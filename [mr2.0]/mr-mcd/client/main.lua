MRFW = exports['mrfw']:GetCoreObject()


isLoggedIn = true
PlayerJob = {}

local onDuty = false

local blips = {

     {title="MC DONALD", colour=5, id=78, x = 82.79, y = 279.21, z = 110.21},
  }


-- Citizen.CreateThread(function()

--     for _, info in pairs(blips) do
--       info.blip = AddBlipForCoord(info.x, info.y, info.z)
--       SetBlipSprite(info.blip, info.id)
--       SetBlipDisplay(info.blip, 4)
--       SetBlipScale(info.blip, 0.7)
--       SetBlipColour(info.blip, info.colour)
--       SetBlipAsShortRange(info.blip, true)
--       BeginTextCommandSetBlipName("STRING")
--       AddTextComponentString(info.title)
--       EndTextCommandSetBlipName(info.blip)
--     end
-- end)

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


RegisterNetEvent('MRFW:Client:OnPlayerLoaded')
AddEventHandler('MRFW:Client:OnPlayerLoaded', function()
    MRFW.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
        if PlayerData.job.onduty then
            if PlayerData.job.name == "mcd" then
                TriggerServerEvent("MRFW:ToggleDuty")
            end
        end
    end)
end)

RegisterNetEvent('MRFW:Client:OnJobUpdate')
AddEventHandler('MRFW:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    onDuty = PlayerJob.onduty
end)

RegisterNetEvent('MRFW:Client:SetDuty')
AddEventHandler('MRFW:Client:SetDuty', function(duty)
    onDuty = duty
end)

-- Citizen.CreateThread(function()
--     local c = Config.Locations["exit"]
--     local Blip = AddBlipForCoord(c.x, c.y, c.z)

--     SetBlipSprite (Blip, 0)
--     SetBlipDisplay(Blip, 0)
--     SetBlipScale  (Blip, 0)
--     SetBlipAsShortRange(Blip, true)
--     SetBlipColour(Blip, 0)
--     SetBlipAlpha(Blip, 0)
-- end)

Citizen.CreateThread(function()
    while true do
        local inRange = false

        if isLoggedIn then
            if PlayerJob.name == "mcd" then
                local pos = GetEntityCoords(PlayerPedId())
                local VehicleDistance = GetDistanceBetweenCoords(pos, Config.Locations["vehicle"].x, Config.Locations["vehicle"].y, Config.Locations["vehicle"].z, true)


                if onDuty then
                    if VehicleDistance < 20 then
                        inRange = true
                        DrawMarker(2, Config.Locations["vehicle"].x, Config.Locations["vehicle"].y, Config.Locations["vehicle"].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 210, 50, 9, 255, false, false, false, true, false, false, false)
                        if VehicleDistance < 1 then
                            local InVehicle = IsPedInAnyVehicle(PlayerPedId())

                            if InVehicle then
                                DrawText3Ds(Config.Locations["vehicle"].x, Config.Locations["vehicle"].y, Config.Locations["vehicle"].z, '[E] Hide the vehicle')
                                if IsControlJustPressed(0, Keys["E"]) then
                                    DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
                                end
                            else
                                DrawText3Ds(Config.Locations["vehicle"].x, Config.Locations["vehicle"].y, Config.Locations["vehicle"].z, '[E] Grab vehicle')
                                if IsControlJustPressed(0, Keys["E"]) then
                                    if IsControlJustPressed(0, Keys["E"]) then
                                        VehicleList()
                                        Menu.hidden = not Menu.hidden
                                    end
                                end
                                Menu.renderGUI()
                            end
                        end
                    end
                end

                if not inRange then
                    Citizen.Wait(1500)
                end
            else
                Citizen.Wait(1500)
            end
        else
            Citizen.Wait(1500)
        end

        Citizen.Wait(5)
    end
end)

RegisterNetEvent('mcd:ToggleDuty', function()
    onDuty = not onDuty
    TriggerServerEvent("MRFW:ToggleDuty")
end)

RegisterNetEvent('mcd:shop', function()
    TriggerServerEvent("inventory:server:OpenInventory", "shop", 'mcdshop', Config.mcdShops)
end)

RegisterNetEvent('mcd:Storage', function()
    TriggerEvent("inventory:client:SetCurrentStash", "mcdstash")
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "mcdstash", {
        maxweight = 4000000,
        slots = 500,
    })
end)


