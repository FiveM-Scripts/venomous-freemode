--[[
            vf_base - Venomous Freemode - base resource
              Copyright (C) 2018-2020  FiveM-Scripts

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program in the file "LICENSE".  If not, see <http://www.gnu.org/licenses/>.
]]

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
		elseif string.sub(v, 1, string.len("ip")) == "ip" then
			return v
		end
	end
end

function Player:Find(source, callback)
	local src = source
	local pLicense = Player:GetLicense(src)
	local identifier = Player:GetIdentifier(src)
	local Parameters = {['license'] = pLicense}

	exports.ghmattimysql:scalar("SELECT license FROM venomous_players WHERE license = @license", Parameters, function(result)
		if not result then
			print('Creating a new profile for ' .. GetPlayerName(src))
			Player:New(pLicense, identifier, 5000, 0, 1, 100)
		else
			exports.ghmattimysql:execute("SELECT * FROM venomous_players WHERE license = @license", Parameters, function(data)
				for k, v in pairs(data) do
					if callback then
						callback(v)
					end
				end
			end)
		end
	end)
end

function Player:New(license, identifier, cash, bank, rank, xp)
	local Parameters = {
	    ['license'] = license,
	    ['identifier'] = identifier,
	    ['cash'] = cash,
	    ['bank'] = bank,
	    ['rank'] = rank,
	    ['xp'] = xp
	}

	return exports.ghmattimysql:execute("INSERT INTO venomous_players (`license`, `identifier`, `cash`, `bank`, `rank`, `xp`) VALUES (@license, @identifier, @cash, @bank, @rank, @xp)", Parameters, function() end)
end

function Player:AddCash(source, value)
	if IsDatabaseVerified then
		local src = source
		local pLicense = Player:GetLicense(src)		

		exports.ghmattimysql:scalar("SELECT cash FROM venomous_players WHERE license = @license", { ['license'] = tostring(pLicense)}, function (CashResult)
			if CashResult then
				local newvalue = CashResult + value
				
				exports.ghmattimysql:execute("UPDATE venomous_players SET cash=@value WHERE license = @license", {['license'] = tostring(pLicense), ['value'] = tostring(newvalue)})
				TriggerClientEvent('vf_base:DisplayCashValue', src, newvalue)
				
				local newvalue = nil
				CashResult = nil
			end
		end)

	end
	CancelEvent()
end

function Player:AddBank(source, value)
	if IsDatabaseVerified then
		local src = source
		local pLicense = Player:GetLicense(src)

		exports.ghmattimysql:scalar("SELECT bank FROM venomous_players WHERE license = @license", { ['license'] = tostring(pLicense)}, function (result)
			if result then
				newvalue = result + value

				TriggerClientEvent('vf_base:DisplayBankValue', src, newvalue)
				exports.ghmattimysql:execute("UPDATE venomous_players SET bank=@value WHERE license = @license", {['license'] = tostring(pLicense), ['value'] = tostring(newvalue)})
				local result = nil
			end
		end)
	end
	CancelEvent()
end

RegisterServerEvent('vf_base:FindPlayer')
AddEventHandler('vf_base:FindPlayer', function(source, callback)
	local src = source
	for k,v in ipairs(GetPlayerIdentifiers(src)) do
		if string.sub(v, 1, string.len("license")) == "license" then
			pLicense = v
		end
	end

	local Parameters = {['license'] = pLicense}

	exports.ghmattimysql:scalar("SELECT license FROM venomous_players WHERE license = @license", Parameters, function(result)
		if not result then
			print('Creating a new profile for ' .. GetPlayerName(src))
			Player:New(pLicense, identifier, 5000, 0, 1, 100)
		else
			exports.ghmattimysql:execute("SELECT * FROM venomous_players WHERE license = @license", Parameters, function(data)
				for k, v in pairs(data) do
					if callback then
						callback(v)
					end
				end
			end)
		end
	end)
end)

RegisterServerEvent('vf_base:AddCash')
AddEventHandler('vf_base:AddCash', function(source, value)
	local src = source
	Player:Find(src, function(data)
		if data then
			local newValue = data.cash + value
			exports.ghmattimysql:scalar("SELECT cash FROM venomous_players WHERE license = @license", { ['license'] = tostring(pLicense)}, function (CashResult)
				if CashResult then
					local newvalue = CashResult + value
					exports.ghmattimysql:execute("UPDATE venomous_players SET cash=@value WHERE license = @license", {['license'] = tostring(pLicense), ['value'] = tostring(newvalue)})
					TriggerClientEvent('vf_base:DisplayCashValue', src, newvalue)
					local newvalue = nil
					CashResult = nil
				end
			end)
		end
	end)
end)

RegisterServerEvent('vf_base:AddBank')
AddEventHandler('vf_base:AddBank', function(source, value)
	local src = source
	Player:Find(src, function(data)
		if data then
			local newValue = data.bank + value
			exports.ghmattimysql:scalar("SELECT bank FROM venomous_players WHERE license = @license", { ['license'] = tostring(pLicense)}, function (result)
				if result then
					newvalue = result + value

					TriggerClientEvent('vf_base:DisplayBankValue', src, newvalue)
					exports.ghmattimysql:execute("UPDATE venomous_players SET bank=@value WHERE license = @license", {['license'] = tostring(pLicense), ['value'] = tostring(newvalue)})
					local result = nil
				end
			end)
		end
	end)
end)

RegisterServerEvent('vf_base:ClearCash')
AddEventHandler('vf_base:ClearCash', function(source, value)
	local src = source

	Player:Find(src, function(data)
		if data then
			local newValue = data.cash - value
			exports.ghmattimysql:execute("UPDATE venomous_players SET cash=@newValue WHERE license = @license", {['license'] = tostring(data.license), ['newValue'] = tostring(newValue)}, function() end)
			TriggerClientEvent('vf_base:DisplayCashValue', source, newValue)
		end
	end)
end)

RegisterServerEvent('vf_base:ClearBank')
AddEventHandler('vf_base:ClearBank', function(source, value)
	local src = source

	Player:Find(src, function(data)
		if data then
			local newValue = data.bank - value
			exports.ghmattimysql:execute("UPDATE venomous_players SET bank=@newValue WHERE license = @license", {['license'] = tostring(data.license), ['newValue'] = tostring(newValue)}, function() end)
			TriggerClientEvent('vf_base:DisplayBankValue', source, newValue)
		end
	end)
end)