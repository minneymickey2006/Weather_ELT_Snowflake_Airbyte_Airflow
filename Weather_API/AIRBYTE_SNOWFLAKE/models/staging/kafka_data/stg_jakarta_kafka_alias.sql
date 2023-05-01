select 
    distinct record_content:current:cloudcover as Cloudcover, 
    record_content:current:precip as Precipitation, 
    record_content:current:observation_time as Observation_Time, 
    record_content:current:pressure as Pressure, 
    record_content:current:temperature as Temperature, 
    record_content:current:weather_descriptions as Weather_Descriptions, 
    record_content:current:wind_degree as Wind_Degree, 
    record_content:current:wind_dir as Wind_Direction, 
    record_content:current:wind_speed as Wind_Speed,
    record_content:current:feelslike as FeelsLike,
    record_content:current:humidity as Humidity,
    record_content:current:visibility as Visibility,
    record_content:current:weather_code as Weather_Code
from {{source('AIRBYTE_SCHEMA','TOPIC1')}}