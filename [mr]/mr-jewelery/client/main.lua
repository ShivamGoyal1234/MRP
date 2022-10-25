local robberyAlert = false
local firstAlarm = false
local OnHackDonet = false
local hackX = -631.45  --starting
local hackY = -230.27
local hackZ = 38.06
local inuse = false
local unlocked = false
local doingLockHack = false
local doorUnlocked = false
local PlayerData = {}
local coordsHack = nil
RegisterNetEvent('MRFW:Client:OnPlayerLoaded', function()
    MRFW.Functions.TriggerCallback('mr-jewellery:server:getactiverob', function(data)
        inuse = data
        OnHackDonet = data
    end)
    MRFW.Functions.TriggerCallback('mr-jewellery:server:getactiverob2', function(data, a)
        unlocked = data
        coordsHack = a
        if unlocked then
            doorUnlocked = true
            TriggerServerEvent('nui_doorlock:server:updateState', 'hiest_door_9', false, nil, false, true, false)
        end
    end)
end)

-- Citizen.CreateThread(function()
--     while true do
-- 		Citizen.Wait(45 * 60000)
-- 		TriggerServerEvent('mr-jewellery:server:updateTable', false)
-- 	end
-- end)

Citizen.CreateThread(function()
    while true do
        sleep = 2500
        if unlocked then
            local plyCoords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, hackX, hackY, hackZ)
            
            if dist <= 2.5 then
                sleep = 5
            DrawText3Ds(hackX, hackY, hackZ, "~g~[E]~w~ To Hack Glasses")
            end
    --
            if dist <= 0.5 then
                if IsControlJustPressed(0, 38) then
                    if unlocked then
                        if not inuse then
                            MRFW.Functions.TriggerCallback('mr-jewellery:server:getCops', function(cops)
                                if cops >= Config.RequiredCops then
                                    TriggerEvent("mhacking:show")
                                    TriggerEvent("mhacking:start", math.random(5, 9), math.random(10, 18), OnHackDone) 
                                else
                                    MRFW.Functions.Notify('Not enough police...', 'error')
                                end
                            end)
                        else
                            MRFW.Functions.Notify('Already Triggerd...', 'error')
                        end
                    else
                        MRFW.Functions.Notify('Cut The Hotwires First', 'error')
                    end
                end			
            end
        end
        Wait(sleep)
	end
end)

local showText = false
Citizen.CreateThread(function()
    while true do
        sleep = 2500
        if coordsHack ~= nil then
            sleep = 1000
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local dist = #(pos - coordsHack)
            if dist <= 7 then
                sleep = 5
                if dist <= 1 then
                    if not showText then
                        exports['mr-text']:DrawText(
                            '[G]',
                            0, 94, 255,0.7,
                            1,
                            50
                        )
                        showText = true
                    end
                    if IsControlJustPressed(0, 47) then
                        if not unlocked then
                            doingLockHack = true
                            TriggerServerEvent("mr-jewellery:server:updateTable2", true)
                            MRFW.Functions.TriggerCallback('mr-jewellery:server:getCops', function(cops)
                                if cops >= Config.RequiredCops then
                                    TriggerEvent('ultra-voltlab', math.random(10,60), function(result,reason)
                                        if result == 0 then
                                            doingLockHack = true
                                            TriggerServerEvent("mr-jewellery:server:updateTable2", false)
                                            MRFW.Functions.Notify('Failed because of wrong placement of wires', 'error', 3000)
                                            unlocked = false
                                        elseif result == 1 then
                                            doingLockHack = false
                                            TriggerServerEvent("mr-jewellery:server:updateTable2", true)
                                            TriggerServerEvent('mr-jewellery:server:setDoorTimeout')
                                            MRFW.Functions.Notify('Doors are Successfully unlocked', 'error', 3000)
                                            unlocked = true
                                        elseif result == 2 then
                                            doingLockHack = true
                                            TriggerServerEvent("mr-jewellery:server:updateTable2", false)
                                            MRFW.Functions.Notify('Failed because of timeout', 'error', 3000)
                                            unlocked = false
                                        elseif result == -1 then
                                            doingLockHack = true
                                            TriggerServerEvent("mr-jewellery:server:updateTable2", false)
                                            MRFW.Functions.Notify('Failed Because of an error contact Developer ASAP', 'error', 3000)
                                            unlocked = false
                                        end
                                    end)
                                else
                                    MRFW.Functions.Notify('Not enough police...', 'error')
                                end
                            end)
                        else
                            MRFW.Functions.Notify('Doors are already unlocked', 'error', 3000)
                        end
                    end
                else
                    if showText then
                        exports['mr-text']:HideText(1)
                        showText = false
                    end
                end
            end
        end
        Citizen.Wait(sleep)
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

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        inRange = false

        if MRFW ~= nil then
            if LocalPlayer.state['isLoggedIn'] and OnHackDonet then
                PlayerData = MRFW.Functions.GetPlayerData()
                for case,_ in pairs(Config.Locations) do
                    -- if PlayerData.job.name ~= "police" then
                        local dist = #(pos - vector3(Config.Locations[case]["coords"]["x"], Config.Locations[case]["coords"]["y"], Config.Locations[case]["coords"]["z"]))
                        local storeDist = #(pos - vector3(Config.JewelleryLocation["coords"]["x"], Config.JewelleryLocation["coords"]["y"], Config.JewelleryLocation["coords"]["z"]))
                        if dist < 30 then
                            inRange = true

                            if dist < 0.6 then
                                if not Config.Locations[case]["isBusy"] and not Config.Locations[case]["isOpened"] then
                                    if OnHackDonet then
                                        DrawText3Ds(Config.Locations[case]["coords"]["x"], Config.Locations[case]["coords"]["y"], Config.Locations[case]["coords"]["z"], '[E] Storing the display case')
                                        if IsControlJustPressed(0, 38) then
                                            MRFW.Functions.TriggerCallback('mr-jewellery:server:getCops', function(cops)
                                                if cops >= Config.RequiredCops then
                                                    if validWeapon() then
                                                        smashVitrine(case)
                                                    else
                                                        MRFW.Functions.Notify('Your weapon is not strong enough..', 'error')
                                                    end
                                                else
                                                    MRFW.Functions.Notify('Not Enough Police ('.. Config.RequiredCops ..') Required', 'error')
                                                end                
                                            end)
                                        end
                                    end
                                end
                            end

                            if storeDist < 2 then
                                if not firstAlarm then
                                    if validWeapon() then
                                        TriggerServerEvent('mr-jewellery:server:PoliceAlertMessage', "Suspicious situation", pos, false)
                                        firstAlarm = true
                                    end
                                end
                            end
                        end
                    -- end
                end
            end
        end

        if not inRange then
            Citizen.Wait(2000)
        end

        Citizen.Wait(5)
    end
end)

