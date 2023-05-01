{% snapshot snp_jakarta_kafka %}

{{
    config(
        target_schema='AIRBYTE_SCHEMA',
        strategy='check',
        unique_key='Weather_Descriptions',
        check_cols='all'
    )
}}

select * from {{ref('stg_jakarta_kafka_alias')}}

{% endsnapshot %}