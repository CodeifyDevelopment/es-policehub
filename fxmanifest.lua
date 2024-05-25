fx_version 'bodacious'

games {"gta5"}

author "Codeify Dev"
description "Qbcore Advanced Police Hub System Made By Codeify Development "
version "1.0.6"

ui_page "html/index.html"

shared_script "config.lua"
client_script "client.lua"
server_script "server.lua"

files {
    "html/*.html",
    "html/*.css",
    "html/*.js",
}

escrow_ignore {
    'config.lua',
}
lua54 'yes'
