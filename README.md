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
-- set variables (these need to be uppercase)
set airbyte_role = 'AIRBYTE_ROLE';
set airbyte_username = 'AIRBYTE_USER';
set airbyte_warehouse = 'AIRBYTE_WAREHOUSE';
set airbyte_database = 'AIRBYTE_DATABASE';
set airbyte_schema = 'AIRBYTE_SCHEMA';

```


2. Data Transformation
The datasets are extracted and loaded into the snowflake.The snowflake is loaded with adventure_works datasets with AIRBYTE_DATABASE as Database and AIRBYTE_SCHEMA as  Schema with tables.

##Data Build Tool(DBT):
The loaded datasets on Snowflake are made connection with DBT working environment through updation of profiles.yml

## Steps:
For connection with editor.
Update the profiles.yml file in the dbt with credentials.
airbyte_snowflake:
  outputs:
    dev:
      type: snowflake
      threads: 1
      account:{{Snowflake user account specification}}
      user: AIRBYTE_USER
      password: password
      role: AIRBYTE_ROLE
      warehouse: AIRBYTE_WAREHOUSE
      database: AIRBYTE_DATABASE
      schema: AIRBYTE_SCHEMA
  target: dev

  -- RUN the "dbt deps" command to initiate connection with Snowflake.

  For transformtion process, the aim of the project to get better insights into sales, customer, product and employee table.
  The different transformations applied on the tables and join together to get better quality data.

## Report generation through transformations applied:

-- Insights into the type of currency , average rate for purchase done by customers.
with currency_rate as(
    select tocurrencycode,
    fromcurrencycode,
    currencyrateid,
    averagerate
    from {{ source("AIRBYTE_SCHEMA","currencyrate") }}
),

sales_order_header as(
    select currencyrateid,
    customerid
    from {{ source("AIRBYTE_SCHEMA","salesorderheader") }}
)

select
    c.tocurrencycode,
    c.fromcurrencycode,
    c.currencyrateid,
    c.averagerate,
    s.customerid
from sales_order_header as s
    inner join currency_rate as c
    on s.currencyrateid = c.currencyrateid

 --products classified by customer as count_of_products
{{
    config(
            materialized = "table",
            database = "AIRBYTE_DATABASE",
            schema = "AIRBYTE_SCHEMA"
    )
 }}
with customer_id as(
    select customerid
    from {{ source("AIRBYTE_SCHEMA","customer") }}
),
salesperson_order_header as(
    select customerid,
    salesorderid
    from {{ source("AIRBYTE_SCHEMA","salesorderheader") }}
),
sales_order_detail as(
    select salesorderid,
    productid
    from {{ source("AIRBYTE_SCHEMA","salesorderdetail") }}
)


select
    c.customerid,
    sum(sd.productid) as sum_of_product
from
    customer_id as c
    inner join salesperson_order_header as so
    on c.customerid = so.customerid
    inner join sales_order_detail as sd
    on sd.salesorderid = so.salesorderid
group by c.customerid

-- Products classified by customer as count_of_products
{{
    config(
            materialized = "table",
            database = "AIRBYTE_DATABASE",
            schema = "AIRBYTE_SCHEMA"
    )
 }}
with customer_id as(
    select customerid
    from {{ source("AIRBYTE_SCHEMA","customer") }}
),
salesperson_order_header as(
    select customerid,
    salesorderid
    from {{ source("AIRBYTE_SCHEMA","salesorderheader") }}
),
sales_order_detail as(
    select salesorderid,
    productid
    from {{ source("AIRBYTE_SCHEMA","salesorderdetail") }}
)


select
    c.customerid,
    sum(sd.productid) as sum_of_product
from
    customer_id as c
    inner join salesperson_order_header as so
    on c.customerid = so.customerid
    inner join sales_order_detail as sd
    on sd.salesorderid = so.salesorderid
group by c.customerid

-- salesperson commision on productid
 
 {{
    config(
            materialized = "table",
            database = "AIRBYTE_DATABASE",
            schema = "AIRBYTE_SCHEMA"
    )
 }}
 
with salesperson_commission as(
    select businessentityid,
    commissionpct
    from {{ source("AIRBYTE_SCHEMA","salesperson")}}
),
salesperson_order_header as(
    select salespersonid,
    salesorderid
    from  {{ source("AIRBYTE_SCHEMA","salesorderheader") }}
),
sales_order_detail as(
    select salesorderid,
    productid
    from  {{ source("AIRBYTE_SCHEMA","salesorderdetail") }}
)
SELECT 
    sum(sc.commissionpct) as commission,
    count(sd.productid) as count_of_product,
    sd.salesorderid as sales_order_id,
    {{ salesperson_commission( 'count_of_product' , 'commission') }} as bonus
from
    salesperson_commission as sc
    inner join salesperson_order_header as so
    on sc.businessentityid=so.salespersonid
    inner join sales_order_detail as sd
    on sd.salesorderid = so.salesorderid
group by sc.businessentityid, sd.salesorderid

-- salesperson commision on productid
 
 {{
    config(
            materialized = "table",
            database = "AIRBYTE_DATABASE",
            
            schema = "AIRBYTE_SCHEMA"
    )
 }}
 
with salesperson_commission as(
    select businessentityid,
    commissionpct
    from {{ source("AIRBYTE_SCHEMA","salesperson")}}
),
salesperson_order_header as(
    select salespersonid,
    salesorderid
    from  {{ source("AIRBYTE_SCHEMA","salesorderheader") }}
),
sales_order_detail as(
    select salesorderid,
    productid
    from  {{ source("AIRBYTE_SCHEMA","salesorderdetail") }}
)
SELECT 
    sum(sc.commissionpct) as commission,
    count(sd.productid) as count_of_product,
    sd.salesorderid as sales_order_id,
    {{ salesperson_commission( 'count_of_product' , 'commission') }} as bonus
from
    salesperson_commission as sc
    inner join salesperson_order_header as so
    on sc.businessentityid=so.salespersonid
    inner join sales_order_detail as sd
    on sd.salesorderid = so.salesorderid
group by sc.businessentityid, sd.salesorderid


The various transformations applied are:
(a) count
(b) alias
(c) inner join operation
(d) group by
(e) sum
(f) where
(f) Macro definition

-- Macro function to allocate commission to salesperson based on count of products they have sold.
{% macro salesperson_commission(count_of_product,commission) %}
    case
            when {{ count_of_product }} = 1000 then {{ commission }} * 1.75
            when {{ count_of_product }} = 500 then {{ commission }} * 1.25
            else {{ commission }}
        end
{% endmacro %}
-- Macro to generate schema
{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}
    {%- if custom_schema_name is none -%}

        {{ default_schema }}

    {%- else -%}

        {{ custom_schema_name | trim }}

    {%- endif -%}

{%- endmacro %}

## Incremental Model and Full Refresh
"Salesorderheader" table is specified with Incremental configuration through "modifieddate" column and "salesorderid" as unique key through deduped+history.
Other tables are Full Referesh in nature through each run.

## Data Modelling
In the data modelling technique, source , staging and serving are defined.According, the business context and data dimesion, dimesions and facts tables are defined in the serving folder along with yml documentation by use of surrogate key and natural key. The dimension and facts tables are joined finally to get better knowledge of the sales, customer, product, and employee.

## One big table

One big table is constructed by joining different tables through "db_utils.star" to join the tables.

## DBT Snapshot 
The snapshots tables are created for predefined table through "check" function on all columns and through "timestamp" to check a particular column based on "modified date".

## Slow Changing Dimesion
Dimesion tables are created based on snapshot definition to capture changes occuring through addition of surrogate key as "dbt_valid_to" and "dbt_valid_from".

## DBT tests

Singular and Generic both tests are performed along with built in functions for tests as Null and Unique.
-- For singular tests, by specifying the where clause.
with currency_rate as(
    select tocurrencycode,
    fromcurrencycode,
    currencyrateid,
    averagerate
    from currencyrate
),

sales_order_header as(
    select currencyrateid,
    customerid
    from salesorderheader
)

select
    c.tocurrencycode,
    c.fromcurrencycode,
    c.currencyrateid,
    c.averagerate,
    s.customerid
from sales_order_header as s
    inner join currency_rate as c
    on s.currencyrateid = c.currencyrateid
where
    c.averagerate > 10

-- For generic test, "number_greater_than" test as generalised way to test the column value

{% test number_greater_than(model, column_name, min_num) %}

    select *
    from {{ model }}
    where {{ column_name }} < {{ min_num }}

{% endtest %}

## DockerFile


## Secrets configuration
.env file is defined to hold the secret credential.

## Deployment on Cloud Platform
Installation of Airbyte


## Semantic Analysis through Power BI


