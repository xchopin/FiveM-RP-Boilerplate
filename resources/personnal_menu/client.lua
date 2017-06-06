-- GITHUB.COM/XCHOPIN - DO NOT REMOVE

local firstspawn = 0
local jobId = -1

AddEventHandler('playerSpawned', function(spawn)
    if firstspawn == 0 then
        TriggerServerEvent("pm:spawnPlayer")
        firstspawn = 1
    end
end)


local options = {
    x = 0.1,
    y = 0.2,
    width = 0.2,
    height = 0.04,
    scale = 0.4,
    font = 0,
    menu_title = "Menu personnel",
    menu_subtitle = "Categories",
    color_r = 192,
    color_g = 57,
    color_b = 43,
}


------------------------------------------------------------------------------------------------------------------------

-- Base du menu
function PersonnalMenu()
    ped = GetPlayerPed(-1);
    ClearMenu()
    Menu.addButton("Animations", "animsMenu", nil)
    Menu.addButton("Telephone", "phoneMenu", nil)
    Menu.addButton("Inventaire", "inventoryMenu", nil)
    Menu.addButton("Gestion des accessoires", "accessoriesMenu", nil)
    Menu.addButton("Carte d'identité", "showCardMenu", nil)
    --Menu.addButton("Montrer sa carte d'identité (Prochainement)", "myCardMenu", nil)
    Menu.addButton("Donner de l'argent", "moneyGive", nil)
end

------------------------------------------------------------------------------------------------------------------------

NUMBERS_LIST = {}
OLDS_MSG = {}
AddEventHandler("playerSpawned", function()
    TriggerServerEvent("pm:repertoryGetNumberList")
    TriggerServerEvent("pm:messageryGetOldMsg")
end)

Citizen.CreateThread(function()
    while true do
        Wait(10000)
        TriggerServerEvent("pm:messageryGetOldMsg")
    end
end)

-- handles when a player spawns either from joining or after death
RegisterNetEvent("pm:repertoryGetNumberListFromServer")
AddEventHandler("pm:repertoryGetNumberListFromServer", function(NUMBERSLIST)
    NUMBERS_LIST = {}
    NUMBERS_LIST = NUMBERSLIST
end)


-- handles when a player spawns either from joining or after death
RegisterNetEvent("pm:notifs")
AddEventHandler("pm:notifs", function(msg)
    notifs(msg)
   -- messagesRight("null")
end)

function notifs(msg)
    SetNotificationTextEntry("STRING")
    AddTextComponentString( msg )
    DrawNotification(false, false)
end



function messagesRight(msg)
    SetTextFont(2)
    SetTextProportional(0)
    SetTextScale(0.5, 0.5)
    SetTextColour(255, 255, 255, 255)
    SetTextCentre(0)
    SetTextEntry("STRING")
    AddTextComponentString("Nouveau Message")
    DrawRect(0.11,0.25,0.2,0.04,0,0,0,150)
    DrawText(0.11 - 0.2/2 + 0.03, 0.25 - 0.04/2 + 0.0028)

    SetTextFont(2)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(centre)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x , y)


    Wait(6500)
end

-- handles when a player spawns either from joining or after death
RegisterNetEvent("pm:messageryGetOldMsgFromServer")
AddEventHandler("pm:messageryGetOldMsgFromServer", function(OLDSMSG)
    OLDS_MSG = {}
    OLDS_MSG = OLDSMSG
end)

-- Menu du téléphone

function phoneMenu()
    options.menu_subtitle = "Telephone"
    ClearMenu()
    Menu.addButton("Ajouter un numero", "newNumero", nil )
    Menu.addButton("Repertoire", "repertoryMenu", nil )
    Menu.addButton("Messages reçus", "messageryMenu", nil )
    Menu.addButton("Urgence 911", "callPolice", nil )
    Menu.addButton("Appeler un taxi", "callTaxi", nil )
    Menu.addButton("Prendre une photo", "takePhoto", nil )
    Menu.addButton("Retour", "PersonnalMenu", nil )
end

function showCardMenu()
    TriggerServerEvent("pm:checkIdentity")
end


function newNumero()
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 10)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
        TriggerServerEvent("pm:addNewNumero", result)
        phoneMenu()
    end
end

