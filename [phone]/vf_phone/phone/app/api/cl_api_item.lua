Item = {}

function Item.AddCallbackItem(app, screen, data, callback)
    if type(callback) == "function" then
        local id = #Apps[app].Screens[screen].Items + 1
        Apps[app].Screens[screen].Items[id] = {Data = data, Callback = callback}

        local Item = {}
        Item.GetID = function() return id end
        Item.GetData = function() return data end
        Item.GetCallback = function() return callback end
        return Item
    end
end

function Item.AddScreenItem(app, screen, data, callbackScreen)
    if type(callbackScreen) == "table" and type(callbackScreen.GetID) == "function" and Apps[app].Screens[callbackScreen.GetID()] then
        local id = #Apps[app].Screens[screen].Items + 1
        Apps[app].Screens[screen].Items[id] = {Data = data, Callback = callbackScreen.GetID()}

        local Item = {}
        Item.GetID = function() return id end
        Item.GetData = function() return data end
        Item.GetCallback = function() return callbackScreen end
        return Item
    end
end