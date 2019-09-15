Phone = {
    Visible = false,
    Theme = GetResourceKvpInt("vf_phone_theme"),
    Wallpaper = GetResourceKvpInt("vf_phone_wallpaper"),
    SleepMode = false,
    InApp = false
}

if Phone.Theme == 0 then
    Phone.Theme = 5
end
if Phone.Wallpaper == 0 then
    Phone.Wallpaper = 11
end

Citizen.CreateThread(function()
    while true do
        Wait(0)

        if Phone.Visible then
            SetPauseMenuActive(false)
            SetMobilePhonePosition(58.0, -21.0 - Phone.VisibleAnimProgress, -60.0)
            SetMobilePhoneRotation(-90.0, Phone.VisibleAnimProgress * 4.0, 0.0)
            if Phone.VisibleAnimProgress > 0 then
                Phone.VisibleAnimProgress = Phone.VisibleAnimProgress - 3
            end

            local h, m = NetworkGetServerTime()
            BeginScaleformMovieMethod(Phone.Scaleform, "SET_TITLEBAR_TIME")
            ScaleformMovieMethodAddParamInt(h)
            ScaleformMovieMethodAddParamInt(m)
            EndScaleformMovieMethod()

            BeginScaleformMovieMethod(Phone.Scaleform, "SET_SLEEP_MODE")
            ScaleformMovieMethodAddParamBool(Phone.SleepMode)
            EndScaleformMovieMethod()

            BeginScaleformMovieMethod(Phone.Scaleform, "SET_THEME")
            ScaleformMovieMethodAddParamInt(Phone.Theme)
            EndScaleformMovieMethod()

            BeginScaleformMovieMethod(Phone.Scaleform, "SET_BACKGROUND_IMAGE")
            ScaleformMovieMethodAddParamInt(Phone.Wallpaper)
            EndScaleformMovieMethod()

            BeginScaleformMovieMethod(Phone.Scaleform, "SET_SIGNAL_STRENGTH")
            ScaleformMovieMethodAddParamInt(GetZoneScumminess(GetZoneAtCoords(GetEntityCoords(PlayerPedId()))))
            EndScaleformMovieMethod()

            local renderID = GetMobilePhoneRenderId()
			SetTextRenderId(renderId)
			DrawScaleformMovie(Phone.Scaleform, 0.0998, 0.1775, 0.1983, 0.364, 255, 255, 255, 255);
            SetTextRenderId(1)
        elseif IsControlJustPressed(3, 27) then -- INPUT_PHONE (arrow up / mmb)
            PlaySoundFrontend(-1, "Pull_Out", "Phone_SoundSet_Default")
            Phone.Scaleform = RequestScaleformMovie("CELLPHONE_IFRUIT")
            while not HasScaleformMovieLoaded(Phone.Scaleform) do
                Wait(0)
            end
            Phone.VisibleAnimProgress = 21
            Phone.Visible = true
            SetMobilePhonePosition()
            SetMobilePhoneScale(285.0)
            CreateMobilePhone()
        end
    end
end)

function Phone.Kill()
    Apps.Kill()
    SetScaleformMovieAsNoLongerNeeded(Phone.Scaleform)
    Phone.Scaleform = nil
    Phone.Visible = false
    DestroyMobilePhone()

    -- Prevent esc from immediately opening the pause menu
    while IsControlPressed(3, 177) do
        Wait(0)
        SetPauseMenuActive(false)
    end
end