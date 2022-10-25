-- Variables
local MRFW = exports['mrfw']:GetCoreObject()
local frozen = false
local permissions = {
    ['kill'] = 'god',
    ['ban'] = 'god',
    ['noclip'] = 'admin',
    ['kickall'] = 'god',
    ['kick'] = 'admin'
}

-- Get Dealers
MRFW.Functions.CreateCallback('test:getdealers', function(source, cb)
    cb(exports['mr-drugs']:GetDealers())
end)

-- Get Players
MRFW.Functions.CreateCallback('test:getplayers', function(source, cb) -- WORKS
    local players = {}
    for k, v in pairs(MRFW.Functions.GetPlayers()) do
        local targetped = GetPlayerPed(v)
        local ped = MRFW.Functions.GetPlayer(v)
        players[#players+1] = {
            name = ped.PlayerData.charinfo.firstname .. ' ' .. ped.PlayerData.charinfo.lastname .. ' | (' .. GetPlayerName(v) .. ')',
            id = v,
            coords = GetEntityCoords(targetped),
            cid = ped.PlayerData.charinfo.firstname .. ' ' .. ped.PlayerData.charinfo.lastname,
            citizenid = ped.PlayerData.citizenid,
            sources = GetPlayerPed(ped.PlayerData.source),
            sourceplayer= ped.PlayerData.source

        }
    end
        table.sort(players, function(a, b)
            return a.id < b.id
        end)
    cb(players)
end)

MRFW.Functions.CreateCallback('mr-admin:server:getrank', function(source, cb)
    local src = source
    if MRFW.Functions.HasPermission(src, 'owner') or MRFW.Functions.HasPermission(src, 'dev') or IsPlayerAceAllowed(src, 'command') then
        cb(true, MRFW.Functions.GetPermission(src))
    else
        cb(false)
    end
end)

-- Functions

local function tablelength(table)
    local count = 0
    for _ in pairs(table) do
        count = count + 1
    end
    return count
end

-- Events

-- RegisterNetEvent('mr-admin:server:GetPlayersForBlipsCustom', function()
--     -- print()
--     local players = MRFW.Functions.GetMR-Players()
--     local dutyPlayers = {}
--     for k, v in pairs(players) do
--         local coords = GetEntityCoords(GetPlayerPed(v.PlayerData.source))
--         local heading = GetEntityHeading(GetPlayerPed(v.PlayerData.source))
--         dutyPlayers[#dutyPlayers+1] = {
--             source = v.PlayerData.source,
--             label = v.PlayerData.name,
--             job = v.PlayerData.charinfo.firstname.." "..v.PlayerData.charinfo.lastname,
--             location = {
--                 x = coords.x,
--                 y = coords.y,
--                 z = coords.z,
--                 w = heading
--             }
--         }
--     end
--     TriggerClientEvent("mr-admin:client:GetPlayersForBlipsCustom", source, dutyPlayers)
-- end)

RegisterNetEvent('mr-admin:server:GetPlayersForBlips', function()
    local src = source
    local players = {}
    for k, v in pairs(MRFW.Functions.GetPlayers()) do
        local targetped = GetPlayerPed(v)
        local ped = MRFW.Functions.GetPlayer(v)
        local firstname
        local lastname
        local citizenid
        local sourcesss
        local isAdmin
        local job
        local onduty
        if ped ~= nil then
            if ped.PlayerData ~= nil then
                if ped.PlayerData.charinfo ~= nil then
                    if ped.PlayerData.charinfo.firstname ~= nil then
                        firstname = ped.PlayerData.charinfo.firstname
                    else
                        firstname = ' Null '
                    end
                    if ped.PlayerData.charinfo.lastname ~= nil then
                        lastname = ped.PlayerData.charinfo.lastname
                    else
                        lastname = ' Null '
                    end
                else
                    firstname = ' Null '
                    lastname = ' Null '
                end
                if ped.PlayerData.citizenid ~= nil then
                    citizenid = ped.PlayerData.citizenid
                else
                    citizenid = ' Null '
                end
                if ped.PlayerData.source ~= nil then
                    if MRFW.Functions.GetPermission(ped.PlayerData.source) ~= nil then
                        isAdmin = MRFW.Functions.GetPermission(ped.PlayerData.source)
                    else
                        isAdmin = ' user '
                    end
                    sourcesss = ped.PlayerData.source
                else
                    sourcesss = ' Null '
                    isAdmin = ' user '
                end
                if ped.PlayerData.job  ~= nil then
                    if ped.PlayerData.job.name ~= nil then
                        job = ped.PlayerData.job.name
                    else
                        job = ' Null '
                    end
                else
                    job = ' Null '
                end
                if ped.PlayerData.job  ~= nil then
                    if ped.PlayerData.job.onduty ~= nil then
                        onduty = ped.PlayerData.job.onduty
                    else
                        onduty = ' Null '
                    end
                else
                    onduty = ' Null '
                end
            else
                firstname = ' Null '
                lastname = ' Null '
                citizenid = ' Null '
                citizenid = ' Null '
                job = ' Null '
                onduty = ' Null '
                isAdmin = ' user '
            end
        else
            firstname = ' Null '
            lastname = ' Null '
            citizenid = ' Null '
            citizenid = ' Null '
            job = ' Null '
            onduty = ' Null '
            isAdmin = ' user '
        end
        players[#players+1] = {
            name = firstname .. ' ' .. lastname .. ' | ' .. GetPlayerName(v),
            id = v,
            coords = GetEntityCoords(targetped),
            cid = firstname .. ' ' .. lastname,
            citizenid = citizenid,
            sources = GetPlayerPed(sourcesss),
            sourceplayer= sourcesss,
            admin = isAdmin,
            job = job,
            duty = onduty,
        }
    end
    TriggerClientEvent('mr-admin:client:Show', src, players)
end)

