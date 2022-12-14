local MRFW = exports['mrfw']:GetCoreObject()
local uiOpen = false
local currentRegister   = 0
local currentSafe = 0
local copsCalled = false
local CurrentCops = 0
local PlayerJob = {}
local onDuty = false
local usingAdvanced = false

CreateThread(function()
    Wait(1000)
    if MRFW.Functions.GetPlayerData().job ~= nil and next(MRFW.Functions.GetPlayerData().job) then
        PlayerJob = MRFW.Functions.GetPlayerData().job
    end
end)

CreateThread(function()
    while true do
        Wait(1000 * 60 * 5)
        if copsCalled then
            copsCalled = false
        end
    end
end)

CreateThread(function()
    Wait(1000)
    setupRegister()
    setupSafes()
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local inRange = false
        for k, v in pairs(Config.Registers) do
            local dist = #(pos - Config.Registers[k][1].xyz)
            if dist <= 1 and Config.Registers[k].robbed then
                inRange = true
                DrawText3Ds(Config.Registers[k][1].xyz, 'The Cash Register Is Empty')
            end
        end
        if not inRange then
            Wait(2000)
        end
        Wait(3)
    end
end)

CreateThread(function()
    while true do
        Wait(1)
        local inRange = false
        if MRFW ~= nil then
            local pos = GetEntityCoords(PlayerPedId())
            for safe,_ in pairs(Config.Safes) do
                local dist = #(pos - Config.Safes[safe][1].xyz)
                if dist < 3 then
                    inRange = true
                    if dist < 1.0 then
                        if not Config.Safes[safe].robbed then
                            DrawText3Ds(Config.Safes[safe][1].xyz, '~g~E~w~ - Try Combination')
                            if IsControlJustPressed(0, 38) then
                                if CurrentCops >= Config.MinimumStoreRobberyPolice then
                                    currentSafe = safe
                                    if math.random(1, 100) <= 65 and not IsWearingHandshoes() then
                                        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
                                    end
                                    if math.random(100) <= 50 then
                                        TriggerServerEvent('hud:server:GainStress', math.random(1, 3))
                                    end
                                    if Config.Safes[safe].type == "keypad" then
                                        SendNUIMessage({
                                            action = "openKeypad",
                                        })
                                        SetNuiFocus(true, true)
                                    else
                                        MRFW.Functions.TriggerCallback('mr-storerobbery:server:getPadlockCombination', function(combination)
                                            TriggerEvent("SafeCracker:StartMinigame", combination)
                                        end, safe)
                                    end

                                    if not copsCalled then
                                        local pos = GetEntityCoords(PlayerPedId())
					local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
                                        local street1 = GetStreetNameFromHashKey(s1)
                                        local street2 = GetStreetNameFromHashKey(s2)
                                        local streetLabel = street1
                                        if street2 ~= nil then
                                            streetLabel = streetLabel .. " " .. street2
                                        end
                                        TriggerServerEvent("mr-storerobbery:server:callCops", "safe", currentSafe, streetLabel, pos)
                                        copsCalled = true
                                    end
                                else
                                    MRFW.Functions.Notify("Not Enough Police (".. Config.MinimumStoreRobberyPolice .." Required)", "error")
                                end
                            end
                        else
                            DrawText3Ds(Config.Safes[safe][1].xyz, 'Safe Opened')
                        end
                    end
                end
            end
        end

        if not inRange then
            Wait(2000)
        end
    end
end)

RegisterNetEvent('MRFW:Client:OnPlayerLoaded', function()
    PlayerJob = MRFW.Functions.GetPlayerData().job
    onDuty = true
end)

RegisterNetEvent('MRFW:Client:SetDuty', function(duty)
    onDuty = duty
end)

RegisterNetEvent('MRFW:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    onDuty = true
end)

RegisterNetEvent('police:SetCopCount', function(amount)
    CurrentCops = amount
end)
local itemquality = nil
local itemtype = nil

RegisterNetEvent('lockpicks:UseLockpick', function(isAdvanced, quality)
    usingAdvanced = isAdvanced
    for k, v in pairs(Config.Registers) do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local dist = #(pos - Config.Registers[k][1].xyz)
        if dist <= 1 and not Config.Registers[k].robbed then
            if CurrentCops >= Config.MinimumStoreRobberyPolice then
                -- print(usingAdvanced)
                if usingAdvanced then
                    if itemquality == nil then
                        itemquality = quality
                    end
                    if itemtype == nil then
                        itemtype = usingAdvanced
                    end
                    lockpick(true)
                    currentRegister = k
                    if not IsWearingHandshoes() then
                        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
                    end
                    if not copsCalled then
			            local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
                        local street1 = GetStreetNameFromHashKey(s1)
                        local street2 = GetStreetNameFromHashKey(s2)
                        local streetLabel = street1
                        if street2 ~= nil then
                            streetLabel = streetLabel .. " " .. street2
                        end
                        TriggerServerEvent("mr-storerobbery:server:callCops", "cashier", currentRegister, streetLabel, pos)
                        copsCalled = true
                    end
                else
                    if itemquality == nil then
                        itemquality = quality
                    end
                    if itemtype == nil then
                        itemtype = usingAdvanced
                    end
                    lockpick(true)
                    currentRegister = k
                    if not IsWearingHandshoes() then
                        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
                    end
                    if not copsCalled then
			            local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
                        local street1 = GetStreetNameFromHashKey(s1)
                        local street2 = GetStreetNameFromHashKey(s2)
                        local streetLabel = street1
                        if street2 ~= nil then
                            streetLabel = streetLabel .. " " .. street2
                        end
                        TriggerServerEvent("mr-storerobbery:server:callCops", "cashier", currentRegister, streetLabel, pos)
                        copsCalled = true
                    end

                end

            else
                MRFW.Functions.Notify("Not Enough Police (2 Required)", "error")
            end
        end
    end
end)

