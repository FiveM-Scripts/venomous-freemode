AddEventHandler("vf_phone:addApp", function(handler)
    if type(handler) == "table" then
        table.insert(Apps, handler)
    end
end)

TriggerEvent("vf_phone:setup")