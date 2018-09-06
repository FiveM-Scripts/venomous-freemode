Apps = {
    ["Main"] = AppMain,
    AppSettings
}

function Apps.Start(app)
    if Apps[app] then
        Apps.CurrentApp = Apps[app]
        if Apps.CurrentApp.Init then
            Apps.CurrentApp.Init()
        end
    end
end

function Apps.Kill()
    if Apps.CurrentApp then
        if Apps.CurrentApp == Apps["Main"] then
            PlaySoundFrontend(-1, "Hang_Up", "Phone_SoundSet_Michael")
            Apps.CurrentApp = nil
            Phone.Kill()
        else
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