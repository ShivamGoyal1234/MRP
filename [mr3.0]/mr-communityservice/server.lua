MRFW = exports['mrfw']:GetCoreObject()
-- Commands

MRFW.Commands.Add('comserv', 'Send To Community Service', {{name='id', help='Target ID'}, {name='amount', help='Action Amount'}}, true, function(source, args)
    local src = source
    local target = tonumber(args[1])
    local targetPlayer = GetPlayerPed(target)
    local amount = tonumber(args[2])
    local Player = MRFW.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "police" then
        if targetPlayer ~= 0 then
            if amount > 0 then
                TriggerEvent('mr-communityservice:server:sendToCommunityService', target, amount)
                TriggerClientEvent('MRFW:Notify', source, 'This citizen has been sentenced to community service!', 'success')
                TriggerClientEvent('MRFW:Notify', target, 'You Have Been Sentenced To '..amount.. ' Month(s) of Community Service')
            else
                TriggerClientEvent('MRFW:Notify', source, 'Invalid amount of months', 'error')
            end
        else
            TriggerClientEvent('MRFW:Notify', source, 'Invalid citizen ID', 'error')
        end
    else
        TriggerClientEvent('MRFW:Notify', source, 'You are not a police officer', 'error')
    end
end, 'police')

MRFW.Commands.Add('endcomserv', 'End Community Service', {{name='id', help='Target ID'}}, true, function(source, args)
    local src = source
    local target = tonumber(args[1])
    local targetPlayer = GetPlayerPed(target)
    local Player = MRFW.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "police" then
        if targetPlayer ~= 0 then
            Release(target)
        else
            TriggerClientEvent('MRFW:Notify', source, 'Invalid citizen ID', 'error')
        end
    else
        TriggerClientEvent('MRFW:Notify', source, 'You are not a police officer', 'error')
    end
end, 'police')

RegisterServerEvent('mr-communityservice:server:finishCommunityService')
AddEventHandler('mr-communityservice:server:finishCommunityService', function()
    local src = source
	Release(src)
end)

-- Events

RegisterServerEvent('mr-communityservice:server:checkIfSentenced')
AddEventHandler('mr-communityservice:server:checkIfSentenced', function()
    local src = source
    local citizenid = MRFW.Functions.GetPlayer(src).PlayerData.citizenid
    local result = MySQL.Sync.fetchAll('SELECT * FROM communityservice WHERE citizenid = ?', {citizenid})
    if result[1] ~= nil and result[1].actions_remaining > 0 then
        TriggerClientEvent('mr-communityservice:client:inCommunityService', src, tonumber(result[1].actions_remaining))
    end
end)

RegisterServerEvent('mr-communityservice:server:completeService')
AddEventHandler('mr-communityservice:server:completeService', function()
    local src = source
    local citizenid = MRFW.Functions.GetPlayer(src).PlayerData.citizenid
    MySQL.Async.execute('UPDATE communityservice SET actions_remaining = actions_remaining - 1 WHERE citizenid = ?', {citizenid})
end)

RegisterServerEvent('mr-communityservice:server:extendService')
AddEventHandler('mr-communityservice:server:extendService', function()
    local src = source
    local citizenid = MRFW.Functions.GetPlayer(src).PlayerData.citizenid
    MySQL.Async.execute('UPDATE communityservice SET actions_remaining = actions_remaining + ? WHERE citizenid = ?', {citizenid, Config.ServiceExtensionOnEscape})
end)

RegisterServerEvent('mr-communityservice:server:sendToCommunityService')
AddEventHandler('mr-communityservice:server:sendToCommunityService', function(target, actions_count)
    local Ply = MRFW.Functions.GetPlayer(target)
    local citizenid = Ply.PlayerData.citizenid
    
    MySQL.Async.insert('INSERT INTO communityservice (citizenid, actions_remaining) VALUES (?, ?) ON DUPLICATE KEY UPDATE actions_remaining = ?', {citizenid, actions_count, actions_count})
    TriggerClientEvent('mr-communityservice:client:inCommunityService', target, actions_count)
end)

-- Functions

function Release(target)
    local Ply = MRFW.Functions.GetPlayer(target)
    local citizenid = Ply.PlayerData.citizenid

    MySQL.Async.execute('DELETE FROM communityservice WHERE citizenid = ?', {citizenid})
    TriggerClientEvent('MRFW:Notify', target, 'Community service completed', 'success')
    TriggerClientEvent('mr-communityservice:client:finishCommunityService', target)
end