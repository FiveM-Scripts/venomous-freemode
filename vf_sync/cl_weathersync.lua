local function UpdateWeather(weather, instantly)
    currentWeather = weather
    if instantly then
        SetWeatherTypeNow(weather)
    else
        SetWeatherTypeOverTime(weather, 30)
    end
end

RegisterNetEvent("vf_sync:syncWeather")
AddEventHandler("vf_sync:syncWeather", function(newWeather)
    UpdateWeather(newWeather, not currentWeather or currentWeather == newWeather)
end)