function hacks(bool)
    if bool then
        local ped = PlayerPedId()
        local plyCoords = GetOffsetFromEntityInWorldCoords(ped, 0, 0.6, 0)
        TriggerEvent('mhacking:hide')
        OnHackDonet = true
        TriggerServerEvent('mr-jewellery:server:updateTable', true)
        TriggerServerEvent('mr-jewellery:server:PoliceAlertMessage', "Jewellery robbery", plyCoords, false)
    else
        local ped = PlayerPedId()
        local plyCoords = GetOffsetFromEntityInWorldCoords(ped, 0, 0.6, 0)
        TriggerEvent('mhacking:hide')
	    TriggerServerEvent('mr-jewellery:server:updateTable', false)
        TriggerServerEvent('mr-jewellery:server:PoliceAlertMessage', "Jewellery robbery", plyCoords, false)
    end
end

function OnHackDone(success, timeremaining)
    if success then
        hacks(true)
    else
        hacks(false)
	end
end

function loadParticle()
	if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
    RequestNamedPtfxAsset("scr_jewelheist")
    end
    while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
    Citizen.Wait(0)
    end
    SetPtfxAssetNextCall("scr_jewelheist")
end

function loadAnimDict(dict)  
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(3)
    end
end

function validWeapon()
    local ped = PlayerPedId()
    local pedWeapon = GetSelectedPedWeapon(ped)

    for k, v in pairs(Config.WhitelistedWeapons) do
        if pedWeapon == k then
            return true
        end
    end
    return false
end

local smashing = false

