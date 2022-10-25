fx_version 'cerulean'
game 'gta5'

description 'MR--Vineyard'
version '1.0.0'

shared_scripts { 
	'@mrfw/import.lua',
	'config.lua'
}

server_script 'server.lua'
client_script 'client.lua'

lua54 'yes'