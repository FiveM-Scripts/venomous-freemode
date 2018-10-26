local _App
local _MessagesScreen

RegisterNetEvent("vf_phone:ReceivePlayerMessage")
AddEventHandler("vf_phone:ReceivePlayerMessage", function(playerServer, message)
    local player = GetPlayerFromServerId(playerServer)
    local headshotId = RegisterPedheadshot(GetPlayerPed(player))
    while not IsPedheadshotReady(headshotId) do
        Wait(0)
    end
    local headshotTxd = GetPedheadshotTxdString(headshotId)
    local playerName = GetPlayerName(player)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    SetNotificationMessage(headshotTxd, headshotTxd, true, 1, "New Message!", playerName)
    DrawNotification(true, true)

    local h, m = NetworkGetServerTime()
    local _MessageDetailScreen = _App.CreateCustomScreen(7, message.SenderName)
    _MessagesScreen.AddCustomScreenItem({h, m, -1, playerName, message}, _MessageDetailScreen)
    _MessageDetailScreen.AddCustomCallbackItem({playerName, message, headshotTxd})
end)

AddEventHandler("vf_phone:setup", function()
    TriggerEvent("vf_phone:CreateApp", GetLabelText("CELL_1"), 4, function(app)
        _App = app
        _MessagesScreen = _App.CreateCustomScreen(6)
        _App.SetLauncherScreen(_MessagesScreen)
    end)
end)