local MRFW = exports['mrfw']:GetCoreObject()
local houseowneridentifier = {}
local houseownercid = {}
local housekeyholders = {}
local housesLoaded = false
local NumberCharset = {}
local Charset = {}
for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

local Frniture = {}

Citizen.CreateThread(function()
    local result = exports['mr-furniture']:getFurniture()
    Frniture = result
end)

MRFW.Functions.CreateCallback('mr-houses:server:getfurnituretable', function(source, cb)
    cb(Frniture)
end)

MRFW.Commands.Add('refreshftable', 'help text here', {}, false, function(source, args)
    local result = exports['mr-furniture']:getFurniture()
    Frniture = result
    TriggerClientEvent('mr-houses:server:postfurnituretable', -1, Frniture)
end,'dev')

-- Threads

Citizen.CreateThread(function()
    local HouseGarages = {}
    local result = MySQL.Sync.fetchAll('SELECT * FROM houselocations', {})
    if result[1] then
        for k, v in pairs(result) do
            local owned = false
            if tonumber(v.owned) == 1 then
                owned = true
            end
            local garage = json.decode(v.garage) or {}
            Config.Houses[v.name] = {
                coords = json.decode(v.coords),
                owned = v.owned,
                price = v.price,
                locked = true,
                adress = v.label,
                tier = v.tier,
                garage = garage,
                decorations = {}
            }
            HouseGarages[v.name] = {
                label = v.label,
                takeVehicle = garage
            }
        end
    end
    TriggerClientEvent("mr-garages:client:houseGarageConfig", -1, HouseGarages)
    TriggerClientEvent("mr-houses:client:setHouseConfig", -1, Config.Houses)
    -- FIXING HOUSES
    --[[for k,v in pairs(Config.Houses) do
        -- need k for k
        for a,b in pairs(v) do
            if a == 'coords' then
                if b.shell ~= nil then
                    print(b.shell.x,b.shell.y,b.shell.z)
                else
                    print('Fixing '..k)
                    local coords = {
                        enter 	= { x = b.enter.x, y = b.enter.y, z = b.enter.z, h = b.enter.h},
                        cam 	= { x = b.enter.x, y = b.enter.y, z = b.enter.z, h = b.enter.h, yaw = -10.00},
                        shell   = { x = b.enter.x, y = b.enter.y, z = b.enter.z - Config.MinZOffset},
                    }
                    local finalc = json.encode(coords)
                    MySQL.Async.execute('UPDATE houselocations SET coords = ? WHERE name = ?',{finalc, k})
                end
            end
        end
    end
    local HouseGarages = {}
    local result = MySQL.Sync.fetchAll('SELECT * FROM houselocations', {})
    if result[1] then
        for k, v in pairs(result) do
            local owned = false
            if tonumber(v.owned) == 1 then
                owned = true
            end
            local garage = json.decode(v.garage) or {}
            Config.Houses[v.name] = {
                coords = json.decode(v.coords),
                owned = v.owned,
                price = v.price,
                locked = true,
                adress = v.label,
                tier = v.tier,
                garage = garage,
                decorations = {}
            }
            HouseGarages[v.name] = {
                label = v.label,
                takeVehicle = garage
            }
        end
    end
    TriggerClientEvent("mr-garages:client:houseGarageConfig", -1, HouseGarages)
    TriggerClientEvent("mr-houses:client:setHouseConfig", -1, Config.Houses)]]
end)

local transfercitizenid = 'HDB41580'
local transferlicense = 'license:9eba7a10f13a64fb41acfc432989e2a037c7ba3b'

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3600000)
        local result = MySQL.Sync.fetchAll('SELECT * FROM player_houses', {})
        if result[1] then
            for _,house in pairs(result) do
                if house.rentcheck == 1 then
                    if house.renttime > 0 then
                        local final = house.renttime - 1
                        MySQL.Async.execute('UPDATE player_houses SET renttime = ? WHERE id = ?', {final, house.id})
                    else
                        if house.rentcooldown > 0 then
                            local final = house.rentcooldown - 1
                            MySQL.Async.execute('UPDATE player_houses SET rentcooldown = ? WHERE id = ?', {final, house.id})
                            local Player = MRFW.Functions.GetPlayerByCitizenId(house.citizenid)
                            if Player ~= nil then
                                TriggerClientEvent("MRFW:Notify", Player.PlayerData.source, "Your house will be seized in "..house.rentcooldown.." hours if you didn't pay your rent", "error", 10000)
                            end
                        else
                            local Player = MRFW.Functions.GetPlayerByCitizenId(house.citizenid)
                            if Player ~= nil then
                                TriggerClientEvent("MRFW:Notify", Player.PlayerData.source, "Your house is seized now because you didn't pay your rent", "error", 10000)
                            end
                            MySQL.Async.execute('UPDATE player_houses SET rentcheck = ? WHERE id = ?', {0, house.id})
                            Wait(100)
                            MySQL.Async.execute('UPDATE player_houses SET citizenid = ?, identifier = ? WHERE id = ?', {transfercitizenid, transferlicense, house.id})
                            MySQL.Async.execute('UPDATE player_houses SET keyholders = ? WHERE id = ?', {"[\""..transfercitizenid.."\"]", house.id})
                            TriggerEvent("mr-log:server:CreateLog", 'house-seize', "House Seized", "blue", "```House: "..house.house..'\nID: '..house.id..'```')
                        end
                    end
                end
            end
        end
    end
end)

MRFW.Commands.Add('giverenthouse', 'Give House on rent', {{name = "id", help = "house number"},{name = "player", help = "player server id"},{name = "amount", help = "in number"},{name = "week", help = "in number"}}, false, function(source, args)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local houseid = tonumber(args[1])
    local target = tonumber(args[2])
    local amount = tonumber(args[3])
    local weeks = tonumber(args[4])
    local tPlayer = MRFW.Functions.GetPlayer(target)
    if Player.PlayerData.job.grade.name == "Company Owner" then
        if houseid ~= nil then
            if tPlayer ~= nil then
                if amount ~= nil and amount > 0 then
                    if weeks ~= nil and weeks > 0 and weeks <= 6 then
                        local result = MySQL.Sync.fetchAll("SELECT * FROM player_houses WHERE id = ?",{houseid})
                        if result[1] ~= nil then
                            if result[1].citizenid == Player.PlayerData.citizenid then
                                local query = 'UPDATE player_houses SET citizenid = ?, identifier = ?, keyholders = ?, rentcheck = 1, rentamount = ?, renttime = 168, rentcooldown = 24, rentremaining = ? WHERE id = ?'
                                MySQL.Async.execute(query, {
                                    tPlayer.PlayerData.citizenid,
                                    tPlayer.PlayerData.license,
                                    '["'..tPlayer.PlayerData.citizenid..'"]',
                                    amount,
                                    weeks,
                                    result[1].id
                                })
                            else
                                TriggerClientEvent("MRFW:Notify", src, "you don't own this house", "error", 3000)
                            end
                        else
                            TriggerClientEvent("MRFW:Notify", src, "Can't find house", "error", 3000)
                        end
                    else
                        TriggerClientEvent("MRFW:Notify", src, "Invalid usage", "error", 3000)
                    end  
                else
                    TriggerClientEvent("MRFW:Notify", src, "Invalid usage", "error", 3000)
                end
            else
                TriggerClientEvent("MRFW:Notify", src, "Player Not Online", "error", 3000)
            end
        else
            TriggerClientEvent("MRFW:Notify", src, "Invalid usage", "error", 3000)
        end
    else
        TriggerClientEvent("MRFW:Notify", src, "You are not a company owner", "error", 3000)
    end
end, 'realestate')

MRFW.Commands.Add('checkhouserent', 'Check House rent', {{name = "id", help = "house number"}}, false, function(source, args)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local houseid = tonumber(args[1])
    if Player then
        local result = MySQL.Sync.fetchAll("SELECT * FROM player_houses WHERE id = ?",{houseid})
        if result[1] ~= nil then
            if result[1].citizenid == Player.PlayerData.citizenid then
                if result[1].rentcheck == 1 then
                    if result[1].renttime > 0 then
                        TriggerClientEvent('chat:addMessage', src, {
                            template = "<div class=chat-message server'><strong>Amount To Pay</strong>: ${0}<br><strong>Weeks Left</strong>: {1}.<br><strong>Repay time</strong>: {2} hour(s).<br></div>",
                            args = {result[1].rentamount, result[1].rentremaining, result[1].renttime}
                        })
                    else
                        if result[1].rentcooldown > 0 then
                            TriggerClientEvent('chat:addMessage', src, {
                                template = "<div class=chat-message server'><strong>Amount To Pay</strong>: ${0}<br><strong>Weeks Left</strong>: {1}.<br><strong>Repay time before seize</strong>: {2} hour(s).<br></div>",
                                args = {result[1].rentamount, result[1].rentremaining, result[1].rentcooldown}
                            })
                        end
                    end
                end
            end 
        end
    end
end)

