--[[
            vf_businesses
            Copyright (C) 2020 FiveM-Scripts
              
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU Affero General Public License for more details.
You should have received a copy of the GNU Affero General Public License
along with vf_businesses in the file "LICENSE". If not, see <http://www.gnu.org/licenses/>.
]]

RegisterServerEvent('vf_business:LoadPlayer')
AddEventHandler('vf_business:LoadPlayer', function()
	local src = source

	TriggerEvent('vf_base:FindPlayer', src, function(user)
		local Parameters = {['license'] = user.license}

		exports.ghmattimysql:scalar("SELECT license FROM vf_business WHERE license = @license", Parameters, function(result)
			if result then
				exports.ghmattimysql:execute("SELECT * FROM vf_business WHERE license = @license", Parameters, function(data)
					TriggerClientEvent('vf_business:GetData', src, data)
				end)
			end
		end)
	end)
end)