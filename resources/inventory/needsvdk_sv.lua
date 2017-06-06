--METTRE DANS LE DOSSIER "vdk_inventory".

require "resources/essentialmode/lib/MySQL"
MySQL:open("127.0.0.1", "gta5_gamemode_essential", "root", "Nadoreevax_5$")

RegisterServerEvent("gabs:eatvdkitem")
AddEventHandler("gabs:eatvdkitem", function(qty, id)
    local player = getPlayerID(source)
	local executed_query = MySQL:executeQuery("SELECT * FROM items WHERE `id` = @foodid", {['@foodid'] = tonumber(id)})
	local result = MySQL:getResults(executed_query, { 'food', 'water', 'needs', 'type' }, "id")
	if (tonumber(result[1].food) + tonumber(result[1].water) > 0) then
		MySQL:executeQuery("UPDATE user_inventory SET `quantity` = @qty WHERE `user_id` = '@username' AND `item_id` = @id", { ['@username'] = player, ['@qty'] = tonumber(qty), ['@id'] = tonumber(id) })
		TriggerEvent('gabs:addcustomneeds', source, tonumber(result[1].food),tonumber(result[1].water), 0)
        if (result[1].type == "drink") then
           TriggerClientEvent("gabs:drink", source)
        else 
            TriggerClientEvent("gabs:eat", source)
        end        
	end
end)



function getPlayerID(source)
    local identifiers = GetPlayerIdentifiers(source)
    local player = getIdentifiant(identifiers)
    return player
end

function getIdentifiant(id)
    for _, v in ipairs(id) do
        return v
    end
end