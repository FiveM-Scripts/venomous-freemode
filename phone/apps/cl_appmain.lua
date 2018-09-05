AppMain = {}
local selectedItem

function AppMain.Init()
    selectedItem = 4
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

        PushScaleformMovieFunction(Phone.Scaleform, "DISPLAY_VIEW")
        PushScaleformMovieFunctionParameterInt(1)
        PushScaleformMovieFunctionParameterInt(selectedItem)
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(Phone.Scaleform, "SET_HEADER")
        if Apps[i] and Apps[i].AppName then
            PushScaleformMovieFunctionParameterString(Apps[i].AppName)
        else
            PushScaleformMovieFunctionParameterString("")
        end
        PopScaleformMovieFunctionVoid()

        if IsControlJustPressed(0, 300) then
            selectedItem = selectedItem - 3
			if selectedItem < 0 then
                selectedItem = 9 + selectedItem
            end
        elseif IsControlJustPressed(0, 299) then
            selectedItem = selectedItem + 3
			if selectedItem > 9 then
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
        end
    end
end