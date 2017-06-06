TriggerEvent("es:setDefaultSettings", {
    moneyIcon = "$"
})

RegisterServerEvent('playerSpawn')
AddEventHandler('playerSpawn', function()
	TriggerClientEvent('es_freeroam:spawnPlayer', source, spawnCoords.x, spawnCoords.y, spawnCoords.z)
end)

AddEventHandler('es:playerLoaded', function(source)
	-- Get the players money amount
	TriggerEvent("es:getPlayerFromId", source, function(user)
	user:setMoney((user.money))
	user:setDirty_Money((user.dirty_money))
	end)
end)




