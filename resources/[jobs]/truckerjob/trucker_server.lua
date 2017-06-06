RegisterServerEvent('truckerJob:addMoney')
AddEventHandler('truckerJob:addMoney', function(amount)
  -- Get the players money amount
  TriggerEvent('es:getPlayerFromId', source, function(user)
    total = math.random(100, 500);
    -- update player money amount
    user:addMoney((total + tonumber(math.floor(amount)) + 0.0))
  end)
end)


require "resources/essentialmode/lib/MySQL"

MySQL:open("127.0.0.1", "gta5_gamemode_essential", "root", "")


RegisterServerEvent('truckcompany:sv_getJobId')
AddEventHandler('truckcompany:sv_getJobId',
  function()
    TriggerClientEvent('truckcompany:cl_setJobId', source, GetJobId(source))
  end
)

RegisterServerEvent('truckcompany:sv_setService')
AddEventHandler('truckcompany:sv_setService',
  function(service)
    TriggerEvent('es:getPlayerFromId', source,
      function(user)
        local executed_query = MySQL:executeQuery("UPDATE users SET enService = @service WHERE users.identifier = '@identifier'", {['@identifier'] = user.identifier, ['@service'] = service})
      end
    )
  end
)


function GetJobId(source)
  local jobId = -1
  TriggerEvent('es:getPlayerFromId', source,
    function(user)
      local executed_query = MySQL:executeQuery("SELECT * FROM users WHERE users.identifier = '@identifier' ", {['@identifier'] = user.identifier})
      local result = MySQL:getResults(executed_query, {'job'}, "identifier")

      if (result[1] ~= nil) then
        jobId = tonumber(result[1].job)
      end
    end
  )

  return tonumber(jobId)
end


RegisterServerEvent('truckcompany:sv_payday')
AddEventHandler('truckcompany:sv_payday',
  function(salary_job)
    TriggerEvent('es:getPlayerFromId', source,
      function(user)
        user:addMoney((salary_job))
        TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Chase Bank", false, "USPS vous a payé: ~g~$~s~"..salary_job.."")
      end
    )
  end
)
