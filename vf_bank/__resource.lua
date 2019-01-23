resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

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