--[[
################################################################
- Creator: Jyben
- Date: 02/05/2017
- Url: https://github.com/Jyben/emergency
- Licence: Apache 2.0
################################################################
--]]

-- JOB MINEUR  = 19

require "resources/essentialmode/lib/MySQL"

MySQL:open("127.0.0.1", "gta5_gamemode_essential", "root", "")


RegisterServerEvent('viticulteurcompany:sv_getJobId')
AddEventHandler('viticulteurcompany:sv_getJobId',
  function()
    TriggerClientEvent('viticulteurcompany:cl_setJobId', source, GetJobId(source))
  end
)

RegisterServerEvent('viticulteurcompany:sv_setService')
AddEventHandler('viticulteurcompany:sv_setService',
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
      local executed_query = MySQL:executeQuery("SELECT identifier, job FROM users WHERE users.identifier = '@identifier' ", {['@identifier'] = user.identifier})
      local result = MySQL:getResults(executed_query, {'job'}, "identifier")

      if (result[1] ~= nil) then
        jobId = tonumber(result[1].job)
      end
    end
  )

  return tonumber(jobId)
end

