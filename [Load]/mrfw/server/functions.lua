MRFW.Functions = {}

-- Getters
-- Get your player first and then trigger a function on them
-- ex: local player = MRFW.Functions.GetPlayer(source)
-- ex: local example = player.Functions.functionname(parameter)

function MRFW.Functions.GetCoords(entity)
    local coords = GetEntityCoords(entity, false)
    local heading = GetEntityHeading(entity)
    return vector4(coords.x, coords.y, coords.z, heading)
end

function MRFW.Functions.GetIdentifier(source, idtype)
    local src = source
    local idtype = idtype or AJConfig.IdentifierType
    for _, identifier in pairs(GetPlayerIdentifiers(src)) do
        if string.find(identifier, idtype) then
            return identifier
        end
    end
    return nil
end

function MRFW.Functions.GetSource(identifier)
    for src, player in pairs(MRFW.Players) do
        local idens = GetPlayerIdentifiers(src)
        for _, id in pairs(idens) do
            if identifier == id then
                return src
            end
        end
    end
    return 0
end

function MRFW.Functions.GetPlayer(source)
    local src = source
    if type(src) == 'number' then
        return MRFW.Players[src]
    else
        return MRFW.Players[MRFW.Functions.GetSource(src)]
    end
end

function MRFW.Functions.GetPlayerByCitizenId(citizenid)
    for src, player in pairs(MRFW.Players) do
        local cid = citizenid
        if MRFW.Players[src].PlayerData.citizenid == cid then
            return MRFW.Players[src]
        end
    end
    return nil
end

function MRFW.Functions.GetPlayerByPhone(number)
    for src, player in pairs(MRFW.Players) do
        local cid = citizenid
        if MRFW.Players[src].PlayerData.charinfo.phone == number then
            return MRFW.Players[src]
        end
    end
    return nil
end

