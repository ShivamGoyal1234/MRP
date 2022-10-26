MRFW = exports['mrfw']:GetCoreObject()

RegisterServerEvent('mr-taco:server:start:black')
AddEventHandler('mr-taco:server:start:black', function()
    local src = source
    
    TriggerClientEvent('mr-taco:start:black:job', src)
end)

RegisterServerEvent('mr-taco:server:reward:money')
AddEventHandler('mr-taco:server:reward:money', function()
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    
    Player.Functions.AddMoney("cash", Config.PaymentTaco, "taco-reward-money")
    TriggerClientEvent('MRFW:Notify', src, "Taco delivered! Go back to the taco shop for a new delivery")
end)

MRFW.Functions.CreateCallback('mr-tacos:server:GetConfig', function(source, cb)
    cb(Config)
end)

RegisterServerEvent('mr-tacos:server:get:stuff')
AddEventHandler('mr-tacos:server:get:stuff', function()
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    
    if Player ~= nil then
        Player.Functions.AddItem("taco-box", 1)
        TriggerClientEvent('inventory:client:ItemBox', source, MRFW.Shared.Items['taco-box'], "add")
    end
end)

MRFW.Functions.CreateCallback('mr-taco:server:get:ingredient', function(source, cb)
    local src = source
    local Ply = MRFW.Functions.GetPlayer(src)
    local lettuce = Ply.Functions.GetItemByName("lettuce")
    local meat = Ply.Functions.GetItemByName("meat")
    if lettuce ~= nil and meat ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

MRFW.Functions.CreateCallback('mr-taco:server:get:tacobox', function(source, cb)
    local src = source
    local Ply = MRFW.Functions.GetPlayer(src)
    local box = Ply.Functions.GetItemByName("taco-box")
    if box ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

MRFW.Functions.CreateCallback('mr-taco:server:get:tacos', function(source, cb)
    local src = source
    local Ply = MRFW.Functions.GetPlayer(src)
    local taco = Ply.Functions.GetItemByName('taco')
    if taco ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

RegisterNetEvent("mr-taco:server:giveitemreward")
AddEventHandler("mr-taco:server:giveitemreward", function(item, count)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local luck1 = math.random(1, 100)
    local itemFound1 = true
    local itemCount1 = 1

    if itemFound1 then
        for i = 1, itemCount1, 1 do
            local randomItem 
            local itemInfo 
            if luck1 == 100 then
                -- randomItem = "bluechip"
                -- itemInfo = MRFW.Shared.Items[randomItem]
               
                -- Player.Functions.AddItem(randomItem, 1)
                -- TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "add")
               
			elseif luck1 > 85 and luck1 <= 98 then
				randomItem = "greychip"
                itemInfo = MRFW.Shared.Items[randomItem]
               
                Player.Functions.AddItem(randomItem, 1)
                TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "add")
			elseif luck1 > 50 and luck1 <= 53 then
				randomItem = "blackkey"
                itemInfo = MRFW.Shared.Items[randomItem]
               
                Player.Functions.AddItem(randomItem, 1)
                TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "add")

            elseif luck1 > 35 and luck1 <= 50 then
                local blackRandom = math.random(15,20)
                randomItem = "blackmoney"
                itemInfo = MRFW.Shared.Items[randomItem]
               
                Player.Functions.AddItem(randomItem, blackRandom)
                TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "add", blackRandom)
                
			elseif luck1 > 15 and luck1 <= 30 then
				randomItem = "empty_bag"
                itemInfo = MRFW.Shared.Items[randomItem]
               
                Player.Functions.AddItem(randomItem, 1)
                TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "add")
                
            elseif luck1 <= 10 then
                TriggerClientEvent('MRFW:Notify', src, "कुछ नहीं मिलेगा , निकल पहली फुर्सत में" , "error", 5000)
                
            end
            Citizen.Wait(500)
        end
    end
end)
