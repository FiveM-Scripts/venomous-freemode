AddEventHandler("vf_phone:setup", function()
    TriggerEvent("vf_phone:CreateApp", GetLabelText("CELL_37"), 14, function(app)
        local missionScreen = app.CreateListScreen()
        app.SetLauncherScreen(missionScreen)
        for i, mission in ipairs(Missions) do
            missionScreen.AddCallbackItem(mission.MissionName, 0, function() Missions.Start(i) end)
        end
    end)
end)