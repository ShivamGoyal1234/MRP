local CurrentDock = nil
local ClosestDock = nil
local PoliceBlip = nil

RegisterNetEvent('MRFW:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    if PlayerJob.name == "police" then
        if PoliceBlip ~= nil then
            RemoveBlip(PoliceBlip)
        end
        PoliceBlip = AddBlipForCoord(MR-Boatshop.PoliceBoat.x, MR-Boatshop.PoliceBoat.y, MR-Boatshop.PoliceBoat.z)
        SetBlipSprite(PoliceBlip, 410)
        SetBlipDisplay(PoliceBlip, 4)
        SetBlipScale(PoliceBlip, 0.8)
        SetBlipAsShortRange(PoliceBlip, true)
        SetBlipColour(PoliceBlip, 29)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Police Boats")
        EndTextCommandSetBlipName(PoliceBlip)
    end
end)

local showText = false
local showText2 = false

CreateThread(function()
    while true do
        sleep = 2500
        if LocalPlayer.state['isLoggedIn'] then
            sleep = 1500
            if PlayerJob.name == "police" then
                local pos = GetEntityCoords(PlayerPedId())
                sleep = 1000
                local dist = #(pos - vector3(MR-Boatshop.PoliceBoat.x, MR-Boatshop.PoliceBoat.y, MR-Boatshop.PoliceBoat.z))
                if dist < 10 then
                    sleep = 5
                    DrawMarker(2, MR-Boatshop.PoliceBoat.x, MR-Boatshop.PoliceBoat.y, MR-Boatshop.PoliceBoat.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                    if #(pos - vector3(MR-Boatshop.PoliceBoat.x, MR-Boatshop.PoliceBoat.y, MR-Boatshop.PoliceBoat.z)) < 1 then
                        if not showText then
                            exports['mr-text']:DrawText(
                                '[E] Take Boat',
                                0, 94, 255,0.7,
                                1,
                                50
                            )
                            showText = true
                        end
                        if IsControlJustReleased(0, 38) then
                            local coords = MR-Boatshop.PoliceBoatSpawn
                            MRFW.Functions.SpawnVehicle("predator", function(veh)
                                SetVehicleNumberPlateText(veh, "PBOA"..tostring(math.random(1000, 9999)))
                                exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'body', 1000.0)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'engine', 1000.0)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'fuel', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'clutch', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'brakes', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'axle', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'radiator', 100)
                                SetEntityHeading(veh, coords.w)
                                exports['mr-fuel']:SetFuel(veh, 100.0)
                                TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                                TriggerEvent("vehiclekeys:client:SetOwner", MRFW.Functions.GetPlate(veh))
                                SetVehicleEngineOn(veh, true, true)
                            end, coords, true)
                            if showText then
                                exports['mr-text']:HideText(1)
                                showText = false
                            end
                        end
                    else
                        if showText then
                            exports['mr-text']:HideText(1)
                            showText = false
                        end
                    end
                end
            end
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        sleep = 2500
        if LocalPlayer.state['isLoggedIn'] then
            sleep = 1500
            if PlayerJob.name == "police" then
                local pos = GetEntityCoords(PlayerPedId())
                sleep = 1000
                local dist = #(pos - vector3(MR-Boatshop.PoliceBoat2.x, MR-Boatshop.PoliceBoat2.y, MR-Boatshop.PoliceBoat2.z))
                if dist < 10 then
                    sleep = 5
                    DrawMarker(2, MR-Boatshop.PoliceBoat2.x, MR-Boatshop.PoliceBoat2.y, MR-Boatshop.PoliceBoat2.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                    if #(pos - vector3(MR-Boatshop.PoliceBoat2.x, MR-Boatshop.PoliceBoat2.y, MR-Boatshop.PoliceBoat2.z)) < 1 then
                        if not showText then
                            exports['mr-text']:DrawText(
                                '[E] Take Boat',
                                0, 94, 255,0.7,
                                1,
                                50
                            )
                            showText = true
                        end
                        if IsControlJustReleased(0, 38) then
                            local coords = MR-Boatshop.PoliceBoatSpawn2
                            MRFW.Functions.SpawnVehicle("predator", function(veh)
                                SetVehicleNumberPlateText(veh, "PBOA"..tostring(math.random(1000, 9999)))
                                exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'body', 1000.0)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'engine', 1000.0)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'fuel', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'clutch', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'brakes', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'axle', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'radiator', 100)
                                SetEntityHeading(veh, coords.w)
                                exports['mr-fuel']:SetFuel(veh, 100.0)
                                TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                                TriggerEvent("vehiclekeys:client:SetOwner", MRFW.Functions.GetPlate(veh))
                                SetVehicleEngineOn(veh, true, true)
                            end, coords, true)
                            if showText then
                                exports['mr-text']:HideText(1)
                                showText = false
                            end
                        end
                    else
                        if showText then
                            exports['mr-text']:HideText(1)
                            showText = false
                        end
                    end
                end
            end
        end
        Wait(sleep)
    end
