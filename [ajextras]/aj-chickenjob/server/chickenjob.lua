
RegisterServerEvent('aj-chickenjob:getNewChicken')
AddEventHandler('aj-chickenjob:getNewChicken', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    -- local pick = Config.Items

      if TriggerClientEvent("AJFW:Notify", src, "You Received 5 Alive chicken!", "Success", 8000) then
          Player.Functions.AddItem('alivechicken', 5)
          TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['alivechicken'], "add")
      end
end)

RegisterServerEvent('aj-chickenjob:getcutChicken')
AddEventHandler('aj-chickenjob:getcutChicken', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    -- local pick = Config.Items

      if TriggerClientEvent("AJFW:Notify", src, "Well! You slaughtered chicken.", "Success", 8000) then
          Player.Functions.RemoveItem('alivechicken', 1)
          Player.Functions.AddItem('slaughteredchicken', 1)
          TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['alivechicken'], "remove")
          TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['slaughteredchicken'], "add")
      end
end)

RegisterServerEvent('aj-chickenjob:startChicken')
AddEventHandler('aj-chickenjob:startChicken', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)

      if TriggerClientEvent("AJFW:Notify", src, "You Paid $500!", "Success", 8000) then
        Player.Functions.RemoveMoney('bank', 500)
          
      end
end)

RegisterServerEvent('aj-chickenjob:getpackedChicken')
AddEventHandler('aj-chickenjob:getpackedChicken', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    -- local pick = Config.Items

      if TriggerClientEvent("AJFW:Notify", src, "You Packed Slaughtered chicken .", "Success", 8000) then
          Player.Functions.RemoveItem('slaughteredchicken', 1)
          Player.Functions.AddItem('packagedchicken', 1)
          TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['slaughteredchicken'], "remove")
          TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['packagedchicken'], "add")
      end
end)


local ItemList = {
    ["packagedchicken"] = math.random(200, 250),
}

RegisterServerEvent('aj-chickenjob:sell')
AddEventHandler('aj-chickenjob:sell', function()
    local src = source
    local price = 0
    local Player = AJFW.Functions.GetPlayer(src)
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
        TriggerClientEvent('AJFW:Notify', src, "You have sold your items")
    else
        TriggerClientEvent('AJFW:Notify', src, "You don't have items")
    end
end)