function IsWearingHandshoes()
    local armIndex = GetPedDrawableVariation(PlayerPedId(), 3)
    local model = GetEntityModel(PlayerPedId())
    local retval = true

    if model == `mp_m_freemode_01` then
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

function setupRegister()
    MRFW.Functions.TriggerCallback('mr-storerobbery:server:getRegisterStatus', function(Registers)
        for k, v in pairs(Registers) do
            Config.Registers[k].robbed = Registers[k].robbed
        end
    end)
end

function setupSafes()
    MRFW.Functions.TriggerCallback('mr-storerobbery:server:getSafeStatus', function(Safes)
        for k, v in pairs(Safes) do
            Config.Safes[k].robbed = Safes[k].robbed
        end
    end)
end

DrawText3Ds = function(coords, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(coords, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function lockpick(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        action = "ui",
        toggle = bool,
    })
    SetCursorLocation(0.5, 0.2)
    uiOpen = bool
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(100)
    end
end

function takeAnim()
    local ped = PlayerPedId()
    while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do
        RequestAnimDict("amb@prop_human_bum_bin@idle_b")
        Wait(100)
    end
    TaskPlayAnim(ped, "amb@prop_human_bum_bin@idle_b", "idle_d", 8.0, 8.0, -1, 50, 0, false, false, false)
    Wait(2500)
    TaskPlayAnim(ped, "amb@prop_human_bum_bin@idle_b", "exit", 8.0, 8.0, -1, 50, 0, false, false, false)
end

local openingDoor = false

RegisterNUICallback('success', function()
    if currentRegister ~= 0 then
        lockpick(false)
        TriggerServerEvent('mr-storerobbery:server:setRegisterStatus', currentRegister)
        local lockpickTime = 25000
        LockpickDoorAnim(lockpickTime)
        MRFW.Functions.Progressbar("search_register", "Emptying The Register..", lockpickTime, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "veh@break_in@0h@p_m_one@",
            anim = "low_force_entry_ds",
            flags = 16,
        }, {}, {}, function() -- Done
            if itemtype then
                local infos = {}
            infos.uses = itemquality.info.uses - 1
            TriggerServerEvent('MRFW:Server:RemoveItem', itemquality.name, itemquality.amount, itemquality.slot)
            TriggerServerEvent("MRFW:Server:AddItem", itemquality.name, itemquality.amount, itemquality.slot, infos)
                -- TriggerServerEvent('Perform:Decay:item', itemquality.name, itemquality.slot, 2)
            else
                local infos = {}
            infos.uses = itemquality.info.uses - 1
            TriggerServerEvent('MRFW:Server:RemoveItem', itemquality.name, itemquality.amount, itemquality.slot)
            TriggerServerEvent("MRFW:Server:AddItem", itemquality.name, itemquality.amount, itemquality.slot, infos)
                -- TriggerServerEvent('Perform:Decay:item', itemquality.name, itemquality.slot, 5)
            end
            itemtype = nil
            itemquality = nil
            openingDoor = false
            ClearPedTasks(PlayerPedId())
            TriggerServerEvent('mr-storerobbery:server:takeMoney', currentRegister, true)
            currentRegister = 0
        end, function() -- Cancel
            itemtype = nil
            itemquality = nil
            openingDoor = false
            ClearPedTasks(PlayerPedId())
            MRFW.Functions.Notify("Process canceled..", "error")
            currentRegister = 0
        end)
        CreateThread(function()
            while openingDoor do
                TriggerServerEvent('hud:server:GainStress', math.random(1, 3))
                Wait(10000)
            end
        end)
    else
        SendNUIMessage({
            action = "kekw",
        })
    end
end)

function LockpickDoorAnim(time)
    time = time / 1000
    loadAnimDict("veh@break_in@0h@p_m_one@")
    TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds" ,3.0, 3.0, -1, 16, 0, false, false, false)
    openingDoor = true
    CreateThread(function()
        while openingDoor do
            TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
            Wait(2000)
            time = time - 2
            TriggerServerEvent('mr-storerobbery:server:takeMoney', currentRegister, false)
            if time <= 0 then
                openingDoor = false
                StopAnimTask(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0)
            end
        end
    end)
