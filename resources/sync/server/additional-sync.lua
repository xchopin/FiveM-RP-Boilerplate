local weatherTypes = { "EXTRASUNNY", "CLEAR", "CLOUDS", "OVERCAST", "SMOG", "FOGGY", "RAIN", "THUNDER", "CLEARING", "NEUTRAL", "SNOW", "BLIZZARD", "XMAS" }
local partsOfDay = { "NIGHT", "MORNING", "NOON", "EVENING" }
local secondOfDay = (ASData.time.h * 3600) + (ASData.time.m * 60) + ASData.time.s

-- Causes a blackout instantly for all clients
-- @param1	integer		NetID of the person issuing the command, or -1 if source is RCON
-- @param2	table		Array of arguments provided
-- @return
-- @arg1	boolean		Whether to blackout the city
OnCmd:register( "blackout", function( source, args )
	-- Check for permissions if ACL is enabled
	if source ~= -1 and ACL ~= nil and not ACL:isModerator( source ) then
		return
	end
	
	-- Process command
	if #args == 0 then
		ASData.blackout = not ASData.blackout
	else
		ASData.blackout = not not tonumber( table.remove( args, 1 ) )
	end
	
	TriggerClientEvent( "MSQSetBlackout", -1, ASData.blackout )
	
	-- Give feedback
	if ASData.blackout then
		OnCmd:feedback( source, "", {}, "Los Santos is now offline" )
	else
		OnCmd:feedback( source, "", {}, "Los Santos is back online" )
	end
end)

-- Changes the weather instantly for all clients and freezes it
-- @param1	integer		NetID of the person issuing the command, or -1 if source is RCON
-- @param2	table		Array of arguments provided
-- @return
-- @arg1	string		What to change the weather to. Expecting a string found in 'weatherTypes'
OnCmd:register( "weather", function( source, args )
	-- Check for permissions if ACL is enabled
	if source ~= -1 and ACL ~= nil and not ACL:isModerator( source ) then
		return
	end
	
	-- Process command
	local weather = string.upper( table.remove( args, 1 ) )
	local exists = find( weatherTypes, weather )
	
	if exists ~= nil then
		ASData.weather = weather
		TriggerClientEvent( "MSQSetWeather", -1, weather )
		return
	end
	
	-- Invalid command syntax, provide help
	OnCmd:feedback( source, "Usage", {255, 255, 255}, "/weather [" .. table.concat( weatherTypes, " | " ) .. "]" )
end)

-- Changes the wind instantly for all clients
-- @param1	integer		NetID of the person issuing the command, or -1 if source is RCON
-- @param2	table		Array of arguments provided
-- @return
-- @arg1	float		Wind speed in Beaufort (0.0 - 12.0)
-- @arg2	float		Wind direction in degrees (0.0 - 360.0)
OnCmd:register( "wind", function( source, args )
	-- Check for permissions if ACL is enabled
	if source ~= -1 and ACL ~= nil and not ACL:isModerator( source ) then
		return
	end
	
	ASData.wind.speed = tonumber( table.remove( args, 1 ) )
	ASData.wind.direction = tonumber( table.remove( args, 1 ) )
	
	if ASData.wind.speed >= 12.0 then
		ASData.wind.speed = 11.99
	end
	
	if ASData.wind.direction >= 360.0 then
		ASData.wind.direction = 0.0
	end
	
	TriggerClientEvent( "MSQSetWind", -1, ASData.wind.speed, ASData.wind.direction )
	
	-- Give feedback
	OnCmd:feedback( source, "", {}, string.format( "The wind has changed (%.2f bft. %s)", ASData.wind.speed, degreesToIntercardinalDirection( ASData.wind.direction ) ) )
end)

-- Changes the amount of new traffic generated for each client
-- @param1	integer		NetID of the person issuing the command, or -1 if source is RCON
-- @param2	table		Array of arguments provided
-- @return
-- @arg1	float		0.0 for no traffic and 1.0 for maximum traffic
OnCmd:register( "traffic", function( source, args )
	-- Check for permissions if ACL is enabled
	if source ~= -1 and ACL ~= nil and not ACL:isModerator( source ) then
		return
	end
	
	-- Process command
	local multiplier = tonumber( table.remove( args, 1 ) )
	
	-- BUG: tonumber("1.0") == float(1.0) > double(1.0). Solution: float(0.9999999) == double(1.0)
	if multiplier == 1.0 then
		multiplier = 0.9999999
	end
	
	if multiplier ~= nil and multiplier >= 0.0 and multiplier <= 1.0 then
		ASData.traffic = multiplier
		TriggerClientEvent( "MSQSetTraffic", -1, multiplier )
		return
	end
	
	-- Invalid command syntax, provide help
	OnCmd:feedback( source, "Usage", {255, 255, 255}, "/traffic [0.0 - 1.0]" )
end)

