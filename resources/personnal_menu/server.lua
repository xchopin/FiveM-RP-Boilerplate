-- GITHUB.COM/XCHOPIN - DO NOT REMOVE
require "resources/essentialmode/lib/MySQL"

MySQL:open("127.0.0.1", "gta5_gamemode_essential", "root", "")
local phone_number_format = "NNLLNNN" -- You shouldn't change this regular expression ;)
------------------------------------------------------------------------------------------------------------------------

RegisterServerEvent("pm:spawnPlayer")
AddEventHandler("pm:spawnPlayer", function()
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local player = user.identifier
        local executed_query = MySQL:executeQuery("SELECT phone_number FROM users WHERE identifier = '@username'", {['@username'] = player})
        local result = MySQL:getResults(executed_query, {'phone_number'}, "identifier")
        if(result[1].phone_number == "none") then
            local phone_number = generatePhoneNumber()
            MySQL:executeQuery("UPDATE users SET phone_number = '@phone' WHERE identifier = '@username'", {
                ['@username'] = player,
                ['@phone'] = phone_number
            })
        end
    end)
end)



RegisterServerEvent("pm:checkIdentity")
AddEventHandler("pm:checkIdentity", function()
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local player = user.identifier
        local executed_query = MySQL:executeQuery("SELECT name, phone_number FROM users WHERE identifier = '@username'", {['@username'] = player})
        local result = MySQL:getResults(executed_query, {'name', 'phone_number'}, "identifier")
        if (result) then
             TriggerClientEvent("pm:notifs", source, "- Nom :" .. result[1].name .. " <br>- Téléphone :" .. result[1].phone_number )
        end
    end)
end)




-- Factory of phone number | (example of format: NNNLLLL, N => number, L => letter)
function numberPhoneFactory(format) --
    local abyte = string.byte("A")
    local zbyte = string.byte("0")

    local number = ""
    for i=0,#format-1 do
        if format[i] == "N" then number = number..string.char(zbyte+math.random(0,9))
        elseif format[i] == "L" then number = number..string.char(abyte+math.random(0,25))
        else number = number..format[i] end
    end

    return number
end


-- get's the player id without having to use bugged essentials
function getPlayerID(source)
    local identifiers = GetPlayerIdentifiers(source)
    local player = getIdentifiant(identifiers)
    return player
end



-- Creates a phone number for a user
function generatePhoneNumber()
    local exists = true
    local phone = nil

    while exists == true do
        phone = numberPhoneFactory(phone_number_format)
        local executed_query = MySQL:executeQuery("SELECT * FROM users WHERE phone_number = '@phone'", {['@phone'] = phone})
        local result = MySQL:getResults(executed_query)
        if (result == nil) then
            exists = false
        end
    end

    return phone
end

-- gets the actual player id unique to the player,
-- independent of whether the player changes their screen name
function getIdentifiant(id)
    for _, v in ipairs(id) do
        return v
    end
end
------------------------------------------------------------------------------------------------------------------------

function checkNumber(number)
    local executed_query = MySQL:executeQuery("SELECT * FROM users WHERE phone_number = '@number' LIMIT 1", { ['@number'] = number })
    local result = MySQL:getResults(executed_query, { 'identifier','name'})
    if result then
        for _, v in ipairs(result) do
            return v
        end

    else
        return false
    end

end

RegisterServerEvent("pm:addNewNumero")
AddEventHandler("pm:addNewNumero", function(number)
    local player = getPlayerID(source)
    local contact =  checkNumber(number)
    if not contact then
        TriggerClientEvent("pm:notifs", source, "~o~Aucun contact trouvé")
    else
        local executed_query = MySQL:executeQuery("SELECT * FROM user_phonelist WHERE owner_id = '@username' AND contact_id = '@id' ", { ['@username'] = player, ['@id'] = contact.identifier })
        local result = MySQL:getResults(executed_query, { 'contact_id' })
        print(json.encode(result[1]))
        if(result[1] == nil) then
            MySQL:executeQuery("INSERT INTO user_phonelist (`owner_id`, `contact_id`, `name`) VALUES ('@owner', '@contact', '@name')",
                { ['@owner'] = player, ['@contact'] = contact.identifier, ['@name'] = contact.name })
            TriggerClientEvent("pm:notifs", source, "~g~Numéro de ~y~".. contact.name .. " ~g~ajouté" )
            updateRepertory({source = source, player = player })
        else
            TriggerClientEvent("pm:notifs", source, " ~y~".. contact.name .. "~r~ existe déjà dans votre répertoire" )
        end
    end
end)

