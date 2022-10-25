local AJFW = exports['ajfw']:GetCoreObject()

AJFW.Functions.CreateUseableItem("radio", function(source, item)
    TriggerClientEvent('aj-radio:use', source)
end)

AJFW.Functions.CreateCallback('aj-radio:server:GetItem', function(source, cb, item)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    if Player ~= nil then
        local RadioItem = Player.Functions.GetItemByName(item)
        if RadioItem ~= nil and not Player.PlayerData.metadata["isdead"] and
            not Player.PlayerData.metadata["inlaststand"] then
            cb(true)
        else
            cb(false)
        end
    else
        cb(false)
    end
end)

for channel, config in pairs(Config.RestrictedChannels) do
    exports['pma-voice']:addChannelCheck(channel, function(source)
        local Player = AJFW.Functions.GetPlayer(source)
        return config[Player.PlayerData.job.name] and Player.PlayerData.job.onduty
    end)
end

AJFW.Commands.Add('radio', 'Open Radio', {}, false, function(source, args)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    if Player ~= nil then
        local has = Player.Functions.GetItemByName("radio")
        if has then
            TriggerClientEvent('aj-radio:use', source)
        end
    end
end)