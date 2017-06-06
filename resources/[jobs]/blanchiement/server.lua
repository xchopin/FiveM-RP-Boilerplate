

require "resources/essentialmode/lib/MySQL"

MySQL:open("127.0.0.1", "gta5_gamemode_essential", "root", "")


RegisterServerEvent('blanchiement:getMoney')
AddEventHandler('blanchiement:getMoney',
  function()
    TriggerClientEvent('blanchiement:checkDirty', source, GetMoney(source))
  end
)

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.abs(math.floor(num * mult + 0.5) / mult)
end


RegisterServerEvent('blanchiement:sendMoney')
AddEventHandler("blanchiement:sendMoney", function(amount)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local player = user.identifier
        if (tonumber(amount) > 0) then
          user:addMoney( round( (tonumber(amount) / 1.70), 0) )
          user:setDirty_Money(0)
          MySQL:executeQuery("UPDATE users SET dirty_money = 0 WHERE identifier = '@username'", {
                ['@username'] = player
          })
        end     
    end)
end)



function GetMoney(source)
  local money = -1

  TriggerEvent('es:getPlayerFromId', source,
    function(user)
      local executed_query = MySQL:executeQuery("SELECT dirty_money FROM users WHERE users.identifier = '@identifier' ", {['@identifier'] = user.identifier})
      local result = MySQL:getResults(executed_query, {'dirty_money'}, "identifier")

      if (result[1] ~= nil) then
        money = tonumber(result[1].dirty_money)
      end
    end
  )

  return tonumber(money)
end

