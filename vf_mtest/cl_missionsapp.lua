--[[
            vf_mtest
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

TriggerEvent("vf_phone:requestAccess", "vf_mtest", function(phone)
    local app = phone.CreateApp(GetLabelText("CELL_37"), 14)
    local missionScreen = app.CreateListScreen()
    app.SetLauncherScreen(missionScreen)
    for i, mission in ipairs(Missions) do
        missionScreen.AddCallbackItem(mission.MissionName, 0, function() Missions.Start(i) end)
    end
end)