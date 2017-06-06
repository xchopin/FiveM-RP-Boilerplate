-- Table constructor
Player = {}
Player.__index = Player

-- Meta table for users
setmetatable(Player, {
	__call = function(self, source, permission_level, money, dirty_money, identifier, group)
		local pl = {}

		pl.source = source
		pl.permission_level = permission_level
		pl.money = money
		pl.dirty_money = dirty_money
		pl.identifier = identifier
		pl.group = group
		pl.coords = {x = 0.0, y = 0.0, z = 0.0}
		pl.session = {}

		return setmetatable(pl, Player)
	end
})

-- Getting permissions
function Player:getPermissions()
	return self.permission_level
end

-- Setting them
function Player:setPermissions(p)
	TriggerEvent("es:setPlayerData", self.source, "permission_level", p, function(response, success)
		self.permission_level = p
	end)
end

-- No need to ever call this (No, it doesn't teleport the player)
function Player:setCoords(x, y, z)
	self.coords.x, self.coords.y, self.coords.z = x, y, z
end

-- Kicks a player with specified reason
function Player:kick(reason)
	DropPlayer(self.source, reason)
end

-- Sets the player money (required to call this from now)
function Player:setMoney(m)
	local prevMoney = self.money
	local newMoney : double = m

	self.money = m

	if((prevMoney - newMoney) < 0)then
		TriggerClientEvent("es:addedMoney", self.source, math.abs(prevMoney - newMoney))
	else
		TriggerClientEvent("es:removedMoney", self.source, math.abs(prevMoney - newMoney))
	end

	TriggerClientEvent('es:activateMoney', self.source , self.money)
end

-- Adds to player money (required to call this from now)
function Player:addMoney(m)
	local newMoney : double = self.money + m

	self.money = newMoney

	TriggerClientEvent("es:addedMoney", self.source, m)
	TriggerClientEvent('es:activateMoney', self.source , self.money)
end

function Player:getMoney()
	return self.money
end

-- Removes from player money (required to call this from now)
function Player:removeMoney(m)
	local newMoney : double = self.money - m

	self.money = newMoney

	TriggerClientEvent("es:removedMoney", self.source, m)
	TriggerClientEvent('es:activateMoney', self.source , self.money)
end

-- Player session variables
function Player:setSessionVar(key, value)
	self.session[key] = value
end

function Player:getSessionVar(key)
	return self.session[key]
end

--==============Dirty money stuff========================
-- Sets the player dirty money (required to call this from now)
function Player:setDirty_Money(m)
	local prevMoney = self.dirty_money
	local newMoney : double = m

	self.dirty_money = m

	if((prevMoney - newMoney) < 0)then
		TriggerClientEvent("es:addedDirtyMoney", self.source, math.abs(prevMoney - newMoney))
	else
		TriggerClientEvent("es:removedDirtyMoney", self.source, math.abs(prevMoney - newMoney))
	end

	TriggerClientEvent('es:activateDirtyMoney', self.source , self.dirty_money)
end

-- Adds to player dirty money (required to call this from now)
function Player:addDirty_Money(m)
	local newMoney : double = self.dirty_money + m

	self.dirty_money = newMoney

	TriggerClientEvent("es:addedDirtyMoney", self.source, m)
	TriggerClientEvent('es:activateDirtyMoney', self.source , self.dirty_money)
end

-- Removes from player dirty money (required to call this from now)
function Player:removeDirty_Money(m)
	local newMoney : double = self.dirty_money - m

	self.dirty_money = newMoney

	TriggerClientEvent("es:removedDirtyMoney", self.source, m)
	TriggerClientEvent('es:activateDirtyMoney', self.source , self.dirty_money)
end
--=============End Dirty money stuff=====================