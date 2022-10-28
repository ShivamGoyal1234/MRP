-- Variables

local MRFW = exports['mrfw']:GetCoreObject()
local PlayerData = MRFW.Functions.GetPlayerData()
local inInventory = false
local currentWeapon = nil
local CurrentWeaponData = {}
local currentOtherInventory = nil
local Drops = {}
local CurrentDrop = nil
local DropsNear = {}
local CurrentVehicle = nil
local CurrentGlovebox = nil
local CurrentStash = nil
local isCrafting = false
local isHotbar = false
local itemInfos = {}
local showBlur = true

RegisterNUICallback('showBlur', function()
    -- Wait(50)
    TriggerEvent("aj-inventory:client:showBlur")
end) 
RegisterNetEvent("aj-inventory:client:showBlur", function()
    -- Wait(50)
    showBlur = not showBlur
end)

-- Functions

local function GetClosestVending()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local object = nil
    for _, machine in pairs(Config.VendingObjects) do
        local ClosestObject = GetClosestObjectOfType(pos.x, pos.y, pos.z, 0.75, GetHashKey(machine), 0, 0, 0)
        if ClosestObject ~= 0 then
            if object == nil then
                object = ClosestObject
            end
        end
    end
    return object
end

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

local function FormatWeaponAttachments(itemdata)
    local attachments = {}
    itemdata.name = itemdata.name:upper()
    if itemdata.info.attachments ~= nil and next(itemdata.info.attachments) ~= nil then
        for k, v in pairs(itemdata.info.attachments) do
            if WeaponAttachments[itemdata.name] ~= nil then
                for key, value in pairs(WeaponAttachments[itemdata.name]) do
                    if value.component == v.component then
                        item = value.item
                        attachments[#attachments+1] = {
                            attachment = key,
                            label = MRFW.Shared.Items[item].label
                            --label = value.label
                        }
                    end
                end
            end
        end
    end
    return attachments
end

local function IsBackEngine(vehModel)
    if BackEngineVehicles[vehModel] then return true end
    return false
end

local function OpenTrunk()
    local vehicle = MRFW.Functions.GetClosestVehicle()
    while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do
        RequestAnimDict("amb@prop_human_bum_bin@idle_b")
        Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), "amb@prop_human_bum_bin@idle_b", "idle_d", 4.0, 4.0, -1, 50, 0, false, false, false)
    if (IsBackEngine(GetEntityModel(vehicle))) then
        SetVehicleDoorOpen(vehicle, 4, false, false)
    else
        SetVehicleDoorOpen(vehicle, 5, false, false)
    end
end

local function CloseTrunk()
    local vehicle = MRFW.Functions.GetClosestVehicle()
    while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do
        RequestAnimDict("amb@prop_human_bum_bin@idle_b")
        Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), "amb@prop_human_bum_bin@idle_b", "exit", 4.0, 4.0, -1, 50, 0, false, false, false)
    if (IsBackEngine(GetEntityModel(vehicle))) then
        SetVehicleDoorShut(vehicle, 4, false)
    else
        SetVehicleDoorShut(vehicle, 5, false)
    end
end

local function closeInventory()
    SendNUIMessage({
        action = "close",
    })
end

local function ToggleHotbar(toggle)
    local HotbarItems = {
        [1] = PlayerData.items[1],
        [2] = PlayerData.items[2],
        [3] = PlayerData.items[3],
        [4] = PlayerData.items[4],
        [5] = PlayerData.items[5],
    }

    if toggle then
        SendNUIMessage({
            action = "toggleHotbar",
            open = true,
            items = HotbarItems
        })
    else
        SendNUIMessage({
            action = "toggleHotbar",
            open = false,
        })
    end
end

local function LoadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
end

local function openAnim()
    local ped = PlayerPedId()
    LoadAnimDict('pickup_object')
    TaskPlayAnim(ped,'pickup_object', 'putdown_low', 5.0, 1.5, 1.0, 48, 0.0, 0, 0, 0)
    Wait(500)
    StopAnimTask(ped, 'pickup_object', 'putdown_low', 1.0)
end

-- Events

RegisterNetEvent('MRFW:Client:OnPlayerLoaded', function()
    LocalPlayer.state:set("inv_busy", false, true)
    PlayerData = MRFW.Functions.GetPlayerData()
end)

RegisterNetEvent('MRFW:Client:OnPlayerUnload', function()
    LocalPlayer.state:set("inv_busy", true, true)
    PlayerData = {}
end)

RegisterNetEvent('MRFW:Player:SetPlayerData', function(val)
    PlayerData = val
end)

RegisterNetEvent('inventory:client:CheckOpenState', function(type, id, label)
    local name = MRFW.Shared.SplitStr(label, "-")[2]
    if type == "stash" then
        if name ~= CurrentStash or CurrentStash == nil then
            TriggerServerEvent('inventory:server:SetIsOpenState', false, type, id)
        end
    elseif type == "trunk" then
        if name ~= CurrentVehicle or CurrentVehicle == nil then
            TriggerServerEvent('inventory:server:SetIsOpenState', false, type, id)
        end
    elseif type == "glovebox" then
        if name ~= CurrentGlovebox or CurrentGlovebox == nil then
            TriggerServerEvent('inventory:server:SetIsOpenState', false, type, id)
        end
    elseif type == "drop" then
        if name ~= CurrentDrop or CurrentDrop == nil then
            TriggerServerEvent('inventory:server:SetIsOpenState', false, type, id)
        end
    end
end)

RegisterNetEvent('weapons:client:SetCurrentWeapon', function(data, bool)
    CurrentWeaponData = data or {}
end)

RegisterNetEvent('inventory:client:ItemBox', function(itemData, type, amount)
    amount = amount or 1
    SendNUIMessage({
        action = "itemBox",
        item = itemData,
        type = type,
        itemAmount = amount
    })
end)

RegisterNetEvent('inventory:client:requiredItems', function(items, bool)
    local itemTable = {}
    if bool then
        for k, v in pairs(items) do
            itemTable[#itemTable+1] = {
                item = items[k].name,
                label = MRFW.Shared.Items[items[k].name]["label"],
                image = items[k].image,
            }
        end
    end

    SendNUIMessage({
        action = "requiredItem",
        items = itemTable,
        toggle = bool
    })
end)

RegisterNetEvent('inventory:server:RobPlayer', function(TargetId)
    SendNUIMessage({
        action = "RobMoney",
        TargetId = TargetId,
    })
end)

