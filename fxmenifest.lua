fx_version 'cerulean'
game 'gta5'

author 'F00Y CYBER | Server: God Battle'
description 'Auto NPC System'
version '1.1.0'

client_scripts {
    'client/cl_main.lua'
}

server_scripts {
    --'server/sv_main.lua'
}

shared_scripts {
    'config.lua'
}

dependencies {
    '/server:7200',
    '/gameBuild:2060'
}