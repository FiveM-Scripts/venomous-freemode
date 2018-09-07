firstTick = false

AddEventHandler('onClientGameTypeStart', function()
	local spawnPos = generateSpawn()
    
    exports.spawnmanager:setAutoSpawnCallback(function()
        exports.spawnmanager:spawnPlayer({
            x = spawnPos.x,
            y = spawnPos.y,
            z = spawnPos.z,
            model = 'mp_m_freemode_01'
        })
    end)

    exports.spawnmanager:setAutoSpawn(true)
    exports.spawnmanager:forceRespawn()
end)

AddEventHandler('playerSpawned', function(spawn)
	local playerPed = PlayerPedId()
	if not IsPlayerSwitchInProgress() then
		SetManualShutdownLoadingScreenNui(true)
		SwitchOutPlayer(playerPed, 0, 1)
	end
	
	if IsPedModel(playerPed, "mp_m_freemode_01") then
		SetPedComponentVariation(playerPed, 0, math.random(0, 1), 0, 2)
		SetPedComponentVariation(playerPed, 2, math.random(1, 17), math.random(3, 6), 2)
		SetPedComponentVariation(playerPed, 3, 164, 0, 2)

		SetPedComponentVariation(playerPed, 4, 1, math.random(2), 2)
		SetPedComponentVariation(playerPed, 6, math.random(0, 6), 0, 2)
		SetPedComponentVariation(playerPed, 10, 7, 0, 2)
		SetPedComponentVariation(playerPed, 11, 0, 11, 2)
	end

	exports.spawnmanager:setAutoSpawn(false)
	firstTick = true

	if IsPlayerSwitchInProgress() then
		showLoadingPromt("PCARD_JOIN_GAME", 8000)		
		Citizen.Wait(8000)
		TriggerServerEvent('freemode:GetPlayerCharacters')
	end
end)


Citizen.CreateThread(function()
	while true do
		Wait(1)
		if firstTick then
			if GetEntityHealth(PlayerPedId()) <= 0 or IsEntityDead(PlayerPedId()) then
				deathscale = RequestDeathScreen()

				if IsControlJustPressed(0, 24) and HasScaleformMovieLoaded(deathscale) then
					DoScreenFadeOut(800)
					while not IsScreenFadedOut() do
						HideHudAndRadarThisFrame()
						Citizen.Wait(1)
					end

					local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
					local _, vector = GetNthClosestVehicleNode(x, y, z, math.random(20, 180), 0, 0, 0)
					success, vec3 = GetSafeCoordForPed(vector.x, vector.y, vector.z, false, 28)
					heading = 0

					if success then
						x, y, z = table.unpack(vec3)
					else
						local temp = generateSpawn()
						x, y, z = temp.x, temp.y, temp.z
					end

					NetworkResurrectLocalPlayer(x, y, z, 0.0, true, false)
					ClearPedBloodDamage(PlayerPedId())
					ClearPedWetness(PlayerPedId())
					StopScreenEffect("DeathFailOut")

					SetScaleformMovieAsNoLongerNeeded(deathscale)
					SetScaleformMovieAsNoLongerNeeded(Instructional)					

					DoScreenFadeIn(800)
					while not IsScreenFadedIn() do
						Citizen.Wait(0)
					end
					locksound = false
				end
			else
				if HasScaleformMovieLoaded(deathscale) then
					StopScreenEffect("DeathFailOut")
					locksound = false

					SetScaleformMovieAsNoLongerNeeded(Instructional)
					SetScaleformMovieAsNoLongerNeeded(deathscale)
				end
			end
		end
	end
end)