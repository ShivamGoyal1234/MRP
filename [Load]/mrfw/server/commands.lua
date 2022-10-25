MRFW.Commands = {}
MRFW.Commands.List = {}

-- Register & Refresh Commands

function MRFW.Commands.Add(name, help, arguments, argsrequired, callback, permission)
    if MRConfig.Commands[name] then
        permission = MRConfig.Commands[name]
    else
        if type(permission) == 'string' then
            permission = permission:lower()
        else
            permission = 'user'
        end
    end
    MRFW.Commands.List[name:lower()] = {
        name = name:lower(),
        permission = permission,
        help = help,
        arguments = arguments,
        argsrequired = argsrequired,
        callback = callback
    }
end

function MRFW.Commands.Refresh(source)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local suggestions = {}
    if Player then
        for command, info in pairs(MRFW.Commands.List) do
            local isDev         = MRFW.Functions.HasPermission(src, 'dev')
            local isOwner       = MRFW.Functions.HasPermission(src, 'owner')
            local isManager     = MRFW.Functions.HasPermission(src, 'manager')
            local is_h_admin    = MRFW.Functions.HasPermission(src, 'h-admin')
            local isAdmin       = MRFW.Functions.HasPermission(src, 'admin')
            local is_c_admin    = MRFW.Functions.HasPermission(src, 'c-admin')
            local is_s_mod      = MRFW.Functions.HasPermission(src, 's-mod')
            local isMod         = MRFW.Functions.HasPermission(src, 'mod')
            local isJob         = Player.PlayerData.job.name
            local allowSuggestion = false
            if MRFW.Commands.List[command].permission == 'dev' then
                if isDev or isPrinciple then
                    allowSuggestion = true
                end
            elseif MRFW.Commands.List[command].permission == 'owner' then
                if isOwner or isDev or isPrinciple then
                    allowSuggestion = true
                end
            elseif MRFW.Commands.List[command].permission == 'manager' then
                if isManager or isOwner or isDev or isPrinciple then
                    allowSuggestion = true
                end
            elseif MRFW.Commands.List[command].permission == 'h-admin' then
                if is_h_admin or isManager or isOwner or isDev or isPrinciple then
                    allowSuggestion = true
                end
            elseif MRFW.Commands.List[command].permission == 'admin' then
                if isAdmin or is_h_admin or isManager or isOwner or isDev or isPrinciple then
                    allowSuggestion = true
                end
            elseif MRFW.Commands.List[command].permission == 'c-admin' then
                if is_c_admin or isAdmin or is_h_admin or isManager or isOwner or isDev or isPrinciple then
                    allowSuggestion = true
                end
            elseif MRFW.Commands.List[command].permission == 's-mod' then
                if is_s_mod or is_c_admin or isAdmin or is_h_admin or isManager or isOwner or isDev or isPrinciple then
                    allowSuggestion = true
                end
            elseif MRFW.Commands.List[command].permission == 'mod' then
                if isMod or is_s_mod or is_c_admin or isAdmin or is_h_admin or isManager or isOwner or isDev or isPrinciple then
                    allowSuggestion = true
                end
            elseif MRFW.Commands.List[command].permission == isJob then
                allowSuggestion = true
            elseif MRFW.Commands.List[command].permission == 'user' then
                allowSuggestion = true
            end
            if allowSuggestion then
                suggestions[#suggestions + 1] = {
                    name = '/' .. command,
                    help = info.help,
                    params = info.arguments
                }
            end
        end
        TriggerClientEvent('chat:addSuggestions', tonumber(source), suggestions)
    end
end

-- Teleport

MRFW.Commands.Add('tp', 'TP To Player or Coords (Admin Only)', { { name = 'id/x', help = 'ID of player or X position' }, { name = 'y', help = 'Y position' }, { name = 'z', help = 'Z position' } }, false, function(source, args)
    local src = source
    if args[1] and not args[2] and not args[3] then
        local target = GetPlayerPed(tonumber(args[1]))
        if target ~= 0 then
            local coords = GetEntityCoords(target)
            TriggerClientEvent('MRFW:Command:TeleportToPlayer', src, coords)
        else
            TriggerClientEvent('MRFW:Notify', src, 'Player Not Online', 'error')
        end
    else
        if args[1] and args[2] and args[3] then
            local x = tonumber((args[1]:gsub(",",""))) + .0
            local y = tonumber((args[2]:gsub(",",""))) + .0
            local z = tonumber((args[3]:gsub(",",""))) + .0
            if (x ~= 0) and (y ~= 0) and (z ~= 0) then
                TriggerClientEvent('MRFW:Command:TeleportToCoords', src, x, y, z)
            else
                TriggerClientEvent('MRFW:Notify', src, 'Incorrect Format', 'error')
            end
        else
            TriggerClientEvent('MRFW:Notify', src, 'Not every argument has been entered (x, y, z)', 'error')
        end
    end
end, 'manager')

