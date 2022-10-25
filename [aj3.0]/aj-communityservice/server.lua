AJFW = exports['ajfw']:GetCoreObject()
-- Commands

AJFW.Commands.Add('comserv', 'Send To Community Service', {{name='id', help='Target ID'}, {name='amount', help='Action Amount'}}, true, function(source, args)
    local src = source
    local target = tonumber(args[1])
    local targetPlayer = GetPlayerPed(target)
    local amount = tonumber(args[2])
    local Player = AJFW.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "police" then
        if targetPlayer ~= 0 then
            if amount > 0 then
                TriggerEvent('aj-communityservice:server:sendToCommunityService', target, amount)
                TriggerClientEvent('AJFW:Notify', source, 'This citizen has been sentenced to community service!', 'success')
                TriggerClientEvent('AJFW:Notify', target, 'You Have Been Sentenced To '..amount.. ' Month(s) of Community Service')
            else
                TriggerClientEvent('AJFW:Notify', source, 'Invalid amount of months', 'error')
            end
        else
            TriggerClientEvent('AJFW:Notify', source, 'Invalid citizen ID', 'error')
        end
    else
        TriggerClientEvent('AJFW:Notify', source, 'You are not a police officer', 'error')
    end
end, 'police')

AJFW.Commands.Add('endcomserv', 'End Community Service', {{name='id', help='Target ID'}}, true, function(source, args)
    local src = source
    local target = tonumber(args[1])
    local targetPlayer = GetPlayerPed(target)
    local Player = AJFW.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "police" then
        if targetPlayer ~= 0 then
            Release(target)
        else
            TriggerClientEvent('AJFW:Notify', source, 'Invalid citizen ID', 'error')
        end
    else
        TriggerClientEvent('AJFW:Notify', source, 'You are not a police officer', 'error')
    end
end, 'police')

RegisterServerEvent('aj-communityservice:server:finishCommunityService')
AddEventHandler('aj-communityservice:server:finishCommunityService', function()
    local src = source
	Release(src)
end)

-- Events

RegisterServerEvent('aj-communityservice:server:checkIfSentenced')
AddEventHandler('aj-communityservice:server:checkIfSentenced', function()
    local src = source
    local citizenid = AJFW.Functions.GetPlayer(src).PlayerData.citizenid
    local result = MySQL.Sync.fetchAll('SELECT * FROM communityservice WHERE citizenid = ?', {citizenid})
    if result[1] ~= nil and result[1].actions_remaining > 0 then
        TriggerClientEvent('aj-communityservice:client:inCommunityService', src, tonumber(result[1].actions_remaining))
    end
end)

RegisterServerEvent('aj-communityservice:server:completeService')
AddEventHandler('aj-communityservice:server:completeService', function()
    local src = source
    local citizenid = AJFW.Functions.GetPlayer(src).PlayerData.citizenid
    MySQL.Async.execute('UPDATE communityservice SET actions_remaining = actions_remaining - 1 WHERE citizenid = ?', {citizenid})
end)

RegisterServerEvent('aj-communityservice:server:extendService')
AddEventHandler('aj-communityservice:server:extendService', function()
    local src = source
    local citizenid = AJFW.Functions.GetPlayer(src).PlayerData.citizenid
    MySQL.Async.execute('UPDATE communityservice SET actions_remaining = actions_remaining + ? WHERE citizenid = ?', {citizenid, Config.ServiceExtensionOnEscape})
end)

RegisterServerEvent('aj-communityservice:server:sendToCommunityService')
AddEventHandler('aj-communityservice:server:sendToCommunityService', function(target, actions_count)
    local Ply = AJFW.Functions.GetPlayer(target)
    local citizenid = Ply.PlayerData.citizenid
    
    MySQL.Async.insert('INSERT INTO communityservice (citizenid, actions_remaining) VALUES (?, ?) ON DUPLICATE KEY UPDATE actions_remaining = ?', {citizenid, actions_count, actions_count})
    TriggerClientEvent('aj-communityservice:client:inCommunityService', target, actions_count)
end)

-- Functions

function Release(target)
    local Ply = AJFW.Functions.GetPlayer(target)
    local citizenid = Ply.PlayerData.citizenid

    MySQL.Async.execute('DELETE FROM communityservice WHERE citizenid = ?', {citizenid})
    TriggerClientEvent('AJFW:Notify', target, 'Community service completed', 'success')
    TriggerClientEvent('aj-communityservice:client:finishCommunityService', target)
end