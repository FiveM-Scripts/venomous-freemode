local DoesInteractionMenuExist = false
personalVeh = nil

function AddInterActionMenu(menu)
    local newitem = UIMenuItem.New(GetLabelText("PM_SETTING_10"), '')
    menu:AddItem(newitem)
    newitem.Activated = function(ParentMenu, SelectedItem)
        if SelectedItem == newitem then
            menu:Visible(not menu:Visible())
            SetEntityHealth(PlayerPedId(), 0)
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
        GetLabelText("PM_UCON_LCK")
    }

    vehItem = NativeUI.CreateListItem(GetLabelText("PIM_TRPV"), personalVehicles, 1, GetLabelText("MPCT_PERVEH1B"))
    submenu:AddItem(vehItem)

    vehAirItem = NativeUI.CreateListItem(GetLabelText("PIM_TRPA"), personalAirVehs, 1, GetLabelText("MPCT_PERVEH1B"))
    submenu:AddItem(vehAirItem)

    DestroyVeh = UIMenuItem.New(GetLabelText("PIM_TA16"), "")
    submenu:AddItem(DestroyVeh)
    DestroyVeh.Activated = function(ParentMenu, SelectedItem)
        if SelectedItem == DestroyVeh then
            DestroyPV(personalVeh)
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
                quantity = item:IndexToItem(index)
                personalVeh = RequestPV(quantity)
            else
                DisplayNotification(GetLabelText("PIM_HRPV9"))
            end
        elseif item == vehAirItem then
            if not DoesEntityExist(personalVeh) then
                quantity = item:IndexToItem(index)
                personalVeh = RequestPV(quantity)
            else
                DisplayNotification(GetLabelText("PIM_HRPV9"))
            end
        elseif item == vehDoorsItem then
            quantity = item:IndexToItem(index)
        end
    end

    local vehRepair = UIMenuItem.New(GetLabelText("BLIP_544"), "")
    vehRepair:RightLabel('$ ' .. '50')
    submenu:AddItem(vehRepair)

    vehRepair.Activated = function(ParentMenu, SelectedItem)
        if SelectedItem == vehRepair then
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                currentVeh = GetVehiclePedIsUsing(PlayerPedId())
                SetVehicleFixed(currentVeh)               
            else
                DisplayNotification(GetLabelText("PIM_HEMV1"))
            end
        end
    end
end

Citizen.CreateThread(function()
	while true do
		Wait(1)
        if NetworkIsGameInProgress() and IsPlayerPlaying(PlayerId()) then
            playerID = PlayerId()
            playerName = GetPlayerName(playerID)
            playerPed = PlayerPedId()

            if not DoesInteractionMenuExist then
                DecorRegister("vf_personalvehicle", 2)

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

    end
end)