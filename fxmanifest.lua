fx_version "adamant"

games { 'gta5'}
lua54 'yes'
use_fxv2_oal 'yes'

ui_page {
    'html/index.html',
}

files {
    'html/*.html',
    'html/*.css',
    'html/*.js',
    'html/images/*.png'
}


client_scripts {
	'configs/clientConfig.lua',
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
	'configs/serverConfig.lua',
    'server/*.lua'
}

dependencies {
    "plouffe_lib"
}