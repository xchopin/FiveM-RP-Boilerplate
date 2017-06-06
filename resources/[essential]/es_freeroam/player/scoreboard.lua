local Settings = {
	--Should the scoreboard draw wanted level?
	["WantedStars"] = false,

	--Should the scoreboard draw player ID?
	["PlayerID"] = true,

	--Should the scoreboard draw voice indicator?
	["VoiceIndicator"] = true,

	--Display time in milliseconds
	["DisplayTime"] = 5000,

	--Keys that will activate the scoreboard.
	--Change only the number value, NOT the 'true'
	--Multiple keys can be used, simply add another row with another number
	--See: https://wiki.gtanet.work/index.php?title=Game_Controls

	--MultiplayerInfo / Z
	[20] = true,

	--Detonate / G
	--[47] = true,
}

-- END OF SETTINGS --

local function DrawPlayerList()
    local players = {}

    for i = 0, 31 do
        if NetworkIsPlayerActive( i ) then
            table.insert( players, i )
        end
    end

	--Top bar
	DrawRect( 0.11, 0.025, 0.2, 0.03, 0, 0, 0, 220 )

	--Top bar title
	SetTextFont( 4 )
	SetTextProportional( 0 )
	SetTextScale( 0.45, 0.45 )
	SetTextColour( 255, 255, 255, 255 )
	SetTextDropShadow( 0, 0, 0, 0, 255 )
	SetTextEdge( 1, 0, 0, 0, 255 )
	SetTextEntry( "STRING" )
	AddTextComponentString( "Players: " .. #players )
	DrawText( 0.015, 0.007 )

	for k, v in pairs( players ) do
		local r
		local g
		local b

		if k % 2 == 0 then
			r = 28
			g = 47
			b = 68
		else
			r = 38
			g = 57
			b = 74
		end

		--Row BG
		DrawRect( 0.11, 0.025 + ( k * 0.03 ), 0.2, 0.03, r, g, b, 220 )

		--Name Label
		SetTextFont( 4 )
		SetTextScale( 0.45, 0.45 )
		SetTextColour( 255, 255, 255, 255 )
		SetTextEntry( "STRING" )
		if Settings["PlayerID"] then
			local pid = GetPlayerServerId(v)
		AddTextComponentString(pid .. " ".. GetPlayerName(v))
	   else
			AddTextComponentString(GetPlayerName(v))
		end
		DrawText( 0.015, 0.007 + ( k * 0.03 ) )


		--Voice Indicator
		if Settings["VoiceIndicator"] then
			local transparency = 60

			if NetworkIsPlayerTalking( v ) then
				transparency = 255
			end

			DrawSprite( "mplobby", "mp_charcard_stats_icons9", 0.2, 0.024 + ( k * 0.03 ), 0.015, 0.025, 0, 255, 255, 255, transparency )
		end

		--Wanted Stars
		if Settings["WantedStars"] then
			local wantedLevel = GetPlayerWantedLevel( v ) or 0
			wantedLevel = wantedLevel

			for i=1, 5 do
				local transparency = 60

				if wantedLevel >= i then
					transparency = 255
				end

				DrawSprite( "mpleaderboard", "leaderboard_star_icon", 0.195 - ( i * 0.010	 ), 0.024 + ( k * 0.03 ), 0.0175, 0.0275, 0, 255, 255, 255, transparency )
			end
		end
	end
end

local LastPress = 0

Citizen.CreateThread( function()
	RequestStreamedTextureDict( "mplobby" )
	RequestStreamedTextureDict( "mpleaderboard" )

	while true do
		Wait( 0 )

		for k, v in pairs( Settings ) do
			if type( k ) == "number" and v == true then
				if IsControlPressed( 0, k ) then
					LastPress = GetGameTimer()
				end
			end
		end

		if GetGameTimer() < LastPress + Settings["DisplayTime"] then
			DrawPlayerList()
		end

	end
end )
