--[[
            vf_utils
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

local HelpTexts = {}

function QueueHelpText(text, duration)
    if type(text) == "string" and type(duration) == "number" then
        table.insert(HelpTexts, { text = text, duration = duration })
    end
end

-- Decrementing
Citizen.CreateThread(function()
    while true do
        if #HelpTexts == 0 then
            Wait(1)
        else
            Wait(1000)
            HelpTexts[1].duration = HelpTexts[1].duration - 1
            if HelpTexts[1].duration == 0 then
                table.remove(HelpTexts, 1)
            end
        end
    end
end)

-- Displaying
Citizen.CreateThread(function()
    while true do
        Wait(1)
        if HelpTexts[1] then
            AddTextEntry("_vf_utils_helptext", HelpTexts[1].text)
            DisplayHelpTextThisFrame("_vf_utils_helptext")
        end
    end
end)