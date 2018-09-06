if Config.enableTextChat then
	StopResource('chat')
else
	StartResource('chat')
end

StopResource('scoreboard')


RegisterServerEvent('freemode:GetPlayerCharacters')
AddEventHandler('freemode:GetPlayerCharacters', function()
	-- todo: query the database table and verify that the player has a character, if not execute the following event.
	TriggerClientEvent("freemode:NoCharacter", source)
end)
