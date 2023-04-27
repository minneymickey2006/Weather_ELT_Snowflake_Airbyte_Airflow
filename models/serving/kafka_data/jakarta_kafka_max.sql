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
    max(Cloudcover) as Max_CloudCover,
    max(Precipitation) as Max_Precipitation,
    max(Pressure) as Max_Pressure,
    max(Temperature) as Max_Temperature,
    max(Wind_Speed) as Max_Wind_Speed,
    max(FeelsLike) as Max_FeelsLike,
    max(humidity) as Max_Humidity,
    max(Visibility) as Max_Visibility,
    max(Weather_Code) as Max_Weather_Code
from current_weather