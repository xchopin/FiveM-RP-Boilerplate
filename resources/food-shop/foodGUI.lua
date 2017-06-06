Keys = {
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

Menu = {}
Menu.GUI = {}
Menu.TitleGUI = {}
Menu.buttonCount = 0
Menu.titleCount = 0
Menu.selection = 0
Menu.hidden = true
MenuTitle = "Superette 7 Eleven"
-------------------
posXMenu = 0.1
posYMenu = 0.05
width = 0.25
height = 0.05
posXMenuTitle = 0.1
posYMenuTitle = 0.05
widthMenuTitle = 0.25
heightMenuTitle = 0.05
-------------------
function Menu.addTitle(name)
	local yoffset = 0.3
	local xoffset = 0
	local xmin = posXMenuTitle
	local ymin = posYMenuTitle
	local xmax = widthMenuTitle
	local ymax = heightMenuTitle
	Menu.TitleGUI[Menu.titleCount +1] = {}
	Menu.TitleGUI[Menu.titleCount +1]["name"] = name
	Menu.TitleGUI[Menu.titleCount+1]["xmin"] = xmin + xoffset
	Menu.TitleGUI[Menu.titleCount+1]["ymin"] = ymin * (Menu.titleCount + 0.01) +yoffset
	Menu.TitleGUI[Menu.titleCount+1]["xmax"] = xmax
	Menu.TitleGUI[Menu.titleCount+1]["ymax"] = ymax
	Menu.titleCount = Menu.titleCount+1
end

function Menu.addButton(name, func,args)
	local yoffset = 0.3
	local xoffset = 0
	local xmin = posXMenu
	local ymin = posYMenu
	local xmax = width
	local ymax = height
	Menu.GUI[Menu.buttonCount +1] = {}
	Menu.GUI[Menu.buttonCount +1]["name"] = name
	Menu.GUI[Menu.buttonCount+1]["func"] = func
	Menu.GUI[Menu.buttonCount+1]["args"] = args
	Menu.GUI[Menu.buttonCount+1]["active"] = false
	Menu.GUI[Menu.buttonCount+1]["xmin"] = xmin + xoffset
	Menu.GUI[Menu.buttonCount+1]["ymin"] = ymin * (Menu.buttonCount + 0.01) +yoffset
	Menu.GUI[Menu.buttonCount+1]["xmax"] = xmax
	Menu.GUI[Menu.buttonCount+1]["ymax"] = ymax
	Menu.buttonCount = Menu.buttonCount+1
end

function Menu.updateSelection()
	if IsControlJustPressed(1, Keys["UP"]) then --RECULER
		if(Menu.selection < Menu.buttonCount -1  )then
			Menu.selection = Menu.selection +1
		else
			Menu.selection = 0
		end
	elseif IsControlJustPressed(1, Keys["DOWN"]) then --AVANCER
		if(Menu.selection > 0)then
			Menu.selection = Menu.selection -1
		else
			Menu.selection = Menu.buttonCount-1
		end
	elseif IsControlJustPressed(1, Keys["NENTER"])  then --ENTREE
			MenuCallFunction(Menu.GUI[Menu.selection +1]["func"], Menu.GUI[Menu.selection +1]["args"])
	end
	local iterator = 0
	for id, settings in ipairs(Menu.GUI) do
		Menu.GUI[id]["active"] = false
		if(iterator == Menu.selection ) then
			Menu.GUI[iterator +1]["active"] = true
		end
		iterator = iterator +1
	end
end

function Menu.renderGUI()
	if not Menu.hidden then
		Menu.renderTitle()
		Menu.renderButtons()
		Menu.updateSelection()
	end
end

function Menu.renderBox(xMin,xMax,yMin,yMax,color1,color2,color3,color4)
	DrawRect(xMin, yMin,xMax, yMax, color1, color2, color3, color4);
end

function Menu.renderTitle()
	local yoffset = 0.3
	local xoffset = 0
	local xmin = posXMenuTitle
	local ymin = posYMenuTitle
	local xmax = widthMenuTitle
	local ymax = heightMenuTitle
	for id, settings in pairs(Menu.TitleGUI) do
		local screen_w = 0
		local screen_h = 0
		screen_w, screen_h =  GetScreenResolution(0, 0)
		boxColor = {0,0,0,128}
		SetTextFont(0)
		SetTextScale(0.0,0.35)
		SetTextColour(255, 255, 255, 255)
		SetTextCentre(true)
		SetTextDropShadow(0, 0, 0, 0, 0)
		SetTextEdge(0, 0, 0, 0, 0)
		SetTextEntry("STRING")
		AddTextComponentString(string.upper(settings["name"]))
		DrawText(settings["xmin"], (settings["ymin"] - heightMenuTitle - 0.0125))
		Menu.renderBox(settings["xmin"] ,settings["xmax"], settings["ymin"] - heightMenuTitle, settings["ymax"],boxColor[1],boxColor[2],boxColor[3],boxColor[4])
	end
end

function Menu.renderButtons()
	for id, settings in pairs(Menu.GUI) do
		local screen_w = 0
		local screen_h = 0
		screen_w, screen_h =  GetScreenResolution(0, 0)
		boxColor = {128,128,128,128}
		if(settings["active"]) then
			boxColor = {0,102,255,102}
		end
		SetTextFont(0)
		SetTextScale(0.0,0.35)
		SetTextColour(255, 255, 255, 255)
		SetTextCentre(true)
		SetTextDropShadow(0, 0, 0, 0, 0)
		SetTextEdge(0, 0, 0, 0, 0)
		SetTextEntry("STRING")
		AddTextComponentString(settings["name"])
		DrawText(settings["xmin"], (settings["ymin"] - 0.0125 ))
		Menu.renderBox(settings["xmin"] ,settings["xmax"], settings["ymin"], settings["ymax"],boxColor[1],boxColor[2],boxColor[3],boxColor[4])
	 end
end
--------------------------------------------------------------------------------------------------------------------
function ClearMenu()
	--Menu = {}
	Menu.GUI = {}
	Menu.buttonCount = 0
	Menu.titleCount = 0
	Menu.selection = 0
end

function MenuCallFunction(fnc, arg)
	_G[fnc](arg)
end										
--------------------------------------------------------------------------------------------------------------------
function Texte(_texte, showtime)
    ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(_texte)
	DrawSubtitleTimed(showtime, 1)
end
--------------------------------------------------------------------------------------------------------------------
local vdkinventory = true -- false car il faudra corrigé dans le servuer pour la liaison...
function ShopMenu()
	ClearMenu()
	if (vdkinventory == false) then
		-- IF YOU DON'T HAVE VDK_INVENTORY
		Menu.addTitle("MENU")
		Menu.addButton("Burger ($150)","buymenu","Burger")
		Menu.addButton("Banh Bao ($20)","buymenu","Banh Bao")
		Menu.addButton("Eau du Mont Chiliad ($70)","buymenu","Eau")
		--Menu.addButton("Coca-Cola ($40)","buymenu","CocaCola")
	else
		Menu.addTitle("MENU")
		Menu.addButton("Burger ($5)","buymenu",{30, 1, 5})
		--Menu.addButton("Banh Bao ($20)","buymenu","Banh Bao")
		--Menu.addButton("Eau du Mont Chiliad ($70)","buymenu","Eau")
		Menu.addButton("Coca-Cola ($2)","buymenu",{31, 1, 2})
		
--		Menu.addButton("FoodName","buymenu",{ itemId, qty, price}) -- itemId = id de l'item vdk (Table : items), qty = quantité et price = prix
	end
end

function buymenu(fooditem)
	if (exports.personnal_menu:notFull() == true) then
		if (vdkinventory == false) then
			Texte("Consommé: ~g~".. fooditem, 5000)
			TriggerServerEvent('gabs:menu', fooditem)
		else
			TriggerServerEvent('gabs:menuvdk', fooditem)
		end
	else
		 TriggerEvent("mt:missiontext","~r~ Inventaire plein ! ", 200)
	end
end
