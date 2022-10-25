fx_version 'cerulean'
game 'gta5'

description 'MR--KeyMiniGame'
version '1.0.0'

ui_page 'html/index.html'

client_scripts {
    '@mrfw/import.lua',
    'client/main.lua',
}

files {
    'html/index.html',
    'html/app.js',
    'html/style.css',
}

lua54 'yes'