MRFW.Commands.Add('payhouserent', 'Pay House Rent', {{name = "id", help = "house number"}}, false, function(source, args)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local houseid = tonumber(args[1])
    local bankbalance = Player.PlayerData.money.bank
    if Player then
        local result = MySQL.Sync.fetchAll("SELECT * FROM player_houses WHERE id = ?",{houseid})
        if result[1] ~= nil then
            if result[1].citizenid == Player.PlayerData.citizenid then
                if result[1].rentcheck == 1 then
                    if result[1].renttime > 0 then
                        if result[1].rentremaining > 1 then
                            local timeremaining = result[1].renttime + 168
                            local weeksleft = result[1].rentremaining - 1
                            local rentpay = result[1].rentamount
                            if bankbalance >= rentpay then
                                Player.Functions.RemoveMoney('bank', rentpay, 'pay house rent')
                                TriggerEvent('mr-bossmenu:server:addAccountMoney', "government", rentpay)
                                local query = 'UPDATE player_houses SET  renttime = ?, rentremaining = ? WHERE id = ?'
                                MySQL.Async.execute(query, {
                                    timeremaining,
                                    weeksleft,
                                    result[1].id
                                })
                                TriggerEvent("mr-log:server:CreateLog", 'house-rent', "Rent Paied", "blue", "```Amount: "..rentpay..'\nID: '..result[1].id..'\nHouse: '..result[1].house..'\ncitizenid: '..result[1].citizenid..'```')
                            else
                                TriggerClientEvent("MRFW:Notify", src, "Not Enough money in bank", "error", 5000)
                            end
                        else
                            local rentpay = result[1].rentamount
                            Player.Functions.RemoveMoney('bank', rentpay, 'pay house rent')
                            TriggerEvent('mr-bossmenu:server:addAccountMoney', "government", rentpay)
                            local query = 'UPDATE player_houses SET rentcheck = 0, rentamount = 0, renttime = 0, rentcooldown = 0, rentremaining = 0 WHERE id = ?'
                            MySQL.Async.execute(query,{result[1].id})
                            TriggerEvent("mr-log:server:CreateLog", 'house-rent', "Rent Paied", "blue", "```Amount: "..rentpay..'\nID: '..result[1].id..'\nHouse: '..result[1].house..'\ncitizenid: '..result[1].citizenid..'```')
                        end
                    else
                        if result[1].rentcooldown > 1 then
                            local timeremaining = 168 - (24 - result[1].rentcooldown)
                            local weeksleft = result[1].rentremaining - 1
                            local rentpay = result[1].rentamount
                            if bankbalance >= rentpay then
                                Player.Functions.RemoveMoney('bank', rentpay, 'pay house rent')
                                TriggerEvent('mr-bossmenu:server:addAccountMoney', "government", rentpay)
                                local query = 'UPDATE player_houses SET  renttime = ?, rentcooldown = 24, rentremaining = ? WHERE id = ?'
                                MySQL.Async.execute(query, {
                                    timeremaining,
                                    weeksleft,
                                    result[1].id
                                })
                                TriggerEvent("mr-log:server:CreateLog", 'house-rent', "Rent Paied", "blue", "```Amount: "..rentpay..'\nID: '..result[1].id..'\nHouse: '..result[1].house..'\ncitizenid: '..result[1].citizenid..'```')
                            else
                                TriggerClientEvent("MRFW:Notify", src, "Not Enough money in bank", "error", 5000)
                            end
                        else
                            local rentpay = result[1].rentamount
                            Player.Functions.RemoveMoney('bank', rentpay, 'pay house rent')
                            TriggerEvent('mr-bossmenu:server:addAccountMoney', "government", rentpay)
                            local query = 'UPDATE player_houses SET rentcheck = 0, rentamount = 0, renttime = 0, rentcooldown = 0, rentremaining = 0 WHERE id = ?'
                            MySQL.Async.execute(query,{result[1].id})
                            TriggerEvent("mr-log:server:CreateLog", 'house-rent', "Rent Paied", "blue", "```Amount: "..rentpay..'\nID: '..result[1].id..'\nHouse: '..result[1].house..'\ncitizenid: '..result[1].citizenid..'```')
                        end
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if not housesLoaded then
            MySQL.Async.fetchAll('SELECT * FROM player_houses', {}, function(houses)
                if houses then
                    for _, house in pairs(houses) do
                        houseowneridentifier[house.house] = house.identifier
                        houseownercid[house.house] = house.citizenid
                        housekeyholders[house.house] = json.decode(house.keyholders)
                    end
                end
            end)
            housesLoaded = true
        end
        Citizen.Wait(5)
    end
end)

-- Commands

MRFW.Commands.Add("decorate", "Decorate Interior", {}, false, function(source)
    local src = source
    TriggerClientEvent("mr-houses:client:decorate", src)
end)

local tierprice = {
    [1] = 10000,
    [2] = 15000,
    [3] = 20000,
    [4] = 18000,
    [5] = 20000,
    [6] = 25000,
    [7] = 30000,
    [8] = 50000,
    [9] = 60000,
    [10] = 55000,
    [11] = 65000,
    [12] = 50000,
    [13] = 50000,
    [14] = 50000,
    [15] = 50000,
    [16] = 60000,
    [17] = 25000,
} 