MRFW.Commands.Add('tpm', 'TP To Marker (Admin Only)', {}, false, function(source)
    local src = source
    TriggerClientEvent('MRFW:Command:GoToMarker', src)
end, 'admin')

-- Permissions

-- MRFW.Commands.Add('addpermission', 'Give Player Permissions (God Only)', { { name = 'id', help = 'ID of player' }, { name = 'permission', help = 'Permission level' } }, true, function(source, args)
--     local src = source
--     local Player = MRFW.Functions.GetPlayer(tonumber(args[1]))
--     local permission = tostring(args[2]):lower()
--     if Player then
--         MRFW.Functions.AddPermission(Player.PlayerData.source, permission)
--     else
--         TriggerClientEvent('MRFW:Notify', src, 'Player Not Online', 'error')
--     end
-- end, 'god')

-- MRFW.Commands.Add('removepermission', 'Remove Players Permissions (God Only)', { { name = 'id', help = 'ID of player' } }, true, function(source, args)
--     local src = source
--     local Player = MRFW.Functions.GetPlayer(tonumber(args[1]))
--     if Player then
--         MRFW.Functions.RemovePermission(Player.PlayerData.source)
--     else
--         TriggerClientEvent('MRFW:Notify', src, 'Player Not Online', 'error')
--     end
-- end, 'god')

-- Vehicle

MRFW.Commands.Add('car', 'Spawn Vehicle (Admin Only)', { { name = 'model', help = 'Model name of the vehicle' } }, true, function(source, args)
    local src = source
    TriggerClientEvent('MRFW:Command:SpawnVehicle', src, args[1])
end, 'owner')

MRFW.Commands.Add('sv', 'Spawn Vehicle (Admin Only)', { { name = 'model', help = 'Model name of the vehicle' } }, true, function(source, args)
    local src = source
    TriggerClientEvent('MRFW:Command:SpawnVehicle', src, args[1])
end, 'owner')

MRFW.Commands.Add('dv', 'Delete Vehicle (Admin Only)', {}, false, function(source)
    local src = source
    TriggerClientEvent('MRFW:Command:DeleteVehicle', src)
end, 'mod')

-- Money

MRFW.Commands.Add('givemoney', 'Give A Player Money (Admin Only)', { { name = 'id', help = 'Player ID' }, { name = 'moneytype', help = 'Type of money (cash, bank, crypto)' }, { name = 'amount', help = 'Amount of money' } }, true, function(source, args)
    local src = source
    local Player = MRFW.Functions.GetPlayer(tonumber(args[1]))
    if Player then
        Player.Functions.AddMoney(tostring(args[2]), tonumber(args[3]))
    else
        TriggerClientEvent('MRFW:Notify', src, 'Player Not Online', 'error')
    end
end, 'owner')

MRFW.Commands.Add('setmoney', 'Set Players Money Amount (Admin Only)', { { name = 'id', help = 'Player ID' }, { name = 'moneytype', help = 'Type of money (cash, bank, crypto)' }, { name = 'amount', help = 'Amount of money' } }, true, function(source, args)
    local src = source
    local Player = MRFW.Functions.GetPlayer(tonumber(args[1]))
    if Player then
        Player.Functions.SetMoney(tostring(args[2]), tonumber(args[3]))
    else
        TriggerClientEvent('MRFW:Notify', src, 'Player Not Online', 'error')
    end
end, 'owner')

-- Job

MRFW.Commands.Add('job', 'Check Your Job', {}, false, function(source)
    local src = source
    local PlayerJob = MRFW.Functions.GetPlayer(src).PlayerData.job
    TriggerClientEvent('MRFW:Notify', src, string.format('[Job]: %s [Grade]: %s [On Duty]: %s', PlayerJob.label, PlayerJob.grade.name, PlayerJob.onduty))
end, 'user')

