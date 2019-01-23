local blips = {
  {x=1701.292, y=3750.450, z=34.365},
  {x=237.428, y=-43.655, z=69.698},
  {x=843.604, y=-1017.784, z=27.546},
  {x=-321.524, y=6072.479, z=31.299},
  {x=-664.218, y=-950.097, z=21.509},
  {x=-1320.983, y=-389.260, z=36.483},
  {x=-1109.053, y=2686.300, z=18.775},
  {x=2568.379, y=309.629, z=108.461},
  {x=-3157.450, y=1079.633, z=20.692},
  {x=16.393, y=-1117.448, z=29.791}
}

local weapon_peds = {
  {model="s_m_m_ammucountry", voice="S_M_M_AMMUCOUNTRY_WHITE_MINI_01", x=1692.733, y=3761.895, z=34.705, a=218.535},
  {model="s_m_m_ammucountry", voice="S_M_M_AMMUCOUNTRY_WHITE_MINI_01", x=-330.933, y=6085.677, z=31.455, a=207.323},
  {model="s_m_y_ammucity_01", voice="S_M_Y_AMMUCITY_01_WHITE_MINI_01", x=253.629, y=-51.305, z=69.941, a=59.656},
  {model="s_m_y_ammucity_01", voice="S_M_Y_AMMUCITY_01_WHITE_MINI_01", x=841.363, y=-1035.350, z=28.195, a=328.528},
  {model="s_m_y_ammucity_01", voice="S_M_Y_AMMUCITY_01_WHITE_MINI_01", x=-661.317, y=-933.515, z=21.829, a=152.798},
  {model="s_m_y_ammucity_01", voice="S_M_Y_AMMUCITY_01_WHITE_MINI_01", x=-1304.413, y=-395.902, z=36.696, a=44.440},
  {model="s_m_y_ammucity_01", voice="S_M_Y_AMMUCITY_01_WHITE_MINI_01", x=-1118.037, y=2700.568, z=18.554, a=196.070},
  {model="s_m_y_ammucity_01", voice="S_M_Y_AMMUCITY_01_WHITE_MINI_01", x=2566.596, y=292.286, z=108.735, a=337.291},
  {model="s_m_y_ammucity_01", voice="S_M_Y_AMMUCITY_01_WHITE_MINI_01", x=-3173.182, y=1089.176, z=20.839, a=223.930},
  {model="s_m_y_ammucity_01", voice="S_M_Y_AMMUCITY_01_WHITE_MINI_01", x=23.394, y=-1105.455, z=29.797, a=147.921}
}

local playerPed = nil
local purchase = nil
local AmmunationMenuCreated = false
local WeaponPurchased = nil

local _ammunationPool
local ammunationMenu

local function isPlayerNearWeaponStore()
  local distance = 20.0
  local pos = {}

  for k,v in pairs(weapon_peds) do
    local x,y,z = table.unpack(GetEntityCoords(playerPed, 0))
    local currentDistance = GetDistanceBetweenCoords(x, y, z, v.x, v.y, v.z, true)

    if currentDistance < distance then
      distance = currentDistance
      pos = {model = v.model, voice = v.voice, x= v.x, y= v.y, z= v.z, heading = v.a}
    end
  end

  if distance < 20.0 then
    if not DoesEntityExist(weaponPed) then
      modelHash = pos.model
      RequestModel(modelHash)
      while not HasModelLoaded(modelHash) do
        Wait(0)
      end

      weaponPed = CreatePed(4, modelHash, pos.x, pos.y, pos.z-1, pos.heading, false, false)
      SetEntityHeading(weaponPed, pos.heading)

      SetBlockingOfNonTemporaryEvents(weaponPed, true)
      SetPedFleeAttributes(weaponPed, 0, 0)
      SetEntityInvincible(weaponPed, true)

      SetAmbientVoiceName(weaponPed, pos.voice)
      SetModelAsNoLongerNeeded(modelHash)
    end
  else
    if DoesEntityExist(weaponPed) then
      DeleteEntity(weaponPed)
    end
  end

  if distance < 20.0 then
    return true
  else
    return false
  end
