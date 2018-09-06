AppSettings = {
    AppName = "Settings",
    AppIcon = 24
}

local settings = {
    ["Theme"] = true
}
local selectedItem

function AppSettings.Init()
    PushScaleformMovieFunction(Phone.Scaleform, "SET_DATA_SLOT_EMPTY")
    PushScaleformMovieFunctionParameterInt(13)
    PopScaleformMovieFunctionVoid()
    selectedItem = 0
end

function AppSettings.Tick()
    local i = 0
    for settingName, settingContent in pairs(settings) do
        PushScaleformMovieFunction(Phone.Scaleform, "SET_DATA_SLOT")
        PushScaleformMovieFunctionParameterInt(13)
        PushScaleformMovieFunctionParameterInt(i)
        PushScaleformMovieFunctionParameterInt(-1)
        PushScaleformMovieFunctionParameterString(settingName)
        PopScaleformMovieFunctionVoid()
        i = i + 1
    end

    PushScaleformMovieFunction(Phone.Scaleform, "DISPLAY_VIEW")
    PushScaleformMovieFunctionParameterInt(13)
    PushScaleformMovieFunctionParameterInt(selectedItem)
end