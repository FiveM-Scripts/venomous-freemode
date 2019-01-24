MissionSnitch = {
    MissionName = "Snitch"
}

local vehicleHash = "oracle"
local destCoords = vector3(417.02288, -978.1325, 29.4316)

local playerPed
local missionVeh
local destBlip
local targetBlip
local missionStage
local SpawnedEnemies = false

DecorRegister("m_snitch_entity", 2)

local function notify(icon, type, sender, title, text, color)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    SetNotificationBackgroundColor(color)
    SetNotificationMessage(icon, icon, true, type, sender, title, text)
    DrawNotification(false, true)
    PlaySoundFrontend(GetSoundId(), "Text_Arrive_Tone", "Phone_SoundSet_Default", true)
end


local function CreateTarget(x,y,z, heading)
    local enemyHash = "g_m_y_mexgoon_03"

    RequestModel(enemyHash)
    while not HasModelLoaded(enemyHash) do
        Wait(1)
    end

    local enemy = CreatePed(4, enemyHash, x, y, z, heading, true, false)

    targetBlip = AddBlipForEntity(enemy)
    SetBlipNameFromTextFile(targetBlip, "BLIP_177")

    SetModelAsNoLongerNeeded(enemyHash)
    TaskStartScenarioInPlace(enemy, "CODE_HUMAN_STAND_COWER", 0, 1)

    return enemy
end

local function CreateEnemyPeds()
    local model = "s_m_y_cop_01"
    local coords = {
        {x= 434.4309, y= -984.01843, z= 30.7104, r= 93.3602},
        {x= 434.2117, y= -979.6658,  z=30.70932, r= 93.3602},
        {x= 444.538,  y= -988.5620,  z= 30.6895, r=0.0},
        {x= 452.6411, y= -986.4833,  z= 30.6895, r=0.0},
        {x= 464.209,  y= -987.00140, z= 25.3476, r=0.0},
        {x= 463.870,  y= -1005.6896, z= 24.9148, r=0.0},
        {x= 448.978,  y= -977.84832, z= 30.6895, r=151.7989}
    }

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end

    for k,v in pairs(coords) do
        enemy = CreatePed(7, model, v.x, v.y, v.z-1.0, v.r, true, false)
        GiveWeaponToPed(enemy, "WEAPON_ASSAULTSHOTGUN", -1, false, true)
        DecorSetBool(enemy, "m_snitch_entity", true)
        
        SetPedCombatAttributes(enemy, 3, false)
        SetPedCombatAttributes(enemy, 5, true)
        SetPedCombatAttributes(enemy, 46, true)

        SetPedRelationshipGroupHash(enemy, "ARMY")
        SetPedAiBlip(enemy, true)
        TaskStartScenarioInPlace(enemy, "WORLD_HUMAN_COP_IDLES", 0, 1)
    end

    SetModelAsNoLongerNeeded(model)
end

local function cleanUpEntities()
    for vehicle in EntityEnum.EnumerateVehicles() do
        if DecorExistOn(vehicle, "m_snitch_entity") then
            DeleteVehicle(vehicle)
        end
    end

    for ped in EntityEnum.EnumeratePeds() do
        if DecorExistOn(ped, "m_snitch_entity") then
            DeletePed(ped)
        end
    end
end

