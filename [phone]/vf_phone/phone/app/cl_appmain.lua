local selectedItem = 4

Citizen.CreateThread(function()
    while true do
        Wait(0)

        if Phone.Visible and not Phone.InApp then
            for i = 0, 8 do
                PushScaleformMovieFunction(Phone.Scaleform, "SET_DATA_SLOT")
                PushScaleformMovieFunctionParameterInt(1)
                PushScaleformMovieFunctionParameterInt(i)
                if Apps[i + 1] and Apps[i + 1].Icon then
                    PushScaleformMovieFunctionParameterInt(Apps[i + 1].Icon)
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
            if Apps[selectedItem + 1] and Apps[selectedItem + 1].Name then
                PushScaleformMovieFunctionParameterString(Apps[selectedItem + 1].Name)
            else
                PushScaleformMovieFunctionParameterString("")
            end
            PopScaleformMovieFunctionVoid()

            local navigated = true
            if IsControlJustPressed(0, 300) then -- Up
                selectedItem = selectedItem - 3
                if selectedItem < 0 then
                    selectedItem = 9 + selectedItem
                end
            elseif IsControlJustPressed(0, 299) then -- Down
                selectedItem = selectedItem + 3
                if selectedItem > 8 then
                    selectedItem = selectedItem - 9
                end
            elseif IsControlJustPressed(0, 307) then -- Right
                selectedItem = selectedItem + 1
                if selectedItem > 8 then
                    selectedItem = 0
                end
            elseif IsControlJustPressed(0, 308) then -- Left
                selectedItem = selectedItem - 1
                if selectedItem < 0 then
                    selectedItem = 8
                end
            else
                if IsControlJustPressed(0, 255) then -- Enter
                    Apps.Start(selectedItem + 1)
                elseif IsControlJustPressed(0, 202) then -- Back
                    Phone.Kill()
                end
                navigated = false
            end
            if navigated then
                PlaySoundFrontend(-1, "Menu_Navigate", "Phone_SoundSet_Default")
            end
        end
    end
end)