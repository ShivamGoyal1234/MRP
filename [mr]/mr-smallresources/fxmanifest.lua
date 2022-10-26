fx_version 'cerulean'
game 'gta5'

description 'MW-SmallResources'
version '1.0.0'

shared_scripts { 
	'@mrfw/import.lua',
	'config.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/*.lua'
}
client_scripts {
	'client/global.lua',
	'client/*.lua'
}
-- client_script 'tool.lua'

data_file 'FIVEM_LOVES_YOU_4B38E96CC036038F' 'events.meta'
data_file 'FIVEM_LOVES_YOU_341B23A2F0E0F131' 'popgroups.ymt'

files {
	'events.meta',
	'popgroups.ymt',
	'relationships.dat'
}

exports {
	'HasHarness'
}


lua54 'yes'