RegisterNetEvent('mr-admin:server:kill', function(player)
    TriggerClientEvent('hospital:client:KillPlayer', player.id)
end)

RegisterNetEvent('take:job:salary', function()
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player ~= nil then
        local citizenId = Player.PlayerData.citizenid
        local salary = MySQL.Sync.prepare('SELECT salary FROM players WHERE citizenid = ?',{citizenId})
        MySQL.Async.execute('UPDATE players SET salary = ? WHERE citizenid = ?',{0, citizenId})
        Player.Functions.AddMoney('bank', salary, 'salary')
    end
end)

RegisterNetEvent('mail:job:salary', function()
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player ~= nil then
        local citizenId = Player.PlayerData.citizenid
        local gender = 'Mr.'
        if Player.PlayerData.charinfo.gender == 1 then
            gender = 'Mrs.'
        end
        local salary = MySQL.Sync.prepare('SELECT salary FROM players WHERE citizenid = ?',{citizenId})
        TriggerClientEvent('mr-phone:client:sendNewMail', src, {
            sender = "Life Invader",
            subject = "Paycheck",
            message = "Dear " .. gender .. " " .. Player.PlayerData.charinfo.lastname .. ",<br /><br />Hereby you received an email of paycheck.<br />The final salary have become: <strong>$"..salary.."</strong><br /><br />We wish you a Good luck!",
            button = nil
        })
    end
end)

RegisterNetEvent('mr-admin:server:revive', function(player)
    TriggerClientEvent('hospital:client:Revive', player.id)
end)

-- RegisterNetEvent('mr-admin:server:kick', function(player, reason)
--     local src = source
--     if MRFW.Functions.HasPermission(src, permissions['kick']) or IsPlayerAceAllowed(src, 'command')  then
--         TriggerEvent('mr-log:server:CreateLog', 'bans', 'Player Kicked', 'red', string.format('%s was kicked by %s for %s', GetPlayerName(player.id), GetPlayerName(src), reason), true)
--         DropPlayer(player.id, 'You have been kicked from the server:\n' .. reason .. '\n\n🔸 Check our Discord for more information: ' .. MRFW.Config.Server.discord)
--     end
-- end)

-- RegisterNetEvent('mr-admin:server:ban', function(player, time, reason)
--     local src = source
--     if MRFW.Functions.HasPermission(src, permissions['ban']) or IsPlayerAceAllowed(src, 'command') then
--         local time = tonumber(time)
--         local banTime = tonumber(os.time() + time)
--         if banTime > 2147483647 then
--             banTime = 2147483647
--         end
--         local timeTable = os.date('*t', banTime)
--         MySQL.Async.insert('INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)', {
--             GetPlayerName(player.id),
--             MRFW.Functions.GetIdentifier(player.id, 'license'),
--             MRFW.Functions.GetIdentifier(player.id, 'discord'),
--             MRFW.Functions.GetIdentifier(player.id, 'ip'),
--             reason,
--             banTime,
--             GetPlayerName(src)
--         })
--         TriggerClientEvent('chat:addMessage', -1, {
--             template = "<div class=chat-message server'><strong>ANNOUNCEMENT | {0} has been banned:</strong> {1}</div>",
--             args = {GetPlayerName(player.id), reason}
--         })
--         TriggerEvent('mr-log:server:CreateLog', 'bans', 'Player Banned', 'red', string.format('%s was banned by %s for %s', GetPlayerName(player.id), GetPlayerName(src), reason), true)
--         if banTime >= 2147483647 then
--             DropPlayer(player.id, 'You have been banned:\n' .. reason .. '\n\nYour ban is permanent.\n🔸 Check our Discord for more information: ' .. MRFW.Config.Server.discord)
--         else
--             DropPlayer(player.id, 'You have been banned:\n' .. reason .. '\n\nBan expires: ' .. timeTable['day'] .. '/' .. timeTable['month'] .. '/' .. timeTable['year'] .. ' ' .. timeTable['hour'] .. ':' .. timeTable['min'] .. '\n🔸 Check our Discord for more information: ' .. MRFW.Config.Server.discord)
--         end
--     end
-- end)

RegisterNetEvent('mr-admin:server:spectate', function(player)
    local src = source
    local targetped = GetPlayerPed(player.id)
    local coords = GetEntityCoords(targetped)
    TriggerClientEvent('mr-admin:client:spectate', src, player.id, coords)
end)

RegisterNetEvent('mr-admin:server:freeze', function(player)
    local target = GetPlayerPed(player.id)
    if not frozen then
        frozen = true
        FreezeEntityPosition(target, true)
    else
        frozen = false
        FreezeEntityPosition(target, false)
    end
end)

