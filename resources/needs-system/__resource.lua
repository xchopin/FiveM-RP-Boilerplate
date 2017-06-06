resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

ui_page 'needs.html'
files {
	'needs.html',
	'pdown.ttf'
}

client_script "needs_cl.lua"
server_script "needs_sv.lua"

export 'checkneeds'
export 'updateneeds'
export 'customupdateneeds'
export 'setneeds'
export 'addcalories'
export 'removecalories'
export 'addwater'
export 'removewater'
export 'addneeds'
export 'removeneeds'