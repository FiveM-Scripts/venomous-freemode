Apps = {
    ["Main"] = AppMain,
    AppSettings
}

function Apps.Start(app)
    if Apps[app] then
        if app == "Main" then
            Apps.Kill()
        end
        Apps.CurrentApp = Apps[app]
        if Apps.CurrentApp.Init then
            Apps.CurrentApp.Init(Phone.Scaleform)
        end
    end
end

function Apps.Kill()
    if Apps.CurrentApp then
        if Apps.CurrentApp.Kill then
            Apps.CurrentApp.Kill()
        end
        local lastApp = Apps.CurrentApp
        Apps.CurrentApp = nil

        if lastApp == Apps["Main"] then
            PlaySoundFrontend(-1, "Hang_Up", "Phone_SoundSet_Michael")
            Phone.Kill()
        else
            PlaySoundFrontend(-1, "Menu_Navigate", "Phone_SoundSet_Default")
            Apps.Start("Main")
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