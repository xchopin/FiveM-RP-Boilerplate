-- Manifest
resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

description 'EssentialMode by Kanersps.'

ui_page 'ui.html'

-- NUI Files
files {
	'ui.html',
	'pdown.ttf',
	'dirty-money.png'
}

-- Server
server_script 'server/classes/player.lua'
server_script 'server/classes/groups.lua'
server_script 'server/player/login.lua'
server_script 'server/main.lua'
server_script 'server/util.lua'

-- Client
client_script 'client/main.lua'
client_script 'client/player.lua'