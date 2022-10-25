local closestBank = nil
local inRange
local requiredItemsShowed = false
local copsCalled = false
local PlayerJob = {}
local refreshed = false
currentThermiteGate = 0
CurrentCops = 0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000 * 60 * 5)
        if copsCalled then
            copsCalled = false
        end
    end
end)

RegisterNetEvent('MRFW:Client:OnJobUpdate')
AddEventHandler('MRFW:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    onDuty = true
end)

RegisterNetEvent('police:SetCopCount')
AddEventHandler('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

RegisterNetEvent("MRFW:Client:OnPlayerLoaded")
AddEventHandler("MRFW:Client:OnPlayerLoaded", function()
    PlayerJob = MRFW.Functions.GetPlayerData().job
    MRFW.Functions.TriggerCallback('mr-bankrobbery:server:GetConfig', function(config)
        Config = config
    end)
    onDuty = true
    ResetBankDoors()
end)

Citizen.CreateThread(function()
    Wait(500)
    if MRFW.Functions.GetPlayerData() ~= nil then
        PlayerJob = MRFW.Functions.GetPlayerData().job
        onDuty = true
    end
end)

RegisterNetEvent('MRFW:Client:SetDuty')
AddEventHandler('MRFW:Client:SetDuty', function(duty)
    onDuty = duty
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if inRange then
            if not refreshed then
                ResetBankDoors()
                refreshed = true
            end
        else
            refreshed = false
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local dist

        if MRFW ~= nil then
            inRange = false

            for k, v in pairs(Config.SmallBanks) do
                dist = #(pos - Config.SmallBanks[k]["coords"])
                if dist < 15 then
                    closestBank = k
                    inRange = true
                end
            end

            if not inRange then
                Citizen.Wait(2000)
                closestBank = nil
            end
        end

        Citizen.Wait(5)
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(2000)
    local requiredItems = {
        [1] = {name = MRFW.Shared.Items["electronickit"]["name"], image = MRFW.Shared.Items["electronickit"]["image"]},
        [2] = {name = MRFW.Shared.Items["trojan_usb"]["name"], image = MRFW.Shared.Items["trojan_usb"]["image"]},
    }
    -- local requiredItems2 = {
    --     [1] = {name = MRFW.Shared.Items["thermite2"]["name"], image = MRFW.Shared.Items["thermite2"]["image"]},
    -- }
    while true do
        

        if MRFW ~= nil then
            if closestBank ~= nil then
                local ped = PlayerPedId()
                local pos = GetEntityCoords(ped)
                if not Config.SmallBanks[closestBank]["isOpened"] then
                    local dist = #(pos - Config.SmallBanks[closestBank]["coords"])
                    if dist < 1 then
                        if not requiredItemsShowed then
                            requiredItemsShowed = true
                            TriggerEvent('inventory:client:requiredItems', requiredItems, true)
                        end
                    else
                        if requiredItemsShowed then
                            requiredItemsShowed = false
                            TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                        end
                    end
                end
                if Config.SmallBanks[closestBank]["isOpened"] then
                    for k, v in pairs(Config.SmallBanks[closestBank]["lockers"]) do
                        local lockerDist = #(pos - Config.SmallBanks[closestBank]["lockers"][k]["coords"])
                        if not Config.SmallBanks[closestBank]["lockers"][k]["isBusy"] then
                            if not Config.SmallBanks[closestBank]["lockers"][k]["isOpened"] then
                                if lockerDist < 5 then
                                    DrawMarker(2, Config.SmallBanks[closestBank]["lockers"][k]["coords"].x, Config.SmallBanks[closestBank]["lockers"][k]["coords"].y, Config.SmallBanks[closestBank]["lockers"][k]["coords"].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                                    if lockerDist < 0.5 then
                                        DrawText3Ds(Config.SmallBanks[closestBank]["lockers"][k]["coords"].x, Config.SmallBanks[closestBank]["lockers"][k]["coords"].y, Config.SmallBanks[closestBank]["lockers"][k]["coords"].z + 0.3, '[E] Break open the safe')
                                        if IsControlJustPressed(0, 38) then
                                            MRFW.Functions.TriggerCallback('MRFW:HasItemV2', function(result, info)
                                                if result then
                                                    if CurrentCops >= Config.MinimumFleecaPolice then
                                                        if info.info.uses >= 1 then
                                                            openLocker(closestBank, k)
                                                            local infos = {}
                                                            infos.uses = info.info.uses - 1
                                                            TriggerServerEvent('MRFW:Server:RemoveItem', info.name, info.amount, info.slot)
                                                            TriggerServerEvent("MRFW:Server:AddItem", info.name, info.amount, info.slot, infos)
                                                        else
                                                            MRFW.Functions.Notify('Your Plasma Cutter is broken', "error") 
                                                        end
                                                    else
                                                        MRFW.Functions.Notify('Minimum Of '..Config.MinimumFleecaPolice..' Police Needed', "error") 
                                                    end
                                                else
                                                    MRFW.Functions.Notify('Locker is too strong', 'error', 4000)
                                                end
                                            end, 'plasma')
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            else
                Citizen.Wait(2500)
            end
        end

        Citizen.Wait(5)
    end
end)

function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

RegisterNetEvent('electronickit:UseElectronickit')
AddEventHandler('electronickit:UseElectronickit', function(item)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    if math.random(1, 100) <= 85 and not IsWearingHandshoes() then
        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
    end
    if closestBank ~= nil then
        MRFW.Functions.TriggerCallback('mr-bankrobbery:server:isRobberyActive', function(isBusy)
            if not isBusy then
                if closestBank ~= nil then
                    local dist = #(pos - Config.SmallBanks[closestBank]["coords"])
                    if dist < 1.5 then
                        if CurrentCops >= Config.MinimumFleecaPolice then
                            if not Config.SmallBanks[closestBank]["isOpened"] then 
                                MRFW.Functions.TriggerCallback('MRFW:HasItemV2', function(has, info2)
                                    if has then
                                        if info2.info.uses > 0 then
                                            TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                                            MRFW.Functions.Progressbar("hack_gate", "Connecting the hacking device ..", math.random(5000, 10000), false, true, {
                                                disableMovement = true,
                                                disableCarMovement = true,
                                                disableMouse = false,
                                                disableCombat = true,
                                            }, {
                                                animDict = "anim@gangops@facility@servers@",
                                                anim = "hotwire",
                                                flags = 16,
                                            }, {}, {}, function() -- Done
                                                StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
                                                local infos = {}
                                                infos.uses = item.info.uses - 1
                                                TriggerServerEvent('MRFW:Server:RemoveItem', item.name, item.amount, item.slot)
                                                TriggerServerEvent("MRFW:Server:AddItem", item.name, item.amount, item.slot, infos)
                                                local infos2 = {}
                                                infos2.uses = info2.info.uses - 1
                                                TriggerServerEvent('MRFW:Server:RemoveItem', info2.name, info2.amount, info2.slot)
                                                TriggerServerEvent("MRFW:Server:AddItem", info2.name, info2.amount, info2.slot, infos2)
                                                -- TriggerServerEvent("MRFW:Server:RemoveItem", "electronickit", 1)
                                                -- TriggerEvent('inventory:client:ItemBox', MRFW.Shared.Items["electronickit"], "remove")
                                                -- TriggerServerEvent("MRFW:Server:RemoveItem", "trojan_usb", 1)
                                                -- TriggerEvent('inventory:client:ItemBox', MRFW.Shared.Items["trojan_usb"], "remove")

                                                TriggerEvent("mhacking:show")
                                                TriggerEvent("mhacking:start", math.random(6, 7), math.random(12, 15), OnHackDone)
                                                if not copsCalled then
                                                    local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, pos.x, pos.y, pos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
                                                    local street1 = GetStreetNameFromHashKey(s1)
                                                    local street2 = GetStreetNameFromHashKey(s2)
                                                    local streetLabel = street1
                                                    if street2 ~= nil then 
                                                        streetLabel = streetLabel .. " " .. street2
                                                    end
                                                    if Config.SmallBanks[closestBank]["alarm"] then
                                                        TriggerServerEvent("mr-bankrobbery:server:callCops", "small", closestBank, streetLabel, pos)
                                                        copsCalled = true
                                                    end
                                                end
                                            end, function() -- Cancel
                                                StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
                                                MRFW.Functions.Notify("Canceled..", "error")
                                            end)
                                        else
                                            MRFW.Functions.Notify("Your Trojan Usb is broken", "error")
                                        end
                                    else
                                        MRFW.Functions.Notify("You're missing an item ..", "error")
                                    end
                                end, 'trojan_usb')
                            else
                                MRFW.Functions.Notify("Looks like the bank is already open ..", "error")
                            end
                        else
                            MRFW.Functions.Notify('Minimum Of '..Config.MinimumFleecaPolice..' Police Needed', "error")
                        end
                    end
                end
            else
                MRFW.Functions.Notify("The security lock is active, opening the door is currently not possible.", "error", 5500)
            end
        end)
    end
end)

RegisterNetEvent('mr-bankrobbery:client:setBankState')
AddEventHandler('mr-bankrobbery:client:setBankState', function(bankId, state)
    if bankId == "paleto" then
        Config.BigBanks["paleto"]["isOpened"] = state
        if state then
            OpenPaletoDoor()
        end
    elseif bankId == "pacific" then
        Config.BigBanks["pacific"]["isOpened"] = state
        if state then
            OpenPacificDoor()
        end
    else
        Config.SmallBanks[bankId]["isOpened"] = state
        if state then
            OpenBankDoor(bankId)
        end
    end
end)

RegisterNetEvent('mr-bankrobbery:client:enableAllBankSecurity')
AddEventHandler('mr-bankrobbery:client:enableAllBankSecurity', function()
    for k, v in pairs(Config.SmallBanks) do
        Config.SmallBanks[k]["alarm"] = true
    end
end)

RegisterNetEvent('mr-bankrobbery:client:disableAllBankSecurity')
AddEventHandler('mr-bankrobbery:client:disableAllBankSecurity', function()
    for k, v in pairs(Config.SmallBanks) do
        Config.SmallBanks[k]["alarm"] = false
    end
end)

RegisterNetEvent('mr-bankrobbery:client:BankSecurity')
AddEventHandler('mr-bankrobbery:client:BankSecurity', function(key, status)
    Config.SmallBanks[key]["alarm"] = status
end)

function OpenBankDoor(bankId)
    local object = GetClosestObjectOfType(Config.SmallBanks[bankId]["coords"]["x"], Config.SmallBanks[bankId]["coords"]["y"], Config.SmallBanks[bankId]["coords"]["z"], 5.0, Config.SmallBanks[bankId]["object"], false, false, false)
    local timeOut = 10
    local entHeading = Config.SmallBanks[bankId]["heading"].closed

    if object ~= 0 then
        Citizen.CreateThread(function()
            while true do

                if entHeading ~= Config.SmallBanks[bankId]["heading"].open then
                    SetEntityHeading(object, entHeading - 10)
                    entHeading = entHeading - 0.5
                else
                    break
                end

                Citizen.Wait(10)
            end
        end)
    end
end

function IsWearingHandshoes()
    local armIndex = GetPedDrawableVariation(PlayerPedId(), 3)
    local model = GetEntityModel(PlayerPedId())
    local retval = true
    if model == GetHashKey("mp_m_freemode_01") then
        if MRFW.Shared.MaleNoGloves[armIndex] ~= nil and MRFW.Shared.MaleNoGloves[armIndex] then
            retval = false
        end
    else
        if MRFW.Shared.FemaleNoGloves[armIndex] ~= nil and MRFW.Shared.FemaleNoGloves[armIndex] then
            retval = false
        end
    end
    return retval
end

function ResetBankDoors()
    for k, v in pairs(Config.SmallBanks) do
        local object = GetClosestObjectOfType(Config.SmallBanks[k]["coords"]["x"], Config.SmallBanks[k]["coords"]["y"], Config.SmallBanks[k]["coords"]["z"], 5.0, Config.SmallBanks[k]["object"], false, false, false)
        if not Config.SmallBanks[k]["isOpened"] then
            SetEntityHeading(object, Config.SmallBanks[k]["heading"].closed)
        else
            SetEntityHeading(object, Config.SmallBanks[k]["heading"].open)
        end
    end
    if not Config.BigBanks["paleto"]["isOpened"] then
        local paletoObject = GetClosestObjectOfType(Config.BigBanks["paleto"]["coords"]["x"], Config.BigBanks["paleto"]["coords"]["y"], Config.BigBanks["paleto"]["coords"]["z"], 5.0, Config.BigBanks["paleto"]["object"], false, false, false)
        SetEntityHeading(paletoObject, Config.BigBanks["paleto"]["heading"].closed)
    else
        local paletoObject = GetClosestObjectOfType(Config.BigBanks["paleto"]["coords"]["x"], Config.BigBanks["paleto"]["coords"]["y"], Config.BigBanks["paleto"]["coords"]["z"], 5.0, Config.BigBanks["paleto"]["object"], false, false, false)
        SetEntityHeading(paletoObject, Config.BigBanks["paleto"]["heading"].open)
    end

    if not Config.BigBanks["pacific"]["isOpened"] then
        local pacificObject = GetClosestObjectOfType(Config.BigBanks["pacific"]["coords"][2]["x"], Config.BigBanks["pacific"]["coords"][2]["y"], Config.BigBanks["pacific"]["coords"][2]["z"], 20.0, Config.BigBanks["pacific"]["object"], false, false, false)
        SetEntityHeading(pacificObject, Config.BigBanks["pacific"]["heading"].closed)
    else
        local pacificObject = GetClosestObjectOfType(Config.BigBanks["pacific"]["coords"][2]["x"], Config.BigBanks["pacific"]["coords"][2]["y"], Config.BigBanks["pacific"]["coords"][2]["z"], 20.0, Config.BigBanks["pacific"]["object"], false, false, false)
        SetEntityHeading(pacificObject, Config.BigBanks["pacific"]["heading"].open)
    end

    

end

function openLocker(bankId, lockerId)
    local has_drill = false
    local done_drill = false
    local drill_info = nil
    local pos = GetEntityCoords(PlayerPedId())
    if math.random(1, 100) <= 65 and not IsWearingHandshoes() then
        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
    end
    TriggerServerEvent('mr-bankrobbery:server:setLockerState', bankId, lockerId, 'isBusy', true)
    if bankId == "paleto" then
        MRFW.Functions.TriggerCallback('MRFW:HasItemV2', function(has, info)
            if has then
                -- print(info.info.quality)
                if info.info.uses >= 1 then
                    has_drill = true
                    drill_info = info
                    done_drill = true
                else
                    done_drill = true
                    MRFW.Functions.Notify("Drill not Working ..", "error")
                    TriggerServerEvent('mr-bankrobbery:server:setLockerState', bankId, lockerId, 'isBusy', false)
                end
            else
                done_drill = true
                MRFW.Functions.Notify("Looks like the safe lock is too strong ..", "error")
                TriggerServerEvent('mr-bankrobbery:server:setLockerState', bankId, lockerId, 'isBusy', false)
            end
        end, 'drill')
        while not done_drill do
            Wait(0)
        end
        if has_drill then
            has_drill = false
            done_drill = false
            MRFW.Functions.TriggerCallback('MRFW:HasItemV2', function(has, info)
                if has then
                    if info.info.uses >= 1 then
                        IsDrilling = true
                        MRFW.Functions.Progressbar("open_locker_drill", "Breaking open the safe ..", math.random(18000, 30000), false, true, {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                            TriggerEvent('dpemote:custom:animation', {"drill"})
                        }, {}, {}, {}, function() -- Done
                            TriggerEvent('dpemote:custom:animation', {"c"})
                            TriggerServerEvent('mr-bankrobbery:server:setLockerState', bankId, lockerId, 'isOpened', true)
                            TriggerServerEvent('mr-bankrobbery:server:setLockerState', bankId, lockerId, 'isBusy', false)
                            TriggerServerEvent('mr-bankrobbery:server:recieveItem', 'paleto')
                            local infos = {}
                            infos.uses = drill_info.info.uses - 1
                            TriggerServerEvent('MRFW:Server:RemoveItem', drill_info.name, drill_info.amount, drill_info.slot)
                            TriggerServerEvent("MRFW:Server:AddItem", drill_info.name, drill_info.amount, drill_info.slot, infos)
                            local infos2 = {}
                            infos2.uses = info.info.uses - 1
                            TriggerServerEvent('MRFW:Server:RemoveItem', info.name, info.amount, info.slot)
                            TriggerServerEvent("MRFW:Server:AddItem", info.name, info.amount, info.slot, infos2)
                            -- TriggerServerEvent('Perform:Decay:item', drill_info.name, drill_info.slot, 5)
                            -- TriggerServerEvent('Perform:Decay:item', info.name, info.slot, 20)
                            MRFW.Functions.Notify("Successful!", "success")
                            IsDrilling = false
                        end, function() -- Cancel
                            TriggerEvent('dpemote:custom:animation', {"c"})
                            MRFW.Functions.Notify("Canceled..", "error")
                            IsDrilling = false
                        end)
                        Citizen.CreateThread(function()
                            while IsDrilling do
                                TriggerServerEvent('hud:server:GainStress', math.random(4, 8))
                                Citizen.Wait(10000)
                            end
                        end)
                    else
                        MRFW.Functions.Notify("Drill bit broken", "error")
                        TriggerServerEvent('mr-bankrobbery:server:setLockerState', bankId, lockerId, 'isBusy', false)
                    end
                else
                    MRFW.Functions.Notify("Missing Drill bit", "error")
                    TriggerServerEvent('mr-bankrobbery:server:setLockerState', bankId, lockerId, 'isBusy', false)
                end
            end, 'drillbit')
        end
    elseif bankId == "pacific" then
        MRFW.Functions.TriggerCallback('MRFW:HasItemV2', function(has, info)
            if has then
                if info.info.uses >= 1 then
                    has_drill = true
                    drill_info = info
                    done_drill = true
                else
                    done_drill = true
                    MRFW.Functions.Notify("Drill not Working ..", "error")
                    TriggerServerEvent('mr-bankrobbery:server:setLockerState', bankId, lockerId, 'isBusy', false)
                end
            else
                done_drill = true
                MRFW.Functions.Notify("Looks like the safe lock is too strong ..", "error")
                TriggerServerEvent('mr-bankrobbery:server:setLockerState', bankId, lockerId, 'isBusy', false)
            end
        end, 'drill')
        while not done_drill do
            Wait(0)
        end
        if has_drill then
            has_drill = false
            done_drill = false
            MRFW.Functions.TriggerCallback('MRFW:HasItemV2', function(has, info)
                if has then
                    if info.info.uses >= 1 then
                        IsDrilling = true
                        TriggerEvent('dpemote:custom:animation', {"drill"})
                        MRFW.Functions.Progressbar("open_locker_drill", "Breaking open the safe ..", math.random(18000, 30000), false, true, {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        }, {}, {}, {}, function() -- Done
                            TriggerEvent('dpemote:custom:animation', {"c"})
                            
                            TriggerServerEvent('mr-bankrobbery:server:setLockerState', bankId, lockerId, 'isOpened', true)
                            TriggerServerEvent('mr-bankrobbery:server:setLockerState', bankId, lockerId, 'isBusy', false)
                            TriggerServerEvent('mr-bankrobbery:server:recieveItem', 'pacific')
                            local infos = {}
                            infos.uses = drill_info.info.uses - 1
                            TriggerServerEvent('MRFW:Server:RemoveItem', drill_info.name, drill_info.amount, drill_info.slot)
                            TriggerServerEvent("MRFW:Server:AddItem", drill_info.name, drill_info.amount, drill_info.slot, infos)
                            local infos2 = {}
                            infos2.uses = info.info.uses - 1
                            TriggerServerEvent('MRFW:Server:RemoveItem', info.name, info.amount, info.slot)
                            TriggerServerEvent("MRFW:Server:AddItem", info.name, info.amount, info.slot, infos2)
                            -- TriggerServerEvent('Perform:Decay:item', drill_info.name, drill_info.slot, 5)
                            -- TriggerServerEvent('Perform:Decay:item', info.name, info.slot, 20)
                            MRFW.Functions.Notify("Successful!", "success")
                            IsDrilling = false
                        end, function() -- Cancel
                            TriggerEvent('dpemote:custom:animation', {"c"})
                            MRFW.Functions.Notify("Canceled..", "error")
                            IsDrilling = false
                        end)
                        Citizen.CreateThread(function()
                            while IsDrilling do
                                TriggerServerEvent('hud:server:GainStress', math.random(4, 8))
                                Citizen.Wait(10000)
                            end
                        end)
                    else
                        MRFW.Functions.Notify("Drill bit broken", "error")
                        TriggerServerEvent('mr-bankrobbery:server:setLockerState', bankId, lockerId, 'isBusy', false)
                    end
                else
                    MRFW.Functions.Notify("Missing Drill bit", "error")
                    TriggerServerEvent('mr-bankrobbery:server:setLockerState', bankId, lockerId, 'isBusy', false)
                end
            end, 'drillbit')
        end
    else
        IsDrilling = true
        MRFW.Functions.Progressbar("open_locker", "Breaking open the safe ..", math.random(27000, 37000), false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
            TriggerEvent('dpemote:custom:animation', {"weld"})
        }, {}, {}, {}, function() -- Done
            TriggerEvent('dpemote:custom:animation', {"c"})
            TriggerServerEvent('mr-bankrobbery:server:setLockerState', bankId, lockerId, 'isOpened', true)
            TriggerServerEvent('mr-bankrobbery:server:setLockerState', bankId, lockerId, 'isBusy', false)
            TriggerServerEvent('mr-bankrobbery:server:recieveItem', 'small')
            MRFW.Functions.Notify("Successful!", "success")
            IsDrilling = false
        end, function() -- Cancel
            TriggerEvent('dpemote:custom:animation', {"c"})
            TriggerServerEvent('mr-bankrobbery:server:setLockerState', bankId, lockerId, 'isBusy', false)
            MRFW.Functions.Notify("Canceled..", "error")
            IsDrilling = false
        end)
        Citizen.CreateThread(function()
            while IsDrilling do
                TriggerServerEvent('hud:server:GainStress', math.random(4, 8))
                Citizen.Wait(10000)
            end
        end)
    end
end

RegisterNetEvent('mr-bankrobbery:client:setLockerState')
AddEventHandler('mr-bankrobbery:client:setLockerState', function(bankId, lockerId, state, bool)
    if bankId == "paleto" then
        Config.BigBanks["paleto"]["lockers"][lockerId][state] = bool
    elseif bankId == "pacific" then
        Config.BigBanks["pacific"]["lockers"][lockerId][state] = bool
    else
        Config.SmallBanks[bankId]["lockers"][lockerId][state] = bool
    end
end)

RegisterNetEvent('mr-bankrobbery:client:ResetFleecaLockers')
AddEventHandler('mr-bankrobbery:client:ResetFleecaLockers', function(BankId)
    Config.SmallBanks[BankId]["isOpened"] = false
    for k,_ in pairs(Config.SmallBanks[BankId]["lockers"]) do
        Config.SmallBanks[BankId]["lockers"][k]["isOpened"] = false
        Config.SmallBanks[BankId]["lockers"][k]["isBusy"] = false
    end
end)

RegisterNetEvent('mr-bankrobbery:client:robberyCall')
AddEventHandler('mr-bankrobbery:client:robberyCall', function(type, key, streetLabel, coords)
    if PlayerJob.name == "police" and onDuty then 
        local cameraId = 4
        local bank = "Fleeca"
        if type == "small" then
            cameraId = Config.SmallBanks[key]["camId"]
            bank = "Fleeca"
            PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
            -- TriggerEvent('mr-policealerts:client:AddPoliceAlert', {
            --     timeOut = 10000,
            --     alertTitle = "Fleeca bank robbery attempt",
            --     coords = {
            --         x = coords.x,
            --         y = coords.y,
            --         z = coords.z,
            --     },
            --     details = {
            --         [1] = {
            --             icon = '<i class="fas fa-university"></i>',
            --             detail = bank,
            --         },
            --         [2] = {
            --             icon = '<i class="fas fa-video"></i>',
            --             detail = cameraId,
            --         },
            --         [3] = {
            --             icon = '<i class="fas fa-globe-europe"></i>',
            --             detail = streetLabel,
            --         },
            --     },
            --     callSign = MRFW.Functions.GetPlayerData().metadata["callsign"],
            -- })
            exports['mr-dispatch']:FleecaBankRobbery(cameraId, coords)
        elseif type == "paleto" then
            cameraId = Config.BigBanks["paleto"]["camId"]
            bank = "Blaine County Savings"
            PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
            Citizen.Wait(100)
            PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
            Citizen.Wait(100)
            PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
            Citizen.Wait(100)
            PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
            -- TriggerEvent('mr-policealerts:client:AddPoliceAlert', {
            --     timeOut = 10000,
            --     alertTitle = "Blain County Savings bank robbery attempt",
            --     coords = {
            --         x = coords.x,
            --         y = coords.y,
            --         z = coords.z,
            --     },
            --     details = {
            --         [1] = {
            --             icon = '<i class="fas fa-university"></i>',
            --             detail = bank,
            --         },
            --         [2] = {
            --             icon = '<i class="fas fa-video"></i>',
            --             detail = cameraId,
            --         },
            --     },
            --     callSign = MRFW.Functions.GetPlayerData().metadata["callsign"],
            -- })
            exports['mr-dispatch']:PaletoBankRobbery(cameraId, coords)
        elseif type == "pacific" then
            bank = "Pacific Standard Bank"
            PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
            Citizen.Wait(100)
            PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
            Citizen.Wait(100)
            PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
            Citizen.Wait(100)
            PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
            -- TriggerEvent('mr-policealerts:client:AddPoliceAlert', {
            --     timeOut = 10000,
            --     alertTitle = "Pacific Standard Bank robbery attempt",
            --     coords = {
            --         x = coords.x,
            --         y = coords.y,
            --         z = coords.z,
            --     },
            --     details = {
            --         [1] = {
            --             icon = '<i class="fas fa-university"></i>',
            --             detail = bank,
            --         },
            --         [2] = {
            --             icon = '<i class="fas fa-video"></i>',
            --             detail = "1 | 2 | 3",
            --         },
            --         [3] = {
            --             icon = '<i class="fas fa-globe-europe"></i>',
            --             detail = "Alta St",
            --         },
            --     },
            --     callSign = MRFW.Functions.GetPlayerData().metadata["callsign"],
            -- })
            exports['mr-dispatch']:PacificBankRobbery(cameraId, coords)
        end
        -- local transG = 250
        -- local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        -- SetBlipSprite(blip, 487)
        -- SetBlipColour(blip, 4)
        -- SetBlipDisplay(blip, 4)
        -- SetBlipAlpha(blip, transG)
        -- SetBlipScale(blip, 1.2)
        -- SetBlipFlashes(blip, true)
        -- BeginTextCommandSetBlipName('STRING')
        -- AddTextComponentString("10-90: Bank Robbery")
        -- EndTextCommandSetBlipName(blip)
        -- while transG ~= 0 do
        --     Wait(180 * 4)
        --     transG = transG - 1
        --     SetBlipAlpha(blip, transG)
        --     if transG == 0 then
        --         SetBlipSprite(blip, 2)
        --         RemoveBlip(blip)
        --         return
        --     end
        -- end
    end
end)

function OnHackDone(success, timeremaining)
    if success then
        TriggerEvent('mhacking:hide')
        TriggerServerEvent('mr-bankrobbery:server:setBankState', closestBank, true)
    else
		TriggerEvent('mhacking:hide')
	end
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        ResetBankDoors()
    end
end)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 

function searchPockets()
    if ( DoesEntityExist( PlayerPedId() ) and not IsEntityDead( PlayerPedId() ) ) then 
        loadAnimDict( "random@mugging4" )
        TaskPlayAnim( PlayerPedId(), "random@mugging4", "agitated_loop_a", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
    end
end

function giveAnim()
    if ( DoesEntityExist( PlayerPedId() ) and not IsEntityDead( PlayerPedId() ) ) then 
        loadAnimDict( "mp_safehouselost@" )
        if ( IsEntityPlayingAnim( PlayerPedId(), "mp_safehouselost@", "package_dropoff", 3 ) ) then 
            TaskPlayAnim( PlayerPedId(), "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
        else
            TaskPlayAnim( PlayerPedId(), "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
        end     
    end
end
