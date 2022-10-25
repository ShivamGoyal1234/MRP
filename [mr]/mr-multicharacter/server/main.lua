local MRFW = exports['mrfw']:GetCoreObject()

-- Functions

local function GiveStarterItems(source)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)

    for k, v in pairs(MRFW.Shared.StarterItems) do
        local info = {}
        if v.item == "id_card" then
            info.citizenid = Player.PlayerData.citizenid
            info.firstname = Player.PlayerData.charinfo.firstname
            info.lastname = Player.PlayerData.charinfo.lastname
            info.birthdate = Player.PlayerData.charinfo.birthdate
            info.gender = Player.PlayerData.charinfo.gender
            info.nationality = Player.PlayerData.charinfo.nationality
        elseif v.item == "driver_license" then
            info.firstname = Player.PlayerData.charinfo.firstname
            info.lastname = Player.PlayerData.charinfo.lastname
            info.birthdate = Player.PlayerData.charinfo.birthdate
            info.type = "Class C Driver License"
        end
        Player.Functions.AddItem(v.item, v.amount, false, info)
    end
end

local function loadHouseData()
    local HouseGarages = {}
    local Houses = {}
    local result = MySQL.Sync.fetchAll('SELECT * FROM houselocations', {})
    if result[1] ~= nil then
        for k, v in pairs(result) do
            local owned = false
            if tonumber(v.owned) == 1 then
                owned = true
            end
            local garage = v.garage ~= nil and json.decode(v.garage) or {}
            Houses[v.name] = {
                coords = json.decode(v.coords),
                owned = v.owned,
                price = v.price,
                locked = true,
                adress = v.label,
                tier = v.tier,
                garage = garage,
                decorations = {},
            }
            HouseGarages[v.name] = {
                label = v.label,
                takeVehicle = garage,
            }
        end
    end
    TriggerClientEvent("mr-garages:client:houseGarageConfig", -1, HouseGarages)
    TriggerClientEvent("mr-houses:client:setHouseConfig", -1, Houses)
end

-- Commands

MRFW.Commands.Add("char", "Logout of Character (Admin Only)", {}, false, function(source)
    local src = source
    MRFW.Player.Logout(src)
    TriggerClientEvent('mr-multicharacter:client:chooseChar', src)
end, "admin")

-- MRFW.Commands.Add("closeNUI", "Close Multi NUI", {}, false, function(source)
--     local src = source
--     TriggerClientEvent('mr-multicharacter:client:closeNUI', src)
-- end)

-- Events

RegisterNetEvent('mr-multicharacter:server:disconnect', function()
    local src = source
    DropPlayer(src, "You have disconnected from MRFW")
end)

RegisterNetEvent('mr-multicharacter:server:loadUserData', function(cData)
    local src = source
    if MRFW.Player.Login(src, cData.citizenid) then
        print('^2[mr-core]^7 '..GetPlayerName(src)..' (Citizen ID: '..cData.citizenid..') has succesfully loaded!')
        MRFW.Commands.Refresh(src)
        loadHouseData()
        TriggerClientEvent('apartments:client:setupSpawnUI', src, cData)
        TriggerEvent("mr-log:server:CreateLog", "joinleave", "Loaded", "green", "**".. GetPlayerName(src) .. "** ("..(MRFW.Functions.GetIdentifier(src, 'discord') or 'undefined') .." |  ||"  ..(MRFW.Functions.GetIdentifier(src, 'ip') or 'undefined') ..  "|| | " ..(MRFW.Functions.GetIdentifier(src, 'license') or 'undefined') .." | " ..cData.citizenid.." | "..src..") loaded..")
	end
end)

RegisterNetEvent('mr-multicharacter:server:createCharacter', function(data)
    local src = source
    local newData = {}
    newData.cid = data.cid
    newData.charinfo = data
    -- print(newData.charinfo.backstory)
    if MRFW.Player.Login(src, false, newData) then
        if Config.StartingApartment then
            local randbucket = (GetPlayerPed(src) .. math.random(11111111,99999999))
            -- SetPlayerRoutingBucket(src, randbucket)
            print('^2[mr-core]^7 '..GetPlayerName(src)..' has succesfully loaded!')
            MRFW.Commands.Refresh(src)
            loadHouseData()
            TriggerClientEvent("mr-multicharacter:client:closeNUI", src)
            TriggerClientEvent('apartments:client:setupSpawnUI', src, newData)
            GiveStarterItems(src)
        else
            local randbucket = ((786687)..math.random(111,999)..math.random(111,999))
            SetPlayerRoutingBucket(src, randbucket)
            print('^2[mr-core]^7 '..GetPlayerName(src)..' has succesfully loaded!')
            MRFW.Commands.Refresh(src)
            loadHouseData()
            TriggerClientEvent("mr-multicharacter:client:closeNUIdefault", src)
            GiveStarterItems(src)
        end
	end
end)


RegisterNetEvent('mr-multicharacter:server:removeBucket', function()
    local src = source
    local bucket = GetPlayerRoutingBucket(src)
    if bucket ~= 0 then
        local val,val2 = string.find(tostring(bucket), "786687")
        -- if val then
            print('^2[mr-core]^7 player removed from bucket '..bucket)
            SetPlayerRoutingBucket(src, 0)
        -- end
    end
end)

RegisterNetEvent('mr-multicharacter:server:deleteCharacter', function(citizenid)
    local src = source
    MRFW.Player.DeleteCharacter(src, citizenid)
end)

-- Callbacks

MRFW.Functions.CreateCallback("mr-multicharacter:server:GetUserCharacters", function(source, cb)
    local src = source
    local license = MRFW.Functions.GetIdentifier(src, 'license')

    MySQL.Async.fetchAll('SELECT * FROM players WHERE license = ?', {license}, function(result)
        cb(result)
    end)
end)

MRFW.Functions.CreateCallback("mr-multicharacter:server:GetServerLogs", function(source, cb)
    MySQL.Async.fetchAll('SELECT * FROM server_logs', {}, function(result)
        cb(result)
    end)
end)

MRFW.Functions.CreateCallback("mr-multicharacter:server:setupCharacters", function(source, cb)
    local license = MRFW.Functions.GetIdentifier(source, 'license')
    local plyChars = {}
    MySQL.Async.fetchAll('SELECT * FROM players WHERE license = ?', {license}, function(result)
        for i = 1, (#result), 1 do
            result[i].charinfo = json.decode(result[i].charinfo)
            result[i].money = json.decode(result[i].money)
            result[i].job = json.decode(result[i].job)
            plyChars[#plyChars+1] = result[i]
        end
        cb(plyChars)
    end)
end)

MRFW.Functions.CreateCallback("mr-multicharacter:server:getSkin", function(source, cb, cid)
    local result = MySQL.Sync.fetchAll('SELECT * FROM playerskins WHERE citizenid = ? AND active = ?', {cid, 1})
    if result[1] ~= nil then
        cb(result[1].model, result[1].skin)
    else
        cb(nil)
    end
end)
