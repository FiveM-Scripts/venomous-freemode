Screen = {}

function Screen.CreateListScreen(app)
    local id = #Apps[app].Screens + 1
    local screenType = 13
    Apps[app].Screens[id] = {Type = screenType, Items = {}}

    local Screen = {}
    Screen.GetID = function() return id end
    Screen.GetType = function() return screenType end
    Screen.AddDummyItem = function(name, icon)
        if (type(name) == "string" or type(name) == "number") and type(icon) == "number" then
            return Item.AddCallbackItem(app, id, {icon, name}, function() end)
        end
    end
    Screen.AddCallbackItem = function(name, icon, callback)
        if (type(name) == "string" or type(name) == "number") and type(icon) == "number" then
            return Item.AddCallbackItem(app, id, {icon, name}, callback)
        end
    end
    Screen.AddScreenItem = function(name, icon, screen)
        if (type(name) == "string" or type(name) == "number") and type(icon) == "number" then
            return Item.AddScreenItem(app, id, {icon, name}, screen)
        end
    end
    return Screen
end