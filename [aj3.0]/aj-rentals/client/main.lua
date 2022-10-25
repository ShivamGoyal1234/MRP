local AJFW = exports['ajfw']:GetCoreObject()
local SpawnVehicle = false


------Delete below or comment out if using QB-Target
Citizen.CreateThread(function()

        local startLoc = CircleZone:Create(Config.PedCoords, 2.0, {
        name='rental',
        debugPoly=false,
        useZ=true, 
        })

        startLoc:onPlayerInOut(function(isPointInside)
        if isPointInside then
            TriggerEvent('aj-rental:openMenu')
        else
            exports['aj-menu']:closeMenu()
        end
    end)

end)

Citizen.CreateThread(function()

    local startLoc = CircleZone:Create(Config.PedCoords2, 2.0, {
    name='rental',
    debugPoly=false,
    useZ=true, 
    })

    startLoc:onPlayerInOut(function(isPointInside)
    if isPointInside then
        TriggerEvent('aj-rental:openMenu')
    else
        exports['aj-menu']:closeMenu()
    end
end)

end)

Citizen.CreateThread(function()

    local startLoc = CircleZone:Create(Config.PedCoords3, 2.0, {
    name='rental',
    debugPoly=false,
    useZ=true, 
    })

    startLoc:onPlayerInOut(function(isPointInside)
    if isPointInside then
        TriggerEvent('aj-rental:openMenu')
    else
        exports['aj-menu']:closeMenu()
    end
end)

end)
----- Delete above or comment out if using QB-Target

