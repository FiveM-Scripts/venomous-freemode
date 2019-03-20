DoesInteractionMenuExist = false
IsPlayerNearImpoundGate = false
personalVeh = nil
gateBlip = nil
gateHash = "prop_facgate_08"
playerPed = nil

function DisplayWarning(text)
    BeginTextCommandDisplayHelp(text)
    EndTextCommandDisplayHelp(0, 0, 0, 8000)
end

function DisplayNotification(text)
    SetNotificationTextEntry("STRING")
    SetNotificationBackgroundColor(140)
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function AddInterActionMenu(menu)
    local newitem = UIMenuItem.New(GetLabelText("PM_SETTING_10"), '')
    menu:AddItem(newitem)
    newitem.Activated = function(ParentMenu, SelectedItem)
        if SelectedItem == newitem then
            menu:Visible(not menu:Visible())
            SetEntityHealth(PlayerPedId(), 0)
        end
    end

    local newitem = UIMenuItem.New(GetLabelText("GC_MENU26"), "")
    newitem:RightLabel('$ ' .. Costs.clear_wanted_level)
    menu:AddItem(newitem)
    newitem.Activated = function(ParentMenu, SelectedItem)
        if SelectedItem == newitem then
            if IsPlayerWantedLevelGreater(PlayerId(), 0) then
                local something, CashAmount = StatGetInt("MP0_WALLET_BALANCE",-1)
                if tonumber(CashAmount) >= Costs.clear_wanted_level then
                    ClearPlayerWantedLevel(PlayerId())
                    TriggerServerEvent('vf_interaction:pay', Costs.clear_wanted_level)
                    DisplayNotification(GetLabelText("FMMC_LOST_WANTED_LEVEL"))
                else
                    DisplayNotification(GetLabelText("BB_NOMONEY"))
                end
            else
                DisplayNotification(GetLabelText("CHEAT_WANTED_DOWN_DENIED"))
            end
        end
    end  
end

function VehiclesInventoryMenu(menu)
    local submenu = _menuPool:AddSubMenu(menu, GetLabelText("VEX_NMB"))
    local personalVehicles = DefaultVehicles

    local personalAirVehs = {
        "lazer",
    }

    local engineStatus = {
        GetLabelText("BIK_AGPOS_ON"),
        GetLabelText("BIK_AGPOS_OFF")
    }

    local doorStatus = {
        GetLabelText("BM_UNLOCKED"),
        GetLabelText("PM_UCON_LCK"),
        GetLabelText("CMM_MOD_ST28"),
        GetLabelText("CMM_MOD_S12"),
        GetLabelText("CMOD_MOD_HOD"),
        GetLabelText("PM_CJACK_1")
    }

    vehItem = NativeUI.CreateListItem(GetLabelText("PIM_TRPV"), personalVehicles, 1, GetLabelText("MPCT_PERVEH1B"))
    submenu:AddItem(vehItem)

    vehAirItem = NativeUI.CreateListItem(GetLabelText("PIM_TRPA"), personalAirVehs, 1, GetLabelText("MPCT_PERVEH1B"))
    submenu:AddItem(vehAirItem)

    DestroyVeh = UIMenuItem.New(GetLabelText("PIM_TA16"), "")
    submenu:AddItem(DestroyVeh)
    DestroyVeh.Activated = function(ParentMenu, SelectedItem)
        if SelectedItem == DestroyVeh then
            Vehicles.Destroy(personalVeh)
        end
    end

    emptyVeh = UIMenuItem.New(GetLabelText("PIM_TEMV"), GetLabelText("PIM_HEMV0"))
    submenu:AddItem(emptyVeh)
    emptyVeh.Activated = function(ParentMenu, SelectedItem)
        if SelectedItem == emptyVeh then
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                currentVeh = GetVehiclePedIsUsing(PlayerPedId())
                TaskEveryoneLeaveVehicle(currentVeh)
            else
                DisplayNotification(GetLabelText("PIM_HEMV1"))
            end
        end
    end    

    vehDoorsItem = NativeUI.CreateListItem(GetLabelText("PIM_TDPV"), doorStatus, 1, "")
    submenu:AddItem(vehDoorsItem)

    submenu.OnListSelect = function(sender, item, index)
        if item == vehItem then
            if not DoesEntityExist(personalVeh) then
                Selected = item:IndexToItem(index)
                personalVeh = Vehicles.Request(Selected)
            else
                DisplayNotification(GetLabelText("PIM_HRPV9"))
            end
        elseif item == vehAirItem then
            if not DoesEntityExist(personalVeh) then
                Selected = item:IndexToItem(index)
                personalVeh = Vehicles.Request(Selected)
            else
                DisplayNotification(GetLabelText("PIM_HRPV9"))
            end
        elseif item == vehDoorsItem then
            Selected = item:IndexToItem(index)
                if Selected == tostring(GetLabelText("PM_UCON_LCK")) then
                    SetVehicleDoorsLocked(personalVeh, 2)
                    SetVehicleDoorsLockedForAllPlayers(personalVeh, 0)
                elseif Selected == tostring(GetLabelText("CMM_MOD_ST28")) then
                   SetVehicleDoorOpen(personalVeh, 1, false, false)
                elseif Selected == tostring(GetLabelText("CMM_MOD_S12")) then
                    if IsVehicleDoorFullyOpen(personalVeh, 5) then
                        print('Close ' .. GetLabelText("CMM_MOD_S12"))
                        SetVehicleDoorShut(personalVeh, 5, false)
                    else
                        SetVehicleDoorOpen(personalVeh, 5, false, false)
                    end

                elseif Selected == tostring(GetLabelText("PM_CJACK_1")) then
                    SetVehicleDoorsShut(personalVeh, false)
                else
                    SetVehicleDoorsLocked(personalVeh, 1)
                    DisplayNotification(GetLabelText("PIM_TDPV") .. " " .. GetLabelText("PM_UCON_ULK"))
                end           
            end
        end

    local vehRepair = UIMenuItem.New(GetLabelText("BLIP_544"), "")
    vehRepair:RightLabel('$ ' .. Costs.repair_vehicle)
    submenu:AddItem(vehRepair)

    vehRepair.Activated = function(ParentMenu, SelectedItem)
        if SelectedItem == vehRepair then            
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                local something, CashAmount = StatGetInt("MP0_WALLET_BALANCE",-1)
                if CashAmount >= tonumber(50) then
                    currentVeh = GetVehiclePedIsUsing(PlayerPedId())
                    SetVehicleFixed(currentVeh)
                    TriggerServerEvent('vf_interaction:pay', tonumber(Costs.repair_vehicle))
                    DisplayNotification("~g~" .. GetLabelText("FM_BET_VEH") .. " " ..GetLabelText("ITEM_REPAIR"))
                else
                    DisplayNotification(GetLabelText("BB_NOMONEY"))
                end
            else
                DisplayNotification(GetLabelText("PIM_HEMV1"))
            end
        end
    end