function MRFW.Functions.GetPlayers()
    local sources = {}
    for k, v in pairs(MRFW.Players) do
        sources[#sources+1] = k
    end
    return sources
end

-- Will return an array of aj Player class instances
-- unlike the GetPlayers() wrapper which only returns IDs
function MRFW.Functions.GetAJPlayers()
    return MRFW.Players
end

function MRFW.Functions.GetPlayersOnDuty(job)
    local players = {}
    local count = 0

    for src, Player in pairs(MRFW.Players) do
        if Player.PlayerData.job.name == job then
            if Player.PlayerData.job.onduty then
                players[#players + 1] = src
                count = count + 1
            end
        end
    end
    return players, count
end

-- Returns only the amount of players on duty for the specified job
function MRFW.Functions.GetDutyCount(job)
    local count = 0

    for _, Player in pairs(MRFW.Players) do
        if Player.PlayerData.job.name == job then
            if Player.PlayerData.job.onduty then
                count = count + 1
            end
        end
    end
    return count
end

--- Routingbucket stuff (Only touch if you know what you are doing)
_G.Player_Buckets = {} -- Bucket array containing all players that have been set to a different bucket
_G.Entity_Buckets = {} -- Bucket array containing all entities that have been set to a different bucket


--- Returns the objects related to buckets, first returned value is the player buckets , second one is entity buckets
function MRFW.Functions.GetBucketObjects()
    return _G.Player_Buckets, _G.Entity_Buckets
end


--- Will set the provided player id / source into the provided bucket id
function MRFW.Functions.SetPlayerBucket(player_source --[[int]],bucket --[[int]])
    if player_source and bucket then
        local plicense = MRFW.Functions.GetIdentifier(player_source, 'license')
        SetPlayerRoutingBucket(player_source, bucket)
        _G.Player_Buckets[plicense] = {player_id = player_source, player_bucket = bucket}
        return true
    else
        return false
    end
end

--- Will set any entity into the provided bucket, for example peds / vehicles / props / etc...
function MRFW.Functions.SetEntityBucket(entity --[[int]],bucket --[[int]])
    if entity and bucket then
        SetEntityRoutingBucket(entity, bucket)
        _G.Entity_Buckets[entity] = {entity_id = entity, entity_bucket = bucket}
        return true
    else
        return false
    end
end


-- Will return an array of all the player ids inside the current bucket
function MRFW.Functions.GetPlayersInBucket(bucket --[[int]])
    local curr_bucket_pool = {}
    if _G.Player_Buckets ~= nil then
        for k, v in pairs(_G.Player_Buckets) do
            if k['player_bucket'] == bucket then
                curr_bucket_pool[#curr_bucket_pool + 1] = k['player_id']
            end
        end
        return curr_bucket_pool
    else
        return false
    end
end


--- Will return an array of all the entities inside the current bucket (Not player entities , use GetPlayersInBucket for that)
function MRFW.Functions.GetEntitiesInBucket(bucket --[[int]])
    local curr_bucket_pool = {}
    if _G.Entity_Buckets ~= nil then
        for k, v in pairs(_G.Entity_Buckets) do
            if k['entity_bucket'] == bucket then
                curr_bucket_pool[#curr_bucket_pool + 1] = k['entity_id']
            end
        end
        return curr_bucket_pool
    else
        return false
    end
end

--- Will return true / false wheter the mentioned player id is present in the bucket provided
function MRFW.Functions.IsPlayerInBucket(player_source --[[int]] ,bucket --[[int]])
    local curr_player_bucket = GetPlayerRoutingBucket(player_source)
    return curr_player_bucket == bucket
end


-- Paychecks (standalone - don't touch)

function PaycheckLoop()
    print('i just got triggered')
    local Players = MRFW.Players
    for i = 1, #Players, 1 do
        print(i)
        local Player = Players[i]
        local payment = Player.PlayerData.job.payment
        print(payment)
        if Player.PlayerData.job and Player.PlayerData.job.payment > 0 then
            print(Player.PlayerData.charinfo.firstname)
            print(Player.PlayerData.charinfo.lastname)
            print(Player.PlayerData.job)
            print(Player.PlayerData.job.payment)
            if AJConfig.Money.OnlyPayWhenDuty then
                if Player.PlayerData.job.onduty then
                    print('onduty')
                    Player.Functions.AddMoney('bank', payment)
                    TriggerClientEvent('MRFW:Notify', Player.PlayerData.source, ('You received your paycheck of $%s'):format(payment))
                    print('success')
                else
                    print('offduty')
                    local aa = payment / 100
                    local bb = aa * AJConfig.Money.Percent
                    print('calculate')
                    Player.Functions.AddMoney('bank', bb)
                    TriggerClientEvent('MRFW:Notify', Player.PlayerData.source, ('You received your paycheck of $%s'):format(payment))
                    print('success')
                end
            else
                Player.Functions.AddMoney('bank', payment)
                TriggerClientEvent('MRFW:Notify', Player.PlayerData.source, ('You received your paycheck of $%s'):format(payment))
            end
        end
    end
    SetTimeout(MRFW.Config.Money.PayCheckTimeOut * (60 * 1000), PaycheckLoop)
end

-- Callbacks

function MRFW.Functions.CreateCallback(name, cb)
    MRFW.ServerCallbacks[name] = cb
end

function MRFW.Functions.TriggerCallback(name, source, cb, ...)
    local src = source
    if MRFW.ServerCallbacks[name] then
        MRFW.ServerCallbacks[name](src, cb, ...)
    end
end

-- Items

function MRFW.Functions.CreateUseableItem(item, cb)
    MRFW.UseableItems[item] = cb
end

function MRFW.Functions.CanUseItem(item)
    return MRFW.UseableItems[item]
end

function MRFW.Functions.UseItem(source, item)
    local src = source
    MRFW.UseableItems[item.name](src, item)
end

-- Kick Player

function MRFW.Functions.Kick(source, reason, setKickReason, deferrals)
    local src = source
    reason = '\n' .. reason .. '\n🔸 Check our Discord for further information: ' .. MRFW.Config.Server.discord
    if setKickReason then
        setKickReason(reason)
    end
    CreateThread(function()
        if deferrals then
            deferrals.update(reason)
            Wait(2500)
        end
        if src then
            DropPlayer(src, reason)
        end
        local i = 0
        while (i <= 4) do
            i = i + 1
            while true do
                if src then
                    if (GetPlayerPing(src) >= 0) then
                        break
                    end
                    Wait(100)
                    CreateThread(function()
                        DropPlayer(src, reason)
                    end)
                end
            end
            Wait(5000)
        end
    end)
end

-- Check if player is whitelisted (not used anywhere)

function MRFW.Functions.IsWhitelisted(source)
    local src = source
    local plicense = MRFW.Functions.GetIdentifier(src, 'license')
    local identifiers = GetPlayerIdentifiers(src)
    if MRFW.Config.Server.whitelist then
        local result = MySQL.Sync.fetchSingle('SELECT * FROM whitelist WHERE license = ?', { plicense })
        if result then
            for _, id in pairs(identifiers) do
                if result.license == id then
                    return true
                end
            end
        end
    else
        return true
    end
    return false
end

-- Setting & Removing Permissions

function MRFW.Functions.AddPermission(source, permission)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local plicense = Player.PlayerData.license
    local pCID = Player.PlayerData.citizenid
    if Player then
        MRFW.Config.Server.PermissionList[pCID] = {
            license = plicense,
            cid = pCID,
            permission = permission:lower(),
        }
        MySQL.Async.execute('DELETE FROM permissions WHERE cid = ?', { pCID })

        MySQL.Async.insert('INSERT INTO permissions (name, license, cid, permission) VALUES (?, ?, ?, ?)', {
            GetPlayerName(src),
            plicense,
            pCID,
            permission:lower()
        })

        Player.Functions.UpdatePlayerData()
        TriggerClientEvent('MRFW:Client:OnPermissionUpdate', src, permission)
    end
end

function MRFW.Functions.RemovePermission(source)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local license = Player.PlayerData.license
    local pCID = Player.PlayerData.citizenid
    if Player then
        MRFW.Config.Server.PermissionList[pCID] = nil
        MySQL.Async.execute('DELETE FROM permissions WHERE cid = ?', { pCID })
        Player.Functions.UpdatePlayerData()
    end
end

-- Checking for Permission Level

function MRFW.Functions.HasPermission(source, permission)
    local src = source
    local license = MRFW.Functions.GetIdentifier(src, 'license')
    local Player = MRFW.Functions.GetPlayer(src)
    local permission = tostring(permission:lower())
    if permission == 'user' then
        return true
    else
        if Player then
            local pCID = Player.PlayerData.citizenid
            if MRFW.Config.Server.PermissionList[pCID] then
                if MRFW.Config.Server.PermissionList[pCID].license == license then
                    if MRFW.Config.Server.PermissionList[pCID].cid == pCID then
                        if MRFW.Config.Server.PermissionList[pCID].permission == permission or MRFW.Config.Server.PermissionList[pCID].permission == 'dev' then
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end

function MRFW.Functions.GetPermission(source)
    local src = source
    local license = MRFW.Functions.GetIdentifier(src, 'license')
    local Player = MRFW.Functions.GetPlayer(src)
    if license then
        if Player then
            local pCID = Player.PlayerData.citizenid
            if MRFW.Config.Server.PermissionList[pCID] then
                if MRFW.Config.Server.PermissionList[pCID].license == license then
                    if MRFW.Config.Server.PermissionList[pCID].cid == pCID then
                        return MRFW.Config.Server.PermissionList[pCID].permission
                    end
                end
            end
        end
    end
    return 'user'
end

-- Opt in or out of admin reports

function MRFW.Functions.IsOptin(source)
    local src = source
    local license = MRFW.Functions.GetIdentifier(src, 'license')
    local Player = MRFW.Functions.GetPlayer(src)
    if Player then
        local pCID = Player.PlayerData.citizenid
        if MRFW.Functions.HasPermission(src, 'dev') then
            return MRFW.Config.Server.PermissionList[pCID].optin
        elseif MRFW.Functions.HasPermission(src, 'owner') then
            return MRFW.Config.Server.PermissionList[pCID].optin
        elseif MRFW.Functions.HasPermission(src, 'manager') then
            return MRFW.Config.Server.PermissionList[pCID].optin
        elseif MRFW.Functions.HasPermission(src, 'h-admin') then
            return MRFW.Config.Server.PermissionList[pCID].optin
        elseif MRFW.Functions.HasPermission(src, 'admin') then
            return MRFW.Config.Server.PermissionList[pCID].optin
        elseif MRFW.Functions.HasPermission(src, 'c-admin') then
            return MRFW.Config.Server.PermissionList[pCID].optin
        elseif MRFW.Functions.HasPermission(src, 's-mod') then
            return MRFW.Config.Server.PermissionList[pCID].optin
        elseif MRFW.Functions.HasPermission(src, 'mod') then
            return MRFW.Config.Server.PermissionList[pCID].optin
        end
    end
    return false
end

function MRFW.Functions.ToggleOptin(source)
    local src = source
    local license = MRFW.Functions.GetIdentifier(src, 'license')
    local Player = MRFW.Functions.GetPlayer(src)
    if Player then
        local pCID = Player.PlayerData.citizenid
        if MRFW.Functions.HasPermission(src, 'dev') then
            MRFW.Config.Server.PermissionList[pCID].optin = not MRFW.Config.Server.PermissionList[pCID].optin
        elseif TJFW.Functions.HasPermission(src, 'owner') then
            MRFW.Config.Server.PermissionList[pCID].optin = not MRFW.Config.Server.PermissionList[pCID].optin
        elseif TJFW.Functions.HasPermission(src, 'manager') then
            MRFW.Config.Server.PermissionList[pCID].optin = not MRFW.Config.Server.PermissionList[pCID].optin
        elseif TJFW.Functions.HasPermission(src, 'h-admin') then
            MRFW.Config.Server.PermissionList[pCID].optin = not MRFW.Config.Server.PermissionList[pCID].optin
        elseif TJFW.Functions.HasPermission(src, 'admin') then
            MRFW.Config.Server.PermissionList[pCID].optin = not MRFW.Config.Server.PermissionList[pCID].optin
        elseif TJFW.Functions.HasPermission(src, 'c-admin') then
            MRFW.Config.Server.PermissionList[pCID].optin = not MRFW.Config.Server.PermissionList[pCID].optin
        elseif TJFW.Functions.HasPermission(src, 's-mod') then
            MRFW.Config.Server.PermissionList[pCID].optin = not MRFW.Config.Server.PermissionList[pCID].optin
        elseif TJFW.Functions.HasPermission(src, 'mod') then
            MRFW.Config.Server.PermissionList[pCID].optin = not MRFW.Config.Server.PermissionList[pCID].optin
        end
    end
end

-- Check if player is banned

function MRFW.Functions.IsPlayerBanned(source)
    local src = source
    local retval = false
    local message = ''
    local plicense = MRFW.Functions.GetIdentifier(src, 'license')
    local result = MySQL.Sync.fetchSingle('SELECT * FROM bans WHERE license = ?', { plicense })
    if result then
        if os.time() < result.expire then
            retval = true
            local timeTable = os.date('*t', tonumber(result.expire))
            message = 'You have been banned from the server:\n' .. result.reason .. '\nYour ban expires ' .. timeTable.day .. '/' .. timeTable.month .. '/' .. timeTable.year .. ' ' .. timeTable.hour .. ':' .. timeTable.min .. '\n'
        else
            MySQL.Async.execute('DELETE FROM bans WHERE id = ?', { result.id })
        end
    end
    return retval, message
end

-- Check for duplicate license

function MRFW.Functions.IsLicenseInUse(license)
    local players = GetPlayers()
    for _, player in pairs(players) do
        local identifiers = GetPlayerIdentifiers(player)
        for _, id in pairs(identifiers) do
            if string.find(id, 'license') then
                local playerLicense = id
                if playerLicense == license then
                    return true
                end
            end
        end
    end
    return false
end

function SecondsToClock(seconds)
	local days = math.floor(seconds / 86400)
	seconds = seconds - days * 86400
	local hours = math.floor(seconds / 3600 )
	seconds = seconds - hours * 3600
	local minutes = math.floor(seconds / 60)
	seconds = seconds - minutes * 60

	if days == 0 and hours == 0 and minutes == 0 then
		return string.format("%d seconds.", seconds)
	elseif days == 0 and hours == 0 then
		return string.format("%d minutes, %d seconds.", minutes, seconds)
	elseif days == 0 then
		return string.format("%d hours, %d minutes, %d seconds.", hours, minutes, seconds)
	else
		return string.format("%d days, %d hours, %d minutes, %d seconds.", days, hours, minutes, seconds)
	end
	return string.format("%d days, %d hours, %d minutes, %d seconds.", days, hours, minutes, seconds)
end

function playerJoin(citizenid)
	local result = MySQL.query.await('SELECT * FROM player_playtime WHERE citizenid = ?', {citizenid})
	if result[1] ~= nil then
		MySQL.query.await('UPDATE player_playtime SET lastJoin = ?, lastLeave = 0 WHERE citizenid = ?', {os.time(os.date("!*t")), citizenid})
	else
		MySQL.query.await('INSERT INTO player_playtime (citizenid, playTime, lastJoin, lastLeave) VALUES (?, 0, ?, 0);', {citizenid, os.time(os.date("!*t"))})
	end
end

function playerDrop(citizenid)
	local timeNow = os.time(os.date("!*t"))
	local result = MySQL.query.await('SELECT * FROM player_playtime WHERE citizenid = ?', {citizenid})

	local result = MySQL.query.await('SELECT * FROM player_playtime WHERE citizenid = ?', {citizenid})
	if result[1] ~= nil then
		local playTime = timeNow - result[1].lastJoin
		print(playTime)
		MySQL.query.await('UPDATE player_playtime SET playTime = ?, lastLeave = ? WHERE citizenid = ?', {(playTime + result[1].playTime), timeNow, citizenid})
	end
end

function GenerateSecretCode()
    local final 
    local result = json.decode(LoadResourceFile(GetCurrentResourceName(), "./lib/secret.json"))
    print(result.code)
    repeat
        local a = tostring(MRShared.RandomStr(5))
        local b = tostring(MRShared.RandomInt(3))
        local c = tostring(MRShared.RandomStr(6))
        local d = tostring(MRShared.RandomInt(2))
        local e = tostring(MRShared.RandomStr(3))
        local f = tostring(MRShared.RandomInt(7))
        local g = tostring(MRShared.RandomStr(5))
        local h = tostring(MRShared.RandomInt(4))
        local i = tostring(MRShared.RandomStr(2))
        local j = tostring(MRShared.RandomInt(6))
        final = a..b..c..d..e..f..g..h..i..j
    until final ~= result.code
    result.code = final
    SaveResourceFile(GetCurrentResourceName(), "./lib/secret.json", json.encode(result), -1)
    TriggerEvent('change:secret:pd', final)
    TriggerClientEvent('aj-radio:LeaveRestrictedRadio', -1)
end

function GetSecretCode()
    local result = json.decode(LoadResourceFile(GetCurrentResourceName(), "./lib/secret.json"))
    return result.code
end