end)

-- CreateThread(function()
--     while true do
--         sleep = 2500
--         local inRange = false
--         local Ped = PlayerPedId()
--         local Pos = GetEntityCoords(Ped)

--         for k, v in pairs(MR-Boatshop.Docks) do
--             local TakeDistance = #(Pos - vector3(v.coords.take.x, v.coords.take.y, v.coords.take.z))

--             if TakeDistance < 50 then
--                 sleep = 500
--                 ClosestDock = k
--                 inRange = true
--                 PutDistance = #(Pos - vector3(v.coords.put.x, v.coords.put.y, v.coords.put.z))

--                 local inBoat = IsPedInAnyBoat(Ped)

--                 if inBoat then
--                         sleep = 5
--                         DrawMarker(35, v.coords.put.x, v.coords.put.y, v.coords.put.z + 0.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.7, 1.7, 1.7, 255, 55, 15, 255, false, false, false, true, false, false, false)
--                     if PutDistance < 2 then
--                         if inBoat then
--                             if not showText2 then
--                                 exports['mr-text']:DrawText(
--                                     '[E] Remove boat',
--                                     0, 94, 255,0.7,
--                                     2,
--                                     50
--                                 )
--                                 showText2 = true
--                             end
--                             if IsControlJustPressed(0, 38) then
--                                 RemoveVehicle()
--                             end
--                         end
--                     elseif PutDistance < 2 then
--                         if showText2 then
--                             exports['mr-text']:HideText(2)
--                             showText2 = false
--                         end
--                     end
--                 end

--                 if not inBoat then
--                     sleep = 5
--                     DrawMarker(2, v.coords.take.x, v.coords.take.y, v.coords.take.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.5, -0.30, 15, 255, 55, 255, false, false, false, true, false, false, false)
--                     if TakeDistance < 1 then
--                         if not showText then
--                             exports['mr-text']:DrawText(
--                                 '[E] Take the boat',
--                                 0, 94, 255,0.7,
--                                 1,
--                                 50
--                             )
--                             showText = true
--                         end
--                         -- DrawText3D(v.coords.take.x, v.coords.take.y, v.coords.take.z, '~g~E~w~ - Take the boat')
--                         if IsControlJustPressed(1, 177) and not Menu.hidden then
--                             CloseMenu()
--                             PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
--                             CurrentDock = nil
--                         elseif IsControlJustPressed(0, 38) and Menu.hidden then
--                             MenuGarage()
--                             Menu.hidden = not Menu.hidden
--                             CurrentDock = k
--                         end
--                         Menu.renderGUI()
--                     else
--                         if showText then
--                             exports['mr-text']:HideText(1)
--                             showText = false
--                         end
--                     end
--                 end
--             elseif TakeDistance > 51 then
--                 if ClosestDock ~= nil then
--                     ClosestDock = nil
--                 end
--             end
--         end

--         for k, v in pairs(MR-Boatshop.Depots) do
--             local TakeDistance = #(Pos - vector3(v.coords.take.x, v.coords.take.y, v.coords.take.z))

--             if TakeDistance < 50 then
--                 sleep = 500
--                 ClosestDock = k
--                 inRange = true
--                 PutDistance = #(Pos - vector3(v.coords.put.x, v.coords.put.y, v.coords.put.z))

--                 local inBoat = IsPedInAnyBoat(Ped)

--                 if not inBoat then
--                     sleep = 5
--                     DrawMarker(2, v.coords.take.x, v.coords.take.y, v.coords.take.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.5, -0.30, 15, 255, 55, 255, false, false, false, true, false, false, false)
--                     if TakeDistance < 1 then
--                         if not showText then
--                             exports['mr-text']:DrawText(
--                                 '[E] Take the boat',
--                                 0, 94, 255,0.7,
--                                 1,
--                                 50
--                             )
--                             showText = true
--                         end
--                         -- DrawText3D(v.coords.take.x, v.coords.take.y, v.coords.take.z, '~g~E~w~ -Boat storage')
--                         if IsControlJustPressed(1, 177) and not Menu.hidden then
--                             CloseMenu()
--                             PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
--                             CurrentDock = nil
--                         elseif IsControlJustPressed(0, 38) and Menu.hidden then
--                             MenuBoatDepot()
--                             Menu.hidden = not Menu.hidden
--                             CurrentDock = k
--                         end
--                         Menu.renderGUI()
--                     else
--                         if showText then
--                             exports['mr-text']:HideText(1)
--                             showText = false
--                         end
--                     end
--                 end
--             elseif TakeDistance > 51 then
--                 if ClosestDock ~= nil then
--                     ClosestDock = nil
--                 end
--             end
--         end


--         Wait(sleep)
--     end
-- end)

