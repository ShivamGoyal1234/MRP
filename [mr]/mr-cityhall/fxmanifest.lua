fx_version 'cerulean'
game 'gta5'

description 'MR--CityHall'
version '1.0.0'

ui_page 'html/index.html'

lua54 'yes'

shared_scripts { 
	'config.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}
client_script 'client/main.lua'

files {
    "html/*.js",
    "html/*.html",
    "html/*.css",
    "html/img/*.png",
    "html/img/*.jpg"
}

