RegisterNetEvent( "MSQNotify" )
RegisterNetEvent( "MSQASInit" )
RegisterNetEvent( "MSQSetBlackout" )
RegisterNetEvent( "MSQSetWeather" )
RegisterNetEvent( "MSQSetWind" )
RegisterNetEvent( "MSQSetTraffic" )
RegisterNetEvent( "MSQSetCrowd" )
RegisterNetEvent( "MSQSetTime" )
RegisterNetEvent( "MSQFreezeTime" )
RegisterNetEvent( "MSQSetTimeRate" )
RegisterNetEvent( "MSQVehicleIndicator" )
RegisterNetEvent( "MSQVehicleWindow" )

local vehicleState = {
	windowsDown = false,
	indicator = {
		left = false,
		right = false
	}
}

local hasBeenInitialised = false
local secondOfDay = 0


-- Shows a notification to the player
-- @param1	string		Message to show
-- @return
AddEventHandler( "MSQNotify", function( message )
	SetNotificationTextEntry( "STRING" )
	AddTextComponentString( message )
	DrawNotification( false, false )
end)

-- Called when client spawns into the map and the server acknowledges it
-- @param1	table		Additional synchronization data
-- @return
AddEventHandler( "MSQASInit", function( data )
	ASData = data
	hasBeenInitialised = true
	
	TriggerEvent( "MSQSetWind", data.wind.speed, data.wind.direction )
	TriggerEvent( "MSQSetTime", ASData.time.h, ASData.time.m, ASData.time.s )
end)

-- Called when a blackout is set or unset by a server operator
-- @param1	boolean		Whether blackout is set
-- @return
AddEventHandler( "MSQSetBlackout", function( trigger )
	ASData.blackout = not not trigger
end)

-- Called when the weather has been changed by a server operator
-- @param1	string		Weather preset to apply
-- @return
AddEventHandler( "MSQSetWeather", function( weather )
	ASData.weather = weather:upper()
end)

-- Called when the wind has been changed by a server operator
-- @param1	float		Wind speed in Beaufort (0.0 - 12.0)
-- @param2	float		Direction in degrees (0.0 - 359.9)
-- @return
AddEventHandler( "MSQSetWind", function( speed, direction )
	ASData.wind.speed = speed
	ASData.wind.direction = direction
	
	if ASData.wind.speed > 0.0 then
		SetWind( 1.0 )
		SetWindSpeed( ASData.wind.speed )
		SetWindDirection( ASData.wind.direction )
	else
		SetWindDirection( 0.0 )
		SetWindSpeed( 0.0 )
		SetWind( 0.0 )
	end
end)

-- Called when the traffic generation has been altered by a server operator
-- @param1	float		Multiplier between 0.0 and 1.0; how much new traffic to generate
-- @return
AddEventHandler( "MSQSetTraffic", function( multiplier )
	ASData.traffic = tonumber( multiplier )
end)

-- Called when the crowd generation has been altered by a server operator
-- @param1	float		Multiplier between 0.0 and 1.0; how many new peds to generate
-- @return
AddEventHandler( "MSQSetCrowd", function( multiplier )
	ASData.crowd = tonumber( multiplier )
end)

-- Called when the time has been changed by a server operator
-- @param1	integer		Hours of the day in 24h notation
-- @param2	integer		Minutes of the hour
-- @param3	integer		Seconds of the minute
AddEventHandler( "MSQSetTime", function( h, m, s )
	ASData.time.h = tonumber( h )
	ASData.time.m = tonumber( m )
	ASData.time.s = tonumber( s )
	
	secondOfDay = (ASData.time.h * 3600) + (ASData.time.m * 60) + ASData.time.s
end)

-- Called when the time was (un)frozen by a server operator
-- @param1	boolean		Whether time is frozen
AddEventHandler( "MSQFreezeTime", function( state )
	ASData.time.frozen = not not state
	
	ASData.time.h = GetClockHours()
	ASData.time.m = GetClockMinutes()
	ASData.time.s = GetClockSeconds()
end)

-- Called when the speed of time has been altered by a server operator
-- @param1	string		DAY, NIGHT or BOTH
-- @param2	float		The rate of which the time should be set as
AddEventHandler( "MSQSetTimeRate", function( daypart, rate )
	daypart = daypart:upper()
	rate = tonumber( rate )
	
	if rate < 0.1 then
		rate = 0.1
	elseif rate > 10.0 then
		rate = 10.0
	end
	
	if daypart == "DAY" or daypart == "BOTH" then
		ASData.time.rates.day = rate
	end
	
	if daypart == "NIGHT" or daypart == "BOTH" then
		ASData.time.rates.night = rate
	end
end)

-- MSQ event. Called when any player switches the turn indicator on or off
-- @param1	integer		PlayerID
-- @param2	integer		1 for left, 0 for right
-- @param3	boolean		whether turn indicator is on
-- @return
AddEventHandler( "MSQVehicleIndicator", function( playerID, dir, state )
	SetVehicleIndicatorLights( GetVehiclePedIsIn( GetPlayerPed( GetPlayerFromServerId( playerID ) ), false ), dir, state )
end)