function repertoryMenu()
    options.menu_subtitle = "Repertoire"
    ClearMenu()
    -- Menu.addButton("Appeler la police", "callPolice")
    for ind, value in pairs(NUMBERS_LIST) do
        Menu.addButton(value.name, "repertoryContact", value.identifier)
    end
    Menu.addButton("Retour", "phoneMenu", nil )
end




function callPolice()
    local plyPos = GetEntityCoords(GetPlayerPed(-1), true)
    TriggerServerEvent("call:makeCall", "police", {x=plyPos.x,y=plyPos.y,z=plyPos.z})
end

function callTaxi()
    local plyPos = GetEntityCoords(GetPlayerPed(-1), true)
    TriggerServerEvent("call:makeCall", "taxi", {x=plyPos.x,y=plyPos.y,z=plyPos.z})
end


function repertoryContact(contact)
    options.menu_subtitle = "Repertoire"
    ClearMenu()
    Menu.addButton("Afficher le numéro", "checkContact", contact )
    Menu.addButton("Envoyer un message", "writeMsg", contact )
    Menu.addButton("Retour", "phoneMenu", nil )

end

function checkContact(contact)
    TriggerServerEvent("pm:checkContactServer", {identifier = contact})
end

function writeMsg(receiver)

    DisplayOnscreenKeyboard(6, "FMMC_KEY_TIP8", "(120 characters max)", "", "", "", "", 120)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
        local msg = {
            receiver = receiver,
            msg = result
        }
        TriggerServerEvent("pm:sendNewMsg", msg)

        phoneMenu()
    end
end

RegisterNetEvent('pm:signalNotif')
AddEventHandler('pm:signalNotif',
    function(receiverId, name, message)
        TriggerServerEvent("pm:accuseReception", receiverId, name, message)
    end
)

function messageryMenu()
    options.menu_subtitle = "Messagerie"
    ClearMenu()
    for ind, value in pairs(OLDS_MSG) do
        local n = ""
        if value.has_read == 0 then
            n = " - ~r~Non lu"
            notifs("~o~ Vous avez des nouveaux message non lus !")
        end
        Menu.addButton(value.name .. " " .. n, "readOldMsg", {msg = value.msg, name = value.name, date= value.date, has_read = value.has_read, receiver_id = value.receiver_id})
    end
    Menu.addButton("Retour", "phoneMenu", nil )
end

function readOldMsg(msg)
    if msg.has_read == 0 then
        TriggerServerEvent("pm:setMsgReaded", msg)
    end
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg.msg)
    SetNotificationMessage("CHAR_DEFAULT", "CHAR_DEFAULT", true, 1, msg.name , "Le ("..tostring(msg.date)..")" , "Message reçu")
    DrawNotification(false, true)
    messageryMenu()
end

function takePhoto()
    RequestAnimDict( "cellphone@" )
    while not HasAnimDictLoaded( "cellphone@" ) do
        Citizen.Wait(0)
    end
    if HasAnimDictLoaded( "cellphone@" ) then
        TaskPlayAnim( PlayerPedId(), "cellphone@" , "cellphone_photo_idle" ,8.0, -8.0, -1, 0, 0, false, false, false )
    end
end

------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsPedUsingAnyScenario(GetPlayerPed(-1)) then
            if IsControlJustPressed(1, 34) or IsControlJustPressed(1, 32) or IsControlJustPressed(1, 8) or IsControlJustPressed(1, 9) then
                ClearPedTasks(GetPlayerPed(-1))
            end
        end

    end
end)

-- Menu des animations
function animsMenu()
    options.menu_subtitle = "Animations"
    ClearMenu()
    Menu.addButton("Lever les bras", "animsAction", { lib = "ped", anim = "handsup" })
    Menu.addButton("Saluer", "animsSalute", nil)
    Menu.addButton("Humeur", "animsHumor", nil)
    Menu.addButton("Sportives", "animsSportives",nil)
    Menu.addButton("Festives", "animsFestives",nil)
    Menu.addButton("Autres", "animsOthers", nil)
    --Menu.addButton("Placer obj test", "animsWithModelsSpawn", {object = "prop_roadcone02c"})
    Menu.addButton("Retour","PersonnalMenu",nil)
end

