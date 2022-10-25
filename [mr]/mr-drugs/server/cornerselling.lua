MRFW.Functions.CreateCallback('mr-drugs:server:cornerselling:getAvailableDrugs', function(source, cb)
    local AvailableDrugs = {}
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)

    for i = 1, #Config.CornerSellingDrugsList, 1 do
        local item = Player.Functions.GetItemByName(Config.CornerSellingDrugsList[i])

        if item ~= nil then
            AvailableDrugs[#AvailableDrugs+1] = {
                item = item.name,
                amount = item.amount,
                label = MRFW.Shared.Items[item.name]["label"]
            }
        end
    end

    if next(AvailableDrugs) ~= nil then
        cb(AvailableDrugs)
    else
        cb(nil)
    end
end)

local Drug_DeliveryLocations = {
    [1] = {
        ["label"] = "Stripclub",
        ["coords"] = vector3(106.24, -1280.32, 29.24),
    },
    [2] = {
        ["label"] = "Vinewood Video",
	["coords"] = vector3(223.98, 121.53, 102.76),
    },
    [3] = {
        ["label"] = "Resort",
	["coords"] = vector3(-1245.63, 376.21, 75.34),
    },
    [4] = {
        ["label"] = "Bahama Mamas",
	["coords"] = vector3(-1383.1, -639.99, 28.67),
    },
}

MRFW.Functions.CreateCallback('jacob:get:drugs', function(source, cb)
    cb(Drug_DeliveryLocations)
end)

RegisterServerEvent('mr-drugs:server:sellCornerDrugs')
AddEventHandler('mr-drugs:server:sellCornerDrugs', function(item, amount, price)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local hasItem = Player.Functions.GetItemByName(item)
    local AvailableDrugs = {}
    if hasItem.amount >= amount then
        
        TriggerClientEvent('MRFW:Notify', src, 'Offer accepted!', 'success')
        Player.Functions.RemoveItem(item, amount)
        Player.Functions.AddMoney('cash', price, "sold-cornerdrugs")
        -- Player.Functions.AddItem('blackmoney', price)
        TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items[item], "remove")

        for i = 1, #Config.CornerSellingDrugsList, 1 do
            local item = Player.Functions.GetItemByName(Config.CornerSellingDrugsList[i])

            if item ~= nil then
                AvailableDrugs[#AvailableDrugs+1] = {
                    item = item.name,
                    amount = item.amount,
                    label = MRFW.Shared.Items[item.name]["label"]
                }
            end
        end

        TriggerClientEvent('mr-drugs:client:refreshAvailableDrugs', src, AvailableDrugs)
    else
        TriggerClientEvent('mr-drugs:client:cornerselling', src)
    end
end)

RegisterServerEvent('mr-drugs:server:robCornerDrugs')
AddEventHandler('mr-drugs:server:robCornerDrugs', function(item, amount, price)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local AvailableDrugs = {}

    Player.Functions.RemoveItem(item, amount)

    TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items[item], "remove")

    for i = 1, #Config.CornerSellingDrugsList, 1 do
        local item = Player.Functions.GetItemByName(Config.CornerSellingDrugsList[i])

        if item ~= nil then
            AvailableDrugs[#AvailableDrugs+1] = {
                item = item.name,
                amount = item.amount,
                label = MRFW.Shared.Items[item.name]["label"]
            }
        end
    end

    TriggerClientEvent('mr-drugs:client:refreshAvailableDrugs', src, AvailableDrugs)
end)