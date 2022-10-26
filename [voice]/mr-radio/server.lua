local MRFW = exports['mrfw']:GetCoreObject()

MRFW.Functions.CreateUseableItem("radio", function(source, item)
    TriggerClientEvent('mr-radio:use', source)
end)

MRFW.Functions.CreateCallback('mr-radio:server:GetItem', function(source, cb, item)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
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
        local Player = MRFW.Functions.GetPlayer(source)
        return config[Player.PlayerData.job.name] and Player.PlayerData.job.onduty
    end)
end

MRFW.Commands.Add('radio', 'Open Radio', {}, false, function(source, args)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player ~= nil then
        local has = Player.Functions.GetItemByName("radio")
        if has then
            TriggerClientEvent('mr-radio:use', source)
        end
    end
end)