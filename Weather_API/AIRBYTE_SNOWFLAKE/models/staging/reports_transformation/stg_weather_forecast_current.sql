{{
    config(
            materialized = "table",
            database = "AIRBYTE_DATABASE",
            schema = "AIRBYTE_SCHEMA"
    )
 }}

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
from
    {{source("AIRBYTE_SCHEMA","CALIFORNIA_FORECAST_CURRENT")}}