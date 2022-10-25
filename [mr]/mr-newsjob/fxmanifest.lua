fx_version 'cerulean'
game 'gta5'

description 'MR--NewsJob'
version '1.0.0'

shared_scripts { 
	'@mrfw/import.lua',
	'config.lua'
}

client_scripts {
    'client/main.lua',
    'client/camera.lua',
    'client/gui.lua'
}

server_script 'server/main.lua'

lua54 'yes'