--[[
################################################################
- Creator: Jyben
- Date: 02/05/2017
- Url: https://github.com/Jyben/emergency
- Licence: Apache 2.0
################################################################
--]]

require "resources/essentialmode/lib/MySQL"

MySQL:open("127.0.0.1", "gta5_gamemode_essential", "root", "")

RegisterServerEvent('es_em:sendEmergency')
AddEventHandler('es_em:sendEmergency',
  function(reason, playerIDInComa, x, y, z)
    TriggerEvent("es:getPlayers", function(players)
      for i,v in pairs(players) do
        TriggerClientEvent('es_em:sendEmergencyToDocs', i, reason, playerIDInComa, x, y, z, source)
      end
    end)
  end
)

RegisterServerEvent('es_em:getTheCall')
AddEventHandler('es_em:getTheCall',
  function(playerName, playerID, x, y, z, sourcePlayerInComa)
    TriggerEvent("es:getPlayers", function(players)
      for i,v in pairs(players) do
        TriggerClientEvent('es_em:callTaken', i, playerName, playerID, x, y, z, sourcePlayerInComa)
      end
    end)
  end
)

RegisterServerEvent('es_em:sv_resurectPlayer')
AddEventHandler('es_em:sv_resurectPlayer',
  function(sourcePlayerInComa)
    TriggerClientEvent('es_em:cl_resurectPlayer', sourcePlayerInComa)
  end
)

RegisterServerEvent('es_em:sv_getJobId')
AddEventHandler('es_em:sv_getJobId',
  function()
    TriggerClientEvent('es_em:cl_setJobId', source, GetJobId(source))
  end
)

RegisterServerEvent('es_em:sv_getDocConnected')
AddEventHandler('es_em:sv_getDocConnected',
  function()
    TriggerEvent("es:getPlayers", function(players)
      local identifier
      local table = {}
      local isConnected = false

      for i,v in pairs(players) do
        identifier = GetPlayerIdentifiers(i)
        if (identifier ~= nil) then
          local executed_query = MySQL:executeQuery("SELECT identifier, job_id, job_name FROM users LEFT JOIN jobs ON jobs.job_id = users.job WHERE users.job = 7 AND users.identifier = '@identifier' AND enService = 1", {['@identifier'] = identifier[1]})
          local result = MySQL:getResults(executed_query, {'job_id'}, "identifier")

          if (result[1] ~= nil) then
            isConnected = true
          end
        end
      end
      TriggerClientEvent('es_em:cl_getDocConnected', source, isConnected)
    end)
  end
)

RegisterServerEvent('es_em:sv_setService')
AddEventHandler('es_em:sv_setService',
  function(service)
    TriggerEvent('es:getPlayerFromId', source,
      function(user)
        local executed_query = MySQL:executeQuery("UPDATE users SET enService = @service WHERE (users.job = 7) AND users.identifier = '@identifier'", {['@identifier'] = user.identifier, ['@service'] = service})
      end
    )
  end
)

RegisterServerEvent('es_em:sv_removeMoney')
AddEventHandler('es_em:sv_removeMoney',
  function()
    TriggerEvent("es:getPlayerFromId", source,
      function(user)
        if(user)then
          user:setMoney(0)
          -- This part requires the mod vdk_inventory
          --TriggerServerEvent("item:reset")
        end
      end
    )
  end
)

RegisterServerEvent('es_em:sv_sendMessageToPlayerInComa')
AddEventHandler('es_em:sv_sendMessageToPlayerInComa',
  function(sourcePlayerInComa)
    TriggerClientEvent('es_em:cl_sendMessageToPlayerInComa', sourcePlayerInComa)
  end
)

AddEventHandler('es:playerDropped', function(source)
   TriggerEvent('es:getPlayerFromId', source, function(user)
        local executed_query = MySQL:executeQuery("UPDATE users SET enService = 0 WHERE users.identifier = '@identifier'", {['@identifier'] = user.identifier})
    end)
end)

function GetJobId(source)
  local jobId = -1

  TriggerEvent('es:getPlayerFromId', source,
    function(user)
      local executed_query = MySQL:executeQuery("SELECT identifier, job_id, job_name FROM users LEFT JOIN jobs ON jobs.job_id = users.job WHERE users.identifier = '@identifier' AND job_id IS NOT NULL", {['@identifier'] = user.identifier})
      local result = MySQL:getResults(executed_query, {'job_id'}, "identifier")

      if (result[1] ~= nil) then
        jobId = tonumber(result[1].job_id)
      end
    end
  )

  return jobId
end
