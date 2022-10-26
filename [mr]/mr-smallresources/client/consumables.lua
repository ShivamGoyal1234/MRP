local alcoholCount = 0
local onWeed = false
local ParachuteEquiped = false
local currentVest = nil
local currentVestTexture = nil
local time = 0


CreateThread(function()
    while true do 
        Wait(10)
        if alcoholCount > 0 then
            Wait(1000 * 60 * 15)
            alcoholCount = alcoholCount - 1
        else
            Wait(2000)
        end
    end
end)

local function EquipArmorAnim()
    loadAnimDict("clothingtie")
    TaskPlayAnim(PlayerPedId(), "clothingtie", "try_tie_negative_a", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

function EquipParachuteAnim()
    loadAnimDict("clothingshirt")        
    TaskPlayAnim(PlayerPedId(), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
end

function EcstasyEffect()
    local startStamina = 30
    SetFlash(0, 0, 500, 7000, 500)
    while startStamina > 0 do 
        Wait(1000)
        startStamina = startStamina - 1
        RestorePlayerStamina(PlayerId(), 1.0)
        if math.random(1, 100) < 51 then
            SetFlash(0, 0, 500, 7000, 500)
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08)
        end
    end
    if IsPedRunning(PlayerPedId()) then
        SetPedToRagdoll(PlayerPedId(), math.random(1000, 3000), math.random(1000, 3000), 3, 0, 0, 0)
    end

    startStamina = 0
end


function CrackBaggyEffect()
    local startStamina = 8
    local ped = PlayerPedId()
    AlienEffect()
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.3)
    while startStamina > 0 do 
        Wait(1000)
        if math.random(1, 100) < 10 then
            RestorePlayerStamina(PlayerId(), 1.0)
        end
        startStamina = startStamina - 1
        if math.random(1, 100) < 60 and IsPedRunning(ped) then
            SetPedToRagdoll(ped, math.random(1000, 2000), math.random(1000, 2000), 3, 0, 0, 0)
        end
        if math.random(1, 100) < 51 then
            AlienEffect()
        end
    end
    if IsPedRunning(ped) then
        SetPedToRagdoll(ped, math.random(1000, 3000), math.random(1000, 3000), 3, 0, 0, 0)
    end

    startStamina = 0
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
end

function CokeBaggyEffect()
    local startStamina = 20
    local ped = PlayerPedId()
    AlienEffect()
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
    while startStamina > 0 do 
        Wait(1000)
        if math.random(1, 100) < 20 then
            RestorePlayerStamina(PlayerId(), 1.0)
        end
        startStamina = startStamina - 1
        if math.random(1, 100) < 10 and IsPedRunning(ped) then
            SetPedToRagdoll(ped, math.random(1000, 3000), math.random(1000, 3000), 3, 0, 0, 0)
        end
        if math.random(1, 300) < 10 then
            AlienEffect()
            Wait(math.random(3000, 6000))
        end
    end
    if IsPedRunning(ped) then
        SetPedToRagdoll(ped, math.random(1000, 3000), math.random(1000, 3000), 3, 0, 0, 0)
    end

    startStamina = 0
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
end

function AlienEffect()
    StartScreenEffect("DrugsMichaelAliensFightIn", 3.0, 0)
    Wait(math.random(5000, 8000))
    StartScreenEffect("DrugsMichaelAliensFight", 3.0, 0)
    Wait(math.random(5000, 8000))    
    StartScreenEffect("DrugsMichaelAliensFightOut", 3.0, 0)
    StopScreenEffect("DrugsMichaelAliensFightIn")
    StopScreenEffect("DrugsMichaelAliensFight")
    StopScreenEffect("DrugsMichaelAliensFightOut")
end

local function Reality()
    Citizen.CreateThread(function()
        local playerPed = PlayerPedId()
        DoScreenFadeOut(800)
        Wait(1000)
        ClearTimecycleModifier()
        ResetScenarioTypesEnabled()
        ResetPedMovementClipset(playerPed, 0)
        SetPedIsDrunk(playerPed, false)
        SetPedMotionBlur(playerPed, false)
        DoScreenFadeIn(800)
    end)
end

local function Drunk(level, start, fuckboi)
    Citizen.CreateThread(function()
        local playerPed = PlayerPedId()
        time = time + fuckboi
        if start then
            DoScreenFadeOut(800)
            Wait(1000)
        end
        if level == 0 then
            RequestAnimSet("move_m@drunk@slightlydrunk")
            
            while not HasAnimSetLoaded("move_m@drunk@slightlydrunk") do
                Citizen.Wait(0)
            end
            SetPedMovementClipset(playerPed, "move_m@drunk@slightlydrunk", true)
  
        elseif level == 1 then
            RequestAnimSet("move_m@drunk@moderatedrunk")
            while not HasAnimSetLoaded("move_m@drunk@moderatedrunk") do
                Citizen.Wait(0)
            end
            SetPedMovementClipset(playerPed, "move_m@drunk@moderatedrunk", true)

        elseif level == 2 then
            RequestAnimSet("move_m@drunk@verydrunk")    
            while not HasAnimSetLoaded("move_m@drunk@verydrunk") do
                Citizen.Wait(0)
            end
            SetPedMovementClipset(playerPed, "move_m@drunk@verydrunk", true)

        end
        SetTimecycleModifier("spectator5")
        SetPedMotionBlur(playerPed, true)
        SetPedIsDrunk(playerPed, true)
        if start then
            DoScreenFadeIn(800)
        end
        Citizen.Wait(time)
        Reality()
    end)
end

RegisterNetEvent("consumables:client:UseJoint", function()

    local playerPed = PlayerPedId()
    local armor = 0
  
    if not IsPedInAnyVehicle(playerPed, false) then
        MRFW.Functions.Progressbar("smoke_joint", "Consumming..", 15000, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
            TriggerEvent('dpemote:custom:animation', {"smokeweed"})
        }, {}, {}, {}, function() -- Done
            TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["joint"], "remove")
            Citizen.Wait(3000)
            ClearPedTasksImmediately(playerPed)
            TriggerEvent('dpemote:custom:animation', {"c"})
            armor = GetPedArmour(PlayerPedId())
            if armor == 100.0 then
                MRFW.Functions.Notify("Kam maro re" , "error")
            elseif armor >= 90.0 then
                TriggerServerEvent('hospital:server:SetArmor', 100)
                SetPedArmour(PlayerPedId(), 100)
            elseif armor >= 80.0 then
                TriggerServerEvent('hospital:server:SetArmor', 90)
                SetPedArmour(PlayerPedId(), 90)
            elseif armor >= 70.0 then
                TriggerServerEvent('hospital:server:SetArmor', 80)
                SetPedArmour(PlayerPedId(), 80)
            elseif armor >= 60.0 then
                TriggerServerEvent('hospital:server:SetArmor', 70)
                SetPedArmour(PlayerPedId(), 70)
            elseif armor >= 50.0 then
                TriggerServerEvent('hospital:server:SetArmor', 60)
                SetPedArmour(PlayerPedId(), 60)
            elseif armor >= 40.0 then
                TriggerServerEvent('hospital:server:SetArmor', 50)
                SetPedArmour(PlayerPedId(), 50)
            elseif armor >= 30.0 then
                TriggerServerEvent('hospital:server:SetArmor', 40)
                SetPedArmour(PlayerPedId(), 40)
            elseif armor >= 20.0 then
                TriggerServerEvent('hospital:server:SetArmor', 30)
                SetPedArmour(PlayerPedId(), 30)
            elseif armor >= 10.0 then
                TriggerServerEvent('hospital:server:SetArmor', 20)
                SetPedArmour(PlayerPedId(), 20)
            elseif armor == 0.0 then
                TriggerServerEvent('hospital:server:SetArmor', 10)
                SetPedArmour(PlayerPedId(), 10)
            end
            Citizen.Wait(3000)
            TriggerServerEvent('hud:server:RelieveStress', math.random(18, 25))
            TriggerEvent("evidence:client:SetStatus", "weedsmell", 300)
        end)
    elseif IsPedInAnyVehicle(playerPed, false) then

        MRFW.Functions.Progressbar("smoke_joint", "Consumming..", 18000, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
            TriggerEvent('dpemote:custom:animation', {"smokeweed"})
        }, {}, {}, {}, function() -- Done
            TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["joint"], "remove")
            TriggerEvent('dpemote:custom:animation', {"c"})
            armor = GetPedArmour(PlayerPedId())
            if armor == 100.0 then
                MRFW.Functions.Notify("Kam maro re" , "error")
            elseif armor >= 90.0 then
                TriggerServerEvent('hospital:server:SetArmor', 100)
                SetPedArmour(PlayerPedId(), 100)
            elseif armor >= 80.0 then
                TriggerServerEvent('hospital:server:SetArmor', 90)
                SetPedArmour(PlayerPedId(), 90)
            elseif armor >= 70.0 then
                TriggerServerEvent('hospital:server:SetArmor', 80)
                SetPedArmour(PlayerPedId(), 80)
            elseif armor >= 60.0 then
                TriggerServerEvent('hospital:server:SetArmor', 70)
                SetPedArmour(PlayerPedId(), 70)
            elseif armor >= 50.0 then
                TriggerServerEvent('hospital:server:SetArmor', 60)
                SetPedArmour(PlayerPedId(), 60)
            elseif armor >= 40.0 then
                TriggerServerEvent('hospital:server:SetArmor', 50)
                SetPedArmour(PlayerPedId(), 50)
            elseif armor >= 30.0 then
                TriggerServerEvent('hospital:server:SetArmor', 40)
                SetPedArmour(PlayerPedId(), 40)
            elseif armor >= 20.0 then
                TriggerServerEvent('hospital:server:SetArmor', 30)
                SetPedArmour(PlayerPedId(), 30)
            elseif armor >= 10.0 then
                TriggerServerEvent('hospital:server:SetArmor', 20)
                SetPedArmour(PlayerPedId(), 20)
            elseif armor == 0.0 then
                TriggerServerEvent('hospital:server:SetArmor', 10)
                SetPedArmour(PlayerPedId(), 10)
            end
            Citizen.Wait(3000)
            TriggerServerEvent('hud:server:RelieveStress', math.random(15, 18))
            TriggerEvent("evidence:client:SetStatus", "weedsmell", 300)
        end)
    end