function animsSportives()
    options.menu_subtitle = "Animations  Sportives"
    ClearMenu()
    Menu.addButton("Faire du Yoga", "animsActionScenario", { anim = "WORLD_HUMAN_YOGA" })
    Menu.addButton("Jogging", "animsActionScenario", { anim = "WORLD_HUMAN_JOG_STANDING" })
    Menu.addButton("Faire des pompes", "animsActionScenario", { anim = "WORLD_HUMAN_PUSH_UPS" })
    Menu.addButton("Retour","animsMenu",nil)
end

function animsFestives()
    options.menu_subtitle = "Animations  Festives"
    ClearMenu()
    Menu.addButton("Boire une biere", "animsActionScenario", { anim = "WORLD_HUMAN_DRINKING" })
    Menu.addButton("Pres du feu", "animsActionScenario", { anim = "WORLD_HUMAN_STAND_FIRE" })
    Menu.addButton("Jouer de la musique", "animsActionScenario", {anim = "WORLD_HUMAN_MUSICIAN" })
    Menu.addButton("Retour","animsMenu",nil)
end

function animsSalute()
    options.menu_subtitle = "Animations  Saluer"
    ClearMenu()
    Menu.addButton("Serrer la main", "animsAction", { lib = "mp_common", anim = "givetake1_a" })
    Menu.addButton("Dire bonjour", "animsAction", { lib = "gestures@m@standing@casual", anim = "gesture_hello" })
    Menu.addButton("Tappes moi en 5", "animsAction", { lib = "mp_ped_interaction", anim = "highfive_guy_a" })
    Menu.addButton("Salut militaire", "animsAction", { lib = "mp_player_int_uppersalute", anim = "mp_player_int_salute" })
    Menu.addButton("Retour","animsMenu",nil)
end

function animsHumor()
    options.menu_subtitle = "Animations  Humeur"
    ClearMenu()
    Menu.addButton("Feliciter", "animsActionScenario", {anim = "WORLD_HUMAN_CHEERING" })
    Menu.addButton("Branleur", "animsAction", { lib = "mp_player_int_upperwank", anim = "mp_player_int_wank_01" })
    Menu.addButton("Dammed ", "animsAction", { lib = "gestures@m@standing@casual", anim = "gesture_damn" })
    Menu.addButton("Calme toi ", "animsAction", { lib = "gestures@m@standing@casual", anim = "gesture_easy_now" })
    Menu.addButton("No way", "animsAction", { lib = "gestures@m@standing@casual", anim = "gesture_no_way" })
    Menu.addButton("Fuck", "animsAction", { lib = "mp_player_int_upperfinger", anim = "mp_player_int_finger_01_enter" })
    Menu.addButton("Doigt d'honneur", "animsAction", { lib = "mp_player_int_upperfinger", anim = "mp_player_int_finger_01_enter" })
    Menu.addButton("Balle dans la tete", "animsAction", { lib = "mp_suicide", anim = "pistol" })
    Menu.addButton("Super", "animsAction", { lib = "mp_action", anim = "thanks_male_06" })
    Menu.addButton("Enlacer", "animsAction", { lib = "mp_ped_interaction", anim = "kisses_guy_a" })
    Menu.addButton("Retour","animsMenu",nil)
end

function animsOthers()
    options.menu_subtitle = "Animations  Autres"
    ClearMenu()
    Menu.addButton("Crocheter", "animsActionScenario", { anim = "WORLD_HUMAN_WELDING" })
    Menu.addButton("Prendre des notes", "animsActionScenario", { anim = "WORLD_HUMAN_CLIPBOARD" })
    Menu.addButton("S'assoir", "animsActionScenario", { anim = "WORLD_HUMAN_PICNIC" })
    Menu.addButton("Fumer une clope", "animsActionScenario", { anim = "WORLD_HUMAN_SMOKING" })
    -- Menu.addButton("Reparer le moteur", "animsAction", { lib = "amb@world_human_vehicle_mechanic@male@idle_a", anim = "WORLD_HUMAN_VEHICLE_MECHANIC" })
    Menu.addButton("Se gratter les bijoux de famille", "animsAction", { lib = "mp_player_int_uppergrab_crotch", anim = "mp_player_int_grab_crotch" })
    Menu.addButton("Rock and Roll", "animsAction", { lib = "mp_player_int_upperrock", anim = "mp_player_int_rock" })
    Menu.addButton("Retour","animsMenu",nil)

end

