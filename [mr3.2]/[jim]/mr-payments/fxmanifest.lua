name "Jim-Payments"
author "Jimathy"
version "v2"
description "Payment Script By Jimathy"
fx_version "cerulean"
game "gta5"

dependencies {
	'mr-input',
	'mr-eye'
}

client_scripts {
    'client.lua',
	'atms.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua',
	'atmserver.lua'
}

shared_scripts {
    'config.lua',
}

lua54 'yes'