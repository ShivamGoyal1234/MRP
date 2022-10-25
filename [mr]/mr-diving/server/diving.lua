local CurrentDivingArea = math.random(1, #MRDiving.Locations)

MRFW.Functions.CreateCallback('mr-diving:server:GetDivingConfig', function(source, cb)
    cb(MRDiving.Locations, CurrentDivingArea)
end)
RegisterNetEvent('mr-diving:server:TakeCoral', function(Area, Coral, Bool)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local CoralType = math.random(1, #MRDiving.CoralTypes)
    local Amount = math.random(1, MRDiving.CoralTypes[CoralType].maxAmount)
    local ItemData = MRFW.Shared.Items[MRDiving.CoralTypes[CoralType].item]

    if Amount > 1 then
        for i = 1, Amount, 1 do
            Player.Functions.AddItem(ItemData["name"], 1)
            TriggerClientEvent('inventory:client:ItemBox', src, ItemData, "add")
            Wait(250)
        end
    else
        Player.Functions.AddItem(ItemData["name"], Amount)
        TriggerClientEvent('inventory:client:ItemBox', src, ItemData, "add")
    end

    if (MRDiving.Locations[Area].TotalCoral - 1) == 0 then
        for k, v in pairs(MRDiving.Locations[CurrentDivingArea].coords.Coral) do
            v.PickedUp = false
        end
        MRDiving.Locations[CurrentDivingArea].TotalCoral = MRDiving.Locations[CurrentDivingArea].DefaultCoral

        local newLocation = math.random(1, #MRDiving.Locations)
        while (newLocation == CurrentDivingArea) do
            Wait(3)
            newLocation = math.random(1, #MRDiving.Locations)
        end
        CurrentDivingArea = newLocation
        
        TriggerClientEvent('mr-diving:client:NewLocations', -1)
    else
        MRDiving.Locations[Area].coords.Coral[Coral].PickedUp = Bool
        MRDiving.Locations[Area].TotalCoral = MRDiving.Locations[Area].TotalCoral - 1
    end

    TriggerClientEvent('mr-diving:server:UpdateCoral', -1, Area, Coral, Bool)
end)

RegisterNetEvent('mr-diving:server:RemoveGear', function()
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)

    Player.Functions.RemoveItem("diving_gear", 1)
    TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items["diving_gear"], "remove")
end)

RegisterNetEvent('mr-diving:server:GiveBackGear', function(item)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local infos = {}
          infos.quality = item.info.uses - 1
          if infos.uses <= 0 then
            infos.uses = 0
          end
    Player.Functions.AddItem("diving_gear", 1, nil, infos)
    TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items["diving_gear"], "add")
end)