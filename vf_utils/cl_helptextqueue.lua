local helpTexts = {}

AddEventHandler("vf_utils:queueHelpText", function(text, duration)
    if type(text) == "string" and type(duration) == "number" then
        table.insert(helpTexts, { text = text, duration = duration })
    end
end)

-- Decrementing
Citizen.CreateThread(function()
    while true do
        if #helpTexts == 0 then
            Wait(1)
        else
            Wait(1000)
            helpTexts[1].duration = helpTexts[1].duration - 1
            if helpTexts[1].duration == 0 then
                table.remove(helpTexts, 1)
            end
        end
    end
end)

-- Displaying
Citizen.CreateThread(function()
    while true do
        Wait(1)
        if helpTexts[1] then
            AddTextEntry("_vf_utils_helptext", helpTexts[1].text)
            DisplayHelpTextThisFrame("_vf_utils_helptext")
        end
    end
end)