fx_version 'cerulean'
game 'gta5'

description 'MR--Garages'
version '1.0.1'

lua54 'yes'

shared_scripts { 
	'@mrfw/import.lua',
	'config.lua',
}

client_scripts {
    '@menuv/menuv.lua',
    'client/main.lua',
    'client/gui.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}


escrow_ignore {
    'config.lua',
}
