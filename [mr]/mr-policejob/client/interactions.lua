-- Variables
local isEscorting = false
local SucceededAttempts = 0
local NeededAttempts = 1

-- Functions

exports('IsHandcuffed', function()
    return isHandcuffed
end)

local function loadAnimDict(dict) -- interactions, job,
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(10)
    end
end

local function IsTargetDead(playerId)
    local retval = false
    local hasReturned = false
    MRFW.Functions.TriggerCallback('police:server:isPlayerDead', function(result)
        retval = result
        hasReturned = true
    end, playerId)
    while not hasReturned do
        Wait(10)
      end
    return retval
end

local function HandCuffAnimation()
    local ped = PlayerPedId()
    loadAnimDict("mp_arrest_paired")
	Wait(100)
    TaskPlayAnim(ped, "mp_arrest_paired", "cop_p2_back_right", 3.0, 3.0, -1, 48, 0, 0, 0, 0)
	Wait(3500)
    TaskPlayAnim(ped, "mp_arrest_paired", "exit", 3.0, 3.0, -1, 48, 0, 0, 0, 0)
end

local function GetCuffedAnimation(playerId)
    local ped = PlayerPedId()
    local cuffer = GetPlayerPed(GetPlayerFromServerId(playerId))
    local heading = GetEntityHeading(cuffer)
    loadAnimDict("mp_arrest_paired")
    SetEntityCoords(ped, GetOffsetFromEntityInWorldCoords(cuffer, 0.0, 0.45, 0.0))
	Wait(100)
	SetEntityHeading(ped, heading)
	TaskPlayAnim(ped, "mp_arrest_paired", "crook_p2_back_right", 3.0, 3.0, -1, 32, 0, 0, 0, 0)
	Wait(2500)
end

function HandunCuffAnimation()
    loadAnimDict("mp_arresting")
	Citizen.Wait(100)
    TaskPlayAnim(PlayerPedId(), "mp_arresting", "a_uncuff", 3.0, 3.0, -1, 48, 0, 0, 0, 0)
	Citizen.Wait(3500)
    TaskPlayAnim(PlayerPedId(), "mp_arresting", "exit", 3.0, 3.0, -1, 48, 0, 0, 0, 0)
end

-- Events

RegisterNetEvent('police:client:SetOutVehicle', function()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        local vehicle = GetVehiclePedIsIn(ped, false)
        TaskLeaveVehicle(ped, vehicle, 16)
    end
end)

RegisterNetEvent('police:client:PutInVehicle', function()
    local ped = PlayerPedId()
    if isHandcuffed or isEscorted then
        local vehicle = MRFW.Functions.GetClosestVehicle()
        if DoesEntityExist(vehicle) then
			for i = GetVehicleMaxNumberOfPassengers(vehicle), 1, -1 do
                if IsVehicleSeatFree(vehicle, i) then
                    isEscorted = false
                    TriggerEvent('hospital:client:isEscorted', isEscorted)
                    ClearPedTasks(PlayerPedId())
                    DetachEntity(PlayerPedId(), true, false)

                    Citizen.Wait(100)
                    SetPedIntoVehicle(PlayerPedId(), vehicle, i)
                    return
                else 
                    isEscorted = false
                    TriggerEvent('hospital:client:isEscorted', isEscorted)
                    ClearPedTasks(PlayerPedId())
                    DetachEntity(PlayerPedId(), true, false)

                    Citizen.Wait(100)
                    if GetVehicleClass(vehicle) == 8 then
                        -- MRFW.Functions.Notify("! ", "error")
                    else
                        SetPedIntoVehicle(PlayerPedId(), vehicle, 0)
                    end
                
                end
            end
		end
    end
end)

RegisterNetEvent('police:client:SearchPlayer', function()
    local player, distance = MRFW.Functions.GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        TriggerServerEvent("inventory:server:OpenInventory", "otherplayer", playerId)
        TriggerServerEvent("police:server:SearchPlayer", playerId)
    else
        MRFW.Functions.Notify("No one nearby!", "error")
    end
end)

