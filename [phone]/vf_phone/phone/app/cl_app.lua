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

        PlaySoundFrontend(-1, "Menu_Accept", "Phone_SoundSet_Michael")
    end
end

function Apps.Kill()
    Phone.InApp = false
    _CurrentApp = nil

    PlaySoundFrontend(-1, "Menu_Back", "Phone_SoundSet_Michael")
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
                BeginScaleformMovieMethod(Phone.Scaleform, "SET_DATA_SLOT_EMPTY")
                ScaleformMovieMethodAddParamInt(_CurrentScreen.Type)
                EndScaleformMovieMethod()

                local header = ""
                if _CurrentScreen.Header then
                    header = _CurrentScreen.Header
                elseif _CurrentApp.Name then
                    header = _CurrentApp.Name
                end

                BeginScaleformMovieMethod(Phone.Scaleform, "SET_HEADER")
                ScaleformMovieMethodAddParamPlayerNameString(header)
                EndScaleformMovieMethod()

                for i, item in ipairs(_CurrentScreen.Items) do
                    BeginScaleformMovieMethod(Phone.Scaleform, "SET_DATA_SLOT")

                    ScaleformMovieMethodAddParamInt(_CurrentScreen.Type)
                    ScaleformMovieMethodAddParamInt(i - 1)

                    for _, data in ipairs(item.Data) do
                        if type(data) == "number" then
                            if math.type(data) == "integer" then
                                ScaleformMovieMethodAddParamInt(data)
                            else
                                ScaleformMovieMethodAddParamFloat(data)
                            end
                        elseif type(data) == "string" then
                            ScaleformMovieMethodAddParamPlayerNameString("~l~" .. data)
                        elseif not data then
                            ScaleformMovieMethodAddParamInt()
                        end
                    end
                    EndScaleformMovieMethod()
                end
            
                BeginScaleformMovieMethod(Phone.Scaleform, "DISPLAY_VIEW")
                ScaleformMovieMethodAddParamInt(_CurrentScreen.Type)
                ScaleformMovieMethodAddParamInt(_SelectedItem)
                EndScaleformMovieMethod()
            
                -- Fix _SelectedItem in case last item got removed while it was selected
                if _SelectedItem > #_CurrentScreen.Items - 1 then
                    _SelectedItem = #_CurrentScreen.Items - 1
                end

                local navigated = false
                if IsControlJustPressed(3, 172) then -- INPUT_CELLPHONE_UP (arrow up)
                    _SelectedItem = _SelectedItem - 1

                    if _SelectedItem < 0 then
                        _SelectedItem = #_CurrentScreen.Items - 1
                    end

                    navigated = true
                elseif IsControlJustPressed(3, 173) then -- INPUT_CELLPHONE_DOWN (arrow down)
                    _SelectedItem = _SelectedItem + 1

                    if _SelectedItem > #_CurrentScreen.Items - 1 then
                        _SelectedItem = 0
                    end

                    navigated = true
                elseif IsControlJustPressed(3, 176) then -- INPUT_CELLPHONE_SELECT (enter / lmb)
                    if #_CurrentScreen.Items > 0 then
                        local item = _CurrentScreen.Items[_SelectedItem + 1]

                        if type(item.Callback) == "table" then -- Action (Should be function, but it isn't because it's a table according to Msgpack!)
                            item.Callback()

                            PlaySoundFrontend(-1, "Menu_Accept", "Phone_SoundSet_Michael")
                        elseif type(item.Callback) == "number" then -- Screen
                            table.insert(_PrevScreens, _CurrentScreen)

                            _CurrentScreen = _CurrentApp.Screens[item.Callback]
                            _SelectedItem = 0

                            PlaySoundFrontend(-1, "Menu_Accept", "Phone_SoundSet_Michael")
                        end
                    end
                elseif IsControlJustPressed(3, 177) then -- INPUT_CELLPHONE_CANCEL (backspace / esc / rmb)
                    if #_PrevScreens > 0 then
                        _CurrentScreen = _PrevScreens[#_PrevScreens]

                        table.remove(_PrevScreens)

                        _SelectedItem = 0

                        PlaySoundFrontend(-1, "Menu_Back", "Phone_SoundSet_Michael")
                    else
                        Wait(0) -- Workaround to stop main app from registering back press too
                        Apps.Kill()
                    end
                end

                if navigated then
                    PlaySoundFrontend(-1, "Menu_Navigate", "Phone_SoundSet_Michael")
                end
            end
        end
    end
end)