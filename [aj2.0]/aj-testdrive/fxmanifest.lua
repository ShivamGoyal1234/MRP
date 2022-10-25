fx_version 'cerulean'
game 'gta5'

description 'AJ-TESTDRIVE'
version '1.0.0'

server_scripts {	
	'@oxmysql/lib/MySQL.lua',		
	'config.lua',
	'server/server.lua',
}

client_scripts {		
	'config.lua',
	'client/utils.lua',
	'client/client.lua'
}

files {
    'html/index.html',
	'html/carousel.css',	
    'html/carousel.js',
	'html/design.css',
	'html/script.js',		
	'html/pickr.es5.min.js',	
	'html/picker.js',	
	'html/jquery-ui.js',
	'html/jqueri-ui.css',
	'html/nano.min.css',	
    'html/images/*.png',
    'html/fonts/*.ttf',
    'imgs/*.png',
	'imgs/brands/*.png',	
}

ui_page 'html/index.html'

dependencies {
	'ajfw',
	--'qb-vehiclekeys'
}

lua54 'yes'
