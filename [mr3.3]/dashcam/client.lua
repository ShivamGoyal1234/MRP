local dashcamActive = false
local attachedVehicle = nil
local cameraHandle = nil

local PlayerData = {}

local MRFW = exports['mrfw']:GetCoreObject()

RegisterNetEvent('MRFW:Client:OnPlayerLoaded', function()
    PlayerData = MRFW.Functions.GetPlayerData()
end)

AddEventHandler('onResourceStart', function(resource)
   if resource == GetCurrentResourceName() then
    PlayerData = MRFW.Functions.GetPlayerData()
   end
end)

RegisterNetEvent('MRFW:Client:OnPlayerUnload', function()
    PlayerData = {}
end)

RegisterNetEvent('MRFW:Player:SetPlayerData', function(val)
    PlayerData = val
end)

Citizen.CreateThread(function()
    while true do
        if dashcamActive then

            if dashcamActive and not IsPedInAnyVehicle(PlayerPedId(), false) then
                DisableDash()
                dashcamActive = false
            end

            if IsPedInAnyVehicle(PlayerPedId(), false) and dashcamActive then
                UpdateDashcam()
            end

        end
        Citizen.Wait(1000)
    end
end)

RegisterCommand('+dashcam', function()
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        if dashcamActive then
            DisableDash()
        else
            EnableDash()
        end
    end
end)

RegisterKeyMapping("+dashcam", "Heli Camera", "keyboard", "I")


Citizen.CreateThread(function()
    while true do
        sleep = 1000
        if dashcamActive then
            sleep = 7
            local bonPos = GetWorldPositionOfEntityBone(attachedVehicle, GetEntityBoneIndexByName(attachedVehicle, "windscreen"))
            local vehRot = GetEntityRotation(attachedVehicle, 0)
            SetCamCoord(cameraHandle, bonPos.x, bonPos.y, bonPos.z)
            SetCamRot(cameraHandle, vehRot.x, vehRot.y, vehRot.z, 0)
        end
        Citizen.Wait(sleep)
    end
end)

function EnableDash()
    attachedVehicle = GetVehiclePedIsIn(GetPlayerPed(PlayerId()), false)
    if DashcamConfig.RestrictVehicles then
        if CheckVehicleRestriction() then
            SetTimecycleModifier("scanline_cam_cheap")
            SetTimecycleModifierStrength(2.2)
            local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
            RenderScriptCams(1, 0, 0, 1, 1)
            SetFocusEntity(attachedVehicle)
            cameraHandle = cam
            SendNUIMessage({
                type = "enabledash"
            })
            dashcamActive = true
        end
    else
        SetTimecycleModifier("scanline_cam_cheap")
        SetTimecycleModifierStrength(2.2)
        local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
        RenderScriptCams(1, 0, 0, 1, 1)
        SetFocusEntity(attachedVehicle)
        cameraHandle = cam
        SendNUIMessage({
            type = "enabledash"
        })
        dashcamActive = true
    end
end

function DisableDash()
    ClearTimecycleModifier("scanline_cam_cheap")
    RenderScriptCams(0, 0, 1, 1, 1)
    DestroyCam(cameraHandle, false)
    SetFocusEntity(GetPlayerPed(PlayerId()))
    SendNUIMessage({
        type = "disabledash"
    })
    dashcamActive = false
end

function UpdateDashcam()
    local gameTime = GetGameTimer()
    local year, month, day, hour, minute, second = GetLocalTime()
    local unitNumber = 'N/A'
    if PlayerData.metadata['callsign'] ~= 'NO CALLSIGN' then
        unitNumber = PlayerData.metadata['callsign']
    end
    local unitName = PlayerData.charinfo.firstname..' '..PlayerData.charinfo.lastname
    local unitSpeed = nil

    if DashcamConfig.useMPH then
        unitSpeed = GetEntitySpeed(attachedVehicle) * 2.23694
    else
        unitSpeed = GetEntitySpeed(attachedVehicle) * 3.6
    end

    SendNUIMessage({
        type = "updatedash",
        info = {
            gameTime = gameTime,
            clockTime = {year = year, month = month, day = day, hour = hour, minute = minute, second = second},
            unitNumber = unitNumber,
            unitName = unitName,
            unitSpeed = unitSpeed,
            useMPH = DashcamConfig.useMPH
        }
    })
end

function CheckVehicleRestriction()
    if DashcamConfig.RestrictionType == "custom" then
        for a = 1, #DashcamConfig.AllowedVehicles do
            print(GetHashKey(DashcamConfig.AllowedVehicles[a]))
            print(GetEntityModel(attachedVehicle))
            if GetHashKey(DashcamConfig.AllowedVehicles[a]) == GetEntityModel(attachedVehicle) then
                return true
            end
        end
        return false
    elseif DashcamConfig.RestrictionType == "class" then
        if GetVehicleClass(attachedVehicle) == 18 then
            return true
        else
            return false
        end
    else
        return false
    end
end