fx_version 'cerulean'
game { 'gta5' }

name 'AJ-TRUCKER'
version '1.0'
description 'Combined'

client_scripts {
    'config.lua',
    'client/*.lua',
    'client/gui.lua',
}

server_scripts {
    'config.lua',
    'server/*.lua'
}


lua54 'yes'