function animsAction(animObj)
    RequestAnimDict( animObj.lib )
    while not HasAnimDictLoaded( animObj.lib ) do
        Citizen.Wait(0)
    end
    if HasAnimDictLoaded( animObj.lib ) then
        TaskPlayAnim( GetPlayerPed(-1), animObj.lib , animObj.anim ,8.0, -8.0, -1, 0, 0, false, false, false )
    end
end

function animsActionScenario(animObj)
    local ped = GetPlayerPed(-1);

    if ped then
        local pos = GetEntityCoords(ped);
        local head = GetEntityHeading(ped);
        --TaskStartScenarioAtPosition(ped, animObj.anim, pos['x'], pos['y'], pos['z'] - 1, head, -1, false, false);
        TaskStartScenarioInPlace(ped, animObj.anim, 0, false)
        if IsControlJustPressed(1,188) then
        end

    end
end

function animsWithModelsSpawn(object)

    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))

    RequestModel(object.object)
    while not HasModelLoaded(object.object) do
        Wait(1)
    end

    local object = CreateObject(object.object, x, y+2, z, true, true, true)
    -- local vX, vY, vZ = table.unpack(GetEntityCoords(object,  true))

    -- AttachEntityToEntity(object, PlayerId(), GetPedBoneIndex(PlayerId()), vX,  vY,  vZ, -90.0, 0, -90.0, true, true, true, false, 0, true)
    PlaceObjectOnGroundProperly(object) -- This function doesn't seem to work.

end

------------------------------------------------------------------------------------------------------------------------

-- register events, only needs to be done once
RegisterNetEvent("item:reset")
RegisterNetEvent("item:getItems")
RegisterNetEvent("item:updateQuantity")
RegisterNetEvent("item:setItem")
RegisterNetEvent("item:sell")
RegisterNetEvent("gui:getItems")
RegisterNetEvent("player:receiveItem")
RegisterNetEvent("player:looseItem")
RegisterNetEvent("player:sellItem")
RegisterNetEvent("player:getMoney_client")
RegisterNetEvent("player:giveMoney_client")


ITEMS = {}
local playerdead = false
local maxCapacity = 35

-- handles when a player spawns either from joining or after death
AddEventHandler("playerSpawned", function()
    TriggerServerEvent("item:getItems")
    -- reset player dead flag
    playerdead = false
end)



AddEventHandler("player:getMoney_client", function(qty)
    print("QUANTITE" .. qty)
    TriggerServerEvent("money:giveTo", qty)
end)

AddEventHandler("player:giveMoney_client", function(qty)
    TriggerServerEvent("money:hasGiven", qty)
end)



AddEventHandler("gui:getItems", function(THEITEMS)
    ITEMS = {}
    ITEMS = THEITEMS
end)

AddEventHandler("player:receiveItem", function(item, quantity)
    if (inventoryGetPods() + quantity <= maxCapacity) then
        item = tonumber(item)
        if (ITEMS[item] == nil) then
            inventoryNew(item, quantity)
        else
            inventoryAdd({ item, quantity })
        end
    end
end)

AddEventHandler("player:looseItem", function(item, quantity)
    item = tonumber(item)
    if (ITEMS[item].quantity >= quantity) then
        inventoryDelete({ item, quantity })
    end
end)

AddEventHandler("player:sellItem", function(item, price, isIllegal)
    item = tonumber(item)
    if (ITEMS[item].quantity > 0) then
        inventorySell({ item, price, isIllegal })
    end
end)

-- Menu de l'inventaire
function inventoryMenu()
    ped = GetPlayerPed(-1);
    options.menu_subtitle = "Objets  "
    options.rightText = (inventoryGetPods() or 0) .. "/" .. maxCapacity
    ClearMenu()
    for ind, value in pairs(ITEMS) do
        if (value.quantity > 0) then
            Menu.addButton(tostring(value.quantity) .. " " ..tostring(value.libelle), "inventoryItemMenu", ind)
        end
    end
    Menu.addButton("Retour", "PersonnalMenu", ind)
end

function inventoryItemMenu(itemId)
    ClearMenu()
    options.menu_subtitle = "Details "
    Menu.addButton("Donner", "inventoryGive", itemId)
    Menu.addButton("Consommer", "eatvdk", { itemId, 1 })
    Menu.addButton("Supprimer", "inventoryDelete", { itemId, 1 })
    Menu.addButton("Retour","inventoryMenu", nil)
