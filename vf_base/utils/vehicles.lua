function DestroyPV(personalVeh)
	if DoesEntityExist(personalVeh) then
		if DoesBlipExist(pvBlip) then
			RemoveBlip(pvBlip)
		end

		if IsPedInVehicle(PlayerPedId(), personalVeh, false) then
			TaskEveryoneLeaveVehicle(personalVeh)
			TaskLeaveVehicle(PlayerPedId(), personalVeh, 0)
		end

		Wait(5000)
        SetEntityAsNoLongerNeeded(personalVeh)
        personalVeh = nil
    else
        DisplayNotification(GetLabelText("PIM_HEMV1"))
    end
end

function RequestPV(vehicleHash)
	local modelHash = vehicleHash
	local playerPed = PlayerPedId()

	if IsModelValid(modelHash) then
		RequestModel(modelHash)
		while not HasModelLoaded(modelHash) do
			Wait(500)
		end

		local x,y,z = table.unpack(GetEntityCoords(playerPed, true))
		local _, vector = GetNthClosestVehicleNodeWithHeading(x, y, z, math.random(5, 10), 0, 0, 0)
		local SpawnX, SpawnY, SpawnZ, SpawnH = table.unpack(vector)

		if not IsThisModelAPlane(modelHash) then
			veh = CreateVehicle(modelHash, SpawnX, SpawnY, SpawnZ, SpawnH, true, false)
			while not DoesEntityExist(veh) do
				Wait(200)
			end

			SetEntityHeading(veh, SpawnH)
		else
			veh = CreateVehicle(modelHash, x, y, z+395.0, SpawnH, true, false)
			while not DoesEntityExist(veh) do
				Wait(200)
			end

			SetHeliBladesFullSpeed(veh)
			TaskWarpPedIntoVehicle(playerPed, veh, -1)
		end

		if DoesEntityExist(veh) then
			if not DoesBlipExist(pvBlip) then
				pvBlip = AddBlipForEntity(veh)
				if IsThisModelAPlane(modelHash) then
					SetBlipSprite(pvBlip, 16)
				elseif IsThisModelAHeli(modelHash) then
					SetBlipSprite(pvBlip, 43)
				else
					SetBlipSprite(pvBlip, 225)
				end

				SetBlipNameFromTextFile(pvBlip, "PVEHICLE")
				SetBlipColour(pvBlip, 4)

				SetBlipFlashes(pvBlip, true)
				SetBlipFlashTimer(pvBlip, 10000)
			end

			DecorSetBool(veh, "vf_personalvehicle", true)

			SetModelAsNoLongerNeeded(modelHash)
			DisplayNotificationWithImg('CHAR_MECHANIC', 6,  GetLabelText("CELL_180"), GetLabelText("EMSTR_481"), GetLabelText("EPS_CAR_TITLE"), 140)
			return veh
		end
	end
end