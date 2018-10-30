Apps = {}
local _SelectedItem
local _CurrentApp
local _CurrentScreen
local _PrevScreens

function Apps.Start(appId)
    if Apps[appId] and Apps[appId].LauncherScreen then
        _CurrentApp = Apps[appId]
        _CurrentScreen = Apps[appId].LauncherScreen
        _PrevScreens = {}
        _SelectedItem = 0
        Phone.InApp = true
        PlaySoundFrontend(-1, "Menu_Navigate", "Phone_SoundSet_Default")
    end
end

function Apps.Kill()
    Phone.InApp = false
    _CurrentApp = nil
    PlaySoundFrontend(-1, "Hang_Up", "Phone_SoundSet_Michael")
end

Citizen.CreateThread(function()
    while true do
        Wait(0)

        if _CurrentApp then
            if not _CurrentScreen then -- Revert back to existing screen if screen got removed
                if not _PrevScreens then -- Quit app if no screens exist
                    Apps.Kill()
                else
                    local screenFound = false
                    for _, screen in ipairs(_PrevScreens) do
                        if screen and not screenFound then
                            _CurrentScreen = screen
                            screenFound = true
                        end
                    end
                    if not screenFound then -- No existing screen found
                        Apps.Kill()
                    end
                end
            else
                PushScaleformMovieFunction(Phone.Scaleform, "SET_DATA_SLOT_EMPTY")
                PushScaleformMovieFunctionParameterInt(_CurrentScreen.Type)
                PopScaleformMovieFunctionVoid()

                local header
                if _CurrentScreen.Header then
                    header = _CurrentScreen.Header
                else
                    header = _CurrentApp.Name
                end
                PushScaleformMovieFunction(Phone.Scaleform, "SET_HEADER")
                PushScaleformMovieFunctionParameterString(header)
                PopScaleformMovieFunctionVoid()

                for i, item in ipairs(_CurrentScreen.Items) do
                    PushScaleformMovieFunction(Phone.Scaleform, "SET_DATA_SLOT")
                    PushScaleformMovieFunctionParameterInt(_CurrentScreen.Type)
                    PushScaleformMovieFunctionParameterInt(i - 1)
                    for _, data in ipairs(item.Data) do
                        if type(data) == "number" then
                            if math.type(data) == "integer" then
                                PushScaleformMovieFunctionParameterInt(data)
                            else
                                PushScaleformMovieFunctionParameterFloat(data)
                            end
                        elseif type(data) == "string" then
                            PushScaleformMovieFunctionParameterString(data)
                        elseif not data then
                            PushScaleformMovieFunctionParameterInt()
                        end
                    end
                    PopScaleformMovieFunctionVoid()
                end
            
                PushScaleformMovieFunction(Phone.Scaleform, "DISPLAY_VIEW")
                PushScaleformMovieFunctionParameterInt(_CurrentScreen.Type)
                PushScaleformMovieFunctionParameterInt(_SelectedItem)
            
                -- Fix _SelectedItem in case last item got removed while it was selected
                if _SelectedItem > #_CurrentScreen.Items - 1 then
                    _SelectedItem = #_CurrentScreen.Items - 1
                end

                local navigated = true
                if IsControlJustPressed(0, 300) then -- Up
                    _SelectedItem = _SelectedItem - 1
                    if _SelectedItem < 0 then
                        _SelectedItem = #_CurrentScreen.Items - 1
                    end
                elseif IsControlJustPressed(0, 299) then -- Down
                    _SelectedItem = _SelectedItem + 1
                    if _SelectedItem > #_CurrentScreen.Items - 1 then
                        _SelectedItem = 0
                    end
                elseif IsControlJustPressed(0, 255) then -- Enter
                    if #_CurrentScreen.Items > 0 then
                        local item = _CurrentScreen.Items[_SelectedItem + 1]
                        if type(item.Callback) == "table" then -- Action (Should be function, but it isn't because it's a table according to Msgpack!)
                            item.Callback()
                        elseif type(item.Callback) == "number" then -- Screen
                            table.insert(_PrevScreens, _CurrentScreen)
                            _CurrentScreen = _CurrentApp.Screens[item.Callback]
                            _SelectedItem = 0
                        end
                    end
                elseif IsControlJustPressed(0, 202) then -- Back
                    if #_PrevScreens > 0 then
                        _CurrentScreen = _PrevScreens[#_PrevScreens]
                        table.remove(_PrevScreens)
                        _SelectedItem = 0
                    else
                        Wait(0) -- Workaround to stop main app from registering back press too
                        Apps.Kill()
                        navigated = false
                    end
                else
                    navigated = false
                end
                if navigated then
                    PlaySoundFrontend(-1, "Menu_Navigate", "Phone_SoundSet_Default")
                end
            end
        end
    end
end)