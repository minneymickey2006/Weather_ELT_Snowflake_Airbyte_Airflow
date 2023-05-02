--Singular test based average currency rate greater than 10 with severity "error".

{{
    config(
        severity = 'error'
    )
}}
select
    MIN_CLOUDCOVER,
    MIN_PRECIPITATION,
    MIN_PRESSURE,
    MIN_TEMPERATURE,
    MIN_WIND_SPEED,
    MIN_FEELSLIKE,
    MIN_HUMIDITY,
    MIN_VISIBILITY,
    C.WEATHER_CODE,
    C.WEATHER_CONDITION
from
    {{ ref('jakarta_kafka_weather_codes_join_min') }}
where
    MIN_TEMPERATURE > 0
