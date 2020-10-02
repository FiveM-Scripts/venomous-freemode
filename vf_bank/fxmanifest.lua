fx_version 'adamant'
game 'gta5'

files({
	'ui/fonts/ChaletComprimeCologneSixty.ttf',	
	'ui/style.css',
	'ui/img/logo.png',
	'ui/index.html',
	'ui/script.js'
})

ui_page('ui/index.html')

client_scripts {
	'client.lua'
}

server_script 'server.lua'