end

local function CreateWeaponMenu(menu)
  for k,v in pairs(storeGroups) do
    local weaponGroup = _ammunationPool:AddSubMenu(menu, v.name, "", true, true)
    for g,w in pairs(StoreWeapons) do
      if v.id == w.id then
        for c, weapon in pairs(w.items) do
          if IsWeaponValid(GetHashKey(weapon.model)) then
            local newitem = NativeUI.CreateItem(weapon.name, "")
            newitem:RightLabel(StoreCurrency .. " " .. weapon.price)
            weaponGroup:AddItem(newitem)
            newitem.Activated = function(ParentMenu, SelectedItem)
              if SelectedItem == newitem then
                WeaponPurchased = GetGameTimer()
                TriggerServerEvent('vf_ammunation:item-selected', weapon.model, weapon.price, weapon.name)
                _ammunationPool:CloseAllMenus()
              end
            end
          end
        end
      end
    end
  end
end

local function DisplayHelpLabel(label, sublabel)
  ClearBrief()
  ClearAllHelpMessages()
  
  BeginTextCommandDisplayHelp(label)
  if sublabel then
     AddTextComponentSubstringPlayerName(sublabel)
  end  
  EndTextCommandDisplayHelp(0, 0, 0, 20000)
end

local function DisplayNotificaition(label)
  SetNotificationTextEntry(label)
  DrawNotification(false, false)
  PlaySoundFrontend(-1, "ERROR", "HUD_AMMO_SHOP_SOUNDSET", true)
end

RegisterNetEvent("vf_ammunation:getStock")
AddEventHandler('vf_ammunation:getStock', function()
  print('load the weapons for te current player')
  TriggerServerEvent('vf_ammunation:LoadPlayer')
end)

RegisterNetEvent("vf_ammunation:nocash")
AddEventHandler("vf_ammunation:nocash", function(weaponHash, weaponName)
  DisplayNotificaition("BB_NOMONEY")
end)

RegisterNetEvent("vf_ammunation:giveWeapon")
AddEventHandler("vf_ammunation:giveWeapon", function(weaponHash, weaponName)
  if IsWeaponValid(weaponHash) then
    if not HasScaleformMovieLoaded(purchase) then
      purchase = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")
      while not HasScaleformMovieLoaded(purchase) do
        Wait(100)
      end
    end

    BeginScaleformMovieMethod(purchase, "SHOW_WEAPON_PURCHASED")
    BeginTextCommandScaleformString("SHOP_PURCH") 
    EndTextCommandScaleformString()

    BeginTextCommandScaleformString("STRING") 
    AddTextComponentSubstringPlayerName(tostring(weaponName)) 
    EndTextCommandScaleformString()

    EndScaleformMovieMethod()

    if DoesEntityExist(weaponPed) then
      if not IsAnySpeechPlaying(weaponPed) then
        PlayAmbientSpeech1(weaponPed, "SHOP_SELL", "SPEECH_PARAMS_FORCE")
      end
    end

    GiveWeaponToPed(playerPed, weaponHash, -1, false, false)
    PlaySoundFrontend(-1, "WEAPON_PURCHASE", "HUD_AMMO_SHOP_SOUNDSET", 1)
  end
end)

RegisterNetEvent("vf_ammunation:LoadWeapons")
AddEventHandler("vf_ammunation:LoadWeapons", function(weapons)
  for k,v in pairs(weapons) do
    weaponHash = v.weapon
    if IsWeaponValid(weaponHash) then
      GiveWeaponToPed(PlayerPedId(), weaponHash, -1, false, false)
    end
  end
end)

