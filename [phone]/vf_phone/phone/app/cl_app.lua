Apps = {}
local SelectedItem
local CurrentApp
local CurrentScreen
local PrevScreens

function Apps.Start(appId)
    if Apps[appId] and Apps[appId].LauncherScreen then
        CurrentApp = Apps[appId]
        CurrentScreen = Apps[appId].LauncherScreen
        PrevScreens = {}
        SelectedItem = 0
        Phone.InApp = true

        PlaySoundFrontend(-1, "Menu_Accept", "Phone_SoundSet_Michael")
    end
end

function Apps.Kill()
    Phone.InApp = false
    CurrentApp = nil

    PlaySoundFrontend(-1, "Menu_Back", "Phone_SoundSet_Michael")
end

Citizen.CreateThread(function()
    while true do
        Wait(0)

        if CurrentApp then
            if not CurrentScreen then -- Revert back to existing screen if screen got removed
                if not PrevScreens then -- Quit app if no screens exist
                    Apps.Kill()
                else
                    local screenFound = false
                    for _, screen in ipairs(PrevScreens) do
                        if screen and not screenFound then
                            CurrentScreen = screen

                            screenFound = true
                        end
                    end

                    if not screenFound then -- No existing screen found
                        Apps.Kill()
                    end
                end
            else
                BeginScaleformMovieMethod(Phone.Scaleform, "SET_DATA_SLOT_EMPTY")
                ScaleformMovieMethodAddParamInt(CurrentScreen.Type)
                EndScaleformMovieMethod()

                local header = ""
                if CurrentScreen.Header then
                    header = CurrentScreen.Header
                elseif CurrentApp.Name then
                    header = CurrentApp.Name
                end

                BeginScaleformMovieMethod(Phone.Scaleform, "SET_HEADER")
                ScaleformMovieMethodAddParamPlayerNameString(header)
                EndScaleformMovieMethod()

                for i, item in ipairs(CurrentScreen.Items) do
                    BeginScaleformMovieMethod(Phone.Scaleform, "SET_DATA_SLOT")

                    ScaleformMovieMethodAddParamInt(CurrentScreen.Type)
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
                ScaleformMovieMethodAddParamInt(CurrentScreen.Type)
                ScaleformMovieMethodAddParamInt(SelectedItem)
                EndScaleformMovieMethod()
            
                -- Fix SelectedItem in case last item got removed while it was selected
                if SelectedItem > #CurrentScreen.Items - 1 then
                    SelectedItem = #CurrentScreen.Items - 1
                end

                local navigated = false
                if IsControlJustPressed(3, 172) then -- INPUT_CELLPHONE_UP (arrow up)
                    SelectedItem = SelectedItem - 1

                    if SelectedItem < 0 then
                        SelectedItem = #CurrentScreen.Items - 1
                    end

                    navigated = true
                elseif IsControlJustPressed(3, 173) then -- INPUT_CELLPHONE_DOWN (arrow down)
                    SelectedItem = SelectedItem + 1

                    if SelectedItem > #CurrentScreen.Items - 1 then
                        SelectedItem = 0
                    end

                    navigated = true
                elseif IsControlJustPressed(3, 176) then -- INPUT_CELLPHONE_SELECT (enter / lmb)
                    if #CurrentScreen.Items > 0 then
                        local item = CurrentScreen.Items[SelectedItem + 1]

                        if type(item.Callback) == "table" then -- Action (Should be function, but it isn't because it's a table according to Msgpack!)
                            item.Callback()

                            PlaySoundFrontend(-1, "Menu_Accept", "Phone_SoundSet_Michael")
                        elseif type(item.Callback) == "number" then -- Screen
                            table.insert(PrevScreens, CurrentScreen)

                            CurrentScreen = CurrentApp.Screens[item.Callback]
                            SelectedItem = 0

                            PlaySoundFrontend(-1, "Menu_Accept", "Phone_SoundSet_Michael")
                        end
                    end
                elseif IsControlJustPressed(3, 177) then -- INPUT_CELLPHONE_CANCEL (backspace / esc / rmb)
                    if #PrevScreens > 0 then
                        CurrentScreen = PrevScreens[#PrevScreens]

                        table.remove(PrevScreens)

                        SelectedItem = 0

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