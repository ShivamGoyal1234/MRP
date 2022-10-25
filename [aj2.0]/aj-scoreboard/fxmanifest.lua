fx_version 'cerulean'
game 'gta5'
 
description 'AJFW Example Manifest'
version '1.0.0'
 
client_scripts {
    'cl_scoreboard.lua',
    'warmenu.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'sv_scoreboard.lua',

}
lua54 'yes'