RegisterNetEvent('aj-rental:openMenu', function()
    local pos = GetEntityCoords(PlayerPedId())
    local veh1 = GetDistanceBetweenCoords(pos, Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z, true)
    local veh2 = GetDistanceBetweenCoords(pos, Config.PedCoords2.x, Config.PedCoords2.y, Config.PedCoords2.z, true)
    local veh3 = GetDistanceBetweenCoords(pos, Config.PedCoords3.x, Config.PedCoords3.y, Config.PedCoords3.z, true)
    
    if veh1 < 10 then
        exports['aj-menu']:showHeader({
            {
                header = 'Rental Vehicles',
                isMenuHeader = true,
            },
            {
                id = 1,
                header = 'Return Vehicle ',
                txt = 'Return your rented vehicle.',
                params = {
                    event = 'aj-rental:return',
                }
            },
            {
                id = 2,
                header = Config.Vehicle1,
                txt = '$' .. Config.Vehicle1cost,
                params = {
                    event = 'aj-rental:spawncar',
                    args = {
                        model = Config.Vehicle1Spawncode,
                        money = Config.Vehicle1cost,
                    }
                }
            },
            {
                id = 3,
                header = Config.Vehicle2,
                txt = '$' .. Config.Vehicle2cost,
                params = {
                    event = 'aj-rental:spawncar', 
                    args = {
                        model = Config.Vehicle2Spawncode,
                        money = Config.Vehicle2cost,
                    }
                }
            },
            {
                id = 4,
                header = Config.Vehicle3,
                txt = '$' .. Config.Vehicle3cost,
                params = {
                    event = 'aj-rental:spawncar', 
                    args = {
                        model = Config.Vehicle3Spawncode,
                        money = Config.Vehicle3cost,
                    }
                }
            },
            {
                id = 5,
                header = Config.Vehicle5,
                txt = '$' .. Config.Vehicle5cost,
                params = {
                    event = 'aj-rental:spawncar', 
                    args = {
                        model = Config.Vehicle5Spawncode,
                        money = Config.Vehicle5cost,
                    }
                }
            },
            {
                id = 6,
                header = Config.Vehicle6,
                txt = '$' .. Config.Vehicle6cost,
                params = {
                    event = 'aj-rental:spawncar', 
                    args = {
                        model = Config.Vehicle6Spawncode,
                        money = Config.Vehicle6cost,
                    }
                }
            },
        })
    end

    if veh2 < 10 then
        exports['aj-menu']:showHeader({
            {
                header = 'Rental Vehicles',
                isMenuHeader = true,
            },
            {
                id = 1,
                header = 'Return Vehicle ',
                txt = 'Return your rented vehicle.',
                params = {
                    event = 'aj-rental:return',
                }
            },
            {
                id = 2,
                header = Config.Vehicle1,
                txt = '$' .. Config.Vehicle1cost,
                params = {
                    event = 'aj-rental:spawncar',
                    args = {
                        model = Config.Vehicle1Spawncode,
                        money = Config.Vehicle1cost,
                    }
                }
            },
            {
                id = 3,
                header = Config.Vehicle2,
                txt = '$' .. Config.Vehicle2cost,
                params = {
                    event = 'aj-rental:spawncar', 
                    args = {
                        model = Config.Vehicle2Spawncode,
                        money = Config.Vehicle2cost,
                    }
                }
            },
            {
                id = 4,
                header = Config.Vehicle3,
                txt = '$' .. Config.Vehicle3cost,
                params = {
                    event = 'aj-rental:spawncar', 
                    args = {
                        model = Config.Vehicle3Spawncode,
                        money = Config.Vehicle3cost,
                    }
                }
            },
            {
                id = 5,
                header = Config.Vehicle5,
                txt = '$' .. Config.Vehicle5cost,
                params = {
                    event = 'aj-rental:spawncar', 
                    args = {
                        model = Config.Vehicle5Spawncode,
                        money = Config.Vehicle5cost,
                    }
                }
            },
            {
                id = 6,
                header = Config.Vehicle6,
                txt = '$' .. Config.Vehicle6cost,
                params = {
                    event = 'aj-rental:spawncar', 
                    args = {
                        model = Config.Vehicle6Spawncode,
                        money = Config.Vehicle6cost,
                    }
                }
            },
        })
    end

    if veh3 < 10 then
        exports['aj-menu']:showHeader({
            {
                header = 'Rental Vehicles',
                isMenuHeader = true,
            },
            {
                id = 1,
                header = 'Return Vehicle ',
                txt = 'Return your rented vehicle.',
                params = {
                    event = 'aj-rental:return',
                }
            },
            {
                id = 2,
                header = Config.Vehicle4,
                txt = '$' .. Config.Vehicle4cost,
                params = {
                    event = 'aj-rental:spawncar',
                    args = {
                        model = Config.Vehicle4Spawncode,
                        money = Config.Vehicle4cost,
                    }
                }
            },
        })
    end

end)

CreateThread(function()
    SpawnNPC()
end)


SpawnNPC = function()
    CreateThread(function()
       
        RequestModel(GetHashKey('a_m_y_business_03'))
        while not HasModelLoaded(GetHashKey('a_m_y_business_03')) do
            Wait(1)
        end
        CreateNPC() 
        CreateNPC2()  
        CreateNPC3()
    end)
end


CreateNPC = function()
    created_ped = CreatePed(5, GetHashKey('a_m_y_business_03') , Config.PedCoords, Config.PedHeading, false, true)
    FreezeEntityPosition(created_ped, true)
    SetEntityInvincible(created_ped, true)
    SetBlockingOfNonTemporaryEvents(created_ped, true)
    TaskStartScenarioInPlace(created_ped, 'WORLD_HUMAN_CLIPBOARD', 0, true)
end

CreateNPC2 = function()
    created_ped = CreatePed(5, GetHashKey('a_m_y_business_03') , Config.PedCoords2, Config.PedHeading2, false, true)
    FreezeEntityPosition(created_ped, true)
    SetEntityInvincible(created_ped, true)
    SetBlockingOfNonTemporaryEvents(created_ped, true)
    TaskStartScenarioInPlace(created_ped, 'WORLD_HUMAN_CLIPBOARD', 0, true)
end

