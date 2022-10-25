local AJFW = exports['ajfw']:GetCoreObject()

local formats = {[1]={a='b',b='g',c='r',},[2]={a='b',b='r',c='g',},[3]={a='g',b='b',c='r',},[4]={a='g',b='r',c='b',},[5]={a='r',b='b',c='g',},[6]={a='r',b='g',c='b',}}

local SomeoneDoingHack = false
local inUseOfLicense = nil
local activeFormat = nil
local successAttempts = 0
local failedAttempts = 0
local decrypting = false
local SystemOverload = false
local activeObjects = {}

RegisterNetEvent('aj-cargo:server:removeDrop:Giveitem',function(drop)
    DeleteEntity(activeObjects[drop])
    if activeObjects[drop] then
        TriggerClientEvent('aj-cargo:client:sync',-1,drop)
        activeObjects[drop] = nil
        local src = source
        local Player = AJFW.Functions.GetPlayer(src)
        local RandomCatagory = math.random(1,100)
        if RandomCatagory <=25 then
            local RandomTier = math.random(1, #Config.Drop_1)
            local RandomItem = math.random(1, #Config.Drop_1[RandomTier])
            print(Config.Drop_1[RandomTier][RandomItem].item)
            Player.Functions.AddItem(Config.Drop_1[RandomTier][RandomItem].item, Config.Drop_1[RandomTier][RandomItem].amount)
            TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items[Config.Drop_1[RandomTier][RandomItem].item], "add")
            TriggerEvent("aj-log:server:CreateLog", "gunhiest", "GUNHIEST", "green", "**"..GetPlayerName(src) .. "** has Picked up " .. Config.Drop_1[RandomTier][RandomItem].item .." ".. Config.Drop_1[RandomTier][RandomItem].amount)
        elseif RandomCatagory >25 and RandomCatagory<=50 then
            local RandomTier = math.random(1, #Config.Drop_2)
            local RandomItem = math.random(1, #Config.Drop_2[RandomTier])
            print(Config.Drop_2[RandomTier][RandomItem].item)
            Player.Functions.AddItem(Config.Drop_2[RandomTier][RandomItem].item, Config.Drop_2[RandomTier][RandomItem].amount)
            TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items[Config.Drop_2[RandomTier][RandomItem].item], "add")
            TriggerEvent("aj-log:server:CreateLog", "gunhiest", "GUNHIEST", "green", "**"..GetPlayerName(src) .. "** has Picked up " .. Config.Drop_2[RandomTier][RandomItem].item .." ".. Config.Drop_2[RandomTier][RandomItem].amount)
        elseif RandomCatagory >50 and RandomCatagory<=75 then
            local RandomTier = math.random(1, #Config.Drop_3)
            local RandomItem = math.random(1, #Config.Drop_3[RandomTier])
            print(Config.Drop_3[RandomTier][RandomItem].item)
            Player.Functions.AddItem(Config.Drop_3[RandomTier][RandomItem].item, Config.Drop_3[RandomTier][RandomItem].amount)
            TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items[Config.Drop_3[RandomTier][RandomItem].item], "add")
            TriggerEvent("aj-log:server:CreateLog", "gunhiest", "GUNHIEST", "green", "**"..GetPlayerName(src) .. "** has Picked up " .. Config.Drop_3[RandomTier][RandomItem].item .." ".. Config.Drop_3[RandomTier][RandomItem].amount)
        elseif RandomCatagory >75 and RandomCatagory<=100 then
            local RandomTier = math.random(1, #Config.Drop_4)
            local RandomItem = math.random(1, #Config.Drop_4[RandomTier])
            print(Config.Drop_4[RandomTier][RandomItem].item)
            Player.Functions.AddItem(Config.Drop_4[RandomTier][RandomItem].item, Config.Drop_4[RandomTier][RandomItem].amount)
            TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items[Config.Drop_4[RandomTier][RandomItem].item], "add")
            TriggerEvent("aj-log:server:CreateLog", "gunhiest", "GUNHIEST", "green", "**"..GetPlayerName(src) .. "** has Picked up " .. Config.Drop_4[RandomTier][RandomItem].item .." ".. Config.Drop_4[RandomTier][RandomItem].amount)
        end
    end
end)

RegisterNetEvent('aj-cargo:server:decryptSuccess',function(item)
    local src = source
    local identifiers, license = GetPlayerIdentifiers(src)
    local foundLocation = false
    for _, v in pairs(identifiers) do
        if string.find(v, "license") then
            license = v
            break
        end
    end
    local Player = AJFW.Functions.GetPlayer(src)
    Player.Functions.RemoveItem(item.name, 1, item.slot)
    decrypting = false
    if successAttempts == 0 then
        successAttempts = successAttempts + 1
    elseif successAttempts == 1 then
        successAttempts = successAttempts + 1
    elseif successAttempts == 2 then
        successAttempts = successAttempts + 1
        failedAttempts = 3
        TriggerClientEvent("AJFW:Notify", src, "Please Wait For Sometime For Location", "error", 1000)
        Citizen.Wait(1000)
        repeat
            Wait(100)
            local randomLocation = math.random(1, #Config.Locations)
            local location = Config.Locations[randomLocation].coords
            local spotAvailalbe = Config.Locations[randomLocation].person
            if spotAvailalbe == nil or spotAvailalbe ~= license  then
                Config.Locations[randomLocation].person = license
                SomeoneDoingHack = false
                inUseOfLicense = nil
                activeFormat = nil
                successAttempts = 0
                failedAttempts = 0
                decrypting = false
                SystemOverload = true
                foundLocation = true
                local model = `gr_prop_gr_rsply_crate04a`
                local entity = CreateObject(model, Config.Locations[randomLocation].coords.x, Config.Locations[randomLocation].coords.y, Config.Locations[randomLocation].coords.z - 1, true, true)
                activeObjects[randomLocation] = entity
                TriggerClientEvent('aj-cargo:load:model', -1, model, entity)
                -- print(location)
                TriggerClientEvent('aj-cargo:create:Drop', src, entity, randomLocation, location)
                TriggerClientEvent('aj-cargo:client:syncDrop',-1,randomLocation,location)
                TriggerClientEvent('aj-cargo:reset:Hacking',src)
                SetTimeout(600000, function()
                    SystemOverload = false
                end)
            end
            -- print(location, spotAvailalbe)
        until foundLocation
    end
end)

RegisterNetEvent('aj-cargo:server:decryptFailed',function()
    decrypting = false
end)

RegisterNetEvent('aj-cargo:hackingCompleted',function()
    local randomFormat = math.random(1, #formats)
    activeFormat = randomFormat
    if     formats[activeFormat].a == 'r' then
        TriggerClientEvent('chatMessage', source, "FIRST", "error", 'Red Chip')
    elseif formats[activeFormat].a == 'g' then
        TriggerClientEvent('chatMessage', source, "FIRST", "report", 'Green Chip')
    elseif formats[activeFormat].a == 'b' then
        TriggerClientEvent('chatMessage', source, "FIRST", "schat", 'Blue Chip')
    end
    if     formats[activeFormat].b == 'r' then
        TriggerClientEvent('chatMessage', source, "SECOND", "error", 'Red Chip')
    elseif formats[activeFormat].b == 'g' then
        TriggerClientEvent('chatMessage', source, "SECOND", "report", 'Green Chip')
    elseif formats[activeFormat].b == 'b' then
        TriggerClientEvent('chatMessage', source, "SECOND", "schat", 'Blue Chip')
    end
    if     formats[activeFormat].c == 'r' then
        TriggerClientEvent('chatMessage', source, "THIRD", "error", 'Red Chip')
    elseif formats[activeFormat].c == 'g' then
        TriggerClientEvent('chatMessage', source, "THIRD", "report", 'Green Chip')
    elseif formats[activeFormat].c == 'b' then
        TriggerClientEvent('chatMessage', source, "THIRD", "schat", 'Blue Chip')
    end
end)

RegisterNetEvent('aj-cargo:server:available', function(bool)
    local src = source
    local identifiers, license = GetPlayerIdentifiers(src)
    for _, v in pairs(identifiers) do
        if string.find(v, "license") then
            license = v
            break
        end
    end
    if bool then
        SomeoneDoingHack = bool
        inUseOfLicense = license
    else
        if inUseOfLicense == license then
            SomeoneDoingHack = bool
            inUseOfLicense = nil
            activeFormat = nil
            successAttempts = 0
            failedAttempts = 0
            decrypting = false
            SystemOverload = true
            SetTimeout(60000, function()
                SystemOverload = false
            end)
        end
    end
    for i = 1, #Config.Locations do
        if Config.Locations[i].person == license then
            Config.Locations[i].person = nil
            DeleteEntity(activeObjects[i])
        end
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    local identifiers, license = GetPlayerIdentifiers(src)
    for _, v in pairs(identifiers) do
        if string.find(v, "license") then
            license = v
            break
        end
    end
    if inUseOfLicense ~= nil then
        if inUseOfLicense == license then
            SomeoneDoingHack = false
            inUseOfLicense = nil
            activeFormat = nil
            successAttempts = 0
            failedAttempts = 0
            decrypting = false
            SystemOverload = true
            SetTimeout(60000, function()
                SystemOverload = false
            end)
        end
    end
    for i = 1, #Config.Locations do
        if Config.Locations[i].person == license then
            Config.Locations[i].person = nil
            DeleteEntity(activeObjects[i])
        end
    end
end)

AJFW.Functions.CreateUseableItem('harddrive' , function(source, item)
    local src = source
    local ped = GetPlayerPed(src)
    local pos = GetEntityCoords(ped)
    local coords = Config.start
    local cops = AJFW.Functions.GetDutyCount('police')
    local dist = #(pos - coords)
    if dist <= 1.5 then
        if cops >= Config.cops then
            if not SomeoneDoingHack then
                if not SystemOverload then
                    if item.info.uses >= 1 then
                        TriggerClientEvent('aj-cargo:client:startHack', source, item)
                    else
                        TriggerClientEvent("AJFW:Notify", src, "Wierd sound in hard drive", "error", 10000)
                    end
                else
                    TriggerClientEvent("AJFW:Notify", src, "System Overloaded Wait SomeTime", "error", 3000)
                end
            else
                TriggerClientEvent("AJFW:Notify", src, "Hack is already running by yourself or someone", "error", 3000)
            end
        else
            TriggerClientEvent("AJFW:Notify", src, "Not Enough Cops Available", "error", 3000)
        end
    end
end)

AJFW.Functions.CreateUseableItem('redchip' , function(source, item)
    local src = source
    local ped = GetPlayerPed(src)
    local pos = GetEntityCoords(ped)
    local coords = Config.start
    local dist = #(pos - coords)
    local identifiers, license = GetPlayerIdentifiers(src)
    local Player = AJFW.Functions.GetPlayer(source)
    for _, v in pairs(identifiers) do
        if string.find(v, "license") then
            license = v
            break
        end
    end
    if dist <= 1.5 then
        if inUseOfLicense ~= nil then
            if inUseOfLicense == license then
                if not decrypting then
                    decrypting = true
                    if failedAttempts == 0 then
                        if successAttempts == 0 then
                            if formats[activeFormat].a == 'r' then
                                TriggerClientEvent('aj-cargo:client:Decrypt', src, item)
                            else
                                TriggerClientEvent("AJFW:Notify", src, "Wrong Key Remaining Attempts = 2", "error", 3000)
                                Player.Functions.RemoveItem(item.name, 1, item.slot)
                                failedAttempts = failedAttempts + 1
                                decrypting = false
                            end
                        elseif successAttempts == 1 then
                            if formats[activeFormat].b == 'r' then
                                TriggerClientEvent('aj-cargo:client:Decrypt', src, item)
                            else
                                TriggerClientEvent("AJFW:Notify", src, "Wrong Key Remaining Attempts = 2", "error", 3000)
                                Player.Functions.RemoveItem(item.name, 1, item.slot)
                                failedAttempts = failedAttempts + 1
                                decrypting = false
                            end
                        elseif successAttempts == 2 then
                            if formats[activeFormat].c == 'r' then
                                TriggerClientEvent('aj-cargo:client:Decrypt', src, item)
                            else
                                TriggerClientEvent("AJFW:Notify", src, "Wrong Key Remaining Attempts = 2", "error", 3000)
                                Player.Functions.RemoveItem(item.name, 1, item.slot)
                                failedAttempts = failedAttempts + 1
                                decrypting = false
                            end
                        end
                    elseif failedAttempts == 1 then
                        if successAttempts == 0 then
                            if formats[activeFormat].a == 'r' then
                                TriggerClientEvent('aj-cargo:client:Decrypt', src, item)
                            else
                                TriggerClientEvent("AJFW:Notify", src, "Wrong Key Remaining Attempts = 1", "error", 3000)
                                Player.Functions.RemoveItem(item.name, 1, item.slot)
                                failedAttempts = failedAttempts + 1
                                decrypting = false
                            end
                        elseif successAttempts == 1 then
                            if formats[activeFormat].b == 'r' then
                                TriggerClientEvent('aj-cargo:client:Decrypt', src, item)
                            else
                                TriggerClientEvent("AJFW:Notify", src, "Wrong Key Remaining Attempts = 1", "error", 3000)
                                Player.Functions.RemoveItem(item.name, 1, item.slot)
                                failedAttempts = failedAttempts + 1
                                decrypting = false
                            end
                        elseif successAttempts == 2 then
                            if formats[activeFormat].c == 'r' then
                                TriggerClientEvent('aj-cargo:client:Decrypt', src, item)
                            else
                                TriggerClientEvent("AJFW:Notify", src, "Wrong Key Remaining Attempts = 1", "error", 3000)
                                Player.Functions.RemoveItem(item.name, 1, item.slot)
                                failedAttempts = failedAttempts + 1
                                decrypting = false
                            end
                        end
                    elseif failedAttempts == 2 then
                        if successAttempts == 0 then
                            if formats[activeFormat].a == 'r' then
                                TriggerClientEvent('aj-cargo:client:Decrypt', src, item)
                            else
                                TriggerClientEvent("AJFW:Notify", src, "Wrong Key Hack Failed", "error", 3000)
                                TriggerClientEvent('aj-cargo:client:DoneHack', src)
                                Player.Functions.RemoveItem(item.name, 1, item.slot)
                                SomeoneDoingHack = false
                                inUseOfLicense = nil
                                activeFormat = nil
                                successAttempts = 0
                                failedAttempts = 0
                                decrypting = false
                                SystemOverload = true
                                SetTimeout(60000, function()
                                    SystemOverload = false
                                end)
                            end
                        elseif successAttempts == 1 then
                            if formats[activeFormat].b == 'r' then
                                TriggerClientEvent('aj-cargo:client:Decrypt', src, item)
                            else
                                TriggerClientEvent("AJFW:Notify", src, "Wrong Key Hack Failed", "error", 3000)
                                TriggerClientEvent('aj-cargo:client:DoneHack', src)
                                Player.Functions.RemoveItem(item.name, 1, item.slot)
                                SomeoneDoingHack = false
                                inUseOfLicense = nil
                                activeFormat = nil
                                successAttempts = 0
                                failedAttempts = 0
                                decrypting = false
                                SystemOverload = true
                                SetTimeout(60000, function()
                                    SystemOverload = false
                                end)
                            end
                        elseif successAttempts == 2 then
                            if formats[activeFormat].c == 'r' then
                                TriggerClientEvent('aj-cargo:client:Decrypt', src, item)
                            else
                                TriggerClientEvent("AJFW:Notify", src, "Wrong Key Hack Failed", "error", 3000)
                                TriggerClientEvent('aj-cargo:client:DoneHack', src)
                                Player.Functions.RemoveItem(item.name, 1, item.slot)
                                SomeoneDoingHack = false
                                inUseOfLicense = nil
                                activeFormat = nil
                                successAttempts = 0
                                failedAttempts = 0
                                decrypting = false
                                SystemOverload = true
                                SetTimeout(60000, function()
                                    SystemOverload = false
                                end)
                            end
                        end
                    end
                else
                    TriggerClientEvent("AJFW:Notify", src, "Already Running Code decrypting", "error", 3000)
                end
            else
                TriggerClientEvent("AJFW:Notify", src, "Someone Already Doing Hack", "error", 3000)
            end
        end
    end
end)

AJFW.Functions.CreateUseableItem('greenchip' , function(source, item)
    local src = source
    local ped = GetPlayerPed(src)
    local pos = GetEntityCoords(ped)
    local coords = Config.start
    local dist = #(pos - coords)
    local identifiers, license = GetPlayerIdentifiers(src)
    for _, v in pairs(identifiers) do
        if string.find(v, "license") then
            license = v
            break
        end
    end
    local Player = AJFW.Functions.GetPlayer(source)
    if dist <= 1.5 then
        if inUseOfLicense ~= nil then
            if inUseOfLicense == license then
                if not decrypting then
                    decrypting = true
                    if failedAttempts == 0 then
                        if successAttempts == 0 then
                            if formats[activeFormat].a == 'g' then
                                TriggerClientEvent('aj-cargo:client:Decrypt', src, item)
                            else
                                TriggerClientEvent("AJFW:Notify", src, "Wrong Key Remaining Attempts = 2", "error", 3000)
                                Player.Functions.RemoveItem(item.name, 1, item.slot)
                                failedAttempts = failedAttempts + 1
                                decrypting = false
                            end
                        elseif successAttempts == 1 then
                            if formats[activeFormat].b == 'g' then
                                TriggerClientEvent('aj-cargo:client:Decrypt', src, item)
                            else
                                TriggerClientEvent("AJFW:Notify", src, "Wrong Key Remaining Attempts = 2", "error", 3000)
                                Player.Functions.RemoveItem(item.name, 1, item.slot)
                                failedAttempts = failedAttempts + 1
                                decrypting = false
                            end
                        elseif successAttempts == 2 then
                            if formats[activeFormat].c == 'g' then
                                TriggerClientEvent('aj-cargo:client:Decrypt', src, item)
                            else
                                TriggerClientEvent("AJFW:Notify", src, "Wrong Key Remaining Attempts = 2", "error", 3000)
                                Player.Functions.RemoveItem(item.name, 1, item.slot)
                                failedAttempts = failedAttempts + 1
                                decrypting = false
                            end
                        end
                    elseif failedAttempts == 1 then
                        if successAttempts == 0 then
                            if formats[activeFormat].a == 'g' then
                                TriggerClientEvent('aj-cargo:client:Decrypt', src, item)
                            else
                                TriggerClientEvent("AJFW:Notify", src, "Wrong Key Remaining Attempts = 1", "error", 3000)
                                Player.Functions.RemoveItem(item.name, 1, item.slot)
                                failedAttempts = failedAttempts + 1
                                decrypting = false
                            end
                        elseif successAttempts == 1 then
                            if formats[activeFormat].b == 'g' then
                                TriggerClientEvent('aj-cargo:client:Decrypt', src, item)
                            else
                                TriggerClientEvent("AJFW:Notify", src, "Wrong Key Remaining Attempts = 1", "error", 3000)
                                Player.Functions.RemoveItem(item.name, 1, item.slot)
                                failedAttempts = failedAttempts + 1
                                decrypting = false
                            end
                        elseif successAttempts == 2 then
                            if formats[activeFormat].c == 'g' then
                                TriggerClientEvent('aj-cargo:client:Decrypt', src, item)
                            else
                                TriggerClientEvent("AJFW:Notify", src, "Wrong Key Remaining Attempts = 1", "error", 3000)
                                Player.Functions.RemoveItem(item.name, 1, item.slot)
                                failedAttempts = failedAttempts + 1
                                decrypting = false
                            end
                        end
                    elseif failedAttempts == 2 then
                        if successAttempts == 0 then
                            if formats[activeFormat].a == 'g' then
                                TriggerClientEvent('aj-cargo:client:Decrypt', src, item)
                            else
                                TriggerClientEvent("AJFW:Notify", src, "Wrong Key Hack Failed", "error", 3000)
                                TriggerClientEvent('aj-cargo:client:DoneHack', src)
                                Player.Functions.RemoveItem(item.name, 1, item.slot)
                                SomeoneDoingHack = false
                                inUseOfLicense = nil
                                activeFormat = nil
                                successAttempts = 0
                                failedAttempts = 0
                                decrypting = false
                                SystemOverload = true
                                SetTimeout(60000, function()
                                    SystemOverload = false
                                end)
                            end
                        elseif successAttempts == 1 then
                            if formats[activeFormat].b == 'g' then
                                TriggerClientEvent('aj-cargo:client:Decrypt', src, item)
                            else
                                TriggerClientEvent("AJFW:Notify", src, "Wrong Key Hack Failed", "error", 3000)
                                TriggerClientEvent('aj-cargo:client:DoneHack', src)
                                Player.Functions.RemoveItem(item.name, 1, item.slot)
                                SomeoneDoingHack = false
                                inUseOfLicense = nil
                                activeFormat = nil
                                successAttempts = 0
                                failedAttempts = 0
                                decrypting = false
                                SystemOverload = true
                                SetTimeout(60000, function()
                                    SystemOverload = false
                                end)
                            end
                        elseif successAttempts == 2 then
                            if formats[activeFormat].c == 'g' then
                                TriggerClientEvent('aj-cargo:client:Decrypt', src, item)
                            else
                                TriggerClientEvent("AJFW:Notify", src, "Wrong Key Hack Failed", "error", 3000)
                                TriggerClientEvent('aj-cargo:client:DoneHack', src)
                                Player.Functions.RemoveItem(item.name, 1, item.slot)
                                SomeoneDoingHack = false
                                inUseOfLicense = nil
                                activeFormat = nil
                                successAttempts = 0
                                failedAttempts = 0
                                decrypting = false
                                SystemOverload = true
                                SetTimeout(60000, function()
                                    SystemOverload = false
                                end)
                            end
                        end
                    end
                else
                    TriggerClientEvent("AJFW:Notify", src, "Already Running Code decrypting", "error", 3000)
                end
            else
                TriggerClientEvent("AJFW:Notify", src, "Someone Already Doing Hack", "error", 3000)
            end
        end
    end
end)

AJFW.Functions.CreateUseableItem('bluechip' , function(source, item)
    local src = source
    local ped = GetPlayerPed(src)
    local pos = GetEntityCoords(ped)
    local coords = Config.start
    local dist = #(pos - coords)
    local identifiers, license = GetPlayerIdentifiers(src)
    for _, v in pairs(identifiers) do
        if string.find(v, "license") then
            license = v
            break
        end
    end
    local Player = AJFW.Functions.GetPlayer(source)
    if dist <= 1.5 then
        if inUseOfLicense ~= nil then
            if inUseOfLicense == license then
                if not decrypting then
                    decrypting = true
                    if failedAttempts == 0 then
                        if successAttempts == 0 then
                            if formats[activeFormat].a == 'b' then
                                TriggerClientEvent('aj-cargo:client:Decrypt', src, item)
                            else
                                TriggerClientEvent("AJFW:Notify", src, "Wrong Key Remaining Attempts = 2", "error", 3000)
                                Player.Functions.RemoveItem(item.name, 1, item.slot)
                                failedAttempts = failedAttempts + 1
                                decrypting = false
                            end
                        elseif successAttempts == 1 then
                            if formats[activeFormat].b == 'b' then
                                TriggerClientEvent('aj-cargo:client:Decrypt', src, item)
                            else
                                TriggerClientEvent("AJFW:Notify", src, "Wrong Key Remaining Attempts = 2", "error", 3000)
                                Player.Functions.RemoveItem(item.name, 1, item.slot)
                                failedAttempts = failedAttempts + 1
                                decrypting = false
                            end
                        elseif successAttempts == 2 then
                            if formats[activeFormat].c == 'b' then
                                TriggerClientEvent('aj-cargo:client:Decrypt', src, item)
                            else
                                TriggerClientEvent("AJFW:Notify", src, "Wrong Key Remaining Attempts = 2", "error", 3000)
                                Player.Functions.RemoveItem(item.name, 1, item.slot)
                                failedAttempts = failedAttempts + 1
                                decrypting = false
                            end
                        end
                    elseif failedAttempts == 1 then
                        if successAttempts == 0 then
                            if formats[activeFormat].a == 'b' then
                                TriggerClientEvent('aj-cargo:client:Decrypt', src, item)
                            else
                                TriggerClientEvent("AJFW:Notify", src, "Wrong Key Remaining Attempts = 1", "error", 3000)
                                Player.Functions.RemoveItem(item.name, 1, item.slot)
                                failedAttempts = failedAttempts + 1
                                decrypting = false
                            end
                        elseif successAttempts == 1 then
                            if formats[activeFormat].b == 'b' then
                                TriggerClientEvent('aj-cargo:client:Decrypt', src, item)
                            else
                                TriggerClientEvent("AJFW:Notify", src, "Wrong Key Remaining Attempts = 1", "error", 3000)
                                Player.Functions.RemoveItem(item.name, 1, item.slot)
                                failedAttempts = failedAttempts + 1
                                decrypting = false
                            end
                        elseif successAttempts == 2 then
                            if formats[activeFormat].c == 'b' then
                                TriggerClientEvent('aj-cargo:client:Decrypt', src, item)
                            else
                                TriggerClientEvent("AJFW:Notify", src, "Wrong Key Remaining Attempts = 1", "error", 3000)
                                Player.Functions.RemoveItem(item.name, 1, item.slot)
                                failedAttempts = failedAttempts + 1
                                decrypting = false
                            end
                        end
                    elseif failedAttempts == 2 then
                        if successAttempts == 0 then
                            if formats[activeFormat].a == 'b' then
                                TriggerClientEvent('aj-cargo:client:Decrypt', src, item)
                            else
                                TriggerClientEvent("AJFW:Notify", src, "Wrong Key Hack Failed", "error", 3000)
                                TriggerClientEvent('aj-cargo:client:DoneHack', src)
                                Player.Functions.RemoveItem(item.name, 1, item.slot)
                                SomeoneDoingHack = false
                                inUseOfLicense = nil
                                activeFormat = nil
                                successAttempts = 0
                                failedAttempts = 0
                                decrypting = false
                                SystemOverload = true
                                SetTimeout(60000, function()
                                    SystemOverload = false
                                end)
                            end
                        elseif successAttempts == 1 then
                            if formats[activeFormat].b == 'b' then
                                TriggerClientEvent('aj-cargo:client:Decrypt', src, item)
                            else
                                TriggerClientEvent("AJFW:Notify", src, "Wrong Key Hack Failed", "error", 3000)
                                TriggerClientEvent('aj-cargo:client:DoneHack', src)
                                Player.Functions.RemoveItem(item.name, 1, item.slot)
                                SomeoneDoingHack = false
                                inUseOfLicense = nil
                                activeFormat = nil
                                successAttempts = 0
                                failedAttempts = 0
                                decrypting = false
                                SystemOverload = true
                                SetTimeout(60000, function()
                                    SystemOverload = false
                                end)
                            end
                        elseif successAttempts == 2 then
                            if formats[activeFormat].c == 'b' then
                                TriggerClientEvent('aj-cargo:client:Decrypt', src, item)
                            else
                                TriggerClientEvent("AJFW:Notify", src, "Wrong Key Hack Failed", "error", 3000)
                                TriggerClientEvent('aj-cargo:client:DoneHack', src)
                                Player.Functions.RemoveItem(item.name, 1, item.slot)
                                SomeoneDoingHack = false
                                inUseOfLicense = nil
                                activeFormat = nil
                                successAttempts = 0
                                failedAttempts = 0
                                decrypting = false
                                SystemOverload = true
                                SetTimeout(60000, function()
                                    SystemOverload = false
                                end)
                            end
                        end
                    end
                else
                    TriggerClientEvent("AJFW:Notify", src, "Already Running Code decrypting", "error", 3000)
                end
            else
                TriggerClientEvent("AJFW:Notify", src, "Someone Already Doing Hack", "error", 3000)
            end
        end
    end
end)