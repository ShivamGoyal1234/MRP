local robberyBusy = false
local timeOut = false
local blackoutActive = false

local ItemList = {
    ["electronickit"] = "electronickit",
    ["trojan_usb"] = "trojan_usb"
}


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000 * 60 * 10)
        if blackoutActive then
            TriggerEvent("mr-weathersync:server:toggleBlackout")
            TriggerClientEvent("police:client:EnableAllCameras", -1)
            TriggerClientEvent("mr-bankrobbery:client:enableAllBankSecurity", -1)
            blackoutActive = false
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000 * 60 * 30)
        TriggerClientEvent("mr-bankrobbery:client:enableAllBankSecurity", -1)
        TriggerClientEvent("police:client:EnableAllCameras", -1)
    end
end)

RegisterServerEvent('mr-bankrobbery:server:setBankState')
AddEventHandler('mr-bankrobbery:server:setBankState', function(bankId, state)
    if bankId == "paleto" then
        if not robberyBusy then
            Config.BigBanks["paleto"]["isOpened"] = state
            TriggerClientEvent('mr-bankrobbery:client:setBankState', -1, bankId, state)
            TriggerEvent('mr-scoreboard:server:SetActivityBusy', "paleto", true)
            TriggerEvent('mr-bankrobbery:server:setTimeout')
        end
    elseif bankId == "pacific" then
        if not robberyBusy then
            Config.BigBanks["pacific"]["isOpened"] = state
            TriggerClientEvent('mr-bankrobbery:client:setBankState', -1, bankId, state)
            TriggerEvent('mr-scoreboard:server:SetActivityBusy', "pacific", true)
            TriggerEvent('mr-bankrobbery:server:setTimeout')
        end
    else
        if not robberyBusy then
            Config.SmallBanks[bankId]["isOpened"] = state
            TriggerClientEvent('mr-bankrobbery:client:setBankState', -1, bankId, state)
            TriggerEvent('mr-banking:server:SetBankClosed', bankId, true)
            TriggerEvent('mr-scoreboard:server:SetActivityBusy', "bankrobbery", true)
            TriggerEvent('mr-bankrobbery:server:SetSmallbankTimeout', bankId)
        end
    end
    robberyBusy = true
end)

RegisterServerEvent('mr-bankrobbery:server:setLockerState')
AddEventHandler('mr-bankrobbery:server:setLockerState', function(bankId, lockerId, state, bool)
    if bankId == "paleto" then
        Config.BigBanks["paleto"]["lockers"][lockerId][state] = bool
    elseif bankId == "pacific" then
        Config.BigBanks["pacific"]["lockers"][lockerId][state] = bool
    else
        Config.SmallBanks[bankId]["lockers"][lockerId][state] = bool
    end

    TriggerClientEvent('mr-bankrobbery:client:setLockerState', -1, bankId, lockerId, state, bool)
end)

