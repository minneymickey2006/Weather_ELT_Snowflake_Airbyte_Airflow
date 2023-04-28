{{
    config(
        materialized='incremental',
        unique_key='Observation_Time',
        on_schema_change='fail'
    )
}}

with avg_weather as(
    select
        Average_CloudCover,
        Average_Precipitation,
        Average_Pressure,
        Average_Temperature,
        Average_Wind_Speed,
        Average_FeelsLike,
        Average_Humidity,
        Average_Visibility,
        Average_Weather_Code,
        Last_Observation_Time
from {{ref('jakarta_kafka_average')}}
)
, min_weather as(
    select
        Min_CloudCover,
        Min_Precipitation,
        Min_Pressure,
        Min_Temperature,
        Min_Wind_Speed,
        Min_FeelsLike,
        Min_Humidity,
        Min_Visibility,
        Min_Weather_Code,
        Last_Observation_Time
from {{ref('jakarta_kafka_min')}}
)

, final as (
    select
        {{ dbt_utils.surrogate_key(['avg_weather.Last_Observation_Time'])}} weather_key
        , avg_weather.Average_CloudCover
        , avg_weather.Average_Precipitation
        , avg_weather.Average_Pressure
        , avg_weather.Average_Temperature
        , avg_weather.Average_Wind_Speed
        , avg_weather.Average_FeelsLike
        , avg_weather.Average_Humidity
        , avg_weather.Average_Visibility
        , avg_weather.Average_Weather_Code
        , min_weather.Min_CloudCover
        , min_weather.Min_Precipitation
        , min_weather.Min_Pressure
        , min_weather.Min_Temperature
        , min_weather.Min_Wind_Speed
        , min_weather.Min_FeelsLike
        , min_weather.Min_Humidity
        , min_weather.Min_Visibility
        , min_weather.Min_Weather_Code
    from
        min_weather
        left join
        avg_weather on
        min_weather.Last_Observation_Time = avg_weather.Last_Observation_Time
)

select * from final

{% if is_incremental() %}
    where Last_Observation_Time > (select max(Last_Observation_Time) from {{ this }})
{% endif %}
