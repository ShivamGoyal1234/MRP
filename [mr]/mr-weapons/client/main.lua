-- Variables
local MRFW = exports['mrfw']:GetCoreObject()
local PlayerData, CurrentWeaponData, CanShoot, MultiplierAmount = {}, {}, true, 0


Citizen.CreateThread(function()
	while MRFW == nil do Wait(100) end
    MRFW.Functions.TriggerCallback('jacob:get:repair', function(a)
		Config.WeaponRepairPoints[1].coords = a
	end)
end)
-- Handlers

AddEventHandler('MRFW:Client:OnPlayerLoaded', function()
    PlayerData = MRFW.Functions.GetPlayerData()
    MRFW.Functions.TriggerCallback("weapons:server:GetConfig", function(RepairPoints)
        for k, data in pairs(RepairPoints) do
            Config.WeaponRepairPoints[k].IsRepairing = data.IsRepairing
            Config.WeaponRepairPoints[k].RepairingData = data.RepairingData
        end
    end)
end)

RegisterNetEvent('MRFW:Client:OnPlayerUnload', function()
    for k, v in pairs(Config.WeaponRepairPoints) do
        Config.WeaponRepairPoints[k].IsRepairing = false
        Config.WeaponRepairPoints[k].RepairingData = {}
    end
end)

-- Functions

local function DrawText3Ds(x, y, z, text)
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

-- Events

RegisterNetEvent("weapons:client:SyncRepairShops", function(NewData, key)
    Config.WeaponRepairPoints[key].IsRepairing = NewData.IsRepairing
    Config.WeaponRepairPoints[key].RepairingData = NewData.RepairingData
end)

RegisterNetEvent("addAttachment", function(component)
    local ped = PlayerPedId()
    local weapon = GetSelectedPedWeapon(ped)
    local WeaponData = MRFW.Shared.Weapons[weapon]
    GiveWeaponComponentToPed(ped, GetHashKey(WeaponData.name), GetHashKey(component))
end)

RegisterNetEvent('weapons:client:EquipTint', function(tint)
    local player = PlayerPedId()
    local weapon = GetSelectedPedWeapon(player)
    SetPedWeaponTintIndex(player, weapon, tint)
end)

RegisterNetEvent('weapons:client:SetCurrentWeapon', function(data, bool)
    if data ~= false then
        CurrentWeaponData = data
    else
        CurrentWeaponData = {}
    end
    CanShoot = bool
end)

RegisterNetEvent('weapons:client:SetWeaponQuality', function(amount)
    if CurrentWeaponData and next(CurrentWeaponData) then
        TriggerServerEvent("weapons:server:SetWeaponQuality", CurrentWeaponData, amount)
    end
end)

RegisterNetEvent('weapon:client:AddAmmo', function(type, amount, itemData)
    local ped = PlayerPedId()
    local weapon = GetSelectedPedWeapon(PlayerPedId())
    if CurrentWeaponData ~= nil then
    
        if MRFW.Shared.Weapons[weapon]["name"] ~= "weapon_unarmed" and MRFW.Shared.Weapons[weapon]["ammotype"] == type:upper() then
            local total = (GetAmmoInPedWeapon(PlayerPedId(), weapon))
            local addamount = GetMaxAmmoInClip(ped, weapon, 1)
            local maxammo = 200 
            
            if type:upper() == 'AMMO_PISTOL' then
                maxammo = 120
            elseif type:upper() == 'AMMO_SMG' then
                maxammo = 180
            elseif type:upper() == 'AMMO_SHOTGUN' then
                maxammo = 60
            elseif type:upper() == 'AMMO_RIFLE' then
                maxammo = 200
            elseif type:upper() == 'AMMO_SNIPER' then
                maxammo = 20
            elseif type:upper() == 'AMMO_LTL' then
                maxammo = 60
            end

            if total < maxammo then
                MRFW.Functions.Progressbar("taking_bullets", "Loading bullets", math.random(500, 1000), false, true, {
                    disableMovement = false,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = true,
                }, {}, {}, {}, function() -- Done
                    if MRFW.Shared.Weapons[weapon] ~= nil then
                        SetAmmoInClip(ped, weapon, 0)
                        SetPedAmmo(ped, weapon, total+addamount)
                        local total = (GetAmmoInPedWeapon(PlayerPedId(), weapon))
                        if total >= maxammo then
                            SetPedAmmo(ped, weapon, maxammo)
                        end
                        TriggerServerEvent("weapons:server:AddWeaponAmmo", CurrentWeaponData, total)
                        TriggerServerEvent('MRFW:Server:RemoveItem', itemData.name, 1, itemData.slot)
                        TriggerEvent('inventory:client:ItemBox', MRFW.Shared.Items[itemData.name], "remove")
                        TriggerEvent('MRFW:Notify', "" .. addamount .." bullets loaded!", "success")
                    end
                end, function()
                    MRFW.Functions.Notify("Canceled", "error")
                end)
            else
                MRFW.Functions.Notify("Your weapon is already loaded.", "error")
            end
        else
            MRFW.Functions.Notify("You are not holding a weapon.", "error")
        end
    else
        MRFW.Functions.Notify("You are not holding a weapon.", "error")
    end
end)

