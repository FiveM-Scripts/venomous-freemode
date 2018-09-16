MySQL.ready(function()
	MySQL.Async.execute("CREATE TABLE IF NOT EXISTS venomous_players (license varchar(255) NOT NULL, identifier varchar(255) NOT NULL, cash int(11) NOT NULL, `bank` int(11) NOT NULL, `rank` int(11) NOT NULL, `xp` int(11) NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8")
end)