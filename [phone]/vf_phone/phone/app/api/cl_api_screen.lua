Screen = {}

function _ClearUnusedScreens(appId, screenId)
    local toBeRemoved = {}
    for _, item in ipairs(Apps[appId].Screens[screenId].Items) do
        if type(item.Callback) == "integer" then -- It's a screen
            table.insert(toBeRemoved, item.Callback)
        end
    end
    -- Check if screen isn't being used anywhere else
    for id, screen in ipairs(Apps[appId].Screens) do
        if id ~= screenId then
            for _, item in ipairs(screen.Items) do
                if type(item.Callback) == "integer" then
                    for i, removeScreenId in ipairs(toBeRemoved) do
                        if removeScreenId == item.Callback then
                            toBeRemoved[i] = nil
                        end
                    end
                end
            end
        end
        -- Remove unused screens (finally)
        for _, removeScreenId in ipairs(toBeRemoved) do
            table.remove(Apps[appId].Screens, removeScreenId)
        end
    end
end

function Screen.CreateListScreen(appId, header)
    local id = #Apps[appId].Screens + 1
    local screenType = 13
    Apps[appId].Screens[id] = {Type = screenType, Header = header, Items = {}}

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
    Screen.ClearItems = function() 
        _ClearUnusedScreens(appId, id)
        Apps[appId].Screens[id].Items = {}
    end
    return Screen
end