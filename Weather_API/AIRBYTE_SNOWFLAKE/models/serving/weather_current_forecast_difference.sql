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
        {{ref('weather_current_forecast_location')}}
)

select
    (Current_Humidity-Forecasted_Humidity) as Difference_Humidity,
    (Current_Pressure-Forecasted_Pressure) as Difference_Pressure,
    (Current_Temperature-Forecasted_Temperature) as Difference_Temperature,
    (Current_Wind_Direction-Forecasted_Wind_Direction) as Difference_Wind_Direction,
    (Current_Wind_Speed-Forecasted_Wind_Speed) as Difference_Wind_Speed
from
    weather_current_forecast

