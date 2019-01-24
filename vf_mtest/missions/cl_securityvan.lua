MissionSecurityVan = {
    MissionName = "SecurityVan"
}

local playerPed
local playerCoords

local securityVan
local securityCase
local securityCaseBlip

local securityVanDriver
local securityVanPassenger

local lastTask
local payOut = false

DecorRegister("m_securityvan_entity", 2)

local enemyGroup = AddRelationshipGroup("Security_guards")

local function CreateSecurityVan(x, y, z)
    local vehicleModel = GetHashKey("stockade")
    local objectModel = GetHashKey("prop_security_case_01")
    local pedModel = GetHashKey("s_m_m_armoured_01")

    if IsModelValid(vehicleModel) and IsModelAVehicle(vehicleModel) then
        if not DoesEntityExist(securityVan) then
            RequestModel(vehicleModel)
            while not HasModelLoaded(vehicleModel) do 
                Wait(50)
            end

            RequestModel(objectModel)
            while not HasModelLoaded(objectModel) do 
                Wait(50)
            end

            RequestModel(pedModel)
            while not HasModelLoaded(pedModel) do
                Wait(50)
            end

            securityVan = CreateVehicle(vehicleModel, x, y, z, heading, true, false)            
            securityCase = CreateObject(objectModel, x, y, z, true, true, false)
            securityVanBlip = AddBlipForEntity(securityVan)
            SetBlipColour(securityVanBlip, 2)

            DecorSetBool(securityVan, "m_securityvan_entity", true)

            AttachEntityToEntity(securityCase, securityVan, 0, 0.0, -2.4589, 1.2195, 0.0, 0.0, 0.0, 0, 0, 0, 0, 2, 1)
            SetEntityVisible(securityCase, true, 0)
            SetEntityNoCollisionEntity(securityCase, securityVan, false)

            SetVehicleDoorsLocked(securityVan, 3)
            SetEntityProofs(securityCase, false, true, true, true, true, true, 0, false)
            SetEntityIsTargetPriority(securityVan, 1, 0)
            
            SetEntityHealth(securityVan, 700)
            SetVehicleAutomaticallyAttaches(securityVan, false, 0)
            SetEntityLoadCollisionFlag(securityVan, true)
            SetVehicleProvidesCover(securityVan, false)

            securityVanDriver = CreatePedInsideVehicle(securityVan, 26, pedModel, -1, true, false)
            DecorSetBool(securityVanDriver, "m_securityvan_entity", true)
            SetPedCombatAttributes(securityVanDriver, 1, false)
            SetPedCombatAttributes(securityVanDriver, 13, false)
            SetPedCombatAttributes(securityVanDriver, 6, true)
            SetPedCombatAttributes(securityVanDriver, 8, false)
            SetPedCombatAttributes(securityVanDriver, 10, true)

            SetPedPlaysHeadOnHornAnimWhenDiesInVehicle(securityVanDriver, false)
            GiveWeaponToPed(securityVanDriver, GetHashKey("weapon_pistol"), -1, false, true)

            securityVanPassenger = CreatePedInsideVehicle(securityVan, 26, pedModel, 0, true, false)
            DecorSetBool(securityVanPassenger, "m_securityvan_entity", true)

            SetPedCombatAttributes(securityVanPassenger, 1, false)
            SetPedCombatAttributes(securityVanPassenger, 13, false)
            SetPedCombatAttributes(securityVanPassenger, 6, true)
            SetPedCombatAttributes(securityVanPassenger, 8, false)
            SetPedCombatAttributes(securityVanPassenger, 10, true)

            SetPedPlaysHeadOnHornAnimWhenDiesInVehicle(securityVanPassenger, false)
            GiveWeaponToPed(securityVanPassenger, GetHashKey("weapon_pistol"), -1, false, true)

            TaskVehicleDriveToCoord(securityVanDriver, securityVan, -574.6195, -847.2320, 25.2925, 10.0, 0, GetHashKey("stockade"), 786603, 2.0, 4.0)

            return securityVan
        end
    end
end

