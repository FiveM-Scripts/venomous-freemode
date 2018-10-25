local _WeatherTypes = {
    "CLEAR",
    "EXTRASUNNY",
    "CLOUDS",
    "OVERCAST",
    "RAIN",
    "CLEARING",
    "THUNDER",
    "SMOG",
    "FOGGY"
}
local _CurrentWeather
local _SecondsUntilChange

local function UpdateWeather()
    local prevWeather = _CurrentWeather
    if _CurrentWeather == "THUNDER" then
        _CurrentWeather = "RAIN"
    elseif _CurrentWeather == "RAIN" then
        _CurrentWeather = "CLEARING"
    end

    _CurrentWeather = _WeatherTypes[math.random(1, #_WeatherTypes)]
    if (_CurrentWeather == "THUNDER" or _CurrentWeather == "RAIN") and prevWeather ~= "CLEARING" then
        _CurrentWeather = "CLEARING"
    end
    _SecondsUntilChange = math.random(120, 1800)
end

Citizen.CreateThread(function()
    UpdateWeather()

    while true do
        Wait(1000)

        _SecondsUntilChange = _SecondsUntilChange - 1
        if _SecondsUntilChange == 0 then
            UpdateWeather()
        end
        TriggerClientEvent("vf_sync:syncWeather", -1, _CurrentWeather)
    end
end)