fx_version 'adamant'
game 'gta5'
author 'FiveM-Scripts'

dependencies {'ghmattimysql', 'NativeUI', 'vf_base'}

client_scripts {
    '@NativeUI/NativeUI.lua',
    'config/costs.lua',
    'config/vehicles.lua',
    'vehicles.lua',
	'client.lua'	
}

server_script 'server.lua'