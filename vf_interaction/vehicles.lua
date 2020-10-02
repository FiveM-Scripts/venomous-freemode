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

Vehicles = {}

function Vehicles.Request(vehicleHash)
	local modelHash = vehicleHash
	local playerPed = PlayerPedId()

	if IsModelValid(modelHash) then
		RequestModel(modelHash)
		while not HasModelLoaded(modelHash) do
			Wait(10)
		end

		local x,y,z = table.unpack(GetEntityCoords(playerPed, true))
		local _, vector = GetNthClosestVehicleNodeWithHeading(x, y, z, math.random(5, 10), 0, 0, 0)
		local SpawnX, SpawnY, SpawnZ, SpawnH = table.unpack(vector)

		if not IsThisModelAPlane(modelHash) then
			veh = CreateVehicle(modelHash, SpawnX, SpawnY, SpawnZ, SpawnH, true, false)
			while not DoesEntityExist(veh) do
				Wait(10)
			end

			SetEntityHeading(veh, SpawnH)
		else
			veh = CreateVehicle(modelHash, x, y, z+395.0, SpawnH, true, false)
			while not DoesEntityExist(veh) do
				Wait(10)
			end

			SetHeliBladesFullSpeed(veh)
		end		

		if DoesEntityExist(veh) then
			SetVehicleHasBeenOwnedByPlayer(veh, true)

			if not DoesBlipExist(pvBlip) then
				pvBlip = AddBlipForEntity(veh)
				if IsThisModelAPlane(modelHash) then
					SetBlipSprite(pvBlip, 16)
				elseif IsThisModelAHeli(modelHash) then
					SetBlipSprite(pvBlip, 43)
				elseif IsThisModelABoat(modelHash) then
					SetBlipSprite(pvBlip, 427)
				elseif IsThisModelABike(modelHash) then
					SetBlipSprite(pvBlip, 226)
				else
					SetBlipSprite(pvBlip, 225)
				end

				SetBlipNameFromTextFile(pvBlip, "PVEHICLE")
				SetBlipColour(pvBlip, 4)

				SetBlipFlashes(pvBlip, true)
				SetBlipFlashTimer(pvBlip, 7000)
			end
			SetVehicleEngineOn(veh, true,  true, true)
			TaskWarpPedIntoVehicle(playerPed, veh, -1)

			SetModelAsNoLongerNeeded(modelHash)
			return veh
		end		
	end
end

function Vehicles.Destroy(personalVeh)
	if DoesEntityExist(personalVeh) then
		if DoesBlipExist(pvBlip) then
				RemoveBlip(pvBlip)
		end

		if IsPedInVehicle(PlayerPedId(), personalVeh, false) then
			TaskEveryoneLeaveVehicle(personalVeh)
			TaskLeaveVehicle(PlayerPedId(), personalVeh, 0)
			Wait(2000)
		end		
		DeleteEntity(personalVeh)
		personalVeh = nil
	else
		DisplayNotification(GetLabelText("PIM_HEMV1"))
	end
end

function Vehicles.Impound(personalVeh)
	SetEntityCoords(personalVeh, 420.705, -1638.87, 29.2919, 0.0, 0.0, 0.0, true)
end