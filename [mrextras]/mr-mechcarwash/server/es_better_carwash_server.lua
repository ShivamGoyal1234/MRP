-- MRFW = nil
-- TriggerEvent('MRFW:GetObject', function(obj) MRFW = obj end)

RegisterServerEvent('es_better_carwash:checkmoney')
AddEventHandler('es_better_carwash:checkmoney',function(amount)
    local src = source
    local ply = MRFW.Functions.GetPlayer(src)
    local cashamount = ply.PlayerData.money["cash"]
    local amount = tonumber(amount)
	TriggerClientEvent('es_better_carwash:success', source, 25)
end)

RegisterServerEvent('es_better_carwash:checkmoney2')
AddEventHandler('es_better_carwash:checkmoney2',function(amount)
    local src = source
    local ply = MRFW.Functions.GetPlayer(src)
    local cashamount = ply.PlayerData.money["cash"]
    local amount = tonumber(amount)
	TriggerClientEvent('es_better_carwash:success2', source, 25)
end)