RegisterServerEvent('mr-bankrobbery:server:recieveItem')
AddEventHandler('mr-bankrobbery:server:recieveItem', function(type)
    local src = source
    local ply = MRFW.Functions.GetPlayer(src)

    if type == "small" then
        local itemType = math.random(#Config.RewardTypes)
        local WeaponChance = math.random(1, 50)
        local odd1 = math.random(1, 50)
        local tierChance = math.random(1, 100)
        local tier = 1

        if tierChance < 20 then tier = 1 elseif tierChance >= 20 and tierChance < 55 then tier = 2 elseif tierChance >= 55 and tierChance < 70 then tier = 3 else tier = 4 end
        if WeaponChance ~= odd1 then
            if tier == 1 then
                ply.Functions.AddItem('security_card_01', 1)
                TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items['security_card_01'], "add")
            else
                worth = math.random(3000, 5000)
                ply.Functions.AddMoney('cash', worth)
            end
        else
            worth = math.random(4000, 6000)
                ply.Functions.AddMoney('cash', worth)
        end
    elseif type == "paleto" then
        local itemType = math.random(#Config.RewardTypes)
        local tierChance = math.random(1, 100)
        local WeaponChance = math.random(1, 10)
        local odd1 = math.random(1, 10)
        local tier = 1
        if tierChance < 20 then tier = 1 elseif tierChance >= 20 and tierChance < 60 then tier = 2 elseif tierChance >= 60 and tierChance < 75 then tier = 3 else tier = 4 end
        if WeaponChance ~= odd1 then
            if tier == 1 then
                ply.Functions.AddItem('security_card_02', 1)
                TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items['security_card_01'], "add")
            else
                worth = math.random(3000, 5000)
                ply.Functions.AddMoney('cash', worth)
            end
        else
           worth = math.random(4000, 8000)
                    ply.Functions.AddMoney('cash', worth)
        end
    elseif type == "pacific" then
        local itemType = math.random(#Config.RewardTypes)
        local WeaponChance = math.random(1, 100)
        local odd1 = math.random(1, 100)
        local odd2 = math.random(1, 100)
        local tierChance = math.random(1, 100)
        local tier = 1
        if tierChance < 10 then tier = 1 elseif tierChance >= 25 and tierChance < 50 then tier = 2 elseif tierChance >= 50 and tierChance < 95 then tier = 3 else tier = 4 end
        if WeaponChance ~= odd1 or WeaponChance ~= odd2 then
            if tier ~= 4 then
                worth = math.random(10000, 20000)
                ply.Functions.AddMoney('cash', worth)
            elseif tier ~= 1 then
                ply.Functions.AddItem('heavyarmor', 1)
                TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items['heavyarmor'], "add")    
            else
                ply.Functions.AddItem('security_card_01', 1)
                TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items['security_card_01'], "add")
            end
        else
            worth = math.random(10000, 20000)
                ply.Functions.AddMoney('cash', worth)
        end
    else
        local chance = math.random(1, 2)
        local odd = math.random(1, 2)
        if chance == odd then
            ply.Functions.AddItem('weapon_microsmg', 1)
            TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items['weapon_microsmg'], "add")
        else
            ply.Functions.AddItem('weapon_minismg', 1)
            TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items['weapon_minismg'], "add")
        end

    end
end)

MRFW.Functions.CreateCallback('mr-bankrobbery:server:isRobberyActive', function(source, cb)
    cb(robberyBusy)
end)

MRFW.Functions.CreateCallback('mr-bankrobbery:server:GetConfig', function(source, cb)
    cb(Config)
end)

