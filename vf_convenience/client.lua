local objects = {"p_poly_bag_01_s", "prop_till_01", "prop_till_02", "p_till_01_s"}
local modeltypes = {'prop_till_01', 'prop_till_02', 'p_till_01_s'}

function DisplayHelpLabel(label, sublabel, time)
  ClearBrief()
  
  BeginTextCommandDisplayHelp(label)
  if sublabel then
     AddTextComponentSubstringPlayerName(sublabel)
  end

  if time then
    displayTime = time
  else
    displayTime = 10000
  end
  EndTextCommandDisplayHelp(0, 0, false, displayTime)
end

Citizen.CreateThread(function()
  ClearPedBloodDamage(PlayerPedId())
  ClearPlayerWantedLevel(PlayerId())

  for k,v in pairs(objects) do
    local object = GetHashKey(v)
    RequestModel(object)
    while not HasModelLoaded(object) do
      Wait(10)
    end
  end

  RequestAnimDict("mp_am_hold_up")
  while not HasAnimDictLoaded("mp_am_hold_up") do
    Wait(10)
  end

  for _, item in pairs(locations) do
    local bCoords = item["blip"]
    local currentBlip = AddBlipForCoord(bCoords.x, bCoords.y, bCoords.z)

    SetBlipSprite(currentBlip, 52)
    SetBlipScale(currentBlip, 0.7)
    SetBlipAsShortRange(currentBlip, true)
    SetBlipNameFromTextFile(currentBlip, "collision_78czu4")
  end

  while true do
    Wait(700)
    IsNearStore = isNearGeneralStore()
    if IsNearStore then
      IsStoreKeeperAlive = DoesEntityExist(storeKeeper)
    end
    PlayerPed = PlayerPedId()
    PedCoords = GetEntityCoords(PlayerPed, true)

    if GetClockHours() == 07 then
      speech = "SHOP_GREET_START"
    elseif GetClockHours() >= 09 and GetClockHours() <= 22 then 
      speech = "SHOP_GREET"
    else
      speech = "SHOP_GREET_END"
    end
  end
end)

Citizen.CreateThread(function()
  DestroyAllCams(0)
  Wait(5000)

  while true do
    Wait(10)
      if IsNearStore then
        if IsStoreKeeperAlive then
          if IsPlayerNearShopKeeper(storeKeeper) and not IsPedDeadOrDying(storeKeeper) then
            if IsPedInMeleeCombat(PlayerPed) then
              if not IsAnySpeechPlaying(storeKeeper) then
                PlayAmbientSpeech1(storeKeeper, "SHOP_NO_FIGHTING", "SPEECH_PARAMS_FORCE")
                Wait(5000)
              end
            end

            if IsPedShooting(PlayerPed) then
              if not IsAnySpeechPlaying(storeKeeper) then
                PlayAmbientSpeech1(storeKeeper, "CALL_COPS_THREAT", "SPEECH_PARAMS_FORCE")
                Wait(5000)
              end
            end

            if not DoesStoreMenuExist then
              if not IsPlayerWantedLevelGreater(PlayerId(), 0) then
                NoCops = false
                if not GreetPlayer then
                  GreetPlayer = true
                end

                if not IsHelpMessageBeingDisplayed() then
                  DisplayHelpLabel("SHR_MENU", 1)
                end

                if IsControlJustPressed(0, 51) then
                  if not DoesCamExist(camera) then
                    camera = CreateCameraWithParams(26379945, 0.0, 0.0, 0.0, 0.0, .0, 0.0, 50.0, 0, 2)
                    while not DoesCamExist(camera) do
                      Wait(50)
                    end

                    AttachCamToEntity(camera, PlayerPedId(), 1.8146, -3.0635, 0.680+0.7, 1)
                    PointCamAtEntity(camera, PlayerPedId(),  0.3874, -0.0957, 0.3008+0.2, 1)
                    SetCamFov(camera, 20.0)
                    ShakeCam(camera, "HAND_SHAKE", 0.1)
                    SetCamActive(camera, true)
                    RenderScriptCams(true, false, 3000, 1, 0, 0)
                  end

                  TaskTurnPedToFaceEntity(storeKeeper, PlayerPedId(), 10000)
                  TaskTurnPedToFaceEntity(PlayerPedId(), storeKeeper, 10000)
                  -- Create the store menu
                  _generalStorePool = NativeUI.CreatePool()
                  storeMenu = NativeUI.CreateMenu("", "~s~" .. GetLabelText("SNK_ITEM"), "", "", MenuType, MenuType)
                  _generalStorePool:Add(storeMenu)

                  _generalStorePool:ControlDisablingEnabled(true)
                  _generalStorePool:MouseControlsEnabled(false)

                  CreateStoreMenu(storeMenu)
                  _generalStorePool:RefreshIndex()
                  DoesStoreMenuExist = true
                  PlayAmbientSpeech1(storeKeeper, "SHOP_GREET_SPECIAL", "SPEECH_PARAMS_FORCE")
                  storeMenu:Visible(not storeMenu:Visible())
                end
              else
                NoCops = true
              end
            end

            if storeMenu then
              if not storeMenu:Visible() then
                _generalStorePool:Clear()
                _generalStorePool:Remove()

                DestroyAllCams(0)
                RenderScriptCams(false, false, 3000, 0, 0)

                DoesStoreMenuExist = false
              else
                DisableControlAction(0, 0, true)
                DisableControlAction(0, 22, true)
                DisableControlAction(0, 30, true)

                DisableControlAction(0, 31, true)
                DisableControlAction(0, 32, true)
                DisableControlAction(0, 33, true)

                DisableControlAction(0, 34, true)
                DisableControlAction(0, 35, true)
                DisableControlAction(0, 36, true)

                DisableControlAction(0, 37, true)

                DisableControlAction(0, 44, true)
                DisableControlAction(0, 47, true)
                DisableControlAction(0, 55, true)
              end
            end
          end
        end
      else
        if IsStoreKeeperAlive then
          DeleteEntity(storeKeeper)
          IsStoreKeeperAlive = false
        end
      end
    end
end)

Citizen.CreateThread(function()
  while true do
    Wait(10)
    if IsStoreKeeperAlive then
      if GreetPlayer and not NoCops then
        if not GreetingPlayer then
          if GetClockHours() == 07 then
            speech = "SHOP_GREET_START"
          elseif GetClockHours() >= 09 and GetClockHours() <= 22 then 
            speech = "SHOP_GREET"
          else
            speech = "SHOP_GREET_END"
          end

          PlayAmbientSpeech1(storeKeeper, speech, "SPEECH_PARAMS_FORCE")
          GreetingPlayer = true
        end
      end

      if NoCops then
        if GetClockHours() == 07 then
          speech = "SHOP_NO_COPS_START"
        elseif GetClockHours() >= 09 and GetClockHours() <= 21 then 
          speech = "SHOP_NO_ENTRY"
        else
          speech = "SHOP_NO_COPS_END"
        end
      else
        speech ""
      end
    end

  end
end)