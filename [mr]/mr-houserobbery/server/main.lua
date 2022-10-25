local MRFW = exports['mrfw']:GetCoreObject()

MRFW.Functions.CreateCallback('mr-houserobbery:server:GetHouseConfig', function(source, cb)
    cb(Config.Houses)
end)

RegisterServerEvent('mr-houserobbery:server:enterHouse')
AddEventHandler('mr-houserobbery:server:enterHouse', function(house)
    local src = source
    local itemInfo = MRFW.Shared.Items["lockpick"]
    local Player = MRFW.Functions.GetPlayer(src)
    
    if not Config.Houses[house]["opened"] then
        ResetHouseStateTimer(house)
        TriggerClientEvent('mr-houserobbery:client:setHouseState', -1, house, true)
    end
    TriggerClientEvent('mr-houserobbery:client:enterHouse', src, house)
    Config.Houses[house]["opened"] = true
end)

function ResetHouseStateTimer(house)
    -- Cannot parse math.random "directly" inside the tonumber function
    local num = math.random(3333333, 11111111)
    local time = tonumber(num)
    Citizen.SetTimeout(time, function()
        Config.Houses[house]["opened"] = false
        for k, v in pairs(Config.Houses[house]["furniture"]) do
            v["searched"] = false
        end
        TriggerClientEvent('mr-houserobbery:client:ResetHouseState', -1, house)
    end)
end

RegisterServerEvent('mr-houserobbery:server:searchCabin')
AddEventHandler('mr-houserobbery:server:searchCabin', function(cabin, house)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local luck = math.random(1, 10)
    local itemFound = math.random(1, 4)
    local itemCount = 1

    local Tier = 1
    if Config.Houses[house]["tier"] == 1 then
        Tier = 1
    elseif Config.Houses[house]["tier"] == 2 then
        Tier = 2
    elseif Config.Houses[house]["tier"] == 3 then
        Tier = 3
    end

    if itemFound < 4 then
        if luck == 10 then
            itemCount = 3
        elseif luck >= 6 and luck <= 8 then
            itemCount = 2
        end

        for i = 1, itemCount, 1 do
            local randomItem = Config.Rewards[Tier][Config.Houses[house]["furniture"][cabin]["type"]][math.random(1, #Config.Rewards[Tier][Config.Houses[house]["furniture"][cabin]["type"]])]
            local itemInfo = MRFW.Shared.Items[randomItem]
            if math.random(1, 100) == 69 then
                randomItem = "painkillers"
                itemInfo = MRFW.Shared.Items[randomItem]
                Player.Functions.AddItem(randomItem, 2)
                TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "add", 2)
            elseif math.random(1, 100) == 35 then
                    randomItem = "weed_og-kush_seed"
                    itemInfo = MRFW.Shared.Items[randomItem]
                    Player.Functions.AddItem(randomItem, 1)
                    TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "add")
            else
                if not itemInfo["unqiue"] then
                    local itemAmount = math.random(1, 3)
                    if randomItem == "plastic" then
                        itemAmount = math.random(8, 10)
                    elseif randomItem == "goldchain" then
                        itemAmount = math.random(1, 2)
                    elseif randomItem == "advancedlockpick" then
                        itemAmount = math.random(1, 2)
                    elseif randomItem == "pistol_ammo" then
                        itemAmount = math.random(1, 2)
                    elseif randomItem == "rifle_ammo" then
                        itemAmount = math.random(1, 2)
                    elseif randomItem == "smg_ammo" then
                        itemAmount = math.random(1, 2)
                    elseif randomItem == "wire" then
                        itemAmount = math.random(1, 2)
                    elseif randomItem == "redchip" then
                        itemAmount = math.random(1, 1)
                    elseif randomItem == "bluechip" then
                        itemAmount = math.random(1, 1)
                    elseif randomItem == "handcuffs" then
                        itemAmount = math.random(1, 2)
                    elseif randomItem == "weed_og-kush_seed" then
                        itemAmount = math.random(1, 2)
                    elseif randomItem == "diamond_ring" then
                        itemAmount = math.random(1, 2)
                    elseif randomItem == "rolex" then
                        itemAmount = math.random(1, 2)
                    elseif randomItem == "blackmoney" then
                        itemAmount = math.random(10, 200)
                    end
                    
                    Player.Functions.AddItem(randomItem, itemAmount)
                    TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "add", itemAmount)
                else
                    Player.Functions.AddItem(randomItem, 1)
                    TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "add", 1)
                end
            end
            Citizen.Wait(500)
            -- local weaponChance = math.random(1, 100)
        end
    else
        TriggerClientEvent('MRFW:Notify', src, 'The box is empty', 'error', 3500)
    end

    Config.Houses[house]["furniture"][cabin]["searched"] = true
    TriggerClientEvent('mr-houserobbery:client:setCabinState', -1, house, cabin, true)
end)

RegisterServerEvent('mr-houserobbery:server:SetBusyState')
AddEventHandler('mr-houserobbery:server:SetBusyState', function(cabin, house, bool)
    Config.Houses[house]["furniture"][cabin]["isBusy"] = bool
    TriggerClientEvent('mr-houserobbery:client:SetBusyState', -1, cabin, house, bool)
end)

MRFW.Commands.Add('lhdoor', 'Lock house robbery door (Police Only)', {}, false, function(source, args)
    TriggerClientEvent('jacob:client:reset:door:pd', source)
end, 'police')

RegisterServerEvent('jacob:server:reset:door:pd')
AddEventHandler('jacob:server:reset:door:pd', function(house)
    if house ~= nil then
        Config.Houses[house]["opened"] = false
        for k, v in pairs(Config.Houses[house]["furniture"]) do
            v["searched"] = false
        end
        TriggerClientEvent('mr-houserobbery:client:ResetHouseState', -1, house)
    end
end)