MRFW.Functions.CreateCallback("thermite:server:check", function(source, cb)
    local Player = MRFW.Functions.GetPlayer(source)
    if Player.Functions.RemoveItem("thermite2", 1) then
        TriggerClientEvent('inventory:client:ItemBox', source, MRFW.Shared.Items["thermite2"], "remove")
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent('mr-bankrobbery:server:setTimeout')
AddEventHandler('mr-bankrobbery:server:setTimeout', function()
    if not robberyBusy then
        if not timeOut then
            timeOut = true
            Citizen.CreateThread(function()
                Citizen.Wait(90 * (60 * 1000))
                timeOut = false
                robberyBusy = false
                TriggerEvent('mr-scoreboard:server:SetActivityBusy', "bankrobbery", false)
                TriggerEvent('mr-scoreboard:server:SetActivityBusy', "pacific", false)

                for k, v in pairs(Config.BigBanks["pacific"]["lockers"]) do
                    Config.BigBanks["pacific"]["lockers"][k]["isBusy"] = false
                    Config.BigBanks["pacific"]["lockers"][k]["isOpened"] = false
                end

                for k, v in pairs(Config.BigBanks["paleto"]["lockers"]) do
                    Config.BigBanks["paleto"]["lockers"][k]["isBusy"] = false
                    Config.BigBanks["paleto"]["lockers"][k]["isOpened"] = false
                end

                TriggerClientEvent('mr-bankrobbery:client:ClearTimeoutDoors', -1)
                Config.BigBanks["paleto"]["isOpened"] = false
                Config.BigBanks["pacific"]["isOpened"] = false
            end)
        end
    end
end)

RegisterServerEvent('mr-bankrobbery:server:SetSmallbankTimeout')
AddEventHandler('mr-bankrobbery:server:SetSmallbankTimeout', function(BankId)
    if not robberyBusy then
        if not timeOut then
            timeOut = true
            Citizen.CreateThread(function()
                Citizen.Wait(30 * (60 * 1000))
                timeOut = false
                robberyBusy = false

                for k, v in pairs(Config.SmallBanks[BankId]["lockers"]) do
                    Config.SmallBanks[BankId]["lockers"][k]["isOpened"] = false
                    Config.SmallBanks[BankId]["lockers"][k]["isBusy"] = false
                end

                timeOut = false
                robberyBusy = false
            	TriggerClientEvent('mr-bankrobbery:client:ResetFleecaLockers', -1, BankId)
            	TriggerEvent('mr-banking:server:SetBankClosed', BankId, false)
            end)
	end
    end
end)

RegisterServerEvent('mr-bankrobbery:server:callCops')
AddEventHandler('mr-bankrobbery:server:callCops', function(type, bank, streetLabel, coords)
    local cameraId = 4
    local bankLabel = "Fleeca"
    local msg = ""
    if type == "small" then
        cameraId = Config.SmallBanks[bank]["camId"]
        bankLabel = "Fleeca"
        msg = "The Alarm has been activated at "..bankLabel.. " " ..streetLabel.." (CAMERA ID: "..cameraId..")"
    elseif type == "paleto" then
        cameraId = Config.BigBanks["paleto"]["camId"]
        bankLabel = "Blaine County Savings"
        msg = "The Alarm has been activated at "..bankLabel.. " Paleto Bay (CAMERA ID: "..cameraId..")"
    elseif type == "pacific" then
        bankLabel = "Pacific Standard Bank"
        msg = "The Alarm has been activated at "..bankLabel.. " Alta St (CAMERA ID: 1/2/3)"
    end
    local alertData = {
        title = "Bank robbery",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg,
    }
    TriggerClientEvent("mr-bankrobbery:client:robberyCall", source, type, bank, streetLabel, coords)
    TriggerClientEvent("mr-phone:client:addPoliceAlert", -1, alertData)
end)

RegisterServerEvent('mr-bankrobbery:server:SetStationStatus')
AddEventHandler('mr-bankrobbery:server:SetStationStatus', function(key, isHit)
    Config.PowerStations[key].hit = isHit
    TriggerClientEvent("mr-bankrobbery:client:SetStationStatus", -1, key, isHit)
    if AllStationsHit() then
        TriggerEvent("mr-weathersync:server:toggleBlackout")
        TriggerClientEvent("police:client:DisableAllCameras", -1)
        TriggerClientEvent("mr-bankrobbery:client:disableAllBankSecurity", -1)
        blackoutActive = true
    else
        CheckStationHits()
    end
end)

RegisterServerEvent('thermite:StartServerFire')
AddEventHandler('thermite:StartServerFire', function(coords, maxChildren, isGasFire)
    TriggerClientEvent("thermite:StartFire", -1, coords, maxChildren, isGasFire)
end)

RegisterServerEvent('thermite:StopFires')
AddEventHandler('thermite:StopFires', function(coords, maxChildren, isGasFire)
    TriggerClientEvent("thermite:StopFires", -1)
end)

function CheckStationHits()
    if Config.PowerStations[1].hit and Config.PowerStations[2].hit and Config.PowerStations[3].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 19, false)
    end
    if Config.PowerStations[3].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 18, false)
        TriggerClientEvent("police:client:SetCamera", -1, 7, false)
    end
    if Config.PowerStations[4].hit and Config.PowerStations[5].hit and Config.PowerStations[6].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 4, false)
        TriggerClientEvent("police:client:SetCamera", -1, 8, false)
        TriggerClientEvent("police:client:SetCamera", -1, 5, false)
        TriggerClientEvent("police:client:SetCamera", -1, 6, false)
    end
    if Config.PowerStations[1].hit and Config.PowerStations[2].hit and Config.PowerStations[3].hit and Config.PowerStations[4].hit and Config.PowerStations[5].hit and Config.PowerStations[6].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 1, false)
        TriggerClientEvent("police:client:SetCamera", -1, 2, false)
        TriggerClientEvent("police:client:SetCamera", -1, 3, false)
    end
    if Config.PowerStations[7].hit and Config.PowerStations[8].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 9, false)
        TriggerClientEvent("police:client:SetCamera", -1, 10, false)
    end
    if Config.PowerStations[9].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 11, false)
        TriggerClientEvent("police:client:SetCamera", -1, 12, false)
        TriggerClientEvent("police:client:SetCamera", -1, 13, false)
    end
    if Config.PowerStations[9].hit and Config.PowerStations[10].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 14, false)
        TriggerClientEvent("police:client:SetCamera", -1, 17, false)
        TriggerClientEvent("police:client:SetCamera", -1, 19, false)
    end
    if Config.PowerStations[7].hit and Config.PowerStations[9].hit and Config.PowerStations[10].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 15, false)
        TriggerClientEvent("police:client:SetCamera", -1, 16, false)
    end
    if Config.PowerStations[10].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 20, false)
    end
    if Config.PowerStations[11].hit and Config.PowerStations[1].hit and Config.PowerStations[2].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 21, false)
        TriggerClientEvent("mr-bankrobbery:client:BankSecurity", 1, false)
        TriggerClientEvent("police:client:SetCamera", -1, 22, false)
        TriggerClientEvent("mr-bankrobbery:client:BankSecurity", 2, false)
    end
    if Config.PowerStations[8].hit and Config.PowerStations[4].hit and Config.PowerStations[5].hit and Config.PowerStations[6].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 23, false)
        TriggerClientEvent("mr-bankrobbery:client:BankSecurity", 3, false)
    end
    if Config.PowerStations[12].hit and Config.PowerStations[13].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 24, false)
        TriggerClientEvent("mr-bankrobbery:client:BankSecurity", 4, false)
        TriggerClientEvent("police:client:SetCamera", -1, 25, false)
        TriggerClientEvent("mr-bankrobbery:client:BankSecurity", 5, false)
    end
