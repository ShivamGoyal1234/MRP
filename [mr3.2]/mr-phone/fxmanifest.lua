fx_version 'cerulean'
game 'gta5'

author '9dgamer#4348'
version 'Release'

ui_page 'html/index.html'

shared_scripts {
    'config.lua',
    '@mr-apartments/config.lua',
    '@mr-garages/config.lua',
}

client_scripts {
    'client/main.lua',
    'client/animation.lua'
}

server_scripts {
    'server/main.lua',
    '@oxmysql/lib/MySQL.lua'
}

files {
    'html/*.html',
    'html/js/*.js',
    'html/img/*.png',
    'html/css/*.css',
    'html/fonts/*.ttf',
    'html/fonts/*.otf',
    'html/fonts/*.woff',
    'html/img/backgrounds/*.png',
    'html/img/apps/*.png',
}

lua54 'yes'