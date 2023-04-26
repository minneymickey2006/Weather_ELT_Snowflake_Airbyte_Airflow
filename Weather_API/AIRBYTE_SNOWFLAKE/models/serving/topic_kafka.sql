select 
   distinct(record_content:current:location:localtime_epoch, record_content:current:location:lat, record_content:current:location:lon) as kafka_data
from {{source('AIRBYTE_SCHEMA','TOPIC1')}}