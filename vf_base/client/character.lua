RegisterNetEvent("freemode:NoCharacter")
AddEventHandler("freemode:NoCharacter", function()
	warning = CreateWarningMessage(GetLabelText("HUD_CONNPROB"), GetLabelText("TRAN_NOCHAR"))
	local IsTeleported = false
	while HasScaleformMovieLoaded(warning) and not IsTeleported do
		if IsControlJustPressed(0, 201) then
			EnterCharacterCreator()
		end

		Citizen.Wait(1)
	end
end)

RegisterNetEvent("freemode:CreateCharacter")
AddEventHandler("freemode:CreateCharacter", function()
	EnterCharacterCreator()
end)

function EnterCharacterCreator()
	if IsPlayerSwitchInProgress() then
		SetEntityCoords(PlayerPedId(), 403.006225894, -996.8715, -99.00)
		SetEntityHeading(PlayerPedId(), 182.65637207031)
		Citizen.Wait(5000)
	end

	N_0xd8295af639fd9cb8(PlayerPedId())
end