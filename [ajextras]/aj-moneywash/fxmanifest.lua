fx_version 'cerulean'
game { 'gta5' }

name 'AJ-MONEYWASH'
version '1.0'

shared_scripts {
	'@ajfw/import.lua',
	'config.lua'
}

client_scripts {
    'client/*.lua',
}

server_scripts {
    'server/*.lua'
}


lua54 'yes'