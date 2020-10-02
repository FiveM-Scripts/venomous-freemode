--[[
            vf_interaction - Venomous Freemode - interaction menu
              Copyright (C) 2018-2020  FiveM-Scripts

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program in the file "LICENSE".  If not, see <http://www.gnu.org/licenses/>.
]]

firstTickPassed = false
inventoryItems = {}
local bodyarm = 1
local currentWalkStyle = 1

RegisterNetEvent('vf_inventory:queryClient')
AddEventHandler('vf_inventory:queryClient', function(array)
    inventoryItems = {}
    inventoryItems = array
    firstTickPassed = true
end)

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
    local normal = GetLabelText("MO_GFX_NORM")
    local femme = GetLabelText("PM_WALK_1")
    local gangster = GetLabelText("collision_8axpk3h")
    local tough = GetLabelText("collision_9y6p771")
    local posh = GetLabelText("collision_9y6p770")

    local walkStyles = {normal, femme, gangster, posh, tough}

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

    WalkStyle = NativeUI.CreateListItem(GetLabelText("PIM_TWALKN"), walkStyles, currentWalkStyle, GetLabelText("PIM_HWALKN"))
    menu:AddItem(WalkStyle)  
    menu.OnListChange = function(sender, item, index)
        if item == WalkStyle then
            local wType = item:IndexToItem(index)
            if wType == normal then 
                if IsPedMale(PlayerPedId()) then
                    clipSet = "MOVE_P_M_ONE"
                else
                    clipSet = "MOVE_P_M_ONE"
                end
                currentWalkStyle = 1
            elseif wType == femme then
                if IsPedMale(PlayerPedId()) then
                    clipSet = "MOVE_M@FEMME@"
                else
                    clipSet = "MOVE_F@FEMME@"
                end
                currentWalkStyle = 2
            elseif wType == gangster then
                if IsPedMale(PlayerPedId()) then
                    clipSet = "MOVE_M@GANGSTER@NG"
                else
                    clipSet = "MOVE_F@GANGSTER@NG"
                end
                currentWalkStyle = 3
            elseif wType == posh then
                if IsPedMale(PlayerPedId()) then
                    clipSet = "MOVE_M@POSH@"
                else
                    clipSet = "MOVE_F@POSH@"
                end
                currentWalkStyle = 4
            elseif wType == tough then
                if IsPedMale(PlayerPedId()) then
                    clipSet = "MOVE_M@TOUGH_GUY@"
                else
                    clipSet = "MOVE_F@TOUGH_GUY@"
                end
                currentWalkStyle = 5
            end

            RequestClipSet(clipSet)
            while not HasClipSetLoaded(clipSet) do
                Citizen.Wait(1)
            end

            SetPedMovementClipset(PlayerPedId(), clipSet, 1048576000)
            RemoveClipSet(clipSet)
        end
    end
 
end

function GeneralInventoryMenu(menu)
    InvMenu = _menuPool:AddSubMenu(menu, GetLabelText("PIM_TINVE"), GetLabelText("PIM_INVOFF"))
    local foods = {GetLabelText("PM_DISPLAY_3"), GetLabelText("WT_BA_0"), GetLabelText("WT_BA_1"), GetLabelText("WT_BA_2"), GetLabelText("WT_BA_3"), GetLabelText("WT_BA_4")}
    local newitem = NativeUI.CreateListItem(GetLabelText("WT_BA"), foods, bodyarm, GetLabelText("PIM_HARMO"))
    InvMenu:AddItem(newitem)
    InvMenu.OnListChange = function(sender, item, index)
        if item == newitem then
            local SelectedItem = item:IndexToItem(index)
            if SelectedItem == GetLabelText("PM_DISPLAY_3") then
                bodyarm = 1
                SetPedComponentVariation(PlayerPedId(), 9, 0, 0, 0)
            elseif SelectedItem == GetLabelText("WT_BA_0") then
                bodyarm = 2
                SetPedComponentVariation(PlayerPedId(), 9, 17, 0, 0)
            elseif SelectedItem == GetLabelText("WT_BA_1") then
                bodyarm = 3
                SetPedComponentVariation(PlayerPedId(), 9, 1, 0, 0)
            elseif SelectedItem == GetLabelText("WT_BA_2") then
                bodyarm = 4
                SetPedComponentVariation(PlayerPedId(), 9, 1, 1, 0)
            elseif SelectedItem == GetLabelText("WT_BA_3") then
                bodyarm = 5
                SetPedComponentVariation(PlayerPedId(), 9, 15, 1, 0)
            elseif SelectedItem == GetLabelText("WT_BA_4") then
                bodyarm = 6
                SetPedComponentVariation(PlayerPedId(), 9, 28, 0, 0)
            end            
        end
    end
end

