resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'
resource_type 'gametype' { name = 'venomous-freemode' }
resource_version '1.0'

dependencies {'mysql-async', 'NativeUI'}

client_scripts {
    '@NativeUI/NativeUI.lua',
    'config/freemode.lua',
    'config/spawn.lua',
    'utils/player.lua',
    'utils/screens.lua',
    'client/character.lua',
    'client/spawn.lua',
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'config/freemode.lua',
    'server/database.lua',
    'server/general.lua'
}
