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

function CreateWarningMessage(title, text, subtext)
    Warningbutton = RequestScaleformMovie("instructional_buttons")
    while not HasScaleformMovieLoaded(Warningbutton) do
        Citizen.Wait(0)
    end

   PushScaleformMovieFunction(Warningbutton, "CLEAR_ALL")
   PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(Warningbutton, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(Warningbutton, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    SetButton(GetControlInstructionalButton(2, 191, true))
    SetButtonMessage(GetLabelText("HUD_CONTINUE"))
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(Warningbutton, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    local popup = RequestScaleformMovie("POPUP_WARNING")
    while not HasScaleformMovieLoaded(popup) do
        Citizen.Wait(1)
    end

    PushScaleformMovieFunction(popup, "SHOW_POPUP_WARNING")
    PushScaleformMovieFunctionParameterFloat(500.0)
    PushScaleformMovieFunctionParameterString(tostring(title))
    PushScaleformMovieFunctionParameterString(tostring(text))

    if subtext then
        PushScaleformMovieFunctionParameterString(tostring(subtext))
    else
        PushScaleformMovieFunctionParameterString("")
    end

    PushScaleformMovieFunctionParameterBool(true)
    PushScaleformMovieFunctionParameterInt(0)

    PopScaleformMovieFunctionVoid()
    PlaySoundFrontend(-1, "CHALLENGE_UNLOCKED", "HUD_AWARDS", true)

    return popup
end

function DisplayWarningMessage(warning)
    ClearAllHelpMessages()
    HideHudAndRadarThisFrame()
    DrawScaleformMovieFullscreen(warning, 255, 255, 255, 255, 0)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if IsPlayerSwitchInProgress() or hidehud then
            HideHudAndRadarThisFrame()
        end

        if HasScaleformMovieLoaded(warning) then
            DisplayWarningMessage(warning)
            if HasScaleformMovieLoaded(Warningbutton) then
                DrawScaleformMovieFullscreen(Warningbutton, 255, 255, 255, 255, 0)
            end

            DisableControlAction(0, 106, true)

            if IsControlJustPressed(0, 201) then
                PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                SetScaleformMovieAsNoLongerNeeded(Warningbutton)
                SetScaleformMovieAsNoLongerNeeded(warning)
            end
        end
    end
end)