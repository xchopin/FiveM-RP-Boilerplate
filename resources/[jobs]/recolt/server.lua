require "resources/essentialmode/lib/MySQL"
MySQL:open("127.0.0.1", "gta5_gamemode_essential", "root", "")

RegisterServerEvent("jobs:getJobs")

local jobs = {}

AddEventHandler("jobs:getJobs", function ()
	jobs = {}
    local executed_query = MySQL:executeQuery("SELECT recolt.isIllegal, job_id, price, i1.`id` AS raw_id, i1.`libelle` AS raw_item, i2.`id` AS treat_id, i2.`libelle` AS treat_item, p1.x AS fx, p1.y AS fy, p1.z AS fz, p2.x AS tx, p2.y AS ty, p2.z AS tz, p3.x AS sx, p3.y AS sy, p3.z AS sz FROM recolt LEFT JOIN items i1 ON recolt.`raw_id`=i1.id LEFT JOIN items i2 ON recolt.`treated_id`=i2.id LEFT JOIN coordinates p1 ON recolt.`field_id`=p1.id LEFT JOIN coordinates p2 ON recolt.`treatment_id`=p2.id LEFT JOIN coordinates p3 ON recolt.`seller_id`=p3.id")
    local result = MySQL:getResults(executed_query, { 'isIllegal', 'job_id', 'price', 'raw_id', 'raw_item', 'treat_id', 'treat_item', 'fx', 'fy', 'fz', 'tx', 'ty', 'tz', 'sx', 'sy', 'sz' })
    if (result) then
        jobs = result
    end
    TriggerClientEvent("cli:getJobs", source, jobs)
end)

RegisterServerEvent('recolte:sv_getJobId')
AddEventHandler('recolte:sv_getJobId',
  function()
    TriggerClientEvent('recolte:cl_setJobId', source, GetJobId(source))
  end
)

function GetJobId(source)
  local jobId = -1

  TriggerEvent('es:getPlayerFromId', source,
    function(user)
      local executed_query = MySQL:executeQuery("SELECT identifier, job FROM users WHERE users.identifier = '@identifier' ", {['@identifier'] = user.identifier})
      local result = MySQL:getResults(executed_query, {'job'}, "identifier")

      if (result) then
        jobId = tonumber(result[1].job)
      end
    end
  )

  return jobId
end
