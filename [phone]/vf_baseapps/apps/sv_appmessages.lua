RegisterServerEvent("vf_phone:SendPlayerMessage")
AddEventHandler("vf_phone:SendPlayerMessage", function(player, message)
    if type(player) == "number" and type(message) == "string" and messages ~= "" then
        TriggerClientEvent("vf_phone:ReceivePlayerMessage", player, source, message)
    end
end)