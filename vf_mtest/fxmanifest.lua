fx_version 'adamant'
game 'gta5'
author 'FiveM-Scripts'

dependency "vf_phone"

client_scripts {
--    "cl_pos.lua",
    "cl_entityenum.lua",
    "missions/cl_ruinermadness.lua",
    "missions/cl_dispatch.lua",
    "missions/cl_securityvan.lua", 
    "missions/cl_snitch.lua",    
    "missions/cl_missions.lua",
    "cl_missionsapp.lua"
}

server_script "sv_missionsapp.lua"