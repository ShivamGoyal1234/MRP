fx_version 'cerulean'
game 'gta5'

description 'MR--Apartments'
version '1.0.0'
lua54 'yes' -- Add in case you want to use lua 5.4 (https://www.lua.org/manual/5.4/manual.html)

shared_script 'config.lua'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/main.lua'
}

escrow_ignore {
	'config.lua'
}

client_scripts {
	'@menuv/menuv.lua',
	'client/main.lua',
	'client/gui.lua'
}

dependencies {
	'mrfw',
	'mr-interior',
	'mr-clothing',
	'mr-weathersync'
}

-- lua54 'yes'

