RegisterServerEvent("player:serviceOn")
RegisterServerEvent("player:serviceOff")
RegisterServerEvent("call:makeCall")
RegisterServerEvent("call:getCall")
require "resources/essentialmode/lib/MySQL"

MySQL:open("127.0.0.1", "gta5_gamemode_essential", "root", "")

local inService = {
    ["police"] = {},
    ["medic"] = {},
    ["taxi"] = {},
}
local callActive = {
    ["police"] = {taken = false},
    ["medic"] = {taken = false},
    ["taxi"] = {taken = false},
}
local timing = 15000

-- Add the player to the inService table
AddEventHandler("player:serviceOn", function(job)
    table.insert(inService[job], source)
end)

-- Remove the player to the inService table
AddEventHandler("player:serviceOff", function(job)
    if job == nil then
        for _,v in pairs(inService) do
            removeService(v)
        end
    end
    removeService(source, job)
end)

-- Receive call event
AddEventHandler("call:makeCall", function(job, pos)
        -- Players can't call simultanously the same service
        if callActive[job].taken then
            TriggerClientEvent("target:call:taken", callActive[job].target, 2)
            CancelEvent()
        end
        -- Save the target of the call
        callActive[job].target = source
        callActive[job].taken = true
        -- Send notif to all players in service
        for _, player in pairs(inService[job]) do
            TriggerClientEvent("call:callIncoming", player, job, pos)
        end
        -- Say to the target after 'timing' seconds that nobody will come
        SetTimeout(timing, function()
            if callActive[job].taken then
                TriggerClientEvent("target:call:taken", callActive[job].target, 0)
            end
            callActive[job].taken = false
        end)
end)

AddEventHandler("call:getCall", function(job)
    callActive[job].taken = false
    -- Say to other in service people that the call is taken
    for _, player in pairs(inService[job]) do
        if player ~= source then
            TriggerClientEvent("call:taken", player)
        end
    end
    -- Say to a target that someone come
    if not callActive[job].taken then
        TriggerClientEvent("target:call:taken", callActive[job].target, 1)
    end
end)

function removeService(player, job)
    for i,val in pairs(inService[job]) do
        if val == player then
            table.remove(inService[job], i)
            return
        end
    end
end


RegisterServerEvent('call:sv_getJobId')
AddEventHandler('call:sv_getJobId',
  function()
    TriggerClientEvent('callpolice:cl_setJobId', source, GetJobId(source))
    TriggerClientEvent('calltaxi:cl_setJobId', source, GetJobId(source))
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