MRFW.Commands.Add("createhouse", "Create House (Real Estate Only)", {{name = "citizenid", help = "Citizenid of the house"}, {name = "tier", help = "Name of the item(no label)"}}, true, function(source, args)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    -- print(src)
    local target = MRFW.Functions.GetPlayer(tonumber(args[1]))
    -- print(target)
    if target ~= nil then
        local citizenid = target.PlayerData.citizenid
        local tier = tonumber(args[2])
        local bank = Player.PlayerData.money['bank']
        if Player.PlayerData.job.grade.name == "Builder" then
            if tier ~= 0 and tier <= 17 then
                if tier == 1 then
                    if bank >= tierprice[tier] then
                        Player.Functions.RemoveMoney('bank', tierprice[tier], "Created Tier "..tier)
                        TriggerClientEvent("mr-houses:client:createHouses", src, citizenid, tier)
                    else
                        TriggerClientEvent('MRFW:Notify', src, "Not Enough Money", "error")
                    end
                elseif tier == 2 then
                    if bank >= tierprice[tier] then
                        Player.Functions.RemoveMoney('bank', tierprice[tier], "Created Tier "..tier)
                        TriggerClientEvent("mr-houses:client:createHouses", src, citizenid, tier)
                    else
                        TriggerClientEvent('MRFW:Notify', src, "Not Enough Money", "error")
                    end
                elseif tier == 3 then
                    if bank >= tierprice[tier] then
                        Player.Functions.RemoveMoney('bank', tierprice[tier], "Created Tier "..tier)
                        TriggerClientEvent("mr-houses:client:createHouses", src, citizenid, tier)
                    else
                        TriggerClientEvent('MRFW:Notify', src, "Not Enough Money", "error")
                    end
                elseif tier == 4 then
                    if bank >= tierprice[tier] then
                        Player.Functions.RemoveMoney('bank', tierprice[tier], "Created Tier "..tier)
                        TriggerClientEvent("mr-houses:client:createHouses", src, citizenid, tier)
                    else
                        TriggerClientEvent('MRFW:Notify', src, "Not Enough Money", "error")
                    end
                elseif tier == 5 then
                    if bank >= tierprice[tier] then
                        Player.Functions.RemoveMoney('bank', tierprice[tier], "Created Tier "..tier)
                        TriggerClientEvent("mr-houses:client:createHouses", src, citizenid, tier)
                    else
                        TriggerClientEvent('MRFW:Notify', src, "Not Enough Money", "error")
                    end
                elseif tier == 6 then
                    if bank >= tierprice[tier] then
                        Player.Functions.RemoveMoney('bank', tierprice[tier], "Created Tier "..tier)
                        TriggerClientEvent("mr-houses:client:createHouses", src, citizenid, tier)
                    else
                        TriggerClientEvent('MRFW:Notify', src, "Not Enough Money", "error")
                    end
                elseif tier == 7 then
                    if bank >= tierprice[tier] then
                        Player.Functions.RemoveMoney('bank', tierprice[tier], "Created Tier "..tier)
                        TriggerClientEvent("mr-houses:client:createHouses", src, citizenid, tier)
                    else
                        TriggerClientEvent('MRFW:Notify', src, "Not Enough Money", "error")
                    end
                elseif tier == 8 then
                    if bank >= tierprice[tier] then
                        Player.Functions.RemoveMoney('bank', tierprice[tier], "Created Tier "..tier)
                        TriggerClientEvent("mr-houses:client:createHouses", src, citizenid, tier)
                    else
                        TriggerClientEvent('MRFW:Notify', src, "Not Enough Money", "error")
                    end
                elseif tier == 9 then
                    if bank >= tierprice[tier] then
                        Player.Functions.RemoveMoney('bank', tierprice[tier], "Created Tier "..tier)
                        TriggerClientEvent("mr-houses:client:createHouses", src, citizenid, tier)
                    else
                        TriggerClientEvent('MRFW:Notify', src, "Not Enough Money", "error")
                    end
                elseif tier == 10 then
                    if bank >= tierprice[tier] then
                        Player.Functions.RemoveMoney('bank', tierprice[tier], "Created Tier "..tier)
                        TriggerClientEvent("mr-houses:client:createHouses", src, citizenid, tier)
                    else
                        TriggerClientEvent('MRFW:Notify', src, "Not Enough Money", "error")
                    end
                elseif tier == 11 then
                    if bank >= tierprice[tier] then
                        Player.Functions.RemoveMoney('bank', tierprice[tier], "Created Tier "..tier)
                        TriggerClientEvent("mr-houses:client:createHouses", src, citizenid, tier)
                    else
                        TriggerClientEvent('MRFW:Notify', src, "Not Enough Money", "error")
                    end
                elseif tier == 12 then
                    if bank >= tierprice[tier] then
                        Player.Functions.RemoveMoney('bank', tierprice[tier], "Created Tier "..tier)
                        TriggerClientEvent("mr-houses:client:createHouses", src, citizenid, tier)
                    else
                        TriggerClientEvent('MRFW:Notify', src, "Not Enough Money", "error")
                    end
                elseif tier == 13 then
                    if bank >= tierprice[tier] then
                        Player.Functions.RemoveMoney('bank', tierprice[tier], "Created Tier "..tier)
                        TriggerClientEvent("mr-houses:client:createHouses", src, citizenid, tier)
                    else
                        TriggerClientEvent('MRFW:Notify', src, "Not Enough Money", "error")
                    end
                elseif tier == 14 then
                    if bank >= tierprice[tier] then
                        Player.Functions.RemoveMoney('bank', tierprice[tier], "Created Tier "..tier)
                        TriggerClientEvent("mr-houses:client:createHouses", src, citizenid, tier)
                    else
                        TriggerClientEvent('MRFW:Notify', src, "Not Enough Money", "error")
                    end
                elseif tier == 15 then
                    if bank >= tierprice[tier] then
                        Player.Functions.RemoveMoney('bank', tierprice[tier], "Created Tier "..tier)
                        TriggerClientEvent("mr-houses:client:createHouses", src, citizenid, tier)
                    else
                        TriggerClientEvent('MRFW:Notify', src, "Not Enough Money", "error")
                    end
                elseif tier == 16 then
                    if bank >= tierprice[tier] then
                        Player.Functions.RemoveMoney('bank', tierprice[tier], "Created Tier "..tier)
                        TriggerClientEvent("mr-houses:client:createHouses", src, citizenid, tier)
                    else
                        TriggerClientEvent('MRFW:Notify', src, "Not Enough Money", "error")
                    end
                elseif tier == 17 then
                    if bank >= tierprice[tier] then
                        Player.Functions.RemoveMoney('bank', tierprice[tier], "Created Tier "..tier)
                        TriggerClientEvent("mr-houses:client:createHouses", src, citizenid, tier)
                    else
                        TriggerClientEvent('MRFW:Notify', src, "Not Enough Money", "error")
                    end
                end
            else
                TriggerClientEvent('MRFW:Notify', src, "Invalid Tier Number", "error")
            end
        else
            TriggerClientEvent('MRFW:Notify', src, "Only realestate can use this command", "error")
        end
    else
        TriggerClientEvent("MRFW:Notify", src, "Player Not Online", "error", 3000)
    end
end, 'realestate')

MRFW.Commands.Add("addgarage", "Add House Garage (Real Estate Only)", {}, false, function(source)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "realestate" and Player.PlayerData.job.grade.name == "Builder" then
        TriggerClientEvent("mr-houses:client:addGarage", src)
    else
        TriggerClientEvent('MRFW:Notify', src, "Only realestate can use this command", "error")
    end
end, 'realestate')

MRFW.Commands.Add("ring", "Ring The Doorbell", {}, false, function(source)
    local src = source
    TriggerClientEvent('mr-houses:client:RequestRing', src)
end)

-- Item

MRFW.Functions.CreateUseableItem("police_stormram", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
    if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
        TriggerClientEvent("mr-houses:client:HomeInvasion", source)
    else
        TriggerClientEvent('MRFW:Notify', source, "This is only possible for emergency services!", "error")
    end
end)

-- Functions

local function hasKey(identifier, cid, house)
    if houseowneridentifier[house] and houseownercid[house] then
        if houseowneridentifier[house] == identifier and houseownercid[house] == cid then
            return true
        else
            if housekeyholders[house] then
                for i = 1, #housekeyholders[house], 1 do
                    if housekeyholders[house][i] == cid then
                        return true
                    end
                end
            end
        end
    end
    return false
end

exports('hasKey', hasKey)

local function GetHouseStreetCount(street)
    local count = 1
    local query = '%' .. street .. '%'
    local result = MySQL.Sync.fetchAll('SELECT * FROM houselocations WHERE name LIKE ?', {query})
    if result[1] then
        for i = 1, #result, 1 do
            count = count + 1
        end
    end
    return count
end

local function escape_sqli(source)
    local replacements = {
        ['"'] = '\\"',
        ["'"] = "\\'"
    }
    return source:gsub("['\"]", replacements)
end

-- Events

RegisterNetEvent('mr-houses:server:setHouses', function()
    local src = source
    TriggerClientEvent("mr-houses:client:setHouseConfig", src, Config.Houses)
end)

RegisterNetEvent('mr-houses:server:addNewHouse', function(street, heading, citizenid, tier, pos)
    local src = source
    local street = street:gsub("%'", "")
    local citizenid = tostring(citizenid)
    local price = tonumber(price)
    local tier = tonumber(tier)
    local houseCount = GetHouseStreetCount(street)
    local name = street:lower() .. tostring(houseCount)
    local label = street .. " " .. tostring(houseCount)
    local coords = {
        enter 	= { x = pos.x, y = pos.y, z = pos.z, h = heading},
        cam 	= { x = pos.x, y = pos.y, z = pos.z, h = heading, yaw = -10.00},
        shell   = { x = pos.x, y = pos.y, z = pos.z - Config.MinZOffset},
    }
    MySQL.Async.insert('INSERT INTO houselocations (name, label, coords, owned, citizenid, tier) VALUES (?, ?, ?, ?, ?, ?)',
        {name, label, json.encode(coords), 0, citizenid, tier})
    Config.Houses[name] = {
        coords = coords,
        owned = false,
        price = price,
        locked = true,
        adress = label,
        tier = tier,
        garage = {},
        decorations = {}
    }
    TriggerClientEvent("mr-houses:client:setHouseConfig", -1, Config.Houses)
    TriggerClientEvent('MRFW:Notify', src, "You have added a house: " .. label)
end)

RegisterNetEvent('mr-houses:server:addGarage', function(house, coords)
    local src = source
    MySQL.Async.execute('UPDATE houselocations SET garage = ? WHERE name = ?', {json.encode(coords), house})
    local garageInfo = {
        label = Config.Houses[house].adress,
        takeVehicle = coords
    }
    TriggerClientEvent("mr-garages:client:addHouseGarage", -1, house, garageInfo)
    TriggerClientEvent('MRFW:Notify', src, "You have added a garage: " .. garageInfo.label)
end)

RegisterNetEvent('mr-houses:server:viewHouse', function(house)
    local src = source
    local pData = MRFW.Functions.GetPlayer(src)
    local house = house
    -- local houseprice = Config.Houses[house].price
    -- local brokerfee = (houseprice / 100 * 5)
    -- local bankfee = (houseprice / 100 * 10)
    -- local taxes = (houseprice / 100 * 6)

    -- TriggerClientEvent('mr-houses:client:viewHouse', src, houseprice, brokerfee, bankfee, taxes,
    --     pData.PlayerData.charinfo.firstname, pData.PlayerData.charinfo.lastname)

    MySQL.Async.fetchAll('SELECT * FROM houselocations WHERE name = ?', {house}, function(results)
        for k,v in pairs(results) do
            local realestate = v.companyname
			local contact = v.companynumber
			local estimateamount = v.estimate
            TriggerClientEvent('mr-houses:client:viewHouse', src, realestate, contact,estimateamount,
                pData.PlayerData.charinfo.firstname, pData.PlayerData.charinfo.lastname)
        end
    end)
end)

