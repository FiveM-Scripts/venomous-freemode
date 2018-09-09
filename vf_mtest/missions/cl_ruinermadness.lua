MissionRuinerMadness = {}
local playerPed
local insurgent2
local destCoords = vector3(-2310.72, 266.46, 169.6)
local destBlip
local spawnEnemyTime

AddTextEntry("m_ruinermadness_task", "Get the Insurgent to the ~y~hideout~w~.")

function MissionRuinerMadness.Init()
    -- Debugging stuff
    --[[for vehicle in EntityEnum.EnumerateVehicles() do
        DeleteVehicle(vehicle)
    end
    for ped in EntityEnum.EnumeratePeds() do
        if not IsPedAPlayer(ped) then
            DeletePed(ped)
        end
    end]]--

    playerPed = PlayerPedId()
    destBlip = AddBlipForCoord(destCoords)
    SetBlipRoute(destBlip, true)
    spawnEnemyTime = 1000

    local insurgent2Hash = GetHashKey("insurgent2")
    RequestModel(insurgent2Hash)
    while not HasModelLoaded(insurgent2Hash) do
        Wait(0)
    end
    insurgent2 = CreateVehicle(insurgent2Hash, 2796.07, -707.95, 4.12, 101.43, true)
    SetModelAsNoLongerNeeded(insurgent2)
    SetVehicleDoorsLocked(insurgent2, 4)
    SetPedIntoVehicle(playerPed, insurgent2, -1)
    SetVehicleAsNoLongerNeeded(insurgent2)

    SetMaxWantedLevel(0)
    TriggerMusicEvent("MP_MC_CMH_IAA_PREP_START")
    TriggerMusicEvent("MP_MC_CMH_VEHICLE_CHASE")
end

function MissionRuinerMadness.Tick()
    DrawMarker(6, destCoords, 0.0, 0.0, 90.0, 0.0, 0.0, 0.0, 2.0, 2.0, 2.0, 0, 0, 255, 255)
    
    BeginTextCommandPrint("m_ruinermadness_task")
    EndTextCommandPrint(0.1, true)

    local playerCoords = GetEntityCoords(playerPed)
    spawnEnemyTime = spawnEnemyTime - 100
    if spawnEnemyTime <= 0 then
        local found, coords = FindSpawnPointInDirection(playerCoords.x, playerCoords.y, playerCoords.z,
            playerCoords.x, playerCoords.y, playerCoords.z, 150.0)
        if found then
            local ruiner2Hash = GetHashKey("ruiner2")
            RequestModel(ruiner2Hash)
            while not HasModelLoaded(ruiner2Hash) do
                Wait(0)
            end
            local ruiner2 = CreateVehicle(ruiner2Hash, coords.x, coords.y, coords.z, GetEntityHeading(playerPed), true)
            SetModelAsNoLongerNeeded(ruiner2Hash)
            SetVehicleDoorsLocked(ruiner2, 4)
            SetVehicleAsNoLongerNeeded(ruiner2)
            local enemy = CreatePed(4, GetEntityModel(playerPed), coords.x, coords.y, coords.z, 0.0, true)
            SetPedAsEnemy(enemy, true)
            SetPedAiBlip(enemy, true)
            SetPedIntoVehicle(enemy, ruiner2, -1)
            TaskVehicleChase(enemy, playerPed)
            SetPedKeepTask(enemy, true)
            SetPedAsNoLongerNeeded(enemy)
        end
        spawnEnemyTime = 20000
    end

    if Vdist2(playerCoords, destCoords) < 5.0 or IsPedDeadOrDying(playerPed) then
        Missions.Kill()
    end
end

function MissionRuinerMadness.Kill()
    DeleteVehicle(insurgent2)
    RemoveBlip(destBlip)

    SetMaxWantedLevel(5)
    TriggerMusicEvent("MP_MC_STOP")
end