end)

RegisterNetEvent("consumables:client:Usecigarette", function()
    local playerPed = PlayerPedId()
    local armor = 0
    if not IsPedInAnyVehicle(playerPed, false) then
        MRFW.Functions.Progressbar("smoke_joint", "Consumming..", 10000, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
            TriggerEvent('dpemote:custom:animation', {"smoke"})
        }, {}, {}, {}, function() -- Done
            TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["cigarette"], "remove")
            Citizen.Wait(3000)
            ClearPedTasksImmediately(playerPed)
            TriggerEvent('dpemote:custom:animation', {"c"})
            Citizen.Wait(3000)
            TriggerServerEvent('hud:server:RelieveStress', math.random(9, 12))
        end)
    elseif IsPedInAnyVehicle(playerPed, false) then
        MRFW.Functions.Progressbar("smoke_joint", "Consumming..", 12000, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
            TriggerEvent('dpemote:custom:animation', {"smoke"})
        }, {}, {}, {}, function() -- Done
            TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["cigarette"], "remove")
            TriggerEvent('dpemote:custom:animation', {"c"})
            Citizen.Wait(3000)
            TriggerServerEvent('hud:server:RelieveStress', math.random(9, 12))
        end)
    end
end)


local parachuteItemData = nil

RegisterNetEvent("consumables:client:UseParachute", function(ItemData)
    EquipParachuteAnim()
    TriggerServerEvent("MRFW:Server:RemoveItem", ItemData.name, 1, ItemData.slot)
    MRFW.Functions.Progressbar("use_parachute", "parachute using..", 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        local ped = PlayerPedId()
        parachuteItemData = ItemData
        -- TriggerServerEvent("equip:parachute", ItemData)
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["parachute"], "remove")
        SetPedParachuteTintIndex(ped, 7)
        GiveWeaponToPed(ped, GetHashKey("GADGET_PARACHUTE"), 1, false)
        local ParachuteData = {
            outfitData = {
                ["bag"]   = { item = 7, texture = 0},  -- Nek / Das
            }
        }
        TriggerEvent('mr-clothing:client:loadOutfit', ParachuteData)
        ParachuteEquiped = true
        TaskPlayAnim(ped, "clothingshirt", "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    end)
end)

RegisterNetEvent("consumables:client:ResetParachute", function()
    if ParachuteEquiped then 
        EquipParachuteAnim()
        MRFW.Functions.Progressbar("reset_parachute", "Packing parachute..", 5000, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            local ped = PlayerPedId()
            TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["parachute"], "add")
            local ParachuteRemoveData = { 
                outfitData = { 
                    ["bag"] = { item = 0, texture = 0} -- Nek / Das
                }
            }
            TriggerEvent('mr-clothing:client:loadOutfit', ParachuteRemoveData)
            TaskPlayAnim(ped, "clothingshirt", "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
            TriggerServerEvent("mr-smallresources:server:AddParachute", parachuteItemData)
            ParachuteEquiped = false
        end)
    else
        MRFW.Functions.Notify("U dont have a parachute!", "error")
    end
end)

RegisterNetEvent("consumables:client:UseArmor", function()
    EquipArmorAnim()
    if GetPedArmour(PlayerPedId()) >= 100 then MRFW.Functions.Notify('kiya iron man banna chahte ho', 'error') return end
    MRFW.Functions.Progressbar("use_armor", "Putting on the body armour..", 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        armor = GetPedArmour(PlayerPedId())
            if armor >= 95.0 then
                MRFW.Functions.Notify("Armor Increased" , "success")
                TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["armor"], "remove")
                TriggerServerEvent('hospital:server:SetArmor', 100)
                TriggerServerEvent("MRFW:Server:RemoveItem", "armor", 1)
                SetPedArmour(PlayerPedId(), 100)
            elseif armor >= 85.0 then
                MRFW.Functions.Notify("Armor Increased" , "success")
                TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["armor"], "remove")
                TriggerServerEvent('hospital:server:SetArmor', 100)
                TriggerServerEvent("MRFW:Server:RemoveItem", "armor", 1)
                SetPedArmour(PlayerPedId(), 100)
            elseif armor >= 75.0 then
                MRFW.Functions.Notify("Armor Increased" , "success")
                TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["armor"], "remove")
                TriggerServerEvent('hospital:server:SetArmor', 100)
                TriggerServerEvent("MRFW:Server:RemoveItem", "armor", 1)
                SetPedArmour(PlayerPedId(), 100)
            elseif armor >= 65.0 then
                MRFW.Functions.Notify("Armor Increased" , "success")
                TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["armor"], "remove")
                TriggerServerEvent('hospital:server:SetArmor', 100)
                TriggerServerEvent("MRFW:Server:RemoveItem", "armor", 1)
                SetPedArmour(PlayerPedId(), 100)
            elseif armor >= 50.0 then
                MRFW.Functions.Notify("Armor Increased" , "success")
                TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["armor"], "remove")
                TriggerServerEvent('hospital:server:SetArmor', 100)
                TriggerServerEvent("MRFW:Server:RemoveItem", "armor", 1)
                SetPedArmour(PlayerPedId(), 100)
            else 
                TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["armor"], "remove")
                TriggerServerEvent('hospital:server:SetArmor', 50)
                TriggerServerEvent("MRFW:Server:RemoveItem", "armor", 1)
                SetPedArmour(PlayerPedId(), 50)
            end
    end)
end)

