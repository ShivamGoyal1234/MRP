local MRFW = exports['mrfw']:GetCoreObject()

RegisterNetEvent('Hunting:Server:TakeDeposit', function()
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local money = Player.PlayerData.money['bank']
    if money >= Config.StartDeposit then
        Player.Functions.RemoveMoney('cash', Config.StartDeposit, 'Started Hunting')
        TriggerClientEvent('Hunting:Client:Start', src)
    else
        TriggerClientEvent("MRFW:Notify", src, "You don't have enough money in your bank", "error", 5000)
    end
end)

RegisterNetEvent('Hunting:Server:ReturnDeposit', function()
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    Player.Functions.AddMoney('cash', Config.ReturnMoney, 'Returned Hunting Vehicle')
end)

RegisterNetEvent('Hunting:Server:Reward', function(weight)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if weight >= 1 then
        Player.Functions.AddItem('meat2', 1)
        TriggerClientEvent("inventory:client:ItemBox", source, MRFW.Shared.Items['meat'], "add")
     elseif weight >= 9 then
        Player.Functions.AddItem('meat2', 2)
        TriggerClientEvent("inventory:client:ItemBox", source, MRFW.Shared.Items['meat'], "add")
     elseif weight >= 15 then
        Player.Functions.AddItem('meat2', 3)
        TriggerClientEvent("inventory:client:ItemBox", source, MRFW.Shared.Items['meat'], "add")
     end
end)

RegisterNetEvent('Hunting:Server:process', function(heading)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local meat = Player.Functions.GetItemByName('meat2')
    if meat ~= nil then
        TriggerClientEvent("Hunting:Client:process", src,heading)
    else
        TriggerClientEvent("MRFW:Notify", src, "You don't have Meat in your inventory", "error", 5000)
    end
end)

RegisterNetEvent('Hunting:Server:GetItemProcessed', function()
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local meat = Player.Functions.GetItemByName('meat2')
    if meat ~= nil then
        Player.Functions.RemoveItem('meat2', 1)
        Player.Functions.AddItem('slaughtered_meat', 1)
    else
        TriggerClientEvent("MRFW:Notify", src, "nalla samjha he ka", "error", 5000)
    end
end)

RegisterNetEvent('Hunting:Server:Packing', function(heading)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local meat = Player.Functions.GetItemByName('slaughtered_meat')
    local box = Player.Functions.GetItemByName('empty_box')
    if meat ~= nil then
        if box ~= nil then
            TriggerClientEvent("Hunting:Client:Packing", src,heading)
        else
            TriggerClientEvent("MRFW:Notify", src, "You don't have Empty Box in your inventory", "error", 5000)
        end
    else
        TriggerClientEvent("MRFW:Notify", src, "You don't have slaughtered meat in your inventory", "error", 5000)
    end
end)

RegisterNetEvent('Hunting:Server:GetPackedItems', function()
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local meat = Player.Functions.GetItemByName('slaughtered_meat')
    if meat ~= nil then
        Player.Functions.RemoveItem('slaughtered_meat', 1)
        Player.Functions.RemoveItem('empty_box', 1)
        Player.Functions.AddItem('packed_meat', 1)
    else
        TriggerClientEvent("MRFW:Notify", src, "nalla samjha he ka", "error", 5000)
    end
end)

RegisterNetEvent('Hunting:Server:Selling', function()
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local meat = Player.Functions.GetItemByName('packed_meat')
    if meat ~= nil then
        TriggerClientEvent("Hunting:Client:Selling", src)
    else
        TriggerClientEvent("MRFW:Notify", src, "You don't have Packed meat in your inventory", "error", 5000)
    end
end)

local ItemList = {
    ["packed_meat"] = math.random(300, 400),
}

RegisterNetEvent('Hunting:Server:Rewards', function()
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local meat = Player.Functions.GetItemByName('packed_meat')
    if meat ~= nil then
        local price = 0
        local Player = MRFW.Functions.GetPlayer(src)
        if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
            for k, v in pairs(Player.PlayerData.items) do 
                if Player.PlayerData.items[k] ~= nil then 
                    if ItemList[Player.PlayerData.items[k].name] ~= nil then 
                        price = price + (ItemList[Player.PlayerData.items[k].name] * Player.PlayerData.items[k].amount)
                        Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k)
                    end
                end
            end
            Player.Functions.AddMoney("cash", price, "sold-items")
            TriggerClientEvent('MRFW:Notify', src, "You have sold your items")
        else
            TriggerClientEvent('MRFW:Notify', src, "You don't have items")
        end
    else
        TriggerClientEvent("MRFW:Notify", src, "nalla samjha he ka", "error", 5000)
    end
end)