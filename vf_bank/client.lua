local modeltypes = {'prop_fleeca_atm', 'prop_atm_01', 'prop_atm_02', 'prop_atm_03'}
local playerPed = nil

local ShowError = false
local errorType = nil

IsPlayerUsingAtm = false

local tipTime = 10000
local tipInterval = 60000
local bankText = "FM_IHELP_TEN"

local anim = "mini@atmenter"

function DisplayTransActionTask(time)
    BeginTextCommandBusyString("HUD_TRANSP")
    EndTextCommandBusyString(4)
    Wait(2000)
    RemoveLoadingPrompt()
end

local function DisplayHelpLabel(label, sublabel, time)
  ClearBrief()
  ClearAllHelpMessages()
  
  BeginTextCommandDisplayHelp(label)
  if sublabel then
     AddTextComponentSubstringPlayerName(sublabel)
  end

  if time then
  	displayTime = time
  else
  	displayTime = 3000
  end
  EndTextCommandDisplayHelp(0, 0, 0, displayTime)
end

RegisterNUICallback('close', function(data, cb)
	FreezeEntityPosition(PlayerPedId(), false)

	RequestAnimDict("mini@atmexit")
	while not HasAnimDictLoaded("mini@atmexit") do
		Wait(1)
	end

	TaskPlayAnim(playerPed, "mini@atmexit", "exit", 8.0, 1.0, -1, 0, 0.0, 0, 0, 0)
	RemoveAnimDict(animDict)
	Wait(500)

	IsPlayerUsingAtm = false
	SetNuiFocus(false)	
end)

RegisterNUICallback('navigate', function(data, cb)
    PlaySoundFrontend(-1, "PIN_BUTTON", "ATM_SOUNDS", true)
end)

RegisterNUICallback('deposit', function(data, cb)
	if data.param then
		if tonumber(CashAmount) >= tonumber(data.param) then
			DisplayTransActionTask(5000)
			TriggerServerEvent('vf_bank:deposit', data.param)

			Wait(2000)
			RemoveLoadingPrompt()			
		else
			TriggerEvent('vf_bank:DisplayError', 'MPATM_NODO')
		end
	end
end)

RegisterNUICallback('whitdraw', function(data, cb)
	if data.param then
		if tonumber(BankAmount) >= tonumber(data.param) then
			DisplayTransActionTask(5000)
			TriggerServerEvent('vf_bank:whitdraw', data.param)
			Wait(2000)
			RemoveLoadingPrompt()
		else
			TriggerEvent('vf_bank:DisplayError', 'MPATM_NODO2')
		end
	end
end)

RegisterNetEvent("vf_bank:DisplayError")
AddEventHandler("vf_bank:DisplayError", function(msg)
   SetNuiFocus(false)
   SendNUIMessage({type = 'close'})
   errorType = tostring(msg)
   ShowError = true
end)

