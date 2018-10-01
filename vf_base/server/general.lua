if Config.enableTextChat then
	StopResource('chat')
else
	StartResource('chat')
end

StopResource('scoreboard')

RegisterServerEvent('vf_base:LoadPlayer')
AddEventHandler('vf_base:LoadPlayer', function()
	local src = source
	Player:Find(source, function(data)
		if data then
			local cash = data.cash
			local bank = data.bank

			TriggerEvent('vf_base:GetPlayerCharacters', src)			
			TriggerClientEvent('vf_base:DisplayCashValue', src, cash)
			TriggerClientEvent('vf_base:DisplayBankValue', src, bank)
			--CancelEvent()
		end
	end)
end)

RegisterServerEvent('vf_base:GetPlayerCharacters')
AddEventHandler('vf_base:GetPlayerCharacters', function()
	local src = source
	TriggerClientEvent("vf_base:NoCharacter", src)
end)

PerformHttpRequest("https://raw.githubusercontent.com/FiveM-Scripts/venomous-freemode/master/vf_base/__resource.lua", function(errorCode, result, headers)
    local version = GetResourceMetadata(GetCurrentResourceName(), 'resource_version', 0)

    if string.find(tostring(result), version) == nil then
        print("\n\r[Venomous Freemode] The version on this server is not up to date. Please update now.\n\r")
    end
end, "GET", "", "")