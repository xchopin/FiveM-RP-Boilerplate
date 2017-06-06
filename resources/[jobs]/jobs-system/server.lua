require "resources/essentialmode/lib/MySQL"
MySQL:open("localhost", "gta5_gamemode_essential", "root", "")


function nameJob(id)
  local executed_query = MySQL:executeQuery("SELECT * FROM jobs WHERE job_id = '@namejob'", {['@namejob'] = id})
  local result = MySQL:getResults(executed_query, {'job_name'}, "job_id")
  return result[1].job_name
end

function updatejob(player, id)
  local job = id
  MySQL:executeQuery("UPDATE users SET `job`='@value' WHERE identifier = '@identifier'", {['@value'] = job, ['@identifier'] = player})
end

RegisterServerEvent('jobssystem:jobs')
AddEventHandler('jobssystem:jobs', function(id)
  TriggerEvent('es:getPlayerFromId', source, function(user)
        local player = user.identifier
        local nameJob = nameJob(id)
        updatejob(player, id)
        TriggerClientEvent("es_freeroam:notify", source, "CHAR_CHAT_CALL", 1, "Pôle Emploi", false, "Félicitations, vous avez été embauché en tant que ".. nameJob)
        TriggerClientEvent("jobssystem:updateJob", source, nameJob)
  end)
end)

AddEventHandler('es:playerLoaded', function(source)
  TriggerEvent('es:getPlayerFromId', source, function(user)

  		 local queryJob = MySQL:executeQuery("SELECT job_name FROM users INNER JOIN jobs on users.job = jobs.job_id WHERE identifier = '@id'", {['@id'] = user.identifier})
        local result = MySQL:getResults(queryJob, {'job_name'}, "job_id")
        local jobName =  result[1].job_name
      
        TriggerClientEvent("jobssystem:updateJob", source, jobName)
    end)
end)




