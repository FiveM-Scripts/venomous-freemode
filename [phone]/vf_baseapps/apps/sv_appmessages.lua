RegisterServerEvent("vf_phone:SendPlayerMessage")
AddEventHandler("vf_phone:SendPlayerMessage", function(player, message)
    if type(player) == "number" and type(message) == "string" then
        local length = #message:gsub("%s+", "")

        if length > 0 and length < 61 then
            TriggerClientEvent("vf_phone:ReceivePlayerMessage", player, source, message)
        end
    end
end)