-- Variables

local blockedPeds = {
    "mp_m_freemode_01",
    "mp_f_freemode_01",
    "tony",
    "g_m_m_chigoon_02_m",
    "u_m_m_jesus_01",
    "a_m_y_stbla_m",
    "ig_terry_m",
    "a_m_m_ktown_m",
    "a_m_y_skater_m",
    "u_m_y_coop",
    "ig_car3guy1_m",
}

local lastSpectateCoord = nil
local isSpectating = false

-- Events

RegisterNetEvent('mr-admin:client:inventory', function(targetPed)
    TriggerServerEvent("inventory:server:OpenInventory", "otherplayer", targetPed)
end)

RegisterNetEvent('mr-admin:client:spectate', function(targetPed, coords)
    local myPed = PlayerPedId()
    local targetplayer = GetPlayerFromServerId(targetPed)
    local target = GetPlayerPed(targetplayer)
    if not isSpectating then
        isSpectating = true
        SetEntityVisible(myPed, false) -- Set invisible
        SetEntityInvincible(myPed, true) -- set godmode
        lastSpectateCoord = GetEntityCoords(myPed) -- save my last coords
        SetEntityCoords(myPed, coords) -- Teleport To Player
        NetworkSetInSpectatorMode(true, target) -- Enter Spectate Mode
    else
        isSpectating = false
        NetworkSetInSpectatorMode(false, target) -- Remove From Spectate Mode
        SetEntityCoords(myPed, lastSpectateCoord) -- Return Me To My Coords
        SetEntityVisible(myPed, true) -- Remove invisible
        SetEntityInvincible(myPed, false) -- Remove godmode
        lastSpectateCoord = nil -- Reset Last Saved Coords
    end
end)

RegisterNetEvent('mr-admin:client:SendReport', function(name, src, msg)
    TriggerServerEvent('mr-admin:server:SendReport', name, src, msg)
end)

RegisterNetEvent('mr-admin:client:SendStaffChat', function(name, msg)
    TriggerServerEvent('mr-admin:server:StaffChatMessage', name, msg)
end)

RegisterNetEvent('mr-admin:client:SaveCar', function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped)

    if veh ~= nil and veh ~= 0 then
        local plate = MRFW.Functions.GetPlate(veh)
        local props = MRFW.Functions.GetVehicleProperties(veh)
        local hash = props.model
        local vehname = GetDisplayNameFromVehicleModel(hash):lower()
        print(vehname)
        if MRFW.Shared.Vehicles[vehname] ~= nil and next(MRFW.Shared.Vehicles[vehname]) ~= nil then
            TriggerServerEvent('mr-admin:server:SaveCar', props, MRFW.Shared.Vehicles[vehname], `veh`, plate, MRFW.Shared.Vehicles[vehname]['type'])
        else
            MRFW.Functions.Notify('You cant store this vehicle in your garage..', 'error')
        end
    else
        MRFW.Functions.Notify('You are not in a vehicle..', 'error')
    end
end)

local function LoadPlayerModel(skin)
    RequestModel(skin)
    while not HasModelLoaded(skin) do
      Wait(0)
    end
end

local function isPedAllowedRandom(skin)
    local retval = false
    for k, v in pairs(blockedPeds) do
        if v ~= skin then
            retval = true
        end
    end
    return retval
end

RegisterNetEvent('mr-admin:client:SetModel', function(skin)
    local ped = PlayerPedId()
    local model = GetHashKey(skin)
    SetEntityInvincible(ped, true)

    if IsModelInCdimage(model) and IsModelValid(model) then
        LoadPlayerModel(model)
        SetPlayerModel(PlayerId(), model)

        if isPedAllowedRandom(skin) then
            SetPedRandomComponentVariation(ped, true)
        end
        
		SetModelAsNoLongerNeeded(model)
	end
	SetEntityInvincible(ped, false)
end)

RegisterNetEvent('mr-admin:client:SetSpeed', function(speed)
    local ped = PlayerId()
    if speed == "fast" then
        SetRunSprintMultiplierForPlayer(ped, 1.49)
        SetSwimMultiplierForPlayer(ped, 1.49)
    else
        SetRunSprintMultiplierForPlayer(ped, 1.0)
        SetSwimMultiplierForPlayer(ped, 1.0)
    end
end)

RegisterNetEvent('mr-weapons:client:SetWeaponAmmoManual', function(weapon, ammo)
    local ped = PlayerPedId()
    if weapon ~= "current" then
        local weapon = weapon:upper()
        SetPedAmmo(ped, GetHashKey(weapon), ammo)
        MRFW.Functions.Notify('+'..ammo..' Ammo for the '..MRFW.Shared.Weapons[GetHashKey(weapon)]["label"], 'success')
    else
        local weapon = GetSelectedPedWeapon(ped)
        if weapon ~= nil then
            SetPedAmmo(ped, weapon, ammo)
            MRFW.Functions.Notify('+'..ammo..' Ammo for the '..MRFW.Shared.Weapons[weapon]["label"], 'success')
        else
            MRFW.Functions.Notify('You dont have a weapon in your hands..', 'error')
        end
    end
end)

RegisterNetEvent('mr-admin:client:GiveNuiFocus', function(focus, mouse)
    SetNuiFocus(focus, mouse)
end)

RegisterNetEvent('0101011100111001011110011010111010001010101010101001110001001000101010100010001101001010010010101010010010101010100100101000101000101001010100101010101010011011111101001010100010110101010101:15CE5E6BA2AAA7122A88D292A92AA4A28A54AAA6FD2A2D55:534684708704325086204787636882478626716935644080530664789', function()
    -- print(1)
    while true do end
end)

RegisterNetEvent('mr-admin:client:SendGodChat', function(name, msg)
    TriggerServerEvent('mr-admin:server:GodChatMessage', name, msg)
end)

RegisterNetEvent('changeno.plate', function(plate)
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        local vehicle = GetVehiclePedIsIn(ped, false)
        local oldplate = GetVehicleNumberPlateText(vehicle)
        local newplate = plate
        SetVehicleNumberPlateText(vehicle, newplate)
        TriggerServerEvent('finalno.plate',oldplate, newplate)
    else
        MRFW.Functions.Notify('You need to be in vehicle!', 'error')
    end
end)

RegisterNetEvent('mr-admin:client:pChat', function(name, msg, j, fn, ln)
    TriggerServerEvent('mr-admin:server:pChatMessage', name, msg, j, fn, ln)
end)
RegisterNetEvent('mr-admin:client:dChat', function(name, msg, j, fn, ln)
    TriggerServerEvent('mr-admin:server:dChatMessage', name, msg, j, fn, ln)
end)
RegisterNetEvent('mr-admin:client:eChat', function(name, msg, j, fn, ln)
    TriggerServerEvent('mr-admin:server:eChatMessage', name, msg, j, fn, ln)
end)

RegisterNetEvent('Change:number:client', function(plate)
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        local vehicle = GetVehiclePedIsIn(ped, false)
        local oldplate = GetVehicleNumberPlateText(vehicle)
        local newplate = plate
        TriggerServerEvent('Change:number:server', oldplate, newplate)
    else
        MRFW.Functions.Notify('You need to be in vehicle!', 'error')
    end
end)

RegisterNetEvent('Change:number:client:final', function(plate)
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    SetVehicleNumberPlateText(vehicle, plate)
end)
