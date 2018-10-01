AppMissions = {
    AppName = GetLabelText("CELL_37"),
    AppIcon = 14
}
local phoneScaleform
local selectedItem

function AppMissions.Init(scaleform)
    phoneScaleform = scaleform
    selectedItem = 0
end

function AppMissions.Tick()
    PushScaleformMovieFunction(phoneScaleform, "SET_DATA_SLOT_EMPTY")
    PushScaleformMovieFunctionParameterInt(13)
    PopScaleformMovieFunctionVoid()

    for i, mission in ipairs(Missions) do
        PushScaleformMovieFunction(phoneScaleform, "SET_DATA_SLOT")
        PushScaleformMovieFunctionParameterInt(13)
        PushScaleformMovieFunctionParameterInt(i - 1)
        PushScaleformMovieFunctionParameterInt()
        if mission.MissionName then
            PushScaleformMovieFunctionParameterString(mission.MissionName)
        else
            PushScaleformMovieFunctionParameterString("Unnamed Mission")
        end
        PopScaleformMovieFunctionVoid()
    end

    PushScaleformMovieFunction(phoneScaleform, "DISPLAY_VIEW")
    PushScaleformMovieFunctionParameterInt(13)
    PushScaleformMovieFunctionParameterInt(selectedItem)

    local navigated = true
    if IsControlJustPressed(0, 300) then
        if selectedItem > 0 then
            selectedItem = selectedItem - 1
        else
            selectedItem = #Missions - 1
        end
    elseif IsControlJustPressed(0, 299) then
        if selectedItem < #Missions - 1 then
            selectedItem = selectedItem + 1
        else
            selectedItem = 0
        end
    elseif IsControlJustPressed(0, 255) then
        Missions.Start(selectedItem + 1)
    else
        navigated = false
    end
    if navigated then
        PlaySoundFrontend(-1, "Menu_Navigate", "Phone_SoundSet_Default")
    end
end

AddEventHandler("vf_phone:setup", function()
    TriggerEvent("vf_phone:addApp", AppMissions)
end)