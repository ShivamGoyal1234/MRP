local MRFW = exports['mrfw']:GetCoreObject()

MRFW.Functions.CreateUseableItem("headbag", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
    TriggerClientEvent('mr-headbag:puton', source, 'from item')
end)

RegisterNetEvent('mr-handbag:MaskPlayer', function(playerId, types)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local MaskedPlayer = MRFW.Functions.GetPlayer(playerId)
    if MaskedPlayer then
        if (MaskedPlayer.PlayerData.metadata["ishandcuffed"] or MaskedPlayer.PlayerData.metadata["inlaststand"] or MaskedPlayer.PlayerData.metadata["isdead"]) then
            if types == 'from item' then
                if Player.Functions.GetItemByName("headbag") then
                    TriggerClientEvent("mr-handbag:GetMasked", MaskedPlayer.PlayerData.source, Player.PlayerData.source, types)
                end
            elseif type(types) == 'table' then
                TriggerClientEvent("mr-handbag:GetMasked", MaskedPlayer.PlayerData.source, Player.PlayerData.source, types)
            end
        else
            TriggerClientEvent('MRFW:Notify', src, "He not cuffed nor dead", 'error')
        end
    else
        TriggerClientEvent('MRFW:Notify', src, "No One Nearby", 'error')
    end
end)

RegisterNetEvent('mr-headbag:item',function(src, type)
    local Player = MRFW.Functions.GetPlayer(src)
    if type == 'add' then 
        Player.Functions.AddItem("headbag", 1)
        TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items["headbag"], "add")
    elseif type == 'remove' then
        Player.Functions.RemoveItem("headbag", 1)
	    TriggerClientEvent("inventory:client:ItemBox", source, MRFW.Shared.Items["headbag"], "remove")
    end
end)