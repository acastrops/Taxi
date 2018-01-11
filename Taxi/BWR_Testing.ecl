IMPORT Taxi;

#WORKUNIT('name', 'Taxi Data: Testing');

taxiData := Taxi.Files.ETL.inFile;

Taxi.Files.Validation.YellowLayout MakeValidationRec(Taxi.Files.ETL.YellowLayout inRec) := TRANSFORM
    SELF.is_good_passenger_count := inRec.passenger_count > 0;
    SELF.is_valid_vendor_id := inRec.VendorID IN [1, 2];
    SELF.is_valid_trip_distance := inRec.trip_distance > 0 
                                        AND inRec.rate_code_id <> 5 
                                        AND inRec.trip_distance < 100;
    SELF.is_valid_dropoff_time := inRec.tpep_dropoff_datetime > inRec.tpep_pickup_datetime;
    SELF.is_valid_tip_amount := inRec.tip_amount > 0 AND inRec.payment_type = 1;
    SELF.is_valid_latlong :=        inRec.pickup_latitude BETWEEN 40 AND 45
                                AND inRec.pickup_longitude BETWEEN -80 AND -70
                                AND inRec.dropoff_latitude BETWEEN 40 AND 45
                                AND inRec.dropoff_longitude BETWEEN -80 AND -70;
    SELF.is_valid_rate_code_id := inRec.rate_code_id IN [1, 2, 3, 4, 5, 6];
    SELF.is_valid_payment_type := inRec.payment_type IN [1, 2, 3, 4, 5, 6];
    SELF.is_total_amt_equal_sum := inRec.total_amount = inRec.fare_amount + inRec.extra + inRec.mta_tax 
                                    + inRec.tip_amount + inRec.tolls_amount + inRec.improvement_surcharge;
    SELF.is_valid_record := SELF.is_good_passenger_count
                                AND SELF.is_valid_vendor_id
                                AND SELF.is_valid_trip_distance
                                AND SELF.is_valid_dropoff_time
                                AND SELF.is_valid_tip_amount
                                AND SELF.is_valid_latlong
                                AND SELF.is_valid_rate_code_id
                                AND SELF.is_valid_payment_type
                                AND SELF.is_total_amt_equal_sum;
    SELF := inRec;
END;

validatedData := PROJECT
    (
        taxiData,
        MakeValidationRec(LEFT)

    );

//OUTPUT(validatedData, NAMED('validatedData'));
OUTPUT(validatedData,,Taxi.Files.GROUP_PREFIX + '::validated_data', OVERWRITE, COMPRESSED);
