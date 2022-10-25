local Total = nil

local slowWeight = 250
local fallWeight = 290

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)
        TriggerServerEvent('smallresources:server:ragdoll')
    end
end)

RegisterNetEvent('smallresources:client:ragdoll', function(weight)
    Total = weight
end)

Citizen.CreateThread(function()
    while true do
        sleep = 1000
        if Total ~= nil then
            if Total >= slowWeight * 1000 then
                local player = PlayerId()
                local ped = PlayerPedId()
                sleep = 5
                SetPedMoveRateOverride(ped, 0.75)
                SetPlayerSprint(player, false)
                if Total >= fallWeight * 1000 then
                    local chance = math.random(1, 100)
                    if chance <= 2 then
                        if IsPedRunning(ped) then
                            SetPedToRagdoll(ped, math.random(1000, 3000), math.random(1000, 3000), 3, 0, 0, 0)
                        end
                    end
                end
            else
                SetPedMoveRateOverride(ped, 1.0)
                SetPlayerSprint(player, true)
            end
        end
        Wait(sleep)
    end
end)