MRFW.Commands.Add('setjob', 'Set A Players Job (Admin Only)', { { name = 'id', help = 'Player ID' }, { name = 'job', help = 'Job name' }, { name = 'grade', help = 'Grade' } }, true, function(source, args)
    local src = source
    local Player = MRFW.Functions.GetPlayer(tonumber(args[1]))
    if Player then
        if MRShared.Jobs[tostring(args[2])] then
            if MRShared.Jobs[tostring(args[2])].grades[tostring(args[3])] then
                Player.Functions.SetJob(tostring(args[2]), tonumber(args[3]))
                TriggerClientEvent('MRFW:Notify', src, 'Success, ID: '..tonumber(args[1])..', Job: '..tostring(args[2])..', Grade: '..MRShared.Jobs[tostring(args[2])].grades[tostring(args[3])].name, 'error', 10000)
            else
                TriggerClientEvent('MRFW:Notify', src, 'Invalid Grade', 'error')
            end
        else
            TriggerClientEvent('MRFW:Notify', src, 'Invalid Job', 'error')
        end
            
    else
        TriggerClientEvent('MRFW:Notify', src, 'Player Not Online', 'error')
    end
end, 'h-admin')

-- Gang

MRFW.Commands.Add('gang', 'Check Your Gang', {}, false, function(source)
    local src = source
    local PlayerGang = MRFW.Functions.GetPlayer(source).PlayerData.gang
    TriggerClientEvent('MRFW:Notify', src, string.format('[Gang]: %s [Grade]: %s', PlayerGang.label, PlayerGang.grade.name))
end, 'user')

MRFW.Commands.Add('setgang', 'Set A Players Gang (Admin Only)', { { name = 'id', help = 'Player ID' }, { name = 'gang', help = 'Name of a gang' }, { name = 'grade', help = 'Grade' } }, true, function(source, args)
    local src = source
    local Player = MRFW.Functions.GetPlayer(tonumber(args[1]))
    if Player then
        Player.Functions.SetGang(tostring(args[2]), tonumber(args[3]))
    else
        TriggerClientEvent('MRFW:Notify', src, 'Player Not Online', 'error')
    end
end, 'h-admin')

-- Inventory (should be in aj-inventory?)

MRFW.Commands.Add('clearinv', 'Clear Players Inventory (Admin Only)', { { name = 'id', help = 'Player ID' } }, false, function(source, args)
    local src = source
    local playerId = args[1] ~= '' and args[1] or src
    local Player = MRFW.Functions.GetPlayer(tonumber(playerId))
    if Player then
        Player.Functions.ClearInventory()
    else
        TriggerClientEvent('MRFW:Notify', src, 'Player Not Online', 'error')
    end
end, 'h-admin')

-- Out of Character Chat

MRFW.Commands.Add('ooc', 'OOC Chat Message', {}, false, function(source, args)
    local src = source
    local message = table.concat(args, ' ')
    local Players = MRFW.Functions.GetPlayers()
    local Player = MRFW.Functions.GetPlayer(src)
    -- for k, v in pairs(Players) do
        -- if v == src then
            TriggerClientEvent('chat:addMessage', -1, {
                color = { 0, 0, 255},
                multiline = true,
                args = {'OOC | '.. GetPlayerName(src), message}
            })
            TriggerEvent('aj-log:server:CreateLog', 'ooc', 'OOC', 'white', '**' .. GetPlayerName(src) .. '** (CitizenID: ' .. Player.PlayerData.citizenid .. ' | ID: ' .. src .. ') **Message:** ' .. message, false)
        -- elseif #(GetEntityCoords(GetPlayerPed(src)) - GetEntityCoords(GetPlayerPed(v))) < 20.0 then
        --     TriggerClientEvent('chat:addMessage', v, {
        --         color = { 0, 0, 255},
        --         multiline = true,
        --         args = {'OOC | '.. GetPlayerName(src), message}
        --     })
        -- elseif MRFW.Functions.HasPermission(v, 'admin') then
        --     if MRFW.Functions.IsOptin(v) then
        --         TriggerClientEvent('chat:addMessage', v, {
        --             color = { 0, 0, 255},
        --             multiline = true,
        --             args = {'OOC | '.. GetPlayerName(src), message}
        --         })
        --         TriggerEvent('aj-log:server:CreateLog', 'ooc', 'OOC', 'white', '**' .. GetPlayerName(src) .. '** (CitizenID: ' .. Player.PlayerData.citizenid .. ' | ID: ' .. src .. ') **Message:** ' .. message, false)
        --     end
        -- end
    -- end
end, 'user')

