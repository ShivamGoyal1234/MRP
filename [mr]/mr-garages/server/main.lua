local OutsideVehicles = {}

-- code

RegisterServerEvent('mr-garages:server:UpdateOutsideVehicles')
AddEventHandler('mr-garages:server:UpdateOutsideVehicles', function(Vehicles)
    local src = source
    local Ply = MRFW.Functions.GetPlayer(src)
    local CitizenId = Ply.PlayerData.citizenid

    OutsideVehicles[CitizenId] = Vehicles
end)

MRFW.Functions.CreateCallback("mr-garage:server:checkVehicleOwner", function(source, cb, plate, type2)
    local src = source
    local pData = MRFW.Functions.GetPlayer(src)

    MySQL.Async.fetchAll('SELECT * FROM player_vehicles WHERE plate = ? AND citizenid = ?',
        {plate, pData.PlayerData.citizenid}, function(result)
            if result[1] ~= nil then
                if result[1].type == type2 then
                    cb(true, true)
                else
                    cb(true,false)
                end
            else
                cb(false)
            end
        end)
end)

MRFW.Functions.CreateCallback("mr-garage:server:GetOutsideVehicles", function(source, cb)
    local Ply = MRFW.Functions.GetPlayer(source)
    local CitizenId = Ply.PlayerData.citizenid

    if OutsideVehicles[CitizenId] ~= nil and next(OutsideVehicles[CitizenId]) ~= nil then
        cb(OutsideVehicles[CitizenId])
    else
        cb(nil)
    end
end)

MRFW.Functions.CreateCallback("mr-garage:server:GetUserVehicles", function(source, cb, garage)
    local src = source
    local pData = MRFW.Functions.GetPlayer(src)
    MySQL.Async.fetchAll('SELECT * FROM player_vehicles WHERE citizenid = ? AND garage = ?', {pData.PlayerData.citizenid, garage}, function(result)
        if result[1] ~= nil then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

MRFW.Functions.CreateCallback("mr-garage:server:GetVehicleProperties", function(source, cb, plate)
    local src = source
    local properties = {}
    local result = MySQL.Sync.fetchAll('SELECT mods FROM player_vehicles WHERE plate = ?', {plate})
    if result[1] ~= nil then
        properties = json.decode(result[1].mods)
    end
    cb(properties)
end)

MRFW.Functions.CreateCallback("mr-garage:server:GetDepotVehicles", function(source, cb)
    local src = source
    local pData = MRFW.Functions.GetPlayer(src)

    MySQL.Async.fetchAll('SELECT * FROM player_vehicles WHERE citizenid = ? AND state = ?',
        {pData.PlayerData.citizenid, 0}, function(result)
            if result[1] ~= nil then
                cb(result)
            else
                cb(nil)
            end
        end)
end)

MRFW.Functions.CreateCallback("mr-garage:server:GetHouseVehicles", function(source, cb, house)
    local src = source
    local pData = MRFW.Functions.GetPlayer(src)

    MySQL.Async.fetchAll('SELECT * FROM player_vehicles WHERE garage = ?', {house}, function(result)
        if result[1] ~= nil then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

MRFW.Functions.CreateCallback("mr-garage:server:checkVehicleHouseOwner", function(source, cb, plate, house)
    local src = source
    local pData = MRFW.Functions.GetPlayer(src)
    MySQL.Async.fetchAll('SELECT * FROM player_vehicles WHERE plate = ?', {plate}, function(result)
        if result[1] ~= nil then
            local hasHouseKey = exports['mr-houses']:hasKey(result[1].license, result[1].citizenid, house)
            if hasHouseKey then
                cb(true)
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)
end)

RegisterServerEvent('mr-garage:server:PayDepotPrice')
AddEventHandler('mr-garage:server:PayDepotPrice', function(vehicle, moods)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local bankBalance = Player.PlayerData.money["bank"]
    MySQL.Async.fetchAll('SELECT * FROM player_vehicles WHERE plate = ?', {vehicle.plate}, function(result)
        if result[1] ~= nil then
            -- if Player.Functions.RemoveMoney("cash", result[1].depotprice, "paid-depot") then
            --     TriggerClientEvent("mr-garages:client:takeOutDepot", src, vehicle, garage)
            -- else
            if bankBalance >= result[1].depotprice then
                
                TriggerClientEvent("mr-garages:client:takeOutDepot", src, vehicle, moods, result[1].depotprice)
            end
        end
    end)
end)

RegisterServerEvent('mr-garage:server:confirmDepot')
AddEventHandler('mr-garage:server:confirmDepot', function(price)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    Player.Functions.RemoveMoney("bank", price, "paid-depot")
end)

RegisterServerEvent('mr-garage:server:updateVehicleState')
AddEventHandler('mr-garage:server:updateVehicleState', function(state, plate, garage)
    MySQL.Async.execute('UPDATE player_vehicles SET state = ?, garage = ?, depotprice = ? WHERE plate = ?',
        {state, garage, 600, plate})
end)

RegisterServerEvent('mr-garage:server:updateVehicleStatus')
AddEventHandler('mr-garage:server:updateVehicleStatus', function(fuel, engine, body, plate, garage)
    local src = source
    local pData = MRFW.Functions.GetPlayer(src)

    if engine > 1000 then
        engine = engine / 1000
    end

    if body > 1000 then
        body = body / 1000
    end

    MySQL.Async.execute(
        'UPDATE player_vehicles SET fuel = ?, engine = ?, body = ? WHERE plate = ? AND citizenid = ? AND garage = ?',
        {fuel, engine, body, plate, pData.PlayerData.citizenid, garage})
end)