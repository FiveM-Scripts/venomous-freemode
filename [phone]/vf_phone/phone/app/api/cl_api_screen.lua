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

Screen = {}

local function _CheckListItemCreatable(name, icon)
    if type(name) == "string" or type(name) == "number" then
        if type(icon) == "number" or not icon then
            return true
        end
    end
end

local function _CreateBaseScreen(app, header, screenType)
    local id = #app.Screens + 1
    app.Screens[id] = {Type = screenType, Header = header, Items = {}}

    local screen = {}
    screen.GetID = function() return id end
    screen.GetType = function() return screenType end
    screen.RemoveItem = function(item)
        if type(item) == "table" and type(item.GetID) == "table" --[[ Once again, thanks for that Msgpack ]] and app.Screens[id].Items[item.GetID()] then
            Item.RemoveItem(app, app.Screens[id], app.Screens[id].Items[item.GetID()])
        end
    end
    screen.ClearItems = function() 
        Item.RemoveItemsInScreen(app, app.Screens[id])
    end
    return screen
end

function Screen.RemoveScreen(app, screen)
    Item.RemoveItemsInScreen(app, screen.GetID())
    table.remove(app.Screens, screen.GetID())
end

function Screen.CreateListScreen(app, header)
    local screen = _CreateBaseScreen(app, header, 22)
    screen.AddCallbackItem = function(name, icon, callback)
        if _CheckListItemCreatable(name, icon) then
            return Item.AddCallbackItem(app.Screens[screen.GetID()], {icon or 0, name}, callback)
        end
    end
    screen.AddScreenItem = function(name, icon, callbackScreen)
        if _CheckListItemCreatable(name, icon) then
            return Item.AddScreenItem(app, app.Screens[screen.GetID()], {icon or 0, name}, callbackScreen)
        end
    end
    return screen
end

function Screen.CreateCustomScreen(app, header, screenType)
    local screen = _CreateBaseScreen(app, header, screenType)
    screen.AddCustomCallbackItem = function(data, callback)
        if type(data) == "table" then
            return Item.AddCallbackItem(app.Screens[screen.GetID()], data, callback)
        end
    end
    screen.AddCustomScreenItem = function(data, callbackScreen)
        if type(data) == "table" then
            return Item.AddScreenItem(app, app.Screens[screen.GetID()], data, callbackScreen)
        end
    end
    return screen
end