{{
    config(
            materialized = "table",
            database = "AIRBYTE_DATABASE",
            schema = "AIRBYTE_SCHEMA"
    )
 }}

select
    country,
    lat,
    Lon,
    Name,
    Region,
    localtime
from
    {{ source("AIRBYTE_SCHEMA","CALIFORNIA_CURRENT_WEATHER_LOCATION") }}