RegisterNetEvent('mcd:pickorder1', function()
    TriggerEvent("inventory:client:SetCurrentStash", "MCD_Order1")
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "MCD_Order1", {
        maxweight = 400000,
        slots = 50,
    })
end)

RegisterNetEvent('mcd:pickorder2', function()
    TriggerEvent("inventory:client:SetCurrentStash", "MCD_Order2")
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "MCD_Order2", {
        maxweight = 400000,
        slots = 50,
    })
end)

RegisterNetEvent('mcd:pickorder3', function()
    TriggerEvent("inventory:client:SetCurrentStash", "MCD_Order3")
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "MCD_Order3", {
        maxweight = 400000,
        slots = 50,
    })
end)

RegisterNetEvent('mcd:caramel', function()
    MRFW.Functions.TriggerCallback('MRFW:HasItem', function(result)
        if result then
            CaramelFilling()
        else
            MRFW.Functions.Notify("You don't have empty cup", "error")
        end
    
    end, 'mcd-cup')
end)

RegisterNetEvent('mcd:Chocolate', function()
    MRFW.Functions.TriggerCallback('MRFW:HasItem', function(result)
        if result then
            ChocolateFilling()
        else
            MRFW.Functions.Notify("You don't have empty cup", "error")
        end
    
    end, 'mcd-cup')
end)

RegisterNetEvent('mcd:cappuccino', function()
    MRFW.Functions.TriggerCallback('MRFW:HasItem', function(result)
        if result then
            cappuccinoFilling()
        else
            MRFW.Functions.Notify("You don't have empty cup", "error")
        end
    
    end, 'mcd-cup')
end)

RegisterNetEvent('mcd:icetea', function()
    MRFW.Functions.TriggerCallback('MRFW:HasItem', function(result)
        if result then
            iceFilling()
        else
            MRFW.Functions.Notify("You don't have empty glass", "error")
        end
    
    end, 'mcd-glass')
end)

RegisterNetEvent('mcd:icedlatte', function()
    MRFW.Functions.TriggerCallback('MRFW:HasItem', function(result)
        if result then
            icedFilling()
        else
            MRFW.Functions.Notify("You don't have empty glass", "error")
        end
    
    end, 'mcd-glass')
end)

RegisterNetEvent('mcd:Strawberry', function()
    MRFW.Functions.TriggerCallback('MRFW:HasItem', function(result)
        if result then
            StrawberryFilling()
        else
            MRFW.Functions.Notify("You don't have empty glass", "error")
        end
    
    end, 'mcd-glass')
end)

RegisterNetEvent('mcd:Mango', function()
    MRFW.Functions.TriggerCallback('MRFW:HasItem', function(result)
        if result then
            MangoFilling()
        else
            MRFW.Functions.Notify("You don't have empty glass", "error")
        end
    
    end, 'mcd-glass')
end)


function StrawberryFilling()

    TriggerServerEvent("MRFW:Server:RemoveItem", "mcd-glass", 1)
    TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["mcd-glass"], "remove")
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "sodaop", 0.8)
    MRFW.Functions.Progressbar("empty_bottle", "Filling Strawberry Banana Smoothie ..", 8000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {
		animDict = "amb@prop_human_bum_shopping_cart@male@idle_a",
		anim = "idle_c",
		flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(PlayerPedId(), "amb@prop_human_bum_shopping_cart@male@idle_a", "idle_c", 1.0)
        TriggerServerEvent("MRFW:Server:AddItem", "mcd-strawberry", 1)
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["mcd-strawberry"], "add")
    end, function() -- Cancel
        StopAnimTask(PlayerPedId(), "amb@prop_human_bum_shopping_cart@male@idle_a", "idle_c", 1.0)
        MRFW.Functions.Notify("Fail", "error")
    end)
end

function MangoFilling()

    TriggerServerEvent("MRFW:Server:RemoveItem", "mcd-glass", 1)
    TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["mcd-glass"], "remove")
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "sodaop", 0.8)
    MRFW.Functions.Progressbar("empty_bottle", "Filling Mango Pineapple Smoothie ..", 8000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {
		animDict = "amb@prop_human_bum_shopping_cart@male@idle_a",
		anim = "idle_c",
		flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(PlayerPedId(), "amb@prop_human_bum_shopping_cart@male@idle_a", "idle_c", 1.0)
        TriggerServerEvent("MRFW:Server:AddItem", "mcd-mango", 1)
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["mcd-mango"], "add")
    end, function() -- Cancel
        StopAnimTask(PlayerPedId(), "amb@prop_human_bum_shopping_cart@male@idle_a", "idle_c", 1.0)
        MRFW.Functions.Notify("Fail", "error")
    end)
