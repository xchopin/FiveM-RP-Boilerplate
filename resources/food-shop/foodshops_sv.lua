require "resources/essentialmode/lib/MySQL"
MySQL:open("127.0.0.1", "gta5_gamemode_essential", "root", "")

RegisterServerEvent('gabs:menu')
AddEventHandler('gabs:menu', function(fooditem)
		TriggerEvent('es:getPlayerFromId', source, function(user)
			for k,v in ipairs(fooditems) do
				if (v.name == fooditem) then
					if (user.money >= v.price) then
						user:removeMoney(v.price)
						if (v.type == 1) then
							TriggerClientEvent("food:vdrink", source, v.value)
						elseif (v.type == 2) then
							TriggerClientEvent("food:veat", source, v.value)
						end
					else
						TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "Vous n'avez pas assez d'argent ~g($".. v.value .. ")~w.")
					end
				end
			end
		end)
end)

local getQuantityval = 0

RegisterServerEvent('player:cbgetQuantity')
AddEventHandler("player:cbgetQuantity", function(cbamount)
	getQuantityval = cbamount
end)

RegisterServerEvent('gabs:menuvdk')
AddEventHandler('gabs:menuvdk', function(fooditem)
		TriggerEvent('es:getPlayerFromId', source, function(user)
			local player = user.identifier
			TriggerClientEvent("player:getQuantity", fooditem[1])
			-- local executed_query = MySQL:executeQuery("SELECT SUM(quantity) as total FROM user_inventory WHERE user_id = '@username'", { ['@username'] = player })
			-- local result = MySQL:getResults(executed_query, { 'total' })
			-- local total = result[1].total
			if (getQuantityval + fooditem[2] <= 35) then
				if (user.money >= fooditem[3]) then
					user:removeMoney(fooditem[3])
					TriggerClientEvent("player:receiveItem", source, fooditem[1], fooditem[2])
				else
					TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "Vous n'avez pas assez d'argent.")
				end
			else
				TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "Vous n'avez pas de place dans votre inventaire.")
			end
		end)
end)

function splitString(self, delimiter)
	local words = self:Split(delimiter)
	local output = {}
	for i = 0, #words - 1 do
		table.insert(output, words[i])
	end

	return output
end
