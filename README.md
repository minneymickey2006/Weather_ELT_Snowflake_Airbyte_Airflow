# Weatherstack
To provide meaningful insights to weather changes based on different parameters such as humidity, temperature and wind speed.

# Workflow
Extraction of datasets
The datasets are extracted from https://weatherstack.com/documentation.

Airbyte is used to connect to API.
For Destination, the airbyte is destined to deliever the source dataset to Snowflake through running of commands to access the Snowflake.

## Setup Steps
1. Set up Airbyte-specific entities in Snowflake
```sql
-- set variables (these need to be uppercase)
set airbyte_role = 'AIRBYTE_ROLE';
set airbyte_username = 'AIRBYTE_USER';
set airbyte_warehouse = 'AIRBYTE_WAREHOUSE';
set airbyte_database = 'AIRBYTE_DATABASE';
set airbyte_schema = 'AIRBYTE_SCHEMA';

-- set user password
set airbyte_password = 'password';

begin;

-- create Airbyte role
use role securityadmin;
create role if not exists identifier($airbyte_role);
grant role identifier($airbyte_role) to role SYSADMIN;

-- create Airbyte user
create user if not exists identifier($airbyte_username)
password = $airbyte_password
default_role = $airbyte_role
default_warehouse = $airbyte_warehouse;

grant role identifier($airbyte_role) to user identifier($airbyte_username);

-- change role to sysadmin for warehouse / database steps
use role sysadmin;

-- create Airbyte warehouse
create warehouse if not exists identifier($airbyte_warehouse)
warehouse_size = xsmall
warehouse_type = standard
auto_suspend = 60
auto_resume = true
initially_suspended = true;

-- create Airbyte database
create database if not exists identifier($airbyte_database);

-- grant Airbyte warehouse access
grant USAGE
on warehouse identifier($airbyte_warehouse)
to role identifier($airbyte_role);

-- grant Airbyte database access
grant OWNERSHIP
on database identifier($airbyte_database)
to role identifier($airbyte_role);

commit;

begin;

USE DATABASE identifier($airbyte_database);

-- create schema for Airbyte data
CREATE SCHEMA IF NOT EXISTS identifier($airbyte_schema);

commit;

begin;

-- grant Airbyte schema access
grant OWNERSHIP
on schema identifier($airbyte_schema)
to role identifier($airbyte_role);

commit;
```

2. To create user for the connection to Kafka
```sql
--create user and role
CREATE USER confluent2 RSA_PUBLIC_KEY='MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA1V+WROjik7v1oDRJxHa0Tl7ejtKm4SjuJ2qBiHKq06ja5mR977xmWorjeqNPLJ5Qkxwa+PDW6iXUTmZXyo/y7XCP/LXvYf1d4wphEU/PVLygnneqQAoVck09eiHSl/dgFNKbYlT3w+ko1Su+iZwYo7k2HonI4845hlUhe0MwoA3d2biwSMdWS5/WSOoxCUpYj/+kzKURLu4GmkJftpriYhNnLPnUrS6bUhfF8XJS0qa+AvVv/J96W5gIhXP3FFDGePjtrS+4bGAg/rpGu0w+X/7oVGNjo35cKO0R78mmk7c431pU3QHAvQZTgemSVaG6QFnRnC47uaulbWBIwjFT/QIDAQAB';
create role kafka_connector_role2;

--grant usage
grant usage on database AIRBYTE_DATABASE to role kafka_connector_role2;AIRBYTE_DATABASE.AIRBYTE_SCHEMA.WEATHERSTACK_CURRENT_WEATHER_CURRENT
grant usage on schema AIRBYTE_DATABASE.AIRBYTE_SCHEMA to role kafka_connector_role2;
grant create table on schema AIRBYTE_DATABASE.AIRBYTE_SCHEMA to role kafka_connector_role2;
grant create stage on schema AIRBYTE_DATABASE.AIRBYTE_SCHEMA to role kafka_connector_role2;
grant create pipe on schema AIRBYTE_DATABASE.AIRBYTE_SCHEMA to role kafka_connector_role2;

--grant role
grant role kafka_connector_role2 to user confluent2;
grant role kafka_connector_role2 to role ACCOUNTADMIN;

--alter user
alter user confluent2 set default_role=kafka_connector_role2;

```


2. Data Transformation
The datasets are extracted and loaded into the snowflake.The snowflake is loaded with adventure_works datasets with AIRBYTE_DATABASE as Database and AIRBYTE_SCHEMA as  Schema with tables.

##Data Build Tool(DBT):
The loaded datasets on Snowflake are made connection with DBT working environment through updation of profiles.yml

## Steps:


## DockerFile


## Secrets configuration
.env file is defined to hold the secret credential.

## Deployment on Cloud Platform
Installation of Airbyte


## Semantic Analysis through Power BI


