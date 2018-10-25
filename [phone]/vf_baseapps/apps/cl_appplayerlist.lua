local _App
local _PlayerListScreen

AddEventHandler("vf_phone:setup", function()
    TriggerEvent("vf_phone:CreateApp", GetLabelText("CELL_35"), 11, function(app)
        _App = app
        _PlayerListScreen = _App.CreateListScreen()
        _App.SetLauncherScreen(_PlayerListScreen)
    end)
end)

Citizen.CreateThread(function()
    while true do
        Wait(100)

        if _PlayerListScreen then
            _PlayerListScreen.ClearItems()
            for i = 0, 64 do
                if NetworkIsPlayerConnected(i) then
                    local playerName = GetPlayerName(i)
                    local playerOptionsMenu = _App.CreateListScreen(playerName)
                    _PlayerListScreen.AddScreenItem(playerName, 0, playerOptionsMenu)
                    playerOptionsMenu.AddCallbackItem("Send Message", 0, function() end)
                end
            end
        end
    end
end)