-- MSQ event. Called when any player rolls down the vehicle windows
-- @param1	integer		PlayerID
-- @param2	boolean		true for windows down, false for windows up
-- @return
AddEventHandler( "MSQVehicleWindow", function( playerID, windowsDown )
	local vehicle = GetVehiclePedIsIn( GetPlayerPed( GetPlayerFromServerId( playerID ) ), false )
	
	if windowsDown then
		RollDownWindow( vehicle, 0 )
		RollDownWindow( vehicle, 1 )
	else
		RollUpWindow( vehicle, 0 )
		RollUpWindow( vehicle, 1 )
	end
end)

-- Reborn event. Called when the client spawns into the map
-- @param1
-- @return
AddEventHandler( "onClientMapStart", function()
	TriggerServerEvent( "MSQonClientMapStart" )
end)


-- Additional Sync High Priority Loop
Citizen.CreateThread( function()
	while not hasBeenInitialised do
		Wait( 500 )
	end
	
	while true do
		Wait( 0 )
		
		local pressedUp = config.vehicleWindowSync and IsControlJustPressed( keybinds.windows.inputGroup, keybinds.windows.up ) or false
		local pressedDown = config.vehicleWindowSync and IsControlJustPressed( keybinds.windows.inputGroup, keybinds.windows.down ) or false
		local pressedLeft = config.vehicleIndicatorSync and IsControlJustPressed( keybinds.indicators.inputGroup, keybinds.indicators.left ) or false
		local pressedRight = config.vehicleIndicatorSync and IsControlJustPressed( keybinds.indicators.inputGroup, keybinds.indicators.right ) or false
		
		if pressedLeft or pressedRight or pressedUp or pressedDown then
			local ped = GetPlayerPed( -1 )
			
			if IsPedInAnyVehicle( ped, true ) then
				local vehicle = GetVehiclePedIsIn( ped, false )
				
				if GetPedInVehicleSeat( vehicle, -1 ) == ped then
					if pressedLeft then
						vehicleState.indicator.left = not vehicleState.indicator.left
						TriggerServerEvent( "MSQSetVehicleIndicator", 1, vehicleState.indicator.left )
					end
					
					if pressedRight then
						vehicleState.indicator.right = not vehicleState.indicator.right
						TriggerServerEvent( "MSQSetVehicleIndicator", 0, vehicleState.indicator.right )
					end
					
					if pressedUp then
						vehicleState.windowsDown = false
						TriggerServerEvent( "MSQSetVehicleWindow", vehicleState.windowsDown )
					end
					
					if pressedDown then
						vehicleState.windowsDown = true
						TriggerServerEvent( "MSQSetVehicleWindow", vehicleState.windowsDown )
					end
				end
			end
		end
		
		SetPedDensityMultiplierThisFrame( ASData.crowd )
		SetVehicleDensityMultiplierThisFrame( ASData.traffic )
	end
end)

-- Additional Sync Low Priority Loop
Citizen.CreateThread( function()
	while not hasBeenInitialised do
		Wait( 500 )
	end
	
	while true do
		Wait( 100 )
		
		SetWeatherTypePersist( ASData.weather )
		SetWeatherTypeNowPersist( ASData.weather )
		SetWeatherTypeNow( ASData.weather )
		SetOverrideWeather( ASData.weather )
		SetBlackout( ASData.blackout )
	end
end)

-- In-game Clock Manipulation Loop
Citizen.CreateThread( function()
	while not hasBeenInitialised do
		Wait( 500 )
	end
	
	local timeBuffer = 0.0
	
	while true do
		Wait( 33 ) -- (int)(GetMillisecondsPerGameMinute() / 60)
		
		if not ASData.time.frozen then
			local gameSecond = 33.333 / ASData.time.rates.night
			
			if secondOfDay >= 19800 and secondOfDay <= 75600 then
				gameSecond = 33.333 / ASData.time.rates.day
			end
			
			timeBuffer = timeBuffer + round( 33.0 / gameSecond, 0 )
			
			if timeBuffer >= 1.0 then
				local skipSeconds = math.floor( timeBuffer )
				
				timeBuffer = timeBuffer - skipSeconds
				secondOfDay = secondOfDay + skipSeconds
				
				if secondOfDay >= 86400 then
					secondOfDay = secondOfDay % 86400
				end
			end
		end
		
		-- Apply time
		ASData.time.h = math.floor( secondOfDay / 3600 )
		ASData.time.m = math.floor( (secondOfDay - (ASData.time.h * 3600)) / 60 )
		ASData.time.s = secondOfDay - (ASData.time.h * 3600) - (ASData.time.m * 60)
		
		NetworkOverrideClockTime( ASData.time.h, ASData.time.m, ASData.time.s )
	end
end)