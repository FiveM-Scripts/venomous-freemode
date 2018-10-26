AddEventHandler("vf_phone:setup", function(Phone)
    local app = Phone.CreateApp(GetLabelText("CELL_37"), 14)
    local missionScreen = app.CreateListScreen()
    app.SetLauncherScreen(missionScreen)
    for i, mission in ipairs(Missions) do
        missionScreen.AddCallbackItem(mission.MissionName, 0, function() Missions.Start(i) end)
    end
end)