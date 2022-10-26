fx_version 'cerulean'
game 'gta5'

-- author '! POLYGON#5788'
-- title 'Poly Companies'
-- description 'Invest in companies'
-- version '0.1'

ui_page 'client/html/UI.html'

server_scripts {
	'locales/main.lua',
	'locales/en.lua', 
    'config.lua',
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua',
    'server/version.lua',
}

client_scripts {
	'locales/main.lua',
	'locales/en.lua', 
    'config.lua',
    'client/client.lua'
}

export 'openUI'

files {
    'client/html/UI.html',
    'client/html/script.js',
    'client/html/style.css',
    'client/html/media/font/Futura-Bold.woff',
    'client/html/media/img/circle.png',
    'client/html/media/img/curve.png',
    'client/html/media/img/fingerprint.jpg',
    'client/html/media/img/logo-big.png',
    'client/html/media/img/logo-top.png',
}

lua54 'yes'