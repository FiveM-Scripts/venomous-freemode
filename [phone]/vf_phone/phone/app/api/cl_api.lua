--[[
            vf_phone
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

--[[
function GetAppIcons()
    return {
        ["APP_CAMERA"] = 1,
        ["APP_CHAT"] = 2,
        ["APP_EMPTY"] = 3,
        ["APP_MESSAGING"] = 4,
        ["APP_CONTACTS"] = 5,
        ["APP_INTERNET"] = 6,
        ["APP_CONTACTS_PLUS"] = 11,
        ["APP_TASKS"] = 12,
        ["APP_GROUP"] = 14,
        ["APP_SETTINGS"] = 24,
        ["APP_WARNING"] = 27,
        ["APP_GAMES"] = 35,
        ["APP_RIGHT_ARROW"] = 38,
        ["APP_TASKS_2"] = 39,
        ["APP_TARGET"] = 40,
        ["APP_TRACKIFY"] = 42,
        ["APP_CLOUD"] = 43,
        ["APP_BROADCAST"] = 49,
        ["APP_VLSI"] = 54,
        ["APP_BENNYS"] = 56,
        ["APP_SECUROSERV"] = 57,
        ["APP_COORDS"] = 58,
        ["APP_RSS"] = 59
    }
end
]]--

--[[Citizen.CreateThread(function()
    while not NetworkIsGameInProgress() or not IsPlayerPlaying(PlayerId()) do
        Wait(1)
    end
    local phone = {}
    phone.IsSleepModeOn = function() return Phone.SleepMode end
    phone.CreateApp = function(name, icon)
        if type(name) == "string" and type(icon) == "number" then
            return App.CreateApp(name, icon)
        end
    end
    TriggerEvent("vf_phone:setup", phone)
end)]]--

RegisterNetEvent("vf_phone:requestAccess")
AddEventHandler("vf_phone:requestAccess", function(id, cb)
    if type(id) == "string" and type(cb) == "table" then
        local phone = {}
        phone.IsSleepModeOn = function() return Phone.SleepMode end
        phone.GetSignalStrength = function() return Phone.SignalStrength end
        phone.CreateApp = function(name, icon)
            if type(name) == "string" and type(icon) == "number" then
                return App.CreateApp(id, name, icon)
            end
        end

        for i=#Apps, 1, -1 do
            if Apps[i].Id == id then
                table.remove(Apps, i)
            end
        end

        cb(phone)
    end
end)