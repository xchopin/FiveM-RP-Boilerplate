local weashop = {
	opened = false,
	title = "Armurerie Los Santos",
	currentmenu = "main",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 200, type = 1 },
	menu = {
		x = 0.9,
		y = 0.08,
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
				{title = "Armes blanches", name = "Melee", description = "Couteau, batte de baseball,..."},
				{title = "Autres", name = "Autres", description = "Armes à feu et autres"},
			}
		},
		["Melee"] = {
			title = "Melee",
			name = "Armes blanches",
			buttons = {
				{title = "Couteau", name = "Knife", costs = 850, description = {}, model = "WEAPON_KNIFE"},
				{title = "Machette", name = "Machette", costs = 950, description = {}, model = "WEAPON_MACHETE"},
				
				{title = "Lampe torche", name = "Flashlight", costs = 400, description = {}, model = "WEAPON_FLASHLIGHT"},
			}
			
		},
		["Autres"] = {
			title = "Autres",
			name = "Autres",
			buttons = {
				{title = "Pistolet", name = "Pistol", costs = 3000, description = {}, model = "WEAPON_PISTOL"},
				{title = "Pistolet de combat", name = "CombatPistol", costs = 4000, description = {}, model = "WEAPON_COMBATPISTOL"},
				{title = "Revolver", name = "Revolver", costs = 3500, description = {}, model = "WEAPON_REVOLVER"},
				{title = "Parachute", name = "Parachute", costs = 800, description = {}, model = "GADGET_PARACHUTE"},
				{title = "Coktail Molotov", name = "Molotov", costs = 6500, description = {}, model = "WEAPON_MOLOTOV"},
				{title = "Fusil Gusenberg", name = "Gusenberg", costs = 29500, description = {}, model = "WEAPON_GUSENBERG"},
				{title = "Lanceur d'artifices", name = "Artifice", costs = 10000, description = {}, model = "WEAPON_FIREWORK"},

			}
		}
	}
}

local fakeWeapon = ''
local weashop_locations = {

	{entering = {1692.41, 3758.22, 34.7053}, inside = {1692.41, 3758.22, 34.7053}, outside = {1692.41, 3758.22, 34.7053}},
	{entering = {252.696, -48.2487, 69.941}, inside = {252.696, -48.2487, 69.941}, outside = {252.696, -48.2487, 69.941}},
	{entering = {844.299, -1033.26, 28.1949}, inside = {844.299, -1033.26, 28.1949}, outside = {844.299, -1033.26, 28.1949}},
	{entering = {-331.624, 6082.46, 31.4548}, inside = {-331.624, 6082.46, 31.4548}, outside = {-331.624, 6082.46, 31.4548}},
	{entering = {-1320.983, -389.260, 36.483}, inside = {-1324.983, -395.260, 32.483}, outside = {-1320.983, -389.260, 36.483}},
    {entering = {-664.147, -935.119, 21.8292}, inside = {-664.147, -935.119, 21.8292}, outside = {-664.147, -935.119, 21.8292}},
        
}


local weashop_blips ={}
local inrangeofweashop = false
local currentlocation = nil
local boughtWeapon = false

local function LocalPed()
return GetPlayerPed(-1)
end

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

function IsPlayerInRangeOfweashop()
return inrangeofweashop
end

