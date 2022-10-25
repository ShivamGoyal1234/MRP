fx_version 'cerulean'
game 'gta5'

description 'MR--LapRaces'
version '1.0.0'

ui_page 'html/index.html'

shared_scripts { 
	'@mrfw/import.lua',
	'config.lua'
}

client_script 'client/main.lua'
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

files {
    'html/*.html',
    'html/*.css',
    'html/*.js',
    'html/fonts/*.otf',
    'html/img/*'
}

exports {
    'IsInRace',
    'IsInEditor'
}

lua54 'yes'

