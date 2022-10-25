fx_version 'cerulean'
game 'gta5'

description 'AJ-carwash'
version '1.0.0'
lua54 'yes' -- Add in case you want to use lua 5.4 (https://www.lua.org/manual/5.4/manual.html)

shared_scripts { 
	'@ajfw/import.lua',
	'config.lua'
}

client_script 'client/main.lua'
server_script 'server/main.lua'

