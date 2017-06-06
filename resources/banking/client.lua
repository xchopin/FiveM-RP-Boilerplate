-- Settings
local depositAtATM = true -- Allows the player to deposit at an ATM rather than only in banks (Default: false)
local giveCashAnywhere = false -- Allows the player to give CASH to another player, no matter how far away they are. (Default: false)
local withdrawAnywhere = false -- Allows the player to withdraw cash from bank account anywhere (Default: false)
local depositAnywhere = false -- Allows the player to deposit cash into bank account anywhere (Default: false)
local displayBankBlips = true -- Toggles Bank Blips on the map (Default: true)
local displayAtmBlips = false -- Toggles ATM blips on the map (Default: false) // THIS IS UGLY. SOME ICONS OVERLAP BECAUSE SOME PLACES HAVE MULTIPLE ATM MACHINES. NOT RECOMMENDED
local enableBankingGui = true -- Enables the banking GUI (Default: true) // MAY HAVE SOME ISSUES

-- ATMS
local atms = {
  {name="ATM", id=277, x=-386.733, y=6045.953, z=31.501},
  {name="ATM", id=277, x=-284.037, y=6224.385, z=31.187},
  {name="ATM", id=277, x=-284.037, y=6224.385, z=31.187},
  {name="ATM", id=277, x=-135.165, y=6365.738, z=31.101},
  {name="ATM", id=277, x=-110.753, y=6467.703, z=31.784},
  {name="ATM", id=277, x=-94.9690, y=6455.301, z=31.784},
  {name="ATM", id=277, x=155.4300, y=6641.991, z=31.784},
  {name="ATM", id=277, x=174.6720, y=6637.218, z=31.784},
  {name="ATM", id=277, x=1703.138, y=6426.783, z=32.730},
  {name="ATM", id=277, x=1735.114, y=6411.035, z=35.164},
  {name="ATM", id=277, x=1702.842, y=4933.593, z=42.051},
  {name="ATM", id=277, x=1967.333, y=3744.293, z=32.272},
  {name="ATM", id=277, x=1821.917, y=3683.483, z=34.244},
  {name="ATM", id=277, x=1174.532, y=2705.278, z=38.027},
  {name="ATM", id=277, x=540.0420, y=2671.007, z=42.177},
  {name="ATM", id=277, x=2564.399, y=2585.100, z=38.016},
  {name="ATM", id=277, x=2558.683, y=349.6010, z=108.050},
  {name="ATM", id=277, x=2558.051, y=389.4817, z=108.660},
  {name="ATM", id=277, x=1077.692, y=-775.796, z=58.218},
  {name="ATM", id=277, x=1139.018, y=-469.886, z=66.789},
  {name="ATM", id=277, x=1168.975, y=-457.241, z=66.641},
  {name="ATM", id=277, x=1153.884, y=-326.540, z=69.245},
  {name="ATM", id=277, x=381.2827, y=323.2518, z=103.270},
  {name="ATM", id=277, x=236.4638, y=217.4718, z=106.840},
  {name="ATM", id=277, x=265.0043, y=212.1717, z=106.780},
  {name="ATM", id=277, x=285.2029, y=143.5690, z=104.970},
  {name="ATM", id=277, x=157.7698, y=233.5450, z=106.450},
  {name="ATM", id=277, x=-164.568, y=233.5066, z=94.919},
  {name="ATM", id=277, x=-1827.04, y=785.5159, z=138.020},
  {name="ATM", id=277, x=-1409.39, y=-99.2603, z=52.473},
  {name="ATM", id=277, x=-1205.35, y=-325.579, z=37.870},
  {name="ATM", id=277, x=-1215.64, y=-332.231, z=37.881},
  {name="ATM", id=277, x=-2072.41, y=-316.959, z=13.345},
  {name="ATM", id=277, x=-2975.72, y=379.7737, z=14.992},
  {name="ATM", id=277, x=-2962.60, y=482.1914, z=15.762},
  {name="ATM", id=277, x=-2955.70, y=488.7218, z=15.486},
  {name="ATM", id=277, x=-3044.22, y=595.2429, z=7.595},
  {name="ATM", id=277, x=-3144.13, y=1127.415, z=20.868},
  {name="ATM", id=277, x=-3241.10, y=996.6881, z=12.500},
  {name="ATM", id=277, x=-3241.11, y=1009.152, z=12.877},
  {name="ATM", id=277, x=-1305.40, y=-706.240, z=25.352},
  {name="ATM", id=277, x=-538.225, y=-854.423, z=29.234},
  {name="ATM", id=277, x=-711.156, y=-818.958, z=23.768},
  {name="ATM", id=277, x=-717.614, y=-915.880, z=19.268},
  {name="ATM", id=277, x=-526.566, y=-1222.90, z=18.434},
  {name="ATM", id=277, x=-256.831, y=-719.646, z=33.444},
  {name="ATM", id=277, x=-203.548, y=-861.588, z=30.205},
  {name="ATM", id=277, x=112.4102, y=-776.162, z=31.427},
  {name="ATM", id=277, x=112.9290, y=-818.710, z=31.386},
  {name="ATM", id=277, x=119.9000, y=-883.826, z=31.191},
  {name="ATM", id=277, x=149.4551, y=-1038.95, z=29.366},
  {name="ATM", id=277, x=-846.304, y=-340.402, z=38.687},
  {name="ATM", id=277, x=-1204.35, y=-324.391, z=37.877},
  {name="ATM", id=277, x=-1216.27, y=-331.461, z=37.773},
  {name="ATM", id=277, x=-56.1935, y=-1752.53, z=29.452},
  {name="ATM", id=277, x=-261.692, y=-2012.64, z=30.121},
  {name="ATM", id=277, x=-273.001, y=-2025.60, z=30.197},
  {name="ATM", id=277, x=314.187, y=-278.621, z=54.170},
  {name="ATM", id=277, x=-351.534, y=-49.529, z=49.042},
  {name="ATM", id=277, x=24.589, y=-946.056, z=29.357},
  {name="ATM", id=277, x=-254.112, y=-692.483, z=33.616},
  {name="ATM", id=277, x=-1570.197, y=-546.651, z=34.955},
  {name="ATM", id=277, x=-1415.909, y=-211.825, z=46.500},
  {name="ATM", id=277, x=-1430.112, y=-211.014, z=46.500},
  {name="ATM", id=277, x=33.232, y=-1347.849, z=29.497},
  {name="ATM", id=277, x=129.216, y=-1292.347, z=29.269},
  {name="ATM", id=277, x=287.645, y=-1282.646, z=29.659},
  {name="ATM", id=277, x=289.012, y=-1256.545, z=29.440},
  {name="ATM", id=277, x=295.839, y=-895.640, z=29.217},
  {name="ATM", id=277, x=1686.753, y=4815.809, z=42.008},
  {name="ATM", id=277, x=-302.408, y=-829.945, z=32.417},
  {name="ATM", id=277, x=5.134, y=-919.949, z=29.557},

}