-- Changes the amount of new pedestrians generated for each client
-- @param1	integer		NetID of the person issuing the command, or -1 if source is RCON
-- @param2	table		Array of arguments provided
-- @return
-- @arg1	float		0.0 for no peds and 1.0 for maximum peds
OnCmd:register( "crowd", function( source, args )
	-- Check for permissions if ACL is enabled
	if source ~= -1 and ACL ~= nil and not ACL:isModerator( source ) then
		return
	end
	
	-- Process command
	local multiplier = tonumber( table.remove( args, 1 ) )
	
	-- BUG: tonumber("1.0") == float(1.0) > double(1.0). Solution: float(0.9999999) == double(1.0)
	if multiplier == 1.0 then
		multiplier = 0.9999999
	end
	
	if multiplier ~= nil and multiplier >= 0.0 and multiplier <= 1.0 then
		ASData.crowd = multiplier
		TriggerClientEvent( "MSQSetCrowd", -1, multiplier )
		return
	end
	
	-- Invalid command syntax, provide help
	OnCmd:feedback( source, "Usage", {255, 255, 255}, "/crowd [0.0 - 1.0]" )
end)

-- Changes the time instantly for all clients, but does not freeze it
-- @param1	integer		NetID of the person issuing the command, or -1 if source is RCON
-- @param2	table		Array of arguments provided
-- @return
-- @arg1	string		What part of the day to change the time to. Expecting a string found in 'partsOfDay'
-- @arg1	integer		Set the hour (24h notation)
-- @arg2	integer		Set the minute
-- @arg3	integer		Set the seconds
OnCmd:register( "time", function( source, args )
	-- Check for permissions if ACL is enabled
	if source ~= -1 and ACL ~= nil and not ACL:isModerator( source ) then
		return
	end
	
	-- Process command
	local p1 = table.remove( args, 1 )
	local p2 = tonumber( table.remove( args, 1 ) )
	local p3 = tonumber( table.remove( args, 1 ) )
	local exists = false
	
	-- Determine what kind of input has been given
	if p3 ~= nil then
		p1 = tonumber( p1 )
	else
		p1 = string.upper( p1 )
		exists = find( partsOfDay, p1 )
	end
	
	if p1 ~= nil and p2 ~= nil and p3 ~= nil and p1 <= 23 and p2 <= 59 and p3 <= 59 then
		-- Using direct time input
		ASData.time.h = p1
		ASData.time.m = p2
		ASData.time.s = p3
		
		secondOfDay = (ASData.time.h * 3600) + (ASData.time.m * 60) + ASData.time.s
		TriggerClientEvent( "MSQSetTime", -1, ASData.time.h, ASData.time.m, ASData.time.s )
		return
	elseif exists then
		-- Using part of day as input
		ASData.time.h = 23
		ASData.time.m = 0
		ASData.time.s = 0
		
		if p1 == "MORNING" then
			ASData.time.h = 7
		elseif p1 == "NOON" then
			ASData.time.h = 12
		elseif p1 == "EVENING" then
			ASData.time.h = 19
		end
		
		secondOfDay = (ASData.time.h * 3600) + (ASData.time.m * 60) + ASData.time.s
		TriggerClientEvent( "MSQSetTime", -1, ASData.time.h, ASData.time.m, ASData.time.s )
		return
	end
	
	-- Invalid command syntax, provide help
	OnCmd:feedback( source, "Usage", {255, 255, 255}, "/time [hh mm ss] | [" .. table.concat( partsOfDay, " | " ) .. "]" )
end)

