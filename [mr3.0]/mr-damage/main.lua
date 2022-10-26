local MRFW = exports['mrfw']:GetCoreObject()

MRFW.Commands.Add("testdecay", "Description", {}, true, function(source, args)
    local src = source
    
    DegradeInventoryItems(src)
    DegradeStashItems(src)
    DegradeTrunkItems(src)
    DegradeGloveboxItems(src)
end, "dev")

RegisterNetEvent('Perform:Decay:item', function(itemm, slott, amount)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player ~= nil then
        local items = Player.PlayerData.items
        local sentItems = {}
        for k,v in pairs(items) do
            local itemInfo = MRFW.Shared.Items[v.name:lower()]
            if v.name == itemm and tonumber(v.slot) == tonumber(slott) then
                local finalcheck = v.info.quality - amount
                if finalcheck <= 5 then
                    v.info.quality = 0
                else
                    v.info.quality = v.info.quality - amount
                end
            end
            local modifiedItem = {
                name = itemInfo["name"],
                amount = tonumber(v.amount),
                info = v.info ~= nil and v.info or "",
                label = itemInfo["label"],
                description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
                weight = itemInfo["weight"], 
                type = itemInfo["type"], 
                unique = itemInfo["unique"], 
                useable = itemInfo["useable"], 
                image = itemInfo["image"],
                slot = tonumber(v.slot),
            }
            table.insert(sentItems, modifiedItem)
        end
        Player.Functions.SetInventory(sentItems)
        TriggerClientEvent("inventory:client:UpdatePlayerInventory", Player.PlayerData.source, false)
    end
end)

RegisterNetEvent('Perform:Decay:item2', function(itemm, slott, amount)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player ~= nil then
        local items = Player.PlayerData.items
        local sentItems = {}
        for k,v in pairs(items) do
            local itemInfo = MRFW.Shared.Items[v.name:lower()]
            if v.name == itemm and tonumber(v.slot) == tonumber(slott) then
                local finalcheck = v.info.quality + amount
                if finalcheck >= 100 then
                    v.info.quality = 100
                else
                    v.info.quality = v.info.quality + amount
                end
            end
            local modifiedItem = {
                name = itemInfo["name"],
                amount = tonumber(v.amount),
                info = v.info ~= nil and v.info or "",
                label = itemInfo["label"],
                description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
                weight = itemInfo["weight"], 
                type = itemInfo["type"], 
                unique = itemInfo["unique"], 
                useable = itemInfo["useable"], 
                image = itemInfo["image"],
                slot = tonumber(v.slot),
            }
            table.insert(sentItems, modifiedItem)
        end
        Player.Functions.SetInventory(sentItems)
        TriggerClientEvent("inventory:client:UpdatePlayerInventory", Player.PlayerData.source, false)
    end
end)

