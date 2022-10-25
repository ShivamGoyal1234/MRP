fx_version 'cerulean'
game 'gta5'

description 'MR--AmbulanceJob'
version '1.0.0'
lua54 'yes' -- Add in case you want to use lua 5.4 (https://www.lua.org/manual/5.4/manual.html)


client_scripts {
	'@menuv/menuv.lua',
	'config.lua',
	'client/main.lua',
	'client/wounding.lua',
	'client/laststand.lua',
	'client/job.lua',
	'client/dead.lua',
	'client/gui.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config.lua',
	'server/main.lua'
}

