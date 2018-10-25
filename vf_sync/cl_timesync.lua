Citizen.CreateThread(function()
    while true do
        Wait(1000)

        NetworkOverrideClockTime(NetworkGetServerTime())
    end
end)