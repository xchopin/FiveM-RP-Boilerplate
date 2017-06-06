ACL = {
	lastError = ""
}

local playersConnecting = {}
local lastConnectedIdent = nil

-- Checks whether the player is whitelisted
-- @param1	integer		NetID of the player connecting. NetID = PlayerID << 16
-- @param2	string		Name of the player connecting
-- @return
function ACL:canConnect( netID, playerName )
	local ids = GetPlayerIdentifiers( netID )
	local png = GetPlayerPing( netID )
	
	-- Bug: GetPlayerIdentifiers sometimes returns identity of previously connected player.
	-- this piece of code instructs players to try again when this is detected, because dropping
	-- connections 'fixes' the bug.
	-- Reportedly supposedly fixed in 01/30 bug. Set ACL.useIdentBugWorkaround to false to stop using this workaround.
	if ACL.useIdentBugWorkaround and lastConnectedIdent ~= nil then
		if ids[1] == lastConnectedIdent[1] then
			lastConnectedIdent = nil
			self.lastError = "Please try again."
			return false
		end
	end
	
	lastConnectedIdent = ids
	
	-- Banlist has highest priority
	if self:isBanned( netID, playerName ) then
		return false
	end
	
	-- Everyone else can connect if whitelisting is disabled
	if not self.enableWhitelist then
		return true
	end
	
	-- Always allow moderators and administrators to connect
	if self:isModerator( netID ) then
		return true
	end
	
	-- Disallow players with high ping when configured
	if self.maxPing > 0 and png > self.maxPing then
		self.lastError = "Your ping is too high for this server (" .. png .. "ms / " .. self.maxPing .. "ms)."
		return false
	end
	
	for k,v in pairs( self.whitelist ) do
		-- Check for whitelisted tags
		if string.find( playerName, v, 1, true ) ~= nil then
			return true
		end
		
		-- Check for whitelisted GUIDS
		if findi( ids, v ) ~= nil then
			return true
		end
	end
	
	self.lastError = "This is a private server. Ask the administrator to be whitelisted."
	return false
end

-- Checks whether player is blacklisted or has disallowed name
-- @param1	integer		PlayerID
-- @param2	string		Player name
-- @return
function ACL:isBanned( playerID, playerName )
	local ids = GetPlayerIdentifiers( playerID )
	
	-- Check for reserved names
	if string.upper( playerName ) == "SERVER" or string.upper( playerName ) == "USAGE" then
		self.lastError = string.format( "The name '%s' is reserved. Please change it.", playerName )
		return true
	end
	
	for k,v in pairs( self.banlist ) do
		-- Check for banned words
		if string.find( playerName, v, 1, true ) ~= nil then
			self.lastError = "Your name or a part of it is not allowed."
			return true
		end
		
		-- Check for banned individuals
		if findi( ids, v ) ~= nil then
			self.lastError = "You are banned."
			return true
		end
	end
	
	return false
end

-- Checks whether the given IP is on the blacklist
-- @param1	string		Player IP in 'GetPlayerIdentifiers' format (eg. "ip:127.0.0.1")
-- @return
function ACL:isBannedIP( ip )
	return findi( self.banlist, ip ) ~= nil
end

-- Checks whether player is listed as moderator or adminstrator
-- @param1	integer		PlayerID
-- @return
function ACL:isModerator( playerID )
	local ids = GetPlayerIdentifiers( playerID )
	
	for k,v in pairs( self.mods ) do
		if findi( ids, v ) ~= nil then
			return true
		end
	end
	
	return self:isAdministrator( playerID )
end

-- Checks whether player is listed as administrator
-- @param1	integer		PlayerID
-- @return
function ACL:isAdministrator( playerID )
	local ids = GetPlayerIdentifiers( playerID )
	
	for k,v in pairs( self.admins ) do
		if findi( ids, v ) ~= nil then
			return true
		end
	end
	
	return false
end

-- Returns a list of players and their IDs
-- Kicks a player off the server
-- @param1	integer		NetID of the person issuing the command, or -1 if source is RCON
-- @param2	table		Array of arguments provided
-- @return
-- @arg1
OnCmd:register( "playerlist", function( source, args )
	if not ACL.enablePlayerManagement then
		-- Aborts the command, allowing other resources to handle it
		return true
	end
	
	for i = 0, 31 do
		local player = GetPlayerName( i )
		
		if player ~= nil then
			if ACL:isAdministrator( i ) then
				OnCmd:feedback( source, "", {255, 255, 255}, string.format( "%d - %s [admin]", i, player ) )
			elseif ACL:isModerator( i ) then
				OnCmd:feedback( source, "", {255, 255, 255}, string.format( "%d - %s [mod]", i, player ) )
			else
				OnCmd:feedback( source, "", {255, 255, 255}, string.format( "%d - %s", i, player ) )
			end
		end
	end
end)

-- Kicks a player off the server
-- @param1	integer		NetID of the person issuing the command, or -1 if source is RCON
-- @param2	table		Array of arguments provided
-- @return
-- @arg1	integer		NetID of the player to kick
OnCmd:register( "kick", function( source, args )
	if not ACL.enablePlayerManagement then
		-- Aborts the command, allowing other resources to handle it
		return true
	end
	
	-- Check for permissions if ACL is enabled
	if not ACL:isModerator( source ) then
		return
	end
	
	-- Process command
	local toKick = table.remove( args, 1 )
	local reason = table.remove( args, 1 )
	
	reason = reason ~= nil and reason or "Kicked."
	
	if toKick ~= nil then
		DropPlayer( tonumber( toKick ), reason )
		return
	end
	
	-- Invalid command syntax, provide help
	OnCmd:feedback( source, "Usage", {255, 255, 255}, "/kick PlayerID [Reason]" )
	OnCmd:feedback( source, "Usage", {255, 255, 255}, "/playerlist (show players and their IDs)" )
end)

-- Called when the client initially connects to the server
AddEventHandler( "playerConnecting", function( playerName, setCallback )
	local ident = GetPlayerIdentifiers( source )
	
	if ident == nil then
		setCallback( "Server is starting. Please try again in a few seconds." )
		CancelEvent()
		return
	end
	
	print( string.format( "'%s' connecting. (%s)", playerName, table.concat( ident, ", " ) ) )
	
	table.insert( playersConnecting, bit32.band( source, 0xFFFF ) + 1 )
	
	if not ACL:canConnect( source, playerName ) then
		print( "Connection rejected for: " .. playerName .. " (reason: " .. ACL.lastError .. ")" )
		setCallback( ACL.lastError )
		CancelEvent()
		return
	end
end)

-- GetPlayerEP does not handle NetIDs, only PlayerIDs. Server LUA does not have Citizen.CreateThread nor Wait
-- so we use this method to periodically check NetIDs converted to PlayerIDs (NetID & 0xFFFF + 1).
-- Usually triggered when the PlayerID is actually added to the server ~600ms after connecting.
-- 01/31: Apparently fixed in the 01/30 patch, however GetPlayerEP on 'playerConnecting' will result in ERROR_WINHTTP_TIMEOUT.
local function checkPlayersConnecting()
	if #playersConnecting > 0 then
		local EP = GetPlayerEP( playersConnecting[1] )
		
		if EP ~= nil then
			EP = "ip:" .. EP:Split( ":" )[0]
			
			if ACL:isBannedIP( EP ) then
				DropPlayer( playersConnecting[1], "You are banned." )
			end
			
			table.remove( playersConnecting, 1 )
		end
	end
	
	SetTimeout( 175, checkPlayersConnecting )
end

SetTimeout( 1, checkPlayersConnecting )