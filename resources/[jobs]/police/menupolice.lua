-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------COPS MENU---------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
local menupolice = {
    opened = false,
    title = "Menu policier",
    currentmenu = "main",
    lastmenu = nil,
    currentpos = nil,
    selectedbutton = 0,
    marker = { r = 0, g = 155, b = 255, a = 200, type = 1 },
    menu = {
        x = 0.11,
        y = 0.25,
        width = 0.2,
        height = 0.04,
        buttons = 10,
        from = 1,
        to = 10,
        scale = 0.4,
        font = 0,
        ["main"] = {
            title = "CATEGORIES",
            name = "main",
            buttons = {
                {name = "Animations", description = ""},
                {name = "Actions sur civils", description = ""},
                {name = "Actions sur véhicules", description = ""},
                --{name = "Call for backup(SOON)", description = ""},
                --{name = "Radar Speed Detector(SOON)", description = ""},
                {name = "Fermer le menu", description = ""},
            }
        },
        ["Animations"] = {
            title = "ANIMATIONS",
            name = "Animations",
            buttons = {
                {name = "Faire la circulation", description = ''},
                {name = "Prendre des notes", description = ''},
                {name = "Fumer", description = ''},
                {name = "Faire la garde", description = ''},
                {name = "Faire la garde 2", description = ''},
            }
        },
        ["Actions sur civils"] = {
            title = "Actions sur citoyens",
            name = "Actions sur civils",
            buttons = {
                --{name = "ID Card(SOON)", description = ''},
                {name = "Fouiller", description = ''},
                {name = "Menotter/Démenotter", description = ''},
                {name = "Confisquer argent sale", description = ''},
                {name = "Mettre dans le véhicule", description = ''},
                {name = "Sortir du véhicule", description = ''},
                {name = "Amendes", description = ''},
            }
        },
        ["Amendes"] = {
            title = "Amendes",
            name = "Amendes",
            buttons = {
                {name = "$250", description = ''},
                {name = "$500", description = ''},
                {name = "$1000", description = ''},
                {name = "$1500", description = ''},
                {name = "$2000", description = ''},
                {name = "$4000", description = ''},
                {name = "$6000", description = ''},
                {name = "$8000", description = ''},
                {name = "$10000", description = ''},
                {name = "$11000", description = ''},
                {name = "$15000", description = ''},
                {name = "$25000", description = ''},
                {name = "$30000", description = ''},
                {name = "$35000", description = ''},
                {name = "$40000", description = ''},
                {name = "$45000", description = ''},
                {name = "$50000", description = ''},
                {name = "$60000", description = ''},
                {name = "$80000", description = ''},
            }
        },
        ["Actions sur véhicules"] = {
            title = "VEHICLE INTERACTIONS",
            name = "Actions sur véhicules",
            buttons = {
                {name = "Vérifier plaque minéralogique", description = ''},
                {name = "Crochetter", description = ''},
            }
        },
    }
}
-------------------------------------------------
----------------CONFIG SELECTION----------------
-------------------------------------------------
function ButtonSelectedPolice(button)
    local ped = GetPlayerPed(-1)
    local this = menupolice.currentmenu
    local btn = button.name
    if this == "main" then
        if btn == "Animations" then
            OpenMenuPolice('Animations')
        elseif btn == "Actions sur civils" then
            OpenMenuPolice('Actions sur civils')
        elseif btn == "Actions sur véhicules" then
            OpenMenuPolice('Actions sur véhicules')
        elseif btn == "Fermer le menu" then
            CloseMenuPolice()
        end
    elseif this == "Animations" then
        if btn == "Faire la circulation" then
            Circulation()
        elseif btn == "Prendre des notes" then
            Note()
        elseif btn == "Faire la garde" then
            StandBy()
        elseif btn == "Faire la garde 2" then
            StandBy2()
        end

    elseif this == "Actions sur civils" then
        if btn == "Amendes" then
            OpenMenuPolice('Amendes')
        elseif btn == "Fouiller" then
            Fouiller()
        elseif btn == "Confisquer argent sale" then
            RemoveDirtyMoney()
        elseif btn == "Menotter/Démenotter" then
            Cuffed()
        elseif btn == "Mettre dans le véhicule" then
            PutInVehicle()
        elseif btn == "Sortir du véhicule" then
            UnseatVehicle()
        end
    elseif this == "Actions sur véhicules" then
        if btn == "Crochetter"then
            Crocheter()
        elseif btn == "Vérifier plaque minéralogique" then
            CheckPlate()
        end
    elseif this == "Amendes" then
        if btn == "$250"then
            Amendes(250)
        elseif btn == "$500" then
            Amendes(500)
        elseif btn == "$1000" then
            Amendes(1000)
        elseif btn == "$1500" then
            Amendes(1500)
        elseif btn == "$2000" then
            Amendes(2000)
        elseif btn == "$4000" then
            Amendes(4000)
        elseif btn == "$6000" then
            Amendes(6000)
        elseif btn == "$8000" then
            Amendes(8000)
        elseif btn == "$10000" then
            Amendes(10000)
        elseif btn == "$11000" then
            Amendes(11000)
        elseif btn == "$15000" then
            Amendes(15000)
        elseif btn == "$25000" then
            Amendes(25000)
        elseif btn == "$30000" then
            Amendes(30000)
        elseif btn == "$35000" then
            Amendes(35000)
        elseif btn == "$40000" then
            Amendes(40000)
        elseif btn == "$45000" then
            Amendes(45000)
        elseif btn == "$50000" then
            Amendes(50000)
        elseif btn == "$60000" then
            Amendes(60000)
        elseif btn == "$80000" then
            Amendes(80000)
        end
    end
