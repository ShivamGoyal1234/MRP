local MRFW = exports['mrfw']:GetCoreObject()

local chicken = 1500

MRFW.Functions.CreateCallback('mr-customs:getMechanic', function(source, cb)
    local retval = false
    local count = MRFW.Functions.GetDutyCount('mechanic')
    local count2 = MRFW.Functions.GetDutyCount('bennys')
    if count or count2 then
        if count > 0 or count2 > 0 then
            retval = true
        end
    end
    cb(retval)
end)

RegisterNetEvent('mr-customs:attemptPurchase', function(type, upgradeLevel)
    local source = source
    local Player = MRFW.Functions.GetPlayer(source)
    local balance = nil
    -- if Player.PlayerData.job.name == "mechanic" then
        -- balance = exports['mr-bossmenu']:GetAccount(Player.PlayerData.job.name)
    -- else
        balance = Player.Functions.GetMoney(moneyType)
    -- end
    if type == "repair" then
        if balance >= chicken then
            Player.Functions.RemoveMoney(moneyType, chicken, "bennys")
                TriggerEvent('mr-bossmenu:server:addAccountMoney', Player.PlayerData.job.name, chicken)
            TriggerClientEvent('mr-customs:purchaseSuccessful', source)
        else
            TriggerClientEvent('mr-customs:purchaseFailed', source)
        end
    elseif type == "performance" then
        if balance >= vehicleCustomisationPrices[type].prices[upgradeLevel] then
            TriggerClientEvent('mr-customs:purchaseSuccessful', source)
            -- if Player.PlayerData.job.name == "mechanic" then
                -- TriggerEvent('mr-bossmenu:server:removeAccountMoney', Player.PlayerData.job.name, vehicleCustomisationPrices[type].prices[upgradeLevel])
            -- else
                Player.Functions.RemoveMoney(moneyType, vehicleCustomisationPrices[type].prices[upgradeLevel], "bennys")
                TriggerEvent('mr-bossmenu:server:addAccountMoney', Player.PlayerData.job.name, vehicleCustomisationPrices[type].prices[upgradeLevel])
            -- end
        else
            TriggerClientEvent('mr-customs:purchaseFailed', source)
        end
    else
        if balance >= vehicleCustomisationPrices[type].price then
            TriggerClientEvent('mr-customs:purchaseSuccessful', source)
            -- if Player.PlayerData.job.name == "mechanic" then
                -- TriggerEvent('mr-bossmenu:server:removeAccountMoney', Player.PlayerData.job.name,
                    -- vehicleCustomisationPrices[type].price)
            -- else
                Player.Functions.RemoveMoney(moneyType, vehicleCustomisationPrices[type].price, "bennys")
                TriggerEvent('mr-bossmenu:server:addAccountMoney', Player.PlayerData.job.name, vehicleCustomisationPrices[type].price)

            -- end
        else
            TriggerClientEvent('mr-customs:purchaseFailed', source)
        end
    end
end)

RegisterNetEvent('mr-customs:updateRepairCost', function(cost)
    chicken = cost
end)

RegisterNetEvent("updateVehicle", function(myCar)
    local src = source
    if IsVehicleOwned(myCar.plate) then
        MySQL.Async.execute('UPDATE player_vehicles SET mods = ? WHERE plate = ?', {json.encode(myCar), myCar.plate})
    end
end)

MRFW.Commands.Add('customs', 'help text here', {}, false, function(source, args)
    local player = tonumber(args[1])
    if player ~= nil then
        local Player = MRFW.Functions.GetPlayer(player)
        if Player ~= nil then
            TriggerClientEvent('event:openfor:admins', player)
        else
            TriggerClientEvent("MRFW:Notify", source, "Player Not Online", "error", 3000)
        end
    else
        TriggerClientEvent('event:openfor:admins', source)
    end
end, 'manager')

function IsVehicleOwned(plate)
    local retval = false
    local result = MySQL.Sync.fetchScalar('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
    if result then
        retval = true
    end
    return retval
end