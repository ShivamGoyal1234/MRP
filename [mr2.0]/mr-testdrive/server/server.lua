MRFW = exports['mrfw']:GetCoreObject()

RegisterServerEvent('mr-testdrive.requestInfo')
AddEventHandler('mr-testdrive.requestInfo', function()
    local src = source
    local xPlayer = MRFW.Functions.GetPlayer(src)
    local rows    

    TriggerClientEvent('mr-testdrive.receiveInfo', src, xPlayer.PlayerData.money['bank'], xPlayer.PlayerData.firstname)
    --TriggerClientEvent("mr-testdrive.notify", src, 'error', 'Use A and D To Rotate')
    TriggerClientEvent("MRFW:Notify", src, "Use A and D To Rotate", "error", 5000)
end)

MRFW.Functions.CreateCallback('mr-testdrive.isPlateTaken', function (source, cb, plate)
    local db = MySQL.Sync.fetchAll('SELECT * FROM player_vehicles WHERE plate = ?', {plate})
    if db ~= nil then
        cb(db[1] ~= nil)
    else
        cb(nil)
    end
end)

RegisterServerEvent('mr-testdrive.CheckMoneyForVeh')
AddEventHandler('mr-testdrive.CheckMoneyForVeh', function(veh, price, name, vehicleProps)
    local src = source
    local xPlayer = MRFW.Functions.GetPlayer(src)

    if xPlayer.PlayerData.money['bank'] >= tonumber(price) then
        xPlayer.Functions.RemoveMoney('bank', tonumber(price))
        local vehiclePropsjson = json.encode(vehicleProps)
        if Config.SpawnVehicle then
            stateVehicle = 0
        else
            stateVehicle = 1
        end
        MySQL.Async.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state) VALUES (?, ?, ?, ?, ?, ?, ?)', 
            {xPlayer.PlayerData.license, xPlayer.PlayerData.citizenid, veh, GetHashKey(veh), vehiclePropsjson, vehicleProps.plate, stateVehicle})
        TriggerClientEvent("mr-testdrive.successfulbuy", source, name, vehicleProps.plate, price)
        TriggerClientEvent('mr-testdrive.receiveInfo', source, xPlayer.PlayerData.money['bank'])    
        TriggerClientEvent('mr-testdrive.spawnVehicle', source, veh, vehicleProps.plate)
    else
        --TriggerClientEvent("mr-testdrive.notify", source, 'error', 'Not Enough Money')
        TriggerClientEvent("MRFW:Notify", source, "Not Enough Money", "error", 5000)
    end
end)

RegisterServerEvent('mr-testdrive.CheckMoneyForTest')
AddEventHandler('mr-testdrive.CheckMoneyForTest', function()
    local src = source
    local xPlayer = MRFW.Functions.GetPlayer(src)
    local price = tonumber(50)

    if xPlayer.PlayerData.money['bank'] >= price then
        --xPlayer.Functions.RemoveMoney('bank', tonumber(price))

        TriggerClientEvent('mr-moneysafe:client:DepositMoney', source , price)
    else
        TriggerClientEvent("mr-testdrive.notify", source, 'error', 'Not Enough Money')
    end
end)


MRFW.Functions.CreateCallback('mr-testdrive.ghuu', function(source, cb)
    local src = source
    local Ply = MRFW.Functions.GetPlayer(src)
	local poo = 50
    local paisamc = Ply.PlayerData.money['bank']

    if paisamc >= poo then
        cb(true)
    else
        cb(false)
    end
end)