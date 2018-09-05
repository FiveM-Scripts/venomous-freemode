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
        if App[i] and App[i].AppIcon then
            PushScaleformMovieFunctionParameterInt(App[i].AppIcon)
        else
            PushScaleformMovieFunctionParameterInt(3)
        end
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(Phone.Scaleform, "DISPLAY_VIEW")
        PushScaleformMovieFunctionParameterInt(1)
        PushScaleformMovieFunctionParameterInt(selectedItem)
        PopScaleformMovieFunctionVoid()
    end
end