RegisterNetEvent("vf_baseapps:setDebugStatus")
AddEventHandler("vf_baseapps:setDebugStatus", function(status)
    IsDebug = status
end)

TriggerServerEvent("vf_baseapps:requestDebugStatus")

TriggerEvent("vf_phone:requestAccess", "vf_baseapps", function(phone)
    TriggerEvent("vf_baseapps:setup", phone)
end)