fx_version 'cerulean'
game { 'gta5' }

name 'MR-MONEYWASH'
version '1.0'

shared_scripts {
	'@mrfw/import.lua',
	'config.lua'
}

client_scripts {
    'client/*.lua',
}

server_scripts {
    'server/*.lua'
}


lua54 'yes'