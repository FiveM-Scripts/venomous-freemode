local _PlayerListScreen

AddEventHandler("vf_phone:setup", function()
    TriggerEvent("vf_phone:CreateApp", GetLabelText("CELL_35"), 11, function(app)
        _PlayerListScreen = app.CreateListScreen()
        app.SetLauncherScreen(_PlayerListScreen)
    end)
end)

Citizen.CreateThread(function()
    while true do
        Wait(100)

        if _PlayerListScreen then
            _PlayerListScreen.ClearItems()
            for i = 0, 64 do
                if NetworkIsPlayerConnected(i) then
                    _PlayerListScreen.AddCallbackItem(GetPlayerName(i), 0)
                end
            end
        end
    end
end)