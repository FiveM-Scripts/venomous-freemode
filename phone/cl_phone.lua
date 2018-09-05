Phone = {
    Visible = false
}

Citizen.CreateThread(function()
    while true do
        Wait(0)

        if Phone.Visible then
            SetMobilePhonePosition(58.0, -21.0 - Phone.VisibleAnimProgress, -60.0)
            SetMobilePhoneRotation(-90.0, Phone.VisibleAnimProgress * 4.0, 0.0)
            if Phone.VisibleAnimProgress > 0 then
                Phone.VisibleAnimProgress = Phone.VisibleAnimProgress - 3
            end

            local h, m, s = NetworkGetServerTime()
            PushScaleformMovieFunction(Phone.Scaleform, "SET_TITLEBAR_TIME")
            PushScaleformMovieFunctionParameterInt(h)
            PushScaleformMovieFunctionParameterInt(m)
            PopScaleformMovieFunctionVoid()

            PushScaleformMovieFunction(Phone.Scaleform, "SET_SLEEP_MODE")
            PushScaleformMovieFunctionParameterBool(false)
            PopScaleformMovieFunctionVoid()

            PushScaleformMovieFunction(Phone.Scaleform, "SET_BACKGROUND_IMAGE")
            PushScaleformMovieFunctionParameterInt(5)
            PopScaleformMovieFunctionVoid()

            PushScaleformMovieFunction(Phone.Scaleform, "SET_THEME")
            PushScaleformMovieFunctionParameterInt(5)
            PopScaleformMovieFunctionVoid()

            PushScaleformMovieFunction(Phone.Scaleform, "SET_SIGNAL_STRENGTH")
            PushScaleformMovieFunctionParameterInt(GetZoneScumminess(GetZoneAtCoords(GetEntityCoords(PlayerPedId()))))
            PopScaleformMovieFunctionVoid()

            local renderID = GetMobilePhoneRenderId()
			SetTextRenderId(renderId)
			DrawScaleformMovie(Phone.Scaleform, 0.0998, 0.1775, 0.1983, 0.364, 255, 255, 255, 255);
            SetTextRenderId(1)
            
            if IsControlJustPressed(0, 202) and (not Apps.CurrentApp or not Apps.CurrentApp.OverrideBack) then
                Phone.Kill()
            end
        elseif IsControlJustPressed(0, 300) then
            PlaySoundFrontend(-1, "Pull_Out", "Phone_SoundSet_Default")
            Phone.Scaleform = RequestScaleformMovie("CELLPHONE_IFRUIT")
            while not HasScaleformMovieLoaded(Phone.Scaleform) do
                Wait(0)
            end
            Phone.VisibleAnimProgress = 21
            Phone.Visible = true
            SetMobilePhoneScale(285.0)
            CreateMobilePhone(0)
            Apps.Start("main")
        end

        --[[for i = 0, 1000 do
            if IsControlJustPressed(0, i) then
                print(i)
            end
        end]]--
    end
end)

function Phone.Kill()
    PlaySoundFrontend(-1, "Hang_Up", "Phone_SoundSet_Michael")
    Apps.Kill()
    SetScaleformMovieAsNoLongerNeeded(Phone.Scaleform)
    Phone.Scaleform = nil
    Phone.Visible = false
    DestroyMobilePhone()
end