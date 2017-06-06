-- Loading MySQL Class
require "resources/essentialmode/lib/MySQL"
MySQL:open("localhost", "gta5_gamemode_essential", "root", "")

RegisterServerEvent('paycheck:salary')
AddEventHandler('paycheck:salary', function()
    TriggerEvent('es:getPlayerFromId', source, function(user)
        -- Ajout de l'argent à l'utilisateur
        local user_id = user.identifier
        -- Requête qui permet de recuperer le métier de l'utilisateur
        local executed_query = MySQL:executeQuery("SELECT salary FROM users INNER JOIN jobs ON users.job = jobs.job_id WHERE identifier = '@username'",{['@username'] = user_id})
        local result = MySQL:getResults(executed_query, {'salary'})
        local salary_job = result[1].salary
        if tonumber(salary_job) > 0 then
            user:addMoney((salary_job))
            TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Chase Bank", false, "Salaire reçu : ~g~$~s~"..salary_job.."")
        end
    end)
end)


