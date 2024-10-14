
-- Main Settings
fx_version 'cerulean'
game 'gta5'

-- Project Information
author 'Xmodz & #4rchan'
description 'ValoriaAC'
version '7.1.1'

-- Web UI Page
ui_page 'ui/index.html'

-- UI Files
files {
    'ui/*.html',
    'ui/css/*.css',
    'ui/js/*.js',
    'ui/assists/**/*.*'
}

-- Shared Scripts and Configurations
shared_scripts {
    'tables/*.lua',
    'configs/valoria-config.lua'
}

-- Client Scripts
client_scripts {
    'src/valoria-client.lua',
    'src/valoria-menu.lua',
}

-- Server Scripts
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'configs/valoria-webhook.lua',
    'src/valoria-server.lua',
}

-- Exports (For use on both client and server)
exports {
    'ValoriaAC_CHANGE_TEMP_WHHITELIST',
    'ValoriaAC_CHECK_TEMP_WHITELIST',
    'ValoriaAC_ACTION'
}

-- Server-specific Exports
server_exports {
    'ValoriaAC_CHANGE_TEMP_WHHITELIST',
    'ValoriaAC_CHECK_TEMP_WHITELIST',
    'ValoriaAC_ACTION'
}

-- Dependencies
dependencies {
    'oxmysql',
}
