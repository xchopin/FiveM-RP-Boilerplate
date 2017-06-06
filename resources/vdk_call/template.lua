local working

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        if IsControlJustPressed(1, 38) then
            if not working then
                TriggerServerEvent("player:serviceOn", "uber")
            else
                TriggerServerEvent("player:serviceOff", "uber")
            end
            working = not working
        end

        -- Trigger a call of Uber with F9
        if IsControlJustPressed(1, 56) then
            local plyPos = GetEntityCoords(GetPlayerPed(-1), true)
            TriggerServerEvent("call:makeCall", "uber", {x=plyPos.x,y=plyPos.y,z=plyPos.z})
        end
    end
end)