MRFW.Commands.Add('looc', 'LOCALOOC Chat Message', {}, false, function(source, args)
    local src = source
    local message = table.concat(args, ' ')
    local Players = MRFW.Functions.GetPlayers()
    local Player = MRFW.Functions.GetPlayer(src)
    for k, v in pairs(Players) do
        if #(GetEntityCoords(GetPlayerPed(src)) - GetEntityCoords(GetPlayerPed(v))) < 100.0 then
            TriggerClientEvent('chat:addMessage', v, {
                color = { 0, 0, 255},
                multiline = true,
                args = {'LOCALOOC | '.. GetPlayerName(src), message}
            })
        elseif MRFW.Functions.HasPermission(v, 'admin') then
            if MRFW.Functions.IsOptin(v) then
                TriggerClientEvent('chat:addMessage', v, {
                    color = { 0, 0, 255},
                    multiline = true,
                    args = {'LOCALOOC(Notif) | '.. GetPlayerName(src), message}
                })
                TriggerEvent('aj-log:server:CreateLog', 'ooc', 'LOCALOOC', 'white', '**' .. GetPlayerName(src) .. '** (CitizenID: ' .. Player.PlayerData.citizenid .. ' | ID: ' .. src .. ') **Message:** ' .. message, false)
            end
        end
    end
end, 'user')

-- MRFW.Commands.Add('me', 'Show local message', {name = 'message', help = 'Message to respond with'}, false, function(source, args)
--     local src = source
--     local ped = GetPlayerPed(src)
--     local pCoords = GetEntityCoords(ped)
--     local msg = table.concat(args, ' ')
--     if msg == '' then return end
--     for k,v in pairs(MRFW.Functions.GetPlayers()) do
--         local target = GetPlayerPed(v)
--         local tCoords = GetEntityCoords(target)
--         if #(pCoords - tCoords) < 20 then
--             TriggerClientEvent('MRFW:Command:ShowMe3D', v, src, msg)
--         end
--     end
-- end, 'user') 

MRFW.Commands.Add("reloadqueue", "Give queue priority", {}, false, function(source, args)
	TriggerEvent('load:queue:db')
	TriggerClientEvent('chatMessage', source, "SYSTEM", "normal", "REFRESH")	
end, "manager")

-- MRFW.Commands.Add("addpriority", "Give queue priority", {{name="id", help="ID of the player"}, {name="priority", help="Priority level"}}, true, function(source, args)
--     local Player = MRFW.Functions.GetPlayer(tonumber(args[1]))
-- 	local level = tonumber(args[2])
-- 	if Player ~= nil then
--         AddPriority(Player.PlayerData.source, level)
--         TriggerClientEvent('chatMessage', source, "SYSTEM", "normal", "you gave " .. GetPlayerName(Player.PlayerData.source) .. " priority level ("..level..")")	
-- 	else
-- 		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Player not online!")	
-- 	end
-- end, "god")

MRFW.Commands.Add('addpriority', 'Give queue priority', {{name="id", help="ID of the player"}, {name="priority", help="Priority level"}, {name="expire", help="true or false"}, {name="days", help="how many days to expire"}}, false, function(source, args)
    local Player = MRFW.Functions.GetPlayer(tonumber(args[1]))
    local level  = tonumber(args[2])
    local expire = args[3]
    local days   = tonumber(args[4])
    if Player ~= nil then
        if level ~= nil then
            if expire == 'true' then
                if days ~= nil then
                    AddPriority(Player.PlayerData.source, level, true, days)
                    TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Success")
                else
                    TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Invalid days type")
                end
            elseif expire == 'false' then
                AddPriority(Player.PlayerData.source, level, false)
                TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Success")
            else
		        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Invalid expire type")
            end
        else
		    TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Invalid Level")
        end	
    else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Player not online!")	
    end
end,'manager')

