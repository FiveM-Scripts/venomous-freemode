CinemaCoords = {
  {x = 300.788, y = 200.752, z = 104.385},
  {x = -1417.9776, y = -196.28897, z = 47.17192},
  {x = 302.907, y = 135.939, z = 160.946}
}

local screenModel = GetHashKey("v_ilev_cin_screen")
local interior = nil

function IsPlayerNearCinema()
	playerPed = PlayerPedId()

	for k,v in pairs(CinemaCoords) do
		cinema = GetDistanceBetweenCoords(GetEntityCoords(playerPed, true), v.x, v.y, v.z-1.0001, true)
		if cinema < 5.0 then
			return true
		end
	end
end

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

function TaskEnterCinema()
	local playerPed = PlayerPedId()

	DoScreenFadeOut(300)
	Wait(350)

	SetEntityVisible(playerPed, false, 0)
	SetEntityInvincible(playerPed, true)

	SetEntityCoords(playerPed, 320.1841, 262.1565, 82.9706-1.0001)
	SetEntityHeading(playerPed, 180.9706)
	SetFollowPedCamViewMode(4)

	interior = GetInteriorAtCoords(320.217, 263.81, 82.974)
	LoadInterior(interior)
	while not IsInteriorReady(interior) do
		Wait(1)
	end

	if not DoesEntityExist(cinemaScreen) then
		RequestModel(screenModel)
		while not HasModelLoaded(screenModel) do
			Wait(1)
		end

		cinemaScreen = CreateObjectNoOffset(screenModel, 320.1257, 248.6608, 86.56934, 1, true, false)
	else
		cinemaScreen = GetClosestObjectOfType(319.884, 262.103, 82.917, 20.475, screenModel, 0, 0, 0)
	end

	if cinemaScreen then
		local handle = CreateNamedRenderTargetForModel("cinscreen", screenModel)
		DoScreenFadeIn(200)

		return handle
	end
end

function TaskLeaveCinema(screenId)
	local playerPed = PlayerPedId()

	DoScreenFadeOut(500)
	while not IsScreenFadedOut() do
		Wait(20)
	end

	SetTvChannel(0)

	if IsNamedRendertargetRegistered(GetNamedRendertargetRenderId(GetHashKey(cinscreen))) then
		ReleaseNamedRendertarget(GetNamedRendertargetRenderId(GetHashKey(cinscreen)))
		SetTextRenderId(GetDefaultScriptRendertargetRenderId())
	end

	if DoesEntityExist(cinemaScreen) then
		DeleteEntity(cinemaScreen)
		cinemaScreen = nil
	end

	UnpinInterior(interior)
	SetEntityCoords(playerPed, oldCoords.x, oldCoords.y, oldCoords.z-1.0001)

	while not HasCollisionLoadedAroundEntity(playerPed) do
		Wait(100)
	end

	SetEntityVisible(playerPed, true, 0)
	SetEntityInvincible(playerPed, false)

	if IsScreenFadedOut() then
		DoScreenFadeIn(500)
	end
end