local function cleanUpEntities()
    for vehicle in EntityEnum.EnumerateVehicles() do
        if DecorExistOn(vehicle, "m_securityvan_entity") then
            blip = GetBlipFromEntity(vehicle)
            if DoesBlipExist(blip) then
                RemoveBlip(blip)
            end

            DeleteVehicle(vehicle)
        end
    end

    for ped in EntityEnum.EnumeratePeds() do
        if DecorExistOn(ped, "m_securityvan_entity") then
            DeletePed(ped)
        end
    end
end

function MissionSecurityVan.Init()
    cleanUpEntities()
    playerPed = PlayerPedId()

    ClearPrints()
    ClearBrief()
    ClearAllHelpMessages()

    if IsPlayerWantedLevelGreater(PlayerId(), 0) then
        ClearPlayerWantedLevel(PlayerId())
    end

    if not DoesEntityExist(securityVan) then
       securityVan = CreateSecurityVan(-331.8429, -1461.0420, 30.153)
    end
end

function MissionSecurityVan.Tick()
    local playerCoords = GetEntityCoords(playerPed)

    if IsEntityDead(playerPed) then
        Missions.Kill()
    else
        if DoesEntityExist(securityVan) then
            if IsEntityInAngledArea(playerPed,  GetOffsetFromEntityInWorldCoords(securityVan, 0.0, -1.440, -5.0), GetOffsetFromEntityInWorldCoords(securityVan, 0.0, -30.440, 5.0), 2.30, 0, true, 0) then
                if DoesEntityExist(securityCase) and GetVehicleDoorAngleRatio(securityVan, 2) > 0.250 and GetVehicleDoorAngleRatio(securityVan, 3) > 0.250 then
                    if IsEntityAttached(securityCase) then
                        SetVehicleUndriveable(securityCase, true)

                        DetachEntity(securityCase, 1, false)
                        SetEntityCollision(securityCase, true, true)
                        ActivatePhysics(securityCase)
                        ApplyForceToEntity(securityCase,  1, 0.0, 1.0, 5.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)

                        if not DoesBlipExist(securityCaseBlip) and DoesEntityExist(securityCase) then
                            RemoveBlip(securityVanBlip)
                            securityCaseBlip = AddBlipForEntity(securityCase)
                        end

                        SetActivateObjectPhysicsAsSoonAsItIsUnfrozen(securityCase, true)

                    end
                end
            elseif GetDistanceBetweenCoords(GetEntityCoords(securityVan, true), playerCoords, true) <= 225.0 then
               -- print('Player is near the van')              
            elseif GetDistanceBetweenCoords(GetEntityCoords(securityVan, true),-331.8429, -1461.0420, 30.153, true) <= 4.0 then
                payout = false
            end
            if GetEntityHealth(securityVan) < 1 and not lastTask then 
                payout = false

            end
        end

        if DoesEntityExist(securityCase) then
            if not IsEntityDead(securityVanDriver) then
                ClearPrints()
                ClearBrief()
                ClearAllHelpMessages()

                BeginTextCommandPrint("HPT_STRAP3")
                EndTextCommandPrint(0.1, true)

                if GetDistanceBetweenCoords(GetEntityCoords(securityCase, true), playerCoords, true) <= 3.0 then
                    RemoveBlip(securityCaseBlip)
                    DeleteEntity(securityCase)

                    PlaySoundFrontend(0, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0)
                    lastTask = true
                end
            else
                payOut = false
                Missions.Kill()
            end
        end

        if not DoesEntityExist(securityCase) and lastTask then
            if IsPlayerWantedLevelGreater(PlayerId(), 0) then
                ClearBrief()
                ClearPrints()
                ClearAllHelpMessages()

                BeginTextCommandPrint("FM_IHELP_LCP")
                EndTextCommandPrint(0.1, true) 
            else
                payOut = true
                Missions.Kill()
            end
        end

    end
end

function MissionSecurityVan.Kill()
    cleanUpEntities()
    ClearAllHelpMessages()
    ClearBrief()
    ClearPrints()

    print('Closing Mission')

    if payOut then
        TriggerServerEvent('vf_mtest:playercut', GetRandomIntInRange(5000, 20000))
        payOut = false
    end

    if DoesEntityExist(securityCase) or DoesBlipExist(securityCaseBlip) then
        RemoveBlip(securityCaseBlip)

    end    

    SetMaxWantedLevel(5)
    TriggerMusicEvent("MP_MC_STOP")
    lastTask = false
end