function Trim(value)
	if value then
		return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
	else
		return nil
	end
end

function RemoveVehicle()
    local ped = PlayerPedId()
    local Boat = IsPedInAnyBoat(ped)

    if Boat then
        local CurVeh = GetVehiclePedIsIn(ped)
        local totalFuel = exports['mr-fuel']:GetFuel(CurVeh)
        TriggerServerEvent('mr-diving:server:SetBoatState', Trim(MRFW.Functions.GetPlate(CurVeh)), 1, ClosestDock, totalFuel)

        MRFW.Functions.DeleteVehicle(CurVeh)
        SetEntityCoords(ped, MR-Boatshop.Docks[ClosestDock].coords.take.x, MR-Boatshop.Docks[ClosestDock].coords.take.y, MR-Boatshop.Docks[ClosestDock].coords.take.z)
        if showText2 then
            exports['mr-text']:HideText(2)
            showText2 = false
        end
    end
end

CreateThread(function()
    -- for k, v in pairs(MR-Boatshop.Docks) do
    --     DockGarage = AddBlipForCoord(v.coords.put.x, v.coords.put.y, v.coords.put.z)

    --     SetBlipSprite (DockGarage, 410)
    --     SetBlipDisplay(DockGarage, 4)
    --     SetBlipScale  (DockGarage, 0.8)
    --     SetBlipAsShortRange(DockGarage, true)
    --     SetBlipColour(DockGarage, 3)

    --     BeginTextCommandSetBlipName("STRING")
    --     AddTextComponentSubstringPlayerName(v.label)
    --     EndTextCommandSetBlipName(DockGarage)
    -- end

    -- for k, v in pairs(MR-Boatshop.Depots) do
    --     BoatDepot = AddBlipForCoord(v.coords.take.x, v.coords.take.y, v.coords.take.z)

    --     SetBlipSprite (BoatDepot, 410)
    --     SetBlipDisplay(BoatDepot, 4)
    --     SetBlipScale  (BoatDepot, 0.8)
    --     SetBlipAsShortRange(BoatDepot, true)
    --     SetBlipColour(BoatDepot, 3)

    --     BeginTextCommandSetBlipName("STRING")
    --     AddTextComponentSubstringPlayerName(v.label)
    --     EndTextCommandSetBlipName(BoatDepot)
    -- end
end)

-- MENU JAAAAAAAAAAAAAA