CreateNPC3 = function()
    created_ped = CreatePed(5, GetHashKey('a_m_y_business_03') , Config.PedCoords3, Config.PedHeading3, false, true)
    FreezeEntityPosition(created_ped, true)
    SetEntityInvincible(created_ped, true)
    SetBlockingOfNonTemporaryEvents(created_ped, true)
    TaskStartScenarioInPlace(created_ped, 'WORLD_HUMAN_CLIPBOARD', 0, true)
end

function CheckFuckingCar(coords)
    local veh = 1000
    local retval, out = FindFirstVehicle()
    local check
    repeat
        local dist = GetDistanceBetweenCoords(GetEntityCoords(out), coords.x, coords.y, coords.z)
        if dist < veh then
            veh = dist
        end
        check, out = FindNextVehicle(retval, out)
    until not check
    EndFindVehicle(retval)
    return veh
end


RegisterNetEvent('aj-rental:spawncar')
AddEventHandler('aj-rental:spawncar', function(data)
    local money = data.money
    local model = data.model
    local player = PlayerPedId()
    local pos = GetEntityCoords(PlayerPedId())
    local veh1 = GetDistanceBetweenCoords(pos, Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z, true)
    local veh2 = GetDistanceBetweenCoords(pos, Config.PedCoords2.x, Config.PedCoords2.y, Config.PedCoords2.z, true)
    local veh3 = GetDistanceBetweenCoords(pos, Config.PedCoords3.x, Config.PedCoords3.y, Config.PedCoords3.z, true)
    if veh1 < 10 then
        local vehnear = AJFW.Functions.CheckFuckingCar(Config.VehCoords)
        if vehnear < 5 then
            AJFW.Functions.Notify('There is a vehicle at the spot', 'error', 3000)
        else
            if SpawnVehicle == false then
                
                AJFW.Functions.SpawnVehicle(model, function(vehicle)
                    SetVehicleNumberPlateText(vehicle, "RENT"..tostring(math.random(1000, 9999)))
                    exports['aj-mechanicjob']:SetVehicleStatus(AJFW.Functions.GetPlate(vehicle), 'body', 1000.0)
		    exports['aj-mechanicjob']:SetVehicleStatus(AJFW.Functions.GetPlate(vehicle), 'engine', 1000.0)
		    exports['aj-mechanicjob']:SetVehicleStatus(AJFW.Functions.GetPlate(vehicle), 'fuel', 100)
		    exports['aj-mechanicjob']:SetVehicleStatus(AJFW.Functions.GetPlate(vehicle), 'clutch', 100)
		    exports['aj-mechanicjob']:SetVehicleStatus(AJFW.Functions.GetPlate(vehicle), 'brakes', 100)
		    exports['aj-mechanicjob']:SetVehicleStatus(AJFW.Functions.GetPlate(vehicle), 'axle', 100)
		    exports['aj-mechanicjob']:SetVehicleStatus(AJFW.Functions.GetPlate(vehicle), 'radiator', 100)
                    SetEntityHeading(vehicle, 340.0)
                    TaskWarpPedIntoVehicle(player, vehicle, -1)
                    exports['aj-fuel']:SetFuel(vehicle, 100.0)
                    TriggerEvent('vehiclekeys:client:SetOwner', GetVehicleNumberPlateText(vehicle))
                    SetVehicleEngineOn(vehicle, true, true)
                    SetEntityAsMissionEntity(vehicle, true, true)
                    SpawnVehicle = true
                end, Config.VehCoords, true)

                Wait(1000)
                local vehicle = GetVehiclePedIsIn(player, false)
                local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                vehicleLabel = GetLabelText(vehicleLabel)
                local plate = GetVehicleNumberPlateText(vehicle)
                TriggerServerEvent('aj-rental:rentalpapers', plate, vehicleLabel, money)
                rentedcar = vehicle
            else
                AJFW.Functions.Notify('You already have a vehicle rented.', 'error') 
            end
        end
    end

    if veh2 < 10 then
        local vehnear = CheckFuckingCar(Config.VehCoords2)
        if vehnear < 5 then
            AJFW.Functions.Notify('There is a vehicle at the spot', 'error', 3000)
        else
            if SpawnVehicle == false then
                AJFW.Functions.SpawnVehicle(model, function(vehicle)
                    SetVehicleNumberPlateText(vehicle, "RENT"..tostring(math.random(1000, 9999)))
                    exports['aj-mechanicjob']:SetVehicleStatus(AJFW.Functions.GetPlate(vehicle), 'body', 1000.0)
		    exports['aj-mechanicjob']:SetVehicleStatus(AJFW.Functions.GetPlate(vehicle), 'engine', 1000.0)
		    exports['aj-mechanicjob']:SetVehicleStatus(AJFW.Functions.GetPlate(vehicle), 'fuel', 100)
		    exports['aj-mechanicjob']:SetVehicleStatus(AJFW.Functions.GetPlate(vehicle), 'clutch', 100)
		    exports['aj-mechanicjob']:SetVehicleStatus(AJFW.Functions.GetPlate(vehicle), 'brakes', 100)
		    exports['aj-mechanicjob']:SetVehicleStatus(AJFW.Functions.GetPlate(vehicle), 'axle', 100)
		    exports['aj-mechanicjob']:SetVehicleStatus(AJFW.Functions.GetPlate(vehicle), 'radiator', 100)
                    SetEntityHeading(vehicle, 250.38)
                    TaskWarpPedIntoVehicle(player, vehicle, -1)
                    exports['aj-fuel']:SetFuel(vehicle, 100.0)
                    TriggerEvent('vehiclekeys:client:SetOwner', GetVehicleNumberPlateText(vehicle))
                    SetVehicleEngineOn(vehicle, true, true)
                    SetEntityAsMissionEntity(vehicle, true, true)
                    SpawnVehicle = true
                end, Config.VehCoords2, true)

                Wait(1000)
                local vehicle = GetVehiclePedIsIn(player, false)
                local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                vehicleLabel = GetLabelText(vehicleLabel)
                local plate = GetVehicleNumberPlateText(vehicle)
                TriggerServerEvent('aj-rental:rentalpapers', plate, vehicleLabel, money)
                rentedcar = vehicle
            else
                AJFW.Functions.Notify('You already have a vehicle rented.', 'error') 
            end
        end
    end

    if veh3 < 10 then
        local vehnear = CheckFuckingCar(Config.VehCoords3)
        if vehnear < 5 then
            AJFW.Functions.Notify('There is a vehicle at the spot', 'error', 3000)
        else
            if SpawnVehicle == false then
                AJFW.Functions.SpawnVehicle(model, function(vehicle)
                    SetVehicleNumberPlateText(vehicle, "JAIL"..tostring(math.random(1000, 9999)))
                    exports['aj-mechanicjob']:SetVehicleStatus(AJFW.Functions.GetPlate(vehicle), 'body', 1000.0)
		    exports['aj-mechanicjob']:SetVehicleStatus(AJFW.Functions.GetPlate(vehicle), 'engine', 1000.0)
		    exports['aj-mechanicjob']:SetVehicleStatus(AJFW.Functions.GetPlate(vehicle), 'fuel', 100)
		    exports['aj-mechanicjob']:SetVehicleStatus(AJFW.Functions.GetPlate(vehicle), 'clutch', 100)
		    exports['aj-mechanicjob']:SetVehicleStatus(AJFW.Functions.GetPlate(vehicle), 'brakes', 100)
		    exports['aj-mechanicjob']:SetVehicleStatus(AJFW.Functions.GetPlate(vehicle), 'axle', 100)
		    exports['aj-mechanicjob']:SetVehicleStatus(AJFW.Functions.GetPlate(vehicle), 'radiator', 100)
                    SetEntityHeading(vehicle, 283.94)
                    TaskWarpPedIntoVehicle(player, vehicle, -1)
                    exports['aj-fuel']:SetFuel(vehicle, 100.0)
                    TriggerEvent('vehiclekeys:client:SetOwner', GetVehicleNumberPlateText(vehicle))
                    SetVehicleEngineOn(vehicle, true, true)
                    SetEntityAsMissionEntity(vehicle, true, true)
                    SpawnVehicle = true
                end, Config.VehCoords3, true)

                Wait(1000)
                local vehicle = GetVehiclePedIsIn(player, false)
                local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                vehicleLabel = GetLabelText(vehicleLabel)
                local plate = GetVehicleNumberPlateText(vehicle)
                TriggerServerEvent('aj-rental:rentalpapers', plate, vehicleLabel, money)
                rentedcar = vehicle
            else
                AJFW.Functions.Notify('You already have a vehicle rented.', 'error') 
            end
        end
    end

end)

