--[[Info]]--

require "resources/essentialmode/lib/MySQL"
MySQL:open("localhost", "gta5_gamemode_essential", "root", "")



--[[Register]]--

RegisterServerEvent("ply_prefecture:GetLicences")
RegisterServerEvent("ply_prefecture:CheckForVeh")
RegisterServerEvent("ply_prefecture:CheckForLicences")
RegisterServerEvent("ply_prefecture:SetLicenceForVeh")



--[[Local/Global]]--

licences = {}



--[[Events]]--

AddEventHandler("ply_prefecture:GetLicences", function()
    licences = {}
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local player = user.identifier
        local executed_query = MySQL:executeQuery("SELECT * FROM licences")
        local result = MySQL:getResults(executed_query, { 'ID', 'name', 'price'}, "ID")
        if (result) then
            for _, v in ipairs(result) do
                t = { ["name"] = v.name, ["price"] = v.price, ["id"] = v.ID }
                table.insert(licences, tonumber(v.ID), t)
            end
        end
    end)
    TriggerClientEvent("ply_prefecture:GetLicences", source, licences)
end)

AddEventHandler('ply_prefecture:CheckForLicences', function(licID)
  TriggerEvent('es:getPlayerFromId', source, function(user)
    licID = licID
    local player = user.identifier
    local executed_query = MySQL:executeQuery("SELECT * FROM user_licence JOIN licences ON `user_licence`.`licence_id` = `licences`.`id` WHERE identifier = '@username' AND licence_id ='@licID'",
    {['@username'] = player, ['@licID'] = licID})
    local result = MySQL:getResults(executed_query, {'licence_id','name','price'}, "identifier")
    licence_id = 0
    print(licence_id)
    if(result)then
      for k,v in ipairs(result)do
        licence_id = v.licence_id
        name = v.name
        price = v.price
      end
    end    
    print(licence_id)
    if (licence_id > 0) then      
        TriggerClientEvent("es_freeroam:notify", source, "CHAR_EPSILON", 1, "Préfecture", false, "Ce permis est déjà acheté")
    else
      local executed_query = MySQL:executeQuery("SELECT * FROM licences WHERE id = '@licID'",
      {['@licID'] = licID})
      local result = MySQL:getResults(executed_query, {'price','name'}, "id")
      if(result)then
        for k,v in ipairs(result)do
          price = v.price
          name = v.name
        end
      end
      local executed_query = MySQL:executeQuery("INSERT INTO user_licence (`identifier`, `licence_id`) VALUES ('@identifier', '@licID')",
      {['@identifier'] = player, ['@licID'] = licID})        
      user:removeMoney((price))    
      TriggerClientEvent("es_freeroam:notify", source, "CHAR_EPSILON", 1, "Préfecture", false, "Permis acheté")
    end
  end)
end)

AddEventHandler('ply_prefecture:CheckForVeh', function()
  TriggerEvent('es:getPlayerFromId', source, function(user)
    local player = user.identifier
    local executed_query = MySQL:executeQuery("SELECT * FROM users WHERE personalvehicle IS NOT NULL AND identifier = '@username'",
    {['@username'] = player})
    local result = MySQL:getResults(executed_query, {'personalvehicle'}, "identifier")
    if(result)then
    	if (result[1] ~= nil) then
    		if (result[1].personalvehicle ~= nil)then
      			for k,v in ipairs(result)do
      			  personalvehicle = v.personalvehicle
      			end
      			TriggerClientEvent('ply_prefecture:CheckForRealVeh', source, personalvehicle)
      		end
      	end
    end
  
  end)
end)

AddEventHandler('ply_prefecture:SetLicenceForVeh', function(name, vehicle, plate, primarycolor, secondarycolor, pearlescentcolor, wheelcolor)
  TriggerEvent('es:getPlayerFromId', source, function(user)

    local player = user.identifier
    local name = name
    local plate = plate
    local state = "Sortit"
    local primarycolor = primarycolor
    local secondarycolor = secondarycolor
    local pearlescentcolor = pearlescentcolor
    local wheelcolor = wheelcolor

    local executed_query = MySQL:executeQuery("INSERT INTO user_vehicle (`identifier`, `vehicle_name`, `vehicle_model`, `vehicle_plate`, `vehicle_state`, `vehicle_colorprimary`, `vehicle_colorsecondary`, `vehicle_pearlescentcolor`, `vehicle_wheelcolor`) VALUES ('@username', '@name', '@vehicle', '@plate', '@state', '@primarycolor', '@secondarycolor', '@pearlescentcolor', '@wheelcolor')",
    {['@username'] = player, ['@name'] = name, ['@vehicle'] = vehicle, ['@plate'] = plate, ['@state'] = state, ['@primarycolor'] = primarycolor, ['@secondarycolor'] = secondarycolor, ['@pearlescentcolor'] = pearlescentcolor, ['@wheelcolor'] = wheelcolor})
    local state = "vide"
    local executed_query = MySQL:executeQuery("UPDATE users SET personalvehicle='@state' WHERE identifier = '@username'",
    {['@username'] = player, ['@state'] = state})
    TriggerClientEvent("es_freeroam:notify", source, "CHAR_EPSILON", 1, "Préfecture", false, "Véhicule enregistré")
  end)
end)
