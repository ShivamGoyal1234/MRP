fx_version 'cerulean'
game { 'gta5' }

name 'MR-UNDERWATERWEED'
version '1.0'
description 'Combined'

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