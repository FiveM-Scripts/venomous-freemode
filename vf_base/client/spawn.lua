firstTick = false
local ShowLoadingScreen = true
local spawnPos = generateSpawn()

AddEventHandler('onClientGameTypeStart', function()
	exports.spawnmanager:setAutoSpawnCallback(function()
		exports.spawnmanager:spawnPlayer({x = spawnPos.x, y = spawnPos.y, z = spawnPos.z-1.0, model = 'mp_m_freemode_01'})
    end)

    exports.spawnmanager:setAutoSpawn(true)
    exports.spawnmanager:forceRespawn()
end)

AddEventHandler('playerSpawned', function(spawn)
	local playerPed = PlayerPedId()
	while not HasCollisionLoadedAroundEntity(playerPed) do
		Wait(1)
	end
	
	Wait(300)
	
	if not IsPlayerSwitchInProgress() and ShowLoadingScreen then
		SwitchOutPlayer(playerPed, 32, 1)
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

	if IsPlayerSwitchInProgress() then
		showLoadingPromt("PCARD_JOIN_GAME", 8000)
		TriggerServerEvent('vf_base:LoadPlayer')
		Citizen.Wait(8000)
		TriggerServerEvent('vf_base:GetPlayerCharacters')
	end

	firstTick = true
	exports.spawnmanager:setAutoSpawn(false)
end)

Citizen.CreateThread(function()
	while true do
		Wait(1)
		if NetworkIsGameInProgress() and firstTick then
			if IsControlJustPressed(0, 20) then
				ShowHudComponentThisFrame(3)
				ShowHudComponentThisFrame(4)

				if not HasHudScaleformLoaded(19) then
					RequestHudScaleform(19)
					Wait(100)
				end
				
				BeginScaleformMovieMethodHudComponent(19, "SHOW")
				EndScaleformMovieMethodReturn()
			end

			if DoesEntityExist(personalVeh) then
				if DecorExistOn(personalVeh, "vf_personalvehicle") then
					if IsPedInVehicle(PlayerPedId(), personalVeh, false) then
						local blip = GetBlipFromEntity(personalVeh)
						if DoesBlipExist(blip) then
							RemoveBlip(blip)
						end
					else
						if not DoesBlipExist(pvBlip) then
							pvModel = GetEntityModel(personalVeh)
							pvBlip = AddBlipForEntity(personalVeh)

							if IsThisModelAPlane(pvModel) then
								SetBlipSprite(pvBlip, 16)
							elseif IsThisModelAHeli(pvModel) then
								SetBlipSprite(pvBlip, 43)
							else
								SetBlipSprite(pvBlip, 225)
							end

							SetBlipNameFromTextFile(pvBlip, "PVEHICLE")
							SetBlipColour(pvBlip, 4)

							SetBlipFlashes(pvBlip, true)
							SetBlipFlashTimer(pvBlip, 10000)
						end
					end
				end
			end			

			if GetEntityHealth(PlayerPedId()) <= 0 or IsEntityDead(PlayerPedId()) then
				deathscale = RequestDeathScreen()

				if HasScaleformMovieLoaded(deathscale) then
					if IsControlJustPressed(0, 24) then
						DoScreenFadeOut(500)
						while not IsScreenFadedOut() do
							HideHudAndRadarThisFrame()
							Wait(500)
						end

						if DoesEntityExist(personalVeh) then
							if DecorExistOn(personalVeh, "vf_personalvehicle") then
								DestroyPV(personalVeh)
							end
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

						NetworkResurrectLocalPlayer(x, y, z-1.0, 0.0, true, false)
						ClearPedBloodDamage(PlayerPedId())
						ClearPedWetness(PlayerPedId())
						StopScreenEffect("DeathFailOut")

						SetScaleformMovieAsNoLongerNeeded(deathscale)
						SetScaleformMovieAsNoLongerNeeded(Instructional)

						Wait(800)
						DoScreenFadeIn(500)

						locksound = false
					end
				end
			end
		end
	end
end)