resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

ui_page 'ui.html'

files {
	'ui.html',
	'job-icon.png',
	'pricedown.ttf'
}

client_script "client.lua"
client_script "gui.lua"
server_script "server.lua"
