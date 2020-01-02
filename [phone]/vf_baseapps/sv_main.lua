local _IsDebug = GetConvarInt("vf_phone_baseapps_debug", 0) ~= 0

RegisterServerEvent("vf_baseapps:requestDebugStatus")
AddEventHandler("vf_baseapps:requestDebugStatus", function()
    TriggerClientEvent("vf_baseapps:setDebugStatus", source, _IsDebug)
end)