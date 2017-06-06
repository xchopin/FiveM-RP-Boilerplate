--[[
################################################################
- Creator: Jyben
- Date: 30/04/2017
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

local isPrinted = false

local txt = {
    ['fr'] = {
        ['inComa'] = '~r~Vous êtes dans le coma',
        ['accident'] = 'Un accident s\'est produit',
        ['murder'] = 'Tentative de meurtre',
        ['ambIsComming'] = 'Une ~b~ambulance~s~ est en route !',
        ['res'] = 'Vous avez été réanimé',
        ['ko'] = 'Vous êtes KO !',
        ['callAmb'] = 'Appuyez sur ~g~E~s~ pour appeler une ambulance',
        ['respawn'] = 'Appuyez sur ~r~X~s~ pour respawn',
        ['youCallAmb'] = 'Vous avez appelé une ~b~ambulance~s~'
    },

    ['en'] = {
        ['inComa'] = '~r~You are in coma',
        ['accident'] = 'An accident happened',
        ['murder'] = 'An attempted murder.',
        ['ambIsComming'] = 'An ambulance arrives !',
        ['res'] = 'You have been resuscitated',
        ['ko'] = 'You are KO !',
        ['callAmb'] = 'Press ~g~E~s~ to call an ambulance.',
        ['respawn'] = 'Press ~r~X~s~ to respawn',
        ['youCallAmb'] = 'You called an ~b~ambulance~s~'
    }
}

local isDead = false
local isKO = false
local isRes = false
local emergencyComes = false

--[[
################################
            THREADS
################################
--]]


Citizen.CreateThread(function()
    while true do
        if (isPrinted == false) then
            local loc = pos
            local blip = AddBlipForCoord(1155.26,-1520.82, 34.84)
            SetBlipSprite(blip,153)
            SetBlipColour(blip, 49)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString('CHU de Los Santos')
            EndTextCommandSetBlipName(blip)
            SetBlipAsShortRange(blip,true)
            SetBlipAsMissionCreatorBlip(blip,true)
            isPrinted = true
        end
        Citizen.Wait(1)
        --NetworkResurrectLocalPlayer(357.757, -597.202, 28.6314, true, true, false)
        local playerPed = GetPlayerPed(-1)
        local playerID = PlayerId()
        local currentPos = GetEntityCoords(playerPed, true)
        local previousPos

        isDead = IsEntityDead(playerPed)

        if isKO and previousPos ~= currentPos then
            isKO = false
        end

        if (GetEntityHealth(playerPed) < 120 and not isDead and not isKO) then
            if (IsPedInMeleeCombat(playerPed)) then
                SetPlayerKO(playerID, playerPed)
            end
        end

        previousPos = currentPos
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsEntityDead(PlayerPedId()) then
            StartScreenEffect("DeathFailOut", 0, 0)
            ShakeGameplayCam("DEATH_FAIL_IN_EFFECT_SHAKE", 1.0)

            local scaleform = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")

            if HasScaleformMovieLoaded(scaleform) then
                Citizen.Wait(0)

                PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
                BeginTextComponent("STRING")
                AddTextComponentString(txt[lang]['inComa'])
                EndTextComponent()
                PopScaleformMovieFunctionVoid()

                Citizen.Wait(500)

                while IsEntityDead(PlayerPedId()) do
                    DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
                    Citizen.Wait(0)
                end

                StopScreenEffect("DeathFailOut")
            end
        end
    end
end)

--[[
################################
            EVENTS
################################
--]]

AddEventHandler("playerSpawned", function(spawn)
    exports.spawnmanager:setAutoSpawn(false)
end)

-- Triggered when player died by environment
AddEventHandler('baseevents:onPlayerDied',
    function(playerId, reasonID)
        local reason = txt[lang]['accident']
        OnPlayerDied(playerId, reasonID, reason)
    end
)

-- Triggered when player died by an another player
AddEventHandler('baseevents:onPlayerKilled',
    function(playerId, playerKill, reasonID)
        local reason = txt[lang]['murder']
        OnPlayerDied(playerId, reasonID, reason)
    end
)

RegisterNetEvent('es_em:cl_sendMessageToPlayerInComa')
AddEventHandler('es_em:cl_sendMessageToPlayerInComa',
    function()
        emergencyComes = true
        SendNotification(txt[lang]['ambIsComming'])
    end
)

RegisterNetEvent('es_em:cl_resurectPlayer')
AddEventHandler('es_em:cl_resurectPlayer',
    function()
        local playerPed = GetPlayerPed(-1)
        isRes = true

        if IsEntityDead(playerPed) then
            SendNotification(txt[lang]['res'])

            ResurrectPed(playerPed)
            SetEntityHealth(playerPed, GetPedMaxHealth(playerPed)/2)
            ClearPedTasksImmediately(playerPed)
        end
    end
)

RegisterNetEvent('es_em:cl_respawn')
AddEventHandler('es_em:cl_respawn',
    function()
        ResPlayer()
    end
)

--[[
################################
        BUSINESS METHODS
################################
--]]

function SetPlayerKO(playerID, playerPed)
    isKO = true
    SendNotification(txt[lang]['ko'])
    SetPedToRagdoll(playerPed, 6000, 6000, 0, 0, 0, 0)
end

function SendNotification(message)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(message)
    DrawNotification(false, false)
end

function ResPlayer()
    isRes = true
    TriggerServerEvent('es_em:sv_removeMoney')
    TriggerServerEvent("item:reset")
    TriggerServerEvent("skin_customization:SpawnPlayer")
    TriggerServerEvent('gabs:setdefaultneeds')
    RemoveAllPedWeapons(GetPlayerPed(-1),true)
    NetworkResurrectLocalPlayer(357.757, -597.202, 28.6314, true, true, false)
    SetNotificationTextEntry("STRING")
    AddTextComponentString("Vous venez de sortir du ~y~coma")
    SetNotificationMessage("CHAR_CALL911", "CHAR_CALL911", true, 1, "CHU de ~r~Los Santos", "")
    DrawNotification(false, true);
end

function OnPlayerDied(playerId, reasonID, reason)
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local isDocConnected = nil

    TriggerServerEvent('es_em:sv_getDocConnected')
    

    Citizen.CreateThread(
        function()
            while isDocConnected == nil do
                Citizen.Wait(1)

                RegisterNetEvent('es_em:cl_getDocConnected')
                AddEventHandler('es_em:cl_getDocConnected',
                    function(cb)
                        isDocConnected = cb
                        if isDocConnected then
                            SendNotification(txt[lang]['callAmb'])
                        end
                    end
                )
            end
        end
    )

    SendNotification(txt[lang]['respawn'])

    Citizen.CreateThread(
        function()
            local emergencyCalled = false
            local notifReceivedAt = nil

            while not isRes do
                Citizen.Wait(1)

                if (IsControlJustReleased(1, Keys['E'])) and not emergencyCalled then
                    if not isDocConnected then
                        ResPlayer()
                    else
                        notifReceivedAt = GetGameTimer()
                        SendNotification(txt[lang]['youCallAmb'])
                        TriggerServerEvent('es_em:sendEmergency', reason, GetPlayerServerId(PlayerId()), pos.x, pos.y, pos.z)
                    end

                    emergencyCalled = true
                elseif (IsControlJustReleased(1, Keys['X'])) then
                    ResPlayer()
                end

                if (GetTimeDifference(GetGameTimer(), notifReceivedAt) > 15000) and not emergencyComes and emergencyCalled then
                    SendNotification(txt[lang]['callAmb'])
                    emergencyCalled = false
                end

            end

            isDocConnected = nil
            isRes = false
            emergencyComes = false
        end)
end

--[[
################################
        USEFUL METHODS
################################
--]]