--Singular test based average currency rate greater than 10 with severity "error".

{{
    config(
        severity = 'error'
    )
}}
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
    {{ref('jakarta_kafka_weather_codes_join_min')}}
where
    Min_Temperature > 0