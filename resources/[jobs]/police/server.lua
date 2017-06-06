require "resources/essentialmode/lib/MySQL"
MySQL:open("localhost", "gta5_gamemode_essential", "root", "")

local inServiceCops = {}

function addCop(identifier)
    MySQL:executeQuery("INSERT INTO police (`identifier`) VALUES ('@identifier')", { ['@identifier'] = identifier})
end

function remCop(identifier)
    MySQL:executeQuery("DELETE FROM police WHERE identifier = '@identifier'", { ['@identifier'] = identifier})
end

function checkIsCop(identifier)
    local query = MySQL:executeQuery("SELECT * FROM users INNER JOIN jobs ON jobs.job_id = users.job WHERE job_name LIKE 'LSPD %' AND identifier = '@identifier'", { ['@identifier'] = identifier})
    local result = MySQL:getResults(query, {'job_id'}, "identifier")

    if(not result[1]) then
        TriggerClientEvent('police:receiveIsCop', source, "inconnu")
    else
        TriggerClientEvent('police:receiveIsCop', source, result[1].job_id)
    end
end

function s_checkIsCop(identifier)
    local query = MySQL:executeQuery("SELECT * FROM users INNER JOIN jobs ON jobs.job_id = users.job WHERE job_name LIKE 'LSPD %' AND users.identifier = '@identifier'", { ['@identifier'] = identifier})
    local result = MySQL:getResults(query, {'job_id'}, "identifier")

    if(not result[1]) then
        return "nil"
    else
        return result[1].job_id
    end
end

function checkInventory(target)
    TriggerClientEvent("pm:notifs", target, "~r~ Attention: La police vous fouille !" )
    local strResult = GetPlayerName(target).." possède : "
    local identifier = ""
    TriggerEvent("es:getPlayerFromId", target, function(player)
        identifier = player.identifier
        local executed_query = MySQL:executeQuery("SELECT * FROM `user_inventory` JOIN items ON items.id = user_inventory.item_id WHERE user_id = '@username'", { ['@username'] = identifier })
        local result = MySQL:getResults(executed_query, { 'quantity', 'libelle', 'item_id', 'isIllegal' }, "item_id")
        if (result) then
            for _, v in ipairs(result) do
                if(v.quantity ~= 0) then
                    strResult = strResult .. v.quantity .. " de " .. v.libelle .. ", "
                end
                if(tonumber(v.isIllegal) == 1) then
                    TriggerClientEvent('police:dropIllegalItem', target, v.item_id)
                end
            end
        end

        strResult = strResult .. " / "

        local executed_query = MySQL:executeQuery("SELECT * FROM user_weapons WHERE identifier = '@username'", { ['@username'] = identifier })
        local result = MySQL:getResults(executed_query, { 'weapon_model' }, 'identifier' )
        if (result) then
            for _, v in ipairs(result) do
                strResult = strResult .. "possession de " .. v.weapon_model .. ", "
            end
        end
    end)
    TriggerClientEvent('chatMessage', source, 'LSPD', {255, 0, 0}, strResult)

    return strResult
end


function checkDirtyMoney(target)
    local identifier = ""
    TriggerEvent("es:getPlayerFromId", target, function(player)
        identifier = player.identifier
        local executed_query = MySQL:executeQuery("SELECT dirty_money FROM users WHERE identifier = '@username'", { ['@username'] = identifier })
        local result = MySQL:getResults(executed_query, { 'dirty_money' }, "item_id")
        if (tonumber(result[1].dirty_money) > 0) then
            local strResult = GetPlayerName(target).." possède $".. result[1].dirty_money.. " d'argent sale !"
            TriggerClientEvent('chatMessage', source, 'LSPD', {255, 0, 0}, strResult)
            TriggerClientEvent("pm:notifs", target, "~r~ Attention: La police a confisqué votre argent sale !" )
            player:setDirty_Money(0)
            MySQL:executeQuery("UPDATE users SET dirty_money = 0 WHERE identifier = '@username'", {
                  ['@username'] = identifier
            })
        else
            TriggerClientEvent('chatMessage', source, 'LSPD', {255, 0, 0}, GetPlayerName(target).." ne possède pas d'argent sale !")
        end
    end)
end

AddEventHandler('playerDropped', function()
    if(inServiceCops[source]) then
        inServiceCops[source] = nil

        for i, c in pairs(inServiceCops) do
            TriggerClientEvent("police:resultAllCopsInService", i, inServiceCops)
        end
    end
end)

AddEventHandler('es:playerDropped', function(player)
    local isCop = s_checkIsCop(player.identifier)
    if(isCop ~= "nil") then
        TriggerEvent("jobssystem:disconnectReset", player, 7)
    end
end)

RegisterServerEvent('police:checkIsCop')
AddEventHandler('police:checkIsCop', function()
    TriggerEvent("es:getPlayerFromId", source, function(user)
        local identifier = user.identifier
        checkIsCop(identifier)
    end)
end)

RegisterServerEvent('police:takeService')
AddEventHandler('police:takeService', function()

    if(not inServiceCops[source]) then
        inServiceCops[source] = GetPlayerName(source)

        for i, c in pairs(inServiceCops) do
            TriggerClientEvent("police:resultAllCopsInService", i, inServiceCops)
        end
    end
end)

RegisterServerEvent('police:breakService')
AddEventHandler('police:breakService', function()

    if(inServiceCops[source]) then
        inServiceCops[source] = nil

        for i, c in pairs(inServiceCops) do
            TriggerClientEvent("police:resultAllCopsInService", i, inServiceCops)
        end
    end
end)

