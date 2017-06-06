resource_manifest_version "77731fab-63ca-442c-a67b-abc70f28dfa5"
description "MsQuerade's Additional Server Synchronization and ACL"
version "1.0.2"

server_scripts {
	"common/ext.lua",
	"common/vars.lua",
	"server/OnCmd.lua",
	"server/ACL.lua",
	"server/ACLConfig.lua",
	"server/additional-sync.lua"
}

client_scripts {
	"common/ext.lua",
	"common/vars.lua",
	"client/config.lua",
	"client/additional-sync.lua"
}