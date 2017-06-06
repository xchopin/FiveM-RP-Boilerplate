-- Huge server file.

local interiors = {
	[1] = { 
		["xo"] = 123.055, 
		["yo"] = -625.695, 
		["zo"] = 206.047, 
		["ho"] = 150.10, 
		["xe"] = 2475.79, 
		["ye"] = -384.055, 
		["ze"] = 94.4,
		["he"] = 234.62, 
		["name"] = 'Siège du Gouvernement'
	},
	[2] = { 
		["xo"] = 319.485, 
		["yo"] = -581.078, 
		["zo"] = 43.3174, 
		["ho"] = 150.10, 
		["xe"] = 1150.88, 
		["ye"] = -1530.24, 
		["ze"] = 35.3863,
		["he"] = 234.62, 
		["name"] = 'CHU de Los Santos'
	},
}

RegisterServerEvent("interiors:sendData_s")
AddEventHandler("interiors:sendData_s", function()
    TriggerClientEvent("interiors:f_sendData", source, interiors)
end)
