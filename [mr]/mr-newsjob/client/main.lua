PlayerJob = {}

local function DrawText3D(x, y, z, text)
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

RegisterNetEvent('MRFW:Client:OnPlayerLoaded', function()
    PlayerJob = MRFW.Functions.GetPlayerData().job

    if PlayerJob.name == "reporter" then
        local blip = AddBlipForCoord(Config.Locations["vehicle"].coords.x, Config.Locations["vehicle"].coords.y, Config.Locations["vehicle"].coords.z)
        SetBlipSprite(blip, 225)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.6)
        SetBlipAsShortRange(blip, true)
        SetBlipColour(blip, 1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.Locations["vehicle"].label)
        EndTextCommandSetBlipName(blip)
    end
end)

RegisterNetEvent('MRFW:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo

    if PlayerJob.name == "reporter" then
        local blip = AddBlipForCoord(Config.Locations["vehicle"].coords.x, Config.Locations["vehicle"].coords.y, Config.Locations["vehicle"].coords.z)
        SetBlipSprite(blip, 225)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.6)
        SetBlipAsShortRange(blip, true)
        SetBlipColour(blip, 1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.Locations["vehicle"].label)
        EndTextCommandSetBlipName(blip)
    end
end)
local showText = false

Citizen.CreateThread(function()
    -- local blip = AddBlipForCoord(Config.Locations["main"].coords.x, Config.Locations["main"].coords.y, Config.Locations["main"].coords.z)
    -- SetBlipSprite(blip, 459)
    -- SetBlipDisplay(blip, 4)
    -- SetBlipScale(blip, 0.6)
    -- SetBlipAsShortRange(blip, true)
    -- SetBlipColour(blip, 1)
    -- BeginTextCommandSetBlipName("STRING")
    -- AddTextComponentSubstringPlayerName(Config.Locations["main"].label)
    -- EndTextCommandSetBlipName(blip)
    while true do 
        Citizen.Wait(1)
        if LocalPlayer.state['isLoggedIn'] and MRFW ~= nil then
            local pos = GetEntityCoords(PlayerPedId())
            if PlayerJob.name == "reporter" then
                if #(pos - vector3(Config.Locations["vehicle"].coords.x, Config.Locations["vehicle"].coords.y, Config.Locations["vehicle"].coords.z)) < 10.0 then
                    DrawMarker(2, Config.Locations["vehicle"].coords.x, Config.Locations["vehicle"].coords.y, Config.Locations["vehicle"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                    if #(pos - vector3(Config.Locations["vehicle"].coords.x, Config.Locations["vehicle"].coords.y, Config.Locations["vehicle"].coords.z)) < 1.5 then
                        if IsPedInAnyVehicle(PlayerPedId(), false) then
                            if not showText then
                                exports['mr-text']:DrawText(
                                    '[E] Store the Vehicle',
                                    0, 94, 255,0.7,
                                    1,
                                    50
                                )
                                showText = true
                            end
                            -- DrawText3D(Config.Locations["vehicle"].coords.x, Config.Locations["vehicle"].coords.y, Config.Locations["vehicle"].coords.z, "~g~E~w~ - Store the Vehicle")
                        else
                            if not showText then
                                exports['mr-text']:DrawText(
                                    '[E] Vehicles',
                                    0, 94, 255,0.7,
                                    1,
                                    50
                                )
                                showText = true
                            end
                            -- DrawText3D(Config.Locations["vehicle"].coords.x, Config.Locations["vehicle"].coords.y, Config.Locations["vehicle"].coords.z, "~g~E~w~ - Vehicles")
                        end
                        if IsControlJustReleased(0, 38) then
                            if IsPedInAnyVehicle(PlayerPedId(), false) then
                                exports['mr-text']:DrawText(
                                    '[E] Vehicles',
                                    0, 94, 255,0.7,
                                    1,
                                    50
                                )
                                DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
                            else
                                MenuGarage()
                                Menu.hidden = not Menu.hidden
                            end
                        end
                        Menu.renderGUI()
                    else
                        if showText then
                            exports['mr-text']:HideText(1)
                            showText = false
                        end
                    end 
                end
                if #(pos - vector3(Config.Locations["vehicle2"].coords.x, Config.Locations["vehicle2"].coords.y, Config.Locations["vehicle2"].coords.z)) < 10.0 then
                    DrawMarker(2, Config.Locations["vehicle2"].coords.x, Config.Locations["vehicle2"].coords.y, Config.Locations["vehicle2"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                    if #(pos - vector3(Config.Locations["vehicle2"].coords.x, Config.Locations["vehicle2"].coords.y, Config.Locations["vehicle2"].coords.z)) < 1.5 then
                        if IsPedInAnyVehicle(PlayerPedId(), false) then
                            if not showText then
                                exports['mr-text']:DrawText(
                                    '[E] Heli',
                                    0, 94, 255,0.7,
                                    1,
                                    50
                                )
                                showText = true
                            end
                            -- DrawText3D(Config.Locations["vehicle2"].coords.x, Config.Locations["vehicle2"].coords.y, Config.Locations["vehicle2"].coords.z, "~g~E~w~ - Heli")
                        else
                            if not showText then
                                exports['mr-text']:DrawText(
                                    '[E] Heli',
                                    0, 94, 255,0.7,
                                    1,
                                    50
                                )
                                showText = true
                            end
                            -- DrawText3D(Config.Locations["vehicle2"].coords.x, Config.Locations["vehicle2"].coords.y, Config.Locations["vehicle2"].coords.z, "~g~E~w~ - Heli")
                        end
                        if IsControlJustReleased(0, 38) then
                            if IsPedInAnyVehicle(PlayerPedId(), false) then
                                exports['mr-text']:DrawText(
                                    '[E] Vehicles',
                                    0, 94, 255,0.7,
                                    1,
                                    50
                                )
                                DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
                            else
                                MenuGarageRoof()
                                Menu.hidden = not Menu.hidden
                            end
                        end
                        Menu.renderGUI()
                    else
                        if showText then
                            exports['mr-text']:HideText(1)
                            showText = false
                        end
                    end
                end
                if #(pos - vector3(Config.Locations["stash"].coords.x, Config.Locations["stash"].coords.y, Config.Locations["stash"].coords.z)) < 10.0 then
                    DrawMarker(2, Config.Locations["stash"].coords.x, Config.Locations["stash"].coords.y, Config.Locations["stash"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                    if #(pos - vector3(Config.Locations["stash"].coords.x, Config.Locations["stash"].coords.y, Config.Locations["stash"].coords.z)) < 1.5 then
                        if not showText then
                            exports['mr-text']:DrawText(
                                '[E] Personal Stash',
                                0, 94, 255,0.7,
                                1,
                                50
                            )
                            showText = true
                        end
                        -- DrawText3D(Config.Locations["stash"].coords.x, Config.Locations["stash"].coords.y, Config.Locations["stash"].coords.z, "~g~E~w~ - Personal Stash")
                        if IsControlJustReleased(0, 38) then
                            if IsControlJustReleased(0, 38) then
                                TriggerServerEvent("inventory:server:OpenInventory", "stash", "reporterstash_"..MRFW.Functions.GetPlayerData().citizenid)
                                TriggerEvent("inventory:client:SetCurrentStash", "reporterstash_"..MRFW.Functions.GetPlayerData().citizenid)
                            end
                        end
                    else
                        if showText then
                            exports['mr-text']:HideText(1)
                            showText = false
                        end
                    end
                end
            else
                Citizen.Wait(2500)
            end
        else
            Citizen.Wait(2500)
        end
    end
end)

function MenuGarage()
    ped = PlayerPedId();
    MenuTitle = "Garage"
    ClearMenu()
    Menu.addButton("Vehicles", "VehicleList", nil)
    Menu.addButton("Close Menu", "closeMenuFull", nil) 
end

function VehicleList(isDown)
    ped = PlayerPedId();
    MenuTitle = "Vehicles:"
    ClearMenu()
    for k, v in pairs(Config.Vehicles) do
        Menu.addButton(Config.Vehicles[k], "TakeOutVehicle", k, "Garage", " Motor: 100%", " Body: 100%", " Fuel: 100%")
    end
        
    Menu.addButton("Back", "MenuGarage",nil)
end

function TakeOutVehicle(vehicleInfo)
    local coords = Config.Locations["vehicle"].coords
    MRFW.Functions.SpawnVehicle(vehicleInfo, function(veh)
        SetVehicleNumberPlateText(veh, "TOWR"..tostring(math.random(1000, 9999)))
        exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'body', 1000.0)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'engine', 1000.0)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'fuel', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'clutch', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'brakes', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'axle', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'radiator', 100)
        SetEntityHeading(veh, coords.w)
        exports['mr-fuel']:SetFuel(veh, 100.0)
        closeMenuFull()
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", MRFW.Functions.GetPlate(veh))
        SetVehicleEngineOn(veh, true, true)
        CurrentPlate = MRFW.Functions.GetPlate(veh)
    end, coords, true)
    exports['mr-text']:DrawText(
        '[E] Store the Vehicle',
        0, 94, 255,0.7,
        1,
        50
    )
end

function closeMenuFull()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
end

function MenuGarageRoof()
    ped = PlayerPedId();
    MenuTitle = "Garage"
    ClearMenu()
    Menu.addButton("Vehicle", "VehicleListRoof", nil)
    Menu.addButton("Close menu", "closeMenuFullRoof", nil)
end

function VehicleListRoof(isDown2)
    ped = PlayerPedId();
    MenuTitle = "Vehicle:"
    ClearMenu()
    for k, v in pairs(Config.HeliVehicles) do
        Menu.addButton(Config.HeliVehicles[k], "TakeOutVehicleRoof", k, "Garage", " Engine: 100%", " Body: 100%", " Fuel: 100%")
    end

    Menu.addButton("Return", "MenuGarage",nil)
end

function TakeOutVehicleRoof(vehicleInfo)
    local coords = Config.Locations["vehicle2"].coords
    MRFW.Functions.SpawnVehicle(vehicleInfo, function(veh)
        SetVehicleNumberPlateText(veh, "TOWR"..tostring(math.random(1000, 9999)))
        exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'body', 1000.0)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'engine', 1000.0)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'fuel', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'clutch', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'brakes', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'axle', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'radiator', 100)
        SetEntityHeading(veh, coords.h)
        exports['mr-fuel']:SetFuel(veh, 100.0)
        closeMenuFull()
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", MRFW.Functions.GetPlate(veh))
        SetVehicleEngineOn(veh, true, true)
        CurrentPlate = MRFW.Functions.GetPlate(veh)
    end, coords, true)
    exports['mr-text']:DrawText(
        '[E] Vehicles',
        0, 94, 255,0.7,
        1,
        50
    )
end

function closeMenuFullRoof()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
end