local AJFW = exports['ajfw']:GetCoreObject()

RegisterNetEvent('aj-garage_new:server:Giveitem', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local dropChance = math.random(Config.DropMin, Config.DropMax)
    if dropChance > 1 then
        local randomChance = math.random(1,100)
        local item = 'water_bottle'
        if randomChance <= 4 then
            item = "labkey6"
        elseif randomChance > 4 and randomChance <= 14 then
            item = 'empty_bottle'
        elseif randomChance > 14 and randomChance <= 29 then
            item = 'lotto'
        elseif randomChance > 29 and randomChance <= 37 then
            item = 'empty_bag'
        elseif randomChance > 37 and randomChance <= 45 then
            item = 'aluminum'
        elseif randomChance > 45 and randomChance <= 50 then
            item = 'sandwich'
        elseif randomChance > 50 and randomChance <= 55 then
            item = 'headbag'
        elseif randomChance > 55 and randomChance <= 60 then
            item = 'papera'
        elseif randomChance > 60 and randomChance <= 65 then
            item = 'plastic'
        elseif randomChance > 65 and randomChance <= 75 then
            item = 'sandwich'
        elseif randomChance > 75 and randomChance <= 80 then
            item = 'snspistol_part_1'
        elseif randomChance > 80 and randomChance <= 85 then
            item = 'snspistol_part_2'
        elseif randomChance > 85 and randomChance <= 90 then
            item = 'snspistol_part_3'
        elseif randomChance > 90 and randomChance <= 100 then
            --do Nothing
        end
        Player.Functions.AddItem(item, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items[item], 'add')
    end
end)

RegisterNetEvent('aj-garage_new:server:GiveMoney', function(amount)
    -- print(amount)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    Player.Functions.AddMoney('cash', amount, "For Doing Garbage Job")
end)