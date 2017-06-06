local Federalstorage = {}
local Stage = 0

Citizen.CreateThread(function()
   storageinit()
   end)

Citizen.CreateThread(function()
    while true do
       Wait(0)
       tick()
     end
   end)

function storageinit()
  bank = AddBlipForCoord(-353.317, -54.1684, 49.0365)
  SetBlipSprite(bank, 304)
  SetBlipAsShortRange(bank, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString("Fleeca Job")
  EndTextCommandSetBlipName(bank)

  pickup = CreatePickup(GetHashKey("PICKUP_MONEY_SECURITY_CASE"), -354.009, -54.316, 49.046)
  -- SetPickupRegenerationTime(pickup, 10000)
end

function tick()
	local  playerPed = GetPlayerPed(-1)
  local  playerCoords = GetEntityCoords(playerPed, 0)

		if(Stage==0) then

			local location = GetEntityCoords(playerPed, 0)
			if (GetDistanceBetweenCoords( -353.317, -54.1684, 49.0365, location.x, location.y, location.z, true ) < 2 ) then
					SetPedComponentVariation(playerPed, 9, 1, 0, 0)
					SetPlayerWantedLevel(GetPlayerPed(playerPed),4,false)
					SetPlayerWantedLevelNow(GetPlayerPed(playerPed),false)
          DrawMissionText("Escape the ~r~cops!", 10000)

					Stage = 1
				end
      else if not(IsEntityDead(playerPed)) then

			local location = GetEntityCoords(playerPed, nil )

			if (GetDistanceBetweenCoords( -353.317, -54.1684, 49.0365 , location.x, location.y, location.z, true ) < 42 )
			then

			if(GetPlayerWantedLevel(GetPlayerPedScriptIndex(playerPed))<5) then

					SetPlayerWantedLevel(GetPlayerPed(playerPed),5,false)
					SetPlayerWantedLevelNow(GetPlayerPed(playerPed),false)
					SetPlayerWantedLevel(GetPlayerPed(playerPed),4,false)
					SetPlayerWantedLevelNow(GetPlayerPed(playerPed),false)
				end
			end

		if not(IsPlayerWantedLevelGreater(GetPlayerPed(playerPed),0)) then
					SetPedComponentVariation(playerPed, 9, 0, 0, 0)
					PlayMissionCompleteAudio("FRANKLIN_BIG_01")
          TriggerServerEvent('mission:completed', 500000)
          DrawMissionText("Good job! here is some ~y~cash.", 5000)
					Stage=0
			end
		else
		Stage = 0
		end
	end
end

-- Text stuff
function DrawMissionText(m_text, showtime)
    ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(showtime, 1)
end
