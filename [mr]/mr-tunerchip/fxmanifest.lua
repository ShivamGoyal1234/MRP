fx_version 'cerulean'
game 'gta5'

description 'MR--TunerChip'
version '1.0.0'

ui_page 'html/index.html'

shared_scripts { 
	'@mrfw/import.lua',
	'config.lua'
}

client_scripts {
    'client/main.lua',
    'client/nos.lua'
}

server_script 'server/main.lua'

files {
    'html/*',
}

lua54 'yes'