resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
resource_type 'gametype' { name = 'venomous-freemode' }
resource_version '1.1.1'

dependencies {'ghmattimysql'}

client_scripts {
    'config/freemode.lua',
    'config/spawn.lua',
    'config/vehicles.lua',
    'utils/player.lua',
    'utils/screens.lua',
    'utils/vehicles.lua',
    'client/spawn.lua'
}

server_scripts {
    'config/freemode.lua',
    'server/database.lua',
    'server/player.lua',
    'server/general.lua'
}
