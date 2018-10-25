Item = {}

function Item.AddCallbackItem(appId, screenId, data, callback)
    if type(callback) == "table" --[[ What are you doing Msgpack??? ]] or not callback then
        local id = #Apps[appId].Screens[screenId].Items + 1
        Apps[appId].Screens[screenId].Items[id] = {Data = data, Callback = callback}

        local Item = {}
        Item.GetID = function() return id end
        Item.GetData = function() return data end
        Item.GetCallback = function() return callback end
        return Item
    end
end

function Item.AddScreenItem(appId, screenId, data, callbackScreen)
    if type(callbackScreen) == "table" and type(callbackScreen.GetID) == "table" --[[ Thanks Msgpack ]] and Apps[appId].Screens[callbackScreen.GetID()] then
        local id = #Apps[appId].Screens[screenId].Items + 1
        Apps[appId].Screens[screenId].Items[id] = {Data = data, Callback = callbackScreen.GetID()}

        local Item = {}
        Item.GetID = function() return id end
        Item.GetData = function() return data end
        Item.GetCallback = function() return callbackScreen end
        return Item
    end
end

function Item.RemoveItem(appId, screenId, itemId)
    table.remove(Apps[appId].Screens[screenId], itemId)
end