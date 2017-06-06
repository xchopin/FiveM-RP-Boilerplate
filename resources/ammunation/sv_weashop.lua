-- Loading MySQL Class
require "resources/essentialmode/lib/MySQL"
MySQL:open("127.0.0.1", "gta5_gamemode_essential", "root", "")

local max_number_weapons = 6 --maximum number of weapons that the player can buy. Weapons given at spawn doesn't count.
local cost_ratio = 100 --Ratio for withdrawing the weapons. This is price/cost_ratio = cost.

RegisterServerEvent('CheckMoneyForWea')
AddEventHandler('CheckMoneyForWea', function(weapon,price)
	TriggerEvent('es:getPlayerFromId', source, function(user)

		if (tonumber(user.money) >= tonumber(price)) then
			local player = user.identifier
			local nb_weapon = 0
			local executed_query = MySQL:executeQuery("SELECT * FROM user_weapons WHERE identifier = '@username'",{['@username'] = player})
			local result = MySQL:getResults(executed_query, {'weapon_model'}, "identifier")
			if result then
				for k,v in ipairs(result) do
					nb_weapon = nb_weapon + 1
				end
			end
			print(nb_weapon)
			if (tonumber(max_number_weapons) > tonumber(nb_weapon)) then
				-- Pay the shop (price)
				user:removeMoney((price))
				MySQL:executeQuery("INSERT INTO user_weapons (identifier,weapon_model,withdraw_cost) VALUES ('@username','@weapon','@cost')",
				{['@username'] = player, ['@weapon'] = weapon, ['@cost'] = (price)/cost_ratio})
				-- Trigger some client stuff
				TriggerClientEvent('FinishMoneyCheckForWea',source)
				TriggerClientEvent("es_freeroam:notify", source, "CHAR_AMMUNATION", 1, "Armurerie Los Santos", false, "Achat effectué\n")
			else
				TriggerClientEvent('ToManyWeapons',source)
				TriggerClientEvent("es_freeroam:notify", source, "CHAR_AMMUNATION", 1, "Armurerie Los Santos", false, "Inventaire complet! (max: "..max_number_weapons..")\n")
			end
		else
			-- Inform the player that he needs more money
			TriggerClientEvent("es_freeroam:notify", source, "CHAR_AMMUNATION", 1, "Armurerie Los Santos", false, "Tu n'as pas assez d'argent...\n")
		end
	end)
end)

RegisterServerEvent("weaponshop:playerSpawned")
AddEventHandler("weaponshop:playerSpawned", function()
	TriggerEvent('es:getPlayerFromId', source, function(user)
		TriggerEvent('weaponshop:GiveWeaponsToPlayer', source)
	end)
end)

RegisterServerEvent("weaponshop:GiveWeaponsToPlayer")
AddEventHandler("weaponshop:GiveWeaponsToPlayer", function(player)
	TriggerEvent('es:getPlayerFromId', player, function(user)
		local playerID = user.identifier
		local delay = nil
			
		local executed_query = MySQL:executeQuery("SELECT * FROM user_weapons WHERE identifier = '@username'",{['@username'] = playerID})
		local result = MySQL:getResults(executed_query, {'weapon_model','withdraw_cost'}, "identifier")
	
		delay = 2000
		if(result)then
			for k,v in ipairs(result) do
				--if (tonumber(user.money) >= tonumber(v.withdraw_cost)) then
					TriggerClientEvent("giveWeapon_spawn", player, v.weapon_model, delay)
				--	user:removeMoney((v.withdraw_cost))
			--	else
			--		TriggerClientEvent("es_freeroam:notify", source, "CHAR_AMMUNATION", 1, "Armurerie Los Santos", false, "Tu n'as pas assez d'argent...\n")
			--		return
			--	end
			end
		end

	end)
end)
