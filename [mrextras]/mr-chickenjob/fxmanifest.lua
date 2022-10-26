fx_version 'cerulean'
game 'gta5'
 
description 'MR-CHICKENJOB'
version '1.0.0'
  
shared_script { 
    '@mrfw/import.lua'
}
 
client_scripts {
    'client/*.lua',
}
 
server_scripts {
    'server/*.lua'
}


lua54 'yes'