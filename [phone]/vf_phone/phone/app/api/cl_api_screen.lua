Screen = {}

function Screen.CreateListScreen(appId)
    local id = #Apps[appId].Screens + 1
    local screenType = 13
    Apps[appId].Screens[id] = {Type = screenType, Items = {}}

    local Screen = {}
    Screen.GetID = function() return id end
    Screen.GetType = function() return screenType end
    Screen.AddCallbackItem = function(name, icon, callback)
        if type(name) == "string" or type(name) == "number" then
            if not icon then
                icon = 0
            end
            if type(icon) == "number" then
                return Item.AddCallbackItem(appId, id, {icon, name}, callback)
            end
        end
    end
    Screen.AddScreenItem = function(name, icon, screen)
        if type(name) == "string" or type(name) == "number" then
            if not icon then
                icon = 0
            end
            if type(icon) == "number" then
                return Item.AddScreenItem(appId, id, {icon, name}, screen)
            end
        end
    end
    Screen.RemoveItem = function(item)
        if type(item) == "table" and type(item.GetID) == "table" --[[ Once again, thanks for that Msgpack ]] and Apps[appId].Screens[id].Items[item.GetID()] then
            Item.RemoveItem(appId, id, item.GetID())
        end
    end
    Screen.ClearItems = function() Apps[appId].Screens[id].Items = {} end
    return Screen
end