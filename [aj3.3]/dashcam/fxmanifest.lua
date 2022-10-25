fx_version 'cerulean'
game 'gta5'
 
description 'AJ-Dashcam'
version '1.0.0'
 
ui_page "nui/index.html"

files {
    "nui/index.html",
    "nui/vue.min.js",
    "nui/script.js",
    "nui/style.css",
    "nui/images/seal.png"
}

client_scripts {
    "config.lua",
    "client.lua"
}

lua54 'yes'