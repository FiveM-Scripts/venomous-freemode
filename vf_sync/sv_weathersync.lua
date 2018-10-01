local weatherTypes = {
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
local currentWeather
local secondsUntilChange

local function UpdateWeather()
    currentWeather = weatherTypes[math.random(1, #weatherTypes)]
    secondsUntilChange = math.random(60, 1800)
end

Citizen.CreateThread(function()
    UpdateWeather()

    while true do
        Wait(1000)

        secondsUntilChange = secondsUntilChange - 1
        if secondsUntilChange == 0 then
            UpdateWeather()
        end
        TriggerClientEvent("vf_sync:syncWeather", -1, currentWeather)
    end
end)