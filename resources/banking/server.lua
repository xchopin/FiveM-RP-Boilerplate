require "resources/essentialmode/lib/MySQL"
MySQL:open("127.0.0.1", "gta5_gamemode_essential", "root", "")

-- HELPER FUNCTIONS
function bankBalance(player)
  local executed_query = MySQL:executeQuery("SELECT * FROM users WHERE identifier = '@name'", {['@name'] = player})
  local result = MySQL:getResults(executed_query, {'bankbalance'}, "identifier")
  return tonumber(result[1].bankbalance)
end

function deposit(player, amount)
  local bankbalance = bankBalance(player)
  local new_balance = bankbalance + amount
  MySQL:executeQuery("UPDATE users SET `bankbalance`='@value' WHERE identifier = '@identifier'", {['@value'] = new_balance, ['@identifier'] = player})
end

function withdraw(player, amount)
  local bankbalance = bankBalance(player)
  local new_balance = bankbalance - amount
  MySQL:executeQuery("UPDATE users SET `bankbalance`='@value' WHERE identifier = '@identifier'", {['@value'] = new_balance, ['@identifier'] = player})
end

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.abs(math.floor(num * mult + 0.5) / mult)
end

-- Check Bank Balance
TriggerEvent('es:addCommand', 'checkbalance', function(source, args, user)
  TriggerEvent('es:getPlayerFromId', source, function(user)
    local player = user.identifier
    local bankbalance = bankBalance(player)
    TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Your current account balance: ~g~$".. bankbalance)
    TriggerClientEvent("banking:updateBalance", source, bankbalance)
    CancelEvent()
  end)
end)

-- Bank Deposit
TriggerEvent('es:addCommand', 'deposit', function(source, args, user)
  local amount = ""
  local player = user.identifier
  for i=1,#args do
    amount = args[i]
  end
  TriggerClientEvent('bank:deposit', source, amount)
end)

RegisterServerEvent('bank:deposit')
AddEventHandler('bank:deposit', function(amount)
  TriggerEvent('es:getPlayerFromId', source, function(user)
      local rounded = round(tonumber(amount), 0)
      if(string.len(rounded) >= 9) then
        TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Input too high^0")
        CancelEvent()
      else
      	if(tonumber(rounded) <= tonumber(user:money)) then
          user:removeMoney((rounded))
          local player = user.identifier
          deposit(player, rounded)
          local new_balance = bankBalance(player)
          TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Chase Bank", false, "Déposé: ~g~$".. rounded .." ~n~~s~Nouveau solde: ~g~$" .. new_balance)
          TriggerClientEvent("banking:updateBalance", source, new_balance)
          TriggerClientEvent("banking:addBalance", source, rounded)
          CancelEvent()
        else
          TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Pas assez d'argent!^0")
          CancelEvent()
        end
      end
  end)
end)

-- Bank Withdraw
TriggerEvent('es:addCommand', 'withdraw', function(source, args, user)
  local amount = ""
  local player = user.identifier
  for i=1,#args do
    amount = args[i]
  end
  TriggerClientEvent('bank:withdraw', source, amount)
end)

RegisterServerEvent('bank:withdraw')
AddEventHandler('bank:withdraw', function(amount)
  TriggerEvent('es:getPlayerFromId', source, function(user)
      local rounded = round(tonumber(amount), 0)
      if(string.len(rounded) >= 9) then
        TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Montant trop élevé^0")
        CancelEvent()
      else
        local player = user.identifier
        local bankbalance = bankBalance(player)
        if(tonumber(rounded) <= tonumber(bankbalance)) then
          withdraw(player, rounded)
          user:addMoney((rounded))
          local new_balance = bankBalance(player)
          TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Chase Bank", false, "Retrait: ~g~$".. rounded .." ~n~~s~Nouveau solde: ~g~$" .. new_balance)
          TriggerClientEvent("banking:updateBalance", source, new_balance)
          TriggerClientEvent("banking:removeBalance", source, rounded)
          CancelEvent()
        else
          TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Solde trop faible!^0")
          CancelEvent()
        end
      end
  end)
end)

-- Bank Transfer

