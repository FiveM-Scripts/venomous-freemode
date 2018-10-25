Screen = {}

local function _ClearUnusedScreens(appId, screenId)
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

local function _CheckListItemCreatable(name, icon)
    if type(name) == "string" or type(name) == "number" then
        if type(icon) == "number" or not icon then
            return true
        end
    end
end

local function _CreateBaseScreen(appId, header, screenType)
    local id = #Apps[appId].Screens + 1
    Apps[appId].Screens[id] = {Type = screenType, Header = header, Items = {}}

    local screen = {}
    screen.GetID = function() return id end
    screen.GetType = function() return screenType end
    screen.RemoveItem = function(item)
        if type(item) == "table" and type(item.GetID) == "table" --[[ Once again, thanks for that Msgpack ]] and Apps[appId].Screens[id].Items[item.GetID()] then
            table.remove(Apps[appId].Screens[id], item.GetID())
        end
    end
    screen.ClearItems = function() 
        _ClearUnusedScreens(appId, id)
        Apps[appId].Screens[id].Items = {}
    end
    return screen
end

function Screen.CreateListScreen(appId, header)
    local screen = _CreateBaseScreen(appId, header, 13)
    screen.AddCallbackItem = function(name, icon, callback)
        if _CheckListItemCreatable(name, icon) then
            return Item.AddCallbackItem(appId, screen.GetID(), {icon or 0, name}, callback)
        end
    end
    screen.AddScreenItem = function(name, icon, screen)
        if _CheckListItemCreatable(name, icon) then
            return Item.AddScreenItem(appId, screen.GetID(), {icon or 0, name}, screen)
        end
    end
    return screen
end