RegisterServerEvent("pm:checkContactServer")
AddEventHandler("pm:checkContactServer", function(identifier)
    print(json.encode(identifier))
    local executed_query = MySQL:executeQuery("SELECT * FROM users WHERE identifier = '@id'", { ['@id'] = identifier.identifier })
    local result = MySQL:getResults(executed_query, { 'identifier', 'phone_number', 'name' })

    if result[1] ~= nil then
        for _, v in ipairs(result) do
            TriggerClientEvent("pm:notifs", source, "~o~".. v.name .. " : ~s~" .. v.phone_number)
        end
    end

end)



function updateRepertory(player)
    numberslist = {}
    source = player.source
    local player = player.player
    local executed_query = MySQL:executeQuery("SELECT * FROM user_phonelist JOIN users ON `user_phonelist`.`contact_id` = `users`.`identifier` WHERE owner_id = '@username' ORDER BY user_phonelist.name ASC", { ['@username'] = player })
    local result = MySQL:getResults(executed_query, { 'identifier','name', 'contact_id'}, "contact_id")
    if (result) then
        for _, v in ipairs(result) do
            t = { name= v.name, identifier = v.identifier }
            table.insert(numberslist, v.identifier, t)
        end
    end
    TriggerClientEvent("pm:repertoryGetNumberListFromServer", source, numberslist)
end

local numberslist = {}
RegisterServerEvent("pm:repertoryGetNumberList")
AddEventHandler("pm:repertoryGetNumberList", function()
    numberslist = {}
    local player = getPlayerID(source)
    local executed_query = MySQL:executeQuery("SELECT * FROM user_phonelist JOIN users ON `user_phonelist`.`contact_id` = `users`.`identifier` WHERE owner_id = '@username' ORDER BY user_phonelist.name ASC", { ['@username'] = player })
    local result = MySQL:getResults(executed_query, { 'identifier','name', 'contact_id'}, "contact_id")
    if (result) then
        for _, v in ipairs(result) do
            t = { name= v.name, identifier = v.identifier }
            table.insert(numberslist, v.identifier, t)
        end
    end
    TriggerClientEvent("pm:repertoryGetNumberListFromServer", source, numberslist)
end)


RegisterServerEvent("pm:accuseReception")
AddEventHandler("pm:accuseReception", function(receiverId, name, message)
	TriggerEvent('es:getPlayerFromId', source, function(user)
        local player = user.identifier
        if (user.identifier == receiverId) then 
        	TriggerClientEvent("pm:notifs", source, "Message de: ~y~".. name.. " <br>~w~" .. message )
        end
    end)

end)