end

function iceFilling()

    TriggerServerEvent("MRFW:Server:RemoveItem", "mcd-glass", 1)
    TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["mcd-glass"], "remove")
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "sodaop", 0.8)
    MRFW.Functions.Progressbar("empty_bottle", "Filling Ice tea ..", 8000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {
		animDict = "amb@prop_human_bum_shopping_cart@male@idle_a",
		anim = "idle_c",
		flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(PlayerPedId(), "amb@prop_human_bum_shopping_cart@male@idle_a", "idle_c", 1.0)
        TriggerServerEvent("MRFW:Server:AddItem", "mcd-icetea", 1)
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["mcd-icetea"], "add")
    end, function() -- Cancel
        StopAnimTask(PlayerPedId(), "amb@prop_human_bum_shopping_cart@male@idle_a", "idle_c", 1.0)
        MRFW.Functions.Notify("Fail", "error")
    end)
end

function icedFilling()

    TriggerServerEvent("MRFW:Server:RemoveItem", "mcd-glass", 1)
    TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["mcd-glass"], "remove")
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "sodaop", 0.8)
    MRFW.Functions.Progressbar("empty_bottle", "Filling Iced Latte ..", 8000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {
		animDict = "amb@prop_human_bum_shopping_cart@male@idle_a",
		anim = "idle_c",
		flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(PlayerPedId(), "amb@prop_human_bum_shopping_cart@male@idle_a", "idle_c", 1.0)
        TriggerServerEvent("MRFW:Server:AddItem", "mcd-iced", 1)
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["mcd-iced"], "add")
    end, function() -- Cancel
        StopAnimTask(PlayerPedId(), "amb@prop_human_bum_shopping_cart@male@idle_a", "idle_c", 1.0)
        MRFW.Functions.Notify("Fail", "error")
    end)
end


function cappuccinoFilling()

    TriggerServerEvent("MRFW:Server:RemoveItem", "mcd-cup", 1)
    TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["mcd-cup"], "remove")
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "cmaking", 0.8)
    MRFW.Functions.Progressbar("empty_bottle", "Filling Cappuccino ..", 10000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {
		animDict = "amb@prop_human_bum_shopping_cart@male@idle_a",
		anim = "idle_c",
		flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(PlayerPedId(), "amb@prop_human_bum_shopping_cart@male@idle_a", "idle_c", 1.0)
        TriggerServerEvent("MRFW:Server:AddItem", "mcd-cappuccino", 1)
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["mcd-cappuccino"], "add")
    end, function() -- Cancel
        StopAnimTask(PlayerPedId(), "amb@prop_human_bum_shopping_cart@male@idle_a", "idle_c", 1.0)
        MRFW.Functions.Notify("Fail", "error")
    end)
end

function ChocolateFilling()

    TriggerServerEvent("MRFW:Server:RemoveItem", "mcd-cup", 1)
    TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["mcd-cup"], "remove")
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "cmaking", 0.8)
    MRFW.Functions.Progressbar("empty_bottle", "Filling Hot Chocolate ..", 10000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {
		animDict = "amb@prop_human_bum_shopping_cart@male@idle_a",
		anim = "idle_c",
		flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(PlayerPedId(), "amb@prop_human_bum_shopping_cart@male@idle_a", "idle_c", 1.0)
        TriggerServerEvent("MRFW:Server:AddItem", "mcd-hchocolate", 1)
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["mcd-hchocolate"], "add")
    end, function() -- Cancel
        StopAnimTask(PlayerPedId(), "amb@prop_human_bum_shopping_cart@male@idle_a", "idle_c", 1.0)
        MRFW.Functions.Notify("Fail", "error")
    end)
end