end

function moneyGive()
  joueur = GetNearPlayer(2) -- FR -- La valeur 2 veut dire 2 mètre de périmètre -- EN -- If the player has as a job number 2 (Font in this case), displays a button to access the font menu
  joueur_proche = GetPlayerServerId(joueur)
  if joueur_proche == 0 then
    Notify("Personne à proximité !")
  else
   		DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 64)
   		while (UpdateOnscreenKeyboard() == 0) do
   		    DisableAllControlActions(0);
   		    Wait(0);
   		end
   		if (GetOnscreenKeyboardResult() ~= nil) then
   		    local result = GetOnscreenKeyboardResult()
   		    TriggerServerEvent("bank:donnerargent", joueur_proche, tonumber(result))
   		end
   end
end


function GetNearPlayer(distance)
  local players = GetPlayers()
  local nearPlayerDistance = distance or -1
  local nearPlayer = -1
  local playerCd = GetEntityCoords(GetPlayerPed(-1), 0)
  for i,v in ipairs(players) do
    local target = GetPlayerPed(v)
    if(target ~= GetPlayerPed(-1)) then
      local targetCoords = GetEntityCoords(GetPlayerPed(v), 0)
      local distance = GetDistanceBetweenCoords(targetCoords["x"], targetCoords["y"], targetCoords["z"], playerCd["x"], playerCd["y"], playerCd["z"], true)
      if(nearPlayerDistance == -1 or nearPlayerDistance > distance) then
        nearPlayer = v
      end
    end
  end
  return nearPlayer
end


-- FR -- Fonction : Récupère l'ID de tout les joueurs actifs
-- FR -- Paramètre(s) : Aucun
---------------------------------------------------------
-- EN -- Function : Get All ID Player Active
-- EN -- Param(s) : None
function GetPlayers()
    local players = {}
    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end
    return players
end


function inventoryGive(item)
        local player = getNearPlayer()
        if (player ~= nil) then
                DisplayOnscreenKeyboard(1, "Quantité :", "", "", "", "", "", 2)
                while (UpdateOnscreenKeyboard() == 0) do
                        DisableAllControlActions(0);
                        Wait(0);
                end
                if (GetOnscreenKeyboardResult()) then
                    local res = tonumber(GetOnscreenKeyboardResult())
                    if (ITEMS[item].quantity - res >= 0) then
                        TriggerServerEvent("player:giveItem", item, ITEMS[item].libelle, res, GetPlayerServerId(player))
                    end
                end
        end
end

function inventorySell(arg)
local itemId = tonumber(arg[1])
local price = arg[2]
local isIllegal = arg[3]
local item = ITEMS[itemId]
item.quantity = item.quantity - 1
TriggerServerEvent("item:sell", itemId, item.quantity, price, isIllegal)
-- inventoryMenu()
end

function inventoryDelete(arg)
local itemId = tonumber(arg[1])
local qty = arg[2]
local item = ITEMS[itemId]
item.quantity = item.quantity - qty
TriggerServerEvent("item:updateQuantity", item.quantity, itemId)
inventoryMenu()
end

function drawNotification(text)
SetNotificationTextEntry("STRING")
AddTextComponentString(text)
DrawNotification(false, false)
end

function eatvdk(arg)
local itemId = tonumber(arg[1])
local qty = arg[2]
local item = ITEMS[itemId]

if (itemId == 30 or itemId == 31 or itemId == 34) then
item.quantity = item.quantity - qty
TriggerServerEvent("gabs:eatvdkitem", item.quantity, itemId)
drawNotification("En train de ~y~consommer")
else
drawNotification("~r~Les objets ne se mangent pas !")
end
inventoryMenu()
end


function inventoryAdd(arg)
if (arg ~= nil) then
local itemId = tonumber(arg[1])
local qty = arg[2]
local item = ITEMS[itemId]
item.quantity = item.quantity + qty
TriggerServerEvent("item:updateQuantity", item.quantity, itemId)
--InventoryMenu()
end
end

function inventoryNew(item, quantity)
TriggerServerEvent("item:setItem", item, quantity)
TriggerServerEvent("item:getItems")
end

function inventoryGetQuantity(itemId)
return ITEMS[tonumber(itemId)].quantity
end

function getQuantity(itemId)
return ITEMS[tonumber(itemId)].quantity
end


