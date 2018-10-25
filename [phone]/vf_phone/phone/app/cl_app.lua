Apps = {}
local selectedItem

function Apps.Start(app)
    if Apps[app] and Apps[app].LauncherScreen then
        Apps.CurrentApp = Apps[app]
        Apps.PrevScreens = {}
        Apps.CurrentScreen = Apps[app].LauncherScreen
        selectedItem = 0
        PlaySoundFrontend(-1, "Menu_Navigate", "Phone_SoundSet_Default")
    end
end

function Apps.Kill()
    Apps.CurrentApp = nil
    PlaySoundFrontend(-1, "Hang_Up", "Phone_SoundSet_Michael")
end

Citizen.CreateThread(function()
    while true do
        Wait(0)

        if Apps.CurrentApp then
            PushScaleformMovieFunction(Phone.Scaleform, "SET_DATA_SLOT_EMPTY")
            PushScaleformMovieFunctionParameterInt(Apps.CurrentScreen.Type)
            PopScaleformMovieFunctionVoid()

            for i, item in ipairs(Apps.CurrentScreen.Items) do
                PushScaleformMovieFunction(Phone.Scaleform, "SET_DATA_SLOT")
                PushScaleformMovieFunctionParameterInt(Apps.CurrentScreen.Type)
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
            PushScaleformMovieFunctionParameterInt(Apps.CurrentScreen.Type)
            PushScaleformMovieFunctionParameterInt(selectedItem)
        
            -- Fix selectedItem in case last item got removed while it was selected
            if selectedItem > #Apps.CurrentScreen.Items - 1 then
                selectedItem = #Apps.CurrentScreen.Items - 1
            end

            local navigated = true
            if IsControlJustPressed(0, 300) then -- Up
                selectedItem = selectedItem - 1
                if selectedItem < 0 then
                    selectedItem = #Apps.CurrentScreen.Items - 1
                end
            elseif IsControlJustPressed(0, 299) then -- Down
                selectedItem = selectedItem + 1
                if selectedItem > #Apps.CurrentScreen.Items - 1 then
                    selectedItem = 0
                end
            elseif IsControlJustPressed(0, 255) then -- Enter
                if #Apps.CurrentScreen.Items > 0 then
                    local item = Apps.CurrentScreen.Items[selectedItem + 1]
                    if type(item.Callback) == "table" then -- Action (Should be function, but it isn't because it's a table according to Msgpack!)
                        item.Callback()
                    elseif type(item.Callback) == "number" then -- Screen
                        table.insert(Apps.PrevScreens, Apps.CurrentScreen)
                        Apps.CurrentScreen = Apps.CurrentApp.Screens[item.Callback]
                        selectedItem = 0
                    end
                end
            elseif IsControlJustPressed(0, 202) then -- Back
                if #Apps.PrevScreens > 0 then
                    Apps.CurrentScreen = Apps.PrevScreens[#Apps.PrevScreens]
                    table.remove(Apps.PrevScreens)
                    selectedItem = 0
                else
                    Wait(1) -- Workaround to stop main app from registering back press too
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
end)