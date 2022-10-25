RegisterServerEvent('json:dataStructure')
AddEventHandler('json:dataStructure', function(data)
    -- ??
end)

RegisterServerEvent('mr-radialmenu:trunk:server:Door')
AddEventHandler('mr-radialmenu:trunk:server:Door', function(open, plate, door)
    TriggerClientEvent('mr-radialmenu:trunk:client:Door', -1, plate, door, open)
end)

RegisterServerEvent('police:server:takeoffmask')
AddEventHandler('police:server:takeoffmask', function(playerId)
    local MaskedPlayer = MRFW.Functions.GetPlayer(playerId)
    if (MaskedPlayer.PlayerData.metadata["ishandcuffed"] or MaskedPlayer.PlayerData.metadata["inlaststand"] or MaskedPlayer.PlayerData.metadata["isdead"]) then
        TriggerClientEvent("police:client:takeoffmaskc", MaskedPlayer.PlayerData.source)
    else
        TriggerClientEvent("MRFW:Notify", src, "This Person is not cuffed or dead", "error", 10000)
    end
end)