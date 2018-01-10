IMPORT Std;

EXPORT Util := MODULE

    EXPORT WeekDays := DATASET
        (
            [
                {'Sunday'},
                {'Monday'},
                {'Tuesday'},
                {'Wednesday'},
                {'Thursday'},
                {'Friday'},
                {'Saturday'}
            ],
            {STRING9 day_of_week}
        );

    EXPORT HolidayDates := DATASET
       (
           [
               {20150101},
               {20150119},
               {20150216},
               {20150525},
               {20150703},
               {20150907},
               {20151012},
               {20151111},
               {20151126},
               {20151225},
               {20160101},
               {20160118},
               {20160215},
               {20160530}
           ],
           {Std.Date.Date_t holiday}
       );

    EXPORT BoroughBoundingBoxes := DATASET
        (
            [
                {1, 'Bronx', 40.917577, 40.785743, -73.748060, -73.933808},
                {2, 'Brooklyn', 40.739446, 40.551042, -73.833365, -74.056630},
                {3, 'Manhattan', 40.882214, 40.680396, -73.907000, -74.047285},
                {4, 'Queens', 40.812242, 40.489794, -73.700272, -73.833365},
                {5, 'Staten Island', 40.651812, 40.477399 , -74.034547 , -74.259090}
            ],
            {
                UNSIGNED1   id;
                STRING      burroughs_name;
                DECIMAL9_6  n;
                DECIMAL9_6  s;
                DECIMAL9_6  e;
                DECIMAL9_6  w;
            }
        );

    EXPORT PrecipType := DATASET
    (
        [
            {0, ''},
            {1, 'rain'},
            {2, 'snow'}
        ],
        {UNSIGNED1 id, STRING precipType}
    );

END;

    