RegisterNetEvent("consumables:client:UseArmorplate", function()
    EquipArmorAnim()
    if GetPedArmour(PlayerPedId()) >= 100 then MRFW.Functions.Notify('kiya iron man banna chahte ho', 'error') return end
    MRFW.Functions.Progressbar("use_armor", "Putting on the body armor plate..", 2000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        armor = GetPedArmour(PlayerPedId())
            if armor >= 75.0 then
                MRFW.Functions.Notify("Armor Increased" , "success")
                TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["armorplate"], "remove")
                TriggerServerEvent('hospital:server:SetArmor', 100)
                TriggerServerEvent("MRFW:Server:RemoveItem", "armorplate", 1)
                SetPedArmour(PlayerPedId(), 100)
            elseif armor >= 50.0 then
                MRFW.Functions.Notify("Armor Increased" , "success")
                TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["armorplate"], "remove")
                TriggerServerEvent('hospital:server:SetArmor', armor+25)
                TriggerServerEvent("MRFW:Server:RemoveItem", "armorplate", 1)
                SetPedArmour(PlayerPedId(), armor+25)
            elseif armor >= 25.0 then
                MRFW.Functions.Notify("Armor Increased" , "success")
                TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["armorplate"], "remove")
                TriggerServerEvent('hospital:server:SetArmor', armor+25)
                TriggerServerEvent("MRFW:Server:RemoveItem", "armorplate", 1)
                SetPedArmour(PlayerPedId(), armor+25)
            else 
                TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["armorplate"], "remove")
                TriggerServerEvent('hospital:server:SetArmor', 25)
                TriggerServerEvent("MRFW:Server:RemoveItem", "armorplate", 1)
                SetPedArmour(PlayerPedId(), 25)
            end
    end)
end)

RegisterNetEvent("consumables:client:UseHeavyArmor", function()
    if GetPedArmour(PlayerPedId()) == 100 then MRFW.Functions.Notify('You already have enough armor on!', 'error') return end
    local ped = PlayerPedId()
    local PlayerData = MRFW.Functions.GetPlayerData()
    EquipArmorAnim()
    MRFW.Functions.Progressbar("use_heavyarmor", "Putting on body armour..", 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["heavyarmor"], "remove")
        TriggerServerEvent('hospital:server:SetArmor', 100)
        TriggerServerEvent("MRFW:Server:RemoveItem", "heavyarmor", 1)
        SetPedArmour(ped, 100)
    end)
end)

RegisterNetEvent("consumables:client:ResetArmor", function()
    local ped = PlayerPedId()
    if currentVest ~= nil and currentVestTexture ~= nil then 
        MRFW.Functions.Progressbar("remove_armor", "Removing the body armour..", 2500, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            SetPedComponentVariation(ped, 9, currentVest, currentVestTexture, 2)
            SetPedArmour(ped, 0)
            TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["heavyarmor"], "add")
            TriggerServerEvent("MRFW:Server:AddItem", "heavyarmor", 1)
        end)
    else
        MRFW.Functions.Notify("You\'re not wearing a vest..", "error")
    end
end)

RegisterNetEvent("consumables:client:DrinkAlcohol", function(itemName)
    TriggerEvent('dpemote:custom:animation', {"beer4"})
    MRFW.Functions.Progressbar("snort_coke", "Drinking liquor..", math.random(3000, 6000), false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent('dpemote:custom:animation', {"c"})
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
        TriggerServerEvent("MRFW:Server:RemoveItem", itemName, 1)
        TriggerServerEvent("MRFW:Server:SetMetaData", "thirst", MRFW.Functions.GetPlayerData().metadata["thirst"] + Consumeables[itemName])
        Drunk(2, true, 15000)
        alcoholCount = alcoholCount + 1
        if alcoholCount > 1 and alcoholCount < 4 then
            TriggerEvent("evidence:client:SetStatus", "alcohol", 200)
        elseif alcoholCount >= 4 then
            TriggerEvent("evidence:client:SetStatus", "heavyalcohol", 200)
        end
        DeleteObject(prop)
        action = false
    end, function() -- Cancel
        TriggerEvent('dpemote:custom:animation', {"c"})
        MRFW.Functions.Notify("Cancelled..", "error")
        DeleteObject(prop)
        action = false
    end)
end)


RegisterNetEvent("consumables:client:DrinkAlcoholchampagne", function(itemName)
    TriggerEvent('dpemote:custom:animation', {"champagne"})
    MRFW.Functions.Progressbar("snort_coke", "Drinking liquor..", math.random(3000, 6000), false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent('dpemote:custom:animation', {"c"})
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
        TriggerServerEvent("MRFW:Server:RemoveItem", itemName, 1)
        TriggerServerEvent("MRFW:Server:SetMetaData", "thirst", MRFW.Functions.GetPlayerData().metadata["thirst"] + Consumeables[itemName])
        Drunk(2, true, 15000)
        alcoholCount = alcoholCount + 1
        if alcoholCount > 1 and alcoholCount < 4 then
            TriggerEvent("evidence:client:SetStatus", "alcohol", 200)
        elseif alcoholCount >= 4 then
            TriggerEvent("evidence:client:SetStatus", "heavyalcohol", 200)
        end
        DeleteObject(prop)
        action = false
    end, function() -- Cancel
        TriggerEvent('dpemote:custom:animation', {"c"})
        MRFW.Functions.Notify("Cancelled..", "error")
        DeleteObject(prop)
        action = false
    end)
end)


RegisterNetEvent("consumables:client:DrinkAlcoholflute", function(itemName)
    TriggerEvent('dpemote:custom:animation', {"flute"})
    MRFW.Functions.Progressbar("snort_coke", "Drinking liquor..", math.random(3000, 6000), false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent('dpemote:custom:animation', {"c"})
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
        TriggerServerEvent("MRFW:Server:RemoveItem", itemName, 1)
        TriggerServerEvent("MRFW:Server:SetMetaData", "thirst", MRFW.Functions.GetPlayerData().metadata["thirst"] + Consumeables[itemName])
        Drunk(2, true, 15000)
        alcoholCount = alcoholCount + 1
        if alcoholCount > 1 and alcoholCount < 4 then
            TriggerEvent("evidence:client:SetStatus", "alcohol", 200)
        elseif alcoholCount >= 4 then
            TriggerEvent("evidence:client:SetStatus", "heavyalcohol", 200)
        end
        DeleteObject(prop)
        action = false
    end, function() -- Cancel
        TriggerEvent('dpemote:custom:animation', {"c"})
        MRFW.Functions.Notify("Cancelled..", "error")
        DeleteObject(prop)
        action = false
    end)
end)


RegisterNetEvent("consumables:client:DrinkAlcoholwine", function(itemName)
    TriggerEvent('dpemote:custom:animation', {"wine"})
    MRFW.Functions.Progressbar("snort_coke", "Drinking liquor..", math.random(3000, 6000), false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent('dpemote:custom:animation', {"c"})
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
        TriggerServerEvent("MRFW:Server:RemoveItem", itemName, 1)
        TriggerServerEvent("MRFW:Server:SetMetaData", "thirst", MRFW.Functions.GetPlayerData().metadata["thirst"] + Consumeables[itemName])
        Drunk(2, true, 15000)
        alcoholCount = alcoholCount + 1
        if alcoholCount > 1 and alcoholCount < 4 then
            TriggerEvent("evidence:client:SetStatus", "alcohol", 200)
        elseif alcoholCount >= 4 then
            TriggerEvent("evidence:client:SetStatus", "heavyalcohol", 200)
        end
        DeleteObject(prop)
        action = false
    end, function() -- Cancel
        TriggerEvent('dpemote:custom:animation', {"c"})
        MRFW.Functions.Notify("Cancelled..", "error")
        DeleteObject(prop)
        action = false
    end)
end)



RegisterNetEvent("consumables:client:DrinkAlcoholbeer", function(itemName)
    TriggerEvent('dpemote:custom:animation', {"beer3"})
    MRFW.Functions.Progressbar("snort_coke", "Drinking liquor..", math.random(3000, 6000), false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent('dpemote:custom:animation', {"c"})
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
        TriggerServerEvent("MRFW:Server:RemoveItem", itemName, 1)
        TriggerServerEvent("MRFW:Server:SetMetaData", "thirst", MRFW.Functions.GetPlayerData().metadata["thirst"] + Consumeables[itemName])
        Drunk(2, true, 15000)
        alcoholCount = alcoholCount + 1
        if alcoholCount > 1 and alcoholCount < 4 then
            TriggerEvent("evidence:client:SetStatus", "alcohol", 200)
        elseif alcoholCount >= 4 then
            TriggerEvent("evidence:client:SetStatus", "heavyalcohol", 200)
        end
        DeleteObject(prop)
        action = false
    end, function() -- Cancel
        TriggerEvent('dpemote:custom:animation', {"c"})
        MRFW.Functions.Notify("Cancelled..", "error")
        DeleteObject(prop)
        action = false
    end)
end)



