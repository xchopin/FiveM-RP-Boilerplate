--[[Info]]--

require "resources/essentialmode/lib/MySQL"
MySQL:open(database.host, database.name, database.username, database.password)



--[[Register]]--

RegisterServerEvent('ply_garages:CheckForSpawnVeh')
RegisterServerEvent('ply_garages:CheckForVeh')
RegisterServerEvent('ply_garages:SetVehOut')
RegisterServerEvent('ply_garages:SetVehIn')
RegisterServerEvent('ply_garages:PutVehInGarages')
RegisterServerEvent('ply_garages:CheckGarageForVeh')
RegisterServerEvent('ply_garages:CheckForSelVeh')
RegisterServerEvent('ply_garages:SelVeh')



--[[Local/Global]]--

vehicles = {}


--[[Events]]--

AddEventHandler('ply_garages:CheckForSpawnVeh', function(veh_id)
  TriggerEvent('es:getPlayerFromId', source, function(user)
    local veh_id = veh_id
    local player = user.identifier
    local executed_query = MySQL:executeQuery("SELECT * FROM user_vehicle WHERE identifier = '@username' AND ID = '@ID'",{['@username'] = player, ['@ID'] = veh_id})
    local result = MySQL:getResults(executed_query, {'vehicle_model', 'vehicle_plate', 'vehicle_state', 'vehicle_colorprimary', 'vehicle_colorsecondary', 'vehicle_pearlescentcolor', 'vehicle_wheelcolor' }, "identifier")
    if(result)then
      for k,v in ipairs(result)do
        vehicle = v.vehicle_model
        plate = v.vehicle_plate
        state = v.vehicle_state
        primarycolor = v.vehicle_colorprimary
        secondarycolor = v.vehicle_colorsecondary
        pearlescentcolor = v.vehicle_pearlescentcolor
        wheelcolor = v.vehicle_wheelcolor

      local vehicle = vehicle
      local plate = plate
      local state = state      
      local primarycolor = primarycolor
      local secondarycolor = secondarycolor
      local pearlescentcolor = pearlescentcolor
      local wheelcolor = wheelcolor
      end
    end
    TriggerClientEvent('ply_garages:SpawnVehicle', source, vehicle, plate, state, primarycolor, secondarycolor, pearlescentcolor, wheelcolor)
  end)
end)

AddEventHandler('ply_garages:CheckForVeh', function()
  TriggerEvent('es:getPlayerFromId', source, function(user)
    local state = "Sortit"
    local player = user.identifier
    local executed_query = MySQL:executeQuery("SELECT * FROM user_vehicle WHERE identifier = '@username' AND vehicle_state ='@state'",{['@username'] = player, ['@vehicle'] = vehicle, ['@state'] = state})
    local result = MySQL:getResults(executed_query, {'vehicle_model', 'vehicle_plate'}, "identifier")
    if(result)then
      for k,v in ipairs(result)do
        vehicle = v.vehicle_model
        plate = v.vehicle_plate
      local vehicle = vehicle
      local plate = plate
      end
    end
    TriggerClientEvent('ply_garages:StoreVehicle', source, vehicle, plate)
  end)
end)

AddEventHandler('ply_garages:SetVehOut', function(vehicle, plate)
  TriggerEvent('es:getPlayerFromId', source, function(user)
    local player = user.identifier
    local vehicle = vehicle
    local state = "Sortit"
    local plate = plate

    local executed_query = MySQL:executeQuery("UPDATE user_vehicle SET vehicle_state='@state' WHERE identifier = '@username' AND vehicle_plate = '@plate' AND vehicle_model = '@vehicle'",
      {['@username'] = player, ['@vehicle'] = vehicle, ['@state'] = state, ['@plate'] = plate})
  end)
end)

AddEventHandler('ply_garages:SetVehIn', function(plate)
  TriggerEvent('es:getPlayerFromId', source, function(user)
    local player = user.identifier
    local plate = plate
    local state = "Rentré"
    local executed_query = MySQL:executeQuery("UPDATE user_vehicle SET vehicle_state='@state' WHERE identifier = '@username' AND vehicle_plate = '@plate'",
      {['@username'] = player, ['@plate'] = plate, ['@state'] = state})
  end)
end)

AddEventHandler('ply_garages:PutVehInGarages', function(vehicle)
  TriggerEvent('es:getPlayerFromId', source, function(user)

    local player = user.identifier
    local state ="Rentré"

    local executed_query = MySQL:executeQuery("SELECT * FROM user_vehicle WHERE identifier = '@username'",{['@username'] = player})
    local result = MySQL:getResults(executed_query, {'identifier'})

    if(result)then
      for k,v in ipairs(result)do
        joueur = v.identifier
        local joueur = joueur
       end
    end

    if joueur ~= nil then

      local executed_query = MySQL:executeQuery("UPDATE user_vehicle SET `vehicle_state`='@state' WHERE identifier = '@username'",
      {['@username'] = player, ['@state'] = state})

    end
  end)
end)

