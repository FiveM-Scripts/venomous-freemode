IsStoreKeeperAlive = false

pos = {}

function CreateStorePed(x, y, z, heading)
  modelHash = GetHashKey("mp_m_shopkeep_01")

  if IsModelValid(modelHash) and IsModelInCdimage(modelHash) then
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
      Wait(50)
    end

    local ped = CreatePed(4, modelHash, x, y, z-1, heading, true, false)
    while not DoesEntityExist(ped) do
      Wait(10)
    end

    netID = PedToNet(ped)

    if not NetworkDoesNetworkIdExist(netID) then
      NetworkRegisterEntityAsNetworked(ped)
    else
      SetNetworkIdExistsOnAllMachines(netID, true)
    end

    GiveWeaponToPed(ped, GetHashKey("weapon_pistol"), -1, false, false)

    SetEntityHeading(ped, heading)
    SetPedFleeAttributes(ped, 0, 0)
    SetEntityInvincible(ped, false)
    TaskSetBlockingOfNonTemporaryEvents(ped, true)

    SetModelAsNoLongerNeeded(modelHash)
    return ped
  else
    print('vf_convenience | You are loading a invalid model')
    return false
  end
end

function TaskStartHoldUp(ped)
  PlayAmbientSpeech1(ped, "SHOP_SCARED_START", "SPEECH_PARAMS_FORCE")
  Wait(50)

  TaskGoStraightToCoord(storeKeeper, atmX, atmY, atmZ, 0.2, 4000, GetEntityHeading(register), 0.5)
  Wait(300)  

  local _, taskSequence = OpenSequenceTask(0)
  TaskTurnPedToFaceEntity(storeKeeper, PlayerPedId(), 10000)
  TaskLookAtEntity(ped, PlayerId(), -1, 0, 2)
  TaskPlayAnim(ped, "mp_am_hold_up", "holdup_victim_20s", 8.0, -8.0, -1, 262192, 0, 0, 0, 0)
  Wait(1000)

  storebag = GetHashKey("p_poly_bag_01_s")
  RequestModel(storebag)
  while not HasModelLoaded(storebag) do
    Citizen.Wait(50)
  end

  coords = GetEntityCoords(storeKeeper, true)

  bag = CreateObject(storebag, coords.x, coords.y, coords.z, false, true, true)
  AttachEntityToEntity(bag, storeKeeper, 11816, 0.0, 0.0, 0.0, 0.0, -90.0, 180.0, false, false, false, false, 2, true)
  
  --AttachEntityToEntity(entity1, entity2, boneIndex, xPos, yPos, zPos, xRot, yRot, zRot, p9, useSoftPinning, collision, isPed, vertexIndex, fixedRot)
  -- TaskPlayAnim(ped, "mp_am_hold_up", "handsup_base", 4.0, -4.0, -1, 49, 0, 0, 0, 0)
  CloseSequenceTask(taskSequence)
  TaskPerformSequence(ped, taskSequence)

  Wait(20000)
  SetPlayerWantedLevel(PlayerId(), 2, false)
  SetPlayerWantedLevelNow(PlayerId())
end

function TaskStartRobbing(ped)
  animDict = "random@shop_robbery"
  if not HasAnimDictLoaded(animDict) then
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
      Wait(10)
    end
  end

  register = GetClosestObjectOfType(GetEntityCoords(ped, true), 0.75, GetHashKey("prop_till_02"), false)
  if DoesEntityExist(register) then
    atmX, atmY, atmZ = table.unpack(GetOffsetFromEntityInWorldCoords(register, 0.0, 0.2, 0.0))
    TaskGoStraightToCoord(playerPed, atmX, atmY, atmZ, 0.1, 4000, GetEntityHeading(register), 0.5)
    print('found the cash register.')
    Wait(3000)
  end

  _, taskSequence = OpenSequenceTask(0)
  TaskPlayAnim(ped, animDict, "robbery_intro_loop_a", 8.0, -8.0, -1, 0, 0, 0, 0, 0)
  TaskPlayAnim(ped, animDict, "robbery_intro_loop_b", 8.0, -8.0, 4000, 1, 0, 0, 0, 0)
  TaskPlayAnim(ped, animDict, "robbery_intro_loop_bag", 8.0, -8.0, 4000, 1, 0, 0, 0, 0)

  CloseSequenceTask(taskSequence)
  TaskPerformSequence(ped, taskSequence)
  RemoveAnimDict(animDict)
end

function isNearGeneralStore()
  local distance = 60.0
  local coords = GetEntityCoords(PlayerPedId(), 0)

  for k, item in pairs(locations) do
    local bCoords = item["blip"]
    local currentDistance = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, bCoords.x, bCoords.y, bCoords.z, true)

    if currentDistance < distance then
      if not DoesEntityExist(storeKeeper) then
        local x, y, z, w = table.unpack(item["ped"])
        local menu = item["menu"]
        
        storeKeeper = CreateStorePed(x, y, z, w)
        print('Created store ped ' .. storeKeeper)
        MenuType = menu
        Wait(10)
      end

      return true
    end
  end
end

function IsPlayerNearShopKeeper(ped)
  local coords = GetEntityCoords(PlayerPedId(), 0)
  local pcoords = GetEntityCoords(ped, 0)
  local distance = GetDistanceBetweenCoords(coords.x, coords.y , coords.z, pcoords.x, pcoords.y, pcoords.z, true)

  if distance <= 2.0 then
    return true
  end
end