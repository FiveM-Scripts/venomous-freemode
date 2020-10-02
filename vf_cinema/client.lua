--[[
            vf_cinema - Venomous Freemode - cinema resource
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

local DoesCinemaBlipsExist = false
local PlayerJoinedCinema = false
local IsMovieStarted = false

screenId = nil 
local function DisplayHelpNotification(text, costs)
	BeginTextCommandDisplayHelp(text)
    AddTextComponentSubstringPlayerName(subtext)
    AddTextComponentInteger(costs)
    EndTextCommandDisplayHelp(0, false, false, 5000)
end

function DisplayNotification(label)
  SetNotificationTextEntry(label)
  DrawNotification(false, false)
  PlaySoundFrontend(-1, "ERROR", "HUD_AMMO_SHOP_SOUNDSET", true)
end

RegisterNetEvent("vf_cinema:enter")
AddEventHandler("vf_cinema:enter", function(state)
	if state then
		Wait(1000)
		screenId = TaskEnterCinema()
		while not screenId do
			Wait(1)
		end

		PlayerJoinedCinema = true
	else
		DisplayNotification("BB_NOMONEY")
	end
end)

Citizen.CreateThread(function()
	SetPlayerControl(PlayerId(), true, 0)
	while true do
		Wait(0)
		if NetworkIsGameInProgress() and IsPlayerPlaying(PlayerId()) then
			PlayerPed = PlayerPedId()

			if not DoesCinemaBlipsExist then
				for k,v in pairs(CinemaCoords) do
					local blip = AddBlipForCoord(v.x, v.y, v.z)
					SetBlipSprite(blip, 135)
					SetBlipAsShortRange(blip, true)
				end
				DoesCinemaBlipsExist = true
			end

			if not IsPedInAnyVehicle(PlayerPed, false) then
				if IsPlayerNearCinema() then
					local hour = GetClockHours()

					if hour < tonumber(10) or hour > tonumber(22) then
						DisplayHelpNotification("TIMCINMULTI")
					else
						DisplayHelpNotification("ACTCIN", 10)
						if IsControlJustPressed(1, 51) then
							oldCoords = GetEntityCoords(PlayerPed, true)
							TriggerServerEvent('vf_cinema:watch', 10)
						end
					end
				end
			end

			if PlayerJoinedCinema then
				if IsEntityDead(PlayerPed) then
					SetEntityInvincible(PlayerPed, false)
					SetEntityVisible(PlayerPed, true, 0)
				end

				if not IsMovieStarted then
					N_0x2201c576facaebe8(2, "PL_CINEMA_MULTIPLAYER", 10)
					SetTvChannel(2)
					SetTvVolume(-5.0)
					SetCurrentPedWeapon(PlayerPed, GetHashKey("weapon_unarmed"), true)
					
					EnableMovieSubtitles(0)
					IsMovieStarted = true
				else

					HideHudAndRadarThisFrame()
				    
				    DisableControlAction(0, 24,  true)
				    DisableControlAction(0, 25,  true)
				    DisableControlAction(0, 142, true)
				    DisableControlAction(0, 225, true)
				    DisableControlAction(0, 30,  true)
				    DisableControlAction(0, 31,  true)

					if IsControlJustPressed(1, 177) then
						TaskLeaveCinema(screenId)
						N_0x74c180030fde4b69(0)

						IsMovieStarted = false
						PlayerJoinedCinema = false
						cinemaScreen = nil
					end
				end
				
				SetTextRenderId(screenId)
				Set_2dLayer(4)

				Citizen.InvokeNative(0xC6372ECD45D73BCD, true)
				DrawTvChannel(0.5, 0.5, 1.0, 1.0, 0.0, 255, 255, 255, 255)
				SetTextRenderId(GetDefaultScriptRendertargetRenderId())
			end
		end
	end
end)