RegisterServerEvent('police:getAllCopsInService')
AddEventHandler('police:getAllCopsInService', function()
    TriggerClientEvent("police:resultAllCopsInService", source, inServiceCops)
end)

RegisterServerEvent('police:checkingPlate')
AddEventHandler('police:checkingPlate', function(plate)
    local executed_query = MySQL:executeQuery("SELECT name FROM user_vehicle JOIN users ON user_vehicle.identifier = users.identifier WHERE vehicle_plate = '@plate'", { ['@plate'] = plate })
    local result = MySQL:getResults(executed_query, { 'name' }, "identifier")
    if (result[1]) then
        for _, v in ipairs(result) do
            TriggerClientEvent('chatMessage', source, 'LSPD', {255, 0, 0}, "Le véhicule #"..plate.." est la propriété de " .. v.name)
        end
    else
        TriggerClientEvent('chatMessage', source, 'LSPD', {255, 0, 0}, "Le véhicule #"..plate.." est inconnu des fichiers de renseignements")
    end
end)

RegisterServerEvent('police:confirmUnseat')
AddEventHandler('police:confirmUnseat', function(t)
    TriggerClientEvent('chatMessage', source, 'LSPD', {255, 0, 0}, GetPlayerName(t).. " est dehors !")
    TriggerClientEvent('police:unseatme', t)
end)

RegisterServerEvent('police:targetCheckInventory')
AddEventHandler('police:targetCheckInventory', function(t)
    checkInventory(t)
end)

RegisterServerEvent('police:checkDirtyMoney')
AddEventHandler('police:checkDirtyMoney', function(t)
    checkDirtyMoney(t)
end)

RegisterServerEvent('police:finesGranted')
RegisterServerEvent('police:finesGranted')
AddEventHandler('police:finesGranted', function(t, amount)
    TriggerClientEvent('chatMessage', source, 'LSPD', {255, 0, 0}, GetPlayerName(t).. " a payé $"..amount.." d'amendes.")
    TriggerClientEvent('police:payFines', t, amount)
end)

RegisterServerEvent('police:cuffGranted')
AddEventHandler('police:cuffGranted', function(t)
    TriggerClientEvent('chatMessage', source, 'LSPD', {255, 0, 0}, GetPlayerName(t).. " est menotté.")
    TriggerClientEvent('police:getArrested', t)
end)

RegisterServerEvent('police:forceEnterAsk')
AddEventHandler('police:forceEnterAsk', function(t, v)
    TriggerClientEvent('chatMessage', source, 'LSPD', {255, 0, 0}, GetPlayerName(t).. " est emmené au véhicule")
    TriggerClientEvent('police:forcedEnteringVeh', t, v)
end)

-----------------------------------------------------------------------
----------------------EVENT SPAWN POLICE VEH---------------------------
-----------------------------------------------------------------------
RegisterServerEvent('CheckPoliceVeh')
AddEventHandler('CheckPoliceVeh', function(vehicle)
    TriggerEvent('es:getPlayerFromId', source, function(user)

        TriggerClientEvent('FinishPoliceCheckForVeh',source)
        -- Spawn police vehicle
        TriggerClientEvent('policeveh:spawnVehicle', source, vehicle)
    end)
end)

-----------------------------------------------------------------------
---------------------COMMANDE ADMIN AJOUT / SUPP COP-------------------
-----------------------------------------------------------------------
TriggerEvent('es:addGroupCommand', 'copadd', "admin", function(source, args, user)
    if(not args[2]) then
        TriggerClientEvent('chatMessage', source, 'LSPD', {255, 0, 0}, "Usage : /copadd [ID]")
    else
        if(GetPlayerName(tonumber(args[2])) ~= nil)then
            local player = tonumber(args[2])
            TriggerEvent("es:getPlayerFromId", player, function(target)
                addCop(target.identifier)
                TriggerClientEvent('chatMessage', source, 'LSPD', {255, 0, 0}, "Roger that !")
                --TriggerClientEvent("es_freeroam:notify", player, "CHAR_ANDREAS", 1, "LSPD", false, "Congrats, you're now a cop !~w~.")
                TriggerClientEvent('police:nowCop', player)
            end)
        else
            TriggerClientEvent('chatMessage', source, 'LSPD', {255, 0, 0}, "No player with this ID !")
        end
    end
end, function(source, args, user)
    TriggerClientEvent('chatMessage', source, 'LSPD', {255, 0, 0}, "You haven't the permission to do that !")
end)

TriggerEvent('es:addGroupCommand', 'coprem', "admin", function(source, args, user)
    if(not args[2]) then
        TriggerClientEvent('chatMessage', source, 'LSPD', {255, 0, 0}, "Usage : /coprem [ID]")
    else
        if(GetPlayerName(tonumber(args[2])) ~= nil)then
            local player = tonumber(args[2])
            TriggerEvent("es:getPlayerFromId", player, function(target)
                remCop(target.identifier)
                TriggerClientEvent("es_freeroam:notify", player, "CHAR_ANDREAS", 1, "LSPD", false, "You're no longer a cop !~w~.")
                TriggerClientEvent('chatMessage', source, 'LSPD', {255, 0, 0}, "Roger that !")
                --TriggerClientEvent('chatMessage', player, 'LSPD', {255, 0, 0}, "You're no longer a cop !")
                TriggerClientEvent('police:noLongerCop', player)
            end)
        else
            TriggerClientEvent('chatMessage', source, 'LSPD', {255, 0, 0}, "No player with this ID !")
        end
    end
end, function(source, args, user)
    TriggerClientEvent('chatMessage', source, 'LSPD', {255, 0, 0}, "You haven't the permission to do that !")
end)