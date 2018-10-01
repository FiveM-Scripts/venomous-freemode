Player = {}
Player.__index = Player

function Player:GetLicense(source)
	for k,v in ipairs(GetPlayerIdentifiers(source)) do
		if string.sub(v, 1, string.len("license")) == "license" then
			return v
		end
	end
end

function Player:GetIdentifier(source)
	for k,v in ipairs(GetPlayerIdentifiers(source)) do
		if string.sub(v, 1, string.len("steam")) == "steam" then
			return v
		end
	end
end

function Player:Find(source, callback)
	local src = source
	local pLicense = Player:GetLicense(src)
	local identifier = Player:GetIdentifier(src)

	MySQL.Async.fetchAll('SELECT * FROM venomous_players WHERE license = @license', { ['@license'] = tostring(pLicense)}, function(content)
		if content then
			for k, v in pairs(content) do
				if callback then
					callback(v)
				end
			end	
		else
			print('Create a new profile for ' .. GetPlayerName(src))
			Player:New(pLicense, identifier, 5000, 2000, 1, 100)
		end
	end)
end

function Player:New(license, identifier, cash, bank, rank, xp)
	MySQL.Async.execute("INSERT INTO venomous_players (`license`, `identifier`, `cash`, `bank`, `rank`, `xp`) VALUES (@license, @identifier,  @cash,  @bank,  @rank,  @xp)", { ['@license'] = license, ['@identifier'] = identifier, ['@cash'] = cash, ['@bank'] = bank, ['@rank'] = rank, ['@xp'] = xp})
end

function Player:AddCash(source, value)
	local src = source
	local pLicense = Player:GetLicense(src)

	MySQL.Sync.execute("UPDATE venomous_players SET cash=@value WHERE license = @license", {['@license'] = tostring(pLicense), ['@value'] = tostring(value)})
	TriggerClientEvent('vf_base:DisplayCashValue', src, value)
	CancelEvent()
end

function Player:AddBank(source, value)
	local src = source
	local pLicense = Player:GetLicense(src)

	MySQL.Sync.execute("UPDATE venomous_players SET bank=@value WHERE license = @license", {['@license'] = tostring(pLicense), ['@value'] = tostring(value)})
	TriggerClientEvent('vf_base:DisplayBankValue', src, value)
	CancelEvent()
end

function Player:RemoveCash(source, value)
	local src = source
	local pLicense = Player:GetLicense(src)
	
	MySQL.Async.fetchScalar("SELECT cash FROM venomous_players WHERE license = @license", { ['@license'] = tostring(pLicense)}, function (result)
		if(result) then
			local newValue = result - value
			MySQL.Sync.execute("UPDATE venomous_players SET cash=@newValue WHERE license = @license", {['@license'] = tostring(pLicense), ['@newValue'] = tostring(newValue)})
			TriggerClientEvent('vf_base:DisplayCashValue', src, newValue)
		end
	end)
	CancelEvent()
end

function Player:ClearCash(source)
	local src = source
	local pLicense = Player:GetLicense(src)
	
	MySQL.Async.fetchScalar("SELECT cash FROM venomous_players WHERE license = @license", { ['@license'] = tostring(pLicense)}, function (result)
		if(result) then
			local newValue = 0

			MySQL.Sync.execute("UPDATE venomous_players SET cash=@newValue WHERE license = @license", {['@license'] = tostring(pLicense), ['@newValue'] = 0})
			TriggerClientEvent('vf_base:DisplayCashValue', src, newValue)
		end
	end)
	CancelEvent()
end

function Player:ClearBank(source)
	local src = source
	local pLicense = Player:GetLicense(src)
	
	MySQL.Async.fetchScalar("SELECT bank FROM venomous_players WHERE license = @license", { ['@license'] = tostring(pLicense)}, function (result)
		if(result) then
			local newValue = 0
			MySQL.Sync.execute("UPDATE venomous_players SET bank=@newValue WHERE license = @license", {['@license'] = tostring(pLicense), ['@newValue'] = newValue})
			TriggerClientEvent('vf_base:DisplayBankValue', src, newValue)
		end
	end)
	CancelEvent()
end

RegisterServerEvent('vf_base:AddCash')
AddEventHandler('vf_base:AddCash', function(value)
	local src = source
	Player:Find(src, function(data)
		if data then
			local newValue = data.cash + value
			Player:AddCash(src, newValue)
		end
	end)
end)

RegisterServerEvent('vf_base:AddBank')
AddEventHandler('vf_base:AddBank', function(value)
	local src = source
	Player:Find(src, function(data)
		if data then
			local newValue = data.bank + value
			Player:AddBank(src, newValue)
		end
	end)
end)

RegisterServerEvent('vf_base:ClearCash')
AddEventHandler('vf_base:ClearCash', function(value)
	local src = source
	Player:Find(src, function(data)
		if data then
			Player:ClearCash(src, value)
		end
	end)
end)

RegisterServerEvent('vf_base:ClearBank')
AddEventHandler('vf_base:ClearBank', function(value)
	local src = source
	Player:Find(src, function(data)
		if data then
			Player:ClearBank(src, value)
		end
	end)
end)