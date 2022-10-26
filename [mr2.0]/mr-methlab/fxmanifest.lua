fx_version 'cerulean'
game 'gta5' 

description 'MR-methlab'
version '1.0.0'

ui_page "html/index.html"

shared_scripts {
    '@mrfw/import.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua',
    'client/gui.lua',
}

server_scripts {
    'server/main.lua',
}

server_exports {
    'GenerateRandomLab'
}

files {
    'html/*'
}

lua54 'yes'