--Version 1.4
require "resources/essentialmode/lib/MySQL"
--Configuration de la connexion vers la DB MySQL
MySQL:open("127.0.0.1", "gta5_gamemode_essential", "root", "")

--Déclaration des EventHandler
RegisterServerEvent("projectEZ:savelastpos")
RegisterServerEvent("projectEZ:SpawnPlayer")

--Intégration de la position dans MySQL
AddEventHandler("projectEZ:savelastpos", function( LastPosX , LastPosY , LastPosZ , LastPosH )
	TriggerEvent('es:getPlayerFromId', source, function(user)
		--Récupération du SteamID.
		local player = user.identifier
		--Formatage des données en JSON pour intégration dans MySQL.
		local LastPos = "{" .. LastPosX .. ", " .. LastPosY .. ",  " .. LastPosZ .. ", " .. LastPosH .. "}"
		--Exécution de la requêtes SQL.
		local executed_query = MySQL:executeQuery("UPDATE users SET `lastpos`='@lastpos' WHERE identifier = '@username'", {['@username'] = player, ['@lastpos'] = LastPos})
	end)
end)

--Récupération de la position depuis MySQL
AddEventHandler("projectEZ:SpawnPlayer", function()
	TriggerEvent('es:getPlayerFromId', source, function(user)
		--Récupération du SteamID.
		local player = user.identifier
		--Exécution de la requêtes SQL.
		local executed_query = MySQL:executeQuery("SELECT * FROM users WHERE identifier = '@username'", {['@username'] = player})
		--Récupération des données générée par la requête.
		local result = MySQL:getResults(executed_query, {'lastpos'}, "identifier")
		-- Vérification de la présence d'un résultat avant de lancer le traitement.
		if(result)then
			for k,v in ipairs(result)do
				if v.lastpos ~= "" then
				-- Décodage des données récupérées
				local ToSpawnPos = json.decode(v.lastpos)
				-- On envoie la derniere position vers le client pour le spawn
				TriggerClientEvent("projectEZ:spawnlaspos", source, ToSpawnPos[1], ToSpawnPos[2], ToSpawnPos[3])
				end
			end
		end
	end)
end)