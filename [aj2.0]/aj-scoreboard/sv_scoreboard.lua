AJFW = exports['ajfw']:GetCoreObject()

local queue = {}

local ST = ST or {}
ST.Scoreboard = {}
ST._Scoreboard = {}
ST._Scoreboard.PlayersS = {}
ST._Scoreboard.RecentS = {}

AJFW.Functions.CreateCallback('jacob:custom:getperms', function(source, cb)
    local group = AJFW.Functions.GetPermission(source)
    cb(group)
end)

AJFW.Functions.CreateCallback('Jacob:custom:count', function(source, cb)
    local TotalPlayers = 0
    for k, v in pairs(AJFW.Functions.GetPlayers()) do
        TotalPlayers = TotalPlayers + 1
    end
    cb(TotalPlayers)
end)

RegisterServerEvent('st-scoreboard:AddPlayer')
AddEventHandler("st-scoreboard:AddPlayer", function()

    local identifiers, steamIdentifier = GetPlayerIdentifiers(source)
    for _, v in pairs(identifiers) do
        if string.find(v, "license") then
            steamIdentifier = v
            break
        end
    end
    local priority
    for k,v in pairs(queue) do
        if k == steamIdentifier then
            priority = v
            break
        else
            priority = 0
        end
    end
    local group = AJFW.Functions.GetPermission(source)
    local stid = string.sub(steamIdentifier, 9)
    local ply = GetPlayerName(source)
    local scomid = steamIdentifier:gsub("steam:", "")
    local data = { src = source, steamid = stid, comid = scomid, name = ply , gg = group, pri = priority }

    TriggerClientEvent("st-scoreboard:AddPlayer", -1, data )
    ST.Scoreboard.AddAllPlayers()
end)

function ST.Scoreboard.AddAllPlayers(self)
    local xPlayers   = AJFW.Functions.GetPlayers()

    for i=1, #xPlayers, 1 do
        
        local identifiers, steamIdentifier = GetPlayerIdentifiers(xPlayers[i])
        for _, v in pairs(identifiers) do
            if string.find(v, "license") then
                steamIdentifier = v
                break
            end
        end
        local priority
        for k,v in pairs(queue) do
            if k == steamIdentifier then
                priority = v
                break
            else
                priority = 0
            end
        end
        local group = AJFW.Functions.GetPermission(xPlayers[i])
        local stid = string.sub(steamIdentifier, 9)
        local ply = GetPlayerName(xPlayers[i])
        local scomid = steamIdentifier:gsub("steam:", "")
        local data = { src = xPlayers[i], steamid = stid, comid = scomid, name = ply , gg = group, pri = priority}

        TriggerClientEvent("st-scoreboard:AddAllPlayers", source, data, recentData)

    end
end

function ST.Scoreboard.AddPlayerS(self, data)
    ST._Scoreboard.PlayersS[data.src] = data
end

AddEventHandler("playerDropped", function()
	local identifiers, steamIdentifier = GetPlayerIdentifiers(source)
    for _, v in pairs(identifiers) do
        if string.find(v, "license") then
            steamIdentifier = v
            break
        end
    end

    local stid = string.sub(steamIdentifier, 8)
    local ply = GetPlayerName(source)
    local scomid = steamIdentifier:gsub("steam:", "")
    local plyid = source
    local data = { src = source, steamid = stid, comid = scomid, name = ply }

    TriggerClientEvent("st-scoreboard:RemovePlayer", -1, data )
    Wait(600000)
    TriggerClientEvent("st-scoreboard:RemoveRecent", -1, plyid)
end)

--[[ function ST.Scoreboard.RemovePlayerS(self, data)
    ST._Scoreboard.RecentS = data
end

function ST.Scoreboard.RemoveRecentS(self, src)
    ST._Scoreboard.RecentS.src = nil
end ]]

function HexIdToSteamId(hexId)
    local cid = math.floor(tonumber(string.sub(hexId, 7), 16))
	local steam64 = math.floor(tonumber(string.sub( cid, 2)))
	local a = steam64 % 2 == 0 and 0 or 1
	local b = math.floor(math.abs(6561197960265728 - steam64 - a) / 2)
	local sid = "STEAM_0:"..a..":"..(a == 1 and b -1 or b)
    return sid
end

function loaddb()
    local db = MySQL.Sync.fetchAll('SELECT * FROM queue')
    if db ~= nil then
        for k,v in pairs(db) do
            queue[v.license] = v.priority
        end
    end
end

AddEventHandler('onResourceStart', function(resource)
   if resource == GetCurrentResourceName() then
    local xPlayers   = AJFW.Functions.GetPlayers()
    for k,v in pairs(xPlayers) do
        local Player = AJFW.Functions.GetPlayer(v)
        TriggerClientEvent('scoreboard:refresh:onStart', Player.PlayerData.source)
        Wait(100)
    end
   end
end)

CreateThread(function()
    Wait(1000)
    loaddb()
    Wait(3000)
    for k,v in pairs(queue)do
        -- print(k,v)
    end
end)