function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

-- Banks
local banks = {
  {name="Banque Chase Manhattan", id=375, x=150.266, y=-1040.203, z=29.374},
  {name="Banque Chase Manhattan", id=375, x=-1212.980, y=-330.841, z=37.787},
  {name="Banque Chase Manhattan", id=375, x=-2962.582, y=482.627, z=15.703},
  {name="Banque Chase Manhattan", id=375, x=-112.202, y=6469.295, z=31.626},
  {name="Banque Chase Manhattan", id=375, x=314.187, y=-278.621, z=54.170},
  {name="Banque Chase Manhattan", id=375, x=-351.534, y=-49.529, z=49.042},
  {name="Banque Chase Manhattan", id=375, x=241.727, y=220.706, z=106.286},
}

-- Display Map Blips
Citizen.CreateThread(function()
  if (displayBankBlips == true) then
    for _, item in pairs(banks) do
      item.blip = AddBlipForCoord(item.x, item.y, item.z)
      SetBlipSprite(item.blip, item.id)
      SetBlipColour(blip, 3)
      SetBlipAsShortRange(item.blip, true)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(item.name)
      EndTextCommandSetBlipName(item.blip)
    end
  end
  if (displayAtmBlips == true) then
    for _, item in pairs(atms) do
      item.blip = AddBlipForCoord(item.x, item.y, item.z)
      SetBlipSprite(item.blip, item.id)
      SetBlipAsShortRange(item.blip, true)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(item.name)
      EndTextCommandSetBlipName(item.blip)
    end
  end
end)

