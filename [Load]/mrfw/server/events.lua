-- Event Handler

AddEventHandler('chatMessage', function(source, _, message)
    if string.sub(message, 1, 1) == '/' then
        CancelEvent()
        return
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    if MRFW.Players[src] then
        local Player = MRFW.Players[src]
        Player.Functions.SetMetaData('armor', GetPedArmour(GetPlayerPed(src)))
        Player.Functions.SetMetaData('health', GetEntityHealth(GetPlayerPed(src)))
        TriggerEvent('mr-log:server:CreateLog', 'joinleave', 'Dropped', 'red', '**' .. GetPlayerName(src) .. '** (' .. Player.PlayerData.license .. ') left..')
        if Player.PlayerData.job.name == 'police' and Player.PlayerData.job.name == 'doctor' and Player.PlayerData.job.name == 'mechanic' and Player.PlayerData.job.name == 'government' then
            TriggerEvent("mr-shiftlog:jobchanged2", Player.PlayerData.job, Player.PlayerData.job, 1, src)
        end
        TriggerEvent('MRFW:Server:playtime:leave', Player.PlayerData.citizenid)
        Player.Functions.Save()
        _G.Player_Buckets[Player.PlayerData.license] = nil
        Citizen.Wait(200)
        MRFW.Players[src] = nil
    end
end)

RegisterNetEvent('MRFW:Server:playtime:join', function(citizenid)
    playerJoin(citizenid)
end)

RegisterNetEvent('MRFW:Server:playtime:leave', function(citizenid)
    playerDrop(citizenid)
end)

