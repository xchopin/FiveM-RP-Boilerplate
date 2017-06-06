--[[Register]]--

RegisterNetEvent("ply_garages:getVehicles")
RegisterNetEvent('ply_garages:SpawnVehicle')
RegisterNetEvent('ply_garages:StoreVehicle')
RegisterNetEvent('ply_garages:SelVehicle')



--[[Local/Global]]--

VEHICLES = {}
local vente_location = {-45.228, -1083.123, 25.816}
local inrangeofgarage = false
local currentlocation = nil

local garages = {
	{name="Garage", colour=3, id=50, x=215.124, y=-791.377, z=29.646},
  	{name="Garage", colour=3, id=50, x=-334.685, y=289.773, z=84.705},
  	{name="Garage", colour=3, id=50, x=-55.272, y=-1838.71, z=25.442},
  	{name="Garage", colour=3, id=50, x=126.434, y=6610.04, z=30.750},
}

garageSelected = { {x=nil, y=nil, z=nil}, }

--[[Functions]]--

function MenuGarage()
    ped = GetPlayerPed(-1);
    MenuTitle = "Garage"
    ClearMenu()
    Menu.addButton("Rentrer le véhicule","RentrerVehicule",nil)
    Menu.addButton("Sortir un véhicule","ListeVehicule",nil)
    Menu.addButton("Fermer","CloseMenu",nil) 
end

function RentrerVehicule()
	TriggerServerEvent('ply_garages:CheckForVeh',source)
	CloseMenu()
end

function ListeVehicule()
    ped = GetPlayerPed(-1);
    MenuTitle = "Vehicules"
    ClearMenu()
    for ind, value in pairs(VEHICLES) do
            Menu.addButton(tostring(value.vehicle_name) .. " : " .. tostring(value.vehicle_state), "OptionVehicle", value.id)
    end    
    Menu.addButton("Retour","MenuGarage",nil)
end

function OptionVehicle(vehID)
	local vehID = vehID
    MenuTitle = "Options"
    ClearMenu()
    Menu.addButton("Sortir", "SortirVehicule", vehID)
    Menu.addButton("Retour", "ListeVehicule", nil)
end

function SortirVehicule(vehID)
	local vehID = vehID
	TriggerServerEvent('ply_garages:CheckForSpawnVeh', vehID)
	CloseMenu()
end

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function CloseMenu()
    Menu.hidden = true
end

function LocalPed()
	return GetPlayerPed(-1)
end

function IsPlayerInRangeOfGarage()
	return inrangeofgarage
end

function Chat(debugg)
    TriggerEvent("chatMessage", '', { 0, 0x99, 255 }, tostring(debugg))
end

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		for _, garage in pairs(garages) do
			DrawMarker(1, garage.x, garage.y, garage.z, 0, 0, 0, 0, 0, 0, 3.001, 3.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
			if GetDistanceBetweenCoords(garage.x, garage.y, garage.z, GetEntityCoords(LocalPed())) < 1.5 then
				drawTxt('~g~E~s~ pour ouvrir le menu',0,1,0.5,0.8,0.6,255,255,255,255)
				if IsControlJustPressed(1, 86) then
					garageSelected.x = garage.x
					garageSelected.y = garage.y
					garageSelected.z = garage.z
					MenuGarage()
					Menu.hidden = not Menu.hidden 
				end
				Menu.renderGUI() 
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		local near = false
		Citizen.Wait(0)
		for _, garage in pairs(garages) do		
			if (GetDistanceBetweenCoords(garage.x, garage.y, garage.z, GetEntityCoords(LocalPed())) < 1.5 and near ~= true) then 
				near = true							
			end
		end
		if near == false then 
			Menu.hidden = true;
		end
	end
end)

Citizen.CreateThread(function()
    for _, item in pairs(garages) do
      item.blip = AddBlipForCoord(item.x, item.y, item.z)
      SetBlipSprite(item.blip, item.id)
      SetBlipAsShortRange(item.blip, true)
	    SetBlipColour(item.blip, item.colour)
	    SetBlipScale(item.blip, 0.7)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(item.name)
      EndTextCommandSetBlipName(item.blip)
    end
end)

Citizen.CreateThread(function()
	local loc = vente_location
	pos = vente_location
	local blip = AddBlipForCoord(pos[1],pos[2],pos[3])
	SetBlipSprite(blip,207)
	SetBlipColour(blip, 3)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Revente')
	EndTextCommandSetBlipName(blip)
	SetBlipAsShortRange(blip,true)
	SetBlipAsMissionCreatorBlip(blip,true)
	checkgarage = 0
	while true do
		Wait(0)
		DrawMarker(1,vente_location[1],vente_location[2],vente_location[3],0,0,0,0,0,0,3.001,3.0001,0.5001,0,155,255,200,0,0,0,0)
		if GetDistanceBetweenCoords(vente_location[1],vente_location[2],vente_location[3],GetEntityCoords(LocalPed())) < 5 and IsPedInAnyVehicle(LocalPed(), true) == false then
			drawTxt('Appuyez ~g~E~s~ pour détruire le véhicule',0,1,0.5,0.8,0.6,255,255,255,255)
			if IsControlJustPressed(1, 86) then
				TriggerServerEvent('ply_garages:CheckForSelVeh',source)
			end
		end
	end
end)