RegisterNetEvent('police:client:SearchPlayerBag', function()
    local player, distance = MRFW.Functions.GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        MRFW.Functions.TriggerCallback('police:callback:searchbag', function(stashId)
            if stashId then
                TriggerEvent('dpemote:custom:animation', {"warmth"})
                TriggerEvent("inventory:client:SetCurrentStash", "storage_bags_"..stashId)
                TriggerServerEvent("inventory:server:OpenInventory", "stash", "storage_bags_"..stashId, {
                    maxweight = 300000,
                    slots = 100,
                })
                Citizen.Wait(5000)
                TriggerEvent('dpemote:custom:animation', {"c"})
            else
                MRFW.Functions.Notify('Bag not Found', 'error', 3000)
            end
        end, playerId)
    else
        MRFW.Functions.Notify("No one nearby!", "error")
    end
end)

RegisterNetEvent('police:client:SearchPlayerBag2', function()
    local player, distance = MRFW.Functions.GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        MRFW.Functions.TriggerCallback('police:callback:searchbag2', function(stashId)
            if stashId then
                TriggerEvent('dpemote:custom:animation', {"warmth"})
                TriggerEvent("inventory:client:SetCurrentStash", "storage_bags_"..stashId)
                TriggerServerEvent("inventory:server:OpenInventory", "stash", "storage_bags_"..stashId, {
                    maxweight = 300000,
                    slots = 100,
                })
                Citizen.Wait(5000)
                TriggerEvent('dpemote:custom:animation', {"c"})
            else
                MRFW.Functions.Notify('Bag not Fount', 'error', 3000)
            end
        end, playerId)
    else
        MRFW.Functions.Notify("No one nearby!", "error")
    end
end)

RegisterNetEvent('police:client:SeizeCash', function()
    local player, distance = MRFW.Functions.GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        TriggerServerEvent("police:server:SeizeCash", playerId)
    else
        MRFW.Functions.Notify("No one nearby!", "error")
    end
end)

RegisterNetEvent('police:client:SeizeDriverLicense', function()
    local player, distance = MRFW.Functions.GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        TriggerServerEvent("police:server:SeizeDriverLicense", playerId)
    else
        MRFW.Functions.Notify("No one nearby!", "error")
    end
end)


RegisterNetEvent('police:client:RobPlayer', function()
    local player, distance = MRFW.Functions.GetClosestPlayer()
    local ped = PlayerPedId()
    if player ~= -1 and distance < 2.5 then
        local playerPed = GetPlayerPed(player)
        local playerId = GetPlayerServerId(player)
        if IsEntityPlayingAnim(playerPed, "mp_arresting", "idle", 3) or IsTargetDead(playerId) then
            MRFW.Functions.Progressbar("robbing_player", "Robbing person..", math.random(5000, 7000), false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "random@shop_robbery",
                anim = "robbery_action_b",
                flags = 16,
            }, {}, {}, function() -- Done
                local plyCoords = GetEntityCoords(playerPed)
                local pos = GetEntityCoords(ped)
                if #(pos - plyCoords) < 2.5 then
                    StopAnimTask(ped, "random@shop_robbery", "robbery_action_b", 1.0)
                    TriggerServerEvent("inventory:server:OpenInventory", "otherplayer", playerId)
                    TriggerEvent("inventory:server:RobPlayer", playerId)
                    closeRob(playerPed)
                else
                    MRFW.Functions.Notify("No one nearby!", "error")
                end
            end, function() -- Cancel
                StopAnimTask(ped, "random@shop_robbery", "robbery_action_b", 1.0)
                MRFW.Functions.Notify("Canceled..", "error")
            end)
        end
    else
        MRFW.Functions.Notify("No one nearby!", "error")
    end
end)

function closeRob(ped)
    while IsEntityPlayingAnim(ped, "mp_arresting", "idle", 3) do
        Citizen.Wait(100)
    end
    TriggerEvent('close:inventory:bug')
end

RegisterNetEvent('police:client:JailCommand', function(playerId, time)
    TriggerServerEvent("police:server:JailPlayer", playerId, tonumber(time))
end)

RegisterNetEvent('police:client:BillCommand', function(playerId, amount)
    TriggerServerEvent("police:server:BillPlayer", playerId, tonumber(amount))
end)

RegisterNetEvent('police:client:JailPlayer', function()
    local player, distance = MRFW.Functions.GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        DisplayOnscreenKeyboard(1, "", "", "", "", "", "", 20)
        while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
            Wait(5)
        end
        local time = GetOnscreenKeyboardResult()
        if tonumber(time) > 0 then
            TriggerServerEvent("police:server:JailPlayer", playerId, tonumber(time))
        else
            MRFW.Functions.Notify("Time must be higher than 0..", "error")
        end
    else
        MRFW.Functions.Notify("No one nearby!", "error")
    end
end)

