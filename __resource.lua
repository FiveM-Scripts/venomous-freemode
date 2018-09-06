resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'
resource_type 'gametype' { name = 'venomous-freemode' }
resource_version '1.0'

dependencies {'mysql-async', 'NativeUI'}

client_scripts {
    'vf_base/config/freemode.lua',
    'vf_base/config/spawn.lua',
    'vf_base/utils/player.lua',
    'vf_base/utils/screens.lua',
    'vf_base/client/character.lua',
	'vf_base/client/spawn.lua',
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'vf_base/config/freemode.lua',
    'vf_base/server/database.lua',
    'vf_base/server/general.lua'
}