fx_version 'cerulean'
game 'gta5'

description 'MR--Shops'
version '1.0.0'

shared_scripts { 
	'@mrfw/import.lua',
	'config.lua'
}

client_script 'client/main.lua'
server_script 'server/main.lua'

dependencies {
	'mr-inventory'
}

lua54 'yes'