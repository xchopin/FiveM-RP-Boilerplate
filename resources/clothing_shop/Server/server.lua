---------------------------------------------------------------------------------------
--                     Author: Xavier CHOPIN <www.github.com/xchopin>                --
--                                 License: Apache 2.0                               --
---------------------------------------------------------------------------------------

require "resources/essentialmode/lib/MySQL"
local settings = require "resources/clothing_shop/Server/settings"
MySQL:open(settings.host, settings.db, settings.user, settings.password)
local SQL_COLUMNS = {
    'skin',
    'face',
    'face_texture',
    'hair',
    'hair_texture',
    'shirt',
    'shirt_texture',
    'pants',
    'pants_texture',
    'shoes',
    'shoes_texture',
    'vest',
    'vest_texture',
    'bag',
    'bag_texture',
    'hat',
    'hat_texture',
    'mask',
    'mask_texture',
    'glasses',
    'glasses_texture',
    'gloves',
    'gloves_texture',
    'jacket',
    'jacket_texture',
    'ears',
    'ears_texture'
}

-- Gives you the column name for a collection and id given
-- collection can be "skin", valueId can be null)
-- 					 "component", requires a valueId
-- 					 "prop", requires a valueId
function giveColumnName(collection, valueId)
    local res = nil
    if (collection == "skin") then
        res = "skin"
    else
        local id = tonumber(valueId)
        if (collection == "component") then
        	if (id == 0) then
        	    res = "face"
        	end
        	if (id == 1) then
        	    res = "mask"
        	end
        	if (id == 2) then
        	    res = "hair"
        	end
        	if (id == 3) then
        	    res = "gloves"
        	end
        	if (id == 4) then
        	    res = "pants"
        	end
        	if (id == 5) then
        	    res = "bag"
        	end
        	if (id == 6) then
        	    res = "shoes"
        	end
        	if (id == 8) then
        	    res = "shirt"
        	end
        	if (id == 9) then
        	    res = "vest"
        	end
        	if (id == 11) then
        	    res = "jacket"
        	end
		else
			if (collection == "prop") then
				if (id == 0) then
					res = "hat"
				end
				if (id == 1) then
					res = "glasses"
				end
				if (id == 2) then
					res = "ears"
				end
			end
		end
	end

 	return res
end


RegisterServerEvent("clothing_shop:SpawnPlayer_server")
AddEventHandler("clothing_shop:SpawnPlayer_server", function()
	TriggerEvent('es:getPlayerFromId', source, function(user)
		
		local player = user.identifier
		local executed_query = MySQL:executeQuery("SELECT isFirstConnection FROM users WHERE identifier = '@username'", {['@username'] = player})
		local result = MySQL:getResults(executed_query, {'isFirstConnection'}, "identifier")
		if(result[1].isFirstConnection == 1)then
			MySQL:executeQuery("INSERT INTO user_clothes(identifier) VALUES ('@identifier')",{['@identifier']=player})
			MySQL:executeQuery("UPDATE users SET isFirstConnection = 0 WHERE identifier = '@username'", {['@username'] = player})
			executed_query = MySQL:executeQuery("SELECT * FROM user_clothes WHERE identifier = '@username'", {['@username'] = player})
			result = MySQL:getResults(executed_query, SQL_COLUMNS, "identifier")
			TriggerClientEvent("clothing_shop:loadItems_client", source, result[1]) -- Updates the client's skin with default values
		end
			executed_query = MySQL:executeQuery("SELECT * FROM user_clothes WHERE identifier = '@username'", {['@username'] = player})
			result = MySQL:getResults(executed_query, SQL_COLUMNS, "identifier")
			--TriggerServerEvent('weaponshop:GiveWeaponsToPlayer', source)
			TriggerClientEvent("clothing_shop:loadItems_client", source, result[1]) -- Updates the client's skin with default values
			
	end)
end)


