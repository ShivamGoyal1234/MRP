local MRFW = exports['mrfw']:GetCoreObject()
local group = Config.Group

-- Check if is decorating --

local IsDecorating = false

RegisterNetEvent('mr-anticheat:client:ToggleDecorate', function(bool)
  IsDecorating = bool
end)

local function trim(plate)
    if not plate then return nil end
    return (string.gsub(plate, '^%s*(.-)%s*$', '%1'))
end

-- Few frequently used locals --

local flags = 0

RegisterNetEvent('MRFW:Client:OnPlayerLoaded', function()
    MRFW.Functions.TriggerCallback('mr-anticheat:server:GetPermissions', function(UserGroup)
        group = UserGroup
    end)
end)

RegisterNetEvent('MRFW:Client:OnPlayerUnload', function()
    IsDecorating = false
    flags = 0
end)

-- Superjump --

-- CreateThread(function()
-- 	while true do
--         Wait(500)

--         local ped = PlayerPedId()
--         local player = PlayerId()

--         if group == Config.Group and LocalPlayer.state['isLoggedIn'] then
--             if IsPedJumping(ped) then
--                 local firstCoord = GetEntityCoords(ped)

--                 while IsPedJumping(ped) do
--                     Wait(5)
--                 end

--                 local secondCoord = GetEntityCoords(ped)
--                 local lengthBetweenCoords = #(firstCoord - secondCoord)

--                 if (lengthBetweenCoords > Config.SuperJumpLength) then
--                     flags = flags + 1
--                     TriggerServerEvent("mr-log:server:CreateLog", "anticheat", "Cheat detected!", "orange", "** @everyone " ..GetPlayerName(player).. "** is flagged from anticheat! **(Flag "..flags.." /"..Config.FlagsForBan.." | Superjump)**")
--                 end
--             end
--         end
--     end
-- end)

-- Speedhack --

-- CreateThread(function()
-- 	while true do
--         Wait(500)

--         local ped = PlayerPedId()
--         local player = PlayerId()
--         local speed = GetEntitySpeed(ped)
--         local inveh = IsPedInAnyVehicle(ped, false)
--         local ragdoll = IsPedRagdoll(ped)
--         local jumping = IsPedJumping(ped)
--         local falling = IsPedFalling(ped)

--         if group == Config.Group and LocalPlayer.state['isLoggedIn'] then
--             if not inveh then
--                 if not ragdoll then
--                     if not falling then
--                         if not jumping then
--                             if speed > Config.MaxSpeed then
--                                 flags = flags + 1
--                                 TriggerServerEvent("mr-log:server:CreateLog", "anticheat", "Cheat detected!", "orange", "** @everyone " ..GetPlayerName(player).. "** is flagged from anticheat! **(Flag "..flags.." /"..Config.FlagsForBan.." | Speedhack)**")
--                             end
--                         end
--                     end
--                 end
--             end
--         end
--     end
-- end)

-- Invisibility --

CreateThread(function()
    while true do
        Wait(10000)

        local ped = PlayerPedId()
        local player = PlayerId()

        if group == Config.Group and LocalPlayer.state['isLoggedIn'] then
            if not IsDecorating then
                if not IsEntityVisible(ped) then
                    SetEntityVisible(ped, 1, 0)
                    TriggerEvent('MRFW:Notify', "MR--ANTICHEAT: You were invisible and have been made visible again!")
                    TriggerServerEvent("mr-log:server:CreateLog", "anticheat", "Made player visible", "green", "** @everyone " ..GetPlayerName(player).. "** was invisible and has been made visible again by MR--Anticheat")
                end
            end
        end
    end
end)

-- Nightvision --

-- CreateThread(function()
--     while true do
--         Wait(2000)

--         local ped = PlayerPedId()
--         local player = PlayerId()

--         if group == Config.Group and LocalPlayer.state['isLoggedIn'] then
--             if GetUsingnightvision(true) then
--                 if not IsPedInAnyHeli(ped) then
--                     flags = flags + 1
--                     TriggerServerEvent("mr-log:server:CreateLog", "anticheat", "Cheat detected!", "orange", "** @everyone " ..GetPlayerName(player).. "** is flagged from anticheat! **(Flag "..flags.." /"..Config.FlagsForBan.." | Nightvision)**")
--                 end
--             end
--         end
--     end
-- end)

