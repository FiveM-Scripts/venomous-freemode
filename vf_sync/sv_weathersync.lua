--[[
            vf_sync
            Copyright (C) 2018-2020  FiveM-Scripts

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program in the file "LICENSE".  If not, see <http://www.gnu.org/licenses/>.
]]

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