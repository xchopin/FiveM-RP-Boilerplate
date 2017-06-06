require "resources/essentialmode/lib/MySQL"
MySQL:open("127.0.0.1", "gta5_gamemode_essential", "root", "")

AddEventHandler('onResourceStart', function(resource)
  MySQL:executeQuery("UPDATE user_vehicle SET `vehicle_state`='@value' WHERE `vehicle_state`='Sortit'",
  {['@value'] = "Rentré"})
end)
