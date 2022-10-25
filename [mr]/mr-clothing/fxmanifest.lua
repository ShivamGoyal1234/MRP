fx_version 'cerulean'
game 'gta5'

description 'mr-clothing'
version '1.0.0'
lua54 'yes' -- Add in case you want to use lua 5.4 (https://www.lua.org/manual/5.4/manual.html)

ui_page "html/index.html"

shared_scripts {
	'@mrfw/import.lua',
	"config.lua"
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	"server/main.lua",
}

client_scripts {
	"client/main.lua",
}

files {
	'html/index.html',
	'html/style.css',
	'html/reset.css',
	'html/script.js',
}


