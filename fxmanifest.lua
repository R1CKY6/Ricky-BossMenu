-- Tech Development
-- Another free script
-- Join now: https://discord.gg/tHAbhd94vS

fx_version 'bodacious'
lua54 'yes' 
game 'gta5' 

author 'R1CKY®#2220'
description 'Tech Development - Boss Menu'
version '1.0'


client_scripts {
    'client/functions.lua',
    'client/callback.lua',
    'client/main.lua'
}

shared_scripts {
    'config/config.lua'
}

server_scripts {
   '@mysql-async/lib/MySQL.lua',
   'config/configS.lua',
   'server/functions.lua',
   'server/main.lua'
}

ui_page 'web/index.html'

files {
    'web/*.html',
    'web/css/*.css',
    'web/js/*.js',
    'web/js/icon/*.js',
    'web/fonts/*.otf',
    'web/img/*.png',
    'web/img/**/*.png',
}
