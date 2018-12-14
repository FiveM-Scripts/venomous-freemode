local _App
local _PlayerListScreen

AddEventHandler("vf_phone:setup", function(phone)
    _App = phone.CreateApp(GetLabelText("CELL_35"), 11)
    _PlayerListScreen = _App.CreateListScreen()
    _App.SetLauncherScreen(_PlayerListScreen)

    Citizen.CreateThread(function()
        local loopApp = _App
        while _App == loopApp do -- Destroy this loop (and coroutine) on vf_phone restart
            Wait(1000)
            _PlayerListScreen.ClearItems()
            for i = 0, 64 do
                if NetworkIsPlayerConnected(i) and (IsDebug or i ~= PlayerId()) then
                    local playerName = GetPlayerName(i)
                    local playerOptionsMenu = _App.CreateListScreen(playerName)
                    _PlayerListScreen.AddScreenItem(playerName, 0, playerOptionsMenu)
                    playerOptionsMenu.AddCallbackItem(GetLabelText("collision_uy2q01"), 0, function()
                        Wait(0) -- Stop from instantly confirming message
                        DisplayOnscreenKeyboard(6, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
                        while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
                            Wait(0)
                        end
                        if UpdateOnscreenKeyboard() == 1 then
                            local message = GetOnscreenKeyboardResult()
                            SetNotificationTextEntry("STRING")
                            if #message == 0 then
                                AddTextComponentString("~r~Message too short!")
                            else
                                TriggerServerEvent("vf_phone:SendPlayerMessage", GetPlayerServerId(i), message)
                                AddTextComponentString("~g~Message sent!")
                            end
                            DrawNotification(true, true)
                        end
                    end)
                end
            end
        end
    end)
end)
