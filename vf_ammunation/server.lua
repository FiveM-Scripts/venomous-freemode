Ammunation = {}

function Ammunation:New(license, weapon)
	local Params = {
	    ['license'] = license,
	    ['weapon'] = weapon
	}

	exports.ghmattimysql:scalar("SELECT weapon FROM venomous_weapons WHERE license = @license AND weapon = @weapon", Params, function(result)
		if not result then
			exports.ghmattimysql:execute("INSERT INTO venomous_weapons (`license`, `weapon`) VALUES (@license, @weapon)", Params, function() end)
		end
	end)
end

local setupTable = "CREATE TABLE IF NOT EXISTS venomous_weapons (license varchar(255) NOT NULL, weapon varchar(255) NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8"
exports.ghmattimysql:execute(setupTable, {}, function() end)

RegisterServerEvent('vf_ammunation:item-selected')
AddEventHandler('vf_ammunation:item-selected', function(model, price, name)
	local src = source

	TriggerEvent('vf_base:FindPlayer', src, function(user)
		if user.cash >= tonumber(price) then
			TriggerEvent('vf_base:ClearCash', src, price)
			Ammunation:New(user.license, model)
			TriggerClientEvent('vf_ammunation:giveWeapon', src, model, name)
		elseif user.bank >= tonumber(price) then
			TriggerEvent('vf_base:ClearBank', src, price)
			Ammunation:New(user.license, model)
			TriggerClientEvent('vf_ammunation:giveWeapon', src, model, name)
		else
			TriggerClientEvent('vf_ammunation:nocash', src)
		end
	end)
end)

RegisterServerEvent('vf_ammunation:LoadPlayer')
AddEventHandler('vf_ammunation:LoadPlayer', function()
	local src = source

	TriggerEvent('vf_base:FindPlayer', src, function(user)
		local Parameters = {['license'] = user.license}

		exports.ghmattimysql:scalar("SELECT license FROM venomous_weapons WHERE license = @license", Parameters, function(result)
			if result then
				exports.ghmattimysql:execute("SELECT weapon FROM venomous_weapons WHERE license = @license", Parameters, function(data)
					TriggerClientEvent('vf_ammunation:LoadWeapons', src, data)
				end)
			end
		end)
	end)
end)