-- NUI Variables
local atBank = false
local atATM = false
local bankOpen = false
local atmOpen = false

-- Open Gui and Focus NUI
function openGui()
  SetNuiFocus(true)
  SendNUIMessage({openBank = true})
end

-- Close Gui and disable NUI
function closeGui()
  SetNuiFocus(false)
  SendNUIMessage({openBank = false})
  bankOpen = false
  atmOpen = false
end

-- If GUI setting turned on, listen for INPUT_PICKUP keypress
if enableBankingGui then
  Citizen.CreateThread(function()
    while true do
      Citizen.Wait(0)
      if(IsNearBank() or IsNearATM()) then
        if (atBank == false) then
          DisplayHelpText("Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le ~y~menu~w~.")
        end
        atBank = true
        if IsControlJustReleased(1, 51)  then -- IF INPUT_PICKUP Is pressed
          if (IsInVehicle()) then
           DisplayHelpText("~r~Vous ne pouvez pas utiliser l'ATM depuis un véhicule~w~.")
          else
            if bankOpen then
              closeGui()
              bankOpen = false
            else
              openGui()
              bankOpen = true
            end
          end
      	end
      else
        if(atmOpen or bankOpen) then
          closeGui()
        end
        atBank = false
        atmOpen = false
        bankOpen = false
      end
    end
  end)
end

-- Disable controls while GUI open
Citizen.CreateThread(function()
  while true do
    if bankOpen or atmOpen then
      local ply = GetPlayerPed(-1)
      local active = true
      DisableControlAction(0, 1, active) -- LookLeftRight
      DisableControlAction(0, 2, active) -- LookUpDown
      DisableControlAction(0, 24, active) -- Attack
      DisablePlayerFiring(ply, true) -- Disable weapon firing
      DisableControlAction(0, 142, active) -- MeleeAttackAlternate
      DisableControlAction(0, 106, active) -- VehicleMouseControlOverride
      if IsControlJustReleased(1, 51) or IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
        SendNUIMessage({type = "click"})
      end
    end
    Citizen.Wait(10)
  end
end)

-- NUI Callback Methods
RegisterNUICallback('close', function(data, cb)
  closeGui()
  cb('ok')
end)

RegisterNUICallback('balance', function(data, cb)
  SendNUIMessage({openSection = "balance"})
  cb('ok')
end)

RegisterNUICallback('withdraw', function(data, cb)
  SendNUIMessage({openSection = "withdraw"})
  cb('ok')
end)

RegisterNUICallback('deposit', function(data, cb)
  SendNUIMessage({openSection = "deposit"})
  cb('ok')
end)

RegisterNUICallback('transfer', function(data, cb)
  SendNUIMessage({openSection = "transfer"})
  cb('ok')
end)

RegisterNUICallback('quickCash', function(data, cb)
  TriggerEvent('bank:withdraw', 100)
  cb('ok')
end)

RegisterNUICallback('withdrawSubmit', function(data, cb)
  TriggerEvent('bank:withdraw', data.amount)
  cb('ok')
end)

RegisterNUICallback('depositSubmit', function(data, cb)
  TriggerEvent('bank:deposit', data.amount)
  cb('ok')
end)

RegisterNUICallback('transferSubmit', function(data, cb)
  local fromPlayer = GetPlayerServerId();
  TriggerEvent('bank:transfer', tonumber(fromPlayer), tonumber(data.toPlayer), tonumber(data.amount))
  cb('ok')
end)

