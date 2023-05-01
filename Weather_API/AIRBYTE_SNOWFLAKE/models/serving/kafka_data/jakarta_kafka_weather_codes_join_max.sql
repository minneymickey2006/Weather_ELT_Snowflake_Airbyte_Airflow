with weather_code as(
    select
        weathercode as Weather_Code,
        Condition as Weather_Condition
    from
        {{ref('weather_codes')}}
)
,max_weather as(
    select
        Max_CloudCover,
        Max_Precipitation,
        Max_Pressure,
        Max_Temperature,
        Max_Wind_Speed,
        Max_FeelsLike,
        Max_Humidity,
        Max_Visibility,
        Max_Weather_Code
    from 
        {{ref('jakarta_kafka_max')}}
)

select
    Max_CloudCover,
    Max_Precipitation,
    Max_Pressure,
    Max_Temperature,
    Max_Wind_Speed,
    Max_FeelsLike,
    Max_Humidity,
    Max_Visibility,
    c.Weather_Code,
    c.Weather_Condition
from
    max_weather as m
    inner join weather_code as c
    on m.Max_Weather_Code=c.Weather_Code