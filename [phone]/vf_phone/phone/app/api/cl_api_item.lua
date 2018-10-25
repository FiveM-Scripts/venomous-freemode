Item = {}

local function _CreateBaseItem(appId, screenId, data, callback)
    local id = #Apps[appId].Screens[screenId].Items + 1
    Apps[appId].Screens[screenId].Items[id] = {Data = data, Callback = callback}
    print(Apps[appId].Screens[screenId].Items[id].Callback)

    local item = {}
    item.GetID = function() return id end
    item.GetData = function() return data end
    item.GetCallback = function() return callback end
    return item
end

function Item.AddCallbackItem(appId, screenId, data, callback)
    if type(callback) == "table" --[[ What are you doing Msgpack??? ]] or not callback then
        return _CreateBaseItem(appId, screenId, data, callback)
    end
end

function Item.AddScreenItem(appId, screenId, data, callbackScreen)
    if type(callbackScreen) == "table" and type(callbackScreen.GetID) == "table" --[[ Thanks Msgpack ]] and Apps[appId].Screens[callbackScreen.GetID()] then
        return _CreateBaseItem(appId, screenId, data, callbackScreen.GetID())
    end
end