RegisterNetEvent('police:client:BillPlayer', function()
    local player, distance = MRFW.Functions.GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        DisplayOnscreenKeyboard(1, "", "", "", "", "", "", 20)
        while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
            Wait(5)
        end
        local price = GetOnscreenKeyboardResult()
        if tonumber(price) > 0 then
            TriggerServerEvent("police:server:BillPlayer", playerId, tonumber(amount))
        else
            MRFW.Functions.Notify("Time must be higher than 0..", "error")
        end
    else
        MRFW.Functions.Notify("No one nearby!", "error")
    end
end)

RegisterNetEvent('police:client:PutPlayerInVehicle', function()
    local player, distance = MRFW.Functions.GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        if not isHandcuffed and not isEscorted then
            TriggerServerEvent("police:server:PutPlayerInVehicle", playerId)
        end
    else
        MRFW.Functions.Notify("No one nearby!", "error")
    end
end)

RegisterNetEvent('police:client:SetPlayerOutVehicle', function()
    local player, distance = MRFW.Functions.GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        if not isHandcuffed and not isEscorted then
            TriggerServerEvent("police:server:SetPlayerOutVehicle", playerId)
        end
    else
        MRFW.Functions.Notify("No one nearby!", "error")
    end
end)

RegisterNetEvent('police:client:EscortPlayer', function()
    local player, distance = MRFW.Functions.GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        if not isHandcuffed and not isEscorted then
            TriggerServerEvent("police:server:EscortPlayer", playerId)
        end
    else
        MRFW.Functions.Notify(Lang:t("error.none_nearby"), "error")
    end
end)

RegisterNetEvent('police:client:KidnapPlayer', function()
    local player, distance = MRFW.Functions.GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        if not IsPedInAnyVehicle(GetPlayerPed(player)) then
            if not isHandcuffed and not isEscorted then
                TriggerServerEvent("police:server:KidnapPlayer", playerId)
            end
        end
    else
        MRFW.Functions.Notify("No one nearby!", "error")
    end
end)

RegisterNetEvent('police:client:CuffPlayerSoft', function()
    if not IsPedRagdoll(PlayerPedId()) then
        local player, distance = MRFW.Functions.GetClosestPlayer()
        if player ~= -1 and distance < 1.5 then
            local playerId = GetPlayerServerId(player)
            if not IsPedInAnyVehicle(GetPlayerPed(player)) and not IsPedInAnyVehicle(PlayerPedId()) then
                TriggerServerEvent("police:server:CuffPlayer", playerId, true)
                HandCuffAnimation()
            else
                MRFW.Functions.Notify(Lang:t("error.vehicle_cuff"), "error")
            end
        else
            MRFW.Functions.Notify(Lang:t("error.none_nearby"), "error")
        end
    else
        Wait(2000)
    end
end)

RegisterNetEvent('police:client:CuffPlayer', function()
    if not IsPedRagdoll(PlayerPedId()) then
        local player, distance = MRFW.Functions.GetClosestPlayer()
        if player ~= -1 and distance < 1.5 then
            MRFW.Functions.TriggerCallback('MRFW:HasItem', function(result)
                if result then 
                    local playerId = GetPlayerServerId(player)
                    if not IsPedInAnyVehicle(GetPlayerPed(player)) and not IsPedInAnyVehicle(GetPlayerPed(PlayerPedId())) then
                        TriggerServerEvent("police:server:CuffPlayer", playerId, false)
                        HandCuffAnimation()
                    else
                        MRFW.Functions.Notify("You can\'t cuff someone in a vehicle", "error")
                    end
                else
                    MRFW.Functions.Notify("You don\'t have handcuffs on you", "error")
                end
            end, "handcuffs")
        else
            MRFW.Functions.Notify("No one nearby!", "error")
        end
    else
        Wait(2000)
    end
end)

