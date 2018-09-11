Citizen.CreateThread(function()
    while true do
        Wait(10000)

        NetworkOverrideClockTime(NetworkGetServerTime())
    end
end)