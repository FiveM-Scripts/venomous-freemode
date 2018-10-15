AddEventHandler("vf_phone:addApp", function(handler)
    if type(handler) == "table" then
        table.insert(Apps, handler)
    end
end)

Citizen.CreateThread(function()
    while not NetworkIsGameInProgress() or not IsPlayerPlaying(PlayerId()) do
        Wait(1)
    end
    TriggerEvent("vf_phone:setup")
end)