-- Thermalvision --

-- CreateThread(function()
--     while true do
--         Wait(2000)

--         local ped = PlayerPedId()

--         if group == Config.Group and LocalPlayer.state['isLoggedIn'] then
--             if GetUsingseethrough(true) then
--                 if not IsPedInAnyHeli(ped) then
--                     flags = flags + 1
--                     TriggerServerEvent("mr-log:server:CreateLog", "anticheat", "Cheat detected!", "orange", "** @everyone " ..GetPlayerName(player).. "** is flagged from anticheat! **(Flag "..flags.." /"..Config.FlagsForBan.." | Thermalvision)**") 
--                 end
--             end
--         end
--     end
-- end)

-- Spawned car --

-- CreateThread(function()
--     while true do
--         sleep = 2500

--         local ped = PlayerPedId()
--         local player = PlayerId()
--         local veh = GetVehiclePedIsIn(ped)
--         local DriverSeat = GetPedInVehicleSeat(veh, -1)
--         local plate = trim(GetVehicleNumberPlateText(veh))

--         if LocalPlayer.state['isLoggedIn'] then
--             if group == Config.Group then
--                 if IsPedInAnyVehicle(ped, true) then
--                     sleep = 5
--                     for _, BlockedPlate in pairs(Config.BlacklistedPlates) do
--                         if plate == BlockedPlate then
--                             if DriverSeat == ped then
--                                 DeleteVehicle(veh)
--                                 TriggerServerEvent("mr-anticheat:server:banPlayer", "Cheating")
--                                 TriggerServerEvent("mr-log:server:CreateLog", "anticheat", "Cheat detected!", "red", "** @everyone " ..GetPlayerName(player).. "** has been banned for cheating (Sat as driver in spawned vehicle with license plate **"..BlockedPlate..")**")
--                             end
--                         end
--                     end
--                 end
--             end
--         end
--         Wait(sleep)
--     end
-- end)

-- Check if ped has weapon in inventory --

CreateThread(function()
    while true do
        Wait(5000)

        if LocalPlayer.state['isLoggedIn'] then

            local PlayerPed = PlayerPedId()
            local player = PlayerId()
            local CurrentWeapon = GetSelectedPedWeapon(PlayerPed)
            local WeaponInformation = MRFW.Shared.Weapons[CurrentWeapon]

            if WeaponInformation["name"] ~= "weapon_unarmed" then
                MRFW.Functions.TriggerCallback('mr-anticheat:server:HasWeaponInInventory', function(HasWeapon)
                    if not HasWeapon then
                        RemoveAllPedWeapons(PlayerPed, false)
                        TriggerServerEvent("mr-log:server:CreateLog", "anticheat", "Weapon removed!", "orange", "** @everyone " ..GetPlayerName(player).. "** had a weapon on them that they did not have in his inventory. MR- Anticheat has removed the weapon.")
                    end
                end, WeaponInformation)
            end
        end
    end
end)

-- Max flags reached = ban, log, explosion & break --

-- CreateThread(function()
--     while true do
--         Wait(500)
--         local player = PlayerId()
--         if flags >= Config.FlagsForBan then
--             -- TriggerServerEvent("mr-anticheat:server:banPlayer", "Cheating")
--             -- AddExplosion(coords, EXPLOSION_GRENADE, 1000.0, true, false, false, true)
--             TriggerServerEvent("mr-log:server:CreateLog", "anticheat", "Player banned! (Not really of course, this is a test duuuhhhh)", "red", "** @everyone " ..GetPlayerName(player).. "** Too often has been flagged by the anti-cheat and preemptively banned from the server")
--             flags = 0
--         end
--     end
-- end)

RegisterNetEvent('mr-anticheat:client:NonRegisteredEventCalled', function(reason, CalledEvent)
    local player = PlayerId()

    TriggerServerEvent('mr-anticheat:server:banPlayer', reason)
    TriggerServerEvent("mr-log:server:CreateLog", "anticheat", "Player banned! (Not really of course, this is a test duuuhhhh)", "red", "** @everyone " ..GetPlayerName(player).. "** has event **"..CalledEvent.."tried to trigger (LUA injector!)")
end)


--------------------------Anti VDM---------------------
-- CreateThread(function()
--     while true do
--         SetWeaponDamageModifier(-1553120962, 0.0)
--         Wait(5)
--     end
-- end)