RegisterServerEvent('mr-radialmenu:server:RemoveStretcher')
AddEventHandler('mr-radialmenu:server:RemoveStretcher', function(PlayerPos, StretcherObject)
    TriggerClientEvent('mr-radialmenu:client:RemoveStretcherFromArea', -1, PlayerPos, StretcherObject)
end)

RegisterServerEvent('mr-radialmenu:Stretcher:BusyCheck')
AddEventHandler('mr-radialmenu:Stretcher:BusyCheck', function(id, type)
    local MyId = source
    TriggerClientEvent('mr-radialmenu:Stretcher:client:BusyCheck', id, MyId, type)
end)

RegisterServerEvent('mr-radialmenu:server:BusyResult')
AddEventHandler('mr-radialmenu:server:BusyResult', function(IsBusy, OtherId, type)
    TriggerClientEvent('mr-radialmenu:client:Result', OtherId, IsBusy, type)
end)