RegisterNetEvent("consumables:client:DrinkAlcoholwhiskey", function(itemName)
    TriggerEvent('dpemote:custom:animation', {"whiskey"})
    MRFW.Functions.Progressbar("snort_coke", "Drinking liquor..", math.random(3000, 6000), false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent('dpemote:custom:animation', {"c"})
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
        TriggerServerEvent("MRFW:Server:RemoveItem", itemName, 1)
        TriggerServerEvent("MRFW:Server:SetMetaData", "thirst", MRFW.Functions.GetPlayerData().metadata["thirst"] + Consumeables[itemName])
        Drunk(2, true, 15000)
        alcoholCount = alcoholCount + 1
        if alcoholCount > 1 and alcoholCount < 4 then
            TriggerEvent("evidence:client:SetStatus", "alcohol", 200)
        elseif alcoholCount >= 4 then
            TriggerEvent("evidence:client:SetStatus", "heavyalcohol", 200)
        end
        DeleteObject(prop)
        action = false
    end, function() -- Cancel
        TriggerEvent('dpemote:custom:animation', {"c"})
        MRFW.Functions.Notify("Cancelled..", "error")
        DeleteObject(prop)
        action = false
    end)
end)



RegisterNetEvent("consumables:client:Cokebaggy", function()
    local ped = PlayerPedId()
    MRFW.Functions.Progressbar("snort_coke", "Quick sniff..", math.random(5000, 8000), false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "switch@trevor@trev_smoking_meth",
        anim = "trev_smoking_meth_loop",
        flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(ped, "switch@trevor@trev_smoking_meth", "trev_smoking_meth_loop", 1.0)
        TriggerServerEvent("MRFW:Server:RemoveItem", "cokebaggy", 1)
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["cokebaggy"], "remove")
        TriggerEvent("evidence:client:SetStatus", "widepupils", 200)
        SetPedArmour(PlayerPedId(), GetPedArmour(PlayerPedId()) + 15)
        CokeBaggyEffect()
    end, function() -- Cancel
        StopAnimTask(ped, "switch@trevor@trev_smoking_meth", "trev_smoking_meth_loop", 1.0)
        MRFW.Functions.Notify("Canceled..", "error")
    end)
end)


RegisterNetEvent("consumables:client:Crackbaggy", function()
    local ped = PlayerPedId()
    MRFW.Functions.Progressbar("snort_coke", "Smoking crack..", math.random(7000, 10000), false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "switch@trevor@trev_smoking_meth",
        anim = "trev_smoking_meth_loop",
        flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(ped, "switch@trevor@trev_smoking_meth", "trev_smoking_meth_loop", 1.0)
        TriggerServerEvent("MRFW:Server:RemoveItem", "crack_baggy", 1)
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["crack_baggy"], "remove")
        TriggerEvent("evidence:client:SetStatus", "widepupils", 300)
        CrackBaggyEffect()
    end, function() -- Cancel
        StopAnimTask(ped, "switch@trevor@trev_smoking_meth", "trev_smoking_meth_loop", 1.0)
        MRFW.Functions.Notify("Canceled..", "error")
    end)
end)


RegisterNetEvent('consumables:client:EcstasyBaggy', function()
    MRFW.Functions.Progressbar("use_ecstasy", "Pops Pills", 3000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {
		animDict = "mp_suicide",
		anim = "pill",
		flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(PlayerPedId(), "mp_suicide", "pill", 1.0)
        TriggerServerEvent("MRFW:Server:RemoveItem", "xtcbaggy", 1)
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["xtcbaggy"], "remove")
        EcstasyEffect()
    end, function() -- Cancel
        StopAnimTask(PlayerPedId(), "mp_suicide", "pill", 1.0)
        MRFW.Functions.Notify("Failed", "error")
    end)
end)


RegisterNetEvent("consumables:client:Eat", function(itemName)
    TriggerEvent('dpemote:custom:animation', {"burger"})
    MRFW.Functions.Progressbar("eat_something", "Eating..", 10000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
        TriggerEvent('dpemote:custom:animation', {"c"})
        TriggerServerEvent("MRFW:Server:SetMetaData", "hunger", MRFW.Functions.GetPlayerData().metadata["hunger"] + Consumeables[itemName])
    end)
end)


RegisterNetEvent("consumables:client:Eatmeal", function(itemName)
    TriggerEvent('dpemote:custom:animation', {"burger"})
    MRFW.Functions.Progressbar("eat_something", "Eating..", 10000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
        TriggerEvent('dpemote:custom:animation', {"c"})
        TriggerServerEvent("MRFW:Server:SetMetaData", "thirst", MRFW.Functions.GetPlayerData().metadata["thirst"] + Consumeables[itemName])
        TriggerServerEvent("MRFW:Server:SetMetaData", "hunger", MRFW.Functions.GetPlayerData().metadata["hunger"] + Consumeables[itemName])
    end)
end)



RegisterNetEvent("consumables:client:Eatdonut", function(itemName)
    TriggerEvent('dpemote:custom:animation', {"donut"})
    MRFW.Functions.Progressbar("eat_something", "Eating..", 10000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
        TriggerEvent('dpemote:custom:animation', {"c"})
        TriggerServerEvent("MRFW:Server:SetMetaData", "hunger", MRFW.Functions.GetPlayerData().metadata["hunger"] + Consumeables[itemName])
    end)
end)


RegisterNetEvent("consumables:client:Eatsandwich", function(itemName)
    TriggerEvent('dpemote:custom:animation', {"sandwich"})
    MRFW.Functions.Progressbar("eat_something ", "Eating..", 10000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
        TriggerEvent('dpemote:custom:animation', {"c"})
        TriggerServerEvent("MRFW:Server:SetMetaData", "hunger", MRFW.Functions.GetPlayerData().metadata["hunger"] + Consumeables[itemName])
    end)
end)


RegisterNetEvent("consumables:client:Eategobar", function(itemName)
    TriggerEvent('dpemote:custom:animation', {"egobar"})
    MRFW.Functions.Progressbar("eat_something", "Eating..", 10000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
        TriggerEvent('dpemote:custom:animation', {"c"})
        TriggerServerEvent("MRFW:Server:SetMetaData", "hunger", MRFW.Functions.GetPlayerData().metadata["hunger"] + Consumeables[itemName])
    end)
end)


RegisterNetEvent("consumables:client:Eatcup", function(itemName)
    TriggerEvent('dpemote:custom:animation', {"cup"})
    MRFW.Functions.Progressbar("eat_something", "Eating..", 10000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
        TriggerEvent('dpemote:custom:animation', {"c"})
        TriggerServerEvent("MRFW:Server:SetMetaData", "hunger", MRFW.Functions.GetPlayerData().metadata["hunger"] + Consumeables[itemName])
    end)
end)


RegisterNetEvent("consumables:client:Eatbowl", function(itemName)
    TriggerEvent('dpemote:custom:animation', {"beans"})
    MRFW.Functions.Progressbar("eat_something", "Eating..", 10000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
        TriggerEvent('dpemote:custom:animation', {"c"})
        TriggerServerEvent("MRFW:Server:SetMetaData", "hunger", MRFW.Functions.GetPlayerData().metadata["hunger"] + Consumeables[itemName])
    end)
end)


RegisterNetEvent("consumables:client:EatBurger", function(itemName)
    TriggerEvent('dpemote:custom:animation', {"burger"})
    MRFW.Functions.Progressbar("eat_something", "Eating..", 15000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
        TriggerEvent('dpemote:custom:animation', {"c"})
        TriggerServerEvent("MRFW:Server:SetMetaData", "hunger", MRFW.Functions.GetPlayerData().metadata["hunger"] + Consumeables[itemName])
    end)
end)


RegisterNetEvent("consumables:client:Drink", function(itemName)
    TriggerEvent('dpemote:custom:animation', {"water"})
    MRFW.Functions.Progressbar("drink_something", "Drinking..", 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
        TriggerEvent('dpemote:custom:animation', {"c"})
        TriggerServerEvent("MRFW:Server:SetMetaData", "thirst", MRFW.Functions.GetPlayerData().metadata["thirst"] + Consumeables[itemName])
    end)
end)