MRFW.Commands.Add("removepriority", "Take priority away from someone", {{name="id", help="ID of the player"}}, true, function(source, args)
	local Player = MRFW.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
        RemovePriority(Player.PlayerData.source)
        TriggerClientEvent('chatMessage', source, "SYSTEM", "normal", "You removed priority from " .. GetPlayerName(Player.PlayerData.source))	
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Player not online!")	
	end
end, "manager")

function AddPriority(src, level, expire, days)
	local Player = MRFW.Functions.GetPlayer(src)
    local identifiers, steamIdentifier = GetPlayerIdentifiers(src)
    for _, v in pairs(identifiers) do
        if string.find(v, "license") then
            steamIdentifier = v
            break
        end
    end
    Citizen.Wait(500)
	if Player ~= nil then 
        MySQL.Async.fetchAll ('SELECT * FROM queue WHERE license = ?', {steamIdentifier}, function(result)
            if result[1] ~= nil then
                if expire then
                    MySQL.Async.execute('UPDATE queue SET priority = ?, expiredd = ?, days = ? WHERE license = ?', {level, 1, days, steamIdentifier})
                else
                    MySQL.Async.execute('UPDATE queue SET priority = ?, expiredd = ?, days = ? WHERE license = ?', {level, 0, 1, steamIdentifier})
                end
            else
                if expire then
                    MySQL.Async.insert('INSERT INTO queue (name, license, priority, expiredd, days) VALUES (?, ?, ?, ?, ?)', {GetPlayerName(src), steamIdentifier, level, 1, days})
                else
                    MySQL.Async.insert('INSERT INTO queue (name, license, priority, expiredd, days) VALUES (?, ?, ?, ?, ?)', {GetPlayerName(src), steamIdentifier, level, 0, 1})
                end
            end
        end)
		Player.Functions.UpdatePlayerData()
        TriggerEvent('load:queue:db')
	end
end

function RemovePriority(src)
	local Player = MRFW.Functions.GetPlayer(src)
    local identifiers, steamIdentifier = GetPlayerIdentifiers(src)
    for _, v in pairs(identifiers) do
        if string.find(v, "license") then
            steamIdentifier = v
            break
        end
    end
    Citizen.Wait(500)
	if Player ~= nil then 
        MySQL.Async.execute('DELETE FROM queue WHERE license = ?', {steamIdentifier})
        TriggerEvent('load:queue:db')
	end
end

MRFW.Commands.Add("gpadmin", "Get Player Playtime", {{name="id", help="ID of the player"}}, true, function(source, args)
	local Player = MRFW.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
        local citizenid = Player.PlayerData.citizenid
        local result = MySQL.query.await('SELECT * FROM player_playtime WHERE citizenid = ?', {citizenid})
        if result[1] ~= nil then
            local storedTime = result[1].playTime
            local joinTime = result[1].lastJoin
            local timeNow = os.time(os.date("!*t"))
    
            TriggerClientEvent('chat:addMessage', source, { args = {"Playtime", Player.PlayerData.name.."'s playtime: "..SecondsToClock((timeNow - joinTime) + storedTime)} })
        end
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Player not online!")	
	end
end, "h-admin")

MRFW.Commands.Add("getplaytime", "Get playTime of your character", {}, true, function(source, args)
	local Player = MRFW.Functions.GetPlayer(source)
	if Player ~= nil then
        local citizenid = Player.PlayerData.citizenid
        local result = MySQL.query.await('SELECT * FROM player_playtime WHERE citizenid = ?', {citizenid})
        if result[1] ~= nil then
            local storedTime = result[1].playTime
            local joinTime = result[1].lastJoin
            local timeNow = os.time(os.date("!*t"))
            TriggerClientEvent('chat:addMessage', source, { args = {"playtime: ", SecondsToClock((timeNow - joinTime) + storedTime)} })
        end
	end
end)

MRFW.Commands.Add('bring', 'Bring Someone to your location', {{name="id", help="ID of the player"}}, false, function(source, args)
    local src = source
    local Player = MRFW.Functions.GetPlayer(tonumber(args[1]))
    if Player then
        local ped = GetPlayerPed(src)
        local tped = GetPlayerPed(Player.PlayerData.source)
        local coords = GetEntityCoords(ped)
        SetEntityCoords(tped, coords)
    else
        TriggerClientEvent('chatMessage', src, "SYSTEM", "error", "Player not online!")	
    end
end, 's-mod')