--[[
################################################################
- Creator: Jyben
- Date: 01/05/2017
- Url: https://github.com/Jyben/emergency
- Licence: Apache 2.0
################################################################
--]]

local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local lang = 'fr'

local txt = {
    ['fr'] = {
        ['getService'] = 'Appuyez sur ~g~E~s~ pour prendre votre service',
        ['dropService'] = 'Appuyez sur ~g~E~s~ pour terminer votre service',
        ['getAmbulance'] = 'Appuyez sur ~g~E~s~ pour obtenir un véhicule',
        ['callTaken'] = 'L\'appel a été pris par ~b~',
        ['emergency'] = '<b>~r~URGENCE~s~ <br><br>~b~Raison~s~: </b>',
        ['takeCall'] = '<b>Appuyez sur ~g~Y~s~ pour prendre l\'appel</b>',
        ['callExpires'] = '<b>~r~URGENCE~s~ <br><br>Attention, l\'appel précèdent a expiré !</b>',
        ['gps'] = 'Un point a été placé sur votre GPS là où se trouve la victime en détresse',
        ['res'] = 'Appuyez sur ~g~E~s~ pour réanimer le joueur',
        ['notDoc'] = 'Vous n\'êtes pas ambulancier',
        ['stopService'] = 'Vous n\'êtes plus en service',
        ['startService'] = 'Début du service'
    },

    ['en'] = {
        ['getService'] = 'Press ~g~E~s~ to take your service',
        ['dropService'] = 'Press ~g~E~s~ to stop your service',
        ['getAmbulance'] = 'Press ~g~E~s~ to get your car',
        ['callTaken'] = 'The call is taken by ~b~',
        ['emergency'] = '<b>~r~EMERGENCY~s~ <br><br>~b~Reason~s~: </b>',
        ['takeCall'] = '<b>Press ~g~Y~s~ to take the call</b>',
        ['callExpires'] = '<b>~r~EMERGENCY~s~ <br><br>Warning, the previous call has expired</b>',
        ['gps'] = 'A point has been placed on your GPS where the victim is in distress',
        ['res'] = 'Press ~g~E~s~ to resuscitate the player',
        ['notDoc'] = 'Your are not a doctor',
        ['stopService'] = 'You are no longer in service',
        ['startService'] = 'Start of service'
    }
}

local isInService = false
local jobId = -1
local notificationInProgress = false
local playerInComaIsADoc = false

--[[
################################
            THREADS
################################
--]]

Citizen.CreateThread(
    function()
        local x = 1155.26
        local y = -1520.82
        local z = 34.84

        while true do
            Citizen.Wait(1)

            local playerPos = GetEntityCoords(GetPlayerPed(-1), true)

            if (Vdist(playerPos.x, playerPos.y, playerPos.z, x, y, z) < 100.0) then
                -- Service
                DrawMarker(1, x, y, z - 1, 0, 0, 0, 0, 0, 0, 3.0001, 3.0001, 1.5001, 255, 165, 0,165, 0, 0, 0,0)

                if (Vdist(playerPos.x, playerPos.y, playerPos.z, x, y, z) < 2.0) then
                    if isInService then
                        DisplayHelpText(txt[lang]['dropService'])
                    else
                        DisplayHelpText(txt[lang]['getService'])
                    end

                    if (IsControlJustReleased(1, 51)) then
                        TriggerServerEvent('es_em:sv_getJobId')
                    end
                end
            end
        end
    end)

Citizen.CreateThread(
    function()
        local x = 1140.41
        local y = -1608.15
        local z = 34.6939
        local blip = false


        while true do
            Citizen.Wait(1)


            local playerPos = GetEntityCoords(GetPlayerPed(-1), true)

            if (Vdist(playerPos.x, playerPos.y, playerPos.z, x, y, z) < 100.0) and isInService and jobId == 7 then
                -- Service car
                DrawMarker(1, x, y, z - 1, 0, 0, 0, 0, 0, 0, 3.0001, 3.0001, 1.5001, 255, 165, 0,165, 0, 0, 0,0)

                if (Vdist(playerPos.x, playerPos.y, playerPos.z, x, y, z) < 2.0) then
                    DisplayHelpText(txt[lang]['getAmbulance'])

                    if (IsControlJustReleased(1, 51)) then
                        SpawnAmbulance()
                    end
                end
            end
        end
    end)

