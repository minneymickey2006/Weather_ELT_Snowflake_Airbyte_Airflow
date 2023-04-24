--Joining current weather forecast with 

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
        Wind_Speed
    from {{ref('stg_weather_current')}}
)
,weather_location as(
    select
        country,
        lat,
        Lon,
        Name,
        Region
    from {{ref('stg_weather_current_location')}}
)

select
    c.Humidity,
    c.Pressure,
    c.Temperature,
    c.Wind_Speed,
    c.Wind_Dir,
    l.country,
    l.lat,
    l.lon,
    l.Name,
    l.Region
from weather_current as c
cross join weather_location as l