AddEventHandler('ply_garages:CheckGarageForVeh', function()
  vehicles = {}
  TriggerEvent('es:getPlayerFromId', source, function(user)
    local player = user.identifier  
    local executed_query = MySQL:executeQuery("SELECT * FROM user_vehicle WHERE identifier = '@username'",{['@username'] = player})
    local result = MySQL:getResults(executed_query, {'id','vehicle_model', 'vehicle_name', 'vehicle_state'}, "id")
    if (result) then
        for _, v in ipairs(result) do
                --print(v.vehicle_model)
                --print(v.vehicle_plate)
                --print(v.vehicle_state)
                --print(v.id)
            t = { ["id"] = v.id, ["vehicle_model"] = v.vehicle_model, ["vehicle_name"] = v.vehicle_name, ["vehicle_state"] = v.vehicle_state}
            table.insert(vehicles, tonumber(v.id), t)
        end
    end
  end)  
    --print(vehicles[1].id)
    --print(vehicles[2].vehicle_model)
    TriggerClientEvent('ply_garages:getVehicles', source, vehicles)
end)

AddEventHandler('ply_garages:CheckForSelVeh', function()
  TriggerEvent('es:getPlayerFromId', source, function(user)
    local state = "Sortit"
    local player = user.identifier
    local executed_query = MySQL:executeQuery("SELECT * FROM user_vehicle WHERE identifier = '@username' AND vehicle_state ='@state'",{['@username'] = player, ['@vehicle'] = vehicle, ['@state'] = state})
    local result = MySQL:getResults(executed_query, {'vehicle_model', 'vehicle_plate'}, "identifier")
    if(result)then
      for k,v in ipairs(result)do
        vehicle = v.vehicle_model
        plate = v.vehicle_plate
      local vehicle = vehicle
      local plate = plate
      end
    end
    TriggerClientEvent('ply_garages:SelVehicle', source, vehicle, plate)
  end)
end)


AddEventHandler('ply_garages:SelVeh', function(plate)
  TriggerEvent('es:getPlayerFromId', source, function(user)
    local player = user.identifier
    local plate = plate

    local executed_query = MySQL:executeQuery("SELECT * FROM user_vehicle WHERE identifier = '@username' AND vehicle_plate ='@plate'",{['@username'] = player, ['@vehicle'] = vehicle, ['@plate'] = plate})
    local result = MySQL:getResults(executed_query, {'vehicle_plate'}, "identifier")
    if(result)then
      for k,v in ipairs(result)do
        
      local price = 2500
      user:addMoney((price))
      end
    end
    local executed_query = MySQL:executeQuery("DELETE from user_vehicle WHERE identifier = '@username' AND vehicle_plate = '@plate'",
      {['@username'] = player, ['@plate'] = plate})
    TriggerClientEvent("es_freeroam:notify", source, "CHAR_SIMEON", 1, "Simeon", false, "Véhicule détruit voici un peu d'argent!\n")
  end)
end)

AddEventHandler('playerConnecting', function()
	local player_state = 1
	local executed_query = MySQL:executeQuery("SELECT * FROM users WHERE player_state = '@player_state'",
      {['@player_state'] = player_state})
	local result = MySQL:getResults(executed_query, {'player_state'})
	if (result) then
		for i,v in ipairs(result) do
			sum = sum + v.player_state
		end
	else
		sum = 0
	end
	if (sum < 1) then
		local old_state = "Sortit"
		local state = "Rentré"
		local executed_query = MySQL:executeQuery("UPDATE user_vehicle SET `vehicle_state`='@state' WHERE vehicle_state = '@old_state'",
		{['@old_state'] = old_state, ['@state'] = state})
	end
end)

AddEventHandler('playerSpawn', function()
	TriggerEvent('es:getPlayerFromId', source, function(user)
		playerID = user.identifier
		local player_state = "1"
		MySQL:executeQuery("UPDATE users SET `player_state`='@player_state' WHERE identifier = '@identifier'",
		{['@player_state'] = player_state, ['@identifier'] = playerID})
	end)
end)

AddEventHandler('playerDropped', function()
		local player_state = "0"
		MySQL:executeQuery("UPDATE users SET `player_state`='@player_state' WHERE identifier = '@identifier'",
		{['@player_state'] = player_state, ['@identifier'] = playerID})
end)
