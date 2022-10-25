fx_version 'cerulean'
game 'gta5'

description 'MR--MechanicJob'
version '1.0.0'

shared_scripts { 
	'@mrfw/import.lua',
}

client_scripts {
	'@menuv/menuv.lua',
	'config.lua',
	'client/main.lua',
	'client/gui.lua',
	'client/drivingdistance.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config.lua',
	'server/main.lua'
}

exports {
	'GetVehicleStatusList',
	'GetVehicleStatus',
	'SetVehicleStatus'
}


lua54 'yes'