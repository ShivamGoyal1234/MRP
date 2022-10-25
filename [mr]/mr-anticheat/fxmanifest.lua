fx_version 'cerulean'
game 'gta5'

description 'MR--Anticheat'
version '1.0.0'
lua54 'yes' -- Add in case you want to use lua 5.4 (https://www.lua.org/manual/5.4/manual.html)

shared_scripts { 
	'config.lua'
}

client_script 'client/main.lua'
server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/main.lua'
}

