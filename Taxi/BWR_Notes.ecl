IMPORT Taxi;

#WORKUNIT('name', 'Taxi Data: Testing');

taxiData := Taxi.Files.ETL.inFile;

maxFarePerPaymentType := TABLE
    (
        taxiData,
        {
        payment_type,
        DECIMAL8_2  highestAmount := MAX(GROUP, total_amount)
        },
        payment_type
    );

sortedData := SORT(maxFarePerPaymentType, payment_type);

//OUTPUT(sortedData, NAMED('DataSample'));

OUTPUT(sortedData,,Taxi.Files.GROUP_PREFIX + '::sorted_sample',OVERWRITE);
