-- Spawn override
AddEventHandler('onClientMapStart', function()
    exports.spawnmanager:setAutoSpawn(true)
    exports.spawnmanager:forceRespawn()
end)

-- Allows the server to spawn the player
RegisterNetEvent('es_freeroam:spawnPlayer')
AddEventHandler('es_freeroam:spawnPlayer', function(x, y, z)
   -- exports.spawnmanager:spawnPlayer({x = x, y = y, z = z})
end)



RegisterNetEvent("es_freeroam:wanted")
AddEventHandler("es_freeroam:wanted", function()
  Citizen.CreateThread(function()
      SetPlayerWantedLevel(PlayerId(), 0, 0)
      SetPlayerWantedLevelNow(PlayerId(), 0)
    end)
end)

  -- Display text
    RegisterNetEvent("es_freeroam:displaytext")
    AddEventHandler("es_freeroam:displaytext", function(text, time)
      ClearPrints()
    	SetTextEntry_2("STRING")
    	AddTextComponentString(text)
    	DrawSubtitleTimed(time, 1)
    end)

    -- Display notification
    RegisterNetEvent("es_freeroam:notify")
    AddEventHandler("es_freeroam:notify", function(icon, type, sender, title, text)
      Citizen.CreateThread(function()
        Wait(1)
        SetNotificationTextEntry("STRING");
        AddTextComponentString(text);
        SetNotificationMessage(icon, icon, true, type, sender, title, text);
        DrawNotification(false, true);
      end)
    end)
