local warningDisplayed
warning = nil
deathscale = nil

function DisplayNotification(text)
    SetNotificationTextEntry("STRING")
    SetNotificationBackgroundColor(140)
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function DisplayNotificationWithImg(icon, type, sender, title, text, color)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    SetNotificationBackgroundColor(color)
    SetNotificationMessage(icon, icon, true, type, sender, title, text)
    DrawNotification(false, true)
    PlaySoundFrontend(GetSoundId(), "Text_Arrive_Tone", "Phone_SoundSet_Default", true)
end

function showLoadingPromt(label, time)
    Citizen.CreateThread(function()
        BeginTextCommandBusyString(tostring(label))
        EndTextCommandBusyString(3)
        Citizen.Wait(time)
        RemoveLoadingPrompt()
    end)
end

function SetButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

function SetButton(ControlButton)
    N_0xe83a3e3557a56640(ControlButton)
end

function RequestDeathScaleform()
    local deathform = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")
    Instructional = RequestScaleformMovie("instructional_buttons")
    while not HasScaleformMovieLoaded(deathform) do
    	Wait(500)
    end

    return deathform
end

function RequestDeathScreen()
	HideHudAndRadarThisFrame()
	
	if not locksound then
		ShakeGameplayCam("DEATH_FAIL_IN_EFFECT_SHAKE", 2.0)
		StartScreenEffect("DeathFailOut", 0, true)

		PlaySoundFrontend(-1, "Bed", "WastedSounds", 1)
		deathscale = RequestDeathScaleform()
		locksound = true
	end

	BeginScaleformMovieMethod(deathscale, "SHOW_WASTED_MP_MESSAGE")
    BeginTextCommandScaleformString("STRING")
    AddTextComponentSubstringTextLabel("RESPAWN_W")
    EndTextCommandScaleformString()
	
    BeginTextCommandScaleformString("AMHB_BYOUDIED")
    EndTextCommandScaleformString()
	
	PushScaleformMovieFunctionParameterFloat(105.0)
	PushScaleformMovieFunctionParameterBool(true)
	EndScaleformMovieMethod()

	SetScreenDrawPosition(0.00, 0.00)
	DrawScaleformMovieFullscreen(deathscale, 255, 255, 255, 255, 0)

    BeginScaleformMovieMethod(Instructional, "CLEAR_ALL")
    EndScaleformMovieMethod()
    
    BeginScaleformMovieMethod(Instructional, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(Instructional, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(2)
    SetButton(GetControlInstructionalButton(2, 329, true))
    SetButtonMessage(GetLabelText("HUD_INPUT27"))
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(Instructional, "DRAW_INSTRUCTIONAL_BUTTONS")
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(Instructional, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    EndScaleformMovieMethod()

    DrawScaleformMovieFullscreen(Instructional, 255, 255, 255, 255, 0)

	return deathscale
end

function SetPlayerScores(currentRankLimit, nextRankLimit, playersPreviousXP, playersCurrentXP, rank)
    if not HasHudScaleformLoaded(19) then
        RequestHudScaleform(19)
        Wait(200)
    end

    BeginScaleformMovieMethodHudComponent(19, "SET_RANK_SCORES")
    PushScaleformMovieFunctionParameterInt(currentRankLimit)
    PushScaleformMovieFunctionParameterInt(nextRankLimit)
    PushScaleformMovieFunctionParameterInt(playersPreviousXP)
    PushScaleformMovieFunctionParameterInt(playersCurrentXP)
    PushScaleformMovieFunctionParameterInt(rank)
    EndScaleformMovieMethodReturn()
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if IsPlayerSwitchInProgress() or hidehud then
            HideHudAndRadarThisFrame()
        end

        if HasHudScaleformLoaded(19) then
            BeginScaleformMovieMethodHudComponent(19, "OVERRIDE_ANIMATION_SPEED")
            PushScaleformMovieFunctionParameterInt(2000)
            EndScaleformMovieMethodReturn()

            BeginScaleformMovieMethodHudComponent(19, "SET_COLOUR")
            PushScaleformMovieFunctionParameterInt(116)
            PushScaleformMovieFunctionParameterInt(123)
            EndScaleformMovieMethodReturn()
        end
    end
end)