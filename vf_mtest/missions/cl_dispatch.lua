MissionDispatch = {
    MissionName = "Dispatch"
}

local vehicleHash = "jackal"
local pilotHash = "s_m_m_pilot_01"
local destCoords = vector3(-970.926, -2992.305, 15.114)

local playerPed
local missionVeh
local destBlip
local missionStage
local SpawnedEnemies = false

DecorRegister("m_dispatch_entity", 2)

local enemyGroup = AddRelationshipGroup("m_dispatch_enemygroup")
SetRelationshipBetweenGroups(5, GetHashKey("m_dispatch_enemygroup"), GetHashKey("PLAYER"))
SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), GetHashKey("m_dispatch_enemygroup"))

local function CreateTargetVehicle(model, x, y, z, rot)
    local modelHash = tostring(model)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(0)
    end

    RequestModel(pilotHash)
    while not HasModelLoaded(pilotHash) do
        Wait(1)
    end

    local vehicle = CreateVehicle(modelHash, x, y, z, rot, true, false)
    while not DoesEntityExist(vehicle) do
        Wait(0)
    end

    ped = CreatePedInsideVehicle(vehicle, 4, pilotHash, -1, true, false)
    SetPedCombatAttributes(ped, 1, true)
    SetPedCombatAttributes(ped, 3, false)

    SetVehicleDoorsLocked(vehicle, 4)
    SetModelAsNoLongerNeeded(modelHash)
    return vehicle
end

local function CreateTarget(vehicle)
    local enemyHash = "g_m_y_mexgoon_03"

    RequestModel(enemyHash)
    while not HasModelLoaded(enemyHash) do
        Wait(1)
    end

    local enemy = CreatePedInsideVehicle(vehicle, 4, enemyHash, 2, true, false)
    SetModelAsNoLongerNeeded(enemyHash)

    return enemy
end

local function CreateEnemyPeds()
    local model = "s_m_y_armymech_01"
    local coords = {
        {x= -942.873, y= -3013.884, z= 19.840},
        {x= -940.438, y= -3009.616, z= 19.840},
        {x= -926.262, y= -2986.001, z= 19.8454},
        {x= -940.712, y= -2963.358, z= 19.845},
        {x= -957.780, y= -2968.714, z= 13.945},
        {x= -957.618, y= -2977.616, z= 13.945},
        {x= -973.362, y= -3005.380, z= 13.945},
        {x= -980.943, y= -3014.230, z= 13.945},
        {x= -997.327, y= -3022.456, z= 13.945}
    }

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end

    for k,v in pairs(coords) do
        enemy = CreatePed(4, model, v.x, v.y, v.z, 0.0, true, false)
        GiveWeaponToPed(enemy, "WEAPON_MARKSMANRIFLE", -1, false, true)
        DecorSetBool(enemy, "m_dispatch_entity", true)
        
        SetPedCombatAttributes(enemy, 3, false)
        SetPedCombatAttributes(enemy, 5, true)
        SetPedCombatAttributes(enemy, 46, true)

        SetPedRelationshipGroupHash(enemy, "m_dispatch_enemygroup")
        SetPedAiBlip(enemy, true)
    end

    SetModelAsNoLongerNeeded(model)
end

local function cleanUpEntities()
    for vehicle in EntityEnum.EnumerateVehicles() do
        if DecorExistOn(vehicle, "m_dispatch_entity") then
            DeleteVehicle(vehicle)
        end
    end

    for ped in EntityEnum.EnumeratePeds() do
        if DecorExistOn(ped, "m_dispatch_entity") then
            DeletePed(ped)
        end
    end
end

function MissionDispatch.Init()
    cleanUpEntities()
    playerPed = PlayerPedId()
    destBlip = AddBlipForCoord(destCoords)
    SetBlipRoute(destBlip, true)

    if IsModelValid(vehicleHash) then
        RequestModel(vehicleHash)
        while not HasModelLoaded(vehicleHash) do
            Wait(0)
        end

        missionVeh = CreateVehicle(vehicleHash, -1021.7688, 693.375, 160.896, 359.050, true, false)
        DecorSetBool(missionVeh, "m_dispatch_entity", true)
        SetVehicleEngineOn(missionVeh, true, true)

        SetPedIntoVehicle(playerPed, missionVeh, -1)
        SetVehicleHasBeenOwnedByPlayer(missionVeh, true)
        SetMaxWantedLevel(0)
        SetVehicleRadioEnabled(playerPed, false)
        SetModelAsNoLongerNeeded(vehicleHash)

        TriggerMusicEvent("MP_MC_CMH_SILO_PREP_START")
        TriggerMusicEvent("MP_MC_CMH_ACTION")
        missionStage = 1
    end
end

function MissionDispatch.Tick()
    local playerCoords = GetEntityCoords(playerPed)
    
    if IsEntityInZone(PlayerPedId(), "AIRP") then
        if not SpawnedEnemies then
            CreateEnemyPeds()
            if not DoesEntityExist(vehicle) then
                vehicle = CreateTargetVehicle("miljet", -970.926, -2992.305, 15.114, 58.565)
                ped = CreateTarget(vehicle)
            end

            SpawnedEnemies = true
        end
        
        if DoesEntityExist(vehicle) then
            if IsEntityDead(vehicle) then
                ClearPrints()
                BeginTextCommandPrint("GR_LEAVE_AREAA")
                EndTextCommandPrint(0.1, true)

                if DoesBlipExist(destBlip) then
                    RemoveBlip(destBlip)
                end

                SetPlayerWantedLevel(PlayerId(), 3, true)
                SetPlayerWantedLevelNow(PlayerId(), true)

                missionStage = 2
            else
                ClearPrints()
                BeginTextCommandPrint("SMOT_DESTROY")
                AddTextComponentSubstringTextLabel("FM_GDM_BLP")
                EndTextCommandPrint(0.1, true)
            end
        end
    else
        if missionStage == 1 then
            ClearPrints()
            BeginTextCommandPrint("BRS_GO_SETUPA")
            AddTextComponentSubstringTextLabel("BRS_MCL_0")
            EndTextCommandPrint(0.1, true)
        elseif missionStage == 2 then
            if IsPlayerWantedLevelGreater(PlayerId(), 0) then
                ClearPrints()
                BeginTextCommandPrint("FM_IHELP_LCP")
                EndTextCommandPrint(0.1, true)
            else
                payOut = true
                Missions.Kill()
            end
        end
    end

    if IsPedDeadOrDying(playerPed) then
        Missions.Kill()
    end
end

function MissionDispatch.Kill()
    cleanUpEntities()

    if DoesBlipExist(destBlip) then
        RemoveBlip(destBlip)
    end

    if DoesEntityExist(vehicle) then
        DeleteVehicle(vehicle)
    end

    if payOut then
        TriggerServerEvent('vf_mtest:playercut', GetRandomIntInRange(5000, 20000))
        payOut = false
    end
    
    ClearPrints()
    SetMaxWantedLevel(5)
    TriggerMusicEvent("MP_MC_STOP")

    SetPlayerWantedLevel(PlayerId(), 0, false)
    SetPlayerWantedLevelNow(PlayerPedId(), true)

    missionStage = 0
    SpawnedEnemies = false
end