Citizen.CreateThread(function()
	SetNuiFocus(false)
	SendNUIMessage({type = 'close'})

	while true do
		Wait(550)
		playerPed = PlayerPedId()
		x,y,z = table.unpack(GetEntityCoords(playerPed, true))
		IsPlayerInVehicle = IsPedInAnyVehicle(playerPed, true)

		something, CashAmount = StatGetInt("MP0_WALLET_BALANCE",-1)
		something2, BankAmount = StatGetInt("BANK_BALANCE",-1)

		if not IsPlayerNearAtm then
			if not IsPlayerInVehicle then
				for k,v in pairs(modeltypes) do
					atm = GetClosestObjectOfType(x, y, z, 0.75, GetHashKey(v), false)
					if DoesEntityExist(atm) then
						currentAtm = atm
						atmX, atmY, atmZ = table.unpack(GetOffsetFromEntityInWorldCoords(currentAtm, 0.0, -0.65, 0.0))
						IsPlayerNearAtm = true
					end
				end
			end
		else
			if not DoesEntityExist(currentAtm) then
				IsPlayerNearAtm = false
			else
				if GetDistanceBetweenCoords(x,y,z, atmX, atmY, atmZ, true) > 2.0 then
					IsPlayerNearAtm = false
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(10)

		if IsPlayerNearAtm then
			if not IsPlayerUsingAtm then
				DisplayHelpLabel("FINH_ATMNEAR", "~INPUT_CONTEXT~")
			else
				ClearAllHelpMessages()				
				DisableControlAction(0, 201, true)
				DisableControlAction(1, 201, true)				
			end

			if IsControlJustPressed(0, 51) then	
				RequestAnimDict("mini@atmbase")		
				RequestAnimDict(anim)
				while not HasAnimDictLoaded(anim) do
					Wait(1)
				end

				SetCurrentPedWeapon(playerPed, GetHashKey("weapon_unarmed"), true)
				TaskLookAtEntity(playerPed, currentAtm, 2000, 2048, 2)
				Wait(500)
				TaskGoStraightToCoord(playerPed, atmX, atmY, atmZ, 0.1, 4000, GetEntityHeading(currentAtm), 0.5)				
				Wait(2000)
				TaskPlayAnim(playerPed, anim, "enter", 8.0, 1.0, -1, 0, 0.0, 0, 0, 0)
				RemoveAnimDict(animDict)
				Wait(4000)
				TaskPlayAnim(playerPed, "mini@atmbase", "base", 8.0, 1.0, -1, 0, 0.0, 0, 0, 0)
				RemoveAnimDict("mini@atmbase")				
				Wait(1000)
				player = PlayerId()
				PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
				FreezeEntityPosition(playerPed, true)

				customButton = GetLabelText("FACE_F_P_CUST")
				amountHolder = GetLabelText("PIM_GPIA")
				menuButton = GetLabelText("MPATM_MENU")
				DepositHelper = GetLabelText("MPATM_DITMT")
				WhitDrawtHelper = GetLabelText("MPATM_WITMT")
				serviceHelper = GetLabelText("MPATM_SER")
				BalanceHelper = GetLabelText("MPATM_ACBA")
				DepositMenu = GetLabelText("MPATM_DIDM")
				WhitdrawMenu = GetLabelText("MPATM_WITM")
				confirmHelper = GetLabelText("FM_CSC_QUIT")

				transMenu = GetLabelText("MPATM_LOG")
				exitButton = GetLabelText("MPATM_EXIT")
				total = CashAmount + BankAmount
			
				SetNuiFocus(true, true)
				SendNUIMessage({ type = 'open', 
					            amountHelper = amountHolder,
					            customHelper = customButton,
					             playerName = GetPlayerName(player),
					             totalMoney = total,
					             serviceHelper = serviceHelper,
					             menuButton = menuButton,
					             BalanceTitle = BalanceHelper,
					             DepositMenu = DepositMenu,
					             WhitdrawMenu = WhitdrawMenu,
					             transMenu = transMenu,
					             exitButton = exitButton,
					             DepositHelp = DepositHelper,
					             ConfirmMenu = confirmHelper,
					             WhitDrawtHelper = WhitDrawtHelper
					            })
				IsPlayerUsingAtm = true
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(1)
		if ShowError then
			if errorType then
				SetWarningMessageWithHeader("GLOBAL_ALERT_DEFAULT", errorType, 2, 0, 0, -1, 0, 1, 1)
			end

			if IsControlJustPressed(2, 191) then
				SetNuiFocus(true, true)
				SendNUIMessage({ type = 'open',
					             amountHelper = amountHolder,
					             customHelper = customButton,
					             playerName = GetPlayerName(player),
					             totalMoney = total,
					             serviceHelper = serviceHelper,
					             menuButton = menuButton,
					             BalanceTitle = BalanceHelper,
					             DepositMenu = DepositMenu,
					             WhitdrawMenu = WhitdrawMenu,
					             transMenu = transMenu,
					             exitButton = exitButton,
					             DepositHelp = DepositHelper,
					             ConfirmMenu = confirmHelper,
					             WhitDrawtHelper = WhitDrawtHelper
					            })
				ShowError = false
				IsPlayerUsingAtm = true
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(520000)
		if not IsPlayerUsingAtm then
			if CashAmount >= 5000 then
				DisplayHelpLabel(bankText)
			end
		else
			ClearAllHelpMessages()			
		end
	end
end)