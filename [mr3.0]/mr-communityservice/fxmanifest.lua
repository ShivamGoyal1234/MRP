fx_version 'cerulean'
game 'gta5'

description 'MR-CommunityService'
version '1.0.0'

shared_scripts {
    'config.lua',
}

client_script 'client.lua'

server_scripts {
    'server.lua',
    '@oxmysql/lib/MySQL.lua',
}

lua54 'yes'