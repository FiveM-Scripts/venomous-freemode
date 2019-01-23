RegisterServerEvent('vf_bank:deposit')
AddEventHandler('vf_bank:deposit', function(price)
	local src = source

	TriggerEvent('vf_base:FindPlayer', src, function(user)
		if user.cash >= tonumber(price) then
			TriggerEvent('vf_base:ClearCash', src, tonumber(price))
			TriggerEvent('vf_base:AddBank', src, tonumber(price))
		else
			print('Not enough cash')
			TriggerClientEvent('vf_bank:DisplayError', src, 'MPATM_NODO')
		end
	end)
end)

RegisterServerEvent('vf_bank:whitdraw')
AddEventHandler('vf_bank:whitdraw', function(price)
	local src = source

	TriggerEvent('vf_base:FindPlayer', src, function(user)
		local bank = user.bank
		if user.bank >= tonumber(price) then
			TriggerEvent('vf_base:ClearBank', src, tonumber(price))
			TriggerEvent('vf_base:AddCash', src, tonumber(price))
		elseif user.bank <= tonumber(price) and user.bank > tonumber(0) then
			TriggerClientEvent('vf_bank:DisplayError', src, 'MP_REP_PROP_4')
		else
			TriggerClientEvent('vf_bank:DisplayError', src, 'MPATM_NODO2')
		end
	end)
end)