end
-------------------------------------------------
----------------FONCTION ANIMATIONS---------------
-------------------------------------------------
function Circulation()

    Citizen.CreateThread(function()
        TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_CAR_PARK_ATTENDANT", 0, false)
        Citizen.Wait(60000)
        ClearPedTasksImmediately(GetPlayerPed(-1))
    end)
    --drawNotification("~g~You're a circulation cop.")
end

function animsActionScenario(animObj)
    local ped = GetPlayerPed(-1);

    if ped then
        local pos = GetEntityCoords(ped);
        local head = GetEntityHeading(ped);
        --TaskStartScenarioAtPosition(ped, animObj.anim, pos['x'], pos['y'], pos['z'] - 1, head, -1, false, false);
        TaskStartScenarioInPlace(ped, animObj.anim, 0, false)

    end
end



function Note()
    Citizen.CreateThread(function()
        TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_CLIPBOARD", 0, false)
        Citizen.Wait(20000)
        ClearPedTasksImmediately(GetPlayerPed(-1))
    end)
    --drawNotification("~g~You're taking notes.")
end

function StandBy()
    Citizen.CreateThread(function()
        TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_COP_IDLES", 0, true)
        Citizen.Wait(20000)
        ClearPedTasksImmediately(GetPlayerPed(-1))
    end)
    --drawNotification("~g~You're in Faire la garde.")
end

function StandBy2()
    Citizen.CreateThread(function()
        TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_GUARD_STAND", 0, 1)
        Citizen.Wait(20000)
        ClearPedTasksImmediately(GetPlayerPed(-1))
    end)
    --drawNotification("~g~You're in Faire la garde.")
end

-------------------------------------------------
------------FONCTION INTERACTION Actions sur civils---------
-------------------------------------------------
function Fouiller()
    t, distance = GetClosestPlayer()
    if(distance ~= -1 and distance < 3) then
        TriggerServerEvent("police:targetCheckInventory", GetPlayerServerId(t))
    else
        TriggerEvent('chatMessage', 'LSPD', {255, 0, 0}, "Pas de citoyens près de vous !")
    end
end

function RemoveDirtyMoney()
    t, distance = GetClosestPlayer()
    if(distance ~= -1 and distance < 3) then
        TriggerServerEvent("police:checkDirtyMoney", GetPlayerServerId(t))
    else
        TriggerEvent('chatMessage', 'LSPD', {255, 0, 0}, "Pas de citoyens près de vous !")
    end
end

function Cuffed()
    t, distance = GetClosestPlayer()
    if(distance ~= -1 and distance < 3) then
        TriggerServerEvent("police:cuffGranted", GetPlayerServerId(t))
    else
        TriggerEvent('chatMessage', 'LSPD', {255, 0, 0}, "Pas de citoyens près de vous !")
    end
end

function PutInVehicle()
    t, distance = GetClosestPlayer()
    if(distance ~= -1 and distance < 3) then
        local v = GetVehiclePedIsIn(GetPlayerPed(-1), true)
        TriggerServerEvent("police:forceEnterAsk", GetPlayerServerId(t), v)
    else
        TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Pas de citoyens près de vous !")
    end
end

function UnseatVehicle()
    t, distance = GetClosestPlayer()
    if(distance ~= -1 and distance < 3) then
        TriggerServerEvent("police:confirmUnseat", GetPlayerServerId(t))
    else
        TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Pas de citoyens près de vous !")
    end