RegisterServerEvent('bank:transfer')
AddEventHandler('bank:transfer', function(fromPlayer, toPlayer, amount)
  if tonumber(fromPlayer) == tonumber(toPlayer) then
    TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Vous ne pouvez pas vous transférer de l'argent^0")
    CancelEvent()
  else
    TriggerEvent('es:getPlayerFromId', fromPlayer, function(user)
        local rounded = round(tonumber(amount), 0)
        if(string.len(rounded) >= 9) then
          TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Montant trop élevé^0")
          CancelEvent()
        else
          local player = user.identifier
          local bankbalance = bankBalance(player)
          if(tonumber(rounded) <= tonumber(bankbalance)) then
            withdraw(player, rounded)
            local new_balance = bankBalance(player)
            TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Chase Bank", false, "Transféré: ~r~-$".. rounded .." ~n~~s~Nouveau solde: ~g~$" .. new_balance)
            TriggerClientEvent("banking:updateBalance", source, new_balance)
            TriggerClientEvent("banking:removeBalance", source, rounded)
            TriggerEvent('es:getPlayerFromId', toPlayer, function(user2)
                local recipient = user2.identifier
                deposit(recipient, rounded)
                new_balance2 = bankBalance(recipient)
                TriggerClientEvent("es_freeroam:notify", toPlayer, "CHAR_BANK_MAZE", 1, "Chase Bank", false, "Reçu: ~g~$".. rounded .." ~n~~s~Nouveau solde: ~g~$" .. new_balance2)
                TriggerClientEvent("banking:updateBalance", toPlayer, new_balance2)
                TriggerClientEvent("banking:addBalance", toPlayer, rounded)
                CancelEvent()
            end)
            CancelEvent()
          else
            TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Pas assez d'argent!^0")
            CancelEvent()
          end
        end
    end)
  end
end)

-- Give Cash
TriggerEvent('es:addCommand', 'givecash', function(source, args, user)
  local fromPlayer
  local toPlayer
  local amount
  if (args[2] ~= nil and tonumber(args[3]) > 0) then
    fromPlayer = tonumber(source)
    toPlayer = tonumber(args[2])
    amount = tonumber(args[3])
    TriggerClientEvent('bank:givecash', source, toPlayer, amount)
	else
    TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Utilisez la commande /givecash [id] [montant]^0")
    return false
  end
end)

RegisterServerEvent('bank:givecash')
AddEventHandler('bank:givecash', function(toPlayer, amount)
	TriggerEvent('es:getPlayerFromId', source, function(user)
		if (tonumber(user.money) >= tonumber(amount)) then
			local player = user.identifier
			user:removeMoney(amount)
			TriggerEvent('es:getPlayerFromId', toPlayer, function(recipient)
				recipient:addMoney(amount)
				TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Chase Bank", false, "Argent donné: ~r~-$".. amount .." ~n~~s~Porte feuille: ~g~$" .. user.money)
				TriggerClientEvent("es_freeroam:notify", toPlayer, "CHAR_BANK_MAZE", 1, "Chase Bank", false, "Argent reçu: ~g~$".. amount .." ~n~~s~Porte feuille: ~g~$" .. recipient.money)
			end)
		else
			if (tonumber(user.money) < tonumber(amount)) then
        TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Pas assez d'argent dans le portefeuille!^0")
        CancelEvent()
			end
		end
	end)
end)

AddEventHandler('es:playerLoaded', function(source)
  TriggerEvent('es:getPlayerFromId', source, function(user)
      local player = user.identifier
      local bankbalance = bankBalance(player)
      TriggerClientEvent("banking:updateBalance", source, bankbalance)
    end)
end)

RegisterServerEvent('bank:withdrawAmende')
AddEventHandler('bank:withdrawAmende', function(amount)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local player = user.identifier
        local bankbalance = bankBalance(player)
    withdraw(player, amount)
    local new_balance = bankBalance(player)
    TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Chase Bank", false, "Nouveau solde: ~g~$" .. new_balance)
    TriggerClientEvent("banking:updateBalance", source, new_balance)
    TriggerClientEvent("banking:removeBalance", source, amount)
    CancelEvent()
    end)
end)

RegisterServerEvent('bank:donnerargent')
AddEventHandler('bank:donnerargent', function(toPlayer, amount)
  TriggerEvent('es:getPlayerFromId', source, function(user)
      local rounded = round(tonumber(amount), 0)
      if(string.len(rounded) >= 9) then
        TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Vous tentez de transferer une trop grosse somme^0")
        CancelEvent()
      else
        local player = user.identifier
        if(user:getMoney() >= rounded) then
          user:removeMoney((rounded))
          TriggerClientEvent("es_freeroam:notify", source, "CHAR_DEFAULT", 1, "", false, "Vous transferez: ~r~-$".. rounded)
          TriggerEvent('es:getPlayerFromId', toPlayer, function(user2)
              local recipient = user2.identifier
              user2:addMoney((rounded))
              TriggerClientEvent("es_freeroam:notify", toPlayer, "CHAR_DEFAULT", 1, "", false, "Vous recevez: ~g~$".. rounded)
              CancelEvent()
          end)
          CancelEvent()
        else
          TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Vous n'avez pas autant d'argent sur votre compte !^0")
          CancelEvent()
        end
      end
  end)
end)