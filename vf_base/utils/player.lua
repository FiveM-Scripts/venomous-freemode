function generateSpawn()
	math.randomseed(GetGameTimer())
    local keys = {}

    for key, value in pairs(SpawnLocations) do
        keys[#keys+1] = key
    end
   
    index = keys[math.random(1, #keys)]
    return SpawnLocations[index]
end

function GetRandomMultiPlayerModel(modelhash)
	local playerPed = PlayerPedId()

	if IsModelValid(modelhash) then
		if not IsPedModel(playerPed, modelHash) then
			RequestModel(modelhash)
			while not HasModelLoaded(modelhash) do
				Wait(500)
			end

			SetPlayerModel(PlayerId(), modelhash)
		end

		SetPedHeadBlendData(PlayerPedId(), 0, math.random(45), 0,math.random(45), math.random(5), math.random(5),1.0,1.0,1.0,true)
		SetPedHairColor(PlayerPedId(), math.random(1, 4), 1)
		
		if IsPedMale(PlayerPedId()) then
			SetPedComponentVariation(PlayerPedId(), 0, math.random(0, 5), 0, 2)
			SetPedComponentVariation(PlayerPedId(), 2, math.random(1, 17), 3, 2)
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)

			SetPedComponentVariation(PlayerPedId(), 4, 1, math.random(0, 15), 2)
			SetPedComponentVariation(PlayerPedId(), 6, 3, math.random(0, 15), 2)
			SetPedComponentVariation(PlayerPedId(), 8, 0, 240, 0)
			SetPedComponentVariation(PlayerPedId(), 10, 0, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 11, 0, math.random(0, 5), 0)			
		else
			SetPedComponentVariation(PlayerPedId(), 0, 0, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 2, math.random(1, 17), 3, 2)
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 4, 1, math.random(2), 2)
			SetPedComponentVariation(PlayerPedId(), 6, math.random(0, 6), 0, 2)

			SetPedComponentVariation(PlayerPedId(), 8, 2, 2, 2)
			SetPedComponentVariation(PlayerPedId(), 10, 7, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 11, 0, 2, 2)
		end

		SetModelAsNoLongerNeeded(modelhash)
	end
end

RegisterNetEvent("vf_base:DisplayCashValue")
AddEventHandler("vf_base:DisplayCashValue", function(value)
	StatSetInt("MP0_WALLET_BALANCE", value, false)
	ShowHudComponentThisFrame(4)
	CancelEvent()
end)

RegisterNetEvent("vf_base:DisplayBankValue")
AddEventHandler("vf_base:DisplayBankValue", function(value)
	StatSetInt("BANK_BALANCE", value, true)
	ShowHudComponentThisFrame(3)	
	CancelEvent()
end)