function SnacksInventoryMenu(menu)
    Wait(100)
    Snacksmenu = _menuPool:AddSubMenu(menu, GetLabelText("ACCNA_SNACK"), GetLabelText("PIM_HSNAC"))
    if #inventoryItems < 1 then
        local thisItem = NativeUI.CreateItem(GetLabelText("JIPMP_NA"), "")
        Snacksmenu:AddItem(thisItem)
    else
        for k,v in pairs(inventoryItems) do
            local totalItems = v.total
            local thisItem = NativeUI.CreateItem(tostring(GetLabelText(v.item)), "")

            thisItem:RightLabel(v.total)
            thisItem.Activated = function(ParentMenu, SelectedItem)
                if SelectedItem == thisItem then
                    if  totalItems > 0 then 
                        totalItems = totalItems - 1
                        thisItem:RightLabel(totalItems)
                        TriggerServerEvent('vf_base:UpdateInventory', v.item)

                        if totalItems < 1 then
                            thisItem:SetRightBadge(BadgeStyle.Lock)
                            thisItem:RightLabel('')
                        end

                        if v.item == "SNK_ITEM4" then
                            if not IsPedInAnyVehicle(PlayerPedId(), false) then
                                TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_SMOKING", 5000, true)
                            end
                        else
                            if not IsEntityDead(PlayerPedId()) then
                                local health = GetEntityHealth(PlayerPedId())
                                uHealth = health + GetRandomIntInRange(10, 20)
                                SetEntityHealth(PlayerPedId(), uHealth)
                                ClearPedTasks(PlayerPedId())
                            end
                        end
                    end
                end
            end

            Snacksmenu:AddItem(thisItem)
        end
    end
end

function VehiclesInventoryMenu(menu)
    Vehmenu = _menuPool:AddSubMenu(menu, GetLabelText("VEX_NMB"))
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
    Vehmenu:AddItem(vehItem)

    vehAirItem = NativeUI.CreateListItem(GetLabelText("PIM_TRPA"), personalAirVehs, 1, GetLabelText("MPCT_PERVEH1B"))
    Vehmenu:AddItem(vehAirItem)

    DestroyVeh = UIMenuItem.New(GetLabelText("PIM_TA16"), "")
    Vehmenu:AddItem(DestroyVeh)
    DestroyVeh.Activated = function(ParentMenu, SelectedItem)
        if SelectedItem == DestroyVeh then
            Vehicles.Destroy(personalVeh)
        end
    end

    emptyVeh = UIMenuItem.New(GetLabelText("PIM_TEMV"), GetLabelText("PIM_HEMV0"))
    Vehmenu:AddItem(emptyVeh)
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
    Vehmenu:AddItem(vehDoorsItem)

    Vehmenu.OnListSelect = function(sender, item, index)
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
                    if GetVehicleDoorAngleRatio(personalVeh, 1) > 0.0 then
                        SetVehicleDoorShut(personalVeh, 1, false)
                    else
                        SetVehicleDoorOpen(personalVeh, 1, false, false)
                    end
                elseif Selected == tostring(GetLabelText("CMM_MOD_S12")) then
                    if GetVehicleDoorAngleRatio(personalVeh, 5) > 0.0 then
                        SetVehicleDoorShut(personalVeh, 5, false)
                    else
                        SetVehicleDoorOpen(personalVeh, 5, false, false)
                    end

                elseif Selected == tostring(GetLabelText("CMOD_MOD_HOD")) then
                    if GetVehicleDoorAngleRatio(personalVeh, 4) > 0.0 then
                        SetVehicleDoorShut(personalVeh, 4, false)
                    else
                        SetVehicleDoorOpen(personalVeh, 4, false, false)
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
    Vehmenu:AddItem(vehRepair)

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
    firstTickPassed = true
    while true do
        Wait(250)
        if DoesEntityExist(personalVeh) then
            if GetVehicleEngineHealth(personalVeh) == 0 then
                Vehicles.Destroy(personalVeh)
            else
                if IsPedInVehicle(PlayerPedId() , personalVeh, true) then
                    vehicle = GetVehiclePedIsUsing(PlayerPedId())
                    if DoesBlipExist(GetBlipFromEntity(vehicle)) then                        
                        SetBlipDisplay(GetBlipFromEntity(vehicle), 0)
                    end
                else
                    vehicleC = GetEntityCoords(personalVeh, true)
                    if DoesBlipExist(pvBlip) then
                        SetBlipDisplay(pvBlip, 2)
                    end
                end
            end
        end

        if IsPedUsingScenario(PlayerPedId(), "WORLD_HUMAN_SMOKING") then
            if not IsEntityDead(PlayerPedId()) then
                Wait(9000)
                local health = GetEntityHealth(PlayerPedId())
                uHealth = health - 10
                SetEntityHealth(PlayerPedId(), uHealth)
            end

            Wait(5000)
            ClearPedTasks(PlayerPedId())
            Wait(2000)
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

    Wait(500)

    while true do
        Wait(10)
        if firstTickPassed then
            coords = GetEntityCoords(PlayerPedId(), true)

            if not DoesInteractionMenuExist then
                if IsControlJustPressed(1, 244) then                    
                    inventoryItems = exports.vf_base:GetInventory()
                    _menuPool = MenuPool.New()
                    mainMenu = UIMenu.New(playerName, "~b~" .. GetLabelText("INPUT_INTERACTION_MENU"))
                    _menuPool:Add(mainMenu)

                    AddInterActionMenu(mainMenu)
                    GeneralInventoryMenu(mainMenu)
                    SnacksInventoryMenu(InvMenu)
                    VehiclesInventoryMenu(mainMenu)

                    _menuPool:RefreshIndex()
                    _menuPool:MouseControlsEnabled(false)

                    mainMenu:Visible(not mainMenu:Visible())
                    DoesInteractionMenuExist = true
                end
            else
                _menuPool:ProcessMenus()

                if mainMenu:Visible() or InvMenu:Visible() or Snacksmenu:Visible() or Vehmenu:Visible() then

                else
                    _menuPool:CloseAllMenus()
                     _menuPool:Remove()
                    DoesInteractionMenuExist = false
                end
            end
        end

    end
end)