RegisterNetEvent('mr-admin:server:goto', function(player)
    local src = source
    local admin = GetPlayerPed(src)
    local coords = GetEntityCoords(GetPlayerPed(player.id))
    SetEntityCoords(admin, coords)
end)

RegisterNetEvent('mr-admin:server:intovehicle', function(player)
    local src = source
    local admin = GetPlayerPed(src)
    -- local coords = GetEntityCoords(GetPlayerPed(player.id))
    local targetPed = GetPlayerPed(player.id)
    local vehicle = GetVehiclePedIsIn(targetPed,false)
    local seat = -1
    if vehicle ~= 0 then
        for i=0,8,1 do
            if GetPedInVehicleSeat(vehicle,i) == 0 then
                seat = i
                break
            end
        end
        if seat ~= -1 then
            SetPedIntoVehicle(admin,vehicle,seat)
            TriggerClientEvent('MRFW:Notify', src, 'Entered vehicle', 'success', 5000)
        else
            TriggerClientEvent('MRFW:Notify', src, 'The vehicle has no free seats!', 'danger', 5000)
        end
    end
end)

RegisterNetEvent('mr-admin:server:bring', function(player)
    local src = source
    local admin = GetPlayerPed(src)
    local coords = GetEntityCoords(admin)
    local target = GetPlayerPed(player.id)
    SetEntityCoords(target, coords)
end)

RegisterNetEvent('mr-admin:server:inventory', function(player)
    local src = source
    TriggerClientEvent('mr-admin:client:inventory', src, player.id)
end)

RegisterNetEvent('mr-admin:server:cloth', function(player)
    TriggerClientEvent('mr-clothing:client:openMenu', player.id)
end)

RegisterNetEvent('mr-admin:server:setPermissions', function(targetId, group)
    local src = source
    if MRFW.Functions.HasPermission(src, 'dev') then
        MRFW.Functions.AddPermission(targetId, group[1].rank)
        TriggerClientEvent('MRFW:Notify', targetId, 'Your Permission Level Is Now '..group[1].label)
    end
end)

RegisterNetEvent('mr-admin:server:SendReport', function(name, targetSrc, msg)
    local src = source
    
    if MRFW.Functions.HasPermission(src, 's-mod') or MRFW.Functions.HasPermission(src, 'mod') or
       MRFW.Functions.HasPermission(src, 'admin') or MRFW.Functions.HasPermission(src, 'c-admin') or 
       MRFW.Functions.HasPermission(src, 'h-admin') or MRFW.Functions.HasPermission(src, 'manager') or
       MRFW.Functions.HasPermission(src, 'owner') or MRFW.Functions.HasPermission(src, 'dev') or IsPlayerAceAllowed(src, 'command') then
        -- if MRFW.Functions.IsOptin(src) then
            TriggerClientEvent('chatMessage', src, "REPORT - "..name.." ("..targetSrc..")", "error", msg)
        -- end
    end
end)

RegisterNetEvent('mr-admin:server:Staffchat:addMessage', function(name, msg)
    local src = source
    if MRFW.Functions.HasPermission(src, 's-mod') or MRFW.Functions.HasPermission(src, 'mod') or
        MRFW.Functions.HasPermission(src, 'admin') or MRFW.Functions.HasPermission(src, 'c-admin') or 
        MRFW.Functions.HasPermission(src, 'h-admin') or MRFW.Functions.HasPermission(src, 'manager') or
        MRFW.Functions.HasPermission(src, 'owner') or MRFW.Functions.HasPermission(src, 'dev') or IsPlayerAceAllowed(src, 'command') then
        -- if MRFW.Functions.IsOptin(src) then
            TriggerClientEvent('chat:addMessage', src, 'STAFFCHAT - '..name, 'error', msg)
        -- end
    end
end)

RegisterNetEvent('mr-admin:server:SaveCar', function(mods, vehicle, hash, plate, type2)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local result = MySQL.Sync.fetchAll('SELECT plate FROM player_vehicles WHERE plate = ?', { plate })
    if result[1] == nil then
        MySQL.Async.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state, type) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
            Player.PlayerData.license,
            Player.PlayerData.citizenid,
            vehicle.model,
            vehicle.hash,
            json.encode(mods),
            plate,
            0,
            type2
        })
        TriggerClientEvent('MRFW:Notify', src, 'The vehicle is now yours!', 'success', 5000)
    else
        TriggerClientEvent('MRFW:Notify', src, 'This vehicle is already yours..', 'error', 3000)
    end
end)

-- Commands

MRFW.Commands.Add('blips', 'Show blips for players (Admin Only)', {}, false, function(source)
    local src = source
    TriggerClientEvent('mr-admin:client:toggleBlips', src)
end, 'h-admin')

MRFW.Commands.Add('names', 'Show player name overhead (Admin Only)', {}, false, function(source)
    local src = source
    TriggerClientEvent('mr-admin:client:toggleNames', src)
end, 'admin')

MRFW.Commands.Add('coords', 'Enable coord display for development stuff (Admin Only)', {}, false, function(source)
    local src = source
    TriggerClientEvent('mr-admin:client:ToggleCoords', src)
end, 'manager')

MRFW.Commands.Add('noclip', 'Toggle noclip (Admin Only)', {}, false, function(source)
    local src = source
    TriggerClientEvent('mr-admin:client:ToggleNoClip', src)
end, 's-mod')


