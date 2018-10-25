local _CurrentWeather
local _IsTransitioning

local function _UpdateWeather(newWeather)
    if _CurrentWeather ~= newWeather and not _IsTransitioning then
        _IsTransitioning = true
        SetWeatherTypeOverTime(newWeather, 30.0)
        Wait(60000) -- Wait 2x the transition time to be sure
        SetWeatherTypeNowPersist(newWeather)
        _IsTransitioning = false
        _CurrentWeather = newWeather
    end
end

RegisterNetEvent("vf_sync:syncWeather")
AddEventHandler("vf_sync:syncWeather", function(newWeather)
    _UpdateWeather(newWeather)
end)