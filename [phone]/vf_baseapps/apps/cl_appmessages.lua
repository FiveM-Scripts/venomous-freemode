AppMessages = {
    AppName = GetLabelText("CELL_1"),
    AppIcon = 4
}
local phoneScaleform
local selectedItem

function AppMessages.Init(scaleform)
    phoneScaleform = scaleform
    selectedItem = 0
end

function AppMessages.Tick()
    PushScaleformMovieFunction(phoneScaleform, "SET_DATA_SLOT_EMPTY")
    PushScaleformMovieFunctionParameterInt(13)
    PopScaleformMovieFunctionVoid()

    local players = {}
    for i = 0, 64 do
        if NetworkIsPlayerConnected(i) then
            PushScaleformMovieFunction(phoneScaleform, "SET_DATA_SLOT")
            PushScaleformMovieFunctionParameterInt(13)
            PushScaleformMovieFunctionParameterInt(i)
            PushScaleformMovieFunctionParameterInt()
            PushScaleformMovieFunctionParameterString(GetPlayerName(i))
            PopScaleformMovieFunctionVoid()

            table.insert(players, i)
        end
    end

    PushScaleformMovieFunction(phoneScaleform, "DISPLAY_VIEW")
    PushScaleformMovieFunctionParameterInt(13)
    PushScaleformMovieFunctionParameterInt(selectedItem)

    local navigated = true
    if IsControlJustPressed(0, 300) then
        if selectedItem > 0 then
            selectedItem = selectedItem - 1
        else
            selectedItem = #players - 1
        end
    elseif IsControlJustPressed(0, 299) then
        if selectedItem < #players - 1 then
            selectedItem = selectedItem + 1
        else
            selectedItem = 0
        end
    elseif IsControlJustPressed(0, 255) then
        
    else
        navigated = false
    end
    if navigated then
        PlaySoundFrontend(-1, "Menu_Navigate", "Phone_SoundSet_Default")
    end
end

AddEventHandler("vf_phone:setup", function()
    TriggerEvent("vf_phone:addApp", AppMessages)
end)