function ShowWeashopBlips(bool)
	if bool and #weashop_blips == 0 then
		for station,pos in pairs(weashop_locations) do
			local loc = pos
			pos = pos.entering
			local blip = AddBlipForCoord(pos[1],pos[2],pos[3])
			-- 60 58 137
			SetBlipSprite(blip,76,7)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Armurerie de Los Santos')
			EndTextCommandSetBlipName(blip)
			SetBlipAsShortRange(blip,true)
			SetBlipAsMissionCreatorBlip(blip,true)
			table.insert(weashop_blips, {blip = blip, pos = loc})
		end
		Citizen.CreateThread(function()
			while #weashop_blips > 0 do
				Citizen.Wait(0)
				local inrange = false
				for i,b in ipairs(weashop_blips) do
					if IsPlayerWantedLevelGreater(GetPlayerIndex(),0) == false and weashop.opened == false and IsPedInAnyVehicle(LocalPed(), true) == false and  GetDistanceBetweenCoords(b.pos.entering[1],b.pos.entering[2],b.pos.entering[3],GetEntityCoords(LocalPed())) < 2 then
						DrawMarker(1,b.pos.entering[1],b.pos.entering[2],b.pos.entering[3],0,0,0,0,0,0,2.001,2.0001,0.5001,0,155,255,200,0,0,0,0)
						drawTxt('Appuyez sur ~g~ENTRER~s~ pour parler ~b~au marchand d\'armes',0,1,0.5,0.8,0.6,255,255,255,255)
						currentlocation = b
						inrange = true
					end
				end
				inrangeofweashop = inrange
			end
		end)
	elseif bool == false and #weashop_blips > 0 then
		for i,b in ipairs(weashop_blips) do
			if DoesBlipExist(b.blip) then
				SetBlipAsMissionCreatorBlip(b.blip,false)
				Citizen.InvokeNative(0x86A652570E5F25DD, Citizen.PointerValueIntInitialized(b.blip))
			end
		end
		weashop_blips = {}
	end
end

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

--local veh = nil
function OpenCreator()
	boughtWeapon = false
	local ped = GetPlayerPed(-1)
	local pos = currentlocation.pos.inside
	FreezeEntityPosition(ped,true)
	SetEntityVisible(ped,false)
	local g = Citizen.InvokeNative(0xC906A7DAB05C8D2B,pos[1],pos[2],pos[3],Citizen.PointerValueFloat(),0)
	SetEntityCoords(ped,pos[1],pos[2],g)
	SetEntityHeading(ped,pos[4])
	weashop.currentmenu = "main"
	weashop.opened = true
	weashop.selectedbutton = 0
end

function CloseCreator()
	Citizen.CreateThread(function()
		local ped = GetPlayerPed(-1)
		if not boughtWeapon then
			local pos = currentlocation.pos.entering
			SetEntityCoords(ped,pos[1],pos[2],pos[3])
			FreezeEntityPosition(ped,false)
			SetEntityVisible(ped,true)
			weashop.opened = false
			weashop.menu.from = 1
			weashop.menu.to = 10
		else
			local pos = currentlocation.pos.entering
			local hash = GetHashKey(fakeWeapon)
			GiveWeaponToPed(ped, hash, 1000, 0, false)
		end
	end)
end

function drawMenuButton(button,x,y,selected)
	local menu = weashop.menu
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
	AddTextComponentString(button.title)
	if selected then
		DrawRect(x,y,menu.width,menu.height,255,255,255,255)
	else
		DrawRect(x,y,menu.width,menu.height,0,0,0,150)
	end
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function drawMenuInfo(text)
	local menu = weashop.menu
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

function drawMenuRight(txt,x,y,selected)
	local menu = weashop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(menu.scale, menu.scale)
	SetTextRightJustify(1)
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