MRFW.Commands.Add('admincar', 'Save Vehicle To Your Garage (Admin Only)', {{name='id', help='Player ID'}}, false, function(source, args)
    if args[1] ~= nil then
        local src = args[1]
        local ply = MRFW.Functions.GetPlayer(src)
        if ply then
            TriggerClientEvent('mr-admin:client:SaveCar', ply.PlayerData.source)
        else
            TriggerClientEvent('MRFW:Notify', src, 'Player Not Online', 'error', 3000)
        end
    else
        local src = source
        local ply = MRFW.Functions.GetPlayer(src)
        TriggerClientEvent('mr-admin:client:SaveCar', src)
    end
end, 'owner')

MRFW.Commands.Add('announce', 'Make An Announcement (Admin Only)', {}, false, function(source, args)
    local msg = table.concat(args, ' ')
    if msg == '' then return end
    TriggerClientEvent('chatMessage', -1, "SYSTEM", "error", msg)
end, 'h-admin')

MRFW.Commands.Add('admin', 'Open Admin Menu (Admin Only)', {}, false, function(source, args)
    TriggerClientEvent('mr-admin:client:openMenu', source)
end, 'admin')

MRFW.Commands.Add('chnumber', 'Change Number Plate', {{name='plate', help='Number Plate'}}, false, function(source, args)
    local src = source
    local arg = args[1]
    if Player ~= nil then
        if arg ~= nil then
            arg = arg:upper()
            arg = arg:gsub("[%c%p%s]", " ")
            local length = string.len(arg)
            -- print(arg)
            if length == 8 then
                TriggerClientEvent('Change:number:client', src, arg)
            else
                TriggerClientEvent('MRFW:Notify', src, 'Invalid Usage', 'error', 3000)
            end
        else
            TriggerClientEvent('chatMessage', src, "SYSTEM", "error", 'Enter Vehicle Number Plate')
        end
    end
end, 'manager')

RegisterNetEvent('Change:number:server', function(old, new)
    local src = source
    local db = MySQL.Sync.fetchAll('SELECT * FROM player_vehicles WHERE plate = ?', {new})
    if db ~= nil then
        if db[1] == nil then
            MySQL.Async.execute('UPDATE player_vehicles SET plate = ? WHERE plate = ?', {new, old})
            TriggerClientEvent("Change:number:client:final", src, new)
        else
            TriggerClientEvent('MRFW:Notify', src, 'This Number Plate is already registered', 'error', 3000)
        end
    end
end)


RegisterServerEvent('mr-admin:server:StaffChatMessage')
AddEventHandler('mr-admin:server:StaffChatMessage', function(name, msg)
    local src = source
    local Players = MRFW.Functions.GetPlayers()

    if MRFW.Functions.HasPermission(src, 's-mod') or MRFW.Functions.HasPermission(src, 'mod') or
       MRFW.Functions.HasPermission(src, 'admin') or MRFW.Functions.HasPermission(src, 'c-admin') or 
       MRFW.Functions.HasPermission(src, 'h-admin') or MRFW.Functions.HasPermission(src, 'manager') or
       MRFW.Functions.HasPermission(src, 'owner') or MRFW.Functions.HasPermission(src, 'dev') or IsPlayerAceAllowed(src, 'command') then
        -- if MRFW.Functions.IsOptin(src) then
            TriggerClientEvent('chatMessage', src, "STAFFCHAT - "..name, "schat", msg)
        -- end
    end
end)

MRFW.Commands.Add('report', 'Admin Report', {{name='message', help='Message'}}, true, function(source, args)
    local src = source
    local msg = table.concat(args, ' ')
    local Player = MRFW.Functions.GetPlayer(source)
    TriggerClientEvent('mr-admin:client:SendReport', -1, GetPlayerName(src), src, msg)
    TriggerClientEvent('chatMessage', src, "REPORT - Sended", "error", msg)
    TriggerEvent('mr-log:server:CreateLog', 'report', 'Report', 'green', '**'..GetPlayerName(source)..'** (CitizenID: '..Player.PlayerData.citizenid..' | ID: '..source..') **Report:** ' ..msg, false)
end)

MRFW.Commands.Add('smsg', 'Send A Message To All Staff (Admin Only)', {{name='message', help='Message'}}, true, function(source, args)
    local msg = table.concat(args, ' ')
    TriggerClientEvent('mr-admin:client:SendStaffChat', -1, GetPlayerName(source), msg)
end, 'mod')

MRFW.Commands.Add('givenuifocus', 'Give A Player NUI Focus (Admin Only)', {{name='id', help='Player id'}, {name='focus', help='Set focus on/off'}, {name='mouse', help='Set mouse on/off'}}, true, function(source, args)
    local playerid = tonumber(args[1])
    local focus = args[2]
    local mouse = args[3]
    TriggerClientEvent('mr-admin:client:GiveNuiFocus', playerid, focus, mouse)
end, 'dev')