RegisterNetEvent('inventory:client:OpenInventory', function(PlayerAmmo, inventory, other)
    if not IsEntityDead(PlayerPedId()) then
        Wait(50)
        ToggleHotbar(false)
        if showBlur == true then
            TriggerScreenblurFadeIn(100)
        end
        SetNuiFocus(true, true)
        if other then
            currentOtherInventory = other.name
        end
        SendNUIMessage({
            action = "open",
            inventory = inventory,
            slots = MaxInventorySlots,
            other = other,
            maxweight = MRFW.Config.Player.MaxWeight,
            Ammo = PlayerAmmo,
            maxammo = Config.MaximumAmmoValues,
        })
        inInventory = true
    end
end)

RegisterNetEvent('inventory:client:UpdatePlayerInventory', function(isError)
    SendNUIMessage({
        action = "update",
        inventory = PlayerData.items,
        maxweight = MRFW.Config.Player.MaxWeight,
        slots = MaxInventorySlots,
        error = isError,
    })
end)

RegisterNetEvent('inventory:client:PickupSnowballs', function()
    local ped = PlayerPedId()
    LoadAnimDict('anim@mp_snowball')
    TaskPlayAnim(ped, 'anim@mp_snowball', 'pickup_snowball', 3.0, 3.0, -1, 0, 1, 0, 0, 0)
    MRFW.Functions.Progressbar("pickupsnowball", "Collecting snowballs..", 1500, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        ClearPedTasks(ped)
        TriggerServerEvent('MRFW:Server:AddItem', "snowball", 1)
        TriggerEvent('inventory:client:ItemBox', MRFW.Shared.Items["snowball"], "add")
    end, function() -- Cancel
        ClearPedTasks(ped)
        MRFW.Functions.Notify("Canceled", "error")
    end)
end)

RegisterNetEvent('inventory:client:UseSnowball', function(amount)
    local ped = PlayerPedId()
    GiveWeaponToPed(ped, `weapon_snowball`, amount, false, false)
    SetPedAmmo(ped, `weapon_snowball`, amount)
    SetCurrentPedWeapon(ped, `weapon_snowball`, true)
end)

RegisterNetEvent('inventory:client:UseWeapon', function(weaponData, shootbool)
    local ped = PlayerPedId()
    local weaponName = tostring(weaponData.name)
    if currentWeapon == weaponName then
        SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
        Wait(1500)
        RemoveAllPedWeapons(ped, true)
        TriggerEvent('weapons:client:SetCurrentWeapon', nil, shootbool)
        currentWeapon = nil
    elseif weaponName == "weapon_stickybomb" or weaponName == "weapon_pipebomb" or weaponName == "weapon_smokegrenade" or weaponName == "weapon_flare" or weaponName == "weapon_proxmine" or weaponName == "weapon_ball"  or weaponName == "weapon_molotov" or weaponName == "weapon_grenade" or weaponName == "weapon_bzgas" then
        GiveWeaponToPed(ped, GetHashKey(weaponName), 1, false, false)
        SetPedAmmo(ped, GetHashKey(weaponName), 1)
        SetCurrentPedWeapon(ped, GetHashKey(weaponName), true)
        TriggerEvent('weapons:client:SetCurrentWeapon', weaponData, shootbool)
        currentWeapon = weaponName
    elseif weaponName == "weapon_snowball" then
        GiveWeaponToPed(ped, GetHashKey(weaponName), 10, false, false)
        SetPedAmmo(ped, GetHashKey(weaponName), 10)
        SetCurrentPedWeapon(ped, GetHashKey(weaponName), true)
        TriggerServerEvent('MRFW:Server:RemoveItem', weaponName, 1)
        TriggerEvent('weapons:client:SetCurrentWeapon', weaponData, shootbool)
        currentWeapon = weaponName
    else
        TriggerEvent('weapons:client:SetCurrentWeapon', weaponData, shootbool)
        MRFW.Functions.TriggerCallback("weapon:server:GetWeaponAmmo", function(result, name)
            local ammo = tonumber(result)
            if weaponName == "weapon_petrolcan" or weaponName == "weapon_fireextinguisher" then
                ammo = 4000
            end
            if name ~= weaponName then
                ammo = 0
            end
            GiveWeaponToPed(ped, GetHashKey(weaponName), 0, false, false)
            SetPedAmmo(ped, GetHashKey(weaponName), ammo)
            SetCurrentPedWeapon(ped, GetHashKey(weaponName), true)
            if weaponData.info.attachments ~= nil then
                for _, attachment in pairs(weaponData.info.attachments) do
                    GiveWeaponComponentToPed(ped, GetHashKey(weaponName), GetHashKey(attachment.component))
                end
            end
            currentWeapon = weaponName
        end, CurrentWeaponData)
    end
end)

RegisterNetEvent('inventory:client:CheckWeapon', function(weaponName)
    local ped = PlayerPedId()
    if currentWeapon == weaponName then
        TriggerEvent('weapons:ResetHolster')
        SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
        RemoveAllPedWeapons(ped, true)
        currentWeapon = nil
    end
end)

RegisterNetEvent('inventory:client:AddDropItem', function(dropId, player, coords)
    local forward = GetEntityForwardVector(GetPlayerPed(GetPlayerFromServerId(player)))
	local x, y, z = table.unpack(coords + forward * 0.5)
    Drops[dropId] = {
        id = dropId,
        coords = {
            x = x,
            y = y,
            z = z - 0.3,
        },
    }
end)

RegisterNetEvent('inventory:client:RemoveDropItem', function(dropId)
    Drops[dropId] = nil
    DropsNear[dropId] = nil
end)

RegisterNetEvent('inventory:client:DropItemAnim', function()
    local ped = PlayerPedId()
    SendNUIMessage({
        action = "close",
    })
    TriggerEvent('dpemote:custom:animation', {"pickup"})
    -- RequestAnimDict("pickup_object")
    -- while not HasAnimDictLoaded("pickup_object") do
        -- Wait(5)
    -- end
    -- TaskPlayAnim(ped, "pickup_object" ,"pickup_low" ,8.0, -8.0, -1, 1, 0, false, false, false )
    Wait(2000)
    ClearPedTasks(ped)
end)

RegisterNetEvent('inventory:client:SetCurrentStash', function(stash)
    CurrentStash = stash
end)

-- Commands

RegisterCommand('closeinv', function()
    closeInventory()
end, false)

RegisterNetEvent('close:inventory:bug', function(data)
    closeInventory()
end)