RegisterNetEvent('aj-rental:return')
AddEventHandler('aj-rental:return', function()
    if SpawnVehicle then
        if not IsPedInAnyVehicle(PlayerPedId(), true) then
            AJFW.Functions.TriggerCallback('AJFW:HasItem', function(result)
                if result then
                    local currentcar = AJFW.Functions.GetClosestVehicle()
                    if currentcar ~= nil then 
                        if currentcar == rentedcar then
                            local Player = AJFW.Functions.GetPlayerData()
                            AJFW.Functions.Notify('Returned vehicle!', 'success')
                            TriggerServerEvent('aj-rental:removepapers')
                                if Config.Depositenabled then
                                    TriggerServerEvent('aj-rentals:server:depositpayout')
                                    local health = GetVehicleEngineHealth(rentedcar)  ---Health check test.
                                        if Config.Healthcheck then
                                            TriggerServerEvent('aj-rentals:server:healthcheck', health)
                                        end
                                end
                            NetworkFadeOutEntity(rentedcar, true,false)
                            Citizen.Wait(2000)
                            AJFW.Functions.DeleteVehicle(rentedcar)
                            SpawnVehicle = false
                        else
                            AJFW.Functions.Notify('Please bring the vehicle back in order to return it.', 'error') 
                        end
                    end
                else
                    AJFW.Functions.Notify("You don't have Rental papers..", "error")
                end
            end, "rentalpapers")
        else
            AJFW.Functions.Notify("Get out of vehicle and Submit", "error")
        end 
    else 
        AJFW.Functions.Notify('No vehicle to return', 'error')
    end
end)