function MissionSnitch.Init()
    TriggerMusicEvent("MP_MC_STOP")
    ClearPrints()
    cleanUpEntities()

    playerPed = PlayerPedId()
    if GetScreenEffectIsActive("MP_Celeb_Win") then
        StopScreenEffect("MP_Celeb_Win")
    end

    ClearPlayerWantedLevel(PlayerId())

    if not DoesEntityExist(destBlip) then
        destBlip = AddBlipForCoord(destCoords)
        SetBlipNameFromTextFile(destBlip, "BLIP_DEST")
        SetBlipRoute(destBlip, true)
    end

    if not IsPlayerSwitchInProgress() then
        SwitchOutPlayer(playerPed, 32, 1)
    end

    Wait(5000)

    if IsModelValid(vehicleHash) then
        RequestModel(vehicleHash)
        while not HasModelLoaded(vehicleHash) do
            Wait(0)
        end

        missionVeh = CreateVehicle(vehicleHash, -1021.7688, 693.375, 160.896, 359.050, true, false)
        DecorSetBool(missionVeh, "m_snitch_entity", true)
        SetVehicleEngineOn(missionVeh, true, true)

        SetPedIntoVehicle(playerPed, missionVeh, -1)
        SetVehicleHasBeenOwnedByPlayer(missionVeh, true)
        SetMaxWantedLevel(0)

        SetModelAsNoLongerNeeded(vehicleHash)
        TriggerMusicEvent("MP_MC_CMH_IAA_PREP_START")
        TriggerMusicEvent("MP_MC_CMH_VEHICLE_CHASE")

        SetPedIntoVehicle(playerPed, missionVeh, -1)
        N_0xd8295af639fd9cb8(playerPed)

        Wait(6000)
        notify("CHAR_MARTIN", 6, GetLabelText("BLIP_352"), GetLabelText("BLIP_133"), 'A snitch in custody is about to hand over the location of my cocaine enterprise. stop him!', 8)
        missionStage = 1
    end
end

function MissionSnitch.Tick()
    local playerCoords = GetEntityCoords(playerPed)

    if IsPedDeadOrDying(playerPed) then
       Missions.Kill()
    end 

    if IsEntityInZone(playerPed, "SKID") then
        if not SpawnedEnemies then
            CreateEnemyPeds()
            ped = CreateTarget(458.281, -1000.52954, 24.9148, 272.934)
            DecorSetBool(ped, "m_snitch_entity", true)

            SpawnedEnemies = true
             missionStage = 2
        end

        if missionStage == 2 then
            if DoesBlipExist(destBlip) then
                RemoveBlip(destBlip)
            end

            ClearPrints()
            BeginTextCommandPrint("DBR_KILSNCH")
            EndTextCommandPrint(0.1, true)

            if DoesBlipExist(targetBlip) and IsEntityDead(ped) then
                RemoveBlip(targetBlip)
                missionStage = 3
            end
        elseif missionStage == 3 then
            if IsPlayerWantedLevelGreater(PlayerId(), 1) then
                ClearPrints()
                BeginTextCommandPrint("GR_LEAVE_AREAA")
                EndTextCommandPrint(0.1, true)
            end
        end
    else
        if missionStage == 1 then
            ClearPrints()
            BeginTextCommandPrint("BRS_GO_SETUPA")
            AddTextComponentSubstringTextLabel("GB_BB_PS2")
            EndTextCommandPrint(0.1, true)
        elseif missionStage == 3 then
            if IsPlayerWantedLevelGreater(PlayerId(), 1) then
                ClearPrints()
                BeginTextCommandPrint("FM_IHELP_LCP")
                EndTextCommandPrint(0.1, true)
            else
                payOut = true
                Missions.Kill()
            end
        end
    end
end

function MissionSnitch.Kill()
    if missionStage == 3 then
        if not IsEntityDead(playerPed) then
            if not GetScreenEffectIsActive("MP_Celeb_Win") then
                StartScreenEffect("MP_Celeb_Win", 5000, false)
            end
        end
         missionStage = 0
    end

    cleanUpEntities()
    ClearPrints()

    if DoesBlipExist(destBlip) then
        RemoveBlip(destBlip)
    end

    if DoesBlipExist(targetBlip) and IsEntityDead(ped) then
        RemoveBlip(targetBlip)
    end

    if DoesEntityExist(missionVeh) then
        if IsPedInVehicle(playerPed, missionVeh, false) then
            TaskLeaveVehicle(playerPed, missionVeh, 1)
            if payOut then
                TriggerServerEvent('vf_mtest:playercut', GetRandomIntInRange(5000, 20000))
                payOut = false
            end
        end

        SetEntityAsNoLongerNeeded(missionVeh)
    end

    TriggerMusicEvent("MP_MC_STOP")

    SetMaxWantedLevel(5)
    SetPlayerWantedLevel(PlayerId(), 0, false)
    SetPlayerWantedLevelNow(playerPed, true)
end