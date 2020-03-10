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

Business = {}

function CreateNamedRenderTargetForModel(name, model)
	local handle = 0

	if not IsNamedRendertargetRegistered(name) then
		RegisterNamedRendertarget(name, 0)
	end

	if not IsNamedRendertargetLinked(model) then
		LinkNamedRendertarget(model)
	end

	if IsNamedRendertargetRegistered(name) then
		handle = GetNamedRendertargetRenderId(name)
	end

	return handle
end

function Business.CreateBlips()
	for k,v in pairs(Config.Locations) do
		local blipcoords = v["blip"]
		local blip = AddBlipForCoord(blipcoords.x, blipcoords.y, blipcoords.z)
		SetBlipSprite(blip, 475)
	end
end

function Business.LoadInterior(interiorID)
	ActivateInteriorEntitySet(interiorID, "office_chairs")
	ActivateInteriorEntitySet(interiorID, "office_booze")

	RefreshInterior(interiorID)
end

function Business.SetCompanyName(name)
	local model = GetHashKey("ex_prop_ex_office_text")
	banner = RequestScaleformMovie("ORGANISATION_NAME")
	while not HasScaleformMovieLoaded(banner) do
		Wait(0)
	end

	playerID = PlayerId()
	playerName = GetPlayerName(playerID)

	BeginScaleformMovieMethod(banner, "SET_ORGANISATION_NAME")
	ScaleformMovieMethodAddParamTextureNameString(tostring(name))

	ScaleformMovieMethodAddParamInt(-1) -- scale
	ScaleformMovieMethodAddParamInt(0) -- color
	ScaleformMovieMethodAddParamInt(2) -- font
	EndScaleformMovieMethod()
	
	local target = CreateNamedRenderTargetForModel("prop_ex_office_text", model)
	return target
end

function Business.CreateMarker(coords)
	for k,v in pairs(Config.Locations) do
		local ix, iy, iz = table.unpack(v["blip"])
		if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, ix, iy, iz, true) < 60.0 then
			DrawMarker(1, ix, iy, iz-1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 96, 62, 148, 200, 0, 0, 2, 0, 0, 0, 0)
		end
	end
end

function Business.IsPlayerNearOffice(coords)
	for k,v in pairs(Config.Locations) do
		local ix, iy, iz = table.unpack(v["blip"])
		if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, ix, iy, iz, true) < 2.0 then
			OfficeIpl = v["ipl"]
			Enterx, Entery, Enterz = table.unpack(v["spawnin"])
			return true
		end
	end
end

function Business.IsPlayerNearExit()
	for k,v in pairs(Config.Locations) do
		local ix, iy, iz = table.unpack(v["spawnout"])
		if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, ix, iy, iz, true) < 2.0 then
			return true
		end
	end
end

function Business.Enter(x, y, z, ipl)
	DoScreenFadeOut(500)

	RequestIpl(ipl)
	while not IsIplActive(ipl) do
		Wait(10)
	end

	interiorID = GetInteriorAtCoords(x, y, z)
	Business.LoadInterior(interiorID)
	Wait(2000)
	renderID = Business.SetCompanyName("Hello")

    SetEntityCoordsNoOffset(PlayerPedId(), x, y, z)
    Wait(2000)
    DoScreenFadeIn(700)
end

RegisterNetEvent('vf_businesses:GetData')
AddEventHandler('vf_businesses:GetData', function(data)
	if data then

	end
end)