function MenuBoatDepot()
    ClearMenu()
    MRFW.Functions.TriggerCallback("mr-diving:server:GetDepotBoats", function(result)
        ped = PlayerPedId();
        MenuTitle = "My Vehicles :"

        if result == nil then
            MRFW.Functions.Notify("You have no vehicles in this Depot", "error", 5000)
            CloseMenu()
        else
            -- Menu.addButton(MR-Boatshop.Depots[CurrentDock].label, "yeet", MR-Boatshop.Depots[CurrentDock].label)

            for k, v in pairs(result) do
                currentFuel = v.fuel
                state = "In Boathouse"

                if v.state == 0 then
                    state = "In Depot"
                end

                Menu.addButton(MR-Boatshop.ShopBoats[v.model]["label"], "TakeOutDepotBoat", v, state, "Fuel: "..currentFuel.. "%")
            end
        end

        Menu.addButton("Back", "MenuGarage", nil)
    end)
end

function VehicleList()
    ClearMenu()
    MRFW.Functions.TriggerCallback("mr-diving:server:GetMyBoats", function(result)
        ped = PlayerPedId();
        MenuTitle = "My Vehicles :"

        if result == nil then
            MRFW.Functions.Notify("You have no vehicles in this Boathouse", "error", 5000)
            CloseMenu()
        else
            -- Menu.addButton(MR-Boatshop.Docks[CurrentDock].label, "yeet", MR-Boatshop.Docks[CurrentDock].label)

            for k, v in pairs(result) do
                currentFuel = v.fuel
                if v.state == 0 then
                    state = "In Depot"
                elseif v.state == 1 then
                    state = "In Boathouse"
                end

                Menu.addButton(MR-Boatshop.ShopBoats[v.model]["label"], "TakeOutVehicle", v, state, "Fuel: "..currentFuel.. "%")
            end
        end

        Menu.addButton("Back", "MenuGarage", nil)
    end, CurrentDock)
end

function TakeOutVehicle(vehicle)
    if vehicle.state == 1 then
        MRFW.Functions.SpawnVehicle(vehicle.model, function(veh)
            SetVehicleNumberPlateText(veh, vehicle.plate)
            SetEntityHeading(veh, MR-Boatshop.Docks[CurrentDock].coords.put.w)
            exports['mr-fuel']:SetFuel(veh, vehicle.fuel)
            MRFW.Functions.Notify("vehicle Out: Fuel: "..currentFuel.. "%", "primary", 4500)
            CloseMenu()
            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
            TriggerEvent("vehiclekeys:client:SetOwner", MRFW.Functions.GetPlate(veh))
            SetVehicleEngineOn(veh, true, true)
            TriggerServerEvent('mr-diving:server:SetBoatState', Trim(MRFW.Functions.GetPlate(veh)), 0, CurrentDock, 100)
        end, MR-Boatshop.Docks[CurrentDock].coords.put, true)
        if showText then
            exports['mr-text']:HideText(1)
            showText = false
        end
    else
        MRFW.Functions.Notify("The boat is not in the boathouse", "error", 4500)
    end
end

function TakeOutDepotBoat(vehicle)
    MRFW.Functions.SpawnVehicle(vehicle.model, function(veh)
        SetVehicleNumberPlateText(veh, vehicle.plate)
        SetEntityHeading(veh, MR-Boatshop.Depots[CurrentDock].coords.put.w)
        exports['mr-fuel']:SetFuel(veh, vehicle.fuel)
        MRFW.Functions.Notify("Vehicle Off: Fuel: "..currentFuel.. "%", "primary", 4500)
        CloseMenu()
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", MRFW.Functions.GetPlate(veh))
        SetVehicleEngineOn(veh, true, true)
    end, MR-Boatshop.Depots[CurrentDock].coords.put, true)
    if showText then
        exports['mr-text']:HideText(1)
        showText = false
    end
end

function MenuGarage()
    ped = PlayerPedId();
    MenuTitle = "Garage"
    ClearMenu()
    Menu.addButton("My Vehicles", "VehicleList", nil)
    Menu.addButton("Close Menu", "CloseMenu", nil)
end

function CloseMenu()
    Menu.hidden = true
    CurrentDock = nil
    ClearMenu()
end

function ClearMenu()
	Menu.GUI = {}
	Menu.buttonCount = 0
	Menu.selection = 0
end
