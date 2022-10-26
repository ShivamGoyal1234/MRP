-- Player load and unload handling
-- New method for checking if logged in across all scripts (optional)
-- if LocalPlayer.state['isLoggedIn'] then
RegisterNetEvent('MRFW:Client:OnPlayerLoaded', function()
    ShutdownLoadingScreenNui()
    LocalPlayer.state:set('isLoggedIn', true, false)
    SetCanAttackFriendly(PlayerPedId(), true, false)
    NetworkSetFriendlyFireOption(true)
end)

RegisterNetEvent('MRFW:Client:OnPlayerUnload', function()
    LocalPlayer.state:set('isLoggedIn', false, false)
end)

-- Teleport Commands

RegisterNetEvent('MRFW:Command:TeleportToPlayer', function(coords)
    local ped = PlayerPedId()
    SetPedCoordsKeepVehicle(ped, coords.x, coords.y, coords.z)
end)

RegisterNetEvent('MRFW:Command:TeleportToCoords', function(x, y, z)
    local ped = PlayerPedId()
    SetPedCoordsKeepVehicle(ped, x, y, z)
end)

RegisterNetEvent('MRFW:Command:GoToMarker', function()
    local ped = PlayerPedId()
    local blip = GetFirstBlipInfoId(8)
    if DoesBlipExist(blip) then
        local blipCoords = GetBlipCoords(blip)
        for height = 1, 1000 do
            SetPedCoordsKeepVehicle(ped, blipCoords.x, blipCoords.y, height + 0.0)
            local foundGround, zPos = GetGroundZFor_3dCoord(blipCoords.x, blipCoords.y, height + 0.0)
            if foundGround then
                SetPedCoordsKeepVehicle(ped, blipCoords.x, blipCoords.y, height + 0.0)
                break
            end
            Wait(0)
        end
    end
end)

-- Vehicle Commands

local dlv = false
local lvs = nil

RegisterNetEvent('MRFW:DLV', function(t)
    dlv = t
end)

RegisterNetEvent('MRFW:Command:SpawnVehicle', function(vehName)
    local ped = PlayerPedId()
    local hash = GetHashKey(vehName)
    if not IsModelInCdimage(hash) then
        return
    end
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(10)
    end
    if dlv then
        SetEntityAsMissionEntity(lvs, true, true)
        DeleteVehicle(lvs)
        lvs = nil
        local vehicle = CreateVehicle(hash, GetEntityCoords(ped), GetEntityHeading(ped), true, false)
        lvs = vehicle
        exports['mr-fuel']:SetFuel(vehicle, 100)
        SetVehicleFuelLevel(vehicle, 100.0)
        SetVehicleDirtLevel(vehicle, 0.0)
        TaskWarpPedIntoVehicle(ped, vehicle, -1)
        SetModelAsNoLongerNeeded(vehicle)
        TriggerEvent("vehiclekeys:client:SetOwner", MRFW.Functions.GetPlate(vehicle))
    else
        local vehicle = CreateVehicle(hash, GetEntityCoords(ped), GetEntityHeading(ped), true, false)
        exports['mr-fuel']:SetFuel(vehicle, 100)
        SetVehicleFuelLevel(vehicle, 100.0)
        SetVehicleDirtLevel(vehicle, 0.0)
        TaskWarpPedIntoVehicle(ped, vehicle, -1)
        SetModelAsNoLongerNeeded(vehicle)
        TriggerEvent("vehiclekeys:client:SetOwner", MRFW.Functions.GetPlate(vehicle))
    end
end)

RegisterNetEvent('MRFW:Command:DeleteVehicle', function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsUsing(ped)
    if veh ~= 0 then
        SetEntityAsMissionEntity(veh, true, true)
        DeleteVehicle(veh)
    else
        local pcoords = GetEntityCoords(ped)
        local vehicles = GetGamePool('CVehicle')
        for k, v in pairs(vehicles) do
            if #(pcoords - GetEntityCoords(v)) <= 5.0 then
                SetEntityAsMissionEntity(v, true, true)
                DeleteVehicle(v)
            end
        end
    end
end)

-- Other stuff

RegisterNetEvent('MRFW:Player:SetPlayerData', function(val)
    MRFW.PlayerData = val
end)

RegisterNetEvent('MRFW:Player:UpdatePlayerData', function()
    TriggerServerEvent('MRFW:UpdatePlayer', GetPedArmour(PlayerPedId()), GetEntityHealth(PlayerPedId()))
end)

RegisterNetEvent('MRFW:Notify', function(text, type, length)
    MRFW.Functions.Notify(text, type, length)
end)

RegisterNetEvent('MRFW:Client:TriggerCallback', function(name, ...)
    if MRFW.ServerCallbacks[name] then
        MRFW.ServerCallbacks[name](...)
        MRFW.ServerCallbacks[name] = nil
    end
end)

RegisterNetEvent('MRFW:Client:UseItem', function(item)
    TriggerServerEvent('MRFW:Server:UseItem', item)
end)

local function Draw3DText(coords, str)
    local onScreen, worldX, worldY = World3dToScreen2d(coords.x, coords.y, coords.z)
	local camCoords = GetGameplayCamCoord()
	local scale = 200 / (GetGameplayCamFov() * #(camCoords - coords))
    if onScreen then
        SetTextScale(1.0, 0.5 * scale)
        SetTextFont(4)
        SetTextColour(255, 255, 255, 255)
        SetTextEdge(2, 0, 0, 0, 150)
		SetTextProportional(1)
		SetTextOutline()
		SetTextCentre(1)
        SetTextEntry("STRING")
        AddTextComponentString(str)
        DrawText(worldX, worldY)
    end
end

RegisterNetEvent('MRFW:Command:ShowMe3D', function(senderId, msg)
    local sender = GetPlayerFromServerId(senderId)
    CreateThread(function()
        local displayTime = 5000 + GetGameTimer()
        while displayTime > GetGameTimer() do
            local targetPed = GetPlayerPed(sender)
            local tCoords = GetEntityCoords(targetPed)
            Draw3DText(tCoords, msg)
            Wait(0)
        end
    end)
end)