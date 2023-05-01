with weather_code as(
    select
        weathercode as Weather_Code,
        Condition as Weather_Condition
    from
        {{ref('weather_codes')}}
)
,min_weather as(
    select
        Min_CloudCover,
        Min_Precipitation,
        Min_Pressure,
        Min_Temperature,
        Min_Wind_Speed,
        Min_FeelsLike,
        Min_Humidity,
        Min_Visibility,
        Min_Weather_Code
    from 
        {{ref('jakarta_kafka_min')}}
)

select
    Min_CloudCover,
    Min_Precipitation,
    Min_Pressure,
    Min_Temperature,
    Min_Wind_Speed,
    Min_FeelsLike,
    Min_Humidity,
    Min_Visibility,
    c.Weather_Code,
    c.Weather_Condition
from
    min_weather as m
    inner join weather_code as c
    on m.Min_Weather_Code=c.Weather_Code