fx_version "cerulean"

game "gta5"

client_scripts {
	'config.lua',
	'client/main.lua',
	'client/gui.lua',
	'client/drivingdistance.lua',
}

server_scripts {
    'server/main.lua',
	'config.lua',
}

exports {
	'GetVehicleStatusList',
	'GetVehicleStatus',
	'SetVehicleStatus',
}


lua54 'yes'