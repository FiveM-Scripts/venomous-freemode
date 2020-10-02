fx_version 'adamant'
game 'gta5'
author 'FiveM-Scripts'

resource_type 'gametype' { name = 'venomous-freemode' }
resource_version '1.1.3'

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

export 'GetInventory'
server_export 'AddInventoryItem'
server_export 'GetInventoryItems'

server_scripts {
    'config/freemode.lua',
    'server/database.lua',
    'server/player.lua',
    'server/general.lua'
}