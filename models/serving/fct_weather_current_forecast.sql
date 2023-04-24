with weather_current as(
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
    from {{ref('stg_weather_current')}}
)
,weather_location as(
    select
        country,
        lat,
        Lon,
        Name,
        Region,
        _AIRBYTE_CALIFORNIA_CURRENT_WEATHER_HASHID
    from {{ref('stg_weather_current_location')}}
)

, final as (
    select
        {{ dbt_utils.surrogate_key(['weather_current._AIRBYTE_CURRENT_HASHID'])}} weather_key
        ,{{dbt_utils.surrogate_key(['_AIRBYTE_CALIFORNIA_CURRENT_WEATHER_HASHID'])}} as weather_location_key
        , weather_current.CloudCover
        , weather_current.FeelsLike
        , weather_current.Pressure
        , weather_current.UV_Index
        , weather_current.Wind_Degree
        , weather_current.Wind_Dir
        , weather_current.Wind_Speed
        , country
        , lat
        , lon
        , Name
        , Region
    from weather_current
    cross join weather_location
)
select *
from final