function inventoryGetPods()
local pods = 0
for _, v in pairs(ITEMS) do
pods = pods + v.quantity
end
return pods
end

function notFull()
if (inventoryGetPods() < maxCapacity) then return true end
end

function PlayerIsDead()
-- do not run if already ran
if playerdead then
return
end
TriggerServerEvent("item:reset")
end

function getPlayers()
local playerList = {}
for i = 0, 32 do
local player = GetPlayerFromServerId(i)
if NetworkIsPlayerActive(player) then
table.insert(playerList, player)
end
end
return playerList
end

function getNearPlayer()
        local players = getPlayers()
        local pos = GetEntityCoords(GetPlayerPed(-1))
        local pos2
        local distance
        local minDistance = 3
        local playerNear
        for _, player in pairs(players) do
        pos2 = GetEntityCoords(GetPlayerPed(player))
        distance = GetDistanceBetweenCoords(pos["x"], pos["y"], pos["z"], pos2["x"], pos2["y"], pos2["z"], true)
        if (pos ~= pos2 and distance < minDistance) then
        playerNear = player
        minDistance = distance
        end
        end
        if (minDistance < 3) then
        return playerNear
        end
end




------------------------------------------------------------------------------------------------------------------------
wearingHat = true
wearingGlasses = true
wearingPercing = true
wearingMask = true
-- Menu Accessoires
function accessoriesMenu()
options.menu_subtitle = "Accessoires"
ClearMenu()
Menu.addButton("Porter/Retirer son chapeau", "accessoriesWearHatChecker")
Menu.addButton("Porter/Retirer ses lunettes", "accessoriesWearGlassesChecker")
Menu.addButton("Porter/Retirer son accessoire (oreilles)", "accessoriesWearPercingChecker")
Menu.addButton("Porter/Retirer son masque", "accessoriesWearMaskChecker")
Menu.addButton("Retour","PersonnalMenu",nil)
end

RegisterNetEvent("pm:accessoriesWearHat")
AddEventHandler("pm:accessoriesWearHat", function(item)
SetPedPropIndex(GetPlayerPed(-1), 0, item.hat,item.hat_texture, 0)
end)
function accessoriesWearHatChecker()
if wearingHat then
wearingHat = false
ClearPedProp(GetPlayerPed(-1),0)
else
wearingHat = true
TriggerServerEvent("pm:wearHat")
end

end

RegisterNetEvent("pm:accessoriesWearPercing")
AddEventHandler("pm:accessoriesWearPercing", function(item)
SetPedPropIndex(GetPlayerPed(-1), 2, item.ears,item.ears_texture, 0)
end)
function accessoriesWearPercingChecker()
if wearingGlasses then
wearingGlasses = false
ClearPedProp(GetPlayerPed(-1),2)
else
wearingGlasses = true
TriggerServerEvent("pm:wearPercing")
end

end

RegisterNetEvent("pm:accessoriesWearGlasses")
AddEventHandler("pm:accessoriesWearGlasses", function(item)
SetPedPropIndex(GetPlayerPed(-1), 1, item.glasses,item.glasses_texture, 0)
end)
function accessoriesWearGlassesChecker()
if wearingPercing then
wearingPercing = false
ClearPedProp(GetPlayerPed(-1),1)
else
wearingPercing = true
TriggerServerEvent("pm:wearGlasses")
end

end

RegisterNetEvent("pm:accessoriesWearMask")
AddEventHandler("pm:accessoriesWearMask", function(item)
SetPedComponentVariation(GetPlayerPed(-1), 1, item.mask,item.mask_texture, 0)
end)
function accessoriesWearMaskChecker()
if wearingMask then
wearingMask = false
SetPedComponentVariation(GetPlayerPed(-1), 1, 0, 0)
else
wearingMask = true
TriggerServerEvent("pm:wearMask")
end

end

------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
while true do
Citizen.Wait(0)
if IsControlJustPressed(1, 311) then
PersonnalMenu() -- Menu to draw
Menu.hidden = not Menu.hidden -- Hide/Show the menu
end
Menu.renderGUI(options) -- Draw menu on each tick if Menu.hidden = false
if IsEntityDead(PlayerPedId()) then
PlayerIsDead()
-- prevent the death check from overloading the server
playerdead = true
end
end
end)

------------------------------------------------------------------------------------------------------------------------