RegisterServerEvent("pm:sendNewMsg")
AddEventHandler("pm:sendNewMsg", function(msg)
    msg = {
        owner_id = getPlayerID(source),
        receiver = msg.receiver,
        msg = msg.msg
    }

    local executed_query = MySQL:executeQuery("SELECT name FROM user_phonelist WHERE owner_id = '@receiver' AND contact_id='@owner' ", { ['@receiver'] = msg.receiver, ['@owner'] = msg.owner_id })
    local result =  MySQL:getResults(executed_query, {'name'})
    local contactName = "Inconnu"
    if (result) then
        if (result[1].name ~= nil) then
    	   contactName = result[1].name
        end
    end

    local executed_query = MySQL:executeQuery("SELECT COUNT(msg) as nb FROM user_message WHERE receiver_id = '@receiver'", { ['@receiver'] = msg.receiver })
    local result = MySQL:getResults(executed_query, {'nb'})
    if (result ~= nil) then
        if (tonumber(result[1].nb) >= 10) then 
            MySQL:executeQuery("DELETE FROM `user_message` WHERE receiver_id = '@receiver' ORDER by id ASC LIMIT 1", { ['@receiver'] = msg.receiver })
        end  
    end

    MySQL:executeQuery("INSERT INTO user_message (`owner_id`, `receiver_id`, `msg`, `has_read`, `name`) VALUES ('@owner', '@receiver', '@msg', '@read', '@name')",
        { ['@owner'] = msg.owner_id, ['@receiver'] = msg.receiver, ['@msg'] = msg.msg, ['@read'] = 0 , ['@name'] = contactName})

    TriggerClientEvent("pm:notifs", source, "~g~Message envoyé" )

    TriggerEvent("es:getPlayers", function(players)
      for i,v in pairs(players) do
        TriggerClientEvent('pm:signalNotif', i, msg.receiver, contactName, msg.msg, source)
      end
    end)
end)

local messagelist = {}
RegisterServerEvent("pm:messageryGetOldMsg")
AddEventHandler("pm:messageryGetOldMsg", function()
    messagelist = {}
    local player = getPlayerID(source)
    local executed_query = MySQL:executeQuery("SELECT * FROM user_message JOIN users ON `user_message`.`owner_id` = `users`.`identifier` WHERE receiver_id = '@user'", { ['@user'] = player })
    local result = MySQL:getResults(executed_query, { 'identifier', 'name', 'msg', 'date', 'has_read', 'owner_id', 'receiver_id'})
    if (result) then
        for _, val in ipairs(result) do
            message = { msg = val.msg, name = val.name, identifier = val.identifier, date = tostring(val.date), has_read = val.has_read }
            --table.insert(messagelist, val.identifier, message)
            messagelist[_] = message
        end

    end
    TriggerClientEvent("pm:messageryGetOldMsgFromServer", source, messagelist)
end)

RegisterServerEvent("pm:setMsgReaded")
AddEventHandler("pm:setMsgReaded", function(msg)
    print(json.encode(msg))
    MySQL:executeQuery("UPDATE user_message SET `has_read` = 1 WHERE `receiver_id` = '@receiver' AND `msg` = '@msg' AND `has_read` = '@read' ", { ['@receiver'] = getPlayerID(source), ['@msg'] = msg.msg, ['@read'] = msg.has_read })
end)


------------------------------------------------------------------------------------------------------------------------

RegisterServerEvent("item:getItems")
RegisterServerEvent("item:updateQuantity")
RegisterServerEvent("item:setItem")
RegisterServerEvent("item:reset")
RegisterServerEvent("item:sell")
RegisterServerEvent("player:giveItem")
RegisterServerEvent("pm:wearHat")
RegisterServerEvent("pm:wearPercing")
RegisterServerEvent("pm:wearGlasses")
RegisterServerEvent("pm:wearMask")

local items = {}



AddEventHandler("item:getItems", function()
    items = {}
    local player = getPlayerID(source)
    local executed_query = MySQL:executeQuery("SELECT * FROM user_inventory JOIN items ON `user_inventory`.`item_id` = `items`.`id` WHERE user_id = '@username'", { ['@username'] = player })
    local result = MySQL:getResults(executed_query, { 'quantity', 'libelle', 'item_id' }, "item_id")
    if (result) then
        for _, v in ipairs(result) do
            t = { ["quantity"] = v.quantity, ["libelle"] = v.libelle }
            table.insert(items, tonumber(v.item_id), t)
        end
    end
    TriggerClientEvent("gui:getItems", source, items)
end)

AddEventHandler("item:setItem", function(item, quantity)
    local player = getPlayerID(source)
    MySQL:executeQuery("INSERT INTO user_inventory (`user_id`, `item_id`, `quantity`) VALUES ('@player', @item, @qty)",
        { ['@player'] = player, ['@item'] = item, ['@qty'] = quantity })
end)

