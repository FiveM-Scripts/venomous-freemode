Missions = {
    MissionRuinerMadness,
    MissionDispatch,
    MissionSnitch
}
local currentMission

function Missions.Start(mission)
    if Missions[mission] then
        if currentMission then
            Missions.Kill()
        end
        currentMission = Missions[mission]
        if currentMission.Init then
            currentMission.Init()
        end
    end
end

function Missions.Kill()
    if currentMission then
        if currentMission.Kill then
            currentMission.Kill()
        end
        currentMission = nil
    end
end

Citizen.CreateThread(function()
    while true do
        Wait(0)

        if currentMission and currentMission.Tick then
            currentMission.Tick()
        end
    end
end)

-- For now
Citizen.CreateThread(function()
     Missions.Start(GetRandomIntInRange(1, 4))
end)