-- LEGACY FUNCTION TO BE ABLE TO USE OLD PLUGINS
RegisterServerEvent("skin_customization:SpawnPlayer")
AddEventHandler("skin_customization:SpawnPlayer", function()
	TriggerEvent('es:getPlayerFromId', source, function(user)
		local player = user.identifier
		local executed_query = MySQL:executeQuery("SELECT isFirstConnection FROM users WHERE identifier = '@username'", {['@username'] = player})
		local result = MySQL:getResults(executed_query, {'isFirstConnection'}, "identifier")
		if(result[1].isFirstConnection == 1)then
			MySQL:executeQuery("INSERT INTO user_clothes(identifier) VALUES ('@identifier')",{['@identifier']=player})
			MySQL:executeQuery("UPDATE users SET isFirstConnection = 0 WHERE identifier = '@username'", {['@username'] = player})
		end
		executed_query = MySQL:executeQuery("SELECT * FROM user_clothes WHERE identifier = '@username'", {['@username'] = player})
		result = MySQL:getResults(executed_query, SQL_COLUMNS, "identifier")
		TriggerClientEvent("clothing_shop:loadItems_client", source, result[1]) -- Updates the client's skin with default values
	end)
end)



RegisterServerEvent("clothing_shop:SetItems_server")
	AddEventHandler("clothing_shop:SetItems_servers",function()
	TriggerEvent('es:getPlayerFromId', source, function(user)
		local player = user.identifier
		local executed_query = MySQL:executeQuery("SELECT * FROM user_clothes WHERE identifier = '@username'", {['@username'] = player})
		local result = MySQL:getResults(executed_query, SQL_COLUMNS, "identifier")
		TriggerClientEvent("clothing_shop:loadItems_client", source, result[1])
	end)
end)

RegisterServerEvent("clothing_shop:SaveItem_server")
AddEventHandler("clothing_shop:SaveItem_server", function(item, values)
	TriggerEvent('es:getPlayerFromId', source, function(user)
		local name = giveColumnName(item.collection, item.id)
		if (name == "skin") then
			MySQL:executeQuery("UPDATE user_clothes SET skin = '@value' WHERE identifier = '@identifier'",{ 
				   ['@value'] = values.value, 
				   ['@identifier'] = user.identifier	
			    }
			)
		else
			MySQL:executeQuery("UPDATE user_clothes SET ".. name .." = '@value', ".. name..'_texture' .." = '@texture_value' WHERE identifier = '@identifier'",{ 
				   ['@value'] = values.value,
				   ['@texture_value'] = values.texture_value,
				   ['@identifier'] = user.identifier	
			    }
			)
		end
		TriggerClientEvent("es_freeroam:notify", source, "CHAR_SOCIAL_CLUB", 1, "Binco Shop", false, "Nouvel élément acheté!")
		
	end)
end)

RegisterServerEvent("clothing_shop:GetSkin_server")
	AddEventHandler("clothing_shop:GetSkin_server",function()
	TriggerEvent('es:getPlayerFromId', source, function(user)
		local executed_query = MySQL:executeQuery("SELECT skin FROM user_clothes WHERE identifier = '@identifier'", {['@identifier'] = user.identifier})
		local result = MySQL:getResults(executed_query, {"skin"}, "identifier")
		TriggerClientEvent("clothing_shop:getSkin_client", source, result[1].skin)
	end)
end)


RegisterServerEvent("clothing_shop:WithDraw_server")
AddEventHandler("clothing_shop:WithDraw_server",function(item, values)
TriggerEvent('es:getPlayerFromId', source, function(user)
		local executed_query = MySQL:executeQuery("SELECT money FROM users WHERE identifier = '@identifier'", {['@identifier'] = user.identifier})
		local result = MySQL:getResults(executed_query, 'money', "identifier")
		TriggerClientEvent("clothing_shop:buyItem_client", source, {item=item, values=values, money=result[1].money})
	end)
end)
