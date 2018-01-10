IMPORT Std;

EXPORT Files := MODULE

    EXPORT PREFIX := 'taxi';
    EXPORT PATH_PREFIX := '~' + PREFIX;
    
    EXPORT GROUP_PREFIX := '~joe';

    //--------------------------------------------------------------------------

    EXPORT Weather := MODULE

        EXPORT FlatWeatherRec := RECORD
            Std.Date.Date_t         date;
            Std.Date.Seconds_t      minutes_after_midnight;
            STRING                  summary;
            UDECIMAL6_3             temperature;
            UDECIMAL6_3             precipIntensity;
            STRING                  precipType;
            UDECIMAL4_2             windSpeed;
            UDECIMAL4_2             visibility;
            UDECIMAL4_2             cloudCover;
        END;

        EXPORT PATH := PATH_PREFIX + '::weather_new_york_city';

        EXPORT inFile := DATASET(PATH, FlatWeatherRec, FLAT);

    END;

    //--------------------------------------------------------------------------

    EXPORT Weather2 := MODULE

        EXPORT FlatWeatherRec := RECORD
            Weather.FlatWeatherRec;
            UNSIGNED1 precipTypeID;
        END;

        EXPORT PATH := GROUP_PREFIX + '::weather_new_york_city_2';

        EXPORT inFile := DATASET(PATH, FlatWeatherRec, FLAT);

    END;

    //--------------------------------------------------------------------------

    EXPORT Raw := MODULE

        EXPORT YellowLayout := RECORD
            STRING  VendorID;
            STRING  tpep_pickup_datetime;
            STRING  tpep_dropoff_datetime;
            STRING  passenger_count;
            STRING  trip_distance;
            STRING  pickup_longitude;
            STRING  pickup_latitude;
            STRING  rate_code_id;
            STRING  store_and_fwd_flag;
            STRING  dropoff_longitude;
            STRING  dropoff_latitude;
            STRING  payment_type;
            STRING  fare_amount;
            STRING  extra;
            STRING  mta_tax;
            STRING  tip_amount;
            STRING  tolls_amount;
            STRING  improvement_surcharge;
            STRING  total_amount;
        END;

        EXPORT PATH := '~{'
            + PREFIX + '::raw::yellow_tripdata_2015-01.csv,'
            + PREFIX + '::raw::yellow_tripdata_2015-02.csv,'
            + PREFIX + '::raw::yellow_tripdata_2015-03.csv,'
            + PREFIX + '::raw::yellow_tripdata_2015-04.csv,'
            + PREFIX + '::raw::yellow_tripdata_2015-05.csv,'
            + PREFIX + '::raw::yellow_tripdata_2015-06.csv,'
            + PREFIX + '::raw::yellow_tripdata_2015-07.csv,'
            + PREFIX + '::raw::yellow_tripdata_2015-08.csv,'
            + PREFIX + '::raw::yellow_tripdata_2015-09.csv,'
            + PREFIX + '::raw::yellow_tripdata_2015-10.csv,'
            + PREFIX + '::raw::yellow_tripdata_2015-11.csv,'
            + PREFIX + '::raw::yellow_tripdata_2015-12.csv,'
            + PREFIX + '::raw::yellow_tripdata_2016-01.csv,'
            + PREFIX + '::raw::yellow_tripdata_2016-02.csv,'
            + PREFIX + '::raw::yellow_tripdata_2016-03.csv,'
            + PREFIX + '::raw::yellow_tripdata_2016-04.csv,'
            + PREFIX + '::raw::yellow_tripdata_2016-05.csv,'
            + PREFIX + '::raw::yellow_tripdata_2016-06.csv'
            + '}';

        EXPORT inFile := DATASET(PATH, YellowLayout, CSV(HEADING(1)));

    END;

    //--------------------------------------------------------------------------

    EXPORT ETL := MODULE

        EXPORT CoercedYellowLayout := RECORD
            UNSIGNED1   VendorID;
            STRING19    tpep_pickup_datetime;
            STRING19    tpep_dropoff_datetime;
            UNSIGNED1   passenger_count;
            DECIMAL10_2 trip_distance;
            DECIMAL9_6  pickup_longitude;
            DECIMAL9_6  pickup_latitude;
            UNSIGNED1   rate_code_id;
            STRING1     store_and_fwd_flag;
            DECIMAL9_6  dropoff_longitude;
            DECIMAL9_6  dropoff_latitude;
            UNSIGNED1   payment_type;
            DECIMAL8_2  fare_amount;
            DECIMAL8_2  extra;
            DECIMAL8_2  mta_tax;
            DECIMAL8_2  tip_amount;
            DECIMAL8_2  tolls_amount;
            DECIMAL8_2  improvement_surcharge;
            DECIMAL8_2  total_amount;
        END;

        EXPORT YellowLayout := RECORD
            UNSIGNED4   record_id;
            CoercedYellowLayout;
        END;

        EXPORT PATH := PATH_PREFIX + '::data';

        EXPORT inFile := DATASET(PATH, YellowLayout, FLAT);

    END;

    EXPORT Validation := MODULE

        EXPORT YellowLayout := RECORD
            ETL.YellowLayout;
            boolean is_good_passenger_count;
            boolean is_valid_vendor_id;
            boolean is_valid_record;
            boolean is_valid_trip_distance;
            boolean is_valid_dropoff_time;
            boolean is_valid_tip_amount;
            boolean is_total_amt_equal_sum;
            boolean is_valid_rate_code_id;
            boolean is_valid_payment_type;
            boolean is_valid_latlong;
        END;

        EXPORT PATH := GROUP_PREFIX + '::validated_data';

        EXPORT inFile := DATASET(PATH, YellowLayout, FLAT);

    END;

    EXPORT Enriched := MODULE

        EXPORT YellowLayout := RECORD
            Validation.YellowLayout;
            Std.Date.Date_t     pickup_date;
            Std.Date.Time_t     pickup_time;
            UNSIGNED4           pickup_minutes_after_midnight;
            UNSIGNED2           pickup_time_window;
            UNSIGNED2           pickup_time_hour; 
            UNSIGNED1           pickup_day_of_week;
            Std.Date.Date_t     dropoff_date;
            Std.Date.Time_t     dropoff_time;
            UNSIGNED4           dropoff_minutes_after_midnight;
            UNSIGNED2           dropoff_time_window;
            UNSIGNED2           dropoff_time_hour; 
            UNSIGNED1           dropoff_day_of_week;
            DECIMAL8_4          trip_duration_minutes;
            UNSIGNED8           trip_distance_bucket;
        END;

        EXPORT PATH := GROUP_PREFIX + '::enriched_data';

        EXPORT inFile := DATASET(PATH, YellowLayout, FLAT);

        EXPORT WeatherAddedLayout := RECORD
            YellowLayout;
            Weather2.FlatWeatherRec weather;
        END;


        //EXPORT PATH := GROUP_PREFIX + '::enriched_data';

        //EXPORT inFile := DATASET(PATH, YellowLayout, FLAT);

    END;

END;
