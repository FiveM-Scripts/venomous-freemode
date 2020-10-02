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