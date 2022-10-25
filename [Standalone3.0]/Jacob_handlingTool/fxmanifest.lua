author '9dgamer'

description 'Utility to edit the handling of vehicles and record speeds'

version '1.0.0'

fx_version 'cerulean'
game 'gta5'

lua54 'yes'

ui_page 'html/index.html'

files {
	'html/index.css',
	'html/index.html',
	'html/index.js',
}

client_scripts {
	'cl_config.lua',
	'cl_debugger.lua',
}

server_scripts {
	'config.lua',
	'sv_debugger.lua'
}

escrow_ignore {
    'config.lua',
}

dependency '/assetpacks'