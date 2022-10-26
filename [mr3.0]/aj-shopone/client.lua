MRFW = exports['mrfw']:GetCoreObject()


isLoggedIn = true
PlayerJob = {}

local onDuty = false

local blips = {

     {title="Shop One", colour=5, id=103, x = 296.53, y = -1267.64, z = 29.42},
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
            if PlayerData.job.name == "shopone" then
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

RegisterNetEvent('ShopOne:ToggleDuty', function()
    onDuty = not onDuty
    TriggerServerEvent("MRFW:ToggleDuty")
end)


local showText3 = false

Citizen.CreateThread(function()
    while true do
        local inRange = false

        if isLoggedIn then
            if PlayerJob.name == "shopone" then
                local pos = GetEntityCoords(PlayerPedId())
                local StashDistance = GetDistanceBetweenCoords(pos, Config.Locations["stash"].x, Config.Locations["stash"].y, Config.Locations["stash"].z, true)
                local OnDutyDistance = GetDistanceBetweenCoords(pos, Config.Locations["duty"].x, Config.Locations["duty"].y, Config.Locations["duty"].z, true)
                local Storages = GetDistanceBetweenCoords(pos, Config.Locations["storage"].x, Config.Locations["storage"].y, Config.Locations["storage"].z, true)
                local Storages2 = GetDistanceBetweenCoords(pos, Config.Locations["storage2"].x, Config.Locations["storage2"].y, Config.Locations["storage2"].z, true)
                local Storages3 = GetDistanceBetweenCoords(pos, Config.Locations["storage3"].x, Config.Locations["storage3"].y, Config.Locations["storage3"].z, true)
                local BeerFilling = GetDistanceBetweenCoords(pos, Config.Locations["beerfill"].x, Config.Locations["beerfill"].y, Config.Locations["beerfill"].z, true)
                local VehicleDistance = GetDistanceBetweenCoords(pos, Config.Locations["vehicle"].x, Config.Locations["vehicle"].y, Config.Locations["vehicle"].z, true)


                if onDuty then
                    if StashDistance < 20 then
                        inRange = true
                        DrawMarker(2, Config.Locations["stash"].x, Config.Locations["stash"].y, Config.Locations["stash"].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 210, 50, 9, 255, false, false, false, true, false, false, false)

                        if StashDistance < 1 then
                            DrawText3Ds(Config.Locations["stash"].x, Config.Locations["stash"].y, Config.Locations["stash"].z, "[E] Open Stash")
                            if IsControlJustReleased(0, 38) then
                                TriggerEvent("inventory:client:SetCurrentStash", "shoponestash")
                                TriggerServerEvent("inventory:server:OpenInventory", "stash", "shoponestash", {
                                    maxweight = 4000000,
                                    slots = 500,
                                })
                            end
                        end
                    end
                end

                if onDuty then
                    if VehicleDistance < 20 then
                        inRange = true
                        DrawMarker(2, Config.Locations["vehicle"].x, Config.Locations["vehicle"].y, Config.Locations["vehicle"].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 210, 50, 9, 255, false, false, false, true, false, false, false)
                        if VehicleDistance < 1 then
                            local InVehicle = IsPedInAnyVehicle(PlayerPedId())

                            if InVehicle then
                                if not showText3 then
                                    exports['mr-text']:DrawText(
                                        '[E] Hide the vehicle',
                                        151, 39, 78,0.7,
                                        4,
                                        50
                                    )
                                    showText3 = true
                                end
                                -- DrawText3Ds(Config.Locations["vehicle"].x, Config.Locations["vehicle"].y, Config.Locations["vehicle"].z, '[E] Hide the vehicle')
                                if IsControlJustPressed(0, 38) then
                                    CheckPlayers(GetVehiclePedIsIn(PlayerPedId()))
                                end
                            else
                                if not showText3 then
                                    exports['mr-text']:DrawText(
                                        '[E] Grab vehicle',
                                        151, 39, 78,0.7,
                                        4,
                                        50
                                    )
                                    showText3 = true
                                end
                                -- DrawText3Ds(Config.Locations["vehicle"].x, Config.Locations["vehicle"].y, Config.Locations["vehicle"].z, '[E] Grab vehicle')
                                if IsControlJustPressed(0, 38) then
                                    if IsControlJustPressed(0, 38) then
                                        ShopeOne_VehicleList()
                                        -- Menu.hidden = not Menu.hidden
                                    end
                                end
                                -- Menu.renderGUI()
                            end
                        else
                            if showText3 then
                                exports['mr-text']:HideText(4)
                                showText3 = false
                            end
                        end
                    end
                end

                -- if OnDutyDistance < 20 then
                --     inRange = true
                --     DrawMarker(2, Config.Locations["duty"].x, Config.Locations["duty"].y, Config.Locations["duty"].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 210, 50, 9, 255, false, false, false, true, false, false, false)

                --     if OnDutyDistance < 1 then
                --         if not onDuty then
                --             DrawText3Ds(Config.Locations["duty"].x, Config.Locations["duty"].y, Config.Locations["duty"].z, "[E] On Duty")
                --         else
                --             DrawText3Ds(Config.Locations["duty"].x, Config.Locations["duty"].y, Config.Locations["duty"].z, "[E] Off Duty")
                --         end
                --         if IsControlJustReleased(0, 38) then
                --             TriggerServerEvent("MRFW:ToggleDuty")
                --         end
                --     end
                -- end
                

                if Storages < 20 then
                    inRange = true
                    if Storages < 1 then
                        
                        DrawText3Ds(Config.Locations["storage"].x, Config.Locations["storage"].y, Config.Locations["storage"].z, "[E] Storage")

                        if IsControlJustReleased(0, 38) then
                            TriggerEvent('dpemote:custom:animation', {"leanbar"})
                            TriggerServerEvent("inventory:server:OpenInventory", "shop", 'shopone', Config.shopone)
                            Citizen.Wait(3000)
                            TriggerEvent('dpemote:custom:animation', {"c"})
                                
                        end
                    end
                end

                if Storages2 < 20 then
                    inRange = true
                    if Storages2 < 1 then
                        
                        DrawText3Ds(Config.Locations["storage2"].x, Config.Locations["storage2"].y, Config.Locations["storage2"].z, "[E] Storage2")

                        if IsControlJustReleased(0, 38) then
                            TriggerEvent('dpemote:custom:animation', {"leanbar"})
                            TriggerServerEvent("inventory:server:OpenInventory", "shop", 'shopone', Config.shopone)
                            Citizen.Wait(3000)
                            TriggerEvent('dpemote:custom:animation', {"c"})
                                
                        end
                    end
                end

                if Storages3 < 7 then
                    inRange = true
                    if Storages3 < 1 then
                        
                        DrawText3Ds(Config.Locations["storage3"].x, Config.Locations["storage3"].y, Config.Locations["storage3"].z, "[E] Storage3")

                        if IsControlJustReleased(0, 38) then
                            TriggerEvent('dpemote:custom:animation', {"leanbar"})
                            TriggerServerEvent("inventory:server:OpenInventory", "shop", 'shopone', Config.shopone2)
                            Citizen.Wait(3000)
                            TriggerEvent('dpemote:custom:animation', {"c"})
                                
                        end
                    end
                end

                if BeerFilling < 7 then
                    inRange = true
                    if BeerFilling < 1 then
                        
                        DrawText3Ds(Config.Locations["beerfill"].x, Config.Locations["beerfill"].y, Config.Locations["beerfill"].z, "[E] Fill Beer Bottle")

                        if IsControlJustReleased(0, 38) then
                            
                            MRFW.Functions.TriggerCallback('MRFW:HasItem', function(result)
                                if result then
                                    beerFilling()
                                else
                                    MRFW.Functions.Notify("You don't have empty_bottle", "error")
                                end
                            
                            end, 'empty_bottle')
                            
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

        Citizen.Wait(3)
    end
end)

Citizen.CreateThread(function()
    while true do
        local inRange = false

        if isLoggedIn then
            local pos = GetEntityCoords(PlayerPedId())
                local publicstash = GetDistanceBetweenCoords(pos, Config.Locations["openstash"].x, Config.Locations["openstash"].y, Config.Locations["openstash"].z, true)
                local publicstash2 = GetDistanceBetweenCoords(pos, Config.Locations["openstash2"].x, Config.Locations["openstash2"].y, Config.Locations["openstash2"].z, true)

                if publicstash < 7 then
                    inRange = true
                    
                    if publicstash < 2 then
                        DrawText3Ds(Config.Locations["openstash"].x, Config.Locations["openstash"].y, Config.Locations["openstash"].z, "[E] Picking Order")
                        if IsControlJustReleased(0, 38) then
                            TriggerEvent("inventory:client:SetCurrentStash", "open_shoponestash")
                            TriggerServerEvent("inventory:server:OpenInventory", "stash", "open_shoponestash", {
                                maxweight = 4000000,
                                slots = 500,
                            })
                        end
                    end
                end
                -- if publicstash2 < 7 then
                --     inRange = true
                    
                --     if publicstash2 < 2 then
                --         DrawText3Ds(Config.Locations["openstash2"].x, Config.Locations["openstash2"].y, Config.Locations["openstash2"].z, "[E] Open Create")
                --         if IsControlJustReleased(0, 38) then
                --             TriggerEvent("inventory:client:SetCurrentStash", "Gun_create")
                --             TriggerServerEvent("inventory:server:OpenInventory", "stash", "Gun_create", {
                --                 maxweight = 4000000,
                --                 slots = 500,
                --             })
                --         end
                --     end
                -- end

            if not inRange then
                Citizen.Wait(1500)
            end

        else
            Citizen.Wait(1500)
        end

        Citizen.Wait(3)
    end
end)


function noSpace(str)
    local normalisedString = string.gsub(str, "%s+", "")
    return normalisedString
end

function beerFilling()

    TriggerServerEvent("MRFW:Server:RemoveItem", "empty_bottle", 1)
    TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["empty_bottle"], "remove")
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "sodaop", 0.8)
    MRFW.Functions.Progressbar("empty_bottle", "Filling Beer in Bottle..", 8000, false, true, {
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
        TriggerServerEvent("MRFW:Server:AddItem", "beer", 1)
        TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["beer"], "add")
    end, function() -- Cancel
        StopAnimTask(PlayerPedId(), "amb@prop_human_bum_shopping_cart@male@idle_a", "idle_c", 1.0)
        MRFW.Functions.Notify("Fail", "error")
    end)
