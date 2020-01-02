RegisterNetEvent("vf_baseapps:setDebugStatus")
AddEventHandler("vf_baseapps:setDebugStatus", function(status)
    IsDebug = status
end)

TriggerServerEvent("vf_baseapps:requestDebugStatus")