with weather_code as(
    select
        weathercode as Weather_Code,
        Condition as Weather_Condition
    from
        {{ref('weather_codes')}}
)
,avg_weather as(
    select
        Average_CloudCover,
        Average_Precipitation,
        Average_Pressure,
        Average_Temperature,
        Average_Wind_Speed,
        Average_FeelsLike,
        Average_Humidity,
        Average_Visibility,
        Average_Weather_Code
    from 
        {{ref('jakarta_kafka_average')}}
)

select
    Average_CloudCover,
    Average_Precipitation,
    Average_Pressure,
    Average_Temperature,
    Average_Wind_Speed,
    Average_FeelsLike,
    Average_Humidity,
    Average_Visibility,
    c.Weather_Code,
    c.Weather_Condition
from
    avg_weather as m
    inner join weather_code as c
    on m.Average_Weather_Code=c.Weather_Code