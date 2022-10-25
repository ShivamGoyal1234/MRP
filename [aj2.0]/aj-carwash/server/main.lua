-- AJFW = nil
-- TriggerEvent('AJFW:GetObject', function(obj) AJFW = obj end)

-- Code

RegisterServerEvent('aj-carwash:server:washCar')
AddEventHandler('aj-carwash:server:washCar', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)

    if Player.Functions.RemoveMoney('cash', Config.DefaultPrice, "car-washed") then
        TriggerClientEvent('aj-carwash:client:washCar', src)
    elseif Player.Functions.RemoveMoney('bank', Config.DefaultPrice, "car-washed") then
        TriggerClientEvent('aj-carwash:client:washCar', src)
    else
        TriggerClientEvent('AJFW:Notify', src, 'You dont have enough money..', 'error')
    end
end)