end

Citizen.CreateThread(function()    
    ClearPrints()
    ClearAllHelpMessages()

    while true do
        Wait(250)
        if DoesEntityExist(personalVeh) then
            if GetVehicleEngineHealth(personalVeh) == 0 then
                Vehicles.Destroy(personalVeh)
            else
                if IsPedInVehicle(PlayerPedId() , personalVeh, true) then
                    SetBlipDisplay(pvBlip, 0)
                else
                    vehicleC = GetEntityCoords(personalVeh, true)
                    if DoesBlipExist(pvBlip) then
                        SetBlipDisplay(pvBlip, 2)
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    local CAT = 'mod_mnu'
    local CurrentSlot = 0
    while HasAdditionalTextLoaded(CurrentSlot) and not HasThisAdditionalTextLoaded(CAT, CurrentSlot) do
        Wait(0)
        CurrentSlot = CurrentSlot + 1
    end

    if not HasThisAdditionalTextLoaded(CAT, CurrentSlot) then
        ClearAdditionalText(CurrentSlot, true)
        RequestAdditionalText(CAT, CurrentSlot)
        while not HasThisAdditionalTextLoaded(CAT, CurrentSlot) do
            Citizen.Wait(0)
        end
    end

    playerID = PlayerId()
    playerName = GetPlayerName(playerID)
    playerPed = PlayerPedId()    

    while true do
        Wait(10)
        if not DoesInteractionMenuExist then
            _menuPool = MenuPool.New()
            mainMenu = UIMenu.New(playerName, "~b~" .. GetLabelText("INPUT_INTERACTION_MENU"))
            _menuPool:Add(mainMenu)

            AddInterActionMenu(mainMenu)
            VehiclesInventoryMenu(mainMenu)

            _menuPool:RefreshIndex()
            _menuPool:MouseControlsEnabled(false)
            DoesInteractionMenuExist = true
        end

        _menuPool:ProcessMenus()
        if IsControlJustPressed(1, 244) then
            mainMenu:Visible(not mainMenu:Visible())
        end
    end
end)