RegisterNetEvent('mr-houses:server:buyHouse', function(house, id)
    local src = source
    local pData = MRFW.Functions.GetPlayer(src)
    local price = Config.Houses[house].price
    -- local HousePrice = math.ceil(price * 1.21)
    -- local bankBalance = pData.PlayerData.money["bank"]
    -- if (bankBalance >= HousePrice) then
        houseowneridentifier[house] = pData.PlayerData.license
        houseownercid[house] = pData.PlayerData.citizenid
        housekeyholders[house] = {
            [1] = pData.PlayerData.citizenid
        }
        MySQL.Async.insert('INSERT INTO player_houses (id, house, identifier, citizenid, keyholders) VALUES (?, ?, ?, ?, ?)',
            {id, house, pData.PlayerData.license, pData.PlayerData.citizenid, json.encode(housekeyholders[house])})
        MySQL.Async.execute('UPDATE houselocations SET owned = ? WHERE name = ?', {1, house})
        TriggerClientEvent('mr-houses:client:SetClosestHouse', src)
        -- pData.Functions.RemoveMoney('bank', HousePrice, "bought-house") -- 21% Extra house costs
        -- TriggerEvent('mr-bossmenu:server:addAccountMoney', "realestate", (HousePrice / 100) * math.random(18, 25))    
    -- else
        -- TriggerClientEvent('MRFW:Notify', source, "You dont have enough money..", "error")
    -- end
end)

RegisterNetEvent('mr-houses:server:lockHouse', function(bool, house)
    TriggerClientEvent('mr-houses:client:lockHouse', -1, bool, house)
end)

RegisterNetEvent('mr-houses:server:SetRamState', function(bool, house)
    Config.Houses[house].IsRaming = bool
    TriggerClientEvent('mr-houses:server:SetRamState', -1, bool, house)
end)

RegisterNetEvent('mr-houses:server:giveKey', function(house, target)
    local pData = MRFW.Functions.GetPlayer(target)
    table.insert(housekeyholders[house], pData.PlayerData.citizenid)
    MySQL.Async.execute('UPDATE player_houses SET keyholders = ? WHERE house = ?',
        {json.encode(housekeyholders[house]), house})
end)

RegisterNetEvent('mr-houses:server:removeHouseKey', function(house, citizenData)
    local src = source
    local newHolders = {}
    if housekeyholders[house] then
        for k, v in pairs(housekeyholders[house]) do
            if housekeyholders[house][k] ~= citizenData.citizenid then
                table.insert(newHolders, housekeyholders[house][k])
            end
        end
    end
    housekeyholders[house] = newHolders
    TriggerClientEvent('MRFW:Notify', src, 'Keys Have Been Removed From ' .. citizenData.firstname .. ' ' .. citizenData.lastname, 'error')
    MySQL.Async.execute('UPDATE player_houses SET keyholders = ? WHERE house = ?', {json.encode(housekeyholders[house]), house})
end)

RegisterNetEvent('mr-houses:server:OpenDoor', function(target, house)
    local OtherPlayer = MRFW.Functions.GetPlayer(target)
    if OtherPlayer then
        TriggerClientEvent('mr-houses:client:SpawnInApartment', OtherPlayer.PlayerData.source, house)
    end
end)

RegisterNetEvent('mr-houses:server:RingDoor', function(house)
    local src = source
    TriggerClientEvent('mr-houses:client:RingDoor', -1, src, house)
end)

RegisterNetEvent('mr-houses:server:savedecorations', function(house, decorations)
    MySQL.Async.execute('UPDATE player_houses SET decorations = ? WHERE house = ?', {json.encode(decorations), house})
    TriggerClientEvent("mr-houses:server:sethousedecorations", -1, house, decorations)
end)

RegisterNetEvent('mr-houses:server:LogoutLocation', function()
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local MyItems = Player.PlayerData.items
    MySQL.Async.execute('UPDATE players SET inventory = ? WHERE citizenid = ?',
        {json.encode(MyItems), Player.PlayerData.citizenid})
    MRFW.Player.Logout(src)
    TriggerClientEvent('mr-multicharacter:client:chooseChar', src)
end)

