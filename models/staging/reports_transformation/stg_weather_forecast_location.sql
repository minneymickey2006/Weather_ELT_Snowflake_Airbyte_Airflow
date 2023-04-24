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
    _AIRBYTE_CALIFORNIA_FORECAST_HASHID
from
    {{source("AIRBYTE_SCHEMA","CALIFORNIA_FORECAST_LOCATION")}}