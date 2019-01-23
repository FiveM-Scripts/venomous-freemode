RegisterServerEvent('vending:purchase')
AddEventHandler('vending:purchase', function()
	local src = source
	TriggerEvent('vf_base:FindPlayer', src, function(user)
		if user.cash >= 1 then
			TriggerEvent('vf_base:ClearCash', src, 1)
			TriggerClientEvent('vending:purchase', src, true)
		else
			TriggerClientEvent('vending:purchase', src, false)
		end
	end)
end)