fx_version 'cerulean'
games { 'gta5' }

author 'Tiger (Discord: lets_tiger)'
description 'Anti Driveby'
version '1.3.0'

server_scripts {
	'server/version_check.lua'
}

client_scripts {
	'client/main.lua'
}

shared_script {
	'config.lua',
    'locales.lua',
    'locales/*.lua'
}

files {
	'stream/TG_Textures.ytd'
}