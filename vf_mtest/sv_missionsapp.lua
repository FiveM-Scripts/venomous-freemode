RegisterServerEvent('vf_mtest:playercut')
AddEventHandler('vf_mtest:playercut', function(price)
	local src = source
	TriggerEvent('vf_base:AddBank', src, tonumber(price))
end)