RegisterServerEvent('vf_convenience:item-selected')
AddEventHandler('vf_convenience:item-selected', function(item, price)
	local src = source
	TriggerEvent('vf_base:FindPlayer', src, function(user)
		local purchased = false
		if user.cash >= tonumber(price) then
			TriggerEvent('vf_base:ClearCash', src, price)
			purchased = true
		elseif user.bank >= tonumber(price) then
			TriggerEvent('vf_base:ClearBank', src, price)
			purchased = true
		else
			TriggerClientEvent('vf_convenience:nocash', src)
			purchased = false
		end

		if purchased then			
			exports.vf_base:AddInventoryItem(src, item)
			TriggerClientEvent("vf_convenience:update", src)
		end
	end)
end)