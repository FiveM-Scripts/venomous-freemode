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

Item = {}

local function _CreateBaseItem(screen, data, callback)
    local id = #screen.Items + 1
    screen.Items[id] = {Data = data, Callback = callback}

    local item = {}
    item.GetID = function() return id end
    item.GetData = function() return data end
    item.GetCallback = function() return callback end
    return item
end

function Item.RemoveItem(app, screen, item, doNotRemoveScreen)
    local itemIndex
    -- Check if screen isn't being used anywhere else
    local removeScreen = not doNotRemoveScreen
    for _, screen in ipairs(app.Screens) do
        for i, screenItem in ipairs(screen.Items) do
            if screenItem == item then
                itemIndex = i

                -- Don't bother continuing if removeScreen is false already
                if not removeScreen then
                    break
                end
            elseif screenItem.Callback == item.Callback then
                removeScreen = false
            end
        end
    end

    -- Remove screen if possible
    if removeScreen then
        table.remove(app.Screens, item.Callback)
    end
    
    -- Remove item
    table.remove(screen.Items, itemIndex)
end

function Item.RemoveItemsInScreen(app, screen)
    for i = #screen.Items, 1, -1 do -- Reverse looping for safe table content removal
        Item.RemoveItem(app, screen, screen.Items[i], true)
    end
end

function Item.AddCallbackItem(screen, data, callback)
    if type(callback) == "table" --[[ What are you doing Msgpack??? ]] or not callback then
        return _CreateBaseItem(screen, data, callback)
    end
end

function Item.AddScreenItem(app, screen, data, callbackScreen)
    if type(callbackScreen) == "table" and type(callbackScreen.GetID) == "table" --[[ Thanks Msgpack ]] and app.Screens[callbackScreen.GetID()] then
        return _CreateBaseItem(screen, data, callbackScreen.GetID())
    end
end