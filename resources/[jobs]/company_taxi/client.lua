-- GITHUB.COM/XCHOPIN - DO NOT REMOVE
local jobCible = 22

local vestiaire = {x=973.556, y=-1936.77 , z=32.22253}
local garage = {x=912.552795410156, y=-169.257705688477 , z=74.2734146118164}


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
        ['getService'] = 'Appuyez sur ~g~E~s~ pour enfiler votre tenue.',
        ['dropService'] = 'Appuyez sur ~g~E~s~ pour terminer votre journée',
        ['getAmbulance'] = 'Appuyez sur ~g~E~s~ pour obtenir un véhicule',
        ['callTaken'] = 'L\'appel a été pris par ~b~',
        ['emergency'] = '<b>~r~URGENCE~s~ <br><br>~b~Raison~s~: </b>',
        ['takeCall'] = '<b>Appuyez sur ~g~Y~s~ pour prendre l\'appel</b>',
        ['callExpires'] = '<b>~r~URGENCE~s~ <br><br>Attention, l\'appel précèdent a expiré !</b>',
        ['gps'] = 'Un point a été placé sur votre GPS là où se trouve la victime en détresse',
        ['res'] = 'Appuyez sur ~g~E~s~ pour réanimer le joueur',
        ['notDoc'] = 'Vous n\'êtes pas chauffeur taxi',
        ['stopService'] = 'Vous n\'êtes plus en service',
        ['startService'] = 'Début du service'
  }
}

local isInService = false
local jobId = -1
local notificationInProgress = false


--[[
################################
            THREADS
################################
--]]


-- PRISE DE SERVICE

-- GARAGE
Citizen.CreateThread(
    function()
        local blip = true
        if blip == true then
            setBlip(garage, "Los Santos Taxis", 198, 73)
            blip = false
        end 

        while true do
            Citizen.Wait(1)
            local playerPos = GetEntityCoords(GetPlayerPed(-1), true)
          
            	if (Vdist(playerPos.x, playerPos.y, playerPos.z, garage.x, garage.y, garage.z) < 100.0) then
            	    -- Service car
            	    DrawMarker(1, garage.x, garage.y, garage.z - 1, 0, 0, 0, 0, 0, 0, 3.0001, 3.0001, 1.5001, 255, 165, 0,165, 0, 0, 0,0)
            	    if (Vdist(playerPos.x, playerPos.y, playerPos.z, garage.x, garage.y, garage.z) < 2.0) then
            	        DisplayHelpText(txt[lang]['getAmbulance'])
            	        if (IsControlJustReleased(1, 51)) then
                            TriggerServerEvent('taxi:sv_getJobId')
                            Wait(120)
                            if jobId == jobCible then
            	                SpawnVehicle()
                            else
                                SendNotification(txt[lang]['notDoc'])
                            end
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



RegisterNetEvent('taxi:cl_setJobId')
AddEventHandler('taxi:cl_setJobId',
    function(p_jobId)
        jobId = p_jobId
      --  GetService()
    end
)

--[[
################################
        BUSINESS METHODS
################################
--]]


function setBlip(coord, name, blipId, color)

        local loc = pos
        local blip = AddBlipForCoord(coord.x, coord.y, coord.z)
        SetBlipSprite(blip, blipId)
        SetBlipColour(blip, color)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(name)
        EndTextCommandSetBlipName(blip)
        SetBlipAsShortRange(blip,true)
        SetBlipAsMissionCreatorBlip(blip,true)

end

function SpawnVehicle()
    Citizen.Wait(0)
    local myPed = GetPlayerPed(-1)
    local player = PlayerId()
    local vehicle = GetHashKey('taxi')

    RequestModel(vehicle)

    while not HasModelLoaded(vehicle) do
        Citizen.Wait(1)
    end

    local plate = math.random(100, 900)
    local coords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 5.0, 0)
    local spawned_car = CreateVehicle(vehicle, coords, garage.x, garage.y, garage.z, true, false)

    SetVehicleOnGroundProperly(spawned_car)
    SetVehicleNumberPlateText(spawned_car, "taxi")
    SetPedIntoVehicle(myPed, spawned_car, - 1)
    SetModelAsNoLongerNeeded(vehicle)
    Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(spawned_car))
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

-- GITHUB.COM/XCHOPIN - DO NOT REMOVE