-- Freezes or unfreezes the time
-- @param1	integer		NetID of the person issuing the command, or -1 if source is RCON
-- @param2	table		Array of arguments provided
-- @return
-- @arg1	boolean		TRUE = freeze time, FALSE = unfreeze time
OnCmd:register( "freezetime", function( source, args )
	-- Check for permissions if ACL is enabled
	if source ~= -1 and ACL ~= nil and not ACL:isModerator( source ) then
		return
	end
	
	-- Process command
	local set = table.remove( args, 1 )
	
	if set ~= nil then
		ASData.time.frozen = tonumber( set ) ~= 0 and true or false
	else
		ASData.time.frozen = not ASData.time.frozen
	end
	
	TriggerClientEvent( "MSQFreezeTime", -1, ASData.time.frozen )
	
	-- Give feedback
	if ASData.time.frozen then
		OnCmd:feedback( source, "", {}, "Time is now frozen" )
	else
		OnCmd:feedback( source, "", {}, "Time is now running" )
	end
end)

-- Changes the rate of which time passes
-- @param1	integer		NetID of the person issuing the command, or -1 if source is RCON
-- @param2	table		Array of arguments provided
-- @return
-- @arg1	string		DAY, NIGHT or BOTH
-- @arg2	float		Rate of which time should pass at
OnCmd:register( "timerate", function( source, args )
	-- Check for permissions if ACL is enabled
	if source ~= -1 and ACL ~= nil and not ACL:isModerator( source ) then
		return
	end
	
	-- Process command
	local daypart = string.upper( table.remove( args, 1 ) )
	local rate = tonumber( table.remove( args, 1 ) )
	
	if daypart == "BOTH" or daypart == "DAY" or daypart == "NIGHT" then
		TriggerClientEvent( "MSQSetTimeRate", -1, daypart, rate )
		
		if daypart == "BOTH" or daypart == "DAY" then
			ASData.time.rates.day = rate
		end
		
		if daypart == "BOTH" or daypart == "NIGHT" then
			ASData.time.rates.night = rate
		end
		
		return
	end
	
	-- Invalid command syntax, provide help
	OnCmd:feedback( source, "Usage", {255, 255, 255}, "/timerate [DAY | NIGHT | BOTH] [0.0 - 60.0] (default: 1.0)" )
end)

-- Custom events
RegisterServerEvent( "MSQonClientMapStart" )
RegisterServerEvent( "MSQSetVehicleIndicator" )
RegisterServerEvent( "MSQSetVehicleWindow" )

-- Reborn event. Called when the client spawns into the map
-- @param1
-- @return
AddEventHandler( "MSQonClientMapStart", function()
	TriggerClientEvent( "MSQASInit", source, ASData )
	
	if ACL ~= nil then
		if ACL:isAdministrator( source ) then
			TriggerClientEvent( "chatMessage", source, "", {255,255,255}, "^3You logged in as administrator." )
		elseif ACL:isModerator( source ) then
			TriggerClientEvent( "chatMessage", source, "", {255,255,255}, "^3You logged in as moderator." )
		end
	end
end)

-- MSQ event. Called when a client uses a vehicle's turn indicators
-- @param1	integer		Direction. 1 for left, 0 for right
-- @param2	boolean		Whether the indicator is on
-- @return
AddEventHandler( "MSQSetVehicleIndicator", function( dir, state )
	TriggerClientEvent( "MSQVehicleIndicator", -1, source, dir, state )
end)

-- MSQ event. Called when a client rolls down the vehicle's windows
-- @param1	boolean		Whether the windows are down (down = true)
-- @return
AddEventHandler( "MSQSetVehicleWindow", function( windowsDown )
	TriggerClientEvent( "MSQVehicleWindow", -1, source, windowsDown )
end)

-- Keep the time updated for when new players enter the server, so that they are roughly in sync with everyone else
-- 2000 milliseconds is one minute in game
local function updateServerClock()
	ASData.time.h = math.floor( secondOfDay / 3600 )
	ASData.time.m = math.floor( (secondOfDay - (ASData.time.h * 3600)) / 60 )
	ASData.time.s = secondOfDay - (ASData.time.h * 3600) - (ASData.time.m * 60)
	
	if not ASData.time.frozen then
		secondOfDay = secondOfDay + 60
		
		if secondOfDay >= 86400 then
			secondOfDay = secondOfDay % 86400
		end
	end
	
	if secondOfDay >= 19800 and secondOfDay <= 75600 then
		SetTimeout( 2000 / ASData.time.rates.day, updateServerClock )
	else
		SetTimeout( 2000 / ASData.time.rates.night, updateServerClock )
	end
end

SetTimeout( 2000, updateServerClock )