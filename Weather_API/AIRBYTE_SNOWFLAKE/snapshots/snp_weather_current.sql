{% snapshot snp_weather_current %}

{{
    config(
        target_schema='AIRBYTE_SCHEMA',
        strategy='check',
        unique_key='_AIRBYTE_CURRENT_HASHID',
        check_cols='all'
    )
}}

select * from {{ source('AIRBYTE_SCHEMA', 'CALIFORNIA_CURRENT_WEATHER_CURRENT')}}

{% endsnapshot %}