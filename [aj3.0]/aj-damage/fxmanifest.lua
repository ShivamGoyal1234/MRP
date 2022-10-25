fx_version 'cerulean'
game 'gta5'
 
description 'AJ Item Damge'
version '1.0.0'
 
lua54 'yes'

 
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config.lua',
    'main.lua'
}
 
 

 
dependency 'cron'