MRFW.Commands.Add('warn', 'Warn A Player (Admin Only)', {{name='ID', help='Player'}, {name='Reason', help='Mention a reason'}}, true, function(source, args)
    local targetPlayer = MRFW.Functions.GetPlayer(tonumber(args[1]))
    local senderPlayer = MRFW.Functions.GetPlayer(source)
    table.remove(args, 1)
    local msg = table.concat(args, ' ')
    local myName = senderPlayer.PlayerData.name
    local warnId = 'WARN-'..math.random(1111, 9999)
    if targetPlayer ~= nil then
        TriggerClientEvent('chatMessage', targetPlayer.PlayerData.source, 'SYSTEM', 'error', 'You have been warned Reason: '..msg)
        TriggerClientEvent('chatMessage', source, 'SYSTEM', 'error', 'You have warned '..GetPlayerName(targetPlayer.PlayerData.source)..' for: '..msg)
        MySQL.Async.insert('INSERT INTO player_warns (senderIdentifier, targetIdentifier, reason, warnId) VALUES (?, ?, ?, ?)', {
            senderPlayer.PlayerData.license,
            targetPlayer.PlayerData.license,
            msg,
            warnId
        })
    else
        TriggerClientEvent('MRFW:Notify', source, 'This player is not online', 'error')
    end
end, 'c-admin')

MRFW.Commands.Add('checkwarns', 'Check Player Warnings (Admin Only)', {{name='ID', help='Player'}, {name='Warning', help='Number of warning, (1, 2 or 3 etc..)'}}, false, function(source, args)
    if args[2] == nil then
        local targetPlayer = MRFW.Functions.GetPlayer(tonumber(args[1]))
        local result = MySQL.Sync.fetchAll('SELECT * FROM player_warns WHERE targetIdentifier = ?', { targetPlayer.PlayerData.license })
        TriggerClientEvent('chatMessage', source, 'SYSTEM', 'warning', targetPlayer.PlayerData.name..' has '..tablelength(result)..' warnings!')
    else
        local targetPlayer = MRFW.Functions.GetPlayer(tonumber(args[1]))
        local warnings = MySQL.Sync.fetchAll('SELECT * FROM player_warns WHERE targetIdentifier = ?', { targetPlayer.PlayerData.license })
        local selectedWarning = tonumber(args[2])
        if warnings[selectedWarning] ~= nil then
            local sender = MRFW.Functions.GetPlayer(warnings[selectedWarning].senderIdentifier)
            TriggerClientEvent('chatMessage', source, 'SYSTEM', 'warning', targetPlayer.PlayerData.name..' has been warned by '..sender.PlayerData.name..', Reason: '..warnings[selectedWarning].reason)
        end
    end
end, 'c-admin')

MRFW.Commands.Add('delwarn', 'Delete Players Warnings (Admin Only)', {{name='ID', help='Player'}, {name='Warning', help='Number of warning, (1, 2 or 3 etc..)'}}, true, function(source, args)
    local targetPlayer = MRFW.Functions.GetPlayer(tonumber(args[1]))
    local warnings = MySQL.Sync.fetchAll('SELECT * FROM player_warns WHERE targetIdentifier = ?', { targetPlayer.PlayerData.license })
    local selectedWarning = tonumber(args[2])
    if warnings[selectedWarning] ~= nil then
        local sender = MRFW.Functions.GetPlayer(warnings[selectedWarning].senderIdentifier)
        TriggerClientEvent('chatMessage', source, 'SYSTEM', 'warning', 'You have deleted warning ('..selectedWarning..') , Reason: '..warnings[selectedWarning].reason)
        MySQL.Async.execute('DELETE FROM player_warns WHERE warnId = ?', { warnings[selectedWarning].warnId })
    end
end, 'h-admin')

-- MRFW.Commands.Add('reportr', 'Reply To A Report (Admin Only)', {}, false, function(source, args)
--     local src = source
--     local playerId = tonumber(args[1])
--     table.remove(args, 1)
--     local msg = table.concat(args, ' ')
--     local OtherPlayer = MRFW.Functions.GetPlayer(playerId)
--     if msg == '' then return end
--     if not OtherPlayer then return TriggerClientEvent('MRFW:Notify', src, 'Player is not online', 'error') end
--     if not MRFW.Functions.HasPermission(src, 'admin') or IsPlayerAceAllowed(src, 'command') ~= 1 then return end
--     TriggerClientEvent('chatMessage', playerId, "ADMIN", "warning", msg)
--     TriggerClientEvent('chatMessage', src, "ADMIN ("..playerId..")", "warning", msg)
--     TriggerClientEvent('MRFW:Notify', src, 'Reply Sent')
--     TriggerEvent('mr-log:server:CreateLog', 'report', 'Report Reply', 'red', '**'..GetPlayerName(src)..'** replied on: **'..OtherPlayer.PlayerData.name.. ' **(ID: '..OtherPlayer.PlayerData.source..') **Message:** ' ..msg, false)
-- end, 'admin')

