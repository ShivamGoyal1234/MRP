fx_version 'cerulean'
game 'gta5'

description 'MR--Skillbar'
version '1.0.0'

ui_page "html/index.html"
shared_script '@mrfw/import.lua'
client_script 'client/main.lua'

files {
    'html/index.html',
    'html/script.js',
    'html/style.css',
    'html/VerdanaBold.ttf'
}

exports {
    'GetSkillbarObject'
}

dependencies {
    'mrfw'
}


lua54 'yes'