RegisterNetEvent("consumables:client:Drinkcup", function(itemName)
    TriggerEvent('dpemote:custom:animation', {"cup"})
    MRFW.Functions.Progressbar("drink_something", "Drinking..", 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
        TriggerEvent('dpemote:custom:animation', {"c"})
        TriggerServerEvent("MRFW:Server:SetMetaData", "thirst", MRFW.Functions.GetPlayerData().metadata["thirst"] + Consumeables[itemName])
    end)
end)

RegisterNetEvent("consumables:client:Drinksoda", function(itemName)
    TriggerEvent('dpemote:custom:animation', {"soda"})
    MRFW.Functions.Progressbar("drink_something", "Drinking..", 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
        TriggerEvent('dpemote:custom:animation', {"c"})
        TriggerServerEvent("MRFW:Server:SetMetaData", "thirst", MRFW.Functions.GetPlayerData().metadata["thirst"] + Consumeables[itemName])
    end)
end)


RegisterNetEvent("consumables:client:DrinkCoffee", function(itemName)
    TriggerEvent('dpemote:custom:animation', {"coffee"})
    MRFW.Functions.Progressbar("drink_something", "Drinking Coffee..", 20000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
        TriggerEvent('dpemote:custom:animation', {"c"})
        TriggerServerEvent("MRFW:Server:SetMetaData", "thirst", MRFW.Functions.GetPlayerData().metadata["thirst"] + Consumeables[itemName])
        TriggerServerEvent('hud:server:RelieveStress', math.random(8, 13))
    end)
end)

RegisterNetEvent("consumables:client:chai", function(itemName)
    TriggerEvent('dpemote:custom:animation', {"cup"})
    MRFW.Functions.Progressbar("drink_something", "Drinking Chai..", 20000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
        TriggerEvent('dpemote:custom:animation', {"c"})
        TriggerServerEvent("MRFW:Server:SetMetaData", "thirst", MRFW.Functions.GetPlayerData().metadata["thirst"] + Consumeables[itemName])
        TriggerServerEvent('hud:server:RelieveStress', math.random(2, 5))
    end)
end)


RegisterNetEvent("consumables:client:OpenMeal", function(itemName)
    MRFW.Functions.Progressbar("smoke_joint", "OPENING MEAL..", 2000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@amb@business@weed@weed_inspecting_high_dry@",
        anim = "weed_inspecting_high_base_inspector",
        flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(PlayerPedId(), "anim@amb@business@weed@weed_inspecting_high_dry@", "weed_inspecting_high_base_inspector", 1.0)
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["mcd-burger"], "add")
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["kurkakola"], "add")
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["mcd-fries"], "add")
        TriggerServerEvent("MRFW:Server:AddItem", 'mcd-burger', 1)
        TriggerServerEvent("MRFW:Server:AddItem", 'kurkakola', 1)
        TriggerServerEvent("MRFW:Server:AddItem", "mcd-fries", 1)
        StopAnimTask(PlayerPedId(), "anim@amb@business@weed@weed_inspecting_high_dry@", "weed_inspecting_high_base_inspector", 1.0)
    end)
end)

RegisterNetEvent("consumables:client:SDrink", function(itemName)
    TriggerEvent('dpemote:custom:animation', {"soda"})
    MRFW.Functions.Progressbar("drink_something", "Drinking..", 2500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
        TriggerEvent('dpemote:custom:animation', {"c"})
        TriggerServerEvent("MRFW:Server:SetMetaData", "thirst", MRFW.Functions.GetPlayerData().metadata["thirst"] + Consumeables[itemName])
    end)
end)


RegisterNetEvent("consumables:client:TeaDrink", function(itemName)
    TriggerEvent('dpemote:custom:animation', {"cup"})
    MRFW.Functions.Progressbar("drink_something", "Drinking Hi-Tea..", 2000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
        TriggerEvent('dpemote:custom:animation', {"c"})
        TriggerServerEvent("MRFW:Server:SetMetaData", "thirst", MRFW.Functions.GetPlayerData().metadata["thirst"] + Consumeables[itemName])
        TriggerServerEvent('hud:server:RelieveStress', math.random(10, 15))
    end)
end)


RegisterNetEvent("consumables:client:UseOxy", function()
    MRFW.Functions.Progressbar("use_bandage", "Take Oxy", 3000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {
		animDict = "mp_suicide",
		anim = "pill",
		flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(PlayerPedId(), "mp_suicide", "pill", 1.0)
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["oxy"], "remove")
        TriggerEvent("hospital:client:HealInjuries")
        TriggerServerEvent('hud:server:RelieveStress', math.random(6, 10))
        AddArmourToPed(PlayerPedId(), math.random(6,8))
        SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) + 15)
    end, function() -- Cancel
        StopAnimTask(PlayerPedId(), "mp_suicide", "pill", 1.0)
        MRFW.Functions.Notify("Fail", "error")
    end)
end)




RegisterNetEvent("consumables:client:MakeJoint", function()
    MRFW.Functions.TriggerCallback('joint:ingredient', function(HasItem, type)
        if HasItem then
            MRFW.Functions.Progressbar("smoke_joint", "Making Joint..", 5000, false, true, {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "anim@amb@business@weed@weed_inspecting_high_dry@",
		        anim = "weed_inspecting_high_base_inspector",
		        flags = 49,
            }, {}, {}, function() -- Done
                StopAnimTask(PlayerPedId(), "anim@amb@business@weed@weed_inspecting_high_dry@", "weed_inspecting_high_base_inspector", 1.0)
                TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["weed_2og"], "remove")
                TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["rolling_paper"], "remove")
                TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["joint"], "add")
                TriggerServerEvent("MRFW:Server:RemoveItem", 'weed_2og', 1)
                TriggerServerEvent("MRFW:Server:RemoveItem", 'rolling_paper', 1)
                TriggerServerEvent("MRFW:Server:AddItem", "joint", 1)
                StopAnimTask(PlayerPedId(), "anim@amb@business@weed@weed_inspecting_high_dry@", "weed_inspecting_high_base_inspector", 1.0)
            end)
        else
            MRFW.Functions.Notify("You do not have the necessary materials.", "error")
            isProcessing = false
        end
    end)
end)

RegisterNetEvent("consumables:client:MethPooch", function()
    local playerPed = PlayerPedId()
    RequestAnimSet("move_m@drunk@slightlydrunk") 
    while not HasAnimSetLoaded("move_m@drunk@slightlydrunk") do
      Citizen.Wait(0)
    end    
    MRFW.Functions.Progressbar("use_bandage", "Taking Meth", 3000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {
		animDict = "mp_suicide",
		anim = "pill",
		flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(PlayerPedId(), "mp_suicide", "pill", 1.0)
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["meth_pooch"], "remove")
        TriggerEvent("evidence:client:SetStatus", "Meth", 300)
        Citizen.Wait(3000)
        if not IsPedInAnyVehicle(playerPed, false) then
            ClearPedTasksImmediately(playerPed)
        end
        SetPedMotionBlur(playerPed, true)
        SetPedMovementClipset(playerPed, "move_m@drunk@slightlydrunk", true)
        SetPedIsDrunk(playerPed, true)
        SetTimecycleModifier("spectator5")
        AnimpostfxPlay("SuccessMichael", 10000001, true)
        ShakeGameplayCam("DRUNK_SHAKE", 1.5)
        SetEntityHealth(PlayerPedId(), 200)
        Citizen.Wait(30000)
        SetPedMoveRateOverride(PlayerId(),1.0)
        SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
        SetPedIsDrunk(PlayerPedId(), false)		
        SetPedMotionBlur(playerPed, false)
        ResetPedMovementClipset(PlayerPedId())
        AnimpostfxStopAll()
        ShakeGameplayCam("DRUNK_SHAKE", 0.0)
        SetTimecycleModifierStrength(0.0)
        SetPedArmour(PlayerPedId(), GetPedArmour(PlayerPedId()) + 60)
    end, function() -- Cancel
        StopAnimTask(PlayerPedId(), "mp_suicide", "pill", 1.0)
        MRFW.Functions.Notify("Fail", "error")
    end)
end)

