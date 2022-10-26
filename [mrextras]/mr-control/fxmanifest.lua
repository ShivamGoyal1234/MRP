fx_version 'cerulean'
game { 'gta5' }

name 'MR-CONTROL'
version '1.0'
description 'Combined'

shared_scripts {
	'@mrfw/import.lua',
	'config.lua'
}

client_scripts {
    'client/*.lua',
}


lua54 'yes'