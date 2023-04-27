with current_weather as(
    select 
        CloudCover,
        Precipitation,
        Pressure,
        Temperature,
        Wind_Speed,
        FeelsLike,
        Humidity,
        Visibility,
        Weather_Code
    from
        {{ref('stg_jakarta_kafka_alias')}}
)

select
    avg(Cloudcover) as Average_CloudCover,
    avg(Precipitation) as Average_Precipitation,
    avg(Pressure) as Average_Pressure,
    avg(Temperature) as Average_Temperature,
    avg(Wind_Speed) as Average_Wind_Speed,
    avg(FeelsLike) as Average_FeelsLike,
    avg(humidity) as Average_Humidity,
    avg(Visibility) as Average_Visibility,
    avg(Weather_Code) as Average_Weather_Code
from current_weather