RegisterNetEvent('mr-houses:server:giveHouseKey', function(target, house)
    local src = source
    local sPlayer = MRFW.Functions.GetPlayer(src)
    local tPlayer = MRFW.Functions.GetPlayer(target)
    local isOwner = MySQL.Sync.prepare('SELECT citizenid FROM player_houses WHERE house = ?',{house})
    if isOwner == sPlayer.PlayerData.citizenid then
        if tPlayer then
            if housekeyholders[house] then
                for _, cid in pairs(housekeyholders[house]) do
                    if cid == tPlayer.PlayerData.citizenid then
                        TriggerClientEvent('MRFW:Notify', src, 'This person already has the keys of the house!', 'error', 3500)
                        return
                    end
                end
                housekeyholders[house][#housekeyholders[house]+1] = tPlayer.PlayerData.citizenid
                MySQL.Async.execute('UPDATE player_houses SET keyholders = ? WHERE house = ?', {json.encode(housekeyholders[house]), house})
                TriggerClientEvent('mr-houses:client:refreshHouse', tPlayer.PlayerData.source)
                TriggerClientEvent('MRFW:Notify', tPlayer.PlayerData.source,
                    'You have the keys of ' .. Config.Houses[house].adress .. ' recieved!', 'success', 2500)
            else
                local sourceTarget = MRFW.Functions.GetPlayer(src)
                housekeyholders[house] = {
                    [1] = sourceTarget.PlayerData.citizenid
                }
                housekeyholders[house][#housekeyholders[house]+1] = tPlayer.PlayerData.citizenid
                MySQL.Async.execute('UPDATE player_houses SET keyholders = ? WHERE house = ?', {json.encode(housekeyholders[house]), house})
                TriggerClientEvent('mr-houses:client:refreshHouse', tPlayer.PlayerData.source)
                TriggerClientEvent('MRFW:Notify', tPlayer.PlayerData.source, 'You have the keys of ' .. Config.Houses[house].adress .. ' recieved!', 'success', 2500)
            end
        else
            TriggerClientEvent('MRFW:Notify', src, 'Something went wrond try again!', 'error', 2500)
        end
    else
        TriggerClientEvent('MRFW:Notify', src, 'You Are Not The Owner Of This House', 'error', 2500)
    end
end)

RegisterNetEvent('mr-houses:server:setLocation', function(coords, house, type)
    if type == 1 then
        MySQL.Async.execute('UPDATE player_houses SET stash = ? WHERE house = ?', {json.encode(coords), house})
    elseif type == 2 then
        MySQL.Async.execute('UPDATE player_houses SET outfit = ? WHERE house = ?', {json.encode(coords), house})
    elseif type == 3 then
        MySQL.Async.execute('UPDATE player_houses SET logout = ? WHERE house = ?', {json.encode(coords), house})
    elseif type == 4 then
		MySQL.Async.execute('UPDATE player_houses SET cupboard = ? WHERE house = ?', {json.encode(coords), house})
	end
    TriggerClientEvent('mr-houses:client:refreshLocations', -1, house, json.encode(coords), type)
end)

RegisterNetEvent('mr-houses:server:SetHouseRammed', function(bool, house)
    Config.Houses[house].IsRammed = bool
    TriggerClientEvent('mr-houses:client:SetHouseRammed', -1, bool, house)
end)

RegisterNetEvent('mr-houses:server:SetInsideMeta', function(insideId, bool)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local insideMeta = Player.PlayerData.metadata["inside"]
    if bool then
        insideMeta.apartment.apartmentType = nil
        insideMeta.apartment.apartmentId = nil
        insideMeta.house = insideId
        Player.Functions.SetMetaData("inside", insideMeta)
    else
        insideMeta.apartment.apartmentType = nil
        insideMeta.apartment.apartmentId = nil
        insideMeta.house = nil
        Player.Functions.SetMetaData("inside", insideMeta)
    end
end)

-- Callbacks

MRFW.Functions.CreateCallback('mr-houses:server:buyFurniture', function(source, cb, price)
    local src = source
    local pData = MRFW.Functions.GetPlayer(src)
    local bankBalance = pData.PlayerData.money["bank"]

    if bankBalance >= price then
        pData.Functions.RemoveMoney('bank', price, "bought-furniture")
        cb(true)
    else
        TriggerClientEvent('MRFW:Notify', src, "You dont have enough money..", "error")
        cb(false)
    end
end)

MRFW.Functions.CreateCallback('mr-houses:server:ProximityKO', function(source, cb, house)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local retvalK = false
    local retvalO = false

    if Player then
        local identifier = Player.PlayerData.license
        local CharId = Player.PlayerData.citizenid
        if hasKey(identifier, CharId, house) then
            retvalK = true
        elseif Player.PlayerData.job.name == "realestate" and Player.PlayerData.job.grade.name == "Builder" then
            retvalK = true
        else
            retvalK = false
        end
    end

    if houseowneridentifier[house] and houseownercid[house] then
        retvalO = true
    else
        retvalO = false
    end

    cb(retvalK, retvalO)
end)

MRFW.Functions.CreateCallback('mr-houses:server:hasKey', function(source, cb, house)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local retval = false
    if Player then
        local identifier = Player.PlayerData.license
        local CharId = Player.PlayerData.citizenid
        if hasKey(identifier, CharId, house) then
            retval = true
        elseif Player.PlayerData.job.name == "realestate" and Player.PlayerData.job.grade.name == "Builder" then
            retval = true
        else
            retval = false
        end
    end

    cb(retval)
end)

MRFW.Functions.CreateCallback('mr-houses:server:isOwned', function(source, cb, house)
    if houseowneridentifier[house] and houseownercid[house] then
        cb(true)
    else
        cb(false)
    end
end)

MRFW.Functions.CreateCallback('mr-houses:server:getHouseOwner', function(source, cb, house)
    cb(houseownercid[house])
end)

MRFW.Functions.CreateCallback('mr-houses:server:getHouseKeyHolders', function(source, cb, house)
    local retval = {}
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if housekeyholders[house] then
        for i = 1, #housekeyholders[house], 1 do
            if Player.PlayerData.citizenid ~= housekeyholders[house][i] then
                local result = MySQL.Sync.fetchAll('SELECT charinfo FROM players WHERE citizenid = ?',
                    {housekeyholders[house][i]})
                if result[1] then
                    local charinfo = json.decode(result[1].charinfo)
                    table.insert(retval, {
                        firstname = charinfo.firstname,
                        lastname = charinfo.lastname,
                        citizenid = housekeyholders[house][i]
                    })
                end
                cb(retval)
            end
        end
    else
        cb(nil)
    end
end)

MRFW.Functions.CreateCallback('mr-phone:server:TransferCid', function(source, cb, NewCid, house)
    local result = MySQL.Sync.fetchAll('SELECT * FROM players WHERE citizenid = ?', {NewCid})
    if result[1] then
        local HouseName = house.name
        housekeyholders[HouseName] = {}
        housekeyholders[HouseName][1] = NewCid
        houseownercid[HouseName] = NewCid
        houseowneridentifier[HouseName] = result[1].license
        MySQL.Async.execute(
            'UPDATE player_houses SET citizenid = ?, keyholders = ?, identifier = ? WHERE house = ?',
            {NewCid, json.encode(housekeyholders[HouseName]), result[1].license, HouseName})
        cb(true)
    else
        cb(false)
    end
end)

MRFW.Functions.CreateCallback('mr-houses:server:getHouseDecorations', function(source, cb, house)
    local retval = nil
    local result = MySQL.Sync.fetchAll('SELECT * FROM player_houses WHERE house = ?', {house})
    if result[1] then
        if result[1].decorations then
            retval = json.decode(result[1].decorations)
        end
    end
    cb(retval)
end)

MRFW.Functions.CreateCallback('mr-houses:server:getHouseLocations', function(source, cb, house)
    local retval = nil
    local result = MySQL.Sync.fetchAll('SELECT * FROM player_houses WHERE house = ?', {house})
    if result[1] then
        retval = result[1]
    end
    cb(retval)
end)

MRFW.Functions.CreateCallback('mr-houses:server:getHouseKeys', function(source, cb)
    local src = source
    local pData = MRFW.Functions.GetPlayer(src)
    local cid = pData.PlayerData.citizenid
end)

MRFW.Functions.CreateCallback('mr-houses:server:getOwnedHouses', function(source, cb)
    local src = source
    local pData = MRFW.Functions.GetPlayer(src)
    if pData then
        MySQL.Async.fetchAll('SELECT * FROM player_houses WHERE identifier = ? AND citizenid = ?', {pData.PlayerData.license, pData.PlayerData.citizenid}, function(houses)
            local ownedHouses = {}
            for i = 1, #houses, 1 do
                ownedHouses[#ownedHouses+1] = houses[i].house
            end
            if houses then
                cb(ownedHouses)
            else
                cb(nil)
            end
        end)
    end
end)

MRFW.Functions.CreateCallback('mr-houses:server:getSavedOutfits', function(source, cb)
    local src = source
    local pData = MRFW.Functions.GetPlayer(src)

    if pData then
        MySQL.Async.fetchAll('SELECT * FROM player_outfits WHERE citizenid = ?', {pData.PlayerData.citizenid},
            function(result)
                if result[1] then
                    cb(result)
                else
                    cb(nil)
                end
            end)
    end
end)

MRFW.Functions.CreateCallback('mr-phone:server:GetPlayerHouses', function(source, cb)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local MyHouses = {}
    local result = MySQL.Sync.fetchAll('SELECT * FROM player_houses WHERE citizenid = ?',
        {Player.PlayerData.citizenid})
    if result and result[1] then
        for k, v in pairs(result) do
            table.insert(MyHouses, {
                name = v.house,
                keyholders = {},
                owner = Player.PlayerData.citizenid,
                price = Config.Houses[v.house].price,
                label = Config.Houses[v.house].adress,
                tier = Config.Houses[v.house].tier,
                garage = Config.Houses[v.house].garage
            })

            if v.keyholders ~= "null" then
                v.keyholders = json.decode(v.keyholders)
                if v.keyholders then
                    for f, data in pairs(v.keyholders) do
                        local keyholderdata = MySQL.Sync.fetchAll('SELECT * FROM players WHERE citizenid = ?',
                            {data})
                        if keyholderdata[1] then
                            keyholderdata[1].charinfo = json.decode(keyholderdata[1].charinfo)

                            local userKeyHolderData = {
                                charinfo = {
                                    firstname = keyholderdata[1].charinfo.firstname,
                                    lastname = keyholderdata[1].charinfo.lastname
                                },
                                citizenid = keyholderdata[1].citizenid,
                                name = keyholderdata[1].name
                            }

                            table.insert(MyHouses[k].keyholders, userKeyHolderData)
                        end
                    end
                else
                    MyHouses[k].keyholders[1] = {
                        charinfo = {
                            firstname = Player.PlayerData.charinfo.firstname,
                            lastname = Player.PlayerData.charinfo.lastname
                        },
                        citizenid = Player.PlayerData.citizenid,
                        name = Player.PlayerData.name
                    }
                end
            else
                MyHouses[k].keyholders[1] = {
                    charinfo = {
                        firstname = Player.PlayerData.charinfo.firstname,
                        lastname = Player.PlayerData.charinfo.lastname
                    },
                    citizenid = Player.PlayerData.citizenid,
                    name = Player.PlayerData.name
                }
            end
        end

        SetTimeout(100, function()
            cb(MyHouses)
        end)
    else
        cb({})
    end
end)

MRFW.Functions.CreateCallback('mr-phone:server:GetHouseKeys', function(source, cb)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local MyKeys = {}

    local result = MySQL.Sync.fetchAll('SELECT * FROM player_houses', {})
    for k, v in pairs(result) do
        if v.keyholders ~= "null" then
            v.keyholders = json.decode(v.keyholders)
            for s, p in pairs(v.keyholders) do
                if p == Player.PlayerData.citizenid and (v.citizenid ~= Player.PlayerData.citizenid) then
                    table.insert(MyKeys, {
                        HouseData = Config.Houses[v.house]
                    })
                end
            end
        end

        if v.citizenid == Player.PlayerData.citizenid then
            table.insert(MyKeys, {
                HouseData = Config.Houses[v.house]
            })
        end
    end
    cb(MyKeys)
end)

MRFW.Functions.CreateCallback('mr-phone:server:MeosGetPlayerHouses', function(source, cb, input)
    local src = source
    if input then
        local search = escape_sqli(input)
        local searchData = {}
        local query = '%' .. search .. '%'
        local result = MySQL.Sync.fetchAll('SELECT * FROM players WHERE citizenid = ? OR charinfo LIKE ?',
            {search, query})
        if result[1] then
            local houses = MySQL.Sync.fetchAll('SELECT * FROM player_houses WHERE citizenid = ?',
                {result[1].citizenid})
            if houses[1] then
                for k, v in pairs(houses) do
                    table.insert(searchData, {
                        name = v.house,
                        keyholders = v.keyholders,
                        owner = v.citizenid,
                        price = Config.Houses[v.house].price,
                        label = Config.Houses[v.house].adress,
                        tier = Config.Houses[v.house].tier,
                        garage = Config.Houses[v.house].garage,
                        charinfo = json.decode(result[1].charinfo),
                        coords = {
                            x = Config.Houses[v.house].coords.enter.x,
                            y = Config.Houses[v.house].coords.enter.y,
                            z = Config.Houses[v.house].coords.enter.z
                        }
                    })
                end
                cb(searchData)
            end
        else
            cb(nil)
        end
    else
        cb(nil)
    end
end)

RegisterNetEvent('mr-houses:server:transferthishouse', function(house, housenumber , target, id)
	local src     	= source
	local target = tonumber(target)
	local pData 	= MRFW.Functions.GetPlayer(target)
    -- exports.oxmysql:execute('INSERT INTO player_houses (id, house , identifier, citizenid, keyholders) VALUES (? ,?, ?, ?, ?)',
    --     {id, house, pData.PlayerData.license, pData.PlayerData.citizenid, json.encode(keyyeet)})

    MySQL.Async.fetchAll('SELECT * FROM player_houses WHERE id = ?', {id}, function(result)
        if result[1] ~= nil then
            MySQL.Async.execute('DELETE FROM player_houses WHERE id = ?', {id}, function()
                MySQL.Async.insert('INSERT INTO player_houses (id, house , identifier, citizenid, keyholders) VALUES (? ,?, ?, ?, ?)',
                    {id, house, pData.PlayerData.license, pData.PlayerData.citizenid, json.encode(keyyeet)})
            end)
        else
            MySQL.Async.insert('INSERT INTO player_houses (id, house , identifier, citizenid, keyholders) VALUES (? ,?, ?, ?, ?)',
                {id, house, pData.PlayerData.license, pData.PlayerData.citizenid, json.encode(keyyeet)})
        end
    end)

    houseowneridentifier[house] = pData.PlayerData.license
    houseownercid[house] = pData.PlayerData.citizenid
    housekeyholders[house] = {
        [1] = pData.PlayerData.citizenid
    }
    MySQL.Async.execute('UPDATE houselocations SET owned = ?, citizenid = ? WHERE name = ?',
        {1,pData.PlayerData.citizenid,house})
    TriggerClientEvent('mr-houses:client:SetClosestHouse', src)
    TriggerClientEvent('MRFW:Notify', pData.PlayerData.source, 'You are the owner of the house:  '..Config.Houses[house].adress..' .', 'success', 2500)
end)

RegisterNetEvent('mr-houses:server:giveHouseKeyonrent', function(target, house)
	local src = source
	local tPlayer = MRFW.Functions.GetPlayer(target)

	if tPlayer ~= nil then
		if housekeyholders[house] ~= nil then
			for _, cid in pairs(housekeyholders[house]) do
				if cid == tPlayer.PlayerData.citizenid then
					TriggerClientEvent('MRFW:Notify', src, 'This person already has the keys of the house!', 'error', 3500)
					return
				end
			end
			table.insert(housekeyholders[house], tPlayer.PlayerData.citizenid)
            MySQL.Async.execute('UPDATE player_houses SET keyholders = ? WHERE house = ?', {json.encode(housekeyholders[house]), house})
			TriggerClientEvent('mr-houses:client:refreshHouse', tPlayer.PlayerData.source)
			TriggerClientEvent('MRFW:Notify', tPlayer.PlayerData.source, 'You have the keys of '..Config.Houses[house].adress..' recieved!', 'success', 2500)
		else
			local sourceTarget = MRFW.Functions.GetPlayer(src)
			housekeyholders[house] = {
				[1] = sourceTarget.PlayerData.citizenid
			}
			table.insert(housekeyholders[house], tPlayer.PlayerData.citizenid)
            MySQL.Async.execute('UPDATE player_houses SET keyholders = ? WHERE house = ?', {json.encode(housekeyholders[house]), house})
			TriggerClientEvent('mr-houses:client:refreshHouse', tPlayer.PlayerData.source)
			TriggerClientEvent('MRFW:Notify', tPlayer.PlayerData.source, 'You have the keys of '..Config.Houses[house].adress..' recieved!', 'success', 2500)
		end
	else
		TriggerClientEvent('MRFW:Notify', src, 'Something went wrond try again!', 'error', 2500)
	end
end)

MRFW.Commands.Add("addadvert", "Add advertisement to your house", {{name="housenumber", help="HouseNumber Alloted to you"},{name="companyname", help="Name of the company"},{name="contactnumber", help="Contact Number"},{name="estimateamount", help="Estimate Amount"}}, true, function(source, args)
	local Player = MRFW.Functions.GetPlayer(source)
	local housenumber = tonumber(args[1])
	local companyname = tostring(args[2])
	local companynumber = tonumber(args[3])
	local estimateamount = tonumber(args[4])
	if Player.PlayerData.job.grade.name == "Company Owner" then
        MySQL.Async.fetchAll('SELECT * FROM houselocations WHERE id = ?', {housenumber},function(results)
            for k,v in pairs(results) do
				if v.citizenid == Player.PlayerData.citizenid then
                    MySQL.Async.execute('UPDATE houselocations SET companyname = ? WHERE id = ?', {companyname, housenumber})
                    MySQL.Async.execute('UPDATE houselocations SET companynumber = ? WHERE id = ?', {companynumber, housenumber})
                    MySQL.Async.execute('UPDATE houselocations SET estimate = ? WHERE id = ?', {estimateamount, housenumber})
					TriggerClientEvent("MRFW:Notify", source, "Added Advertisement ", "success", 10000)
				else
					TriggerClientEvent("MRFW:Notify", source, "aj Chutiya hai kya? ", "error", 10000)
				end	
			end
        end)
	else
		TriggerClientEvent('MRFW:Notify', source, "You don't have Permission!", "error")
	end
end, 'realestate')

RegisterNetEvent('mr-houses:server:setAdvert', function(housenumber, companyname, companynumber, estimateamount)
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	local housenumber = housenumber
	local companyname = companyname
	local companynumber = companynumber
	local estimateamount = estimateamount
    MySQL.Async.fetchAll('SELECT * FROM houselocations WHERE id = ?', {housenumber},function(results)
        for k,v in pairs(results) do
			if v.citizenid == Player.PlayerData.citizenid then
                MySQL.Async.execute('UPDATE houselocations SET companyname = ? WHERE id = ?', {companyname, housenumber})
                MySQL.Async.execute('UPDATE houselocations SET companynumber = ? WHERE id = ?', {companynumber, housenumber})
                MySQL.Async.execute('UPDATE houselocations SET estimate = ? WHERE id = ?', {estimateamount, housenumber})
				TriggerClientEvent("MRFW:Notify", src, "Added Advertisement ", "success", 10000)
			else
				TriggerClientEvent("MRFW:Notify", src, "aj Chutiya hai kya? ", "error", 10000)
			end	
		end
    end)
end)
RegisterNetEvent('mr-houses:server:buyobject', function(objectData)
    local src         = source
    local pData     = MRFW.Functions.GetPlayer(src)
    
    local bankBalance = pData.PlayerData.money["bank"]


    if (bankBalance >= objectData) then
        
        pData.Functions.RemoveMoney('bank', objectData)
        TriggerClientEvent('mr-houses:client:donekardo', src)
        
    else
        TriggerClientEvent('MRFW:Notify', source, "You dont have enough money..", "error")
        TriggerClientEvent('mr-houses:client:donekardo2', src)
    end
end)

MRFW.Commands.Add("ownthishouse", "Own house assigned house", {{name="housenumber", help="HouseNumber Alloted to you"}}, true, function(source, args)
	local Player = MRFW.Functions.GetPlayer(source)
	local housenumber = tonumber(args[1])
	if Player.PlayerData.job.grade.name == "Company Owner" then
        MySQL.Async.fetchAll('SELECT * FROM houselocations WHERE id = ?', {housenumber},function(results)
            for k,v in pairs(results) do
				if v.citizenid == Player.PlayerData.citizenid then
					local street = v.label
					local id = v.id
                    local database = MySQL.Sync.fetchAll('SELECT * FROM player_houses WHERE id = ?',{id})
                    if database[1] == nil then
					    TriggerClientEvent('mr-houses:client:ownthishouse', source, street , id)
                    else
                        TriggerClientEvent("MRFW:Notify", source, "already owned", "error", 5000)
                    end
				else
					TriggerClientEvent("MRFW:Notify", source, "what are you trying to do?", "error", 5000)
				end	
			end
        end)
	else
		TriggerClientEvent('MRFW:Notify', source, "You don't have Permission!", "error")
	end
end, 'realestate')

-- MRFW.Commands.Add("giveonrent", "Give assigned and owned house on rent", {{name="playerid", help="Player ID"}}, true, function(source, args)
-- 	local Player = MRFW.Functions.GetPlayer(source)
-- 	local playerid = tonumber(args[1])
-- 	if Player.PlayerData.job.grade.name == "Company Owner" then

-- 		TriggerClientEvent('mr-houses:client:givetheHouseKeyonrent', source, playerid)

-- 	else
-- 		TriggerClientEvent('MRFW:Notify', source, "You don't have Permission!", "error")
-- 	end
-- end, 'realestate')

MRFW.Commands.Add("transferhouse", "Transfer Assigned house", {{name="housenumber", help="HouseNumber Alloted to you"},{name="playerid", help="Player ID"}}, true, function(source, args)
	local Player = MRFW.Functions.GetPlayer(source)
	local housenumber = tonumber(args[1])
	local playerid = tonumber(args[2])
	if Player.PlayerData.job.grade.name == "Company Owner" then
        MySQL.Async.fetchAll('SELECT * FROM houselocations WHERE id = ?', {housenumber},function(results)
            for k,v in pairs(results) do
				if v.citizenid == Player.PlayerData.citizenid then
					local street = v.label
					local id = v.id
                    -- if v.rentcheck == 0 then
					    TriggerClientEvent('mr-houses:client:transferthishouse', source, street , housenumber , playerid , id)
                    -- end
				else
					TriggerClientEvent("MRFW:Notify", source, "aj Chutiya hai kya? ", "error", 10000)
				end	
			end
        end)
	else
		TriggerClientEvent('MRFW:Notify', source, "You don't have Permission!", "error")
	end
end, 'realestate')

RegisterNetEvent('mr-houses:server:settransfer', function(housenumber, playerid)
	local source = source
	local Player = MRFW.Functions.GetPlayer(source)
	local housenumber = housenumber
	local playerid = playerid
    MySQL.Async.fetchAll('SELECT * FROM houselocations WHERE id = ?', {housenumber},function(results)
        for k,v in pairs(results) do
			if v.citizenid == Player.PlayerData.citizenid then
				local street = v.label
				local id = v.id
                if v.rentcheck == 0 then
				    TriggerClientEvent('mr-houses:client:transferthishouse', source, street , housenumber , playerid , id)
                end
			else
				TriggerClientEvent("MRFW:Notify", source, "aj Chutiya hai kya? ", "error", 10000)
			end	
		end
    end)
end)

-- MRFW.Commands.Add("revokefromrent", "Revoke given house on rent", {{name="playerid", help="Player ID"}}, true, function(source, args)
-- 	local Player = MRFW.Functions.GetPlayer(source)
-- 	local playerid = tonumber(args[1])
-- 	if Player.PlayerData.job.grade.name == "Company Owner" then
-- 		TriggerClientEvent('mr-houses:client:removeHouseKeyonrent', source, playerid)
-- 	else
-- 		TriggerClientEvent('MRFW:Notify', source, "You don't have Permission!", "error")
-- 	end
-- end)

RegisterNetEvent('mr-houses:server:rentHouse', function(house)

	local src     	= source
	local pData 	= MRFW.Functions.GetPlayer(src)
	local price   	= Config.Houses[house].price
	--local HousePrice = math.ceil(price * 1.21)
	local bankBalance = pData.PlayerData.money["bank"]
	
	local rentprice 	= (price / 5)
	local insttime 		= 168 -- Hours
	local date = os.date('%Y-%m-%d')
	local hnumber = Generateajp()

	if (bankBalance >= rentprice) then
        MySQL.Async.insert('INSERT INTO player_houses (house, identifier, citizenid, keyholders, rentprice, insttime, houseprice, repayam, date, hnumber) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
            {house, pData.PlayerData.license, pData.PlayerData.citizenid, json.encode(keyyeet), (price - rentprice), insttime, price, rentprice, date, hnumber})
		houseowneridentifier[house] = pData.PlayerData.license
		houseownercid[house] = pData.PlayerData.citizenid
		housekeyholders[house] = {
			[1] = pData.PlayerData.citizenid
		}
        MySQL.Async.execute('UPDATE houselocations SET owned = ? WHERE name = ?', {1, house})
		TriggerClientEvent('mr-houses:client:SetClosestHouse', src)

		--pData.Functions.RemoveMoney('bank', rentprice, "bought-house") -- 21% Extra house costs
		
		TriggerClientEvent('mr-moneysafesgov:client:DepositMoney', src , rentprice)
		pData.Functions.RemoveItem('housingpaper', 1)
	else
		TriggerClientEvent('MRFW:Notify', source, "You dont have enough money..", "error")
	end

end)

function Generateajp()
    local hnumber = tostring(GetRandomNumber(1)) .. GetRandomLetter(2) .. tostring(GetRandomNumber(3)) .. GetRandomLetter(2)
    MySQL.Async.fetchAll('SELECT * FROM player_houses WHERE hnumber = ?', {hnumber},function(result)
        while (result[1] ~= nil) do
            hnumber = tostring(GetRandomNumber(1)) .. GetRandomLetter(2) .. tostring(GetRandomNumber(3)) .. GetRandomLetter(2)
        end
        return Hnumber
    end)
    return hnumber:upper()
end

function GetRandomNumber(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

--EVENT TO MINUS 1 HOUR 

local timer = ((60 * 1000) * 60) -- 60 minute timer -- 1 Hour
function updateFinance()
    MySQL.Async.fetchAll('SELECT insttime, hnumber FROM player_houses WHERE insttime > ?', {0},function(result)
        for i=1, #result do
            local financeTimer = result[i].insttime
            local hnumber = result[i].hnumber
            local newTimer = financeTimer - 1  ---1 Hour Cut
            if financeTimer ~= nil then
                MySQL.Async.execute('UPDATE player_houses SET insttime = ?  WHERE hnumber = ?', {newTimer, hnumber})
            end
        end
    end)
    SetTimeout(timer, updateFinance)
end
SetTimeout(timer, updateFinance)

--EVENT TO CHECK FINANCE

RegisterNetEvent('mr-houses:AutoStatuscheck', function()
    local src = source
	local Player = MRFW.Functions.GetPlayer(source)

	local foundOwedHouse = false
    MySQL.Async.fetchAll('SELECT * FROM player_houses WHERE citizenid = ?', {Player.PlayerData.citizenid},function(results)
        for k,v in pairs(results) do
			if v.insttime < 1 and v.repayam > 1 then
				foundOwedHouse = true
            elseif v.insttime < 72 and v.repayam > 1 then
                local financeTime = v.insttime
                TriggerClientEvent("MRFW:Notify", src, "You have one Rent which you have to pay in "..financeTime.. " hours", "error", 10000)
			end	
		end
		if foundOwedHouse then
            MySQL.Async.fetchAll('SELECT * FROM player_houses WHERE citizenid = ?', {Player.PlayerData.citizenid},function(vehData)
                for k,v in pairs(vehData) do
					if v.insttime < 1 and v.repayam > 1 then
						local hnumber = v.hnumber
						local house = v.house
                        local rentAmount = v.rentprice
                        local rentPayment = v.repayam
                        --if Player.PlayerData.money["bank"] >= rentPayment then
                            TriggerClientEvent("MRFW:Notify", src, "You have 1 Rent of your House Number: " ..hnumber.. " installment cost: $ " ..rentPayment.." . ", "error", 10000) 
                            TriggerClientEvent("MRFW:Notify", src, "Kindly pay in 10min else vehicle will be seized ", "error", 10000)
                            TriggerClientEvent("mr-houses:mail" , src, hnumber , house , rentPayment)
                            Citizen.Wait(600000)
                            MySQL.Async.fetchAll('SELECT * FROM player_houses WHERE citizenid = ?', {Player.PlayerData.citizenid},function(vehData)
                                for k,v in pairs(vehData) do
                                    if v.insttime < 1 and v.repayam > 1 then
                                        local hnumber = v.hnumber
										local house = v.house
                                        MySQL.Async.execute('DELETE FROM player_houses WHERE hnumber = ? AND house = ?', {hnumber, house})
                                    end
                                end
                            end)
                            TriggerClientEvent("MRFW:Notify", src, "We Have Seized Your House", "error", 7000) 
                        --end
					end
				end
            end)
        end
    end)
end)

RegisterNetEvent('mr-houses:CheckRent', function()
    local src = source
	local Player = MRFW.Functions.GetPlayer(source)

	local foundOwedHouse = false
    MySQL.Async.fetchAll('SELECT * FROM player_houses WHERE citizenid = ?', {Player.PlayerData.citizenid},function(results)
        for k,v in pairs(results) do
			if v.insttime < 1 and v.repayam > 1 then
				foundOwedHouse = true
            elseif v.insttime < 72 and v.repayam > 1 then
                local financeTime = v.insttime
                TriggerClientEvent("MRFW:Notify", src, "You have one Rent which you have to pay in "..financeTime.. " hours", "error", 10000)
			end	
		end
		if foundOwedHouse then
            MySQL.Async.fetchAll('SELECT * FROM player_houses WHERE citizenid = ?', {Player.PlayerData.citizenid},function(vehData)
                for k,v in pairs(vehData) do
					if v.insttime < 1 and v.repayam > 1 then
						local hnumber = v.hnumber
						local house = v.house
                        local rentAmount = v.rentprice
                        local rentPayment = v.repayam
                        --if Player.PlayerData.money["bank"] >= rentPayment then
                            TriggerClientEvent("MRFW:Notify", src, "You have 1 Rent of your House Number: " ..hnumber.. " installment cost: $ " ..rentPayment.." . ", "error", 10000) 
                            TriggerClientEvent("MRFW:Notify", src, "Kindly pay in 10min else vehicle will be seized ", "error", 10000)
                            TriggerClientEvent("mr-houses:mail" , src, hnumber , house , rentPayment)
                            Citizen.Wait(600000)
                            MySQL.Async.fetchAll('SELECT * FROM player_houses WHERE citizenid = ?', {Player.PlayerData.citizenid},function(vehData)
                                for k,v in pairs(vehData) do
                                    if v.insttime < 1 and v.repayam > 1 then
                                        local hnumber = v.hnumber
										local house = v.house
                                        MySQL.Async.execute('DELETE FROM player_houses WHERE hnumber = ? AND house = ?', {hnumber,  house})
                                    end
                                end
                            end)
                            TriggerClientEvent("MRFW:Notify", src, "We Have Seized Your House", "error", 7000) 
                        --end
					end
				end
            end)
        elseif not foundOwedHouse then
            TriggerClientEvent("MRFW:Notify", src, "No any dues!", "error", 5000) 
        end
    end)
end)

--EVENT TO PAY WEEKLY RENT
RegisterNetEvent('mr-houses:PayRent', function()
    local src = source
	local Player = MRFW.Functions.GetPlayer(source)

	local foundOwedHouse = false
    MySQL.Async.fetchAll('SELECT * FROM player_houses WHERE citizenid = ?', {Player.PlayerData.citizenid},function(results)
        for k,v in pairs(results) do
			if v.insttime < 1 and v.repayam > 1 then
				foundOwedHouse = true
            
			end	
		end
		if foundOwedHouse then
            MySQL.Async.fetchAll('SELECT * FROM player_houses WHERE citizenid = ?', {Player.PlayerData.citizenid},function(vehData)
                for k,v in pairs(vehData) do
					if v.insttime < 1 and v.repayam > 1 then
						local hnumber = v.hnumber
						local house = v.house
                        local rentAmount = v.rentprice
                        local rentPayment = v.repayam
                        local date = os.date('%Y-%m-%d')
                        if Player.PlayerData.money["bank"] >= rentPayment then
                            TriggerClientEvent("MRFW:Notify", src, "You have 1 Rent of your House Number: " ..hnumber.. " installment cost: $ " ..rentPayment.." . ", "error", 10000) 
                            Citizen.Wait(100)
                            --Player.Functions.RemoveMoney('bank', rentPayment)
                            TriggerClientEvent('mr-moneysafesgov:client:DepositMoney', src, rentPayment) 
                            TriggerClientEvent("MRFW:Notify", src, "Paid Rent of $" ..rentPayment.. " . ", "error", 10000) 
                            MySQL.Async.execute('UPDATE player_houses SET rentprice = ? WHERE hnumber = ?', {(rentAmount - rentPayment), hnumber})
                            MySQL.Async.execute('UPDATE player_houses SET insttime = ? WHERE hnumber = ?', {168, hnumber})
                            MySQL.Async.execute('UPDATE player_houses SET fdate = ? WHERE hnumber = ?', {date, hnumber})
                            TriggerClientEvent("mr-houses:paidmail" , src, hnumber , house , rentPayment)
                        elseif rentPayment < 1 then
                            MySQL.Async.execute('UPDATE player_houses SET rentprice = ? WHERE hnumber = ?', {0, hnumber})
                            MySQL.Async.execute('UPDATE player_houses SET insttime = ? WHERE hnumber = ?', {0, hnumber})
                            MySQL.Async.execute('UPDATE player_houses SET repayam = ? WHERE hnumber = ?', {0, hnumber})
                            TriggerClientEvent("MRFW:Notify", src, "No Any Rent!", "error", 7000) 
                        elseif rentAmount == 0 then
                            MySQL.Async.execute('UPDATE player_houses SET rentprice = ? WHERE hnumber = ?', {0, hnumber})
                            MySQL.Async.execute('UPDATE player_houses SET insttime = ? WHERE hnumber = ?', {0, hnumber})
                            MySQL.Async.execute('UPDATE player_houses SET repayam = ? WHERE hnumber = ?', {0, hnumber})
                            TriggerClientEvent("MRFW:Notify", src, "No Any Rent!", "error", 7000) 
                        else 
                            TriggerClientEvent("MRFW:Notify", src, "You don't have money", "error", 7000)
                        end
					end
				end
            end)
        elseif not foundOwedHouse then
            TriggerClientEvent("MRFW:Notify", src, "No any dues!", "error", 7000) 
        end
    end)
end)

RegisterNetEvent('mr-houses:ExistRent', function()
    local src = source
	local Player = MRFW.Functions.GetPlayer(source)

	local foundOwedHouse = false
    MySQL.Async.fetchAll('SELECT * FROM player_houses WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(results)
        for k,v in pairs(results) do
			if v.insttime > 1 and v.rentprice > 1 then
				foundOwedHouse = true
               
			end	
		end
        if foundOwedHouse then
            TriggerClientEvent("MRFW:Notify", src, "You already have one Rented House!", "error", 7000) 
        else
            TriggerClientEvent('mr-houses:client:checkhouse' , src)
        end
    end)
end)

-- MRFW.Commands.Add("rent", "Check Rent", {}, false, function(source)
-- 	local src = source
--     local Player = MRFW.Functions.GetPlayer(source)
--     TriggerClientEvent("mr-houses:client:cRent" , source)
-- end)

-- MRFW.Commands.Add("payrent", "Pay Rent", {}, false, function(source)
-- 	local src = source
--     local Player = MRFW.Functions.GetPlayer(source)
--     TriggerClientEvent("mr-houses:client:payrent" , source)
-- end)

MRFW.Commands.Add("MyHouses", "Check Your House Details", {}, false, function(source)
    local Player = MRFW.Functions.GetPlayer(source)
	local cid = Player.PlayerData.citizenid
    TriggerClientEvent("Jacob:Client:MyHouses", source, cid)
end)

RegisterServerEvent('Jacob:Server:MyHouses')
AddEventHandler('Jacob:Server:MyHouses', function(cid, timeout)
	local src = source
	if timeout == 0 then
		-- print(cid)
		local r = nil
        MySQL.Async.fetchAll('SELECT * FROM houselocations WHERE citizenid = ?', {cid}, function(result)
            if result[1] ~= nil then
				r = result
			end
        end)
		Citizen.Wait(500)
		-- print(r)
		TriggerClientEvent('Jacob:Client:MyHouses:results', src, r)
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM:", "error", "Wait "..cid.." Seconds Before Using This Command Again.")
    end
end)


MRFW.Commands.Add('thishnumber', 'help text here', {}, false, function(source, args)
    local src = source
    local player = MRFW.Functions.GetPlayer(src)
    -- if player.PlayerData.job.grade.name == "Company Owner" then
        TriggerClientEvent('jacob:get:this:house', src, src)
	-- else
		-- TriggerClientEvent('MRFW:Notify', source, "You don't have Permission!", "error")
	-- end
end)

RegisterServerEvent('jacob:get:this:house:s')
AddEventHandler('jacob:get:this:house:s', function(src,data)
    MySQL.Async.fetchAll('SELECT * FROM houselocations WHERE name = ?', {data}, function(result)
        if result[1] ~= nil then
            local ids = nil
            for k,v in pairs(result) do
                ids = v.id
            end
            Citizen.Wait(500)
            TriggerClientEvent('chatMessage', src, "SYSTEM:", "error", "This House Number is ("..ids..")")
        else
            TriggerClientEvent('MRFW:Notify', source, "SomeThing Went Wrong Contact Server DEVELOPER", "error")
        end
    end)
end)

-- MRFW.Commands.Add('fixmyhouse', 'Fix House Furniture', {}, false, function(source, args)
--     TriggerClientEvent('houses:client:fixhouse', source)
-- end)

-- MRFW.Commands.Add('fixOwnedHouse', 'Fix House Interior', {}, false, function(source, args)
    
    -- local coords = {
    --     enter 	= { x = pos.x, y = pos.y, z = pos.z, h = heading},
    --     cam 	= { x = pos.x, y = pos.y, z = pos.z, h = heading, yaw = -10.00},
    --     shell   = { x = pos.x, y = pos.y, z = pos.z - Config.MinZOffset},
    -- }
    -- MySQL.
    -- local HouseGarages = {}
    -- local result = MySQL.Sync.fetchAll('SELECT * FROM houselocations', {})
    -- if result[1] then
    --     for k, v in pairs(result) do
    --         local owned = false
    --         if tonumber(v.owned) == 1 then
    --             owned = true
    --         end
    --         local garage = json.decode(v.garage) or {}
    --         Config.Houses[v.name] = {
    --             coords = json.decode(v.coords),
    --             owned = v.owned,
    --             price = v.price,
    --             locked = true,
    --             adress = v.label,
    --             tier = v.tier,
    --             garage = garage,
    --             decorations = {}
    --         }
    --         HouseGarages[v.name] = {
    --             label = v.label,
    --             takeVehicle = garage
    --         }
    --     end
    -- end
    -- TriggerClientEvent("mr-garages:client:houseGarageConfig", -1, HouseGarages)
    -- TriggerClientEvent("mr-houses:client:setHouseConfig", -1, Config.Houses)
-- end)