RegisterCommand('inventory', function()
    if not isCrafting and not inInventory then
        if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] and not IsPauseMenuActive() then
            local ped = PlayerPedId()
            local curVeh = nil
            local VendingMachine = GetClosestVending()

            if IsPedInAnyVehicle(ped) then -- Is Player In Vehicle
                local vehicle = GetVehiclePedIsIn(ped, false)
                CurrentGlovebox = MRFW.Functions.GetPlate(vehicle)
                curVeh = vehicle
                CurrentVehicle = nil
            else
                local vehicle = MRFW.Functions.GetClosestVehicle()
                if vehicle ~= 0 and vehicle ~= nil then
                    local pos = GetEntityCoords(ped)
                    local trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
                    if (IsBackEngine(GetEntityModel(vehicle))) then
                        trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, 2.5, 0)
                    end
                    if #(pos - trunkpos) < 2.0 and not IsPedInAnyVehicle(ped) then
                        if GetVehicleDoorLockStatus(vehicle) < 2 then
                            CurrentVehicle = MRFW.Functions.GetPlate(vehicle)
                            curVeh = vehicle
                            CurrentGlovebox = nil
                        else
                            MRFW.Functions.Notify("Vehicle Locked", "error")
                            return
                        end
                    else
                        CurrentVehicle = nil
                    end
                else
                    CurrentVehicle = nil
                end
            end

            if CurrentVehicle then -- Trunk
                local vehicleClass = GetVehicleClass(curVeh)
                local maxweight = 0
                local slots = 0
                local model = GetEntityModel(curVeh)
                local vehname = GetDisplayNameFromVehicleModel(model):lower()
                print(vehname)
                if MRFW.Shared.Vehicles[vehname] ~= nil then
                    if MRFW.Shared.Vehicles[vehname]['weight'] ~= nil then
                        if MRFW.Shared.Vehicles[vehname]['slot'] ~= nil then
                            maxweight = MRFW.Shared.Vehicles[vehname]['weight']
                            slots = MRFW.Shared.Vehicles[vehname]['slot']
                        else
                            MRFW.Functions.Notify('Hmm. this is wierd contact developer and give them this vehicle name | '..vehname, 'error')
                        end
                    else
                        MRFW.Functions.Notify('Hmm. this is wierd contact developer and give them this vehicle name | '..vehname, 'error')
                    end
                else
                    if vehicleClass == 0 then
                        maxweight = 800000
                        slots = 80
                    elseif vehicleClass == 1 then
                        maxweight = 800000
                        slots = 100
                    elseif vehicleClass == 2 then
                        maxweight = 800000
                        slots = 90
                    elseif vehicleClass == 3 then
                        maxweight = 600000
                        slots = 70
                    elseif vehicleClass == 4 then
                        maxweight = 500000
                        slots = 80
                    elseif vehicleClass == 5 then
                        maxweight = 500000
                        slots = 70
                    elseif vehicleClass == 6 then
                        maxweight = 600000
                        slots = 70
                    elseif vehicleClass == 7 then
                        maxweight = 400000
                        slots = 60
                    elseif vehicleClass == 8 then
                        maxweight = 100000
                        slots = 10
                    elseif vehicleClass == 9 then
                        maxweight = 600000
                        slots = 50
                    elseif vehicleClass == 12 then
                        maxweight = 1600000
                        slots = 100
                    elseif vehicleClass == 13 then
                        maxweight = 0
                        slots = 0
                    elseif vehicleClass == 14 then
                        maxweight = 300000
                        slots = 50
                    elseif vehicleClass == 15 then
                        maxweight = 300000
                        slots = 50
                    elseif vehicleClass == 16 then
                        maxweight = 300000
                        slots = 50
                    else
                        maxweight = 60000
                        slots = 35
                    end
                end
                local other = {
                    maxweight = maxweight,
                    slots = slots,
                }
                TriggerServerEvent("inventory:server:OpenInventory", "trunk", CurrentVehicle, other)
                OpenTrunk()
            elseif CurrentGlovebox then
                TriggerServerEvent("inventory:server:OpenInventory", "glovebox", CurrentGlovebox)
            elseif CurrentDrop then
                TriggerServerEvent("inventory:server:OpenInventory", "drop", CurrentDrop)
            elseif VendingMachine then
                local ShopItems = {}
                ShopItems.label = "Vending Machine"
                ShopItems.items = Config.VendingItem
                ShopItems.slots = #Config.VendingItem
                TriggerServerEvent("inventory:server:OpenInventory", "shop", "Vendingshop_"..math.random(1, 99), ShopItems)
            else
                TriggerServerEvent("inventory:server:OpenInventory")
                openAnim()
            end
        end
    end
end)

RegisterKeyMapping('inventory', 'Open Inventory', 'keyboard', 'TAB')

RegisterCommand('hotbar', function()
    isHotbar = not isHotbar
    if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] and not IsPauseMenuActive() then
        ToggleHotbar(isHotbar)
    end
end)

RegisterKeyMapping('hotbar', 'Toggles keybind slots', 'keyboard', 'z')

for i = 1, 5 do
    RegisterCommand('slot' .. i,function()
        if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] and not IsPauseMenuActive() then
            if i == 6 then
                i = MaxInventorySlots
            end
            TriggerServerEvent("inventory:server:UseItemSlot", i)
        end
    end)
    RegisterKeyMapping('slot' .. i, 'Uses the item in slot ' .. i, 'keyboard', i)
end

RegisterNetEvent('aj-inventory:client:giveAnim', function()
    LoadAnimDict('mp_common')
	TaskPlayAnim(PlayerPedId(), 'mp_common', 'givetake1_b', 8.0, 1.0, -1, 16, 0, 0, 0, 0)
end)

-- NUI

RegisterNUICallback('RobMoney', function(data)
    TriggerServerEvent("police:server:RobPlayer", data.TargetId)
end)

RegisterNUICallback('Notify', function(data)
    MRFW.Functions.Notify(data.message, data.type)
end)

RegisterNUICallback('GetWeaponData', function(data, cb)
    local data = {
        WeaponData = MRFW.Shared.Items[data.weapon],
        AttachmentData = FormatWeaponAttachments(data.ItemData)
    }
    cb(data)
end)

RegisterNUICallback('RemoveAttachment', function(data, cb)
    local ped = PlayerPedId()
    local WeaponData = MRFW.Shared.Items[data.WeaponData.name]
    local label = MRFW.Shared.Items
    local Attachment = WeaponAttachments[WeaponData.name:upper()][data.AttachmentData.attachment]

    MRFW.Functions.TriggerCallback('weapons:server:RemoveAttachment', function(NewAttachments)
        if NewAttachments ~= false then
            local Attachies = {}
            RemoveWeaponComponentFromPed(ped, GetHashKey(data.WeaponData.name), GetHashKey(Attachment.component))
            for k, v in pairs(NewAttachments) do
                for wep, pew in pairs(WeaponAttachments[WeaponData.name:upper()]) do
                    if v.component == pew.component then
                        item = pew.item
                        Attachies[#Attachies+1] = {
                            attachment = pew.item,
                            label = MRFW.Shared.Items[item].label,
                        }
                    end
                end
            end
            local DJATA = {
                Attachments = Attachies,
                WeaponData = WeaponData,
            }
            cb(DJATA)
        else
            RemoveWeaponComponentFromPed(ped, GetHashKey(data.WeaponData.name), GetHashKey(Attachment.component))
            cb({})
        end
    end, data.AttachmentData, data.WeaponData)
end)

