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

IsDatabaseVerified = false

local setupTable = "CREATE TABLE IF NOT EXISTS venomous_players (license varchar(255) NOT NULL, identifier varchar(255) NOT NULL, cash int(11) NOT NULL, `bank` int(11) NOT NULL, `rank` int(11) NOT NULL, `xp` int(11) NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8"
exports.ghmattimysql:execute(setupTable, {}, function()
	local invTable = "CREATE TABLE IF NOT EXISTS venomous_inventory (license varchar(255) NOT NULL, item varchar(255) NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8"
	exports.ghmattimysql:execute(invTable, {}, function() IsDatabaseVerified = true end)
end)
