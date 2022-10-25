fx_version 'cerulean'
game 'gta5'

description 'MR--Diving'
version '1.0.0'

lua54 'yes'

shared_scripts { 
	'@mrfw/import.lua',
	'config.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
	'server/main.lua',
    'server/diving.lua'
}

client_scripts {
    'client/main.lua',
    'client/boatshop.lua',
    'client/diving.lua',
    'client/garage.lua',
    'client/gui.lua',
    'client/shop.lua'
}

