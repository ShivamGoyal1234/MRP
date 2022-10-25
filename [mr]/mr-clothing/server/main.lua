-- MRFW = nil
-- TriggerEvent('MRFW:GetObject', function(obj) MRFW = obj end)

-- Code

MRFW.Commands.Add("skin", "Give Re-skin", {}, false, function(source, args)
	TriggerClientEvent("mr-clothing:client:openMenu", source)
end, "admin")

MRFW.Commands.Add("refreshskin", "Refreshskin", {}, false, function(source, args)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
	TriggerClientEvent("MRFW:Client:Refreshskin", source)
end)

RegisterServerEvent("mr-clothing:saveSkin")
AddEventHandler('mr-clothing:saveSkin', function(model, skin, cut)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local aaa = cut
    if aaa ~= nil then
        if Player.PlayerData.money.cash >= aaa then
            Player.Functions.RemoveMoney('cash', aaa)
        elseif Player.PlayerData.money.bank >= aaa then
            Player.Functions.RemoveMoney('bank', aaa)
        end
    end

    if model ~= nil and skin ~= nil then 
        MySQL.Async.execute('DELETE FROM playerskins WHERE citizenid = ?', {Player.PlayerData.citizenid}, function()
            MySQL.Async.insert('INSERT INTO playerskins (citizenid, model, skin, active) VALUES (?, ?, ?, ?)', {Player.PlayerData.citizenid, model, skin, 1})
        end)
    end
end)

RegisterServerEvent("mr-clothes:loadPlayerSkin")
AddEventHandler('mr-clothes:loadPlayerSkin', function()
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local db = MySQL.Sync.fetchAll('SELECT * FROM playerskins WHERE citizenid = ? AND active = ?', {Player.PlayerData.citizenid, 1})
    if db ~= nil then
        if db[1] ~= nil then
            TriggerClientEvent("mr-clothes:loadSkin", src, false, db[1].model, db[1].skin)
        else
            TriggerClientEvent("mr-clothes:loadSkin", src, true)
        end
    end
end)

RegisterServerEvent("mr-clothes:loadPlayerSkins")
AddEventHandler('mr-clothes:loadPlayerSkins', function()
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local db = MySQL.Sync.fetchAll('SELECT * FROM playerskins WHERE citizenid = ? AND active = ?', {Player.PlayerData.citizenid, 1})
    if db ~= nil then
        if db[1] ~= nil then
            TriggerClientEvent("mr-clothes:loadSkins", src, false, db[1].model, db[1].skin)
        else
            TriggerClientEvent("mr-clothes:loadSkins", src, true)
        end
    end
end)

RegisterServerEvent("mr-clothes:saveOutfit")
AddEventHandler("mr-clothes:saveOutfit", function(outfitName, model, skinData)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if model ~= nil and skinData ~= nil then
        local outfitId = "outfit-"..math.random(1, 10).."-"..math.random(1111, 9999)
        MySQL.Async.insert('INSERT INTO player_outfits (citizenid, outfitname, model, skin, outfitId) VALUES (?, ?, ?, ?, ?)', 
            {Player.PlayerData.citizenid, outfitName, model, json.encode(skinData), outfitId},function()
                local db = MySQL.Sync.fetchAll('SELECT * FROM player_outfits WHERE citizenid = ?', {Player.PlayerData.citizenid})
                if db ~= nil then
                    if db[1] ~= nil then
                        TriggerClientEvent('mr-clothing:client:reloadOutfits', src, db)
                    else
                        TriggerClientEvent('mr-clothing:client:reloadOutfits', src, nil)
                    end
                end
        end)
    end
end)

RegisterServerEvent("mr-clothing:server:removeOutfit")
AddEventHandler("mr-clothing:server:removeOutfit", function(outfitName, outfitId)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    MySQL.Async.execute('DELETE FROM player_outfits WHERE citizenid = ? AND outfitname = ? AND outfitId = ?', 
        {Player.PlayerData.citizenid, outfitName, outfitId}, function()
            local db = MySQL.Sync.fetchAll('SELECT * FROM player_outfits WHERE citizenid = ?', {Player.PlayerData.citizenid})
            if db ~= nil then
                if db[1] ~= nil then
                    TriggerClientEvent('mr-clothing:client:reloadOutfits', src, db)
                else
                    TriggerClientEvent('mr-clothing:client:reloadOutfits', src, nil)
                end
            end
    end)
end)

MRFW.Functions.CreateCallback('mr-clothing:server:getOutfits', function(source, cb)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local anusVal = {}

    local db = MySQL.Sync.fetchAll('SELECT * FROM player_outfits WHERE citizenid = ?', {Player.PlayerData.citizenid})
    if db ~= nil then
        if db[1] ~= nil then
            for k, v in pairs(db) do
                db[k].skin = json.decode(db[k].skin)
                anusVal[k] = v
            end
            cb(anusVal)
        end
        cb(anusVal)
    end
end)

RegisterServerEvent('mr-clothing:print')
AddEventHandler('mr-clothing:print', function(data)
    -- print(data)
end)

MRFW.Commands.Add("helmet", "Put your helmet/cap/hat on or off..", {}, false, function(source, args)
    TriggerClientEvent("mr-clothing:client:adjustfacewear", source, 1) -- Hat
end)

MRFW.Commands.Add("glasses", "Put your glasses on or off..", {}, false, function(source, args)
	TriggerClientEvent("mr-clothing:client:adjustfacewear", source, 2)
end)

MRFW.Commands.Add("masks", "Put your mask on or off..", {}, false, function(source, args)
	TriggerClientEvent("mr-clothing:client:adjustfacewear", source, 4)
end)