--[[Events]]--

AddEventHandler("ply_garages:getVehicles", function(THEVEHICLES)
    VEHICLES = {}
    VEHICLES = THEVEHICLES
end)

AddEventHandler("playerSpawned", function()
    TriggerServerEvent("ply_garages:CheckGarageForVeh")
end)

AddEventHandler('ply_garages:SpawnVehicle', function(vehicle, plate, state, primarycolor, secondarycolor, pearlescentcolor, wheelcolor)
	local car = GetHashKey(vehicle)
	local plate = plate
	local state = state
	local primarycolor = tonumber(primarycolor)
	local secondarycolor = tonumber(secondarycolor)
	local pearlescentcolor = tonumber(pearlescentcolor)
	local wheelcolor = tonumber(wheelcolor)
	Citizen.CreateThread(function()
		Citizen.Wait(3000)
		local caisseo = GetClosestVehicle(garageSelected.x, garageSelected.y, garageSelected.z, 3.000, 0, 70)
		if DoesEntityExist(caisseo) then
			drawNotification("La zone est encombrée") 
		else
			if state == "Sortit" then
				drawNotification("Ce véhicule n'est pas dans le garage")
			else
				local mods = {}
				for i = 0,24 do
					mods[i] = GetVehicleMod(veh,i)
				end
				RequestModel(car)
				while not HasModelLoaded(car) do
				Citizen.Wait(0)
				end
				veh = CreateVehicle(car, garageSelected.x, garageSelected.y, garageSelected.z, 0.0, true, false)
				for i,mod in pairs(mods) do
					SetVehicleModKit(personalvehicle,0)
					SetVehicleMod(personalvehicle,i,mod)
				end
				SetVehicleNumberPlateText(veh, plate)
				SetVehicleOnGroundProperly(veh)
				SetVehicleHasBeenOwnedByPlayer(veh,true)
				local id = NetworkGetNetworkIdFromEntity(veh)
				SetNetworkIdCanMigrate(id, true)
				SetVehicleColours(veh, primarycolor, secondarycolor)
				SetVehicleExtraColours(veh, pearlescentcolor, wheelcolor)
				SetEntityInvincible(veh, false) 
				drawNotification("Véhicule sorti")				
				TriggerServerEvent('ply_garages:SetVehOut', vehicle, plate)
   				TriggerServerEvent("ply_garages:CheckGarageForVeh")
			end
		end
	end)
end)

AddEventHandler('ply_garages:StoreVehicle', function(vehicle, plate)
	local car = GetHashKey(vehicle)	
	local plate = plate
	Citizen.CreateThread(function()
		Citizen.Wait(3000)
		local caissei = GetClosestVehicle(garageSelected.x, garageSelected.y, garageSelected.z, 3.000, 0, 70)
		SetEntityAsMissionEntity(caissei, true, true)		
		local platecaissei = GetVehicleNumberPlateText(caissei)
		if DoesEntityExist(caissei) then	
			if plate ~= platecaissei then					
				drawNotification("Ce n'est pas ton véhicule")
			else
				Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(caissei))
				drawNotification("Véhicule rentré")
				TriggerServerEvent('ply_garages:SetVehIn', plate)
				TriggerServerEvent("ply_garages:CheckGarageForVeh")
			end
		else
			drawNotification("Aucun véhicule présent")
		end   
	end)
end)

AddEventHandler('ply_garages:SelVehicle', function(vehicle, plate)
	local car = GetHashKey(vehicle)	
	local plate = plate
	Citizen.CreateThread(function()		
		Citizen.Wait(0)
		local caissei = GetClosestVehicle(vente_location[1],vente_location[2],vente_location[3], 3.000, 0, 70)
		SetEntityAsMissionEntity(caissei, true, true)
		local platecaissei = GetVehicleNumberPlateText(caissei)
		if DoesEntityExist(caissei) then
			if plate ~= platecaissei then
				drawNotification("Ce n'est pas ton véhicule")
			else
				Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(caissei))
				TriggerServerEvent('ply_garages:SelVeh', plate)
				TriggerServerEvent("ply_garages:CheckGarageForVeh")
			end
		else
			drawNotification("Aucun véhicule présent")
		end
	end)
end)

local firstspawn = 0
AddEventHandler('playerSpawned', function(spawn)
	if firstspawn == 0 then
		RemoveIpl('v_carshowroom')
		RemoveIpl('shutter_open')
		RemoveIpl('shutter_closed')
		RemoveIpl('shr_int')
		RemoveIpl('csr_inMission')
		RequestIpl('v_carshowroom')
		RequestIpl('shr_int')
		--RequestIpl('csr_inMission')
		RequestIpl('shutter_closed')
		firstspawn = 1
	end
end)