RegisterNetEvent('police:client:CuffPlayerSofts')
AddEventHandler('police:client:CuffPlayerSofts', function()
    if not IsPedRagdoll(PlayerPedId()) then
        local player, distance = GetClosestPlayer()
        if player ~= -1 and distance < 1.5 then
            local playerId = GetPlayerServerId(player)
            if not IsPedInAnyVehicle(GetPlayerPed(player)) and not IsPedInAnyVehicle(GetPlayerPed(PlayerPedId())) then
                
                if not isCuffed then
                    isCuffed = true
                    TriggerServerEvent("police:server:CuffPlayer", playerId, true)
                    HandCuffAnimation()
                    TriggerServerEvent("MRFW:Server:RemoveItem", "handcuffs", 1)
                    TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["handcuffs"], "remove")
                elseif isCuffed then
                    MRFW.Functions.Notify("Person is already cuffed!", "error")
                end
            else
                MRFW.Functions.Notify("You cant cuff someone in a vehicle", "error")
            end
        else
            MRFW.Functions.Notify("No one nearby!", "error")
        end
    else
        Citizen.Wait(2000)
    end
end)

RegisterNetEvent('police:client:GetEscorted', function(playerId)
    local ped = PlayerPedId()
    MRFW.Functions.GetPlayerData(function(PlayerData)
        if PlayerData.metadata["isdead"] or isHandcuffed or PlayerData.metadata["inlaststand"] then
            if not isEscorted then
                isEscorted = true
                draggerId = playerId
                local dragger = GetPlayerPed(GetPlayerFromServerId(playerId))
                SetEntityCoords(ped, GetOffsetFromEntityInWorldCoords(dragger, 0.0, 0.45, 0.0))
                AttachEntityToEntity(ped, dragger, 11816, 0.45, 0.45, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
            else
                isEscorted = false
                DetachEntity(ped, true, false)
            end
            TriggerEvent('hospital:client:isEscorted', isEscorted)
        end
    end)
end)

RegisterNetEvent('police:client:DeEscort', function()
    isEscorted = false
    TriggerEvent('hospital:client:isEscorted', isEscorted)
    DetachEntity(PlayerPedId(), true, false)
end)

RegisterNetEvent('police:client:GetKidnappedTarget', function(playerId)
    local ped = PlayerPedId()
    MRFW.Functions.GetPlayerData(function(PlayerData)
        if PlayerData.metadata["isdead"] or PlayerData.metadata["inlaststand"] or isHandcuffed then
            if not isEscorted then
                isEscorted = true
                draggerId = playerId
                local dragger = GetPlayerPed(GetPlayerFromServerId(playerId))
                RequestAnimDict("nm")

                while not HasAnimDictLoaded("nm") do
                    Wait(10)
                end
                -- AttachEntityToEntity(PlayerPedId(), dragger, 11816, 0.45, 0.45, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
                AttachEntityToEntity(ped, dragger, 0, 0.27, 0.15, 0.63, 0.5, 0.5, 0.0, false, false, false, false, 2, false)
                TaskPlayAnim(ped, "nm", "firemans_carry", 8.0, -8.0, 100000, 33, 0, false, false, false)
            else
                isEscorted = false
                DetachEntity(ped, true, false)
                ClearPedTasksImmediately(ped)
            end
            TriggerEvent('hospital:client:isEscorted', isEscorted)
        end
    end)
end)

RegisterNetEvent('police:client:unnCuffPlayer')
AddEventHandler('police:client:unnCuffPlayer', function()
    if not IsPedRagdoll(PlayerPedId()) then
        local player, distance = GetClosestPlayer()
        if player ~= -1 and distance < 1.5 then
            MRFW.Functions.TriggerCallback('MRFW:HasItem', function(result)
                if result then 
                    local playerId = GetPlayerServerId(player)
                    MRFW.Functions.Notify("You succeeded!")
                    TriggerEvent("police:client:uncCuffPlayer", playerId, false)
                    TriggerServerEvent('Police:Server:Give:Cuffs')
                    isCuffed = false
                    IsCuffing = false
                else
                    MRFW.Functions.Notify("You don\'t have uncuff on you", "error")
                end
            end, "keyz")
        else
            MRFW.Functions.Notify("No one nearby!", "error")
        end
    else
        Citizen.Wait(2000)
    end
end)

RegisterNetEvent('police:client:unnCuffPlayer1')
AddEventHandler('police:client:unnCuffPlayer1', function(info)
    if not IsPedRagdoll(PlayerPedId()) then
        local player, distance = GetClosestPlayer()
        if player ~= -1 and distance < 1.5 then
            MRFW.Functions.TriggerCallback('MRFW:HasItem', function(result)
                if result then 
                    local playerId = GetPlayerServerId(player)
                    MRFW.Functions.Notify("You succeeded!")
                    TriggerEvent("police:client:uncCuffPlayer", playerId, false)
                    local infos = {}
                    infos.uses = info.info.uses - 1
                    TriggerServerEvent('MRFW:Server:RemoveItem', info.name, info.amount, info.slot)
                    TriggerServerEvent("MRFW:Server:AddItem", info.name, info.amount, info.slot, infos)
                    -- TriggerServerEvent('Perform:Decay:item', info.name, info.slot, 5)
                    -- TriggerServerEvent("MRFW:Server:RemoveItem", 'bolt_cutter', 1, slot)
                    -- TriggerServerEvent("MRFW:Server:AddItem", 'bolt_cutter', 1, slot, info)
                    isCuffed = false
                    IsCuffing = false
                else
                    MRFW.Functions.Notify("You don\'t have uncuff on you", "error")
                end
            end, "bolt_cutter")
        else
            MRFW.Functions.Notify("No one nearby!", "error")
        end
    else
        Citizen.Wait(2000)
    end
end)

RegisterNetEvent('police:client:unCuffPlayer')
AddEventHandler('police:client:unCuffPlayer', function(isSoftcuff)
    if not IsPedRagdoll(PlayerPedId()) then
        local player, distance = GetClosestPlayer()
        if player ~= -1 and distance < 1.5 then
            local playerId = GetPlayerServerId(player)
            if not IsPedInAnyVehicle(GetPlayerPed(player)) and not IsPedInAnyVehicle(GetPlayerPed(PlayerPedId())) then
                HandunCuffAnimation()
                Citizen.Wait(100)
                TriggerServerEvent("police:server:unCuffPlayer", playerId, false)
                isCuffed = false
                
            else
                MRFW.Functions.Notify("You can\'t uncuff someone in a vehicle", "error")
            end     
        else
            MRFW.Functions.Notify("No one nearby!", "error")
        end
    else
        Citizen.Wait(2000)
    end
end)

RegisterNetEvent('police:client:uncCuffPlayer')
AddEventHandler('police:client:uncCuffPlayer', function(isSoftcuff)
    if not IsPedRagdoll(PlayerPedId()) then
        local player, distance = GetClosestPlayer()
        if player ~= -1 and distance < 1.5 then
            local playerId = GetPlayerServerId(player)
            if not IsPedInAnyVehicle(GetPlayerPed(player)) and not IsPedInAnyVehicle(GetPlayerPed(PlayerPedId())) then
                HandunCuffAnimation()
                Citizen.Wait(100)
                TriggerServerEvent("police:server:unnCuffPlayer", playerId, false)
                isCuffed = false
                
            else
                MRFW.Functions.Notify("You can\'t uncuff someone in a vehicle", "error")
            end     
        else
            MRFW.Functions.Notify("No one nearby!", "error")
        end
    else
        Citizen.Wait(2000)
    end
end)

RegisterNetEvent('police:client:GetKidnappedDragger', function(playerId)
    MRFW.Functions.GetPlayerData(function(PlayerData)
        if not isEscorting then
            draggerId = playerId
            local dragger = PlayerPedId()
            RequestAnimDict("missfinale_c2mcs_1")

            while not HasAnimDictLoaded("missfinale_c2mcs_1") do
                Wait(10)
            end
            TaskPlayAnim(dragger, "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 8.0, -8.0, 100000, 49, 0, false, false, false)
            isEscorting = true
        else
            local dragger = PlayerPedId()
            ClearPedSecondaryTask(dragger)
            ClearPedTasksImmediately(dragger)
            isEscorting = false
        end
        TriggerEvent('hospital:client:SetEscortingState', isEscorting)
        TriggerEvent('mr-kidnapping:client:SetKidnapping', isEscorting)
    end)
end)

-- RegisterNetEvent('police:client:GetCuffed', function(playerId, isSoftcuff)
--     local ped = PlayerPedId()
--     if not isHandcuffed then
--         isHandcuffed = true
--         TriggerServerEvent("police:server:SetHandcuffStatus", true)
--         ClearPedTasksImmediately(ped)
--         if GetSelectedPedWeapon(ped) ~= `WEAPON_UNARMED` then
--             SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
--         end
--         if not isSoftcuff then
--             cuffType = 16
--             GetCuffedAnimation(playerId)
--             MRFW.Functions.Notify("You are cuffed!")
--         else
--             cuffType = 49
--             GetCuffedAnimation(playerId)
--             MRFW.Functions.Notify("You are cuffed, but you can walk")
--         end
--     end
-- end)

RegisterNetEvent('police:client:GetCuffed', function(playerID, isSoftcuff)
    local ped = PlayerPedId()
    local Skillbar = exports['mr-skillbar']:GetSkillbarObject()
    if not isHandcuffed then
        Skillbar.Start({
            duration = math.random(500, 750),
            pos = math.random(10, 30),
            width = math.random(10, 20),
        }, function()
            if SucceededAttempts + 1 >= NeededAttempts then
                isHandcuffed = false
                isEscorted = false
                TriggerEvent('hospital:client:isEscorted', isEscorted)
                DetachEntity(ped, true, false)
                TriggerServerEvent("police:server:SetHandcuffStatus", false)
                ClearPedTasksImmediately(ped)
                TriggerServerEvent("InteractSound_SV:PlayOnSource", "Uncuff", 0.2)
                MRFW.Functions.Notify("You are uncuffed!")
            else
                Skillbar.Repeat({
                    duration = math.random(700, 1250),
                    pos = math.random(10, 40),
                    width = math.random(10, 13),
                })
                SucceededAttempts = SucceededAttempts + 1
            end
        end, function()
            isHandcuffed = true
            TriggerServerEvent("police:server:SetHandcuffStatus", true)
            ClearPedTasksImmediately(ped)
            if GetSelectedPedWeapon(ped) ~= `WEAPON_UNARMED` then
                SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
            end
            TriggerEvent("close:inventory:bug")
            if not isSoftcuff then
                cuffType = 16
                GetCuffedAnimation(playerId)
                MRFW.Functions.Notify("You are cuffed!")
            else
                cuffType = 49
                GetCuffedAnimation(playerId)
                MRFW.Functions.Notify("You are cuffed, but you can walk")
            end
        end)
    end 
end)

RegisterNetEvent('police:client:unGetCuffed')
AddEventHandler('police:client:unGetCuffed', function(playerId, isSoftcuff)
    if isHandcuffed or isSoftcuff then
        isHandcuffed = false
        isEscorted = false
        TriggerEvent('hospital:client:isEscorted', isEscorted)
        DetachEntity(PlayerPedId(), true, false)
        TriggerServerEvent("police:server:SetHandcuffStatus", false)
        ClearPedTasksImmediately(PlayerPedId())
        MRFW.Functions.Notify("You are uncuffed!")
    end
end)

-- Threads

CreateThread(function()
    while true do
        Wait(1)
        if isEscorted then
            DisableAllControlActions(0)
            EnableControlAction(0, 1, true)
			EnableControlAction(0, 2, true)
            EnableControlAction(0, 245, true)
            EnableControlAction(0, 38, true)
            EnableControlAction(0, 322, true)
	    EnableControlAction(0, 249, true)
            EnableControlAction(0, 46, true)
        end

        if isHandcuffed then
            DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1

			DisableControlAction(0, 45, true) -- Reload
			DisableControlAction(0, 22, true) -- Jump
			DisableControlAction(0, 44, true) -- Cover
			DisableControlAction(0, 37, true) -- Select Weapon
			DisableControlAction(0, 23, true) -- Also 'enter'?

			DisableControlAction(0, 288, true) -- Disable phone
			DisableControlAction(0, 289, true) -- Inventory
			DisableControlAction(0, 170, true) -- Animations
			DisableControlAction(0, 167, true) -- Job

			DisableControlAction(0, 26, true) -- Disable looking behind
			DisableControlAction(0, 73, true) -- Disable clearing animation
			DisableControlAction(2, 199, true) -- Disable pause screen

			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle

			DisableControlAction(2, 36, true) -- Disable going stealth

			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
	    	EnableControlAction(0, 249, true) -- Added for talking while cuffed
            EnableControlAction(0, 46, true)  -- Added for talking while cuffed

            if (not IsEntityPlayingAnim(PlayerPedId(), "mp_arresting", "idle", 3) and not IsEntityPlayingAnim(PlayerPedId(), "mp_arrest_paired", "crook_p2_back_right", 3)) and not MRFW.Functions.GetPlayerData().metadata["isdead"] then
                loadAnimDict("mp_arresting")
                TaskPlayAnim(PlayerPedId(), "mp_arresting", "idle", 8.0, -8, -1, cuffType, 0, 0, 0, 0)
            end
        end
        if not isHandcuffed and not isEscorted then
            Wait(2000)
        end
    end
end)