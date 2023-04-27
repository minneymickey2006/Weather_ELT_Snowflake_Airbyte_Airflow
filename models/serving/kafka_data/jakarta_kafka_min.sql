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
    min(CloudCover) as Min_CloudCover,
    min(Precipitation) as Min_Precipitation,
    min(Pressure) as Min_Pressure,
    min(Temperature) as Min_Temperature,
    min(Wind_Speed) as Min_Wind_Speed,
    min(FeelsLike) as Min_FeelsLike,
    min(humidity) as Min_Humidity,
    min(Visibility) as Min_Visibility,
    min(Weather_Code) as Min_Weather_Code
from current_weather