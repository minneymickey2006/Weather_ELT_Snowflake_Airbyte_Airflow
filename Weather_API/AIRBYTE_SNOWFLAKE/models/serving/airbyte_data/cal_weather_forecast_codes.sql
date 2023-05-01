with weather_forecast as(
    select
    CloudCover,
    FeelsLike,
    Humidity,
    Observation_Time,
    Precip,
    Pressure,
    Temperature,
    UV_Index,
    Visibility,
    Weather_Code,
    Wind_Degree,
    Wind_Dir,
    Wind_Speed,
    _AIRBYTE_CURRENT_HASHID
    from {{ref('stg_weather_forecast_current')}}
)
,w_code as(
    select
        WeatherCode,
        Condition
    from {{ref('weather_codes')}}

)

select
    distinct CloudCover,
    FeelsLike,
    Humidity,
    Observation_Time,
    Precip,
    Pressure,
    Temperature,
    UV_Index,
    Visibility,
    Wind_Degree,
    Wind_Dir,
    Wind_Speed,
    Weather_Code,
    _AIRBYTE_CURRENT_HASHID,
    c.Condition
from
    weather_forecast as w
    inner join w_code as c
    on w.Weather_Code=c.WeatherCode