function DegradeInventoryItems(sources)
    local src = sources
    local results = MySQL.Sync.fetchAll('SELECT citizenid, inventory FROM players', {})
	if results[1] ~= nil then
        local citizenid = nil
        for k = 1, #results, 1 do
            row = results[k]
            citizenid = row.citizenid   
            local sentItems = {}
            local items = nil
            local isOnline = MRFW.Functions.GetPlayerByCitizenId(citizenid)
            if isOnline then
                items = isOnline.PlayerData.items

                for a, item in pairs(items) do
                    if item ~= nil then
                        local itemInfo = MRFW.Shared.Items[item.name:lower()]
                        if item.info ~= nil and item.info.quality ~= nil then
                            local degradeAmount = MRFW.Shared.Items[item.name:lower()]["degrade"] ~= nil and MRFW.Shared.Items[item.name:lower()]["degrade"] or 0.0
                            if item.info.quality == 0.0 then
                                --do nothing
                            elseif (item.info.quality - degradeAmount) > 0.0 then
                                item.info.quality = item.info.quality - degradeAmount
                            elseif (item.info.quality - degradeAmount) < 0.0 then
                                item.info.quality = 0.0
                            end
                        else
                            if type(item.info) == 'table' then
                                item.info.quality = 100.0
                            elseif type(item.info) == 'string' and item.info == '' then
                                item.info = {}
                                item.info.quality = 100.0
                            end
                        end
            
                        local modifiedItem = {
                            name = itemInfo["name"],
                            amount = tonumber(item.amount),
                            info = item.info ~= nil and item.info or "",
                            label = itemInfo["label"],
                            description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
                            weight = itemInfo["weight"], 
                            type = itemInfo["type"], 
                            unique = itemInfo["unique"], 
                            useable = itemInfo["useable"], 
                            image = itemInfo["image"],
                            slot = item.slot,
                        }
            
                        table.insert(sentItems, modifiedItem)
                    end
                end

                isOnline.Functions.SetInventory(sentItems)
                TriggerClientEvent("inventory:client:UpdatePlayerInventory", isOnline.PlayerData.source, false)
            else
                if row.inventory ~= nil then
                    row.inventory = json.decode(row.inventory)
                    if row.inventory ~= nil then 
                        for l = 1, #row.inventory, 1 do
                            item = row.inventory[l]
                            if item ~= nil then
                                local itemInfo = MRFW.Shared.Items[item.name:lower()]
                                if item.info ~= nil and item.info.quality ~= nil then
                                    local degradeAmount = MRFW.Shared.Items[item.name:lower()]["degrade"] ~= nil and MRFW.Shared.Items[item.name:lower()]["degrade"] or 0.0
                                    if item.info.quality == 0.0 then
                                        --do nothing
                                    elseif (item.info.quality - degradeAmount) > 0.0 then
                                        item.info.quality = item.info.quality - degradeAmount
                                    elseif (item.info.quality - degradeAmount) < 0.0 then
                                        item.info.quality = 0.0
                                    end
                                else
                                    if type(item.info) == 'table' then
                                        item.info.quality = 100.0
                                    elseif type(item.info) == 'string' and item.info == '' then
                                        item.info = {}
                                        item.info.quality = 100.0
                                    end
                                end

                                local modifiedItem = {
                                    name = itemInfo["name"],
                                    amount = tonumber(item.amount),
                                    info = item.info ~= nil and item.info or "",
                                    label = itemInfo["label"],
                                    description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
                                    weight = itemInfo["weight"], 
                                    type = itemInfo["type"], 
                                    unique = itemInfo["unique"], 
                                    useable = itemInfo["useable"], 
                                    image = itemInfo["image"],
                                    slot = item.slot,
                                }

                                table.insert(sentItems, modifiedItem)
                            end
                        end
                        MySQL.Async.execute('UPDATE players SET inventory = ? WHERE citizenid = ?', { json.encode(sentItems), citizenid })
                    end
                end
            end
            Citizen.Wait(500)
        end
	end
    TriggerClientEvent("MRFW:Notify", src, "DoneInventory Decay", "success", 3000)
end

function DegradeStashItems(sources)
    local src = sources
    local results = MySQL.Sync.fetchAll('SELECT * FROM stashitems', {})
	if results[1] ~= nil then
        local id = nil
        for k = 1, #results, 1 do
            row = results[k]
            id = row.id
            local items = {}
            if row.items ~= nil then
                row.items = json.decode(row.items)
                if row.items ~= nil then 
                    for l = 1, #row.items, 1 do
                        item = row.items[l]
                        if item ~= nil then
                            local itemInfo = MRFW.Shared.Items[item.name:lower()]
                            if item.info ~= nil and item.info.quality ~= nil then
                                local degradeAmount = MRFW.Shared.Items[item.name:lower()]["degrade"] ~= nil and MRFW.Shared.Items[item.name:lower()]["degrade"] or 0.0
                                if item.info.quality == 0.0 then
                                    --do nothing
                                elseif (item.info.quality - degradeAmount) > 0.0 then
                                    item.info.quality = item.info.quality - degradeAmount
                                elseif (item.info.quality - degradeAmount) < 0.0 then
                                    item.info.quality = 0.0
                                end
                            else
                                if type(item.info) == 'table' then
                                    item.info.quality = 100.0
                                elseif type(item.info) == 'string' and item.info == '' then
                                    item.info = {}
                                    item.info.quality = 100.0
                                end

                            end

                            local modifiedItem = {
                                name = itemInfo["name"],
                                amount = tonumber(item.amount),
                                info = item.info ~= nil and item.info or "",
                                label = itemInfo["label"],
                                description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
                                weight = itemInfo["weight"], 
                                type = itemInfo["type"], 
                                unique = itemInfo["unique"], 
                                useable = itemInfo["useable"], 
                                image = itemInfo["image"],
                                slot = item.slot,
                            }

                            table.insert(items, modifiedItem)
                        end
                    end
                end
            end
            MySQL.Async.execute('UPDATE stashitems SET items = ? WHERE id = ?', { json.encode(items), id })
            Citizen.Wait(500)
        end
	end
    TriggerClientEvent("MRFW:Notify", src, "DoneStash Decay", "success", 3000)
end