RegisterNUICallback('getCombineItem', function(data, cb)
    cb(MRFW.Shared.Items[data.item])
end)

RegisterNUICallback("CloseInventory", function()
    if currentOtherInventory == "none-inv" then
        CurrentDrop = nil
        CurrentVehicle = nil
        CurrentGlovebox = nil
        CurrentStash = nil
        SetNuiFocus(false, false)
        inInventory = false
        TriggerScreenblurFadeOut(1000)
        ClearPedTasks(PlayerPedId())
        return
    end
    if CurrentVehicle ~= nil then
        CloseTrunk()
        TriggerServerEvent("inventory:server:SaveInventory", "trunk", CurrentVehicle)
        CurrentVehicle = nil
    elseif CurrentGlovebox ~= nil then
        TriggerServerEvent("inventory:server:SaveInventory", "glovebox", CurrentGlovebox)
        CurrentGlovebox = nil
    elseif CurrentStash ~= nil then
        TriggerServerEvent("inventory:server:SaveInventory", "stash", CurrentStash)
        CurrentStash = nil
    else
        TriggerServerEvent("inventory:server:SaveInventory", "drop", CurrentDrop)
        CurrentDrop = nil
    end
    Wait(50)
    TriggerScreenblurFadeOut(1000)
    SetNuiFocus(false, false)
    inInventory = false
end)

RegisterNUICallback("UseItem", function(data)
    TriggerServerEvent("inventory:server:UseItem", data.inventory, data.item)
end)

RegisterNUICallback("combineItem", function(data)
    Wait(150)
    TriggerServerEvent('inventory:server:combineItem', data.reward, data.fromItem, data.toItem)
end)

