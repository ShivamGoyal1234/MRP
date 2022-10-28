fx_version 'cerulean'
author '! marcinhu.#6158'
Description 'Repairs'
game 'gta5'

shared_scripts {
    'config.lua',
}

client_scripts{
    'client/**.lua',
}

server_scripts{
    'server/**.lua',
}

escrow_ignore {
    "client/**",
    "server/**",
  "config.lua",
  "README.lua"
}

lua54 'yes'