RegisterNetEvent("consumables:client:Acideffect", function()
    local playerPed = PlayerPedId()
    RequestAnimSet("move_m@drunk@slightlydrunk") 
    while not HasAnimSetLoaded("move_m@drunk@slightlydrunk") do
      Citizen.Wait(0)
    end    
    MRFW.Functions.Progressbar("use_bandage", "Taking Acid", 3000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {
		animDict = "mp_suicide",
		anim = "pill",
		flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(PlayerPedId(), "mp_suicide", "pill", 1.0)
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["acid"], "remove")
        TriggerEvent("evidence:client:SetStatus", "Acid", 300)
        Drunk(2, true, 150000)
        exports["acidtrip"]:DoAcid(120000)
        TriggerServerEvent('hud:server:RelieveStress', math.random(8, 12))
    end, function() -- Cancel
        StopAnimTask(PlayerPedId(), "mp_suicide", "pill", 1.0)
        MRFW.Functions.Notify("Fail", "error")
    end)
end)


RegisterNetEvent("consumables:client:paracetamol", function()
    MRFW.Functions.Progressbar("use_bandage", "Taking Paracetamol", 3000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {
		animDict = "mp_suicide",
		anim = "pill",
		flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(PlayerPedId(), "mp_suicide", "pill", 1.0)
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["paracetamol"], "remove")
        SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) + 7)
    end, function() -- Cancel
        StopAnimTask(PlayerPedId(), "mp_suicide", "pill", 1.0)
        MRFW.Functions.Notify("Fail", "error")
    end)
end)


RegisterNetEvent("consumables:client:aspirine", function()
    MRFW.Functions.Progressbar("use_bandage", "Taking Aspirine", 3000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {
		animDict = "mp_suicide",
		anim = "pill",
		flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(PlayerPedId(), "mp_suicide", "pill", 1.0)
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["aspirine"], "remove")
        SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) + 6)
        TriggerServerEvent('hud:server:RelieveStress', math.random(2, 3))
    end, function() -- Cancel
        StopAnimTask(PlayerPedId(), "mp_suicide", "pill", 1.0)
        MRFW.Functions.Notify("Fail", "error")
    end)
end)


RegisterNetEvent("consumables:client:disprin", function()
    MRFW.Functions.Progressbar("use_bandage", "Taking Disprin", 3000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {
		animDict = "mp_suicide",
		anim = "pill",
		flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(PlayerPedId(), "mp_suicide", "pill", 1.0)
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["disprin"], "remove")
        TriggerServerEvent('hud:server:RelieveStress', math.random(2, 3))
    end, function() -- Cancel
        StopAnimTask(PlayerPedId(), "mp_suicide", "pill", 1.0)
        MRFW.Functions.Notify("Fail", "error")
    end)
end)


RegisterNetEvent("consumables:client:heparin", function()
    MRFW.Functions.Progressbar("use_bandage", "Taking Heparin", 3000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {
		animDict = "mp_suicide",
		anim = "pill",
		flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(PlayerPedId(), "mp_suicide", "pill", 1.0)
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["heparin"], "remove")
        SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) + 7)
        TriggerServerEvent('hud:server:RelieveStress', math.random(2, 3))
    end, function() -- Cancel
        StopAnimTask(PlayerPedId(), "mp_suicide", "pill", 1.0)
        MRFW.Functions.Notify("Fail", "error")
    end)
end)


RegisterNetEvent("consumables:client:ibuprofen", function()
    MRFW.Functions.Progressbar("use_bandage", "Taking Ibuprofen", 3000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {
		animDict = "mp_suicide",
		anim = "pill",
		flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(PlayerPedId(), "mp_suicide", "pill", 1.0)
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["ibuprofen"], "remove")
        SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) + 15)
    end, function() -- Cancel
        StopAnimTask(PlayerPedId(), "mp_suicide", "pill", 1.0)
        MRFW.Functions.Notify("Fail", "error")
    end)
end)



RegisterNetEvent("consumables:client:tsoup", function(itemName)
    TriggerEvent('dpemote:custom:animation', {"beans"})
    MRFW.Functions.Progressbar("drink_something", "Eating Soup", 2500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
        TriggerEvent('dpemote:custom:animation', {"c"})
        TriggerServerEvent("MRFW:Server:SetMetaData", "thirst", MRFW.Functions.GetPlayerData().metadata["thirst"] + Consumeables[itemName])
    end)
end)


RegisterNetEvent("consumables:client:msoup", function(itemName)
    TriggerEvent('dpemote:custom:animation', {"beans"})
    MRFW.Functions.Progressbar("drink_something", "Eating Soup", 2500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
        TriggerEvent('dpemote:custom:animation', {"c"})
        TriggerServerEvent("MRFW:Server:SetMetaData", "thirst", MRFW.Functions.GetPlayerData().metadata["thirst"] + Consumeables[itemName])
    end)
end)


RegisterNetEvent("consumables:client:rggol", function(itemName)
    TriggerEvent('dpemote:custom:animation', {"donut"})
    MRFW.Functions.Progressbar("eat_something", "Eating Golgappa..", 2500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
        TriggerEvent('dpemote:custom:animation', {"c"})
        TriggerServerEvent("MRFW:Server:SetMetaData", "hunger", MRFW.Functions.GetPlayerData().metadata["hunger"] + Consumeables[itemName])
    end)
end)



RegisterNetEvent("consumables:client:belachi", function()
    MRFW.Functions.Progressbar("use_bandage", "Eating Baba Elaichi", 3000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {
		animDict = "mp_suicide",
		anim = "pill",
		flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(PlayerPedId(), "mp_suicide", "pill", 1.0)
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["belachi"], "remove")
        TriggerServerEvent('hud:server:RelieveStress', math.random(1, 3))
    end, function() -- Cancel
        StopAnimTask(PlayerPedId(), "mp_suicide", "pill", 1.0)
        MRFW.Functions.Notify("Fail", "error")
    end)
end)


RegisterNetEvent("consumables:client:gulabjamun", function(itemName)
    TriggerEvent('dpemote:custom:animation', {"donut"})
    MRFW.Functions.Progressbar("eat_something", "Eating gulabjamun..", 2500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
        TriggerEvent('dpemote:custom:animation', {"c"})
        TriggerServerEvent("MRFW:Server:SetMetaData", "hunger", MRFW.Functions.GetPlayerData().metadata["hunger"] + Consumeables[itemName])
    end)
end)

RegisterNetEvent("consumables:client:rosogulla", function(itemName)
    TriggerEvent('dpemote:custom:animation', {"donut"})
    MRFW.Functions.Progressbar("eat_something", "Eating rosogulla..", 2500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
        TriggerEvent('dpemote:custom:animation', {"c"})
        TriggerServerEvent("MRFW:Server:SetMetaData", "hunger", MRFW.Functions.GetPlayerData().metadata["hunger"] + Consumeables[itemName])
    end)
end)


RegisterNetEvent("consumables:client:paan", function(itemName)
    TriggerEvent('mr-clothing:client:adjustfacewear')
    TriggerEvent('dpemote:custom:animation', {"candy"})
    MRFW.Functions.Progressbar("eat_something", "Eating paan..", 2500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
        TriggerEvent('dpemote:custom:animation', {"c"})
        local PanData = {
            outfitData = {
                ["lipstick"]   = { item = 2, texture = 21},  -- Nek / Das
                --["lipstick"]   = { item = 8, texture = 21},
            },
        }
        
        TriggerEvent('mr-clothing:client:loadOutfit', PanData)
        TriggerServerEvent("MRFW:Server:SetMetaData", "hunger", MRFW.Functions.GetPlayerData().metadata["hunger"] + Consumeables[itemName])
    end)
end)


RegisterNetEvent("consumables:client:cookedchicken", function(itemName)
    TriggerEvent('dpemote:custom:animation', {"beans"})
    MRFW.Functions.Progressbar("eat_something", "Eating Cooked Chicken..", 2500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
        TriggerEvent('dpemote:custom:animation', {"c"})
        TriggerServerEvent("MRFW:Server:SetMetaData", "hunger", MRFW.Functions.GetPlayerData().metadata["hunger"] + Consumeables[itemName])
    end)
end)


