function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

function drawRct(x,y,width,height,r,g,b,a)
	DrawRect(x + width/2, y + height/2, width, height, r, g, b, a)
end

Citizen.CreateThread(function()
	while true do
	
		Citizen.Wait(1)
		local get_ped = GetPlayerPed(-1) -- current ped
		local get_ped_veh = GetVehiclePedIsIn(GetPlayerPed(-1),false) -- Current Vehicle ped is in
		local plate_veh = GetVehicleNumberPlateText(get_ped_veh) -- Vehicle Plate
		local veh_stop = IsVehicleStopped(get_ped_veh) -- Parked or not
		local veh_engine_health = GetVehicleEngineHealth(get_ped_veh) -- Vehicle Engine Damage 
		local veh_body_health = GetVehicleBodyHealth(get_ped_veh)
		local veh_burnout = IsVehicleInBurnout(get_ped_veh) -- Vehicle Burnout


		if(IsPedInAnyVehicle(GetPlayerPed(-1), false))then
			local kmh = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) * 3.6
			drawRct(0.11, 0.932, 0.046,0.03,0,0,0,100) 	-- UI:panel kmh	
			drawRct(0.159, 0.809, 0.005,0.173,0,0,0,100)  -- UI:engine_damage
			drawRct(0.1661, 0.809, 0.005,0.173,0,0,0,100)  -- UI:body_damage
			drawRct(0.1661, 0.809, 0.005,veh_body_health/5800,0,0,0,100)  -- UI:body_damage
			drawRct(0.159, 0.768, 0.0122, 0.038, 0,0,0,150)        -- UI: 1
			drawRct(0.028, 0.777, 0.029, 0.02, 0,0,0,150)          -- UI: 2
			drawRct(0.1131, 0.777, 0.031, 0.02, 0,0,0,150)         -- UI: 3
			drawRct(0.1445, 0.777, 0.0129, 0.028, 0,0,0,150)       -- UI: 4
			drawRct(0.014, 0.777, 0.013, 0.028, 0,0,0,150)         -- UI: 5
			drawRct(0.0625, 0.768, 0.045, 0.037, 0,0,0,150)        -- UI: 6
			drawRct(0.014, 0.768, 0.043, 0.007, 0,0,0,150)         -- UI: 7
			drawRct(0.0279, 0.798, 0.0293, 0.007, 0,0,0,150)       -- UI: 8
			drawRct(0.0575, 0.768, 0.004, 0.037, 0,0,0,150)        -- UI: 9
			drawRct(0.1131, 0.768, 0.044, 0.007, 0,0,0,150)        -- UI: 10
			drawRct(0.1131, 0.798, 0.031, 0.007, 0,0,0,150)        -- UI: 11
			drawRct(0.1085, 0.768, 0.004, 0.037, 0,0,0,150)        -- UI: 12
			
			drawTxt(0.61, 1.42, 1.0,1.0,0.64 , "~w~" .. math.ceil(kmh), 255, 255, 255, 255)  -- INT: kmh
			drawTxt(0.633, 1.432, 1.0,1.0,0.4, "~w~ km/h", 255, 255, 255, 255)	-- TXT: kmh
			drawTxt(0.563, 1.2624, 1.0,1.0,0.55, "~w~" .. plate_veh, 255, 255, 255, 255) -- TXT: Plate	

			if veh_burnout then
			drawTxt(0.535, 1.266, 1.0,1.0,0.44, "~r~DSC", 255, 255, 255, 200) -- TXT: DSC {veh_burnout}
			else
			drawTxt(0.535, 1.266, 1.0,1.0,0.44, "DSC", 255, 255, 255, 150)
			end		
			
			if (veh_engine_health > 0) and (veh_engine_health < 300) then
				drawTxt(0.619, 1.266, 1.0,1.0,0.45, "~y~Moteur", 255, 255, 255, 200) -- TXT: Fluid
				drawTxt(0.514, 1.269, 1.0,1.0,0.45, "~w~~y~Huile", 255, 255, 255, 200) -- TXT: Oil
				drawTxt(0.645, 1.270, 1.0,1.0,0.45, "~y~AC", 255, 255, 255, 200)
			elseif veh_engine_health < 1 then 
				drawRct(0.159, 0.809, 0.005, 0,0,0,0,100)  -- panel damage
				drawTxt(0.645, 1.270, 1.0,1.0,0.45, "~r~AC", 255, 255, 255, 200)
				drawTxt(0.619, 1.266, 1.0,1.0,0.45, "~r~Moteur", 255, 255, 255, 200) -- TXT: Fluid
				drawTxt(0.514, 1.269, 1.0,1.0,0.45, "~w~~r~Huile", 255, 255, 255, 200) -- TXT: Oil
				drawTxt(0.645, 1.270, 1.0,1.0,0.45, "~r~AC", 255, 255, 255, 200)
			else
				drawTxt(0.619, 1.266, 1.0,1.0,0.45, "Moteur", 255, 255, 255, 150) -- TXT: Fluid
				drawTxt(0.514, 1.269, 1.0,1.0,0.45, "Huile", 255, 255, 255, 150) -- TXT: Oil
				drawRct(0.159, 0.809, 0.005, veh_engine_health / 5800,0,0,0,100)  -- panel damage
				drawTxt(0.645, 1.270, 1.0,1.0,0.45, "~w~AC", 255, 255, 255, 150)
			end	
			
			if veh_stop then
				drawTxt(0.6605, 1.262, 1.0,1.0,0.6, "~r~P", 255, 255, 255, 200)
			else
				drawTxt(0.6605, 1.262, 1.0,1.0,0.6, "P", 255, 255, 255, 150)
			end
		end		
	end
end)