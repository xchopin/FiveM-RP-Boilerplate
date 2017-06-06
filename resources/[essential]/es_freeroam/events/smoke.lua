local thisPed
local pedCoords = {}
local storedPeds = {}
local blips = {
  -- Smoke on the water
  {x=-1171.42, y=-1572.72, z=3.6636},
}

local MISSION = {}
MISSION.start = false
MISSION.wanted = false
local playerCoords
local playerPed

showStartText   = false

--blips
local BLIP = {}
Citizen.CreateThread(function()
    while true do
       Wait(0)

       RequestAnimSet("MOVE_M@DRUNK@SLIGHTLYDRUNK")
           while not HasAnimSetLoaded("MOVE_M@DRUNK@SLIGHTLYDRUNK") do
            Citizen.Wait(0)
           end

       playerPed = GetPlayerPed(-1)
       playerCoords = GetEntityCoords(playerPed, 0)
      smoketick()
    end
end)

function smoketick()
    --Show notification, when player is near the weedshop
    if(MISSION.start == false) then
    for _, item in pairs(blips) do
    if(GetDistanceBetweenCoords(playerCoords, item.x, item.y, item.z) < 10) then
            if(showStartText == false) then
                DealText()
            end
            -- Start mission
            if(IsControlPressed(1, 38)) then
              TriggerServerEvent("es_freeroam:pay", tonumber(50))
              Toxicated()
              MISSION.start = true
            end
          else
            showStartText = false
          end --if GetDistanceBetweenCoords ...
        end -- end for
      end--if MISSION.start == false

          if(MISSION.start == true) then
            Citizen.CreateThread(function()
              while true do
                Wait(0)
                playerPed = GetPlayerPed(-1)
                playerCoords = GetEntityCoords(playerPed, 0)
                vehCheck = IsPedInAnyVehicle(GetPlayerPed(-1), true)
                -- Check if the player is inside a vehicle
                if vehCheck and MISSION.start == true  then
                  -- Set the player wanted
                  SetPlayerWantedLevel(GetPlayerPed(playerPed),1,false)
                  SetPlayerWantedLevelNow(GetPlayerPed(playerPed),false)
                end
              end
            end)
            Citizen.Wait(120000)
            reality()
            MISSION.start = false
          end -- end mission.start
        end -- end tick

        function Toxicated()
          TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_DRUG_DEALER", 0, 1)
          Citizen.Wait(5000)
          DoScreenFadeOut(1000)
          Citizen.Wait(1000)
          ClearPedTasksImmediately(GetPlayerPed(-1))
          SetTimecycleModifier("spectator5")
          SetPedMotionBlur(GetPlayerPed(-1), true)
          SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
          SetPedIsDrunk(GetPlayerPed(-1), true)
          DoScreenFadeIn(1000)
        end

        function reality()
          Citizen.Wait(50000)
          DoScreenFadeOut(1000)
          Citizen.Wait(1000)
          DoScreenFadeIn(1000)
          ClearTimecycleModifier()
          ResetScenarioTypesEnabled()
          ResetPedMovementClipset(GetPlayerPed(-1), 0)
          SetPedIsDrunk(GetPlayerPed(-1), false)
          SetPedMotionBlur(GetPlayerPed(-1), false)
          -- Stop the mini mission
          Citizen.Trace("Going back to reality\n")
        end

        function DealText()
          DrawMarker(1, -1171.42, -1572.72, 3.6636, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 2.0, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
          ShowInfo("Press ~INPUT_CONTEXT~ to buy drugs", 0)
        end

        function DrawMissionText(m_text, showtime)
          ClearPrints()
          SetTextEntry_2("STRING")
          AddTextComponentString(m_text)
          DrawSubtitleTimed(showtime, 1)
        end

        function ShowNotification(text)
          SetNotificationTextEntry("STRING")
          AddTextComponentString(text)
          DrawNotification(true, false)
        end

        function ShowInfo(text, state)
          SetTextComponentFormat("STRING")
          AddTextComponentString(text)DisplayHelpTextFromStringLabel(0, state, 0, -1)
        end
