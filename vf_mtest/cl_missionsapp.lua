TriggerEvent("vf_phone:requestAccess", "vf_mtest", function(phone)
    local app = phone.CreateApp(GetLabelText("CELL_37"), 14)
    local missionScreen = app.CreateListScreen()
    app.SetLauncherScreen(missionScreen)
    for i, mission in ipairs(Missions) do
        missionScreen.AddCallbackItem(mission.MissionName, 0, function() Missions.Start(i) end)
    end
end)