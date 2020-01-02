App = {}

function App.CreateApp(id, name, icon)
    local appId = #Apps + 1
    Apps[appId] = {Id = id, Name = name, Icon = icon, Screens = {}}

    local app = {}
    app.GetID = function() return appId end
    app.GetName = function() return name end
    app.GetIcon = function() return icon end
    app.CreateListScreen = function(header)
        if type(header) == "string" or type(header) == "number" or not header then
            return Screen.CreateListScreen(Apps[appId], header)
        end
    end
    app.CreateCustomScreen = function(screenType, header)
        if type(screenType) == "number" and (type(header) == "string" or type(header) == "number" or not header) then
            return Screen.CreateCustomScreen(Apps[appId], header, screenType)
        end
    end
    app.SetLauncherScreen = function(screen)
        if type(screen) == "table" and type(screen.GetID) == "table" and Apps[appId].Screens[screen.GetID()] then
            Apps[appId].LauncherScreen = Apps[appId].Screens[screen.GetID()]
        end
    end
    app.RemoveScreen = function(screen)
        if type(screen) == "table" and type(screen.GetID) == "table" and Apps[appId].Screens[screen.GetID()] then
            Screen.RemoveScreen(Apps[appId], Apps[appId].Screens[screen.GetID()])
        end
    end
    return app
end