if Config.enableTextChat then
	StopResource('chat')
else
	StartResource('chat')
end

StopResource('scoreboard')

RegisterServerEvent('vf_base:LoadPlayer')
AddEventHandler('vf_base:LoadPlayer', function()
	local src = source
	Player:Find(src, function(data)
		if data then
			local bank = data.bank
			local cash = data.cash
			local rank = data.rank
			local xp = data.xp

			 TriggerClientEvent('vf_base:DisplayCashValue', src, cash)
			 TriggerClientEvent('vf_base:DisplayBankValue', src, bank)
		end
	end)
end)

PerformHttpRequest("https://raw.githubusercontent.com/FiveM-Scripts/venomous-freemode/master/vf_base/__resource.lua", function(errorCode, result, headers)
    local version = GetResourceMetadata(GetCurrentResourceName(), 'resource_version', 0)

    if string.find(tostring(result), version) == nil then
        print("\n\r[Venomous Freemode] The version on this server is not up to date. Please update now.\n\r")
    end
end, "GET", "", "")

RegisterServerEvent("vf_base:KickRes")
AddEventHandler("vf_base:KickRes", function(reason)
	DropPlayer(source, tostring(reason))
end)