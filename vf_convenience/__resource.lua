resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

dependencies {'ghmattimysql', 'NativeUI', 'vf_base'}

client_scripts {
 "@NativeUI/NativeUI.lua",
 "config.lua",
 "cl_ped.lua",
 "cl_menu.lua",
 "client.lua"
}

server_script "server.lua"