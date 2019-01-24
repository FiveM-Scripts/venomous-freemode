MissionRuinerMadness = {
    MissionName = "Ruiner Madness"
}
local playerPed
local insurgent2
local destCoords = vector3(-2310.72, 266.46, 169.6)
local destBlip
local spawnEnemyTime

AddTextEntry("m_ruinermadness_task", "Get the Insurgent to the ~y~hideout~w~.")
DecorRegister("m_ruinermadness_entity", 2)
local enemyGroup = AddRelationshipGroup("m_ruinermadness_enemygroup")

local function cleanUpEntities()
    for vehicle in EntityEnum.EnumerateVehicles() do
        if DecorExistOn(vehicle, "m_ruinermadness_entity") then
            DeleteVehicle(vehicle)
        end
    end

    for ped in EntityEnum.EnumeratePeds() do
        if DecorExistOn(ped, "m_ruinermadness_entity") then
            DeletePed(ped)
        end
    end
end

function MissionRuinerMadness.Init()
    cleanUpEntities()

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
    DecorSetBool(insurgent2, "m_ruinermadness_entity", true)
    SetVehicleDoorsLocked(insurgent2, 4)
    SetVehicleEngineOn(insurgent2, true, true)
    SetPedIntoVehicle(playerPed, insurgent2, -1)
    SetVehicleAsNoLongerNeeded(insurgent2)

    SetMaxWantedLevel(0)
    SetWantedLevelMultiplier(0.0)
    TriggerMusicEvent("MP_MC_CMH_SUB_FINALE_START")
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
            playerCoords.x, playerCoords.y, playerCoords.z, 100.0)
        if found then
            local ruiner2Hash = GetHashKey("ruiner2")
            RequestModel(ruiner2Hash)
            while not HasModelLoaded(ruiner2Hash) do
                Wait(10)
            end

            local playerHeading = GetEntityHeading(insurgent2)
            local targetHeading
            if playerHeading < 181 then
                targetHeading = playerHeading + 180
            else
                targetHeading = playerHeading - 180
            end

            local ruiner2 = CreateVehicle(ruiner2Hash, coords.x, coords.y, coords.z, targetHeading, true)
            while not DoesEntityExist(ruiner2) do
                Wait(10)
            end
            
            DecorSetBool(ruiner2, "m_ruinermadness_entity", true)
            SetVehicleDoorsLocked(ruiner2, 4)
            SetVehicleEngineOn(ruiner2, true, true)           
            
            local enemy = CreatePed(4, GetEntityModel(playerPed), coords.x, coords.y, coords.z, 0.0, true)
            DecorSetBool(enemy, "m_ruinermadness_entity", true)
            SetPedRelationshipGroupHash(enemy, "m_ruinermadness_enemygroup")
            SetPedCombatAttributes(enemy, 3, false)
            SetPedCombatAttributes(enemy, 5, true)
            SetPedCombatAttributes(enemy, 46, true)
            SetPedAsEnemy(enemy, true)
            SetPedAiBlip(enemy, true)
            SetPedIntoVehicle(enemy, ruiner2, -1)
            TaskCombatPed(enemy, playerPed, 0, 16)
            SetPedKeepTask(enemy, true)

            local enemy2 = CreatePed(4, GetEntityModel(playerPed), coords.x, coords.y, coords.z, 0.0, true)
            DecorSetBool(enemy2, "m_ruinermadness_entity", true)
            SetPedRelationshipGroupHash(enemy2, "m_ruinermadness_enemygroup")
            SetPedCombatAttributes(enemy2, 3, false)
            SetPedCombatAttributes(enemy2, 5, true)
            SetPedCombatAttributes(enemy2, 46, true)
            SetPedAsEnemy(enemy2, true)
            SetPedAiBlip(enemy2, true)
            SetPedIntoVehicle(enemy2, ruiner2, 0)
            GiveWeaponToPed(enemy2, GetHashKey("WEAPON_APPISTOL"), 999999, false, true)
            SetPedAccuracy(enemy2, 80)
            TaskCombatPed(enemy2, playerPed, 0, 16)
            SetPedKeepTask(enemy2, true)            

            Wait(1400)

            SetVehicleAsNoLongerNeeded(ruiner2)            
            SetPedAsNoLongerNeeded(enemy)
            SetPedAsNoLongerNeeded(enemy2)
        end
        spawnEnemyTime = 15000
    end

    if Vdist2(playerCoords, destCoords) < 5.0 then
        payOut = true
        Missions.Kill()
    else
        if IsPedDeadOrDying(playerPed) then
            payOut = false
            Missions.Kill()
        end
    end
end

function MissionRuinerMadness.Kill()
    cleanUpEntities()
    ClearPrints()
    RemoveBlip(destBlip)

    if payOut then
        TriggerServerEvent('vf_mtest:playercut', GetRandomIntInRange(5000, 20000))
        payOut = false
    end

    if DoesEntityExist(insurgent2) then
        if IsPedInVehicle(playerPed, insurgent2, false) then
            TaskLeaveVehicle(playerPed, insurgent2, 0)
            Wait(3000)
        end
        DeleteEntity(insurgent2)
    end

    SetWantedLevelMultiplier(1.0)
    SetMaxWantedLevel(5)
    TriggerMusicEvent("MP_MC_STOP")
end