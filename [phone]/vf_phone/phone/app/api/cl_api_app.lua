App = {}

function App.CreateApp(name, icon)
    if type(name) == "string" and type(icon) == "number" then
        local id = #Apps + 1
        Apps[id] = {Name = name, Icon = icon, Screens = {}}

        local App = {}
        App.GetID = function() return id end
        App.GetName = function() return name end
        App.GetIcon = function() return icon end
        App.CreateListScreen = function() return Screen.CreateListScreen(id) end
        App.SetLauncherScreen = function(screen)
            if type(screen) == "table" and type(screen.GetID) == "table" --[[ Wtf Msgpack?!?! ]] and Apps[id].Screens[screen.GetID()] then
                Apps[id].LauncherScreen = Apps[id].Screens[screen.GetID()]
            end
        end
        return App
    end
end