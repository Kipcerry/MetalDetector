

fx_version 'adamant'

game 'gta5'


lua54 'yes'

shared_scripts {
	'@ox_lib/init.lua',
    'config.lua',
    '@es_extended/imports.lua'
}


server_scripts {

	'server.lua',
    '@oxmysql/lib/MySQL.lua'
}

client_scripts {
	'client.lua'
}

file 'stream/gen_w_am_metaldetector.ytyp'

server_exports {
    'AddProspectingTarget', -- x, y, z, data
    'AddProspectingTargets', -- list
    'StartProspecting', -- player
    'StopProspecting', -- player
    'IsProspecting', -- player
    'SetDifficulty', -- modifier
}