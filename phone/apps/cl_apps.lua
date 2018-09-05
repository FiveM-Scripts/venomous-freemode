App = {
    ["main"] = AppMain

}

function App.Start(app)
    App.CurrentApp = App[app]
    if App.CurrentApp and App.CurrentApp.Init then
        App.CurrentApp.Init()
    end
end

function App.Kill()
    if App.CurrentApp then
        if App.CurrentApp == App["main"] then
            App.CurrentApp = nil
            Phone.Kill()
        else
            App.Start("main")
        end
    end
end

Citizen.CreateThread(function()
    while true do
        Wait(0)

        if App.CurrentApp and App.CurrentApp.Tick then
            App.CurrentApp.Tick()
        end
    end
end)