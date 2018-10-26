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
    local screen = _CreateBaseScreen(app, header, 13)
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
    screen.AddCallbackItem = function(data, callback)
        if type(data) == "table" then
            return Item.AddCallbackItem(app.Screens[screen.GetID()], data, callback)
        end
    end
    screen.AddScreenItem = function(data, callbackScreen)
        if type(data) == "table" then
            return Item.AddScreenItem(app, app.Screens[screen.GetID()], data, callbackScreen)
        end
    end
    return screen
end