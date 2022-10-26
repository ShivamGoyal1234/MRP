-- MRFW = nil
-- TriggerEvent('MRFW:GetObject', function(obj) MRFW = obj end)

-- Code

RegisterServerEvent('mr-carwash:server:washCar')
AddEventHandler('mr-carwash:server:washCar', function()
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)

    if Player.Functions.RemoveMoney('cash', Config.DefaultPrice, "car-washed") then
        TriggerClientEvent('mr-carwash:client:washCar', src)
    elseif Player.Functions.RemoveMoney('bank', Config.DefaultPrice, "car-washed") then
        TriggerClientEvent('mr-carwash:client:washCar', src)
    else
        TriggerClientEvent('MRFW:Notify', src, 'You dont have enough money..', 'error')
    end
end)