AddEventHandler('chatMessage', function(source, n, message)
    local src = source
    if string.sub(message, 1, 1) == '/' then
        local args = MRFW.Shared.SplitStr(message, ' ')
        local command = string.gsub(args[1]:lower(), '/', '')
        CancelEvent()
        if MRFW.Commands.List[command] then
            local Player = MRFW.Functions.GetPlayer(src)
            if Player then
                local isDev         = MRFW.Functions.HasPermission(src, 'dev')
                local isOwner       = MRFW.Functions.HasPermission(src, 'owner')
                local isManager     = MRFW.Functions.HasPermission(src, 'manager')
                local is_h_admin    = MRFW.Functions.HasPermission(src, 'h-admin')
                local isAdmin       = MRFW.Functions.HasPermission(src, 'admin')
                local is_c_admin    = MRFW.Functions.HasPermission(src, 'c-admin')
                local is_s_mod      = MRFW.Functions.HasPermission(src, 's-mod')
                local isMod         = MRFW.Functions.HasPermission(src, 'mod')
                local isJob         = Player.PlayerData.job.name
                table.remove(args, 1)
                if MRFW.Commands.List[command].permission == 'dev' then
                    if isDev or isPrinciple then
                        if (MRFW.Commands.List[command].argsrequired and #MRFW.Commands.List[command].arguments ~= 0 and args[#MRFW.Commands.List[command].arguments] == nil) then
                            TriggerClientEvent('MRFW:Notify', src, 'All arguments must be filled out!', 'error')
                        else
                            MRFW.Commands.List[command].callback(src, args)
                        end
                    else
                        TriggerClientEvent('MRFW:Notify', src, 'No Access To This Command', 'error')
                    end
                elseif MRFW.Commands.List[command].permission == 'owner' then
                    if isOwner or isDev or isPrinciple then
                        if (MRFW.Commands.List[command].argsrequired and #MRFW.Commands.List[command].arguments ~= 0 and args[#MRFW.Commands.List[command].arguments] == nil) then
                            TriggerClientEvent('MRFW:Notify', src, 'All arguments must be filled out!', 'error')
                        else
                            MRFW.Commands.List[command].callback(src, args)
                        end
                    else
                        TriggerClientEvent('MRFW:Notify', src, 'No Access To This Command', 'error')
                    end
                elseif MRFW.Commands.List[command].permission == 'manager' then
                    if isManager or isOwner or isDev or isPrinciple then
                        if (MRFW.Commands.List[command].argsrequired and #MRFW.Commands.List[command].arguments ~= 0 and args[#MRFW.Commands.List[command].arguments] == nil) then
                            TriggerClientEvent('MRFW:Notify', src, 'All arguments must be filled out!', 'error')
                        else
                            MRFW.Commands.List[command].callback(src, args)
                        end
                    else
                        TriggerClientEvent('MRFW:Notify', src, 'No Access To This Command', 'error')
                    end
                elseif MRFW.Commands.List[command].permission == 'h-admin' then
                    if is_h_admin or isManager or isOwner or isDev or isPrinciple then
                        if (MRFW.Commands.List[command].argsrequired and #MRFW.Commands.List[command].arguments ~= 0 and args[#MRFW.Commands.List[command].arguments] == nil) then
                            TriggerClientEvent('MRFW:Notify', src, 'All arguments must be filled out!', 'error')
                        else
                            MRFW.Commands.List[command].callback(src, args)
                        end
                    else
                        TriggerClientEvent('MRFW:Notify', src, 'No Access To This Command', 'error')
                    end
                elseif MRFW.Commands.List[command].permission == 'admin' then
                    if isAdmin or is_h_admin or isManager or isOwner or isDev or isPrinciple then
                        if (MRFW.Commands.List[command].argsrequired and #MRFW.Commands.List[command].arguments ~= 0 and args[#MRFW.Commands.List[command].arguments] == nil) then
                            TriggerClientEvent('MRFW:Notify', src, 'All arguments must be filled out!', 'error')
                        else
                            MRFW.Commands.List[command].callback(src, args)
                        end
                    else
                        TriggerClientEvent('MRFW:Notify', src, 'No Access To This Command', 'error')
                    end
                elseif MRFW.Commands.List[command].permission == 'c-admin' then
                    if is_c_admin or isAdmin or is_h_admin or isManager or isOwner or isDev or isPrinciple then
                        if (MRFW.Commands.List[command].argsrequired and #MRFW.Commands.List[command].arguments ~= 0 and args[#MRFW.Commands.List[command].arguments] == nil) then
                            TriggerClientEvent('MRFW:Notify', src, 'All arguments must be filled out!', 'error')
                        else
                            MRFW.Commands.List[command].callback(src, args)
                        end
                    else
                        TriggerClientEvent('MRFW:Notify', src, 'No Access To This Command', 'error')
                    end
                elseif MRFW.Commands.List[command].permission == 's-mod' then
                    if is_s_mod or is_c_admin or isAdmin or is_h_admin or isManager or isOwner or isDev or isPrinciple then
                        if (MRFW.Commands.List[command].argsrequired and #MRFW.Commands.List[command].arguments ~= 0 and args[#MRFW.Commands.List[command].arguments] == nil) then
                            TriggerClientEvent('MRFW:Notify', src, 'All arguments must be filled out!', 'error')
                        else
                            MRFW.Commands.List[command].callback(src, args)
                        end
                    else
                        TriggerClientEvent('MRFW:Notify', src, 'No Access To This Command', 'error')
                    end
                elseif MRFW.Commands.List[command].permission == 'mod' then
                    if isMod or is_s_mod or is_c_admin or isAdmin or is_h_admin or isManager or isOwner or isDev or isPrinciple then
                        if (MRFW.Commands.List[command].argsrequired and #MRFW.Commands.List[command].arguments ~= 0 and args[#MRFW.Commands.List[command].arguments] == nil) then
                            TriggerClientEvent('MRFW:Notify', src, 'All arguments must be filled out!', 'error')
                        else
                            MRFW.Commands.List[command].callback(src, args)
                        end
                    else
                        TriggerClientEvent('MRFW:Notify', src, 'No Access To This Command', 'error')
                    end
                elseif MRFW.Commands.List[command].permission == isJob then
                    if MRFW.Commands.List[command].permission == isJob then
                        if (MRFW.Commands.List[command].argsrequired and #MRFW.Commands.List[command].arguments ~= 0 and args[#MRFW.Commands.List[command].arguments] == nil) then
                            TriggerClientEvent('MRFW:Notify', src, 'All arguments must be filled out!', 'error')
                        else
                            MRFW.Commands.List[command].callback(src, args)
                        end
                    else
                        TriggerClientEvent('MRFW:Notify', src, 'No Access To This Command', 'error')
                    end
                elseif MRFW.Commands.List[command].permission == 'user' then
                    if (MRFW.Commands.List[command].argsrequired and #MRFW.Commands.List[command].arguments ~= 0 and args[#MRFW.Commands.List[command].arguments] == nil) then
                        TriggerClientEvent('MRFW:Notify', src, 'All arguments must be filled out!', 'error')
                    else
                        MRFW.Commands.List[command].callback(src, args)
                    end
                end
            end
        end
    end
end)

-- Player Connecting

local function OnPlayerConnecting(name, setKickReason, deferrals)
    local player = source
    local license
    local name = GetPlayerName(player)
    local identifiers = GetPlayerIdentifiers(player)
    local a1 = json.encode(GetPlayerIdentifiers(player))
	local a2 = json.decode(a1)
	local b1,b2,b3,b4,b5,b6,b7,b8
	if a2[1]==nil then b1='null'else b1=a2[1]end
	if a2[2]==nil then b2='null'else b2=a2[2]end
	if a2[3]==nil then b3='null'else b3=a2[3]end
	if a2[4]==nil then b4='null'else b4=a2[4]end
	if a2[5]==nil then b5='null'else b5=a2[5]end
	if a2[6]==nil then b6='null'else b6=a2[6]end
	if a2[7]==nil then b7='null'else b7=a2[7]end
    if a2[8]==nil then b8='null'else b8=a2[8]end
	TriggerEvent("mr-log:server:CreateLog", "joinleave", "Queue", "orange", "**"..name .. "** ```"..b1..
                                                                                              "\n"..b2..
                                                                                              "\n"..b3..
                                                                                              "\n"..b4..
                                                                                              "\n"..b5..
                                                                                              "\n"..b6..
                                                                                              "\n"..b7..
                                                                                              "\n"..b8..
                                                                                              "\n".."``` in queue..")
    deferrals.defer()

    -- mandatory wait!
    Wait(0)

    deferrals.update(string.format('Hello %s. Validating Your Rockstar License', name))

    for _, v in pairs(identifiers) do
        if string.find(v, 'license') then
            license = v
            break
        end
    end

    -- mandatory wait!
    Wait(2500)

    deferrals.update(string.format('Hello %s. We are checking if you are banned.', name))

    local isBanned, Reason = MRFW.Functions.IsPlayerBanned(player)
    local isLicenseAlreadyInUse = MRFW.Functions.IsLicenseInUse(license)

    Wait(2500)

    deferrals.update(string.format('Welcome %s to {Server Name}.', name))

    if not license then
        deferrals.done('No Valid Rockstar License Found')
    elseif isBanned then
        deferrals.done(Reason)
    elseif isLicenseAlreadyInUse then
        deferrals.done('Duplicate Rockstar License Found')
    else
        deferrals.done()
        Wait(1000)
        TriggerEvent('connectqueue:playerConnect', name, setKickReason, deferrals)
    end
    --Add any additional defferals you may need!
end

AddEventHandler('playerConnecting', OnPlayerConnecting)

-- Open & Close Server (prevents players from joining)

RegisterNetEvent('MRFW:server:CloseServer', function(reason)
    local src = source
    if MRFW.Functions.HasPermission(src, 'admin') or MRFW.Functions.HasPermission(src, 'god') then
        local reason = reason or 'No reason specified'
        MRFW.Config.Server.closed = true
        MRFW.Config.Server.closedReason = reason
        TriggerClientEvent('ajadmin:client:SetServerStatus', -1, true)
    else
        MRFW.Functions.Kick(src, 'You don\'t have permissions for this..', nil, nil)
    end
end)

RegisterNetEvent('MRFW:server:OpenServer', function()
    local src = source
    if MRFW.Functions.HasPermission(src, 'admin') or MRFW.Functions.HasPermission(src, 'god') then
        MRFW.Config.Server.closed = false
        TriggerClientEvent('ajadmin:client:SetServerStatus', -1, false)
    else
        MRFW.Functions.Kick(src, 'You don\'t have permissions for this..', nil, nil)
    end
end)

-- Callbacks

RegisterNetEvent('MRFW:Server:TriggerCallback', function(name, ...)
    local src = source
    MRFW.Functions.TriggerCallback(name, src, function(...)
        TriggerClientEvent('MRFW:Client:TriggerCallback', src, name, ...)
    end, ...)
end)

-- Player
RegisterNetEvent('MRFW:Player:UpdatePlayerPayment', function()
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local payment = Player.PlayerData.job.payment
    if Player.PlayerData.job and Player.PlayerData.job.payment > 0 then
        if MRConfig.Money.OnlyPayWhenDuty then
            if Player.PlayerData.job.onduty then
                -- Player.Functions.AddMoney('bank', payment)
                local salary = MySQL.Sync.prepare('SELECT salary FROM players WHERE citizenid = ?',{Player.PlayerData.citizenid})
                local final = salary + payment
                MySQL.Async.execute('UPDATE players SET salary = ? WHERE citizenid = ?',{final, Player.PlayerData.citizenid})
                TriggerClientEvent('MRFW:Notify', Player.PlayerData.source, 'Salary Received collect it from Life Invader')
            else
                local aa = payment / 100
                local bb = aa * MRConfig.Money.Percent
                -- Player.Functions.AddMoney('bank', bb)
                local salary = MySQL.Sync.prepare('SELECT salary FROM players WHERE citizenid = ?',{Player.PlayerData.citizenid})
                local final = salary + bb
                MySQL.Async.execute('UPDATE players SET salary = ? WHERE citizenid = ?',{final, Player.PlayerData.citizenid})
                TriggerClientEvent('MRFW:Notify', Player.PlayerData.source, 'Salary Received collect it from Life Invader')
            end
        else
            Player.Functions.AddMoney('bank', payment)
            TriggerClientEvent('MRFW:Notify', Player.PlayerData.source, 'Salary Received collect it from Life Invader')
        end
    end
end)

RegisterNetEvent('MRFW:UpdatePlayer', function(armor, health)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player then
        local newHunger = Player.PlayerData.metadata['hunger'] - MRFW.Config.Player.HungerRate
        local newThirst = Player.PlayerData.metadata['thirst'] - MRFW.Config.Player.ThirstRate
        if newHunger <= 0 then
            newHunger = 0
        end
        if newThirst <= 0 then
            newThirst = 0
        end
        Player.Functions.SetMetaData('thirst', newThirst)
        Player.Functions.SetMetaData('hunger', newHunger)
        if armor ~= nil then
            local abcd = armor
            Player.Functions.SetMetaData('armor', abcd)
        end
        if health ~= nil then
            local abcd = health
            Player.Functions.SetMetaData('health', abcd)
        end
        TriggerClientEvent('hud:client:UpdateNeeds', src, newHunger, newThirst)
        Player.Functions.Save()
    end
end)

RegisterNetEvent('MRFW:Server:SetMetaData', function(meta, data)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if not Player then return end
    if meta == 'hunger' or meta == 'thirst' then
        if data > 100 then
            data = 100
        end
    end
    Player.Functions.SetMetaData(meta, data)
    TriggerClientEvent('hud:client:UpdateNeeds', src, Player.PlayerData.metadata['hunger'], Player.PlayerData.metadata['thirst'])
end)

RegisterNetEvent('MRFW:ToggleDuty', function()
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player.PlayerData.job.onduty then
        Player.Functions.SetJobDuty(false)
        TriggerClientEvent('MRFW:Notify', src, 'You are now off duty!')
    else
        Player.Functions.SetJobDuty(true)
        TriggerClientEvent('MRFW:Notify', src, 'You are now on duty!')
    end
    TriggerClientEvent('MRFW:Client:SetDuty', src, Player.PlayerData.job.onduty)
end)

-- Items

RegisterNetEvent('MRFW:Server:UseItem', function(item)
    local src = source
    if item and item.amount > 0 then
        if MRFW.Functions.CanUseItem(item.name) then
            MRFW.Functions.UseItem(src, item)
        end
    end
end)

RegisterNetEvent('MRFW:Server:RemoveItem', function(itemName, amount, slot)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    Player.Functions.RemoveItem(itemName, amount, slot)
end)

RegisterNetEvent('MRFW:Server:AddItem', function(itemName, amount, slot, info)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    Player.Functions.AddItem(itemName, amount, slot, info)
end)

-- Non-Chat Command Calling (ex: mr-adminmenu)

RegisterNetEvent('MRFW:CallCommand', function(command, args)
    local src = source
    if MRFW.Commands.List[command] then
        local Player = MRFW.Functions.GetPlayer(src)
        if Player then
            local isDev         = MRFW.Functions.HasPermission(src, 'dev')
            local isOwner       = MRFW.Functions.HasPermission(src, 'owner')
            local isManager     = MRFW.Functions.HasPermission(src, 'manager')
            local is_h_admin    = MRFW.Functions.HasPermission(src, 'h-admin')
            local isAdmin       = MRFW.Functions.HasPermission(src, 'admin')
            local is_c_admin    = MRFW.Functions.HasPermission(src, 'c-admin')
            local is_s_mod      = MRFW.Functions.HasPermission(src, 's-mod')
            local isMod         = MRFW.Functions.HasPermission(src, 'mod')
            local isJob         = Player.PlayerData.job.name
            if MRFW.Commands.List[command].permission == 'dev' then
                if isDev or isPrinciple then
                    if (MRFW.Commands.List[command].argsrequired and #MRFW.Commands.List[command].arguments ~= 0 and args[#MRFW.Commands.List[command].arguments] == nil) then
                        TriggerClientEvent('MRFW:Notify', src, 'All arguments must be filled out!', 'error')
                    else
                        MRFW.Commands.List[command].callback(src, args)
                    end
                else
                    TriggerClientEvent('MRFW:Notify', src, 'No Access To This Command', 'error')
                end
            elseif MRFW.Commands.List[command].permission == 'owner' then
                if isOwner or isDev or isPrinciple then
                    if (MRFW.Commands.List[command].argsrequired and #MRFW.Commands.List[command].arguments ~= 0 and args[#MRFW.Commands.List[command].arguments] == nil) then
                        TriggerClientEvent('MRFW:Notify', src, 'All arguments must be filled out!', 'error')
                    else
                        MRFW.Commands.List[command].callback(src, args)
                    end
                else
                    TriggerClientEvent('MRFW:Notify', src, 'No Access To This Command', 'error')
                end
            elseif MRFW.Commands.List[command].permission == 'manager' then
                if isManager or isOwner or isDev or isPrinciple then
                    if (MRFW.Commands.List[command].argsrequired and #MRFW.Commands.List[command].arguments ~= 0 and args[#MRFW.Commands.List[command].arguments] == nil) then
                        TriggerClientEvent('MRFW:Notify', src, 'All arguments must be filled out!', 'error')
                    else
                        MRFW.Commands.List[command].callback(src, args)
                    end
                else
                    TriggerClientEvent('MRFW:Notify', src, 'No Access To This Command', 'error')
                end
            elseif MRFW.Commands.List[command].permission == 'h-admin' then
                if is_h_admin or isManager or isOwner or isDev or isPrinciple then
                    if (MRFW.Commands.List[command].argsrequired and #MRFW.Commands.List[command].arguments ~= 0 and args[#MRFW.Commands.List[command].arguments] == nil) then
                        TriggerClientEvent('MRFW:Notify', src, 'All arguments must be filled out!', 'error')
                    else
                        MRFW.Commands.List[command].callback(src, args)
                    end
                else
                    TriggerClientEvent('MRFW:Notify', src, 'No Access To This Command', 'error')
                end
            elseif MRFW.Commands.List[command].permission == 'admin' then
                if isAdmin or is_h_admin or isManager or isOwner or isDev or isPrinciple then
                    if (MRFW.Commands.List[command].argsrequired and #MRFW.Commands.List[command].arguments ~= 0 and args[#MRFW.Commands.List[command].arguments] == nil) then
                        TriggerClientEvent('MRFW:Notify', src, 'All arguments must be filled out!', 'error')
                    else
                        MRFW.Commands.List[command].callback(src, args)
                    end
                else
                    TriggerClientEvent('MRFW:Notify', src, 'No Access To This Command', 'error')
                end
            elseif MRFW.Commands.List[command].permission == 'c-admin' then
                if is_c_admin or isAdmin or is_h_admin or isManager or isOwner or isDev or isPrinciple then
                    if (MRFW.Commands.List[command].argsrequired and #MRFW.Commands.List[command].arguments ~= 0 and args[#MRFW.Commands.List[command].arguments] == nil) then
                        TriggerClientEvent('MRFW:Notify', src, 'All arguments must be filled out!', 'error')
                    else
                        MRFW.Commands.List[command].callback(src, args)
                    end
                else
                    TriggerClientEvent('MRFW:Notify', src, 'No Access To This Command', 'error')
                end
            elseif MRFW.Commands.List[command].permission == 's-mod' then
                if is_s_mod or is_c_admin or isAdmin or is_h_admin or isManager or isOwner or isDev or isPrinciple then
                    if (MRFW.Commands.List[command].argsrequired and #MRFW.Commands.List[command].arguments ~= 0 and args[#MRFW.Commands.List[command].arguments] == nil) then
                        TriggerClientEvent('MRFW:Notify', src, 'All arguments must be filled out!', 'error')
                    else
                        MRFW.Commands.List[command].callback(src, args)
                    end
                else
                    TriggerClientEvent('MRFW:Notify', src, 'No Access To This Command', 'error')
                end
            elseif MRFW.Commands.List[command].permission == 'mod' then
                if isMod or is_s_mod or is_c_admin or isAdmin or is_h_admin or isManager or isOwner or isDev or isPrinciple then
                    if (MRFW.Commands.List[command].argsrequired and #MRFW.Commands.List[command].arguments ~= 0 and args[#MRFW.Commands.List[command].arguments] == nil) then
                        TriggerClientEvent('MRFW:Notify', src, 'All arguments must be filled out!', 'error')
                    else
                        MRFW.Commands.List[command].callback(src, args)
                    end
                else
                    TriggerClientEvent('MRFW:Notify', src, 'No Access To This Command', 'error')
                end
            elseif MRFW.Commands.List[command].permission == isJob then
                if MRFW.Commands.List[command].permission == isJob then
                    if (MRFW.Commands.List[command].argsrequired and #MRFW.Commands.List[command].arguments ~= 0 and args[#MRFW.Commands.List[command].arguments] == nil) then
                        TriggerClientEvent('MRFW:Notify', src, 'All arguments must be filled out!', 'error')
                    else
                        MRFW.Commands.List[command].callback(src, args)
                    end
                else
                    TriggerClientEvent('MRFW:Notify', src, 'No Access To This Command', 'error')
                end
            elseif MRFW.Commands.List[command].permission == 'user' then
                if (MRFW.Commands.List[command].argsrequired and #MRFW.Commands.List[command].arguments ~= 0 and args[#MRFW.Commands.List[command].arguments] == nil) then
                    TriggerClientEvent('MRFW:Notify', src, 'All arguments must be filled out!', 'error')
                else
                    MRFW.Commands.List[command].callback(src, args)
                end
            end
        end
    end
end)

-- Has Item Callback (can also use client function - MRFW.Functions.HasItem(item))

MRFW.Functions.CreateCallback('MRFW:HasItem', function(source, cb, items, amount)
    local src = source
    local retval = false
    local Player = MRFW.Functions.GetPlayer(src)
    if Player then
        if type(items) == 'table' then
            local count = 0
            local finalcount = 0
            for k, v in pairs(items) do
                if type(k) == 'string' then
                    finalcount = 0
                    for i, _ in pairs(items) do
                        if i then
                            finalcount = finalcount + 1
                        end
                    end
                    local item = Player.Functions.GetItemByName(k)
                    if item then
                        if item.amount >= v then
                            count = count + 1
                            if count == finalcount then
                                retval = true
                            end
                        end
                    end
                else
                    finalcount = #items
                    local item = Player.Functions.GetItemByName(v)
                    if item then
                        if amount then
                            if item.amount >= amount then
                                count = count + 1
                                if count == finalcount then
                                    retval = true
                                end
                            end
                        else
                            count = count + 1
                            if count == finalcount then
                                retval = true
                            end
                        end
                    end
                end
            end
        else
            local item = Player.Functions.GetItemByName(items)
            if item then
                if amount then
                    if item.amount >= amount then
                        retval = true
                    end
                else
                    retval = true
                end
            end
        end
    end
    cb(retval)
end)

MRFW.Functions.CreateCallback('MRFW:HasItemV2', function(source, cb, items, amount)
    local src = source
    local retval = false
    local Player = MRFW.Functions.GetPlayer(src)
    local item = nil
    if Player then
        if type(items) == 'table' then
            local count = 0
            local finalcount = 0
            for k, v in pairs(items) do
                if type(k) == 'string' then
                    finalcount = 0
                    for i, _ in pairs(items) do
                        if i then
                            finalcount = finalcount + 1
                        end
                    end
                    item = Player.Functions.GetItemByName(k)
                    if item then
                        if item.amount >= v then
                            count = count + 1
                            if count == finalcount then
                                retval = true
                            end
                        end
                    end
                else
                    finalcount = #items
                    item = Player.Functions.GetItemByName(v)
                    if item then
                        if amount then
                            if item.amount >= amount then
                                count = count + 1
                                if count == finalcount then
                                    retval = true
                                end
                            end
                        else
                            count = count + 1
                            if count == finalcount then
                                retval = true
                            end
                        end
                    end
                end
            end
        else
            item = Player.Functions.GetItemByName(items)
            if item then
                if amount then
                    if item.amount >= amount then
                        retval = true
                    end
                else
                    retval = true
                end
            end
        end
    end
    cb(retval, item)
end)