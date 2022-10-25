local inTuner = false
local RainbowNeon = false
LastEngineMultiplier = 1.0
local TunerData 

function setVehData(veh,data)
    local multp = 0.12
    local dTrain = 0.0
    if tonumber(data.drivetrain) == 2 then dTrain = 0.5 elseif tonumber(data.drivetrain) == 3 then dTrain = 1.0 end
    if not DoesEntityExist(veh) or not data then return nil end
    SetVehicleHandlingFloat(veh, "CHandlingData", "fInitialDriveForce", data.boost * multp)
    SetVehicleHandlingFloat(veh, "CHandlingData", "fDriveInertia", data.acceleration * multp)
    ModifyVehicleTopSpeed(veh, data.gearchange * multp)
    LastEngineMultiplier = data.gearchange * multp
    SetVehicleHandlingFloat(veh, "CHandlingData", "fDriveBiasFront", dTrain*1.0)
    SetVehicleHandlingFloat(veh, "CHandlingData", "fBrakeBiasFront", data.breaking * multp)
    -- TriggerEvent('mr-custom:client:updatemodsindatabase')
end

-- Citizen.CreateThread(function()
--     while true do
--         Wait(1000)
--         local ped = PlayerPedId()
--         if IsPedInAnyVehicle(ped, false) then
--             local vehicle = GetVehiclePedIsIn(ped, true)
--             local a = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveForce")
--             local b = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fDriveInertia")
--             local c = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fDriveBiasFront")
--             local d = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fBrakeBiasFront")
--             local e = GetVehicleTopSpeedModifier(vehicle)
--             -- local a = exports['vstancer']:GetFrontCamber(vehicle)
--             -- local b = exports['vstancer']:GetRearCamber(vehicle)
--             -- local c = exports['vstancer']:GetFrontTrackWidth(vehicle)
--             -- local d = exports['vstancer']:GetRearTrackWidth(vehicle)
--             print("======================================================")
--             print('fInitialDriveForce '..a)
--             print('fDriveInertia '..b)
--             print('fDriveBiasFront '..c)
--             print('fBrakeBiasFront '..d)
--             print('TopSpeedModifier '..e)
--             print("======================================================")
--         end
--     end
-- end)
-- function tablePrintOut(table)
--     if type(table) == 'table' then
--        local s = '\n{ '
--        for k,v in pairs(table) do
--           if type(k) ~= 'number' then k = '"'..k..'"' end
--           s = s .. '['..k..'] = ' .. tablePrintOut(v) .. ',\n'
--        end
--        return s .. '}'
--     else
--        return tostring(table)
--     end
-- end

function resetVeh(veh)
    SetVehicleHandlingFloat(veh, "CHandlingData", "fInitialDriveForce", 1.0)
    SetVehicleHandlingFloat(veh, "CHandlingData", "fDriveInertia", 1.0)
    SetVehicleEnginePowerMultiplier(veh, 1.0)
    SetVehicleHandlingFloat(veh, "CHandlingData", "fDriveBiasFront", 0.5)
    SetVehicleHandlingFloat(veh, "CHandlingData", "fBrakeBiasFront", 1.0)
end

RegisterNUICallback('save', function(data)
    MRFW.Functions.TriggerCallback('mr-tunerchip2:server:HasChip', function(HasChip)
        if HasChip then
            local ped = PlayerPedId()
            local veh = GetVehiclePedIsUsing(ped)
            setVehData(veh, data)
            -- TriggerServerEvent('Perform:Decay:item', TunerData.name, TunerData.slot, 2)
            MRFW.Functions.Notify('TunerChip v3.55: Vehicle Tuned!', 'error')

            TriggerServerEvent('mr-tunerchip2:server:TuneStatus', MRFW.Functions.GetPlate(veh), true)
        end
    end)
end)

RegisterNetEvent('mr-tunerchip2:client:TuneStatus')
AddEventHandler('mr-tunerchip2:client:TuneStatus', function()
    local ped = PlayerPedId()
    local closestVehicle = GetClosestVehicle(GetEntityCoords(ped), 5.0, 0, 70)
    local plate = MRFW.Functions.GetPlate(closestVehicle)
    local vehModel = GetEntityModel(closestVehicle)
    if vehModel ~= 0 then
        MRFW.Functions.TriggerCallback('mr-tunerchip2:server:GetStatus', function(status)
            if status then
                MRFW.Functions.Notify('This Vehicle Has Been Tuned', 'success')
            else
                MRFW.Functions.Notify('This Vehicle Has Not Been Tuned', 'error')
            end
        end, plate)
    else
        MRFW.Functions.Notify('No Vehicle Nearby', 'error')
    end
end)