RegisterNUICallback('combineWithAnim', function(data)
    local ped = PlayerPedId()
    local combineData = data.combineData
    local aDict = combineData.anim.dict
    local aLib = combineData.anim.lib
    local animText = combineData.anim.text
    local animTimeout = combineData.anim.timeOut

    MRFW.Functions.Progressbar("combine_anim", animText, animTimeout, false, true, {
        disableMovement = false,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = aDict,
        anim = aLib,
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(ped, aDict, aLib, 1.0)
        TriggerServerEvent('inventory:server:combineItem', combineData.reward, data.requiredItem, data.usedItem)
    end, function() -- Cancel
        StopAnimTask(ped, aDict, aLib, 1.0)
        MRFW.Functions.Notify("Failed!", "error")
    end)
end)

RegisterNUICallback("SetInventoryData", function(data)
    TriggerServerEvent("inventory:server:SetInventoryData", data.fromInventory, data.toInventory, data.fromSlot, data.toSlot, data.fromAmount, data.toAmount)
end)

RegisterNUICallback("PlayDropSound", function()
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

RegisterNUICallback("PlayDropFail", function()
    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
end)

RegisterNUICallback("GiveItem", function(data)
    local player, distance = MRFW.Functions.GetClosestPlayer(GetEntityCoords(PlayerPedId()))
    if player ~= -1 and distance < 3 then
        if (data.inventory == 'player') then
            local playerId = GetPlayerServerId(player)
            SetCurrentPedWeapon(PlayerPedId(),'WEAPON_UNARMED',true)
            TriggerServerEvent("inventory:server:GiveItem", playerId, data.item.name, data.amount, data.item.slot)
        else
            MRFW.Functions.Notify("You do not own this item!", "error")
        end
    else
        MRFW.Functions.Notify("No one nearby!", "error")
    end
end)

-- Threads

CreateThread(function()
    while true do
        local sleep = 1000
        if DropsNear then
            for k, v in pairs(DropsNear) do
                if DropsNear[k] then
                    sleep = 0
                    DrawMarker(2, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.15, 120, 10, 20, 155, false, false, false, 1, false, false, false)
                end
            end
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        if Drops and next(Drops) then
            local pos = GetEntityCoords(PlayerPedId(), true)
            for k, v in pairs(Drops) do
                if Drops[k] then
                    local dist = #(pos - vector3(v.coords.x, v.coords.y, v.coords.z))
                    if dist < 7.5 then
                        DropsNear[k] = v
                        if dist < 2 then
                            CurrentDrop = k
                        else
                            CurrentDrop = nil
                        end
                    else
                        DropsNear[k] = nil
                    end
                end
            end
        else
            DropsNear = {}
        end
        Wait(500)
    end
end)

local function HasItem(list, item)

    for i = 1, #list do

        if item == list[i] then
            return true
        end
    end

    return false
end

AddEventHandler("inventory:server:SearchLocalVehicleInventory", function(plate, list, cb)
local trunk = Trunks[plate]
local glovebox = Gloveboxes[plate]
local result = false

if trunk ~= nil then
    for k, v in pairs(trunk.items) do
        local ITEM = trunk.items[k].name
        if HasItem(list, ITEM) then
            RESULT = true
        end
    end
else
    trunk = GetOwnedVehicleItems(plate)

    for k, v in pairs(TRUNK) do

        local ITEM = TRUNK[k].name
        if HasItem(list, ITEM) then
            RESULT = true
        end
    end

end

if glovebox ~= nil then
    for k, v in pairs(glovebox.items) do

        local ITEM = glovebox.items[k].name
        if HasItem(list, ITEM) then
            RESULT = true
        end
    end
else
    glovebox = GetOwnedVehicleGloveboxItems(plate)

    for k, v in pairs(glovebox) do
        local ITEM = glovebox[k].name
        if HasItem(list, ITEM) then
            RESULT = true
        end
    end
end
cb(RESULT)
end)

-------All Crafting----------

---------normal crafting-------
local function ItemsToItemInfo()
	itemInfos = {
		[1] = {nil},
		[2] = {nil},
		[3] = {nil},
		[4] = {nil},
		[5] = {nil},
		[6] = {nil},
		[7] = {nil},
		[8] = {nil},
		[9] = {nil},
		[10] = {nil},
        [11] = {nil},
        [12] = {nil},
        [13] = {nil},
        [14] = {nil},
	}

	local items = {}
	for k, item in pairs(Config.CraftingItems) do
		local itemInfo = MRFW.Shared.Items[item.name:lower()]
		items[item.slot] = {
			name = itemInfo["name"],
			amount = tonumber(item.amount),
			info = itemInfos[item.slot],
			label = itemInfo["label"],
			description = itemInfo["description"] or "",
			weight = itemInfo["weight"],
			type = itemInfo["type"],
			unique = itemInfo["unique"],
			useable = itemInfo["useable"],
			image = itemInfo["image"],
			slot = item.slot,
			costs = item.costs,
			threshold = item.threshold,
			points = item.points,
		}
	end
	Config.CraftingItems = items
end

local function GetThresholdItems()
	ItemsToItemInfo()
	local items = {}
	for k, item in pairs(Config.CraftingItems) do
		if MRFW.Functions.GetPlayerData().metadata["craftingrep"] >= Config.CraftingItems[k].threshold then
			items[k] = Config.CraftingItems[k]
		end
	end
	return items
end

RegisterNetEvent('inventory:client:CraftItems', function(itemName, itemCosts, amount, toSlot, points)
    local ped = PlayerPedId()
    SendNUIMessage({
        action = "close",
    })
    isCrafting = true
    MRFW.Functions.Progressbar("repair_vehicle", "Crafting..", (math.random(2000, 5000) * amount), false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {
		animDict = "mini@repair",
		anim = "fixing_a_player",
		flags = 16,
	}, {}, {}, function() -- Done
		StopAnimTask(ped, "mini@repair", "fixing_a_player", 1.0)
        TriggerServerEvent("inventory:server:CraftItems", itemName, itemCosts, amount, toSlot, points)
        TriggerEvent('inventory:client:ItemBox', MRFW.Shared.Items[itemName], 'add')
        isCrafting = false
	end, function() -- Cancel
		StopAnimTask(ped, "mini@repair", "fixing_a_player", 1.0)
        MRFW.Functions.Notify("Failed", "error")
        isCrafting = false
	end)
end)

RegisterNetEvent('crafting:normal', function()
    local crafting = {}
    crafting.label = "Crafting"
    crafting.items = GetThresholdItems()
    TriggerServerEvent("inventory:server:OpenInventory", "crafting", math.random(1, 99), crafting)
end)


---------Attachment----------

local function SetupAttachmentItemsInfo()
	itemInfos = {
		[1] = {nil},
		[2] = {nil},
		[3] = {nil},
		[4] = {nil},
		[5] = {nil},
		[6] = {nil},
		[7] = {nil},
		[8] = {nil},
		[9] = {nil},
		[10] = {nil},
        [11] = {nil},
        [12] = {nil},
        [13] = {nil},
	}

	local items = {}
	for k, item in pairs(Config.AttachmentCrafting["items"]) do
		local itemInfo = MRFW.Shared.Items[item.name:lower()]
		items[item.slot] = {
			name = itemInfo["name"],
			amount = tonumber(item.amount),
			info = itemInfos[item.slot],
			label = itemInfo["label"],
			description = itemInfo["description"] or "",
			weight = itemInfo["weight"],
			unique = itemInfo["unique"],
			useable = itemInfo["useable"],
			image = itemInfo["image"],
			slot = item.slot,
			costs = item.costs,
			threshold = item.threshold,
			points = item.points,
		}
	end
	Config.AttachmentCrafting["items"] = items
end


local function GetAttachmentThresholdItems()
	SetupAttachmentItemsInfo()
	local items = {}
	for k, item in pairs(Config.AttachmentCrafting["items"]) do
		if MRFW.Functions.GetPlayerData().metadata["attachmentcraftingrep"] >= Config.AttachmentCrafting["items"][k].threshold then
			items[k] = Config.AttachmentCrafting["items"][k]
		end
	end
	return items
end

RegisterNetEvent('inventory:client:CraftAttachment', function(itemName, itemCosts, amount, toSlot, points)
    local ped = PlayerPedId()
    SendNUIMessage({
        action = "close",
    })
    isCrafting = true
    MRFW.Functions.Progressbar("repair_vehicle", "Crafting..", (math.random(2000, 5000) * amount), false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {
		animDict = "mini@repair",
		anim = "fixing_a_player",
		flags = 16,
	}, {}, {}, function() -- Done
		StopAnimTask(ped, "mini@repair", "fixing_a_player", 1.0)
        TriggerServerEvent("inventory:server:CraftAttachment", itemName, itemCosts, amount, toSlot, points)
        TriggerEvent('inventory:client:ItemBox', MRFW.Shared.Items[itemName], 'add')
        isCrafting = false
	end, function() -- Cancel
		StopAnimTask(ped, "mini@repair", "fixing_a_player", 1.0)
        MRFW.Functions.Notify("Failed", "error")
        isCrafting = false
	end)
end)

RegisterNetEvent('crafting:attachement', function()
    local crafting = {}
    crafting.label = "Attachment Crafting"
    crafting.items = GetAttachmentThresholdItems()
    TriggerServerEvent("inventory:server:OpenInventory", "attachment_crafting", math.random(1, 99), crafting)
end)


----------------------pasta------------------------

local function pastaInfo()
	itemInfos = {
		[1] = {nil},
		[2] = {nil},
		[3] = {nil},
		[4] = {nil},
		[5] = {nil},
    }

	local items = {}
	for k, item in pairs(Config.pastaItems) do
		local itemInfo = MRFW.Shared.Items[item.name:lower()]
		items[item.slot] = {
			name = itemInfo["name"],
			amount = tonumber(item.amount),
			info = itemInfos[item.slot],
			label = itemInfo["label"],
			description = itemInfo["description"] or "",
			weight = itemInfo["weight"],
			type = itemInfo["type"],
			unique = itemInfo["unique"],
			useable = itemInfo["useable"],
			image = itemInfo["image"],
			slot = item.slot,
			costs = item.costs,
			threshold = item.threshold,
			points = item.points,
		}
	end
	Config.pastaItems = items
end

local function GetThresholdpastaItems()
	pastaInfo()
	local items = {}
	for k, item in pairs(Config.pastaItems) do
		if MRFW.Functions.GetPlayerData().metadata["pastarep"] >= Config.pastaItems[k].threshold then
			items[k] = Config.pastaItems[k]
		end
	end
	return items
end

RegisterNetEvent('inventory:client:pastaItems', function(itemName, itemCosts, amount, toSlot, points)
    local ped = PlayerPedId()
    SendNUIMessage({
        action = "close",
    })
    isCrafting = true
    MRFW.Functions.Progressbar("repair_vehicle", "Cooking..", (math.random(2000, 5000) * amount), false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {
		animDict = "mini@repair",
		anim = "fixing_a_player",
		flags = 16,
	}, {}, {}, function() -- Done
		StopAnimTask(ped, "mini@repair", "fixing_a_player", 1.0)
        TriggerServerEvent("inventory:server:pastaItems", itemName, itemCosts, amount, toSlot, points)
        TriggerEvent('inventory:client:ItemBox', MRFW.Shared.Items[itemName], 'add')
        isCrafting = false
	end, function() -- Cancel
		StopAnimTask(ped, "mini@repair", "fixing_a_player", 1.0)
        MRFW.Functions.Notify("Failed", "error")
        isCrafting = false
	end)
end)

RegisterNetEvent('crafting:pasta', function()
    local crafting = {}
    crafting.label = "Pasta"
    crafting.items = GetThresholdpastaItems()
    TriggerServerEvent("inventory:server:OpenInventory", "pasta_crafting", math.random(1, 99), crafting)
end)


----------------------------tea-------------------------

local function teaInfo()
	itemInfos = {
		[1] = {nil},
		[2] = {nil},
		[3] = {nil},
		[4] = {nil},
		[5] = {nil},
    }

	local items = {}
	for k, item in pairs(Config.teaItems) do
		local itemInfo = MRFW.Shared.Items[item.name:lower()]
		items[item.slot] = {
			name = itemInfo["name"],
			amount = tonumber(item.amount),
			info = itemInfos[item.slot],
			label = itemInfo["label"],
			description = itemInfo["description"] or "",
			weight = itemInfo["weight"],
			type = itemInfo["type"],
			unique = itemInfo["unique"],
			useable = itemInfo["useable"],
			image = itemInfo["image"],
			slot = item.slot,
			costs = item.costs,
			threshold = item.threshold,
			points = item.points,
		}
	end
	Config.teaItems = items
end

local function GetThresholdteaItems()
	teaInfo()
	local items = {}
	for k, item in pairs(Config.teaItems) do
		if MRFW.Functions.GetPlayerData().metadata["tearep"] >= Config.teaItems[k].threshold then
			items[k] = Config.teaItems[k]
		end
	end
	return items
end

RegisterNetEvent('inventory:client:teaItems', function(itemName, itemCosts, amount, toSlot, points)
    local ped = PlayerPedId()
    SendNUIMessage({
        action = "close",
    })
    isCrafting = true
    MRFW.Functions.Progressbar("repair_vehicle", "Cooking..", (math.random(2000, 5000) * amount), false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {
		animDict = "mini@repair",
		anim = "fixing_a_player",
		flags = 16,
	}, {}, {}, function() -- Done
		StopAnimTask(ped, "mini@repair", "fixing_a_player", 1.0)
        TriggerServerEvent("inventory:server:teaItems", itemName, itemCosts, amount, toSlot, points)
        TriggerEvent('inventory:client:ItemBox', MRFW.Shared.Items[itemName], 'add')
        isCrafting = false
	end, function() -- Cancel
		StopAnimTask(ped, "mini@repair", "fixing_a_player", 1.0)
        MRFW.Functions.Notify("Failed", "error")
        isCrafting = false
	end)
end)


RegisterNetEvent('crafting:tea', function()
    local crafting = {}
    crafting.label = "Tea"
    crafting.items = GetThresholdteaItems()
    TriggerServerEvent("inventory:server:OpenInventory", "tea_crafting", math.random(1, 99), crafting)
end)


--------------------------------mcd------------------------------
local function mcdInfo()
	itemInfos = {
		[1] = {costs =  MRFW.Shared.Items["bread"]["label"] .. ": 1x,"..
                        MRFW.Shared.Items["veggies"]["label"] .. ": 1x,"..
                        MRFW.Shared.Items["sauce"]["label"] .. ": 1x,"},

		[2] = {costs =  MRFW.Shared.Items["bread"]["label"] .. ": 1x,"..
                        MRFW.Shared.Items["veggies"]["label"] .. ": 1x,"..
                        MRFW.Shared.Items["sauce"]["label"] .. ": 1x,"..
                        MRFW.Shared.Items["chickenpatty"]["label"] .. ": 1x,"},

		[3] = {costs =  MRFW.Shared.Items["bread"]["label"] .. ": 1x,"..
                        MRFW.Shared.Items["veggies"]["label"] .. ": 1x,"..
                        MRFW.Shared.Items["cheese"]["label"] .. ": 1x,"..
                        MRFW.Shared.Items["sauce"]["label"] .. ": 1x,"..
                        MRFW.Shared.Items["vegpatty"]["label"] .. ": 1x,"},

		[4] = {costs =  MRFW.Shared.Items["bread"]["label"] .. ": 1x,"..
                        MRFW.Shared.Items["veggies"]["label"] .. ": 1x,"..
                        MRFW.Shared.Items["cheese"]["label"] .. ": 1x,"..
                        MRFW.Shared.Items["sauce"]["label"] .. ": 1x,"..
                        MRFW.Shared.Items["chickenpatty"]["label"] .. ": 1x,"},

		[5] = {costs =  MRFW.Shared.Items["potato"]["label"] .. ": 2x,"..
                        MRFW.Shared.Items["oil"]["label"] .. ": 1x,"..
                        MRFW.Shared.Items["masala"]["label"] .. ": 1x,"..
                        MRFW.Shared.Items["salt"]["label"] .. ": 1x,"},

		[6] = {costs =  MRFW.Shared.Items["oil"]["label"] .. ": 1x,"..
                        MRFW.Shared.Items["cheese"]["label"] .. ": 1x,"..
                        MRFW.Shared.Items["bread"]["label"] .. ": 2x,"..
                        MRFW.Shared.Items["salt"]["label"] .. ": 1x,"..
                        MRFW.Shared.Items["veggies"]["label"] .. ": 1x,"},

		[7] = {costs =  MRFW.Shared.Items["bun"]["label"] .. ": 2x,"..
                        MRFW.Shared.Items["veggies"]["label"] .. ": 2x,"..
                        MRFW.Shared.Items["cheese"]["label"] .. ": 3x,"..
                        MRFW.Shared.Items["sauce"]["label"] .. ": 2x,"..
                        MRFW.Shared.Items["vegpatty"]["label"] .. ": 3x,"},

		[8] = {costs =  MRFW.Shared.Items["cuttedchicken"]["label"] .. ": 1x,"..
                        MRFW.Shared.Items["bread"]["label"] .. ": 2x,"..
                        MRFW.Shared.Items["sauce"]["label"] .. ": 2x,"},

		[9] = {costs =  MRFW.Shared.Items["paneer"]["label"] .. ": 1x,"..
                        MRFW.Shared.Items["masala"]["label"] .. ": 1x,"..
                        MRFW.Shared.Items["bun"]["label"] .. ": 1x,"..
                        MRFW.Shared.Items["veggies"]["label"] .. ": 1x,"..
                        MRFW.Shared.Items["cheese"]["label"] .. ": 1x,"..
                        MRFW.Shared.Items["sauce"]["label"] .. ": 1x,"},

		[10] = {costs = MRFW.Shared.Items["egg"]["label"] .. ": 1x,"..
                        MRFW.Shared.Items["masala"]["label"] .. ": 1x,"..
                        MRFW.Shared.Items["bun"]["label"] .. ": 1x,"..
                        MRFW.Shared.Items["cheese"]["label"] .. ": 1x,"..
                        MRFW.Shared.Items["salt"]["label"] .. ": 1x,"},

        [11] = {costs = MRFW.Shared.Items["mcd-burger"]["label"] .. ": 1x,"..
                        MRFW.Shared.Items["mcd-fries"]["label"] .. ": 1x,"..
                        MRFW.Shared.Items["mcd-cola"]["label"] .. ": 1x,"},

        [12] = {costs = MRFW.Shared.Items["mcd-burger-c"]["label"] .. ": 1x,"..
                        MRFW.Shared.Items["chicken-fries"]["label"] .. ": 1x,"..
                        MRFW.Shared.Items["mcd-cola"]["label"] .. ": 1x,"},

        [13] = {costs = MRFW.Shared.Items["cuttedchicken"]["label"] .. ": 1x,"..
                        MRFW.Shared.Items["oil"]["label"] .. ": 1x,"..
                        MRFW.Shared.Items["masala"]["label"] .. ": 1x,"..
                        MRFW.Shared.Items["salt"]["label"] .. ": 1x,"},
	}

	local items = {}
	for k, item in pairs(Config.mcdItems) do
		local itemInfo = MRFW.Shared.Items[item.name:lower()]
		items[item.slot] = {
			name = itemInfo["name"],
			amount = tonumber(item.amount),
			info = itemInfos[item.slot],
			label = itemInfo["label"],
			description = itemInfo["description"] or "",
			weight = itemInfo["weight"],
			type = itemInfo["type"],
			unique = itemInfo["unique"],
			useable = itemInfo["useable"],
			image = itemInfo["image"],
			slot = item.slot,
			costs = item.costs,
			threshold = item.threshold,
			points = item.points,
		}
	end
	Config.mcdItems = items
end

local function GetThresholdmcdItems()
	mcdInfo()
	local items = {}
	for k, item in pairs(Config.mcdItems) do
		if MRFW.Functions.GetPlayerData().metadata["mcdrep"] >= Config.mcdItems[k].threshold then
			items[k] = Config.mcdItems[k]
		end
	end
	return items
end

RegisterNetEvent('inventory:client:mcdItems', function(itemName, itemCosts, amount, toSlot, points)
    local ped = PlayerPedId()
    SendNUIMessage({
        action = "close",
    })
    isCrafting = true
    MRFW.Functions.Progressbar("repair_vehicle", "Cooking..", (math.random(2000, 5000) * amount), false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
        TriggerEvent('dpemote:custom:animation', {"bbqf"})
	}, {}, {}, {}, function() -- Done
		TriggerEvent('dpemote:custom:animation', {"c"})
        TriggerServerEvent("inventory:server:mcdItems", itemName, itemCosts, amount, toSlot, points)
        TriggerEvent('inventory:client:ItemBox', MRFW.Shared.Items[itemName], 'add')
        isCrafting = false
	end, function() -- Cancel
		TriggerEvent('dpemote:custom:animation', {"c"})
        MRFW.Functions.Notify("Failed", "error")
        isCrafting = false
	end)
end)

RegisterNetEvent('crafting:mcd', function()
    local crafting = {}
    crafting.label = "mcd"
    crafting.items = GetThresholdmcdItems()
    TriggerServerEvent("inventory:server:OpenInventory", "mcd_crafting", math.random(1, 99), crafting)
end)


-----------------------cooking/dhaba-----------------------

local function dhabaInfo()
	itemInfos = {
		[1] = {nil},
		[2] = {nil},
		[3] = {nil},
		[4] = {nil},
		[5] = {nil},
		[6] = {nil},
		[7] = {nil},
		[8] = {nil},
		[9] = {nil},
		[10] = {nil},
        [11] = {nil},
	}

	local items = {}
	for k, item in pairs(Config.dhabaItems) do
		local itemInfo = MRFW.Shared.Items[item.name:lower()]
		items[item.slot] = {
			name = itemInfo["name"],
			amount = tonumber(item.amount),
			info = itemInfos[item.slot],
			label = itemInfo["label"],
			description = itemInfo["description"] or "",
			weight = itemInfo["weight"],
			type = itemInfo["type"],
			unique = itemInfo["unique"],
			useable = itemInfo["useable"],
			image = itemInfo["image"],
			slot = item.slot,
			costs = item.costs,
			threshold = item.threshold,
			points = item.points,
		}
	end
	Config.dhabaItems = items
end

local function GetThresholddhabaItems()
	dhabaInfo()
	local items = {}
	for k, item in pairs(Config.dhabaItems) do
		if MRFW.Functions.GetPlayerData().metadata["dhabarep"] >= Config.dhabaItems[k].threshold then
			items[k] = Config.dhabaItems[k]
		end
	end
	return items
end

RegisterNetEvent('inventory:client:dhabaItems', function(itemName, itemCosts, amount, toSlot, points)
    local ped = PlayerPedId()
    SendNUIMessage({
        action = "close",
    })
    isCrafting = true
    MRFW.Functions.Progressbar("repair_vehicle", "Cooking..", (math.random(2000, 5000) * amount), false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {
		animDict = "mini@repair",
		anim = "fixing_a_player",
		flags = 16,
	}, {}, {}, function() -- Done
		StopAnimTask(ped, "mini@repair", "fixing_a_player", 1.0)
        TriggerServerEvent("inventory:server:dhabaItems", itemName, itemCosts, amount, toSlot, points)
        TriggerEvent('inventory:client:ItemBox', MRFW.Shared.Items[itemName], 'add')
        isCrafting = false
	end, function() -- Cancel
		StopAnimTask(ped, "mini@repair", "fixing_a_player", 1.0)
        MRFW.Functions.Notify("Failed", "error")
        isCrafting = false
	end)
end)

RegisterNetEvent('crafting:dhaba', function()
    local crafting = {}
    crafting.label = "dhaba"
    crafting.items = GetThresholddhabaItems()
    TriggerServerEvent("inventory:server:OpenInventory", "dhaba_crafting", math.random(1, 99), crafting)
end)

---------------------------mechanic--------------------------

local function mechInfo()
	itemInfos = {
		[1] = {costs = MRFW.Shared.Items["pikit"]["label"] .. ": 2x,"..
                       MRFW.Shared.Items["clutch"]["label"] .. ": 20x,"..
                       MRFW.Shared.Items["wire"]["label"] .. ": 20x,"..
                       MRFW.Shared.Items["plastic"]["label"] .. ": 20x,"..
                       MRFW.Shared.Items["glass"]["label"] .. ": 10x,"},

		[2] = {costs = MRFW.Shared.Items["rubber"]["label"] .. ": 10x,"..
                       MRFW.Shared.Items["weapon_petrolcan"]["label"] .. ": 1x,"..
                       MRFW.Shared.Items["metalscrap"]["label"] .. ": 10x,"..
                       MRFW.Shared.Items["aluminum"]["label"] .. ": 7x,"..
                       MRFW.Shared.Items["steel"]["label"] .. ": 10x,"..
                       MRFW.Shared.Items["wire"]["label"] .. ": 5x,"..
                       MRFW.Shared.Items["ironoxide"]["label"] .. ": 5x,"..
                       MRFW.Shared.Items["aluminumoxide"]["label"] .. ": 5x,"},

		[3] = {costs = MRFW.Shared.Items["metalscrap"]["label"] .. ": 15x,"..
                       MRFW.Shared.Items["steel"]["label"] .. ": 17x,"..
                       MRFW.Shared.Items["iron"]["label"] .. ": 9x,"..
                       MRFW.Shared.Items["rubber"]["label"] .. ": 15x,"..
                       MRFW.Shared.Items["screwdriverset"]["label"] .. ": 1x,"},

		[4] = {costs = MRFW.Shared.Items["metalscrap"]["label"] .. ": 10x,"..
                       MRFW.Shared.Items["steel"]["label"] .. ": 8x,"..
                       MRFW.Shared.Items["iron"]["label"] .. ": 8x,"},

		[5] = {costs = MRFW.Shared.Items["metalscrap"]["label"] .. ": 20x,"..
                       MRFW.Shared.Items["steel"]["label"] .. ": 17x,"..
                       MRFW.Shared.Items["iron"]["label"] .. ": 12x,"..
                       MRFW.Shared.Items["plastic"]["label"] .. ": 15x,"},
	}

	local items = {}
	for k, item in pairs(Config.mechItems) do
		local itemInfo = MRFW.Shared.Items[item.name:lower()]
		items[item.slot] = {
			name = itemInfo["name"],
			amount = tonumber(item.amount),
			info = itemInfos[item.slot],
			label = itemInfo["label"],
			description = itemInfo["description"] or "",
			weight = itemInfo["weight"],
			type = itemInfo["type"],
			unique = itemInfo["unique"],
			useable = itemInfo["useable"],
			image = itemInfo["image"],
			slot = item.slot,
			costs = item.costs,
			threshold = item.threshold,
			points = item.points,
		}
	end
	Config.mechItems = items
end

local function GetThresholdmechItems()
	mechInfo()
	local items = {}
	for k, item in pairs(Config.mechItems) do
		if MRFW.Functions.GetPlayerData().metadata["mechrep"] >= Config.mechItems[k].threshold then
			items[k] = Config.mechItems[k]
		end
	end
	return items
end

RegisterNetEvent('inventory:client:mechItems', function(itemName, itemCosts, amount, toSlot, points)
    local ped = PlayerPedId()
    SendNUIMessage({
        action = "close",
    })
    isCrafting = true
    MRFW.Functions.Progressbar("repair_vehicle", "Crafting..", (math.random(2000, 5000) * amount), false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {
		animDict = "mini@repair",
		anim = "fixing_a_player",
		flags = 16,
	}, {}, {}, function() -- Done
		StopAnimTask(ped, "mini@repair", "fixing_a_player", 1.0)
        TriggerServerEvent("inventory:server:mechItems", itemName, itemCosts, amount, toSlot, points)
        TriggerEvent('inventory:client:ItemBox', MRFW.Shared.Items[itemName], 'add')
        isCrafting = false
	end, function() -- Cancel
		StopAnimTask(ped, "mini@repair", "fixing_a_player", 1.0)
        MRFW.Functions.Notify("Failed", "error")
        isCrafting = false
	end)
end)

RegisterNetEvent('crafting:mech', function()
    local crafting = {}
    crafting.label = "Mechanic"
    crafting.items = GetThresholdmechItems()
    TriggerServerEvent("inventory:server:OpenInventory", "mech_crafting", math.random(1, 99), crafting)
end)

RegisterNetEvent('open:inventory:bag',function(name)
    TriggerEvent("inventory:client:SetCurrentStash", "storage_bags_"..name)
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "storage_bags_"..name, {
        maxweight = 300000,
        slots = 100,
    })
end)

