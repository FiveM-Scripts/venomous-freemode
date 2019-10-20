RegisterServerEvent('sotw:purchase')
AddEventHandler('sotw:purchase', function(price)
	local src = source
	TriggerEvent('vf_base:FindPlayer', src, function(user)
		if user.cash >= tonumber(price) then
			TriggerEvent('vf_base:ClearCash', src, tonumber(price))
			TriggerClientEvent('sotw:buyweed', src, model, name)
		elseif user.bank >= tonumber(price) then
			TriggerEvent('vf_base:ClearBank', src, tonumber(price))
			TriggerClientEvent('sotw:buyweed', src, model, name)
		end
	end)
end)