end

function Amendes(amount)
    t, distance = GetClosestPlayer()
    if(distance ~= -1 and distance < 3) then
        TriggerServerEvent("police:finesGranted", GetPlayerServerId(t), amount)
    else
        TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Pas de citoyens près de vous !")
    end
end

-------------------------------------------------
------------FONCTION INTERACTION VEHICLE---------
-------------------------------------------------
function Crocheter()
    Citizen.CreateThread(function()
        local ply = GetPlayerPed(-1)
        local plyCoords = GetEntityCoords(ply, 0)
        --GetClosestVehicle(x,y,z,distance dectection, 0 = tous les vehicules, Flag 70 = tous les veicules sauf police a tester https://pastebin.com/kghNFkRi)
        veh = GetClosestVehicle(plyCoords["x"], plyCoords["y"], plyCoords["z"], 5.001, 0, 70)
        TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_WELDING", 0, true)
        Citizen.Wait(20000)
        SetVehicleDoorsLocked(veh, 1)
        ClearPedTasksImmediately(GetPlayerPed(-1))
        drawNotification("Le véhicule est désormais ~g~ouvert~w~.")
    end)
end

function CheckPlate()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 20.0, 0.0)

    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
    local a, b, c, d, vehicleHandle = GetRaycastResult(rayHandle)
    if(DoesEntityExist(vehicleHandle)) then
        TriggerServerEvent("police:checkingPlate", GetVehicleNumberPlateText(vehicleHandle))
    else
        TriggerEvent('chatMessage', 'LSPD', {255, 0, 0}, "Pas de véhicule près de vous !")
    end
end
-------------------------------------------------
----------------CONFIG OPEN MENU-----------------
-------------------------------------------------
function OpenMenuPolice(menu)
    menupolice.lastmenu = menupolice.currentmenu
    if menu == "Animations" then
        menupolice.lastmenu = "main"
    elseif menu == "Actions sur civils" then
        menupolice.lastmenu = "main"
    elseif menu == "Actions sur véhicules" then
        menupolice.lastmenu = "main"
    elseif menu == "Amendes" then
        menupolice.lastmenu = "main"
    end
    menupolice.menu.from = 1
    menupolice.menu.to = 10
    menupolice.selectedbutton = 0
    menupolice.currentmenu = menu
end
-------------------------------------------------
------------------DRAW NOTIFY--------------------
-------------------------------------------------
function drawNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end
--------------------------------------
-------------DISPLAY HELP TEXT--------
--------------------------------------
function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
-------------------------------------------------
------------------DRAW TITLE MENU----------------
-------------------------------------------------
function drawMenuTitle(txt,x,y)
    local menu = menupolice.menu
    SetTextFont(2)
    SetTextProportional(0)
    SetTextScale(0.5, 0.5)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    AddTextComponentString(txt)
    DrawRect(x,y,menu.width,menu.height,0,0,0,150)
    DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end
-------------------------------------------------
------------------DRAW MENU BOUTON---------------
-------------------------------------------------
function drawMenuButton(button,x,y,selected)
    local menu = menupolice.menu
    SetTextFont(menu.font)
    SetTextProportional(0)
    SetTextScale(menu.scale, menu.scale)
    if selected then
        SetTextColour(0, 0, 0, 255)
    else
        SetTextColour(255, 255, 255, 255)
    end
    SetTextCentre(0)
    SetTextEntry("STRING")
    AddTextComponentString(button.name)
    if selected then
        DrawRect(x,y,menu.width,menu.height,255,255,255,255)
    else
        DrawRect(x,y,menu.width,menu.height,0,0,0,150)
    end
    DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end
-------------------------------------------------
------------------DRAW MENU INFO-----------------
-------------------------------------------------
function drawMenuInfo(text)
    local menu = menupolice.menu
    SetTextFont(menu.font)
    SetTextProportional(0)
    SetTextScale(0.45, 0.45)
    SetTextColour(255, 255, 255, 255)
    SetTextCentre(0)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawRect(0.675, 0.95,0.65,0.050,0,0,0,150)
    DrawText(0.365, 0.934)
end
-------------------------------------------------
----------------DRAW MENU DROIT------------------
-------------------------------------------------
function drawMenuRight(txt,x,y,selected)
    local menu = menupolice.menu
    SetTextFont(menu.font)
    SetTextProportional(0)
    SetTextScale(menu.scale, menu.scale)
    --SetTextRightJustify(1)
    if selected then
        SetTextColour(0, 0, 0, 255)
    else
        SetTextColour(255, 255, 255, 255)
    end
    SetTextCentre(0)
    SetTextEntry("STRING")
    AddTextComponentString(txt)
    DrawText(x + menu.width/2 - 0.03, y - menu.height/2 + 0.0028)
