-- Average Forecast and Current Updates for a city.
with weather_current_forecast as(
    select
        Current_Humidity,
        Current_Pressure,
        Current_Temperature,
        Current_Wind_Speed,
        Current_Wind_Direction,
        Country,
        Forecasted_Humidity,
        Forecasted_Pressure,
        Forecasted_Temperature,
        Forecasted_Wind_Speed,
        Forecasted_Wind_Direction
    from
        {{ref('cal_weather_current_forecast_location')}}
)

select
    avg(Current_Humidity) as Average_Current_Humidity,
    avg(Forecasted_Humidity) as Average_Forecast_Humidity,
    avg(Current_Temperature) as Average_Current_Temperature,
    avg(Forecasted_Temperature) as Average_Forecasted_Temperature,
    avg(Current_Pressure) as Average_Current_Pressure,
    avg(Forecasted_Pressure) as Average_Forecasted_Pressure,
    avg(Current_Wind_Speed) as Average_Current_Wind_Speed,
    avg(Forecasted_Wind_Speed) as Average_Forecasted_Wind_Speed
from
    weather_current_forecast
    limit 50