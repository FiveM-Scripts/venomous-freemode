local displayIdleWarning = false
local IsTimerStarted = false
local TimerSoundPlayed = false

local arriveTime = nil
local NotificationSoundLocked = false
local time

local function ConvertTime(ms, timerSound)
  local MilliSeconds = tonumber(ms) / 1000
  local timer = tonumber(timerSound)

  if MilliSeconds <= 0 then
  	return 0
  else
  	hours = string.format("%02.f", math.floor(MilliSeconds/3600))
  	mins  = string.format("%02.f", math.floor(MilliSeconds/60 - (hours*60)))
    secs  = string.format("%02.f", math.floor(MilliSeconds - hours*3600 - mins *60))

    if tonumber(hours) >= 01 then
    	return hours..":" ..mins..":"..secs
    elseif tonumber(mins) >= 01 then
    	return mins.."m "..secs .."s"
    else
    	if tonumber(secs) <= 10 then
    		if not TimerSoundPlayed then
    			local sound = GetSoundId()
    			PlaySoundFrontend(sound, "Timer_10s", "DLC_TG_Dinner_Sounds", false)
    			TimerSoundPlayed = true
    		end
    	end

    	return secs .."s"
    end
  end
end

local function DisplayIdleText(time)
	if notify then	
		RemoveNotification(notify)
	end

	if not NotificationSoundLocked then
		PlaySoundFrontend(0, "DELETE", "HUD_DEATHMATCH_SOUNDSET", 1)
		NotificationSoundLocked = true
	end

    SetNotificationTextEntry("HUD_ILDETIME")
    AddTextComponentSubstringPlayerName(time)
    SetNotificationBackgroundColor(140)
    notify = DrawNotification(false, false)

    return notify
end

local function StartIdleCountDownTimer(ms)
	if ms then
		arriveTime = tonumber(GetGameTimer() + ms * 1000)
		return arriveTime
	else
		print("No seconds has been set for the timer.\n")
	end
end

Citizen.CreateThread(function()
	while true do
		Wait(50000)
		if NetworkIsGameInProgress() and IsPlayerPlaying(PlayerId()) and firstTick then
			if not IsPlayerSwitchInProgress() then
				playerPed = PlayerPedId()
				currentPos = GetEntityCoords(playerPed, true)

				if currentPos == prevPos then
					if not IsTimerStarted then
						newTime = StartIdleCountDownTimer(Config.idleSecondsUntilKick)
						IsTimerStarted = true
					end
				end

				prevPos = currentPos
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if IsPlayerPlaying(PlayerId()) and NetworkIsGameInProgress() then
			player = PlayerId()
			playerPed = PlayerPedId()

			if IsTimerStarted then
				time = newTime - GetGameTimer()
				if IsPlayerClimbing(player) or IsPedWalking(playerPed) or IsPedRunning(playerPed) or IsPedSprinting(playerPed) or IsPedShooting(playerPed) then
					arriveTime = nil
					newTime = nil
					NotificationSoundLocked = false
					RemoveNotification(idleNotification)
					IsTimerStarted = false
				elseif GetGameTimer() < newTime then
					displayCounter = ConvertTime(time, 10)
					idleNotification = DisplayIdleText(displayCounter)
				else
					TimerSoundPlayed = false
					TriggerServerEvent('vf_base:KickRes', GetLabelText("HUD_KICKRES"))
				end
			else
				TimerSoundPlayed = false
				IsTimerStarted = false
				time = nil
			end
		end
	end
end)