RegisterNetEvent("weapons:client:EquipAttachment", function(ItemData, attachment)
    local ped = PlayerPedId()
    local weapon = GetSelectedPedWeapon(ped)
    local WeaponData = MRFW.Shared.Weapons[weapon]
    if weapon ~= GetHashKey("WEAPON_UNARMED") then
        WeaponData.name = WeaponData.name:upper()
        if WeaponAttachments[WeaponData.name] then
            if WeaponAttachments[WeaponData.name][attachment]['item'] == ItemData.name then
                TriggerServerEvent("weapons:server:EquipAttachment", ItemData, CurrentWeaponData, WeaponAttachments[WeaponData.name][attachment])
            else
                MRFW.Functions.Notify("This weapon does not support this attachment.", "error")
            end
        end
    else
        MRFW.Functions.Notify("You dont have a weapon in your hand.", "error")
    end
end)

-- Threads

CreateThread(function()
    SetWeaponsNoAutoswap(true)
end)

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        if IsPedArmed(ped, 7) == 1 and (IsControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 24)) then
            local weapon = GetSelectedPedWeapon(ped)
            local ammo = GetAmmoInPedWeapon(ped, weapon)
            TriggerServerEvent("weapons:server:UpdateWeaponAmmo", CurrentWeaponData, tonumber(ammo))
            if MultiplierAmount > 0 then
                TriggerServerEvent("weapons:server:UpdateWeaponQuality", CurrentWeaponData, MultiplierAmount)
                MultiplierAmount = 0
            end
        end
        Wait(5)
    end
end)

CreateThread(function()
    while true do
        sleep = 2500
        if LocalPlayer.state['isLoggedIn'] then
            if CurrentWeaponData and next(CurrentWeaponData) then
                sleep = 5
                local ped = PlayerPedId()
                if IsPedShooting(ped) or IsControlJustPressed(0, 24) then
                    if CanShoot then
                        local weapon = GetSelectedPedWeapon(ped)
                        local ammo = GetAmmoInPedWeapon(ped, weapon)
                        if MRFW.Shared.Weapons[weapon]["name"] == "weapon_snowball" then
                            TriggerServerEvent('MRFW:Server:RemoveItem', "snowball", 1)
                        elseif MRFW.Shared.Weapons[weapon]["name"] == "weapon_pipebomb" then
                            TriggerServerEvent('MRFW:Server:RemoveItem', "weapon_pipebomb", 1)
                        elseif MRFW.Shared.Weapons[weapon]["name"] == "weapon_molotov" then
                            TriggerServerEvent('MRFW:Server:RemoveItem', "weapon_molotov", 1)
                        elseif MRFW.Shared.Weapons[weapon]["name"] == "weapon_stickybomb" then
                            TriggerServerEvent('MRFW:Server:RemoveItem', "weapon_stickybomb", 1)
                        else
                            if ammo > 0 then
                                MultiplierAmount = MultiplierAmount + 1
                            end
                        end
                    else
			            local weapon = GetSelectedPedWeapon(ped)
                        if weapon ~= -1569615261 then
                            TriggerEvent('inventory:client:CheckWeapon', MRFW.Shared.Weapons[weapon]["name"])
                            MRFW.Functions.Notify("This weapon is broken and can not be used.", "error")
                            MultiplierAmount = 0
                        end
                    end
                end
            end
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    while Config.WeaponRepairPoints[1].coords == nil do Wait(100) end
    while true do
        if LocalPlayer.state['isLoggedIn'] then
            local inRange = false
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            for k, data in pairs(Config.WeaponRepairPoints) do
                local distance = #(pos - data.coords)
                -- print(data.coords.x,data.coords.y,data.coords.z)
                if distance < 10 then
                    inRange = true
                    if distance < 1 then
                        if data.IsRepairing then
                            if data.RepairingData.CitizenId ~= PlayerData.citizenid then
                                DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, 'The repairshop in this moment is ~r~NOT~w~ usable.')
                            else
                                if not data.RepairingData.Ready then
                                    DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, 'Your weapon will be repaired.')
                                else
                                    DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, '[E] - Take Weapon Back')
                                end
                            end
                        else
                            if CurrentWeaponData and next(CurrentWeaponData) then
                                if not data.RepairingData.Ready then
                                    local WeaponData = MRFW.Shared.Weapons[GetHashKey(CurrentWeaponData.name)]
                                    local WeaponClass = (MRFW.Shared.SplitStr(WeaponData.ammotype, "_")[2]):lower()
                                    DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, '[E] Repair Weapon, ~g~$'..Config.WeaponRepairCotsts[WeaponClass]..'~w~')
                                    if IsControlJustPressed(0, 38) then
                                        MRFW.Functions.TriggerCallback('weapons:server:RepairWeapon', function(HasMoney)
                                            if HasMoney then
                                                CurrentWeaponData = {}
                                            end
                                        end, k, CurrentWeaponData)
                                    end
                                else
                                    if data.RepairingData.CitizenId ~= PlayerData.citizenid then
                                        DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, 'The repairshop is this moment ~r~NOT~w~ usable.')
                                    else
                                        DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, '[E] - Take Weapon Back')
                                        if IsControlJustPressed(0, 38) then
                                            TriggerServerEvent('weapons:server:TakeBackWeapon', k, data)
                                        end
                                    end
                                end
                            else
                                if data.RepairingData.CitizenId == nil then
                                    DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, 'You dont have a weapon in your hands.')
                                elseif data.RepairingData.CitizenId == PlayerData.citizenid then
                                    DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, '[E] - Take Weapon Back')
                                    if IsControlJustPressed(0, 38) then
                                        TriggerServerEvent('weapons:server:TakeBackWeapon', k, data)
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if not inRange then
                Wait(1000)
            end
        end
        Wait(3)
    end
end)