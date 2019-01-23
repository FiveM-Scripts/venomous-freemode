local modeltypes = {"prop_vend_soda_01", "prop_vend_soda_02"}
local animDict = "mini@sprunk"

local IsPlayerNearVendingMachine = false
local IsInitMessageDisplayed = false

local playerPed = nil
local TempCan = nil

local function DisplayHelp(msg)
	BeginTextCommandDisplayHelp(msg)
	EndTextCommandDisplayHelp(0, 0, true, 2000)
end

Citizen.CreateThread(function()
	while true do
		Wait(5)
		playerPed = PlayerPedId()
		coords = GetEntityCoords(playerPed, true)
	end
end)

IsPedFacingPed(ped, otherPed, angle)

Citizen.CreateThread(function()
	while true do
		Wait(550)
		if not IsPlayerNearVendingMachine then
		    if not IsPedInAnyVehicle(playerPed, true) then
			    for k,v in pairs(modeltypes) do
			    	vending = GetClosestObjectOfType(coords, 1.75, GetHashKey(v), false)
			    	if DoesEntityExist(vending) then
			    	    currentVending = vending
   	    		   	    VendingX, VendingY, VendingZ = table.unpack(GetOffsetFromEntityInWorldCoords(currentVending, 0.0, -0.97, 0.0))

   	    		   	    vendingAnim = RequestAnimDict(animDict)
   	    		   	    while not HasAnimDictLoaded(animDict) do
   	    		   	    	Wait(1)
   	    		   	    end
   	    		   	    
   	    		   	    if GetEntityModel(vending) == GetHashKey("prop_vend_soda_01") then
   	    		   	        CanModel = GetHashKey("prop_ecola_can")
   	    		   	    elseif GetEntityModel(currentVending) == GetHashKey("prop_vend_soda_02") then
   	    		   	        CanModel = GetHashKey("prop_ld_can_01b") 
   	    		   	    end

   	    		   	    RequestModel(CanModel)
   	    		   	    while not HasModelLoaded(CanModel) do
   	    		   	    	Wait(1)
   	    		   	    end

			    	    IsPlayerNearVendingMachine = true
			    	end
			    end
			end	
		end

		if removeNow then
		   	RemoveAnimDict(animDict)
		   	SetModelAsNoLongerNeeded(CanModel)
		   	ReleaseAmbientAudioBank()

		   	IsInitMessageDisplayed = false
		   	removeNow = false
		end	

		if DoesEntityExist(currentVending) then
		    if GetDistanceBetweenCoords(coords, GetEntityCoords(currentVending, true), true) > 1.75 then
		        IsInitMessageDisplayed = false
		        IsPlayerNearVendingMachine = false
		    end
		end
	end
end)

RegisterNetEvent("vending:purchase")
AddEventHandler("vending:purchase", function(allowed)
	Citizen.CreateThread(function()
		ClearAllHelpMessages()

		if IsPlayerNearVendingMachine and allowed then
		    SetPlayerControl(PlayerId(), false, 256)
	    	RequestAmbientAudioBank("VENDING_MACHINE", 0)
	    	SetCurrentPedWeapon(playerPed, GetHashKey("weapon_unarmed"), true)
	    	
	    	boneIndex = GetPedBoneIndex(playerPed, 28422)
	   	    
	   	    TaskLookAtEntity(playerPed, currentVending, 2000, 2048, 2)
	   	    TaskGoStraightToCoord(playerPed, VendingX, VendingY, VendingZ, 1.0, 4000, GetEntityHeading(currentVending), 0.5)
	   	    Wait(2000)
		   	    
	   	    TempCan = CreateObject(CanModel, GetEntityCoords(currentVending, true), false, false, false)
	   	    TaskPlayAnim(playerPed, animDict, "plyr_buy_drink_pt1", 2.0, -4.0, -1, 1048576, 0, 0, 0, 0)
	   	    Wait(500)
	   	    AttachEntityToEntity(TempCan, playerPed, boneIndex, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)		   	
	   	end
	end)
end)

Citizen.CreateThread(function()
	while true do
		Wait(15)
		if IsPlayerNearVendingMachine then
		    if not IsInitMessageDisplayed then
		    	DisplayHelp("VENDHLP")
		    	IsInitMessageDisplayed = true
		    end

		    if IsControlJustPressed(0, 51) then
		    	TriggerServerEvent('vending:purchase')
		    end

		   	if IsEntityPlayingAnim(playerPed, animDict, "plyr_buy_drink_pt1", 3) then
		   		if GetEntityAnimCurrentTime(playerPed,animDict, "plyr_buy_drink_pt1") > 0.98 then
		   			if not IsEntityPlayingAnim(playerPed, animDict, "plyr_buy_drink_pt2", 3) then
		   				HintAmbientAudioBank("VENDING_MACHINE", 0)
		   				TaskPlayAnim(playerPed, animDict, "PLYR_BUY_DRINK_PT2", 4.0, -1000.0, -1, 1048576, 0.0, 0, 2052, 0)
		   				N_0x2208438012482a1a(playerPed, 0, 0)
		   			end
		   		end
		   	end

		   	if IsEntityPlayingAnim(playerPed, animDict, "plyr_buy_drink_pt2", 3) then
		   		if GetEntityAnimCurrentTime(playerPed,animDict, "plyr_buy_drink_pt2") > 0.10 then
		   			if not IsEntityPlayingAnim(playerPed, animDict, "plyr_buy_drink_pt3", 3) then
		   				Wait(300)
		   				TaskPlayAnim(playerPed, animDict, "PLYR_BUY_DRINK_PT3",  100.0, -4.0, -1, 2048624, 0.0, 0, 2048, 0)
		   				N_0x2208438012482a1a(playerPed, 0, 0)
		   				Wait(800)
		   				DeleteEntity(TempCan)
		   			end
		   		end
		   	end

		   	if IsEntityPlayingAnim(playerPed, animDict, "plyr_buy_drink_pt3", 3) then
		   		if GetEntityAnimCurrentTime(playerPed,animDict, "plyr_buy_drink_pt3") > 0.90 then
	   				SetPlayerControl(PlayerId(), true, 256)	
	   				DetachResult = DetachEntity(TempCan, false, true)
		   			SetEntityHealth(playerPed, GetPedMaxHealth(playerPed))
		   			removeNow = true
		   		end
		   	end		   	
		end
	end
end)