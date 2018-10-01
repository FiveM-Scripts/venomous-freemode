Citizen.CreateThread(function()
    while true do
        Wait(0)

        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        AddTextEntry("mtest_coords", "x:" .. coords.x .. "\ny:" .. coords.y .. "\nz:" .. coords.z .. "\nrot:" .. GetEntityHeading(playerPed))
        DisplayHelpTextThisFrame("mtest_coords")
    end
end)