end


function OpenMenu()
    ClearMenu()
    Menu.addButton("Options", "VehicleOptions", nil)
    Menu.addButton("Close Menu", "CloseMenu", nil) 
end

local ShopeOne

function ShopeOne_VehicleList()
    ShopeOne = MenuV:CreateMenu(false,"ShopeOne Garage", 'topright', 151, 39, 78, 'size-125', 'none', 'menuv')
    for k,v in pairs(Config.Vehicles) do
        ShopeOne:AddButton({
            icon = '🚙',
            label = v,
            select = function(btn)
            MenuV:CloseAll()
            SpawnListVehicle(k)
            end
        })
    end
    MenuV:OpenMenu(ShopeOne)
end

function CheckPlayers(vehicle)
    for i = -1, 5,1 do                
        seat = GetPedInVehicleSeat(vehicle,i)
        if seat ~= 0 then
            TaskLeaveVehicle(seat,vehicle,0)
            SetVehicleDoorsLocked(vehicle)
            Wait(1500)
            MRFW.Functions.DeleteVehicle(vehicle)
        end
   end
   if showText3 then
    exports['mr-text']:HideText(4)
    showText3 = false
end
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
    local vehNear = MRFW.Functions.CheckFuckingCar(coords)
        MRFW.Functions.SpawnVehicle(model, function(veh)
            SetVehicleNumberPlateText(veh, "SO "..tostring(math.random(100, 999)))
            SetEntityHeading(veh, coords.h)
            exports['mr-fuel']:SetFuel(veh, 100.0)
            Menu.hidden = true
            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
            TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
            SetVehicleEngineOn(veh, true, true)
        end, coords, true)
        exports['mr-text']:ChangeText(
            '[E] Hide The Vehicle ',
            151, 39, 78,0.7,
            4,
            50
        )
end

-- Menu Functions

CloseMenu = function()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
end