end

function AllStationsHit()
    local retval = true
    for k, v in pairs(Config.PowerStations) do
        if not Config.PowerStations[k].hit then
            retval = false
        end
    end
    return retval
end

MRFW.Functions.CreateUseableItem("thermite2", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('lighter') ~= nil then
        Player.Functions.RemoveItem(item.name, 1, item.slot)
        TriggerClientEvent("thermite:UseThermite", source)
    else
        TriggerClientEvent('MRFW:Notify', source, "You're missing ignition source ", "error")
    end
end)

MRFW.Functions.CreateUseableItem("security_card_01", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('security_card_01') ~= nil then
        TriggerClientEvent("mr-bankrobbery:UseBankcardA", source)
    end
end)

MRFW.Functions.CreateUseableItem("security_card_02", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('security_card_02') ~= nil then
        TriggerClientEvent("mr-bankrobbery:UseBankcardB", source)
    end
end)

MRFW.Functions.CreateUseableItem("electronickit", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
    if Player.Functions.GetItemByName('electronickit') ~= nil then
        if item.info.uses >= 1 then
            TriggerClientEvent("electronickit:UseElectronickit", source, item)
        else
            TriggerClientEvent("MRFW:Notify", source, "Chip Broken", "error", 10000)
        end
    end
end)
