local MRFW = exports['mrfw']:GetCoreObject()

-- Get permissions --

MRFW.Functions.CreateCallback('mr-anticheat:server:GetPermissions', function(source, cb)
    local group = MRFW.Functions.GetPermission(source)
    cb(group)
end)

-- Execute ban --

RegisterNetEvent('mr-anticheat:server:banPlayer', function(reason)
    local src = source
    TriggerEvent("mr-log:server:CreateLog", "anticheat", "Anti-Cheat", "white", GetPlayerName(src).." has been banned for "..reason, false)
    MySQL.Async.execute('INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)', {
        GetPlayerName(src),
        MRFW.Functions.GetIdentifier(src, 'license'),
        MRFW.Functions.GetIdentifier(src, 'discord'),
        MRFW.Functions.GetIdentifier(src, 'ip'),
        reason,
        2145913200,
        'Anti-Cheat'
    })
    DropPlayer(src, "You have been banned for cheating. Check our Discord for more information: " .. MRFW.Config.Server.discord)
end)

-- Fake events --
function NonRegisteredEventCalled(CalledEvent, source)
    TriggerClientEvent("mr-anticheat:client:NonRegisteredEventCalled", source, "Cheating", CalledEvent)
end


for x, v in pairs(Config.BlacklistedEvents) do
    RegisterServerEvent(v)
    AddEventHandler(v, function(source)
        NonRegisteredEventCalled(v, source)
    end)
end



-- RegisterServerEvent('banking:withdraw')
-- AddEventHandler('banking:withdraw', function(source)
--     NonRegisteredEventCalled('bank:withdraw', source)
-- end)

MRFW.Functions.CreateCallback('mr-anticheat:server:HasWeaponInInventory', function(source, cb, WeaponInfo)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local PlayerInventory = Player.PlayerData.items
    local retval = false

    for k, v in pairs(PlayerInventory) do
        if v.name == WeaponInfo["name"] then
            retval = true
        end
    end
    cb(retval)
end)
