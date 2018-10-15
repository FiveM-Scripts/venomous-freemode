AddEventHandler("vf_phone:addApp", function(handler)
    if type(handler) == "table" then
        table.insert(Apps, handler)
    end
end)

Citizen.CreateThread(function()
    Wait(100)
    TriggerEvent("vf_phone:setup")
end)