RegisterNetEvent('mr-tunerchip2:client:checkvehicle')
AddEventHandler('mr-tunerchip2:client:checkvehicle', function(slot, info)
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        TriggerServerEvent('mr-tunerchip2:server:checkvehicle', slot, info)
    else
        MRFW.Functions.Notify("You Are Not In A Vehicle", "error")
    end
end)

RegisterNUICallback('checkItem', function(data, cb)
    local retval = false
    MRFW.Functions.TriggerCallback('MRFW:HasItem', function(result)
        if result then
            retval = true
        end
        cb(retval)
    end, data.item)
end)

RegisterNUICallback('reset', function(data)
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsUsing(ped)
    resetVeh(veh)
    -- TriggerServerEvent('Perform:Decay:item', TunerData.name, TunerData.slot, 2)
    MRFW.Functions.Notify('TunerChip v3.55: Vehicle has been reset!', 'error')
end)

RegisterNetEvent('mr-tunerchip2:client:openChip')
AddEventHandler('mr-tunerchip2:client:openChip', function(item)
    local ped = PlayerPedId()
    local inVehicle = IsPedInAnyVehicle(ped)

    if inVehicle then
        MRFW.Functions.Progressbar("connect_laptop", "Tunerchip v3.55: Vehicle Has Been Reset!", 2000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
            anim = "machinic_loop_mechandplayer",
            flags = 16,
        }, {}, {}, function() -- Done
            local infos = {}
            infos.uses = item.info.uses - 1
            TriggerServerEvent('MRFW:Server:RemoveItem', item.name, item.amount, item.slot)
            TriggerServerEvent("MRFW:Server:AddItem", item.name, item.amount, item.slot, infos)
            TunerData = item
            StopAnimTask(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
            openTunerLaptop(true)
        end, function() -- Cancel
            StopAnimTask(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
            MRFW.Functions.Notify("Canceled", "error")
        end)
    else
        MRFW.Functions.Notify("You Are Not In A Vehicle", "error")
    end
end)

RegisterNUICallback('exit', function()
    openTunerLaptop(false)
    SetNuiFocus(false, false)
    inTuner = false
end)

local LastRainbowNeonColor = 0

local RainbowNeonColors = {
    [1] = {
        r = 255,
        g = 0,
        b = 0
    },
    [2] = {
        r = 255,
        g = 165,
        b = 0
    },
    [3] = {
        r = 255,
        g = 255,
        b = 0
    },
    [4] = {
        r = 0,
        g = 0,
        b = 255
    },
    [5] = {
        r = 75,
        g = 0,
        b = 130
    },
    [6] = {
        r = 238,
        g = 130,
        b = 238
    },
}

RegisterNUICallback('saveNeon', function(data)
    MRFW.Functions.TriggerCallback('mr-tunerchip2:server:HasChip', function(HasChip)
        if HasChip then
            if not data.rainbowEnabled then
                local ped = PlayerPedId()
                local veh = GetVehiclePedIsIn(ped)

                if tonumber(data.neonEnabled) == 1 then
                    SetVehicleNeonLightEnabled(veh, 0, true)
                    SetVehicleNeonLightEnabled(veh, 1, true)
                    SetVehicleNeonLightEnabled(veh, 2, true)
                    SetVehicleNeonLightEnabled(veh, 3, true)
                    if tonumber(data.r) ~= nil and tonumber(data.g) ~= nil and tonumber(data.b) ~= nil then
                        SetVehicleNeonLightsColour(veh, tonumber(data.r), tonumber(data.g), tonumber(data.b))
                    else
                        SetVehicleNeonLightsColour(veh, 255, 255, 255)
                    end
                    RainbowNeon = false
                else
                    SetVehicleNeonLightEnabled(veh, 0, false)
                    SetVehicleNeonLightEnabled(veh, 1, false)
                    SetVehicleNeonLightEnabled(veh, 2, false)
                    SetVehicleNeonLightEnabled(veh, 3, false)
                    RainbowNeon = false
                end
            else
                local ped = PlayerPedId()
                local veh = GetVehiclePedIsIn(ped)

                if tonumber(data.neonEnabled) == 1 then
                    if not RainbowNeon then
                        RainbowNeon = true
                        SetVehicleNeonLightEnabled(veh, 0, true)
                        SetVehicleNeonLightEnabled(veh, 1, true)
                        SetVehicleNeonLightEnabled(veh, 2, true)
                        SetVehicleNeonLightEnabled(veh, 3, true)
                        Citizen.CreateThread(function()
                            while true do
                                if RainbowNeon then
                                    if (LastRainbowNeonColor + 1) ~= 7 then
                                        LastRainbowNeonColor = LastRainbowNeonColor + 1
                                        SetVehicleNeonLightsColour(veh, RainbowNeonColors[LastRainbowNeonColor].r, RainbowNeonColors[LastRainbowNeonColor].g, RainbowNeonColors[LastRainbowNeonColor].b)
                                    else
                                        LastRainbowNeonColor = 1
                                        SetVehicleNeonLightsColour(veh, RainbowNeonColors[LastRainbowNeonColor].r, RainbowNeonColors[LastRainbowNeonColor].g, RainbowNeonColors[LastRainbowNeonColor].b)
                                    end
                                else
                                    break
                                end

                                Citizen.Wait(350)
                            end
                        end)
                    end
                else
                    RainbowNeon = false
                    SetVehicleNeonLightEnabled(veh, 0, false)
                    SetVehicleNeonLightEnabled(veh, 1, false)
                    SetVehicleNeonLightEnabled(veh, 2, false)
                    SetVehicleNeonLightEnabled(veh, 3, false)
                end
            end
            -- TriggerServerEvent('Perform:Decay:item', TunerData.name, TunerData.slot, 2)
        end
    end)
end)

local RainbowHeadlight = false
local RainbowHeadlightValue = 0

RegisterNUICallback('saveHeadlights', function(data)
    MRFW.Functions.TriggerCallback('mr-tunerchip2:server:HasChip', function(HasChip)
        if HasChip then
            if data.rainbowEnabled then
                RainbowHeadlight = true
                local ped = PlayerPedId()
                local veh = GetVehiclePedIsIn(ped)
                local value = tonumber(data.value)

                Citizen.CreateThread(function()
                    while true do
                        if RainbowHeadlight then
                            if (RainbowHeadlightValue + 1) ~= 12 then
                                RainbowHeadlightValue = RainbowHeadlightValue + 1
                                ToggleVehicleMod(veh, 22, true)
                                SetVehicleHeadlightsColour(veh, RainbowHeadlightValue)
                            else
                                RainbowHeadlightValue = 1
                                ToggleVehicleMod(veh, 22, true)
                                SetVehicleHeadlightsColour(veh, RainbowHeadlightValue)
                            end
                        else
                            break
                        end
                        Citizen.Wait(300)
                    end
                end)                
                ToggleVehicleMod(veh, 22, true)
                SetVehicleHeadlightsColour(veh, value)
            else
                RainbowHeadlight = false
                local ped = PlayerPedId()
                local veh = GetVehiclePedIsIn(ped)
                local value = tonumber(data.value)

                ToggleVehicleMod(veh, 22, true)
                SetVehicleHeadlightsColour(veh, value)
            end
            -- TriggerServerEvent('Perform:Decay:item', TunerData.name, TunerData.slot, 2)
        end
    end)
end)

function openTunerLaptop(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        action = "ui",
        toggle = bool
    })
    inTuner = bool
end

RegisterNUICallback('SetStancer', function(data, cb)
    local fOffset = data.fOffset * 100 / 1000
    local fRotation = data.fRotation * 100 / 1000
    local rOffset = data.rOffset * 100 / 1000
    local rRotation = data.rRotation * 100 / 1000

    -- print(fOffset)
    -- print(fRotation)
    -- print(rOffset)
    -- print(rRotation)

    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped)
    -- TriggerServerEvent('Perform:Decay:item', TunerData.name, TunerData.slot, 2)
    exports["vstancer"]:SetWheelPreset(veh, -fOffset, -fRotation, -rOffset, -rRotation)
    TriggerEvent('mr-custom:client:updatemodsindatabase')
end)
