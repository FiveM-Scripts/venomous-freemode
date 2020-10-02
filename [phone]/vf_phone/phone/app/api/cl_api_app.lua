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

App = {}

function App.CreateApp(id, name, icon)
    local appId = #Apps + 1
    Apps[appId] = {Id = id, Name = name, Icon = icon, Screens = {}}

    local app = {}
    app.GetID = function() return appId end
    app.GetName = function() return name end
    app.GetIcon = function() return icon end
    app.CreateListScreen = function(header)
        if type(header) == "string" or type(header) == "number" or not header then
            return Screen.CreateListScreen(Apps[appId], header)
        end
    end
    app.CreateCustomScreen = function(screenType, header)
        if type(screenType) == "number" and (type(header) == "string" or type(header) == "number" or not header) then
            return Screen.CreateCustomScreen(Apps[appId], header, screenType)
        end
    end
    app.SetLauncherScreen = function(screen)
        if type(screen) == "table" and type(screen.GetID) == "table" and Apps[appId].Screens[screen.GetID()] then
            Apps[appId].LauncherScreen = Apps[appId].Screens[screen.GetID()]
        end
    end
    app.RemoveScreen = function(screen)
        if type(screen) == "table" and type(screen.GetID) == "table" and Apps[appId].Screens[screen.GetID()] then
            Screen.RemoveScreen(Apps[appId], Apps[appId].Screens[screen.GetID()])
        end
    end
    return app
end