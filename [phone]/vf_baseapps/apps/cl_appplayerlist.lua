local App
local PlayerListScreen

AddEventHandler("vf_baseapps:setup", function(phone)
    App = phone.CreateApp(GetLabelText("CELL_35"), 14)
    PlayerListScreen = App.CreateListScreen()
    App.SetLauncherScreen(PlayerListScreen)

    Citizen.CreateThread(function()
        local loopApp = App
        while App == loopApp do -- Destroy this loop (and coroutine) on vf_phone restart
            Wait(1000)
            PlayerListScreen.ClearItems()

            local hasPlayers = false
            for _, player in pairs(GetActivePlayers()) do
                if IsDebug or player ~= PlayerId() then
                    hasPlayers = true

                    local playerName = GetPlayerName(player)
                    local playerOptionsMenu = App.CreateListScreen(playerName)

                    PlayerListScreen.AddScreenItem(playerName, 0, playerOptionsMenu)
                    playerOptionsMenu.AddCallbackItem(GetLabelText("collision_uy2q01"), 0, function()
                        Wait(0) -- Stop from instantly confirming message

                        DisplayOnscreenKeyboard(6, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
                        while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
                            Wait(0)
                        end

                        if UpdateOnscreenKeyboard() == 1 then
                            local message = GetOnscreenKeyboardResult()
                            SetNotificationTextEntry("STRING")
                            if phone.GetSignalStrength() == 0 then
                                AddTextComponentString("~r~No signal!")
                            elseif #message:gsub("%s+", "") == 0 then
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

            if not hasPlayers then
                PlayerListScreen.AddCallbackItem("No Players")
            end
        end
    end)
end)
