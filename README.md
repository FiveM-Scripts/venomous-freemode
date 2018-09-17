# Venomous-freemode
[![Version](https://img.shields.io/badge/Version-1.0.0-brightgreen.svg)]()
[![GitHub license](https://img.shields.io/github/license/FiveM-Scripts/venomous-freemode.svg)](LICENSE)
<a href="https://discordapp.com/invite/qnAqCEd" title="Chat on Discord"><img alt="Discord Status" src="https://discordapp.com/api/guilds/285462938691567627/widget.png"></a>

A freemode gamemode fully written from scratch.    
It's aiming for modularity by splitting parts of the gamemode into multiple independent resources.    
This allows you to remove parts at your will, add custom extensions without conflicting resources and even use single parts outside of the gamemode.

## Changelog    
All notable changes to this project will be documented [here](CHANGELOG.md).

## Requirements

- [NativeUI](https://github.com/FrazzIe/NativeUILua) 
- [MySQL Community Server](https://dev.mysql.com/downloads/mysql/)
- [mysql-async](https://github.com/brouznouf/fivem-mysql-async)

## Installation
- Download or clone the gamemode.
- **Copy** all folders to your resources folder.
- Add the resources to your server config file.
```
# you probably don't want to change these!
# only change them if you're using a server with multiple network interfaces
endpoint_add_tcp "0.0.0.0:30120"
endpoint_add_udp "0.0.0.0:30120"

set mysql_connection_string "server=127.0.0.1;database=venomous;userid=DB_USERNAME;password=DB_PASSWORD;sslmode=none;"

start mapmanager
start spawnmanager
start sessionmanager
start fivem
start hardcap
start rconlog
start mysql-async
start NativeUI
start vf_base
start vf_sync
start vf_baseapps
start vf_mtest
start vf_phone
```

