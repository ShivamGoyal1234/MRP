fx_version 'cerulean'
game 'gta5'
 
description 'AJFW Example Manifest'
version '1.0.0'
 
shared_script { 
    'config.lua'
}
 
client_scripts {
    'client.lua',
}

server_scripts {
    'server.lua',
}

ui_page "html/index.html"

files {
    '*.lua',
    'html/*.html',
    'html/*.js',
    'html/*.css',
}
lua54 'yes'