function I()
    local armIndex = GetPedDrawableVariation(PlayerPedId(), 8)
    local model = GetEntityModel(PlayerPedId())
    local retval = false
    if model == GetHashKey("mp_m_freemode_01") then
        if Config.BagMale[armIndex] ~= nil and Config.BagMale[armIndex] then
            retval = false
        end
    else
        if Config.BagFemale[armIndex] ~= nil and Config.BagFemale[armIndex] then
            retval = false
        end
    end
    return retval
end

Citizen.CreateThread(function()
    while true do
        local sleep = 5000
        local ped = PlayerPedId()
        local bag = GetPedDrawableVariation(ped, 5)
        local model = GetEntityModel(ped)
        local hasbag = MRFW.Functions.HasItem('bag')
        if hasbag then
            if LocalPlayer.state['isLoggedIn'] then
                if PlayerData.job.name == 'police' then
                    if model == GetHashKey("mp_m_freemode_01") then
                        if bag ~= 23 then
                            SetPedComponentVariation(ped, 5, 23, 0, 0)
                        end
                    else
                        if bag ~= 18 then
                            SetPedComponentVariation(ped, 5, 18, 0, 0)
                        end
                    end
                elseif PlayerData.job.name == 'doctor' then
                    if model == GetHashKey("mp_m_freemode_01") then
                        if bag ~= 23 then
                            SetPedComponentVariation(ped, 5, 23, 10, 0)
                        end
                    else
                        if bag ~= 18 then
                            SetPedComponentVariation(ped, 5, 18, 10, 0)
                        end
                    end
                else
                    if model == GetHashKey("mp_m_freemode_01") then
                        if bag ~= 25 then
                            SetPedComponentVariation(ped, 5, 25, 1, 0)
                        end
                    else
                        if bag ~= 20 then
                            SetPedComponentVariation(ped, 5, 20, 1, 0)
                        end
                    end
                end
            else
                sleep = 10000
            end
        else
            sleep = 10000
        end
        Wait(sleep)
    end
end)
