-- Loading MySQL Class
require "resources/essentialmode/lib/MySQL"

-- MySQL:open("IP", "databasname", "user", "password")
MySQL:open("127.0.0.1", "gta5_gamemode_essential", "root", "")

function LoadUser(identifier, source, new)
	local executed_query = MySQL:executeQuery("SELECT * FROM users WHERE identifier = '@name'", {['@name'] = identifier})
	local result = MySQL:getResults(executed_query, {'permission_level', 'money', 'dirty_money', 'identifier', 'group'}, "identifier")

	local group = groups[result[1].group]
	Users[source] = Player(source, result[1].permission_level, result[1].money, result[1].dirty_money, result[1].identifier , group)

	TriggerEvent('es:playerLoaded', source, Users[source])

	if(true)then
		TriggerClientEvent('es:setPlayerDecorator', source, 'rank', Users[source]:getPermissions())
	end

	if(true)then
		TriggerEvent('es:newPlayerLoaded', source, Users[source])
	end
end

function stringsplit(self, delimiter)
  local a = self:Split(delimiter)
  local t = {}

  for i = 0, #a - 1 do
     table.insert(t, a[i])
  end

  return t
end

function isIdentifierBanned(id)
	local executed_query = MySQL:executeQuery("SELECT * FROM bans WHERE banned = '@name'", {['@name'] = id})
	local result = MySQL:getResults(executed_query, {'expires', 'reason', 'timestamp'}, "identifier")

	if(result)then
		for k,v in ipairs(result)do
			if v.expires > v.timestamp then
				return true
			end
		end
	end

	return false
end

AddEventHandler('es:getPlayers', function(cb)
	cb(Users)
end)

function hasAccount(identifier)
	local executed_query = MySQL:executeQuery("SELECT * FROM users WHERE identifier = '@name'", {['@name'] = identifier})
	local result = MySQL:getResults(executed_query, {'permission_level', 'money'}, "identifier")

	if(result[1] ~= nil) then
		return true
	end
	return false
end


function isLoggedIn(source)
	if(Users[GetPlayerName(source)] ~= nil)then
	if(Users[GetPlayerName(source)]['isLoggedIn'] == 1) then
		return true
	else
		return false
	end
	else
		return false
	end
end

function registerUser(identifier, source)
	if not hasAccount(identifier) then
		-- Inserting Default User Account Stats
		MySQL:executeQuery("INSERT INTO users (`identifier`, `permission_level`, `money`, `group`) VALUES ('@username', '0', '@money', 'user')",
		{['@username'] = identifier, ['@money'] = settings.defaultSettings.startingCash})

		LoadUser(identifier, source, true)
	else
		LoadUser(identifier, source)
	end
end

AddEventHandler("es:setPlayerData", function(user, k, v, cb)
	if(Users[user])then
		if(Users[user][k])then

			if(k ~= "money") then
				Users[user][k] = v

				MySQL:executeQuery("UPDATE users SET `@key`='@value' WHERE identifier = '@identifier'",
			    {['@key'] = k, ['@value'] = v, ['@identifier'] = Users[user]['identifier']})
			end

			if(k == "group")then
				Users[user].group = groups[v]
			end

			cb("Player data edited.", true)
		else
			cb("Column does not exist!", false)
		end
	else
		cb("User could not be found!", false)
	end
end)

AddEventHandler("es:setPlayerDataId", function(user, k, v, cb)
	MySQL:executeQuery("UPDATE users SET @key='@value' WHERE identifier = '@identifier'",
	{['@key'] = k, ['@value'] = v, ['@identifier'] = user})

	cb("Player data edited.", true)
end)

AddEventHandler("es:getPlayerFromId", function(user, cb)
	if(Users)then
		if(Users[user])then
			cb(Users[user])
		else
			cb(nil)
		end
	else
		cb(nil)
	end
end)

AddEventHandler("es:getPlayerFromIdentifier", function(identifier, cb)
	local executed_query = MySQL:executeQuery("SELECT * FROM users WHERE identifier = '@name'", {['@name'] = identifier})
	local result = MySQL:getResults(executed_query, {'permission_level', 'money', 'dirty_money', 'identifier', 'group'}, "identifier")

	if(result[1])then
		cb(result[1])
	else
		cb(nil)
	end
end)

AddEventHandler("es:getAllPlayers", function(cb)
	local executed_query = MySQL:executeQuery("SELECT * FROM users", {})
	local result = MySQL:getResults(executed_query, {'permission_level', 'money', 'dirty_money', 'identifier', 'group'}, "identifier")

	if(result)then
		cb(result)
	else
		cb(nil)
	end
end)

-- Function to update player money every 60 seconds.
local function savePlayerMoney()
	SetTimeout(60000, function()
		TriggerEvent("es:getPlayers", function(users)
			for k,v in pairs(users)do
				MySQL:executeQuery("UPDATE users SET `money`='@value', `dirty_money`='@v2' WHERE identifier = '@identifier'",
			    {['@value'] = v.money, ['@v2'] = v.dirty_money, ['@identifier'] = v.identifier})
			end
		end)

		savePlayerMoney()
	end)
end

savePlayerMoney()