end
-------------------------------------------------
-------------------DRAW TEXT---------------------
-------------------------------------------------
function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
    SetTextFont(font)
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
end
-------------------------------------------------
----------------CONFIG BACK MENU-----------------
-------------------------------------------------
function BackMenuPolice()
    if backlock then
        return
    end
    backlock = true
    if menupolice.currentmenu == "main" then
        CloseMenuPolice()
    elseif menupolice.currentmenu == "Animations" or menupolice.currentmenu == "Actions sur civils" or menupolice.currentmenu == "Actions sur véhicules" or menupolice.currentmenu == "Amendes" then
        OpenMenuPolice(menupolice.lastmenu)
    else
        OpenMenuPolice(menupolice.lastmenu)
    end
end
-------------------------------------------------
---------------------FONCTION--------------------
-------------------------------------------------
function f(n)
    return n + 0.0001
end

function LocalPed()
    return GetPlayerPed(-1)
end

function try(f, catch_f)
    local status, exception = pcall(f)
    if not status then
        catch_f(exception)
    end
end
function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function round(num, idp)
    if idp and idp>0 then
        local mult = 10^idp
        return math.floor(num * mult + 0.5) / mult
    end
    return math.floor(num + 0.5)
end

function stringstarts(String,Start)
    return string.sub(String,1,string.len(Start))==Start
end
-------------------------------------------------
----------------FONCTION OPEN--------------------
-------------------------------------------------
function OpenPoliceMenu()
    menupolice.currentmenu = "main"
    menupolice.opened = true
    menupolice.selectedbutton = 0
end
-------------------------------------------------
----------------FONCTION CLOSE-------------------
-------------------------------------------------
function CloseMenuPolice()
    menupolice.opened = false
    menupolice.menu.from = 1
    menupolice.menu.to = 10
end
-------------------------------------------------
----------------FONCTION OPEN MENU---------------
-------------------------------------------------
local backlock = false
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(1,166) and menupolice.opened == true then
            CloseMenuPolice()
        end
        if menupolice.opened then
            local ped = LocalPed()
            local menu = menupolice.menu[menupolice.currentmenu]
            drawTxt(menupolice.title,1,1,menupolice.menu.x,menupolice.menu.y,1.0, 255,255,255,255)
            drawMenuTitle(menu.title, menupolice.menu.x,menupolice.menu.y + 0.08)
            drawTxt(menupolice.selectedbutton.."/"..tablelength(menu.buttons),0,0,menupolice.menu.x + menupolice.menu.width/2 - 0.0385,menupolice.menu.y + 0.067,0.4, 255,255,255,255)
            local y = menupolice.menu.y + 0.12
            buttoncount = tablelength(menu.buttons)
            local selected = false

            for i,button in pairs(menu.buttons) do
                if i >= menupolice.menu.from and i <= menupolice.menu.to then

                    if i == menupolice.selectedbutton then
                        selected = true
                    else
                        selected = false
                    end
                    drawMenuButton(button,menupolice.menu.x,y,selected)
                    if button.distance ~= nil then
                        drawMenuRight(button.distance.."m",menupolice.menu.x,y,selected)
                    end
                    y = y + 0.04
                    if selected and IsControlJustPressed(1,201) then
                        ButtonSelectedPolice(button)
                    end
                end
            end
        end
        if menupolice.opened then
            if IsControlJustPressed(1,202) then
                BackMenuPolice()
            end
            if IsControlJustReleased(1,202) then
                backlock = false
            end
            if IsControlJustPressed(1,188) then
                if menupolice.selectedbutton > 1 then
                    menupolice.selectedbutton = menupolice.selectedbutton -1
                    if buttoncount > 10 and menupolice.selectedbutton < menupolice.menu.from then
                        menupolice.menu.from = menupolice.menu.from -1
                        menupolice.menu.to = menupolice.menu.to - 1
                    end
                end
            end
            if IsControlJustPressed(1,187)then
                if menupolice.selectedbutton < buttoncount then
                    menupolice.selectedbutton = menupolice.selectedbutton +1
                    if buttoncount > 10 and menupolice.selectedbutton > menupolice.menu.to then
                        menupolice.menu.to = menupolice.menu.to + 1
                        menupolice.menu.from = menupolice.menu.from + 1
                    end
                end
            end
        end

    end
end)