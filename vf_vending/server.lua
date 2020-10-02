--[[
            vf_vending
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

RegisterServerEvent('vending:purchase')
AddEventHandler('vending:purchase', function()
	local src = source
	TriggerEvent('vf_base:FindPlayer', src, function(user)
		if user.cash >= 1 then
			TriggerEvent('vf_base:ClearCash', src, 1)
			TriggerClientEvent('vending:purchase', src, true)
		else
			TriggerClientEvent('vending:purchase', src, false)
		end
	end)
end)