RegisterServerEvent('vf_cinema:watch')
AddEventHandler('vf_cinema:watch', function(price)
	local src = source

	TriggerEvent('vf_base:FindPlayer', src, function(user)
		if user.cash >= tonumber(price) then
			TriggerEvent('vf_base:ClearCash', src, price)
			TriggerClientEvent('vf_cinema:enter', src, true)
		else
			TriggerClientEvent('vf_cinema:enter', src, false)
		end
	end)
end)