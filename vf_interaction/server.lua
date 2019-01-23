RegisterServerEvent('vf_interaction:pay')
AddEventHandler('vf_interaction:pay', function(price)
	local src = source

	TriggerEvent('vf_base:FindPlayer', src, function(user)
		local cash = user.cash
		if cash >= tonumber(price) then
			TriggerEvent('vf_base:ClearCash', src, tonumber(price))
		end
	end)
end)