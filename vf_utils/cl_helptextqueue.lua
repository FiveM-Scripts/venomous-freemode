local HelpTexts = {}

function QueueHelpText(text, duration)
    if type(text) == "string" and type(duration) == "number" then
        table.insert(HelpTexts, { text = text, duration = duration })
    end
end

-- Decrementing
Citizen.CreateThread(function()
    while true do
        if #HelpTexts == 0 then
            Wait(1)
        else
            Wait(1000)
            HelpTexts[1].duration = HelpTexts[1].duration - 1
            if HelpTexts[1].duration == 0 then
                table.remove(HelpTexts, 1)
            end
        end
    end
end)

-- Displaying
Citizen.CreateThread(function()
    while true do
        Wait(1)
        if HelpTexts[1] then
            AddTextEntry("_vf_utils_helptext", HelpTexts[1].text)
            DisplayHelpTextThisFrame("_vf_utils_helptext")
        end
    end
end)