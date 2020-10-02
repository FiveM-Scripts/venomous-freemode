local Phone
local App
local MessagesScreen

RegisterNetEvent("vf_phone:ReceivePlayerMessage")
AddEventHandler("vf_phone:ReceivePlayerMessage", function(playerServer, message)
    while Phone.GetSignalStrength() == 0 do
        Wait(1000)
    end

    local player = GetPlayerFromServerId(playerServer)

    local headshotId = RegisterPedheadshot(GetPlayerPed(player))
    while not IsPedheadshotReady(headshotId) do
        Wait(0)
    end

    local headshotTxd = GetPedheadshotTxdString(headshotId)
    local playerName = GetPlayerName(player)

    if not Phone.IsSleepModeOn() then
        SetNotificationTextEntry("STRING")
        AddTextComponentString(message)
        SetNotificationMessage(headshotTxd, headshotTxd, true, 1, "New Message", playerName)
        DrawNotification(true, true)
        PlaySound(-1, "Text_Arrive_Tone", "Phone_SoundSet_Default")
    end

    local h, m = NetworkGetServerTime()
    local _MessageDetailScreen = App.CreateCustomScreen(7, message.SenderName)

    MessagesScreen.AddCustomScreenItem({h, m, -1, playerName, message}, _MessageDetailScreen)
    _MessageDetailScreen.AddCustomCallbackItem({playerName, message, headshotTxd})
end)

AddEventHandler("vf_baseapps:setup", function(phone)
    Phone = phone
    App = Phone.CreateApp(GetLabelText("CELL_1"), 4)
    MessagesScreen = App.CreateCustomScreen(6)

    App.SetLauncherScreen(MessagesScreen)
end)