RegisterNetEvent("consumables:client:pannermasala", function(itemName)
    TriggerEvent('dpemote:custom:animation', {"beans"})
    MRFW.Functions.Progressbar("eat_something", "Eating Paneer Masala..", 2500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
        TriggerEvent('dpemote:custom:animation', {"c"})
        TriggerServerEvent("MRFW:Server:SetMetaData", "hunger", MRFW.Functions.GetPlayerData().metadata["hunger"] + Consumeables[itemName])
    end)
end)


RegisterNetEvent("consumables:client:chickenmasala", function(itemName)
    TriggerEvent('dpemote:custom:animation', {"beans"})
    MRFW.Functions.Progressbar("eat_something", "Eating Chicken Masala..", 2500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
        TriggerEvent('dpemote:custom:animation', {"c"})
        TriggerServerEvent("MRFW:Server:SetMetaData", "hunger", MRFW.Functions.GetPlayerData().metadata["hunger"] + Consumeables[itemName])
    end)
end)


RegisterNetEvent("consumables:client:chickenroll", function(itemName)
    TriggerEvent('dpemote:custom:animation', {"sandwich"})
    MRFW.Functions.Progressbar("eat_something", "Eating Chicken Roll..", 2500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
        TriggerEvent('dpemote:custom:animation', {"c"})
        TriggerServerEvent("MRFW:Server:SetMetaData", "hunger", MRFW.Functions.GetPlayerData().metadata["hunger"] + Consumeables[itemName])
    end)
end)


RegisterNetEvent("consumables:client:brownbread", function(itemName)
    TriggerEvent('dpemote:custom:animation', {"sandwich"})
    MRFW.Functions.Progressbar("eat_something", "Eating Brown Bread..", 2500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
        TriggerEvent('dpemote:custom:animation', {"c"})
        TriggerServerEvent("MRFW:Server:SetMetaData", "hunger", MRFW.Functions.GetPlayerData().metadata["hunger"] + Consumeables[itemName])
    end)
end)


RegisterNetEvent("consumables:client:garlicbread", function(itemName)
    TriggerEvent('dpemote:custom:animation', {"sandwich"})
    MRFW.Functions.Progressbar("eat_something", "Eating Garlic Bread..", 2500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
        TriggerEvent('dpemote:custom:animation', {"c"})
        TriggerServerEvent("MRFW:Server:SetMetaData", "hunger", MRFW.Functions.GetPlayerData().metadata["hunger"] + Consumeables[itemName])
    end)
end)


RegisterNetEvent("consumables:client:naan", function(itemName)
    TriggerEvent('dpemote:custom:animation', {"sandwich"})
    MRFW.Functions.Progressbar("eat_something", "Eating Naan..", 2500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
        TriggerEvent('dpemote:custom:animation', {"c"})
        TriggerServerEvent("MRFW:Server:SetMetaData", "hunger", MRFW.Functions.GetPlayerData().metadata["hunger"] + Consumeables[itemName])
    end)
end)



RegisterNetEvent("consumables:client:mushroomkhao", function(itemName)
    TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
    TriggerEvent('dpemote:custom:animation', {"candy"})
    MRFW.Functions.Progressbar("eat_something", "Eating..", 2500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent('dpemote:custom:animation', {"c"})
        TriggerEvent('dpemote:custom:animation', {"cough"})
        Citizen.Wait(800)
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "vomit", 0.3)
        Citizen.Wait(6000)
        TriggerServerEvent("MRFW:Server:SetMetaData", "hunger", MRFW.Functions.GetPlayerData().metadata["hunger"] - 25)
        TriggerServerEvent("MRFW:Server:SetMetaData", "thirst", MRFW.Functions.GetPlayerData().metadata["thirst"] - 25)
        Citizen.Wait(3000)
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "vomit", 0.3)
        TriggerServerEvent("MRFW:Server:SetMetaData", "hunger", MRFW.Functions.GetPlayerData().metadata["hunger"] - 25)
        TriggerServerEvent("MRFW:Server:SetMetaData", "thirst", MRFW.Functions.GetPlayerData().metadata["thirst"] - 25)
        TriggerServerEvent('hud:server:GainStress', math.random(2, 5))
        Citizen.Wait(1000)
        TriggerEvent('dpemote:custom:animation', {"c"})
    end)
end)

RegisterNetEvent("consumables:client:pmushroomkhao", function(itemName)
    TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
    TriggerEvent('dpemote:custom:animation', {"candy"})
    MRFW.Functions.Progressbar("eat_something", "Eating..", 2500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent('dpemote:custom:animation', {"c"})
        TriggerEvent('dpemote:custom:animation', {"cough"})
        Citizen.Wait(800)
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "vomit", 0.3)
        Citizen.Wait(6000)
        TriggerServerEvent("MRFW:Server:SetMetaData", "hunger", MRFW.Functions.GetPlayerData().metadata["hunger"] - 50)
        TriggerServerEvent("MRFW:Server:SetMetaData", "thirst", MRFW.Functions.GetPlayerData().metadata["thirst"] - 50)
        Citizen.Wait(3000)
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "vomit", 0.3)
        TriggerServerEvent("MRFW:Server:SetMetaData", "hunger", MRFW.Functions.GetPlayerData().metadata["hunger"] - 50)
        TriggerServerEvent("MRFW:Server:SetMetaData", "thirst", MRFW.Functions.GetPlayerData().metadata["thirst"] - 50)
        SetEntityHealth(PlayerPedId(), 0)
        Citizen.Wait(1000)
        TriggerEvent('dpemote:custom:animation', {"c"})
    end)
end)

RegisterNetEvent("consumables:client:UsesJoint", function()
    local playerPed = PlayerPedId()
    local armor = 0
    if not IsPedInAnyVehicle(playerPed, false) then
        TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_SMOKING_POT", 0, 1)
        Citizen.Wait(100)
        TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_SMOKING_POT", 0, 1)
        MRFW.Functions.Progressbar("smoke_joint", "Consumming..", 20000, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["sjoint"], "remove")
            Citizen.Wait(3000)
            ClearPedTasksImmediately(playerPed)
            TriggerEvent('dpemote:custom:animation', {"c"})
            armor = GetPedArmour(PlayerPedId())
            if armor == 100.0 then
                MRFW.Functions.Notify("Kam maro re" , "error")
            elseif armor >= 90.0 then
                MRFW.Functions.Notify("Armor Increased" , "error")
                SetPedArmour(PlayerPedId(), 100)
            elseif armor >= 75.0 then
                MRFW.Functions.Notify("Armor Increased" , "error")
                SetPedArmour(PlayerPedId(), 90)
            elseif armor >= 60.0 then
                MRFW.Functions.Notify("Armor Increased" , "error")
                SetPedArmour(PlayerPedId(), 75)
            elseif armor >= 45.0 then
                MRFW.Functions.Notify("Armor Increased" , "error")
                SetPedArmour(PlayerPedId(), 60)
            elseif armor >= 30.0 then
                MRFW.Functions.Notify("Armor Increased" , "error")
                SetPedArmour(PlayerPedId(), 45)
            elseif armor >= 15.0 then
                MRFW.Functions.Notify("Armor Increased" , "error")
                SetPedArmour(PlayerPedId(), 30)
            else 
                SetPedArmour(PlayerPedId(), 15)
            end
            Citizen.Wait(3000)
            TriggerServerEvent('hud:server:RelieveStress', math.random(20, 25))
            TriggerEvent("evidence:client:SetStatus", "weedsmell", 300)
        end)
    elseif IsPedInAnyVehicle(playerPed, false) then
        MRFW.Functions.Progressbar("smoke_joint", "Consumming..", 28000, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["sjoint"], "remove")
            TriggerEvent('dpemote:custom:animation', {"c"})
            armor = GetPedArmour(PlayerPedId())
            if armor == 100.0 then
                MRFW.Functions.Notify("Kam maro re" , "error")
            elseif armor >= 95.0 then
                MRFW.Functions.Notify("Armor Increased" , "error")
                SetPedArmour(PlayerPedId(), 100)
            elseif armor >= 85.0 then
                MRFW.Functions.Notify("Armor Increased" , "error")
                SetPedArmour(PlayerPedId(), 95)
            elseif armor >= 75.0 then
                MRFW.Functions.Notify("Armor Increased" , "error")
                SetPedArmour(PlayerPedId(), 85)
            elseif armor >= 65.0 then
                MRFW.Functions.Notify("Armor Increased" , "error")
                SetPedArmour(PlayerPedId(), 75)
            elseif armor >= 55.0 then
                MRFW.Functions.Notify("Armor Increased" , "error")
                SetPedArmour(PlayerPedId(), 65)
            elseif armor >= 45.0 then
                MRFW.Functions.Notify("Armor Increased" , "error")
                SetPedArmour(PlayerPedId(), 55)
            elseif armor >= 35.0 then
                MRFW.Functions.Notify("Armor Increased" , "error")
                SetPedArmour(PlayerPedId(), 45)
            elseif armor >= 25.0 then
                MRFW.Functions.Notify("Armor Increased" , "error")
                SetPedArmour(PlayerPedId(), 35)
            elseif armor >= 15.0 then
                MRFW.Functions.Notify("Armor Increased" , "error")
                SetPedArmour(PlayerPedId(), 25)
            else 
                SetPedArmour(PlayerPedId(), 15)
            end
            Citizen.Wait(3000)
            TriggerServerEvent('hud:server:RelieveStress', math.random(18, 20))
            TriggerEvent("evidence:client:SetStatus", "weedsmell", 300)
        end)
    end