-- Check if player is near an atm
function IsNearATM()
  local ply = GetPlayerPed(-1)
  local plyCoords = GetEntityCoords(ply, 0)
  for _, item in pairs(atms) do
    local distance = GetDistanceBetweenCoords(item.x, item.y, item.z,  plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
    if(distance <= 1) then
      return true
    end
  end
end

-- Check if player is in a vehicle
function IsInVehicle()
  local ply = GetPlayerPed(-1)
  if IsPedSittingInAnyVehicle(ply) then
    return true
  else
    return false
  end
end

-- Check if player is near a bank
function IsNearBank()
  local ply = GetPlayerPed(-1)
  local plyCoords = GetEntityCoords(ply, 0)
  for _, item in pairs(banks) do
    local distance = GetDistanceBetweenCoords(item.x, item.y, item.z,  plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
    if(distance <= 3) then
      return true
    end
  end
end

-- Check if player is near another player
function IsNearPlayer(player)
  local ply = GetPlayerPed(-1)
  local plyCoords = GetEntityCoords(ply, 0)
  local ply2 = GetPlayerPed(GetPlayerFromServerId(player))
  local ply2Coords = GetEntityCoords(ply2, 0)
  local distance = GetDistanceBetweenCoords(ply2Coords["x"], ply2Coords["y"], ply2Coords["z"],  plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
  if(distance <= 5) then
    return true
  end
end

-- Process deposit if conditions met
RegisterNetEvent('bank:deposit')
AddEventHandler('bank:deposit', function(amount)
  if(IsNearBank() == true or depositAtATM == true and IsNearATM() == true or depositAnywhere == true ) then
    if (IsInVehicle()) then
        DisplayHelpText("~r~Vous ne pouvez pas utiliser l'ATM depuis un véhicule~w~.")
    else
      TriggerServerEvent("bank:deposit", tonumber(amount))
    end
  else
      DisplayHelpText("~r~Le dépot se fait uniquement à la banque~w~.")
  end
end)

-- Process withdraw if conditions met
RegisterNetEvent('bank:withdraw')
AddEventHandler('bank:withdraw', function(amount)
  if(IsNearATM() == true or IsNearBank() == true or withdrawAnywhere == true) then
    if (IsInVehicle()) then
       DisplayHelpText("~r~Vous ne pouvez pas utiliser l'ATM depuis un véhicule~w~.")
    else
      TriggerServerEvent("bank:withdraw", tonumber(amount))
    end
  else
    DisplayHelpText("~r~Le dépot se fait uniquement à la banque~w~.")
  end
end)

-- Process give cash if conditions met
RegisterNetEvent('bank:givecash')
AddEventHandler('bank:givecash', function(toPlayer, amount)
  if(IsNearPlayer(toPlayer) == true or giveCashAnywhere == true) then
    local player2 = GetPlayerFromServerId(toPlayer)
    local playing = IsPlayerPlaying(player2)
    if (playing ~= false) then
      TriggerServerEvent("bank:givecash", toPlayer, tonumber(amount))
    else
      TriggerEvent('chatMessage', "", {255, 0, 0}, "^1Ce joueur n'est pas dans la ville.");
    end
  else
    TriggerEvent('chatMessage', "", {255, 0, 0}, "^1Ce joueur n'est pas près de vous.");
  end
end)

-- Process bank transfer if player is online
RegisterNetEvent('bank:transfer')
AddEventHandler('bank:transfer', function(fromPlayer, toPlayer, amount)
  local player2 = GetPlayerFromServerId(toPlayer)
  local playing = IsPlayerPlaying(player2)
  if (playing ~= false) then
    TriggerServerEvent("bank:transfer", fromPlayer, toPlayer, tonumber(amount))
  else
    TriggerEvent('chatMessage', "", {255, 0, 0}, "^1Ce joueur n'est pas dans la ville.");
  end
end)

-- Send NUI message to update bank balance
RegisterNetEvent('banking:updateBalance')
AddEventHandler('banking:updateBalance', function(balance)
  local id = PlayerId()
  local playerName = GetPlayerName(id)
	SendNUIMessage({
		updateBalance = true,
		balance = balance,
    player = playerName
	})
end)

-- Send NUI Message to display add balance popup
RegisterNetEvent("banking:addBalance")
AddEventHandler("banking:addBalance", function(amount)
	SendNUIMessage({
		addBalance = true,
		amount = amount
	})

end)

-- Send NUI Message to display remove balance popup
RegisterNetEvent("banking:removeBalance")
AddEventHandler("banking:removeBalance", function(amount)
	SendNUIMessage({
		removeBalance = true,
		amount = amount
	})
end)