end

RegisterNUICallback('callcops', function()
    TriggerEvent("police:SetCopAlert")
end)

RegisterNetEvent('SafeCracker:EndMinigame', function(won)
    if currentSafe ~= 0 then
        if won then
            if currentSafe ~= 0 then
                if not Config.Safes[currentSafe].robbed then
                    SetNuiFocus(false, false)
                    TriggerServerEvent("mr-storerobbery:server:SafeReward", currentSafe)
                    TriggerServerEvent("mr-storerobbery:server:setSafeStatus", currentSafe)
                    currentSafe = 0
                    takeAnim()
                end
            else
                SendNUIMessage({
                    action = "kekw",
                })
            end
        end
    end
    copsCalled = false
end)

RegisterNUICallback('PadLockSuccess', function()
    if currentSafe ~= 0 then
        if not Config.Safes[currentSafe].robbed then
            SendNUIMessage({
                action = "kekw",
            })
        end
    else
        SendNUIMessage({
            action = "kekw",
        })
    end
end)

RegisterNUICallback('PadLockClose', function()
    SetNuiFocus(false, false)
    copsCalled = false
end)

RegisterNUICallback("CombinationFail", function(data, cb)
    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
end)

RegisterNUICallback('fail', function()
    if itemtype then
        local infos = {}
            infos.uses = itemquality.info.uses - 1
            TriggerServerEvent('MRFW:Server:RemoveItem', itemquality.name, itemquality.amount, itemquality.slot)
            TriggerServerEvent("MRFW:Server:AddItem", itemquality.name, itemquality.amount, itemquality.slot, infos)
        -- TriggerServerEvent('Perform:Decay:item', itemquality.name, itemquality.slot, math.random(2, 5))
    else
        local infos = {}
            infos.uses = itemquality.info.uses - 1
            TriggerServerEvent('MRFW:Server:RemoveItem', itemquality.name, itemquality.amount, itemquality.slot)
            TriggerServerEvent("MRFW:Server:AddItem", itemquality.name, itemquality.amount, itemquality.slot, infos)
        -- TriggerServerEvent('Perform:Decay:item', itemquality.name, itemquality.slot, math.random(5, 10))
    end
    itemtype = nil
    itemquality = nil
    -- if usingAdvanced then
    --     if math.random(1, 100) < 20 then
    --         -- TriggerServerEvent("MRFW:Server:RemoveItem", "advancedlockpick", 1)
    --         -- TriggerEvent('inventory:client:ItemBox', MRFW.Shared.Items["advancedlockpick"], "remove")
    --     end
    -- else
    --     if math.random(1, 100) < 40 then
    --         -- TriggerServerEvent("MRFW:Server:RemoveItem", "lockpick", 1)
    --         -- TriggerEvent('inventory:client:ItemBox', MRFW.Shared.Items["lockpick"], "remove")
    --     end
    -- end
    -- if (IsWearingHandshoes() and math.random(1, 100) <= 25) then
    --     local pos = GetEntityCoords(PlayerPedId())
    --     TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
    --     MRFW.Functions.Notify("You Broke The Lock Pick")
    -- end
    lockpick(false)
end)

RegisterNUICallback('exit', function()
    lockpick(false)
end)

RegisterNUICallback('TryCombination', function(data, cb)
    MRFW.Functions.TriggerCallback('mr-storerobbery:server:isCombinationRight', function(combination)
        if tonumber(data.combination) ~= nil then
            if tonumber(data.combination) == combination then
                TriggerServerEvent("mr-storerobbery:server:SafeReward", currentSafe)
                TriggerServerEvent("mr-storerobbery:server:setSafeStatus", currentSafe)
                SetNuiFocus(false, false)
                SendNUIMessage({
                    action = "closeKeypad",
                    error = false,
                })
                currentSafe = 0
                takeAnim()
            else
                TriggerEvent("police:SetCopAlert")
                SetNuiFocus(false, false)
                SendNUIMessage({
                    action = "closeKeypad",
                    error = true,
                })
                currentSafe = 0
            end
        end
    end, currentSafe)
end)

RegisterNetEvent('mr-storerobbery:client:setRegisterStatus', function(batch, val)
    -- Has to be a better way maybe like adding a unique id to identify the register
    if(type(batch) ~= "table") then
        Config.Registers[batch] = val
    else
        for k, v in pairs(batch) do
            Config.Registers[k] = batch[k]
        end
    end
end)

RegisterNetEvent('mr-storerobbery:client:setSafeStatus', function(safe, bool)
    Config.Safes[safe].robbed = bool
end)

RegisterNetEvent('mr-storerobbery:client:robberyCall', function(type, key, streetLabel, coords)
    -- if PlayerJob.name == "police" and onDuty then
        local cameraId = 4
        if type == "safe" then
            cameraId = Config.Safes[key].camId
        else
            cameraId = Config.Registers[key].camId
        end
        exports['mr-dispatch']:StoreRobbery(cameraId, coords)
    -- end
end)
