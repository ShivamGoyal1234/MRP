
RegisterServerEvent('mr-chickenjob:getNewChicken')
AddEventHandler('mr-chickenjob:getNewChicken', function()
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    -- local pick = Config.Items

      if TriggerClientEvent("MRFW:Notify", src, "You Received 5 Alive chicken!", "Success", 8000) then
          Player.Functions.AddItem('alivechicken', 5)
          TriggerClientEvent("inventory:client:ItemBox", source, MRFW.Shared.Items['alivechicken'], "add")
      end
end)

RegisterServerEvent('mr-chickenjob:getcutChicken')
AddEventHandler('mr-chickenjob:getcutChicken', function()
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    -- local pick = Config.Items

      if TriggerClientEvent("MRFW:Notify", src, "Well! You slaughtered chicken.", "Success", 8000) then
          Player.Functions.RemoveItem('alivechicken', 1)
          Player.Functions.AddItem('slaughteredchicken', 1)
          TriggerClientEvent("inventory:client:ItemBox", source, MRFW.Shared.Items['alivechicken'], "remove")
          TriggerClientEvent("inventory:client:ItemBox", source, MRFW.Shared.Items['slaughteredchicken'], "add")
      end
end)

RegisterServerEvent('mr-chickenjob:startChicken')
AddEventHandler('mr-chickenjob:startChicken', function()
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)

      if TriggerClientEvent("MRFW:Notify", src, "You Paid $500!", "Success", 8000) then
        Player.Functions.RemoveMoney('bank', 500)
          
      end
end)

RegisterServerEvent('mr-chickenjob:getpackedChicken')
AddEventHandler('mr-chickenjob:getpackedChicken', function()
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    -- local pick = Config.Items

      if TriggerClientEvent("MRFW:Notify", src, "You Packed Slaughtered chicken .", "Success", 8000) then
          Player.Functions.RemoveItem('slaughteredchicken', 1)
          Player.Functions.AddItem('packagedchicken', 1)
          TriggerClientEvent("inventory:client:ItemBox", source, MRFW.Shared.Items['slaughteredchicken'], "remove")
          TriggerClientEvent("inventory:client:ItemBox", source, MRFW.Shared.Items['packagedchicken'], "add")
      end
end)


local ItemList = {
    ["packagedchicken"] = math.random(200, 250),
}

RegisterServerEvent('mr-chickenjob:sell')
AddEventHandler('mr-chickenjob:sell', function()
    local src = source
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
end)


