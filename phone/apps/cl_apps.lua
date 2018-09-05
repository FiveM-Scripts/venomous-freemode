Apps = {
    ["main"] = AppMain

}

function Apps.Start(app)
    Apps.CurrentApp = Apps[app]
    if Apps.CurrentApp and Apps.CurrentApp.Init then
        Apps.CurrentApp.Init()
    end
end

function Apps.Kill()
    if Apps.CurrentApp then
        if Apps.CurrentApp == Apps["main"] then
            Apps.CurrentApp = nil
            Phone.Kill()
        else
            Apps.Start("main")
        end
    end
end

Citizen.CreateThread(function()
    while true do
        Wait(0)

        if Apps.CurrentApp and Apps.CurrentApp.Tick then
            Apps.CurrentApp.Tick()
        end
    end
end)