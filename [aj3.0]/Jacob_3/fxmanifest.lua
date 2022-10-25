fx_version 'cerulean'
game 'gta5'


shared_scripts { 
	'shared/*.lua',
}

client_scripts {
	'@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/EntityZone.lua',
	'@PolyZone/CircleZone.lua',
	'@PolyZone/ComboZone.lua',
	'client/main.lua'
}

server_scripts {
	'server/main.lua'
}




lua54 'yes'