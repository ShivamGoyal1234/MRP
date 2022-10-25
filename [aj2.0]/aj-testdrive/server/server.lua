AJFW = exports['ajfw']:GetCoreObject()

RegisterServerEvent('aj-testdrive.requestInfo')
AddEventHandler('aj-testdrive.requestInfo', function()
    local src = source
    local xPlayer = AJFW.Functions.GetPlayer(src)
    local rows    

    TriggerClientEvent('aj-testdrive.receiveInfo', src, xPlayer.PlayerData.money['bank'], xPlayer.PlayerData.firstname)
    --TriggerClientEvent("aj-testdrive.notify", src, 'error', 'Use A and D To Rotate')
    TriggerClientEvent("AJFW:Notify", src, "Use A and D To Rotate", "error", 5000)
end)

AJFW.Functions.CreateCallback('aj-testdrive.isPlateTaken', function (source, cb, plate)
    local db = MySQL.Sync.fetchAll('SELECT * FROM player_vehicles WHERE plate = ?', {plate})
    if db ~= nil then
        cb(db[1] ~= nil)
    else
        cb(nil)
    end
end)

RegisterServerEvent('aj-testdrive.CheckMoneyForVeh')
AddEventHandler('aj-testdrive.CheckMoneyForVeh', function(veh, price, name, vehicleProps)
    local src = source
    local xPlayer = AJFW.Functions.GetPlayer(src)

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
        TriggerClientEvent("aj-testdrive.successfulbuy", source, name, vehicleProps.plate, price)
        TriggerClientEvent('aj-testdrive.receiveInfo', source, xPlayer.PlayerData.money['bank'])    
        TriggerClientEvent('aj-testdrive.spawnVehicle', source, veh, vehicleProps.plate)
    else
        --TriggerClientEvent("aj-testdrive.notify", source, 'error', 'Not Enough Money')
        TriggerClientEvent("AJFW:Notify", source, "Not Enough Money", "error", 5000)
    end
end)

RegisterServerEvent('aj-testdrive.CheckMoneyForTest')
AddEventHandler('aj-testdrive.CheckMoneyForTest', function()
    local src = source
    local xPlayer = AJFW.Functions.GetPlayer(src)
    local price = tonumber(50)

    if xPlayer.PlayerData.money['bank'] >= price then
        --xPlayer.Functions.RemoveMoney('bank', tonumber(price))

        TriggerClientEvent('aj-moneysafe:client:DepositMoney', source , price)
    else
        TriggerClientEvent("aj-testdrive.notify", source, 'error', 'Not Enough Money')
    end
end)


AJFW.Functions.CreateCallback('aj-testdrive.ghuu', function(source, cb)
    local src = source
    local Ply = AJFW.Functions.GetPlayer(src)
	local poo = 50
    local paisamc = Ply.PlayerData.money['bank']

    if paisamc >= poo then
        cb(true)
    else
        cb(false)
    end
end)