function DegradeGloveboxItems(sources)
    local src = sources
    local results = MySQL.Sync.fetchAll('SELECT * FROM gloveboxitems', {})
	if results[1] ~= nil then
        local id = nil
        for k = 1, #results, 1 do
            row = results[k]
            id = row.id
            local items = {}
            if row.items ~= nil then
                row.items = json.decode(row.items)
                if row.items ~= nil then 
                    for l = 1, #row.items, 1 do
                        item = row.items[l]
                        local itemInfo = MRFW.Shared.Items[item.name:lower()]
                        if item.info ~= nil and item.info.quality ~= nil then
                            local degradeAmount = MRFW.Shared.Items[item.name:lower()]["degrade"] ~= nil and MRFW.Shared.Items[item.name:lower()]["degrade"] or 0.0
                            if item.info.quality == 0.0 then
                                --do nothing
                            elseif (item.info.quality - degradeAmount) > 0.0 then
                                item.info.quality = item.info.quality - degradeAmount
                            elseif (item.info.quality - degradeAmount) < 0.0 then
                                item.info.quality = 0.0
                            end
                        else
                            if type(item.info) == 'table' then
                                item.info.quality = 100.0
                            elseif type(item.info) == 'string' and item.info == '' then
                                item.info = {}
                                item.info.quality = 100.0
                            end

                        end

                        local modifiedItem = {
                            name = itemInfo["name"],
                            amount = tonumber(item.amount),
                            info = item.info ~= nil and item.info or "",
                            label = itemInfo["label"],
                            description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
                            weight = itemInfo["weight"], 
                            type = itemInfo["type"], 
                            unique = itemInfo["unique"], 
                            useable = itemInfo["useable"], 
                            image = itemInfo["image"],
                            slot = item.slot,
                        }

                        table.insert(items, modifiedItem)
                    end
                end
            end
            MySQL.Async.execute('UPDATE gloveboxitems SET items = ? WHERE id = ?', { json.encode(items), id })
            Citizen.Wait(500)
        end
	end
    TriggerClientEvent("MRFW:Notify", src, "DoneGlovebox Decay", "success", 3000)
end

function DegradeTrunkItems(sources)
    local src = sources
    local results = MySQL.Sync.fetchAll('SELECT * FROM trunkitems', {})
	if results[1] ~= nil then
        local id = nil
        for k = 1, #results, 1 do
            row = results[k]
            id = row.id
            local items = {}
            if row.items ~= nil then
                row.items = json.decode(row.items)
                if row.items ~= nil then
                    for l = 1, #row.items, 1 do
                        item = row.items[l]
                        local degradeAmount = MRFW.Shared.Items[item.name:lower()]["degrade"] ~= nil and MRFW.Shared.Items[item.name:lower()]["degrade"] or 0.0
                        local itemInfo = MRFW.Shared.Items[item.name:lower()]
                        if item.info ~= nil and item.info.quality ~= nil and degradeAmount > 0.0 then
                            if item.info.quality == 0.0 then
                                --do nothing
                            elseif (item.info.quality - degradeAmount) > 0.0 then
                                item.info.quality = item.info.quality - degradeAmount
                            elseif (item.info.quality - degradeAmount) < 0.0 then
                                item.info.quality = 0.0
                            end
                        else
                            if type(item.info) == 'table' then
                                item.info.quality = 100.0
                            elseif type(item.info) == 'string' and item.info == '' then
                                item.info = {}
                                item.info.quality = 100.0
                            end

                        end

                        local modifiedItem = {
                            name = itemInfo["name"],
                            amount = tonumber(item.amount),
                            info = item.info ~= nil and item.info or "",
                            label = itemInfo["label"],
                            description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
                            weight = itemInfo["weight"], 
                            type = itemInfo["type"], 
                            unique = itemInfo["unique"], 
                            useable = itemInfo["useable"], 
                            image = itemInfo["image"],
                            slot = item.slot,
                        }

                        table.insert(items, modifiedItem)
                    end
                end
            end
            MySQL.Async.execute('UPDATE trunkitems SET items = ? WHERE id = ?', { json.encode(items), id })
            Citizen.Wait(500)
        end
	end
    TriggerClientEvent("MRFW:Notify", src, "DoneTrunk Decay", "success", 3000)
end

-- function DegradeAllTables()
--     DegradeInventoryItems()
--     Citizen.Wait(500)
--     DegradeStashItems()
--     Citizen.Wait(500)
--     DegradeTrunkItems()
--     Citizen.Wait(500)
--     DegradeGloveboxItems()
-- end

-- Citizen.CreateThread(function()
--     for k = 1, #Config.Times, 1 do
--         time = Config.Times[k]
--         TriggerEvent('cron:runAt', time, 00, DegradeAllTables)
--     end
-- end)