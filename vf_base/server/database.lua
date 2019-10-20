IsDatabaseVerified = false

local setupTable = "CREATE TABLE IF NOT EXISTS venomous_players (license varchar(255) NOT NULL, identifier varchar(255) NOT NULL, cash int(11) NOT NULL, `bank` int(11) NOT NULL, `rank` int(11) NOT NULL, `xp` int(11) NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8"
exports.ghmattimysql:execute(setupTable, {}, function()
	local invTable = "CREATE TABLE IF NOT EXISTS venomous_inventory (license varchar(255) NOT NULL, item varchar(255) NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8"
	exports.ghmattimysql:execute(invTable, {}, function() IsDatabaseVerified = true end)
end)