function drawMenuTitle(txt,x,y)
local menu = weashop.menu
	SetTextFont(2)
	SetTextProportional(0)
	SetTextScale(0.5, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawRect(x,y,menu.width,menu.height,0,0,0,150)
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function Notify(text)
SetNotificationTextEntry('STRING')
AddTextComponentString(text)
DrawNotification(false, false)
end

function DoesPlayerHaveWeapon(model,button,y,selected, source)
		local t = false
		local hash = GetHashKey(model)
		t = HasPedGotWeapon(GetPlayerPed(-1),hash,true) --Check if player already has selected weapon !!!! THIS DOES NOT WORK !!!!!
		if t then
			drawMenuRight("OWNED",weashop.menu.x,y,selected)
		else
			drawMenuRight(button.costs.." $",weashop.menu.x,y,selected)
		end
end

local backlock = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(1,201) and IsPlayerInRangeOfweashop() then
			if weashop.opened then
				CloseCreator()
			else
				OpenCreator()
			end
		end
		if weashop.opened then
			local ped = LocalPed()
			local menu = weashop.menu[weashop.currentmenu]
			drawTxt(weashop.title,1,1,weashop.menu.x,weashop.menu.y,1.0, 255,255,255,255)
			drawMenuTitle(menu.title, weashop.menu.x,weashop.menu.y + 0.08)
			drawTxt(weashop.selectedbutton.."/"..tablelength(menu.buttons),0,0,weashop.menu.x + weashop.menu.width/2 - 0.0385,weashop.menu.y + 0.067,0.4, 255,255,255,255)
			local y = weashop.menu.y + 0.12
			buttoncount = tablelength(menu.buttons)
			local selected = false

			for i,button in pairs(menu.buttons) do
				if i >= weashop.menu.from and i <= weashop.menu.to then

					if i == weashop.selectedbutton then
						selected = true
					else
						selected = false
					end
					drawMenuButton(button,weashop.menu.x,y,selected)
					if button.costs ~= nil then
						DoesPlayerHaveWeapon(button.model,button,y,selected,ped)
					end
					y = y + 0.04
					if selected and IsControlJustPressed(1,201) then
						ButtonSelected(button)
					end
				end
			end
		end
		if weashop.opened then
			if IsControlJustPressed(1,202) then
				Back()
			end
			if IsControlJustReleased(1,202) then
				backlock = false
			end
			if IsControlJustPressed(1,188) then
				if weashop.selectedbutton > 1 then
					weashop.selectedbutton = weashop.selectedbutton -1
					if buttoncount > 10 and weashop.selectedbutton < weashop.menu.from then
						weashop.menu.from = weashop.menu.from -1
						weashop.menu.to = weashop.menu.to - 1
					end
				end
			end
			if IsControlJustPressed(1,187)then
				if weashop.selectedbutton < buttoncount then
					weashop.selectedbutton = weashop.selectedbutton +1
					if buttoncount > 10 and weashop.selectedbutton > weashop.menu.to then
						weashop.menu.to = weashop.menu.to + 1
						weashop.menu.from = weashop.menu.from + 1
					end
				end
			end
		end

	end
end)

function round(num, idp)
  if idp and idp>0 then
    local mult = 10^idp
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end

function ButtonSelected(button)
	local ped = GetPlayerPed(-1)
	local this = weashop.currentmenu
	local btn = button.name
	if this == "main" then
		if btn == "Melee" then
			OpenMenu('Melee')
		elseif btn == "Autres" then
			OpenMenu('Autres')
		end
	else
		fakeWeapon = button.model
		TriggerServerEvent('CheckMoneyForWea',button.model,button.costs)
	end
end

RegisterNetEvent('FinishMoneyCheckForWea')
AddEventHandler('FinishMoneyCheckForWea', function()
	boughtWeapon = true
	CloseCreator()
end)

RegisterNetEvent('ToManyWeapons')
AddEventHandler('ToManyWeapons', function()
	boughtWeapon = false
	CloseCreator()
end)

function OpenMenu(menu)
	weashop.lastmenu = weashop.currentmenu
	weashop.menu.from = 1
	weashop.menu.to = 10
	weashop.selectedbutton = 0
	weashop.currentmenu = menu
end

function Back()
	if backlock then
		return
	end
	backlock = true
	if weashop.currentmenu == "main" then
		boughtWeapon = false
		CloseCreator()
	else
		OpenMenu(weashop.lastmenu)
	end

end

function stringstarts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

local firstspawn = 0
AddEventHandler('playerSpawned', function()
if firstspawn == 0 then
	ShowWeashopBlips(true)
	firstspawn = 1
end
TriggerServerEvent("weaponshop:playerSpawned")
end)

RegisterNetEvent('giveWeapon')
AddEventHandler('giveWeapon', function(name, delay)
	Citizen.CreateThread(function()
		local weapon = GetHashKey(name)
        Wait(delay)
        local hash = GetHashKey(name)
        GiveWeaponToPed(GetPlayerPed(-1), weapon, 1000, 0, false)
    end)
end)

RegisterNetEvent('giveWeapon_spawn')
AddEventHandler('giveWeapon_spawn', function(name, delay)
	Citizen.CreateThread(function()
		local weapon = GetHashKey(name)
        Wait(delay)
        local hash = GetHashKey(name)
        GiveWeaponToPed(GetPlayerPed(-1), weapon, 25, 0, false)
    end)
end)