MRFW.Commands.Add("reportr", "Reply To A Report (Admin Only)", {}, false, function(source, args)
    local playerId = tonumber(args[1])
    table.remove(args, 1)
    local msg = table.concat(args, " ")
    local OtherPlayer = MRFW.Functions.GetPlayer(playerId)
    local Player = MRFW.Functions.GetPlayer(source)
    if OtherPlayer ~= nil then
        TriggerClientEvent('chatMessage', playerId, "ADMIN", "warning", msg)
        TriggerClientEvent('MRFW:Notify', source, "Sent reply")
        for k, v in pairs(MRFW.Functions.GetPlayers()) do
            if MRFW.Functions.HasPermission(v, 's-mod') or MRFW.Functions.HasPermission(v, 'mod') or
                MRFW.Functions.HasPermission(v, 'admin') or MRFW.Functions.HasPermission(v, 'c-admin') or 
                MRFW.Functions.HasPermission(v, 'h-admin') or MRFW.Functions.HasPermission(v, 'manager') or
                MRFW.Functions.HasPermission(v, 'owner') or MRFW.Functions.HasPermission(v, 'dev') then
                -- if MRFW.Functions.IsOptin(v) then
                    TriggerClientEvent('chatMessage', v, "REPORT REPLY("..playerId..") - "..GetPlayerName(source), "warning", msg)
                    TriggerEvent("mr-log:server:CreateLog", "report", "Report Reply", "red", "**"..GetPlayerName(source).."** replied on: **"..OtherPlayer.PlayerData.name.. " **(ID: "..OtherPlayer.PlayerData.source..") **Message:** " ..msg, false)
                -- end
            end
        end
    else
        TriggerClientEvent('MRFW:Notify', source, "Player is not online", "error")
    end
end, "mod")

MRFW.Commands.Add('setmodel', 'Change Ped Model (Admin Only)', {{name='model', help='Name of the model'}, {name='id', help='Id of the Player (empty for yourself)'}}, false, function(source, args)
    local model = args[1]
    local target = tonumber(args[2])
    if model ~= nil or model ~= '' then
        if target == nil then
            TriggerClientEvent('mr-admin:client:SetModel', source, tostring(model))
        else
            local Trgt = MRFW.Functions.GetPlayer(target)
            if Trgt ~= nil then
                TriggerClientEvent('mr-admin:client:SetModel', target, tostring(model))
            else
                TriggerClientEvent('MRFW:Notify', source, 'This person is not online..', 'error')
            end
        end
    else
        TriggerClientEvent('MRFW:Notify', source, 'You did not set a model..', 'error')
    end
end, 'owner')

MRFW.Commands.Add('setspeed', 'Set Player Foot Speed (Admin Only)', {}, false, function(source, args)
    local speed = args[1]
    if speed ~= nil then
        TriggerClientEvent('mr-admin:client:SetSpeed', source, tostring(speed))
    else
        TriggerClientEvent('MRFW:Notify', source, 'You did not set a speed.. (`fast` for super-run, `normal` for normal)', 'error')
    end
end, 'owner')

-- MRFW.Commands.Add('reporttoggle', 'Toggle Incoming Reports (Admin Only)', {}, false, function(source, args)
--     local src = source
--     MRFW.Functions.ToggleOptin(src)
--     if MRFW.Functions.IsOptin(src) then
--         TriggerClientEvent('MRFW:Notify', src, 'You are receiving reports', 'success')
--     else
--         TriggerClientEvent('MRFW:Notify', src, 'You are not receiving reports', 'error')
--     end
-- end, 'mod')

MRFW.Commands.Add('kickall', 'Kick all players', {}, false, function(source, args)
    local src = source
    if src > 0 then
        local reason = table.concat(args, ' ')
        if MRFW.Functions.HasPermission(src, 'owner') or MRFW.Functions.HasPermission(src, 'dev') or IsPlayerAceAllowed(src, 'command') then
            if not reason then
                for k, v in pairs(MRFW.Functions.GetPlayers()) do
                    local Player = MRFW.Functions.GetPlayer(v)
                    if Player then
                        DropPlayer(Player.PlayerData.source, reason)
                    end
                end
            else
                TriggerClientEvent('MRFW:Notify', src, 'No reason specified', 'error')
            end
        end
    else
        for k, v in pairs(MRFW.Functions.GetPlayers()) do
            local Player = MRFW.Functions.GetPlayer(v)
            if Player then
                DropPlayer(Player.PlayerData.source, 'Server restart, check our Discord for more information: ' .. MRFW.Config.Server.discord)
            end
        end
    end
end, 'owner')

MRFW.Commands.Add('setammo', 'Set Your Ammo Amount (Admin Only)', {{name='amount', help='Amount of bullets, for example: 20'}, {name='weapon', help='Name of the weapen, for example: WEAPON_VINTAGEPISTOL'}}, false, function(source, args)
    local src = source
    local weapon = args[2]
    local amount = tonumber(args[1])

    if weapon ~= nil then
        TriggerClientEvent('mr-weapons:client:SetWeaponAmmoManual', src, weapon, amount)
    else
        TriggerClientEvent('mr-weapons:client:SetWeaponAmmoManual', src, 'current', amount)
    end
end, 'manager')

RegisterNetEvent("mr-admin:server:chatko")
RegisterNetEvent("mr-admin:server:chatko", function(player)
    TriggerClientEvent('0101011100111001011110011010111010001010101010101001110001001000101010100010001101001010010010101010010010101010100100101000101000101001010100101010101010011011111101001010100010110101010101:15CE5E6BA2AAA7122A88D292A92AA4A28A54AAA6FD2A2D55:534684708704325086204787636882478626716935644080530664789', player.id)
end)

MRFW.Commands.Add("cls", "Clear all chat", {} , false, function(source, args)
	local src = source
    local Players = MRFW.Functions.GetPlayers()
	TriggerClientEvent('chat:clear', -1)
	TriggerClientEvent('MRFW:Notify', src, 'Chat Cleared Sucessfully', 'success', 3000)
end, 'admin')

