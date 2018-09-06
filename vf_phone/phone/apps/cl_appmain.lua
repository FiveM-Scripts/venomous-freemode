AppMain = {}
local selectedItem = 4

function AppMain.Init()
    
end

function AppMain.Tick()
    for i = 1, 10 do
        PushScaleformMovieFunction(Phone.Scaleform, "SET_DATA_SLOT")
        PushScaleformMovieFunctionParameterInt(1)
        PushScaleformMovieFunctionParameterInt(i - 1)
        if Apps[i] and Apps[i].AppIcon then
            PushScaleformMovieFunctionParameterInt(Apps[i].AppIcon)
        else
            PushScaleformMovieFunctionParameterInt(3)
        end
        PopScaleformMovieFunctionVoid()
    end

    PushScaleformMovieFunction(Phone.Scaleform, "DISPLAY_VIEW")
    PushScaleformMovieFunctionParameterInt(1)
    PushScaleformMovieFunctionParameterInt(selectedItem)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(Phone.Scaleform, "SET_HEADER")
    if Apps[selectedItem + 1] and Apps[selectedItem + 1].AppName then
        PushScaleformMovieFunctionParameterString(Apps[selectedItem + 1].AppName)
    else
        PushScaleformMovieFunctionParameterString("")
    end
    PopScaleformMovieFunctionVoid()

    local navigated = true
    if IsControlJustPressed(0, 300) then
        selectedItem = selectedItem - 3
        if selectedItem < 0 then
            selectedItem = 9 + selectedItem
        end
    elseif IsControlJustPressed(0, 299) then
        selectedItem = selectedItem + 3
        if selectedItem > 8 then
            selectedItem = selectedItem - 9
        end
    elseif IsControlJustPressed(0, 307) then
        selectedItem = selectedItem + 1
        if selectedItem > 8 then
            selectedItem = 0
        end
    elseif IsControlJustPressed(0, 308) then
        selectedItem = selectedItem - 1
        if selectedItem < 0 then
            selectedItem = 8
        end
    elseif IsControlJustPressed(0, 255) then
        Apps.Start(selectedItem + 1)
    else
        navigated = false
    end
    if navigated then
        PlaySoundFrontend(-1, "Menu_Navigate", "Phone_SoundSet_Default")
    end
end