Citizen.CreateThread(function()
    VehicleRental = AddBlipForCoord(111.0112, -1088.67, 29.302) 
    SetBlipSprite (VehicleRental, 56)
    SetBlipDisplay(VehicleRental, 4)
    SetBlipScale  (VehicleRental, 0.5)
    SetBlipAsShortRange(VehicleRental, true)
    SetBlipColour(VehicleRental, 77)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Vehicle Rental")
    EndTextCommandSetBlipName(VehicleRental)
end) 

Citizen.CreateThread(function()
    VehicleRental = AddBlipForCoord(-275.62, -997.84, 25.31) 
    SetBlipSprite (VehicleRental, 56)
    SetBlipDisplay(VehicleRental, 4)
    SetBlipScale  (VehicleRental, 0.5)
    SetBlipAsShortRange(VehicleRental, true)
    SetBlipColour(VehicleRental, 77)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Vehicle Rental")
    EndTextCommandSetBlipName(VehicleRental)
end) 

Citizen.CreateThread(function()
    VehicleRental = AddBlipForCoord(1852.13, 2581.85, 44.67) 
    SetBlipSprite (VehicleRental, 56)
    SetBlipDisplay(VehicleRental, 4)
    SetBlipScale  (VehicleRental, 0.5)
    SetBlipAsShortRange(VehicleRental, true)
    SetBlipColour(VehicleRental, 77)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Vehicle Rental")
    EndTextCommandSetBlipName(VehicleRental)
end) 