function CaramelFilling()

    TriggerServerEvent("MRFW:Server:RemoveItem", "mcd-cup", 1)
    TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["mcd-cup"], "remove")
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "cmaking", 0.8)
    MRFW.Functions.Progressbar("empty_bottle", "Filling Caramel Latte ..", 10000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {
		animDict = "amb@prop_human_bum_shopping_cart@male@idle_a",
		anim = "idle_c",
		flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(PlayerPedId(), "amb@prop_human_bum_shopping_cart@male@idle_a", "idle_c", 1.0)
        TriggerServerEvent("MRFW:Server:AddItem", "mcd-caramel", 1)
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["mcd-caramel"], "add")
    end, function() -- Cancel
        StopAnimTask(PlayerPedId(), "amb@prop_human_bum_shopping_cart@male@idle_a", "idle_c", 1.0)
        MRFW.Functions.Notify("Fail", "error")
    end)
end

function niks()
    -- print('niks')
end

function OpenMenu()
    ClearMenu()
    Menu.addButton("Options", "VehicleOptions", nil)
    Menu.addButton("Close Menu", "CloseMenu", nil) 
end

function VehicleList()
    ClearMenu()
    for k, v in pairs(Config.Vehicles) do
        Menu.addButton(v, "SpawnListVehicle", k) 
    end
    Menu.addButton("Close Menu", "CloseMenu", nil) 
end

function SpawnListVehicle(model)
    local coords = {
        x = Config.Locations["vehicle"].x,
        y = Config.Locations["vehicle"].y,
        z = Config.Locations["vehicle"].z,
        h = Config.Locations["vehicle"].h,
    }
    local plate = "AC"..math.random(1111, 9999)
    -- local vehNear = MRFW.Functions.CheckFuckingCar(coords)
    -- if vehNear > 5 then
    --    MRFW.Functions.Notify('There is a vehicle at the spot', 'error', 3000)
    -- else
        MRFW.Functions.SpawnVehicle(model, function(veh)
            SetVehicleNumberPlateText(veh, "ACBV"..tostring(math.random(1000, 9999)))
            exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'body', 1000.0)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'engine', 1000.0)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'fuel', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'clutch', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'brakes', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'axle', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'radiator', 100)
            SetEntityHeading(veh, coords.h)
            exports['mr-fuel']:SetFuel(veh, 100.0)
            Menu.hidden = true
            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
            TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
            SetVehicleEngineOn(veh, true, true)
        end, coords, true)
    -- end
end

-- Menu Functions

CloseMenu = function()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
end

ClearMenu = function()
	--Menu = {}
	Menu.GUI = {}
	Menu.buttonCount = 0
	Menu.selection = 0
end

function noSpace(str)
    local normalisedString = string.gsub(str, "%s+", "")
    return normalisedString
end

local debug = true

Citizen.CreateThread(function()
    ---Tables
    exports['mr-eye']:AddBoxZone("McdTable", vector3(75.7, 282.19, 110.21), 1.0, 1.6, { name="McdTable", heading = 91.0, debugPoly=true, minZ=21.49, maxZ=22.89 }, 
        { options = { {  event = "mcd-table:Stash", icon = "fas fa-box-open", label = "Table", stash = "Table_1" }, }, distance = 2.0 })
    -- exports['mr-eye']:AddBoxZone("McdTable2", vector3(-573.44, -1063.45, 22.34), 1.9, 1.0, { name="McdTable", heading = 91.0, debugPoly=debug, minZ=21.49, maxZ=22.89 }, 
    --     { options = { {  event = "mcd-table:Stash", icon = "fas fa-box-open", label = "Table", stash = "Table_2" }, }, distance = 2.0 })
    -- exports['mr-eye']:AddBoxZone("McdTable3", vector3(-573.41, -1067.09, 22.49), 1.9, 1.0, { name="McdTable", heading = 91.0, debugPoly=debug, minZ=21.49, maxZ=22.89 }, 
    --     { options = { {  event = "mcd-table:Stash", icon = "fas fa-box-open", label = "Table", stash = "Table_3" }, }, distance = 2.0 })
    -- exports['mr-eye']:AddBoxZone("McdTable4", vector3(-578.68, -1051.09, 22.35), 1.2, 0.9, { name="McdTable", heading = 91.0, debugPoly=debug, minZ=21.49, maxZ=22.89 }, 
    --     { options = { {  event = "mcd-table:Stash", icon = "fas fa-box-open", label = "Table", stash = "Table_4" }, }, distance = 2.0 })	
end)

RegisterNetEvent('mcd-table:Stash')
AddEventHandler('mcd-table:Stash',function(data)
	id = data.stash
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "MCD_"..id,
    {
        maxweight = 200000,
        slots = 25,
    })
    TriggerEvent("inventory:client:SetCurrentStash", "MCD_"..id)
end)