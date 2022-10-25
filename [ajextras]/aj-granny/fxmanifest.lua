fx_version 'cerulean'
game { 'gta5' }

name 'aj Script'
version '1.0'
description 'Combined'

shared_scripts {
	'@ajfw/import.lua',
}

client_scripts {
    'client/*.lua',
}

server_scripts {
    'server/*.lua'
}


lua54 'yes'