AddEventHandler("item:updateQuantity", function(qty, id)
    local player = getPlayerID(source)
    MySQL:executeQuery("UPDATE user_inventory SET `quantity` = @qty WHERE `user_id` = '@username' AND `item_id` = @id", { ['@username'] = player, ['@qty'] = tonumber(qty), ['@id'] = tonumber(id) })
end)

AddEventHandler("item:reset", function()
    local player = getPlayerID(source)
    MySQL:executeQuery("UPDATE user_inventory SET `quantity` = @qty WHERE `user_id` = '@username'", { ['@username'] = player, ['@qty'] = 0 })
end)

AddEventHandler("item:sell", function(id, qty, price, isIllegal)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local player = user.identifier
        MySQL:executeQuery("UPDATE user_inventory SET `quantity` = @qty WHERE `user_id` = '@username' AND `item_id` = @id", { ['@username'] = player, ['@qty'] = tonumber(qty), ['@id'] = tonumber(id) })
       	print('EST-CE LEGAL ? ' .. isIllegal)
       	if (tonumber(isIllegal) == 1) then
       		user:addDirty_Money(tonumber(price))
       	else
       		user:addMoney(tonumber(price))
       	end
        
    end)
end)

AddEventHandler("player:giveItem", function(item, name, qty, target)
    local player = getPlayerID(source)
    local executed_query = MySQL:executeQuery("SELECT SUM(quantity) as total FROM user_inventory WHERE user_id = '@username'", { ['@username'] = player })
    local result = MySQL:getResults(executed_query, { 'total' })
    local total = result[1].total
    if (total + qty <= 35) then
        TriggerClientEvent("player:looseItem", source, item, qty)
        TriggerClientEvent("player:receiveItem", target, item, qty)
        TriggerClientEvent("es_freeroam:notify", target, "CHAR_MP_STRIPCLUB_PR", 1, "", false, "Vous venez de recevoir " .. qty .. " " .. name)
    end
end)






------------------------------------------------------------------------------------------------------------------------
AddEventHandler("pm:wearHat", function()
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local playerSkin_query = MySQL:executeQuery("SELECT * FROM user_clothes WHERE identifier = '@username'", {['@username'] = user.identifier})
        local skin = MySQL:getResults(playerSkin_query, {'identifier','hat', 'hat_texture'}, "identifier")
        if(skin)then
            for k,v in ipairs(skin)do
                if v.helmet ~= nil then
                    TriggerClientEvent("pm:accessoriesWearHat", source, v)
                end
            end
        end
    end)
end)


AddEventHandler("pm:wearGlasses", function()
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local playerSkin_query = MySQL:executeQuery("SELECT * FROM user_clothes WHERE identifier = '@username'", {['@username'] = user.identifier})
        local skin = MySQL:getResults(playerSkin_query, {'identifier','glasses', 'glasses_texture'}, "identifier")
        if(skin)then
            for k,v in ipairs(skin)do
                if v.glasses ~= nil then
                    TriggerClientEvent("pm:accessoriesWearGlasses", source, v)
                end
            end
        end
    end)
end)


AddEventHandler("pm:wearPercing", function()
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local playerSkin_query = MySQL:executeQuery("SELECT * FROM user_clothes WHERE identifier = '@username'", {['@username'] = user.identifier})
        local skin = MySQL:getResults(playerSkin_query, {'identifier','ears', 'ears_texture'}, "identifier")
        if(skin)then
            for k,v in ipairs(skin)do
                if v.percing ~= nil then
                    TriggerClientEvent("pm:accessoriesWearPercing", source, v)
                end
            end
        end
    end)
end)

AddEventHandler("pm:wearMask", function()
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local playerSkin_query = MySQL:executeQuery("SELECT * FROM user_clothes WHERE identifier = '@username'", {['@username'] = user.identifier})
        local skin = MySQL:getResults(playerSkin_query, {'identifier','mask', 'mask_texture'}, "identifier")
        if(skin)then
            for k,v in ipairs(skin)do
                if v.mask ~= nil then
                    TriggerClientEvent("pm:accessoriesWearMask", source, v)
                end
            end
        end
    end)
end)
------------------------------------------------------------------------------------------------------------------------