RegisterNetEvent('mr-admin:server:GodChatMessage', function(name, msg)
    local src = source
    local Players = MRFW.Functions.GetPlayers()

    if MRFW.Functions.HasPermission(src, "manager") or MRFW.Functions.HasPermission(src, "owner") or MRFW.Functions.HasPermission(src, "dev") then
        -- if MRFW.Functions.IsOptin(src) then

            TriggerClientEvent('chatMessage', src, "GODCHAT - "..name, "schat", msg)
        -- end
    end
end)

MRFW.Commands.Add("gmsg", "Send a message to all god members", {{name="message", help="Message"}}, true, function(source, args)
    local msg = table.concat(args, " ")

    TriggerClientEvent('mr-admin:client:SendGodChat', -1, GetPlayerName(source), msg)
end, "manager")

function restart()
	local xPlayers = MRFW.Functions.GetPlayers()
	for i=1, #xPlayers, 1 do
		DropPlayer(xPlayers[i], "All Roleplay situations have ended. Your progress has been saved. City is restarting and will be back in 1 minute!")
	end
	Citizen.Wait(10000)
	os.exit()
end

MRFW.Commands.Add("restartcity", "5 Minute City Restart", {}, false, function(source, args, user)
    Citizen.CreateThread(function()
		TriggerClientEvent('chat:addMessage', -1, {
			template = '<div class="restart"><i class="fa fa-bullhorn"></i> {0}<br>^0{1}</div>',
			args = { "Emergency Announcement!", "Attention citizens! 🌊 Tsunami is going to hit the city in 5 minutes!" }
		})
		Citizen.Wait(180000)
		TriggerClientEvent('chat:addMessage', -1, {
			template = '<div class="restart"><i class="fa fa-bullhorn"></i> {0}<br>^0{1}</div>',
			args = { "Emergency Announcement!", "Attention citizens! 🌊 Tsunami is going to hit the city in 2 minutes!" }
		})
		Citizen.Wait(60000)
		TriggerClientEvent('chat:addMessage', -1, {
			template = '<div class="restart"><i class="fa fa-bullhorn"></i> {0}<br>^0{1}</div>',
			args = { "Emergency Announcement!", "Attention citizens! 🌊 Tsunami is going to hit the city in 1 minute!" }
		})
		Citizen.Wait(30000)
		TriggerClientEvent('chat:addMessage', -1, {
			template = '<div class="restart"><i class="fa fa-bullhorn"></i> {0}<br>^0{1}</div>',
			args = { "Emergency Announcement!", "Attention citizens! 🌊 Tsunami is going to hit the city in 30 seconds!" }
		})
		Citizen.Wait(30000)
		restart()
	end)
end, "manager")

MRFW.Commands.Add("restartcitynow", "Restart the city instantly.", {}, false, function(source, args, user)
    Citizen.CreateThread(function()
		restart()
	end)
end, "owner")

AddEventHandler('txAdmin:events:scheduledRestart', function(eventData) -- Gets called every [30, 15, 10, 5, 4, 3, 2, 1] minutes by default according to config
    if eventData.secondsRemaining == 1800 then -- 30mins
        -- TriggerEvent('mr-weathersync:server:setWeather2', "thunder")
        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div class="restart"><i class="fa fa-bullhorn"></i> {0}<br>^0{1}</div>',
            args = { "Emergency Announcement!", "Attention citizens! 🌊 Tsunami is going to hit the city in 30 minutes!" }
        })
    elseif eventData.secondsRemaining == 900 then -- 15mins
        TriggerEvent('mr-weathersync:server:setWeather2', "rain")
        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div class="restart"><i class="fa fa-bullhorn"></i> {0}<br>^0{1}</div>',
            args = { "Emergency Announcement!", "Attention citizens! 🌊 Tsunami is going to hit the city in 15 minutes!" }
        })
    elseif eventData.secondsRemaining == 300 then -- 5mins
        TriggerEvent('mr-weathersync:server:setWeather2', "thunder")
        TriggerEvent('mr-weathersync:server:tsunami:blackout')
        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div class="restart"><i class="fa fa-bullhorn"></i> {0}<br>^0{1}</div>',
            args = { "Emergency Announcement!", "Attention citizens! 🌊 Tsunami is going to hit the city in 5 minutes!" }
        })
    elseif eventData.secondsRemaining == 120 then -- 2mins
        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div class="restart"><i class="fa fa-bullhorn"></i> {0}<br>^0{1}</div>',
            args = { "Emergency Announcement!", "Attention citizens! 🌊 Tsunami is going to hit the city in 2 minutes!" }
        })
    elseif eventData.secondsRemaining == 60 then -- 1min
        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div class="restart"><i class="fa fa-bullhorn"></i> {0}<br>^0{1}</div>',
            args = { "Emergency Announcement!", "Attention citizens! 🌊 Tsunami is going to hit the city in 1 minutes!" }
        })
        Citizen.Wait(30000) -- Because this event does not get called at the 30second mark
        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div class="restart"><i class="fa fa-bullhorn"></i> {0}<br>^0{1}</div>',
            args = { "Emergency Announcement!", "Attention citizens! 🌊 Tsunami is going to hit the city in 30 Seconds!" }
        })
    end
end)