end)


RegisterNetEvent("consumables:client:MakesJoint", function()
    MRFW.Functions.TriggerCallback('sjoint:ingredient', function(HasItem, type)
        if HasItem then
            MRFW.Functions.Progressbar("smoke_joint", "Making Joint..", 5000, false, true, {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "anim@amb@business@weed@weed_inspecting_high_dry@",
		        anim = "weed_inspecting_high_base_inspector",
		        flags = 49,
            }, {}, {}, function() -- Done
                StopAnimTask(PlayerPedId(), "anim@amb@business@weed@weed_inspecting_high_dry@", "weed_inspecting_high_base_inspector", 1.0)
                TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["weed_skunk"], "remove")
                TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["rolling_paper"], "remove")
                TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["sjoint"], "add")
                TriggerServerEvent("MRFW:Server:RemoveItem", 'weed_skunk', 1)
                TriggerServerEvent("MRFW:Server:RemoveItem", 'rolling_paper', 1)
                TriggerServerEvent("MRFW:Server:AddItem", "sjoint", 1)
                StopAnimTask(PlayerPedId(), "anim@amb@business@weed@weed_inspecting_high_dry@", "weed_inspecting_high_base_inspector", 1.0)
            end)
        else
            MRFW.Functions.Notify("आपके पास आवश्यक सामग्री नहीं है|", "error")
            isProcessing = false
        end
    end)
end)

function EquipNightVision()
    loadAnimDict("mp_masks@standard_car@ds@")        
    TaskPlayAnim(PlayerPedId(), "mp_masks@standard_car@ds@", "put_on_mask", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    SetTimeout(600, function()
    ClearPedTasks(PlayerPedId())
end)
end

function OffNightVision()
    loadAnimDict("missheist_agency2ahelmet")        
    TaskPlayAnim(PlayerPedId(), "missheist_agency2ahelmet", "take_off_helmet_stand", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    SetTimeout(600, function()
    ClearPedTasks(PlayerPedId())
end)
end

local currentHat = false

RegisterNetEvent("consumables:client:useNightVision", function()
    local ped = PlayerPedId()
    local PlayerData = MRFW.Functions.GetPlayerData()
    if IsNightvisionActive() then
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "nv", 0.25)
        OffNightVision()
        MRFW.Functions.Progressbar("nightvision", "Removing nightvision..", 1500, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
        SetNightvision(false)
        SetSeethrough(false)
        ClearPedProp(ped, 0)
        SetPedPropIndex(ped, 0, currentHat, 0, 0)
        end)
    else
        currentHat = GetPedPropIndex(ped, 0)
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "nv", 0.25)
        EquipNightVision()
        MRFW.Functions.Progressbar("nightvision", "Putting on nightvision..", 1500, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            SetNightvision(true)
            SetSeethrough(false)
            SetPedPropIndex(ped, 0, 129, 0, 0)
        end)
    end
end)

RegisterNetEvent("consumables:client:Drinktank", function(itemName)
    TriggerEvent('dpemote:custom:animation', {"cup"})
    MRFW.Functions.Progressbar("drink_something", "Drinking..", 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent('dpemote:custom:animation', {"c"})
        TriggerServerEvent("MRFW:Server:SetMetaData", "thirst", MRFW.Functions.GetPlayerData().metadata["thirst"] + 5)
    end)
end)
RegisterNetEvent("consumables:client:uwububbleteablueberry", function(itemName)
    TriggerEvent('animations:client:EmoteCommandStart', {"bubbletea"})
    action = true
    MRFW.Functions.Progressbar("drink_something", "Popping some Bubble Tea..", 10000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        DeleteObject(prop)
        TriggerServerEvent("MRFW:Server:SetMetaData", "thirst", MRFW.Functions.GetPlayerData().metadata["thirst"] + Consumeables[itemName])
        action = false
    end)
end)
RegisterNetEvent("consumables:client:uwumisosoup", function(itemName)
    TriggerEvent('animations:client:EmoteCommandStart', {"misosoup"})
    action = true
    MRFW.Functions.Progressbar("drink_something", "Supping some Soup..", 10000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        DeleteObject(prop)
        TriggerServerEvent("MRFW:Server:SetMetaData", "thirst", MRFW.Functions.GetPlayerData().metadata["thirst"] + Consumeables[itemName])
        action = false
    end)
end)

RegisterNetEvent("consumables:client:EatPancakes", function(itemName)
    TriggerEvent('animations:client:EmoteCommandStart', {"uwupancake"})
    action = true
    MRFW.Functions.Progressbar("eat_something", "Supping some Soup..", 10000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        DeleteObject(prop)
        TriggerServerEvent("MRFW:Server:SetMetaData", "hunger", MRFW.Functions.GetPlayerData().metadata["hunger"] + Consumeables[itemName])
        action = false
    end)
end)


RegisterNetEvent("consumables:client:EatCupcakes", function(itemName)
    TriggerEvent('animations:client:EmoteCommandStart', {"uwucupcake"})
    action = true
    MRFW.Functions.Progressbar("eat_something", "Supping some Soup..", 10000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        DeleteObject(prop)
        TriggerServerEvent("MRFW:Server:SetMetaData", "hunger", MRFW.Functions.GetPlayerData().metadata["hunger"] + Consumeables[itemName])
        action = false
    end)
end)

RegisterNetEvent("consumables:client:uwubudhabowl", function(itemName)
    TriggerEvent('animations:client:EmoteCommandStart', {"budhabowl"})
    action = true
    MRFW.Functions.Progressbar("eat_something", "Banging a bowl of goodness..", 10000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        DeleteObject(prop)
        TriggerServerEvent("MRFW:Server:SetMetaData", "hunger", MRFW.Functions.GetPlayerData().metadata["hunger"] + Consumeables[itemName])
        action = false
    end)
end)
RegisterNetEvent("consumables:client:uwuvanillasandy", function(itemName)
    TriggerEvent('animations:client:EmoteCommandStart', {"uwusandy"})
    action = true
    MRFW.Functions.Progressbar("eat_something", "uWu Icecream Mmm..", 10000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        DeleteObject(prop)
        TriggerServerEvent("MRFW:Server:SetMetaData", "hunger", MRFW.Functions.GetPlayerData().metadata["hunger"] + Consumeables[itemName])
        action = false
    end)
end)
RegisterNetEvent("consumables:client:uwuchocsandy", function(itemName)
    TriggerEvent('animations:client:EmoteCommandStart', {"uwusandy"})
    action = true
    MRFW.Functions.Progressbar("eat_something", "uWu Icecream Mmm..", 10000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[itemName], "remove")
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        DeleteObject(prop)
        TriggerServerEvent("MRFW:Server:SetMetaData", "hunger", MRFW.Functions.GetPlayerData().metadata["hunger"] + Consumeables[itemName])
        action = false
    end)
end)
