CurrentSlot = 10
gxt = "SNK_MNU"


RegisterNetEvent('vf_convenience:update')
AddEventHandler('vf_convenience:update', function()
  if DoesStoreMenuExist then
    _generalStorePool:Clear()
    _generalStorePool:Remove()

    -- Create the store menu
    _generalStorePool = NativeUI.CreatePool()
    storeMenu = NativeUI.CreateMenu("", "~s~" .. GetLabelText("SNK_ITEM"), "", "", MenuType, MenuType)
    _generalStorePool:Add(storeMenu)

    _generalStorePool:ControlDisablingEnabled(true)
    _generalStorePool:MouseControlsEnabled(false)

    Wait(10)

    CreateStoreMenu(storeMenu)
    _generalStorePool:RefreshIndex()
    storeMenu:Visible(not storeMenu:Visible())
    DoesStoreMenuExist = true
  end
end)

Citizen.CreateThread(function()
  while not NetworkIsGameInProgress() and not IsPlayerPlaying(PlayerId()) do
    Citizen.Wait(0)
  end

  while HasAdditionalTextLoaded(CurrentSlot) and not HasThisAdditionalTextLoaded(gxt, CurrentSlot) do
    Citizen.Wait(0)
    CurrentSlot = CurrentSlot + 1
  end

  if not HasThisAdditionalTextLoaded(gxt, CurrentSlot) then
    ClearAdditionalText(CurrentSlot, true)
    RequestAdditionalText(gxt, CurrentSlot)
    while not HasThisAdditionalTextLoaded(gxt, CurrentSlot) do
      Citizen.Wait(0)
    end
  end

  Citizen.Wait(1800)
end)

function CreateStoreMenu(menu)  
  inventoryItems = exports.vf_base:GetInventory()
  ConvenienceStore = {
    {name = "SNK_ITEM1", description = "SNK_ITEM1_D", price = 10},
    {name = "SNK_ITEM2", description = "SNK_ITEM2_D", price = 20},
    {name = "SNK_ITEM3", description = "SNK_ITEM3_D", price = 10},
    {name = "SNK_ITEM4", description = "SNK_ITEM4_D", price = 30},
    {name = "SNK_ITEM5", description = "SNK_ITEM5_D", price = 50},
    {name = "SNK_ITEM6", description = "SNK_ITEM6_D", price = 50} 
  }

  for k, item in pairs(ConvenienceStore) do
    local locked = false
    local thisItem = nil

    for i, inventory in pairs(inventoryItems) do
      if item.name == inventory.item then
        if inventory.total >= 9 then
          locked = true
        else
          locked = false
        end
      end
    end

    if not locked then
      thisItem = NativeUI.CreateItem(GetLabelText(item.name), GetLabelText(item.description))
      thisItem:RightLabel("$" .. item.price)
      thisItem:SetRightBadge(BadgeStyle.None)
    else
      thisItem = NativeUI.CreateItem(GetLabelText(item.name), GetLabelText("SNK_SOUT"))
      thisItem:SetRightBadge(BadgeStyle.Lock)
      
    end 

    thisItem.Activated = function(ParentMenu, SelectedItem)
      if SelectedItem == thisItem then
        if not locked then
          TriggerServerEvent("vf_convenience:item-selected", item.name, item.price)
          PlaySoundFrontend(-1, "PURCHASE", "HUD_LIQUOR_STORE_SOUNDSET", true)
          if not IsAnySpeechPlaying(storeKeeper) then
            PlayAmbientSpeech1(storeKeeper, "SHOP_SELL", "SPEECH_PARAMS_FORCE")
          end
        else
          PlayAmbientSpeech1(storeKeeper, "SHOP_OUT_OF_STOCK", "SPEECH_PARAMS_FORCE")
        end
      end
    end

    menu:AddItem(thisItem)    
  end
end

Citizen.CreateThread(function()
  while true do
    Wait(6)
    if DoesStoreMenuExist then
      _generalStorePool:ProcessMenus()
    end
  end
end)