function smashVitrine(k)
    local animDict = "missheist_jewel"
    local animName = "smash_case"
    local ped = PlayerPedId()
    local plyCoords = GetOffsetFromEntityInWorldCoords(ped, 0, 0.6, 0)
    local pedWeapon = GetSelectedPedWeapon(ped)

    if math.random(1, 100) <= 80 and not IsWearingHandshoes() then
        TriggerServerEvent("evidence:server:CreateFingerDrop", plyCoords)
    elseif math.random(1, 100) <= 5 and IsWearingHandshoes() then
        TriggerServerEvent("evidence:server:CreateFingerDrop", plyCoords)
        MRFW.Functions.Notify("You've left a fingerprint on the glass", "error")
    end

    smashing = true

    MRFW.Functions.Progressbar("smash_vitrine", "Stocking a display", Config.WhitelistedWeapons[pedWeapon]["timeOut"], false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent('mr-jewellery:server:setVitrineState', "isOpened", true, k)
        TriggerServerEvent('mr-jewellery:server:setVitrineState', "isBusy", false, k)
        TriggerServerEvent('mr-jewellery:server:setTimeout')
        TriggerServerEvent('mr-jewellery:server:vitrineReward')
        smashing = false
        TaskPlayAnim(ped, animDict, "exit", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
    end, function() -- Cancel
        TriggerServerEvent('mr-jewellery:server:setVitrineState', "isBusy", false, k)
        smashing = false
        TaskPlayAnim(ped, animDict, "exit", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
    end)
    TriggerServerEvent('mr-jewellery:server:setVitrineState', "isBusy", true, k)

    Citizen.CreateThread(function()
        while smashing do
            loadAnimDict(animDict)
            TaskPlayAnim(ped, animDict, animName, 3.0, 3.0, -1, 2, 0, 0, 0, 0 )
            Citizen.Wait(500)
            TriggerServerEvent("InteractSound_SV:PlayOnSource", "breaking_vitrine_glass", 0.25)
            loadParticle()
            StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", plyCoords.x, plyCoords.y, plyCoords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
            Citizen.Wait(2500)
        end
    end)
end

RegisterNetEvent('mr-jewellery:client:setVitrineState')
AddEventHandler('mr-jewellery:client:setVitrineState', function(stateType, state, k)
    Config.Locations[k][stateType] = state
end)

RegisterNetEvent('mr-jewellery:client:setAlertState')
AddEventHandler('mr-jewellery:client:setAlertState', function(bool)
    robberyAlert = bool
end)

RegisterNetEvent('mr-jewellery:client:PoliceAlertMessage')
AddEventHandler('mr-jewellery:client:PoliceAlertMessage', function(title, coords, blip)
    if blip then
        -- TriggerEvent('mr-policealerts:client:AddPoliceAlert', {
        --     timeOut = 5000,
        --     alertTitle = title,
        --     details = {
        --         [1] = {
        --             icon = '<i class="fas fa-gem"></i>',
        --             detail = "Vangelico Jeweler",
        --         },
        --         [2] = {
        --             icon = '<i class="fas fa-video"></i>',
        --             detail = "31 | 32 | 33 | 34",
        --         },
        --         [3] = {
        --             icon = '<i class="fas fa-globe-europe"></i>',
        --             detail = "Rockford Dr",
        --         },
        --     },
        --     callSign = MRFW.Functions.GetPlayerData().metadata["callsign"],
        -- })
        -- PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
        -- Citizen.Wait(100)
        -- PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
        -- Citizen.Wait(100)
        -- PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
        -- local transG = 100
        -- local blip = AddBlipForRadius(coords.x, coords.y, coords.z, 100.0)
        -- SetBlipSprite(blip, 9)
        -- SetBlipColour(blip, 1)
        -- SetBlipAlpha(blip, transG)
        -- SetBlipAsShortRange(blip, false)
        -- BeginTextCommandSetBlipName('STRING')
        -- AddTextComponentString("911 - Suspicious Situation at Jewelry Store")
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
        exports['mr-dispatch']:VangelicoRobbery(coords)
    else
        if not robberyAlert then
            -- PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
            -- TriggerEvent('mr-policealerts:client:AddPoliceAlert', {
            --     timeOut = 5000,
            --     alertTitle = title,
            --     details = {
            --         [1] = {
            --             icon = '<i class="fas fa-gem"></i>',
            --             detail = "Vangelico Jewelry",
            --         },
            --         [2] = {
            --             icon = '<i class="fas fa-video"></i>',
            --             detail = "31 | 32 | 33 | 34",
            --         },
            --         [3] = {
            --             icon = '<i class="fas fa-globe-europe"></i>',
            --             detail = "Rockford Dr",
            --         },
            --     },
            --     callSign = MRFW.Functions.GetPlayerData().metadata["callsign"],
            -- })
            exports['mr-dispatch']:VangelicoRobbery(coords)
            robberyAlert = true
        end
    end
end)

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

Citizen.CreateThread(function()
    Dealer = AddBlipForCoord(Config.JewelleryLocation["coords"]["x"], Config.JewelleryLocation["coords"]["y"], Config.JewelleryLocation["coords"]["z"])

    SetBlipSprite (Dealer, 617)
    SetBlipDisplay(Dealer, 4)
    SetBlipScale  (Dealer, 0.7)
    SetBlipAsShortRange(Dealer, true)
    SetBlipColour(Dealer, 3)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Vangelico Jewelry")
    EndTextCommandSetBlipName(Dealer)
end)

RegisterNetEvent('mr-jewellery:client:syncTable')
AddEventHandler('mr-jewellery:client:syncTable', function(bool)
    inuse = bool
    OnHackDonet = bool
end)

RegisterNetEvent('mr-jewellery:client:syncTable2')
AddEventHandler('mr-jewellery:client:syncTable2', function(bool)
    unlocked = bool
    if unlocked and not doingLockHack then
        local lock = not bool
        doorUnlocked = true
        TriggerServerEvent('nui_doorlock:server:updateState', 'hiest_door_9', lock, nil, false, true, false)
    elseif not unlocked and doorUnlocked then
        local lock = not bool
        doorUnlocked = false
        TriggerServerEvent('nui_doorlock:server:updateState', 'hiest_door_9', lock, nil, false, true, false)
    end
end)