Citizen.CreateThread(function()
  playerId = PlayerId()

  while true do
    Wait(1)
    if NetworkIsGameInProgress() and IsPlayerPlaying(playerId) then
      playerPed = PlayerPedId()
      
      if not BlipsCreated then
        for _, item in pairs(blips) do
          item.blip = AddBlipForCoord(item.x, item.y, item.z)
          
          SetBlipSprite(item.blip, 110)
          SetBlipAsShortRange(item.blip, true)
        end

        BlipsCreated = true
      end

      if isPlayerNearWeaponStore() then
        x, y, z = table.unpack(GetEntityCoords(playerPed, true))

        if DoesEntityExist(weaponPed) then
          if joinedStore and AmmunationMenuCreated then
            _ammunationPool:ProcessMenus()
          end

          offset = GetOffsetFromEntityInWorldCoords(weaponPed, 1.0, 2.5, -1.5)
          weaponPedCoords = GetEntityCoords(weaponPed, true)
          if GetDistanceBetweenCoords(x, y, z, weaponPedCoords, true) <= 9.3 then
            if not joinedStore then
              if not IsAnySpeechPlaying(weaponPed) then
                ClearPedTasksImmediately(weaponPed)
                PlayAmbientSpeech1(weaponPed, "SHOP_GREET", "SPEECH_PARAMS_FORCE")

                joinedStore = true
              end
            end

            if GetDistanceBetweenCoords(x, y, z, weaponPedCoords, true) < 3.0 then
              if not IsHelpMessageBeingDisplayed() then
                DisplayHelpLabel("GS_BROWSE_W", "~INPUT_CONTEXT~")
              end

              if IsControlJustPressed(0, 51) then
                if not AmmunationMenuCreated then
                  _ammunationPool = NativeUI.CreatePool()
                  ammunationMenu = NativeUI.CreateMenu("", GetLabelText("CMRC_CATEGS"), "", "", "shopui_title_gunclub", "shopui_title_gunclub")
                  _ammunationPool:Add(ammunationMenu)

                  _ammunationPool:ControlDisablingEnabled(true)
                  _ammunationPool:MouseControlsEnabled(false)

                  CreateWeaponMenu(ammunationMenu)
                  _ammunationPool:RefreshIndex()
                  AmmunationMenuCreated = true
                end

                TaskTurnPedToFaceEntity(weaponPed, playerPed, 500)
                TaskTurnPedToFaceEntity(playerPed, weaponPed, 500)

                if not IsAnySpeechPlaying(weaponPed) then
                  ClearPedTasksImmediately(weaponPed)                  
                  if IsPlayerWantedLevelGreater(playerId, 0) then
                    PlayAmbientSpeech1(weaponPed, "SHOP_NO_COPS", "SPEECH_PARAMS_FORCE")
                  else
                    ammunationMenu:Visible(not ammunationMenu:Visible())
                    PlayAmbientSpeech1(weaponPed, "SHOP_BROWSE", "SPEECH_PARAMS_FORCE")
                  end
                end
              end
            end
          end

          if GetDistanceBetweenCoords(x, y, z, weaponPedCoords) >= 10.0 then
            if joinedStore then
              if not IsAnySpeechPlaying(weaponPed) then
                ClearPedTasksImmediately(weaponPed)
                PlayAmbientSpeech1(weaponPed, "SHOP_GOODBYE", "SPEECH_PARAMS_FORCE")
              end

              if AmmunationMenuCreated then
                _ammunationPool:CloseAllMenus()
                _ammunationPool:Remove()
                AmmunationMenuCreated = false
                ClearAllHelpMessages()
              end

              joinedStore = false
            end
          end

          if joinedStore then
            HideHudComponentThisFrame(19)
            HideHudComponentThisFrame(20)

            SetCurrentPedWeapon(playerPed, "weapon_unarmed", true)
            if HasScaleformMovieLoaded(purchase) then
              if GetGameTimer() < WeaponPurchased + 5000 then
                DrawScaleformMovieFullscreen(purchase, 255, 255, 255, 255)
              else
                SetScaleformMovieAsNoLongerNeeded(purchase)
                _ammunationPool:Remove()
                AmmunationMenuCreated = false
              end
            end
          end

        end
      end

    end
  end
end)