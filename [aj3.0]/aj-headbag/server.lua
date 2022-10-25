local AJFW = exports['ajfw']:GetCoreObject()

AJFW.Functions.CreateUseableItem("headbag", function(source, item)
    local Player = AJFW.Functions.GetPlayer(source)
    TriggerClientEvent('aj-headbag:puton', source, 'from item')
end)

RegisterNetEvent('aj-handbag:MaskPlayer', function(playerId, types)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local MaskedPlayer = AJFW.Functions.GetPlayer(playerId)
    if MaskedPlayer then
        if (MaskedPlayer.PlayerData.metadata["ishandcuffed"] or MaskedPlayer.PlayerData.metadata["inlaststand"] or MaskedPlayer.PlayerData.metadata["isdead"]) then
            if types == 'from item' then
                if Player.Functions.GetItemByName("headbag") then
                    TriggerClientEvent("aj-handbag:GetMasked", MaskedPlayer.PlayerData.source, Player.PlayerData.source, types)
                end
            elseif type(types) == 'table' then
                TriggerClientEvent("aj-handbag:GetMasked", MaskedPlayer.PlayerData.source, Player.PlayerData.source, types)
            end
        else
            TriggerClientEvent('AJFW:Notify', src, "He not cuffed nor dead", 'error')
        end
    else
        TriggerClientEvent('AJFW:Notify', src, "No One Nearby", 'error')
    end
end)

RegisterNetEvent('aj-headbag:item',function(src, type)
    local Player = AJFW.Functions.GetPlayer(src)
    if type == 'add' then 
        Player.Functions.AddItem("headbag", 1)
        TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items["headbag"], "add")
    elseif type == 'remove' then
        Player.Functions.RemoveItem("headbag", 1)
	    TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items["headbag"], "remove")
    end
end)