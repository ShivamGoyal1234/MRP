fx_version 'cerulean'
game 'gta5'
 
description 'chatko beta kal aana'
lua54 'yes'
client_scripts {
    'client/*.lua'
}
this_is_a_map "yes"
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/expire.lua',
    'server/server.lua'
}
 
dependency 'ajfw'

