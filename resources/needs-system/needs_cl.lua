local rpdfirstspawn = 0
AddEventHandler('playerSpawned', function(spawn)
	if rpdfirstspawn == 0 then
		rpdfirstspawn = 1
	else
		TriggerServerEvent('gabs:setdefaultneeds')
	end
end)

RegisterNetEvent('gabs:needskill')
AddEventHandler('gabs:needskill', function()
	SetEntityHealth(GetPlayerPed(-1), 0)
end)
-- FOOD
RegisterNetEvent('gabs:setfood')
AddEventHandler('gabs:setfood', function(food)
  local id = PlayerId()
  local playerName = GetPlayerName(id)
	SendNUIMessage({
		setfood = true,
		food = food,
    player = playerName
	})
end)

RegisterNetEvent("gabs:add_calories")
AddEventHandler("gabs:add_calories", function(calories)
	SendNUIMessage({
		addcalories = true,
		calories = calories
	})

end)

RegisterNetEvent("gabs:remove_calories")
AddEventHandler("gabs:remove_calories", function(calories)
	SendNUIMessage({
		removecalories = true,
		calories = calories
	})
end)
-- WATER
RegisterNetEvent('gabs:setwater')
AddEventHandler('gabs:setwater', function(water)
  local id = PlayerId()
  local playerName = GetPlayerName(id)
	SendNUIMessage({
		setwater = true,
		water = water,
    player = playerName
	})
end)

RegisterNetEvent("gabs:add_water")
AddEventHandler("gabs:add_water", function(waterdrops)
	SendNUIMessage({
		addwater = true,
		waterdrops = waterdrops
	})

end)

RegisterNetEvent("gabs:remove_water")
AddEventHandler("gabs:remove_water", function(waterdrops)
	SendNUIMessage({
		removewater = true,
		waterdrops = waterdrops
	})
end)
-- NEEDS
RegisterNetEvent('gabs:setneeds')
AddEventHandler('gabs:setneeds', function(needs)
  local id = PlayerId()
  local playerName = GetPlayerName(id)
	SendNUIMessage({
		setneeds = true,
		needs = needs,
    player = playerName
	})
end)

RegisterNetEvent("gabs:add_needs")
AddEventHandler("gabs:add_needs", function(wc)
	SendNUIMessage({
		addneeds = true,
		wc = wc
	})

end)

RegisterNetEvent("gabs:remove_needs")
AddEventHandler("gabs:remove_needs", function(wc)
	SendNUIMessage({
		removeneeds = true,
		wc = wc
	})
end)
-- EMOTES
RegisterNetEvent('gabs:drink')
AddEventHandler('gabs:drink', function()
	ped = GetPlayerPed(-1)
	if ped then
		Citizen.CreateThread(function()
			RequestAnimDict('amb@world_human_drinking_fat@beer@male@idle_a')
		    local pedid = PlayerPedId()
			TaskPlayAnim(pedid, 'amb@world_human_drinking_fat@beer@male@idle_a', 'idle_a', 8.0, -8, -1, 16, 0, 0, 0, 0)
			Citizen.Wait(5000)
			ClearPedTasks(ped)
		end)
	end
end)

RegisterNetEvent('gabs:eat')
AddEventHandler('gabs:eat', function()
	ped = GetPlayerPed(-1)
	if ped then
		Citizen.CreateThread(function()
			RequestAnimDict('amb@code_human_wander_eating_donut@male@idle_a')
		    local pedid = PlayerPedId()
			TaskPlayAnim(pedid, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_c', 8.0, -8, -1, 16, 0, 0, 0, 0)
			Citizen.Wait(5000)
			ClearPedTasks(ped)
		end)
	end
end)

RegisterNetEvent('gabs:pee')
AddEventHandler('gabs:pee', function()
	ped = GetPlayerPed(-1)
	if ped then
		Citizen.CreateThread(function()
			RequestAnimDict('misscarsteal2peeing')
		    local pedid = PlayerPedId()
			TaskPlayAnim(pedid, 'misscarsteal2peeing', 'peeing_intro', 8.0, -8, -1, 16, 0, 0, 0, 0)
			Citizen.Wait(5000)
			TaskPlayAnim(pedid, 'misscarsteal2peeing', 'peeing_loop', 8.0, -8, -1, 16, 0, 0, 0, 0)
			Citizen.Wait(5000)
			TaskPlayAnim(pedid, 'misscarsteal2peeing', 'peeing_outro', 8.0, -8, -1, 16, 0, 0, 0, 0)
			ClearPedTasks(ped)
		end)
	end
end)