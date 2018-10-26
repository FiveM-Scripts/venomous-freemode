App = {}

function App.CreateApp(name, icon)
    if type(name) == "string" and type(icon) == "number" then
        local id = #Apps + 1
        Apps[id] = {Name = name, Icon = icon, Screens = {}}

        local app = {}
        app.GetID = function() return id end
        app.GetName = function() return name end
        app.GetIcon = function() return icon end
        app.CreateListScreen = function(header)
            if type(header) == "string" or type(header) == "number" or not header then
                return Screen.CreateListScreen(Apps[id], header)
            end
        end
        app.CreateCustomScreen = function(screenType, header)
            if type(screenType) == "number" and (type(header) == "string" or type(header) == "number" or not header) then
                return Screen.CreateCustomScreen(Apps[id], header, screenType)
            end
        end
        app.SetLauncherScreen = function(screen)
            if type(screen) == "table" and type(screen.GetID) == "table" --[[ Wtf Msgpack?!?! ]] and Apps[id].Screens[screen.GetID()] then
                Apps[id].LauncherScreen = Apps[id].Screens[screen.GetID()]
            end
        end
        app.RemoveScreen = function(screen)
            if type(screen) == "table" and type(screen.GetID) == "table" --[[ MsgPack -.- ]] and Apps[id].Screens[screen.GetID()] then
                Screen.RemoveScreen(Apps[id], Apps[id].Screens[screen.GetID()])
            end
        end
        return app
    end
end