IMPORT Taxi;
IMPORT Std;

#WORKUNIT('name','Taxi Data: Weather');

weatherData := Taxi.Files.Weather.infile;
precipTypeData := Taxi.Util.PrecipType;

newWeatherData := JOIN
    (
        weatherData,
        precipTypeData,
        LEFT.precipType = RIGHT.precipType,
        TRANSFORM
            (
                Taxi.Files.Weather2.FlatWeatherRec,
                SELF.precipTypeID := RIGHT.id,
                SELF := LEFT
            ),
        LEFT OUTER
    );

//OUTPUT(newWeatherData,,Taxi.Files.Weather2.PATH,OVERWRITE);

taxiData := Taxi.Files.Enriched.infile;

weatherPlusTaxi := JOIN
    (
        taxiData,
        newWeatherData,
        LEFT.pickup_date = RIGHT.date
            AND RIGHT.minutes_after_midnight >= LEFT.pickup_minutes_after_midnight -30
            AND RIGHT.minutes_after_midnight <= LEFT.pickup_minutes_after_midnight +30,
        TRANSFORM
            (
                Taxi.Files.Enriched.WeatherAddedLayout,
                SELF.weather := RIGHT,
                SELF := LEFT,
            ),
        LOOKUP //, LEFT OUTER
    );

precipTypeVsTripDuration := CORRELATION(weatherPlusTaxi, weather.precipTypeID, trip_distance);
OUTPUT(precipTypeVsTripDuration, NAMED('precipTypeVsTripDuration'));

//OUTPUT(weatherPlusTaxi,,Taxi.Files.Weather2.PATH,OVERWRITE);
//OUTPUT(weatherPlusTaxi, NAMED('weatherPlusTaxi'));