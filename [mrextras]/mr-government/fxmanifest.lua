fx_version 'cerulean'
game 'gta5'
 
description 'MR-GOVERNMENT'
version '1.0.0'
  
shared_script { 
    '@mrfw/import.lua'
}
 
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