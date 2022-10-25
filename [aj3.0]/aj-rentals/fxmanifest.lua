fx_version 'cerulean'
game 'gta5'

description 'aj-rental'
author 'Hyper'
version '1.2.0'


client_script {
    'config.lua',
    'client/main.lua',
    '@PolyZone/client.lua',
    '@PolyZone/CircleZone.lua',
}
server_script {
    'config.lua',
    'server/main.lua',
}

lua54 'yes'