Citizen.CreateThread(
    function()
        local x = 1175.72
        local y = -1538.25
        local z = 39.401
        local blip = false


        while true do
            Citizen.Wait(1)


            local playerPos = GetEntityCoords(GetPlayerPed(-1), true)

            if (Vdist(playerPos.x, playerPos.y, playerPos.z, x, y, z) < 100.0) and isInService and jobId == 7 then
                -- Service car
                DrawMarker(1, x, y, z - 1, 0, 0, 0, 0, 0, 0, 3.0001, 3.0001, 1.5001, 255, 165, 0,165, 0, 0, 0,0)

                if (Vdist(playerPos.x, playerPos.y, playerPos.z, x, y, z) < 2.0) then
                    DisplayHelpText(txt[lang]['getAmbulance'])

                    if (IsControlJustReleased(1, 51)) then
                        SpawnHelicopter()
                    end
                end
            end
        end
    end)

--[[
################################
            EVENTS
################################
--]]

RegisterNetEvent('es_em:sendEmergencyToDocs')
AddEventHandler('es_em:sendEmergencyToDocs',
    function(reason, playerIDInComa, x, y, z, sourcePlayerInComa)
        local playerServerId = GetPlayerServerId(PlayerId())

        if playerIDInComa == playerServerId then playerInComaIsADoc = true else playerInComaIsADoc = false end

        Citizen.CreateThread(
            function()
                if isInService and jobId == 7 and not playerInComaIsADoc then
                    local controlPressed = false

                    while notificationInProgress do
                        Citizen.Wait(0)
                    end

                    local notifReceivedAt = GetGameTimer()

                    SendNotification(txt[lang]['emergency'] .. reason)
                    SendNotification(txt[lang]['takeCall'])

                    while not controlPressed do
                        Citizen.Wait(0)
                        notificationInProgress = true

                        if (GetTimeDifference(GetGameTimer(), notifReceivedAt) > 15000) then
                            notificationInProgress = false
                            controlPressed = true
                            SendNotification(txt[lang]['callExpires'])
                        end

                        if IsControlPressed(1, Keys["Y"]) then
                            controlPressed = true
                            TriggerServerEvent('es_em:getTheCall', GetPlayerName(PlayerId()), playerServerId, x, y, z, sourcePlayerInComa)
                        end

                        if controlPressed then
                            notificationInProgress = false
                        end
                    end
                end
            end
        )
    end
)

RegisterNetEvent('es_em:callTaken')
AddEventHandler('es_em:callTaken',
    function(playerName, playerID, x, y, z, sourcePlayerInComa)
        local playerServerId = GetPlayerServerId(PlayerId())

        if isInService and jobId == 7 and not playerInComaIsADoc then
            SendNotification(txt[lang]['callTaken'] .. playerName .. '~s~')
        end

        if playerServerId == playerID then
            TriggerServerEvent('es_em:sv_sendMessageToPlayerInComa', sourcePlayerInComa)
            StartEmergency(x, y, z, sourcePlayerInComa)
        end
    end)

RegisterNetEvent('es_em:cl_setJobId')
AddEventHandler('es_em:cl_setJobId',
    function(p_jobId)
        jobId = p_jobId
        GetService()
    end
)