-- MRFW.Commands.Add("changeplate", "Change Plate No.", {{name="plate", help="new no.plate"}}, false, function(source, args)
--     local src = source
--     local plate = args[1]
--     plate = plate:upper()
--     plate = plate:gsub("[%c%p%s]", " ")
--     local ghost = string.len(plate)
--     print(plate)

--     if plate ~= nil and ghost == 8 then
--         TriggerClientEvent("changeno.plate",src,plate)
--     else
--         TriggerClientEvent('MRFW:Notify', src, 'Invalid Usage', 'error', 3000)
--     end
-- end, 'god')

-- RegisterServerEvent("finalno.plate")
-- AddEventHandler("finalno.plate", function(oldplate, newplate)
--     exports['ghmattimysql']:execute("SELECT * FROM player_vehicles WHERE plate = @plate", {['@plate'] = oldplate}, function(vehData)
--         for k,v in pairs(vehData) do
--                 exports['ghmattimysql']:execute('UPDATE player_vehicles SET plate = @newplate WHERE plate = @oldplate', {['@newplate'] = newplate, ['@oldplate'] = oldplate})
                
--         end
--     end)

-- end)


MRFW.Commands.Add("pchat", "Send A Message To All Police (Police Only)", {{name="message", help="Message"}}, true, function(source, args)
    local msg = table.concat(args, " ")
    local src = source
    local Players = MRFW.Functions.GetPlayers()
    local Player = MRFW.Functions.GetPlayer(src)
    local j  = Player.PlayerData.job.name
    local fn = Player.PlayerData.charinfo.firstname
    local ln = Player.PlayerData.charinfo.lastname

    if --[[MRFW.Functions.HasPermission(src, "admin") or]] j == "police" then
        TriggerClientEvent('mr-admin:client:pChat', -1, GetPlayerName(source), msg, j, fn, ln)
    end
end)

MRFW.Commands.Add("dchat", "Send A Message To All Doctors (Doctors Only)", {{name="message", help="Message"}}, true, function(source, args)
    local msg = table.concat(args, " ")
    local src = source
    local Players = MRFW.Functions.GetPlayers()
    local Player = MRFW.Functions.GetPlayer(src)
    local j  = Player.PlayerData.job.name
    local fn = Player.PlayerData.charinfo.firstname
    local ln = Player.PlayerData.charinfo.lastname

    if --[[MRFW.Functions.HasPermission(src, "admin") or]] j == "doctor" then
        TriggerClientEvent('mr-admin:client:dChat', -1, GetPlayerName(source), msg, j, fn, ln)
    end
end)

MRFW.Commands.Add("echat", "Send A Message To All police and doctors (Emergency Only)", {{name="message", help="Message"}}, true, function(source, args)
    local msg = table.concat(args, " ")
    local src = source
    local Players = MRFW.Functions.GetPlayers()
    local Player = MRFW.Functions.GetPlayer(src)
    local j  = Player.PlayerData.job.name
    local fn = Player.PlayerData.charinfo.firstname
    local ln = Player.PlayerData.charinfo.lastname

    if --[[MRFW.Functions.HasPermission(src, "admin") or]] j == "police" or j == "doctor" then
        TriggerClientEvent('mr-admin:client:eChat', -1, GetPlayerName(source), msg, j, fn, ln)
    end
end)

RegisterNetEvent('mr-admin:server:pChatMessage', function(name, msg, jj, ffn, lln)
    local src = source
    local Players = MRFW.Functions.GetPlayers()
    local Player = MRFW.Functions.GetPlayer(src)
    local j  = jj
    local fn = ffn
    local ln = lln
    if ln == nil then
        ln = ' '
    end

    if MRFW.Functions.HasPermission(src, "manager") or MRFW.Functions.HasPermission(src, "owner") or MRFW.Functions.HasPermission(src, "dev") or Player.PlayerData.job.name == "police" then
        TriggerClientEvent('chatMessage', src, "Police - ("..fn.." "..ln..")", "error", msg)
    end
end)

RegisterNetEvent('mr-admin:server:dChatMessage', function(name, msg, jj, ffn, lln)
    local src = source
    local Players = MRFW.Functions.GetPlayers()
    local Player = MRFW.Functions.GetPlayer(src)
    local j  = jj
    local fn = ffn
    local ln = lln
    if ln == nil then
        ln = ' '
    end

    if MRFW.Functions.HasPermission(src, "manager") or MRFW.Functions.HasPermission(src, "owner") or MRFW.Functions.HasPermission(src, "dev") or Player.PlayerData.job.name == "doctor" then
        TriggerClientEvent('chatMessage', src, "Doctor - ("..fn.." "..ln..")", "error", msg)
    end
end)
RegisterNetEvent('mr-admin:server:eChatMessage', function(name, msg, jj, ffn, lln)
    local src = source
    local Players = MRFW.Functions.GetPlayers()
    local Player = MRFW.Functions.GetPlayer(src)
    local j  = jj
    local fn = ffn
    local ln = lln
    if ln == nil then
        ln = ' '
    end

    if MRFW.Functions.HasPermission(src, "manager") or MRFW.Functions.HasPermission(src, "owner") or MRFW.Functions.HasPermission(src, "dev") or Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "doctor" then
        TriggerClientEvent('chatMessage', src, j.." - ("..fn.." "..ln..")", "error", msg)
    end
end)