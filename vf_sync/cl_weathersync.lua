local _IsTransitioning

local function _UpdateWeather(weather)
    if not _IsTransitioning then
        _IsTransitioning = true
        SetWeatherTypeOverTime(weather, 30.0)
        Wait(60000) -- Wait 2x the transition time to be sure
        SetWeatherTypeNowPersist(weather)
        _IsTransitioning = false
    end
end

RegisterNetEvent("vf_sync:syncWeather")
AddEventHandler("vf_sync:syncWeather", function(newWeather)
    _UpdateWeather(newWeather)
end)