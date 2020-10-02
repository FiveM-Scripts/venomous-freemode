--[[
            vf_bank - Venomous Freemode - banking resource
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