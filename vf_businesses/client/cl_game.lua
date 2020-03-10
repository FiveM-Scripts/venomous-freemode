--[[
            vf_businesses
            Copyright (C) 2020 FiveM-Scripts
              
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU Affero General Public License for more details.
You should have received a copy of the GNU Affero General Public License
along with vf_businesses in the file "LICENSE". If not, see <http://www.gnu.org/licenses/>.
]]

Citizen.CreateThread(function()
	while true do
		Wait(400)
		playerPed = PlayerPedId()
		coords = GetEntityCoords(playerPed, true)
		
		if coords then
			if Business.IsPlayerNearOffice(coords) then
				NearOffice = true
			else
				NearOffice = false
			end
		end
	end
end)

Citizen.CreateThread(function()
	Business.CreateBlips()
    while true do
        Wait(1)
        if coords then
        	Business.CreateMarker(coords)

        	if NearOffice then
        		if IsControlJustPressed(1, 38) then
        			oldPos = coords
        			Business.Enter(Enterx, Entery, Enterz, OfficeIpl)
        		end
            end

            if Business.IsPlayerNearExit() then
            	if not IsScreenFadingOut() then
            		DoScreenFadeOut(200)
            		Wait(400)
            		SetEntityCoords(playerPed, oldPos.x, oldPos.y, oldPos.z-1.0)
            		Wait(400)
            		DoScreenFadeIn(700)
            	end
            end
        end
    end
end)