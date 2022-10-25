function NearTaxi(src)
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    for k,v in pairs(Config.NPCLocations.DeliverLocations) do
        local dist = #(coords - vector3(v.x,v.y,v.z))
        if dist < 50 then
            return true
        end
    end
end

RegisterNetEvent('mr-taxi:server:NpcPay', function(Payment)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "taxi" then
        if NearTaxi(src) then
            local randomAmount = math.random(1, 5)
            local r1, r2 = math.random(1, 5), math.random(1, 5)
            if randomAmount == r1 or randomAmount == r2 then Payment = Payment + math.random(10, 20) end
            Player.Functions.AddMoney('cash', Payment)
            local chance = math.random(1, 20)
            if chance <= 2 then
                Player.Functions.AddItem("labkey2", 1)
                TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items["labkey2"], "add")
            elseif chance > 2 and chance <= 4 then
               Player.Functions.AddItem("cryptostick", 1)
                TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items["cryptostick"], "add")
            elseif chance > 4 and chance <= 10 then
                local br = math.random(40,50)
                Player.Functions.AddItem("blackmoney", br)
                TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items["blackmoney"], "add", br)
            end
        else
            -- DropPlayer(src, 'Attempting To Exploit')
        end
    else
        -- DropPlayer(src, 'Attempting To Exploit')
    end
end)

