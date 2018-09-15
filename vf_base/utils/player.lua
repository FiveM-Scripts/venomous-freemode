function generateSpawn()
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
		
		if IsPedMale(playerPed) then
			SetPedComponentVariation(PlayerPedId(), 0, math.random(0, 5), 0, 2)
			SetPedComponentVariation(PlayerPedId(), 2, math.random(1, 17), 3, 2)
			SetPedComponentVariation(PlayerPedId(), 3, 164, 0, 2)

			SetPedComponentVariation(PlayerPedId(), 4, 1, math.random(2), 2)
			SetPedComponentVariation(PlayerPedId(), 6, math.random(0, 6), 0, 2)
			SetPedComponentVariation(PlayerPedId(), 10, 7, 0, 2)

			SetPedComponentVariation(PlayerPedId(), 8, 0, 240, 0)
			SetPedComponentVariation(PlayerPedId(), 11, 0, 240, 0)
			SetPedHairColor(PlayerPedId(), math.random(1, 4), 1)
		else
			SetPedComponentVariation(PlayerPedId(), 0, 0, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 2, math.random(1, 17), 3, 2)
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 4, 1, math.random(2), 2)
			SetPedComponentVariation(PlayerPedId(), 6, math.random(0, 6), 0, 2)

			SetPedComponentVariation(PlayerPedId(), 8, 2, 2, 2)
			SetPedComponentVariation(PlayerPedId(), 10, 7, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 11, 0, 2, 2)
			
			SetPedHairColor(PlayerPedId(), math.random(1, 4), 1)
		end

		SetModelAsNoLongerNeeded(modelhash)
	end
end
