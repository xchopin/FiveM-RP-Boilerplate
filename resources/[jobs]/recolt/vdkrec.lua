--Variables
local recoltDistance = 10
local timeForRecolt = 4000 --1000 for 1 second
--

local near
local jobId
JOBS = {}
local id_job = -1

RegisterNetEvent("jobs:getJobs")
RegisterNetEvent("cli:getJobs")

AddEventHandler("playerSpawned", function()
    TriggerServerEvent("jobs:getJobs")
    TriggerServerEvent('recolte:sv_getJobId')
end)

-- Get the list of all jobs in the database and create the blip associated
AddEventHandler("cli:getJobs", function(listJobs)
    JOBS = listJobs
end)

-- Control if the player of is near of a place of job
function IsNear()
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)
    if(IsPedInAnyVehicle(ply, true) == false) then
        for k, item in ipairs(JOBS) do
            local distance_field = GetDistanceBetweenCoords(item.fx, item.fy, item.fz, plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
            local distance_treatment = GetDistanceBetweenCoords(item.tx, item.ty, item.tz, plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
            local distance_seller = GetDistanceBetweenCoords(item.sx, item.sy, item.sz, plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
            if (distance_field <= recoltDistance) then
                jobId = k
                return 'field'
            elseif (distance_treatment <= recoltDistance) then
                jobId = k
                return 'treatment'
            elseif (distance_seller <= recoltDistance) then
                jobId = k
                return 'seller'
            end
        end
    end
end

-- Display the message of recolting/treating/selling and trigger the associated event(s)
function recolt(text, rl)
    	if (text == 'Récolte') then
    	    TriggerEvent("mt:missiontext", text .. ' en cours de ~g~' .. tostring(JOBS[jobId].raw_item) .. '~s~...', timeForRecolt - 800)
    	    Citizen.Wait(timeForRecolt - 800)
    	    TriggerEvent("player:receiveItem", tonumber(JOBS[jobId].raw_id), 1)
    	    TriggerEvent("mt:missiontext", rl .. ' ~g~' .. tostring(JOBS[jobId].raw_item) .. '~s~...', 800)
    	elseif (text == 'Traitement') then
    	    TriggerEvent("mt:missiontext", text .. ' en cours de ~g~' .. tostring(JOBS[jobId].raw_item) .. '~s~...', timeForRecolt - 800)
    	    Citizen.Wait(timeForRecolt - 800)
    	    TriggerEvent("player:looseItem", tonumber(JOBS[jobId].raw_id), 1)
    	    TriggerEvent("player:receiveItem", tonumber(JOBS[jobId].treat_id), 1)
    	    TriggerEvent("mt:missiontext", rl .. ' ~g~' .. tostring(JOBS[jobId].treat_item) .. '~s~...', 800)
    	elseif (text == 'Vente') then
    	    TriggerEvent("mt:missiontext", text .. ' en cours de ~g~' .. tostring(JOBS[jobId].treat_item) .. '~s~...', timeForRecolt - 800)
    	    Citizen.Wait(timeForRecolt - 800)
    	    TriggerEvent("player:sellItem", tonumber(JOBS[jobId].treat_id), tonumber(JOBS[jobId].price), tonumber(JOBS[jobId].isIllegal))
    	    TriggerEvent("mt:missiontext", rl .. ' ~g~' .. tostring(JOBS[jobId].treat_item) .. '~s~...', 800)
    	end
    	Citizen.Wait(800)
end

function setBlip(x, y, z, num)
    local blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip, tonumber(num))
    SetBlipAsShortRange(blip, true)
end

function IdentifyJob()
	Citizen.Wait(2000)
	TriggerServerEvent('recolte:sv_getJobId')
	return id_job
end

RegisterNetEvent('recolte:cl_setJobId')
AddEventHandler('recolte:cl_setJobId',
    function(p_jobId)
        id_job = p_jobId
    end
)

-- Constantly check the position of the player
Citizen.CreateThread(function()
    Citizen.Wait(4000)
    while true do
        near = IsNear()
            if (exports.personnal_menu:notFull() == true) then
                if (near == 'field') then
                    if (tonumber(JOBS[jobId].job_id) ~= id_job and tonumber(JOBS[jobId].job_id) ~= 1) then
          			  IdentifyJob()
          			else 
          				recolt('Récolte', '+1')
          			end	
                elseif (near == 'treatment' and exports.personnal_menu:getQuantity(JOBS[jobId].raw_id) > 0) then
                   	if (tonumber(JOBS[jobId].job_id) ~= id_job and tonumber(JOBS[jobId].job_id) ~= 1) then
          			  IdentifyJob()
          			else
          				recolt('Traitement', '+1')
          			end
                elseif (near == 'seller' and exports.personnal_menu:getQuantity(JOBS[jobId].treat_id) > 0) then
                   	if (tonumber(JOBS[jobId].job_id) ~= id_job and tonumber(JOBS[jobId].job_id) ~= 1) then
          			    IdentifyJob()
          			else
          				recolt('Vente', '-1')
          			end
                end
            else
                if (near == 'field') then
                	if (tonumber(JOBS[jobId].job_id) ~= id_job and tonumber(JOBS[jobId].job_id) ~= 1) then
          			    IdentifyJob()
          			else
          				TriggerEvent("mt:missiontext","~r~ Inventaire plein ! ", 200)
          			end
                elseif (near == 'treatment' and exports.personnal_menu:getQuantity(JOBS[jobId].raw_id) > 0) then
                    if (tonumber(JOBS[jobId].job_id) ~= id_job and tonumber(JOBS[jobId].job_id) ~= 1) then
          			    IdentifyJob()
          			else
          				recolt('Traitement', '+1')
          			end
                elseif (near == 'seller' and exports.personnal_menu:getQuantity(JOBS[jobId].treat_id) > 0) then
                	if (tonumber(JOBS[jobId].job_id) ~= id_job and tonumber(JOBS[jobId].job_id) ~= 1) then
          			    IdentifyJob()
          			else
          				recolt('Vente', '-1')
          			end
                end
            end
    Citizen.Wait(50)
    end
end)



function Chat(debugg)
    TriggerEvent("chatMessage", '', { 0, 0x99, 255 }, tostring(debugg))
end