AddEventHandler('baseevents:onPlayerDied',
    function(playerId, reasonID)
        if (jobId == 7) then
            if isInService then
                SendNotification(txt[lang]['stopService'])
                TriggerServerEvent('es_em:sv_setService', 0)
            end
        end
    end
)

        --[[
        ################################
                BUSINESS METHODS
        ################################
        --]]

        function SpawnAmbulance()
            Citizen.Wait(0)
            local myPed = GetPlayerPed(-1)
            local player = PlayerId()
            local vehicle = GetHashKey('ambulance')

            RequestModel(vehicle)

            while not HasModelLoaded(vehicle) do
                Wait(1)
            end

            local plate = math.random(100, 900)
            local coords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 5.0, 0)
            local spawned_car = CreateVehicle(vehicle, coords, 431.436, - 996.786, 25.1887, true, false)

            SetVehicleOnGroundProperly(spawned_car)
            SetVehicleNumberPlateText(spawned_car, "MEDIC")
            SetPedIntoVehicle(myPed, spawned_car, - 1)
            SetModelAsNoLongerNeeded(vehicle)
            Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(spawned_car))
        end


        function SpawnHelicopter()
            Citizen.Wait(0)
            local myPed = GetPlayerPed(-1)
            local player = PlayerId()
            local vehicle = GetHashKey('supervolito')

            RequestModel(vehicle)

            while not HasModelLoaded(vehicle) do
                Wait(1)
            end

            local plate = math.random(100, 900)
            local coords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 5.0, 0)
            local spawned_car = CreateVehicle(vehicle, coords, 1175.72, -1538.25, 39.401, true, false)

            SetVehicleOnGroundProperly(spawned_car)
            SetVehicleNumberPlateText(spawned_car, "MEDIC")
            SetPedIntoVehicle(myPed, spawned_car, - 1)
            SetModelAsNoLongerNeeded(vehicle)
            Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(spawned_car))
        end


        function StartEmergency(x, y, z, sourcePlayerInComa)
            BLIP_EMERGENCY = AddBlipForCoord(x, y, z)

            SetBlipSprite(BLIP_EMERGENCY, 2)
            SetNewWaypoint(x, y)

            SendNotification(txt[lang]['gps'])

            Citizen.CreateThread(
                function()
                    local isRes = false
                    local ped = GetPlayerPed(-1);
                    while not isRes do
                        Citizen.Wait(0)

                        if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), x,y,z, true)<3.0) then
                            DisplayHelpText(txt[lang]['res'])
                            if (IsControlJustReleased(1, Keys['E'])) then
                                TaskStartScenarioInPlace(ped, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
                                Citizen.Wait(8000)
                                ClearPedTasks(ped);
                                TriggerServerEvent('es_em:sv_resurectPlayer', sourcePlayerInComa)
                                isRes = true
                            end
                        end
                    end
                end)
        end

        -- Get job form server
        function GetService()
            local playerPed = GetPlayerPed(-1)

            if (jobId ~= 7) then
                SendNotification(txt[lang]['notDoc'])
                return
            end

            if isInService then
                SendNotification(txt[lang]['stopService'])
                TriggerServerEvent("skin_customization:SpawnPlayer")
                TriggerServerEvent('es_em:sv_setService', 0)
            else
                SendNotification(txt[lang]['startService'])
                TriggerServerEvent('es_em:sv_setService', 1)
            end

            isInService = not isInService

            SetPedComponentVariation(playerPed, 11, 13, 3, 2)
            SetPedComponentVariation(playerPed, 8, 15, 0, 2)
            SetPedComponentVariation(playerPed, 4, 9, 3, 2)
            SetPedComponentVariation(playerPed, 3, 92, 0, 2)
            SetPedComponentVariation(playerPed, 6, 25, 0, 2)
        end

        --[[
        ################################
                USEFUL METHODS
        ################################
        --]]

        function DisplayHelpText(str)
            SetTextComponentFormat("STRING")
            AddTextComponentString(str)
            DisplayHelpTextFromStringLabel(0, 0, 1, -1)
        end

        function SendNotification(message)
            SetNotificationTextEntry("STRING")
            AddTextComponentString(message)
            DrawNotification(false, false)
        end

        function GetClosestPlayer()
            local players = GetPlayers()
            local closestDistance = -1
            local closestPlayer = -1
            local ply = GetPlayerPed(-1)
            local plyCoords = GetEntityCoords(ply, 0)

            for index,value in ipairs(players) do
                local target = GetPlayerPed(value)
                if(target ~= ply) then
                    local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
                    local distance = GetDistanceBetweenCoords(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
                    if(closestDistance == -1 or closestDistance > distance) then
                        closestPlayer = value
                        closestDistance = distance
                    end
                end
            end

            return closestPlayer, closestDistance
        end

        function GetPlayers()
            local players = {}

            for i = 0, 31 do
                if NetworkIsPlayerActive(i) then
                    table.insert(players, i)
                end
            end

            return players
        end
