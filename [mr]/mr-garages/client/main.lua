local currentHouseGarage = nil
local hasGarageKey = nil
local currentGarage = nil
local OutsideVehicles = {}
local PlayerGang = {}
local menu1
local menu2
local menu1_open = false
local menu2_open = false
local showText = false

RegisterNetEvent('MRFW:Client:OnPlayerLoaded')
AddEventHandler('MRFW:Client:OnPlayerLoaded', function()
    PlayerGang = MRFW.Functions.GetPlayerData().gang
end)

RegisterNetEvent('MRFW:Client:OnGangUpdate')
AddEventHandler('MRFW:Client:OnGangUpdate', function(gang)
    PlayerGang = gang
end)

RegisterNetEvent('mr-garages:client:setHouseGarage')
AddEventHandler('mr-garages:client:setHouseGarage', function(house, hasKey)
    currentHouseGarage = house
    hasGarageKey = hasKey
end)

RegisterNetEvent('mr-garages:client:houseGarageConfig')
AddEventHandler('mr-garages:client:houseGarageConfig', function(garageConfig)
    HouseGarages = garageConfig
end)

RegisterNetEvent('mr-garages:client:addHouseGarage')
AddEventHandler('mr-garages:client:addHouseGarage', function(house, garageInfo)
    HouseGarages[house] = garageInfo
end)

RegisterNetEvent('mr-garages:client:takeOutDepot', function(vehicle, moods, price)
    local VehExists = DoesEntityExist(OutsideVehicles[vehicle.plate])
    if not VehExists then
        if OutsideVehicles and next(OutsideVehicles) then
            if OutsideVehicles[vehicle.plate] then
                local Engine = GetVehicleEngineHealth(OutsideVehicles[vehicle.plate])
                MRFW.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
                    MRFW.Functions.TriggerCallback('mr-garage:server:GetVehicleProperties', function(properties)
                        MRFW.Functions.SetVehicleProperties(veh, properties)
                        enginePercent = round(moods.engineHealth / 10, 0)
                        bodyPercent = round(moods.bodyHealth / 10, 0)
                        currentFuel = round(moods.fuelLevel, 1)

                        if vehicle.plate then
                            DeleteVehicle(OutsideVehicles[vehicle.plate])
                            OutsideVehicles[vehicle.plate] = veh
                            TriggerServerEvent('mr-garages:server:UpdateOutsideVehicles', OutsideVehicles)
                        end

                        SetVehicleNumberPlateText(veh, vehicle.plate)
                        SetEntityHeading(veh, Depots[currentGarage].takeVehicle.w)
                        print('[Garage Debug Variable veh Line:59 Type: ]'.. type(veh)..' Value: '..veh)
                        exports['mr-fuel']:SetFuel(veh, currentFuel)
                        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                        SetEntityAsMissionEntity(veh, true, true)
                        doCarDamage(veh, vehicle)
                        TriggerServerEvent('mr-garage:server:updateVehicleState', 0, vehicle.plate, vehicle.garage)
                        TriggerEvent("vehiclekeys:client:SetOwner", MRFW.Functions.GetPlate(veh))
                        closeMenuFull()
                        SetVehicleEngineOn(veh, true, true)
                    end, vehicle.plate)
                    TriggerServerEvent('mr-garage:server:confirmDepot', price)
                    TriggerEvent("vehiclekeys:client:SetOwner", vehicle.plate)
                end, Depots[currentGarage].spawnPoint, true)
                SetTimeout(250, function()
                    TriggerEvent("vehiclekeys:client:SetOwner", MRFW.Functions.GetPlate(GetVehiclePedIsIn(PlayerPedId(), false)))
                end)
            else
                MRFW.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
                    MRFW.Functions.TriggerCallback('mr-garage:server:GetVehicleProperties', function(properties)
                        MRFW.Functions.SetVehicleProperties(veh, properties)
                        enginePercent = round(moods.engineHealth / 10, 0)
                        bodyPercent = round(moods.bodyHealth / 10, 0)
                        currentFuel = round(moods.fuelLevel, 1)

                        if vehicle.plate then
                            OutsideVehicles[vehicle.plate] = veh
                            TriggerServerEvent('mr-garages:server:UpdateOutsideVehicles', OutsideVehicles)
                        end

                        SetVehicleNumberPlateText(veh, vehicle.plate)
                        SetEntityHeading(veh, Depots[currentGarage].takeVehicle.w)
                        print('[Garage Debug Variable veh Line:90 Type: ]'.. type(veh)..' Value: '..veh)
                        exports['mr-fuel']:SetFuel(veh, currentFuel)
                        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                        SetEntityAsMissionEntity(veh, true, true)
                        doCarDamage(veh, vehicle)
                        TriggerServerEvent('mr-garage:server:updateVehicleState', 0, vehicle.plate, vehicle.garage)
                        TriggerEvent("vehiclekeys:client:SetOwner", MRFW.Functions.GetPlate(veh))
                        closeMenuFull()
                        SetVehicleEngineOn(veh, true, true)
                    end, vehicle.plate)
                    TriggerServerEvent('mr-garage:server:confirmDepot', price)
                    TriggerEvent("vehiclekeys:client:SetOwner", vehicle.plate)
                end, Depots[currentGarage].spawnPoint, true)
                SetTimeout(250, function()
                    TriggerEvent("vehiclekeys:client:SetOwner", MRFW.Functions.GetPlate(GetVehiclePedIsIn(PlayerPedId(), false)))
                end)
            end
        else
            MRFW.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
                MRFW.Functions.TriggerCallback('mr-garage:server:GetVehicleProperties', function(properties)
                    MRFW.Functions.SetVehicleProperties(veh, properties)
                    enginePercent = round(moods.engineHealth / 10, 0)
                    bodyPercent = round(moods.bodyHealth / 10, 0)
                    currentFuel = round(moods.fuelLevel, 1)

                    if vehicle.plate then
                        OutsideVehicles[vehicle.plate] = veh
                        TriggerServerEvent('mr-garages:server:UpdateOutsideVehicles', OutsideVehicles)
                    end

                    SetVehicleNumberPlateText(veh, vehicle.plate)
                    SetEntityHeading(veh, Depots[currentGarage].takeVehicle.w)
                    print('[Garage Debug Variable veh Line:122 Type: ]'.. type(veh)..' Value: '..veh)
                    exports['mr-fuel']:SetFuel(veh, currentFuel)
                    TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                    SetEntityAsMissionEntity(veh, true, true)
                    doCarDamage(veh, vehicle)
                    TriggerServerEvent('mr-garage:server:updateVehicleState', 0, vehicle.plate, vehicle.garage)
                    TriggerEvent("vehiclekeys:client:SetOwner", MRFW.Functions.GetPlate(veh))
                    closeMenuFull()
                    SetVehicleEngineOn(veh, true, true)
                end, vehicle.plate)
                TriggerServerEvent('mr-garage:server:confirmDepot', price)
                TriggerEvent("vehiclekeys:client:SetOwner", vehicle.plate)
            end, Depots[currentGarage].spawnPoint, true)
            SetTimeout(250, function()
                TriggerEvent("vehiclekeys:client:SetOwner", MRFW.Functions.GetPlate(GetVehiclePedIsIn(PlayerPedId(), false)))
            end)
        end
    else
        MRFW.Functions.Notify("Your car is not in impound", "error", 5000)
    end
end)


DrawText3Ds = function(x, y, z, text)
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
local garagelabel = {
    "Casino Parking",
    "Government Garage",
    "EMS Garage",
    "Police Garage",
    "Plane Parking",
    "Heli Parking",
    "Police Parking",
}

CreateThread(function()
    -- for k, v in pairs(Garages) do
    --     if v.showBlip then
    --         local Garage = AddBlipForCoord(Garages[k].takeVehicle.x, Garages[k].takeVehicle.y, Garages[k].takeVehicle.z)

    --         SetBlipSprite (Garage, 357)
    --         SetBlipDisplay(Garage, 4)
    --         SetBlipScale  (Garage, 0.65)
    --         SetBlipAsShortRange(Garage, true)
    --         SetBlipColour(Garage, 3)

    --         BeginTextCommandSetBlipName("STRING")
    --         local Label = "Garages"
    --         for l,s in pairs(garagelabel) do
    --             if Garages[k].label == s then
    --                 Label =Garages[k].label
    --             end
    --         end
    --         AddTextComponentSubstringPlayerName(Label)
    --         EndTextCommandSetBlipName(Garage)
    --     end
    -- end

    for k, v in pairs(Depots) do
        if v.showBlip then
            local Depot = AddBlipForCoord(Depots[k].takeVehicle.x, Depots[k].takeVehicle.y, Depots[k].takeVehicle.z)

            SetBlipSprite (Depot, 68)
            SetBlipDisplay(Depot, 4)
            SetBlipScale  (Depot, 0.7)
            SetBlipAsShortRange(Depot, true)
            SetBlipColour(Depot, 5)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(Depots[k].label)
            EndTextCommandSetBlipName(Depot)
        end
    end
end)

function MenuGarage()
    ped = PlayerPedId();
    MenuTitle = "Garage"
    ClearMenu()
    Menu.addButton("My Vehicles", "VehicleList", nil)
    Menu.addButton("Close Menu", "close", nil)
end

function GangMenuGarage()
    ped = PlayerPedId();
    MenuTitle = "Garage"
    ClearMenu()
    Menu.addButton("My Vehicles", "GangVehicleList", nil)
    Menu.addButton("Close Menu", "close", nil)
end

function MenuDepot()
    ped = PlayerPedId();
    MenuTitle = "Impound"
    ClearMenu()
    Menu.addButton("Depot Vehicles", "DepotList", nil)
    Menu.addButton("Close Menu", "close", nil)
end

function MenuHouseGarage(house)
    ped = PlayerPedId();
    MenuTitle = HouseGarages[house].label
    ClearMenu()
    Menu.addButton("My Vehicles", "HouseGarage", house)
    Menu.addButton("Close Menu", "close", nil)
end

function HouseGarage(house)
    MRFW.Functions.TriggerCallback("mr-garage:server:GetHouseVehicles", function(result)
        ped = PlayerPedId();
        MenuTitle = "Depot Vehicles :"
        ClearMenu()

        if result == nil then
            MRFW.Functions.Notify("You have no vehicles in your garage", "error", 5000)
            closeMenuFull()
        else
            Menu.addButton(HouseGarages[house].label, "HouseGarage", HouseGarages[house].label)

            for k, v in pairs(result) do
                enginePercent = round(v.engine / 10, 0)
                bodyPercent = round(v.body / 10, 0)
                currentFuel = v.fuel
                curGarage = HouseGarages[house].label

                if v.state == 0 then
                    v.state = "Out"
                elseif v.state == 1 then
                    v.state = "Garaged"
                elseif v.state == 2 then
                    v.state = "Impound"
                end

                Menu.addButton(MRFW.Shared.Vehicles[v.vehicle]["name"], "TakeOutGarageVehicle", v, v.state, " Motor: " .. enginePercent.."%", " Body: " .. bodyPercent.."%", " Fuel: "..currentFuel.."%")
            end
        end

        Menu.addButton("Back", "MenuHouseGarage", house)
    end, house)
end

function getPlayerVehicles(garage)
    local vehicles = {}

    return vehicles
end

function DepotList()
    MRFW.Functions.TriggerCallback("mr-garage:server:GetDepotVehicles", function(result)
        ped = PlayerPedId();
        MenuTitle = "Impounded Vehicles :"
        ClearMenu()

        if result == nil then
            MRFW.Functions.Notify("There are no vehicles in the Impound", "error", 5000)
            closeMenuFull()
        else
            Menu.addButton(Depots[currentGarage].label, "DepotList", Depots[currentGarage].label)

            for k, v in pairs(result) do
                enginePercent = round(v.engine / 10, 0)
                bodyPercent = round(v.body / 10, 0)
                currentFuel = v.fuel


                if v.state == 0 then
                    v.state = "Impound"
                end

                Menu.addButton(MRFW.Shared.Vehicles[v.vehicle]["name"], "TakeOutDepotVehicle", v, v.state .. " ($"..v.depotprice..",-)", " Motor: " .. enginePercent.."%", " Body: " .. bodyPercent.."%", " Fuel: "..currentFuel.."%")
            end
        end

        Menu.addButton("Back", "MenuDepot",nil)
    end)
end

function VehicleList()
    MRFW.Functions.TriggerCallback("mr-garage:server:GetUserVehicles", function(result)
        ped = PlayerPedId();
        MenuTitle = "My Vehicles :"
        ClearMenu()

        if result == nil then
            MRFW.Functions.Notify("You have no vehicles in this garage", "error", 5000)
            closeMenuFull()
        else
            Menu.addButton(Garages[currentGarage].label, "VehicleList", Garages[currentGarage].label)

            for k, v in pairs(result) do
                enginePercent = round(v.engine / 10, 0)
                bodyPercent = round(v.body / 10, 0)
                currentFuel = v.fuel
                curGarage = Garages[v.garage].label


                if v.state == 0 then
                    v.state = "Out"
                elseif v.state == 1 then
                    v.state = "Garaged"
                elseif v.state == 2 then
                    v.state = "Impound"
                end

                Menu.addButton(MRFW.Shared.Vehicles[v.vehicle]["name"], "TakeOutVehicle", v, v.state, " Motor: " .. enginePercent .. "%", " Body: " .. bodyPercent.. "%", " Fuel: "..currentFuel.. "%")
            end
        end

        Menu.addButton("Back", "MenuGarage",nil)
    end, currentGarage)
end

function GangVehicleList()
    MRFW.Functions.TriggerCallback("mr-garage:server:GetUserVehicles", function(result)
        ped = PlayerPedId();
        MenuTitle = "My Vehicles :"
        ClearMenu()

        if result == nil then
            MRFW.Functions.Notify("You have no vehicles in this garage", "error", 5000)
            closeMenuFull()
        else
            Menu.addButton(GangGarages[currentGarage].label, "GangVehicleList", GangGarages[currentGarage].label)

            for k, v in pairs(result) do
                enginePercent = round(v.engine / 10, 0)
                bodyPercent = round(v.body / 10, 0)
                currentFuel = v.fuel
                curGarage = GangGarages[v.garage].label



                if v.state == 0 then
                    v.state = "Out"
                elseif v.state == 1 then
                    v.state = "Garaged"
                elseif v.state == 2 then
                    v.state = "Impound"
                end

                Menu.addButton(MRFW.Shared.Vehicles[v.vehicle]["name"], "TakeOutGangVehicle", v, v.state, " Motor: " .. enginePercent .. "%", " Body: " .. bodyPercent.. "%", " Fuel: "..currentFuel.. "%")
            end
        end

        Menu.addButton("Back", "MenuGarage",nil)
    end, currentGarage)
end

function TakeOutVehicle(vehicle)
    if vehicle.state == "Garaged" then
        enginePercent = round(vehicle.engine / 10, 1)
        bodyPercent = round(vehicle.body / 10, 1)
        currentFuel = vehicle.fuel
        local vehNear = MRFW.Functions.CheckFuckingCar(coords)
        if vehNear < 5 then
           MRFW.Functions.Notify('There is a vehicle at the spot', 'error', 3000)
        else
            MRFW.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
                MRFW.Functions.TriggerCallback('mr-garage:server:GetVehicleProperties', function(properties)
    
                    if vehicle.plate ~= nil then
                        OutsideVehicles[vehicle.plate] = veh
                        TriggerServerEvent('mr-garages:server:UpdateOutsideVehicles', OutsideVehicles)
                    end
    
                    MRFW.Functions.SetVehicleProperties(veh, properties)
                    SetVehicleNumberPlateText(veh, vehicle.plate)
                    SetEntityHeading(veh, Garages[currentGarage].spawnPoint.w)
                    print('[Garage Debug Variable veh Line:405 Type: ]'.. type(veh)..' Value: '..veh)
                    exports['mr-fuel']:SetFuel(veh, currentFuel)
                    doCarDamage(veh, vehicle)
                    SetEntityAsMissionEntity(veh, true, true)
                    TriggerServerEvent('mr-garage:server:updateVehicleState', 0, vehicle.plate, vehicle.garage)
                    closeMenuFull()
                    TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                    TriggerEvent("vehiclekeys:client:SetOwner", MRFW.Functions.GetPlate(veh))
                    SetVehicleEngineOn(veh, true, true)
                end, vehicle.plate)
    
            end, Garages[currentGarage].spawnPoint, true)
        end

        
    elseif vehicle.state == "Out" then
        MRFW.Functions.Notify("Is your vehicle in the Depot", "error", 2500)
    elseif vehicle.state == "Impound" then
        MRFW.Functions.Notify("This vehicle was impounded by the Police", "error", 4000)
    end
end

function TakeOutGangVehicle(vehicle)
    if vehicle.state == "Garaged" then
        enginePercent = round(vehicle.engine / 10, 1)
        bodyPercent = round(vehicle.body / 10, 1)
        currentFuel = vehicle.fuel

        MRFW.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
            MRFW.Functions.TriggerCallback('mr-garage:server:GetVehicleProperties', function(properties)

                if vehicle.plate ~= nil then
                    OutsideVehicles[vehicle.plate] = veh
                    TriggerServerEvent('mr-garages:server:UpdateOutsideVehicles', OutsideVehicles)
                end

                MRFW.Functions.SetVehicleProperties(veh, properties)
                SetVehicleNumberPlateText(veh, vehicle.plate)
                SetEntityHeading(veh, GangGarages[currentGarage].spawnPoint.w)
                print('[Garage Debug Variable veh Line:444 Type: ]'.. type(veh)..' Value: '..veh)
                exports['mr-fuel']:SetFuel(veh, currentFuel)
                doCarDamage(veh, vehicle)
                SetEntityAsMissionEntity(veh, true, true)
                TriggerServerEvent('mr-garage:server:updateVehicleState', 0, vehicle.plate, vehicle.garage)
                closeMenuFull()
                TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                TriggerEvent("vehiclekeys:client:SetOwner", MRFW.Functions.GetPlate(veh))
                SetVehicleEngineOn(veh, true, true)
            end, vehicle.plate)

        end, GangGarages[currentGarage].spawnPoint, true)
    elseif vehicle.state == "Out" then
        MRFW.Functions.Notify("Is your vehicle in the Depot", "error", 2500)
    elseif vehicle.state == "Impound" then
        MRFW.Functions.Notify("This vehicle was impounded by the Police", "error", 4000)
    end
end

function TakeOutDepotVehicle(vehicle)
    if vehicle.state == "Impound" then
        TriggerServerEvent("mr-garage:server:PayDepotPrice", vehicle)
        Wait(1000)
    end
end

function TakeOutGarageVehicle(vehicle)
    if vehicle.state == "Garaged" then
        MRFW.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
            MRFW.Functions.TriggerCallback('mr-garage:server:GetVehicleProperties', function(properties)
                MRFW.Functions.SetVehicleProperties(veh, properties)
                enginePercent = round(vehicle.engine / 10, 1)
                bodyPercent = round(vehicle.body / 10, 1)
                currentFuel = vehicle.fuel

                if vehicle.plate ~= nil then
                    OutsideVehicles[vehicle.plate] = veh
                    TriggerServerEvent('mr-garages:server:UpdateOutsideVehicles', OutsideVehicles)
                end

                SetVehicleNumberPlateText(veh, vehicle.plate)
                SetEntityHeading(veh, HouseGarages[currentHouseGarage].takeVehicle.w)
                TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                print('[Garage Debug Variable veh Line:487 Type: ]'.. type(veh)..' Value: '..veh)
                exports['mr-fuel']:SetFuel(veh, currentFuel)
                SetEntityAsMissionEntity(veh, true, true)
                doCarDamage(veh, vehicle)
                TriggerServerEvent('mr-garage:server:updateVehicleState', 0, vehicle.plate, vehicle.garage)
                closeMenuFull()
                TriggerEvent("vehiclekeys:client:SetOwner", MRFW.Functions.GetPlate(veh))
                SetVehicleEngineOn(veh, true, true)
            end, vehicle.plate)
        end, HouseGarages[currentHouseGarage].takeVehicle, true)
    end
end

function doCarDamage(currentVehicle, veh)
	smash = false
    m = json.decode(veh.mods)
	local engine = m.engineHealth + 0.0
	local body = m.bodyHealth + 0.0
	if engine < 200.0 then
		engine = 200.0
    end

    Wait(100)
    if body < 700.0 then
		SmashVehicleWindow(currentVehicle, 0)
		SmashVehicleWindow(currentVehicle, 1)
		SmashVehicleWindow(currentVehicle, 2)
		SmashVehicleWindow(currentVehicle, 3)
		SmashVehicleWindow(currentVehicle, 4)
        SmashVehicleWindow(currentVehicle, 5)
		SmashVehicleWindow(currentVehicle, 6)
		SmashVehicleWindow(currentVehicle, 7)
	end
	if body < 450.0 then
        SetVehicleDoorBroken(currentVehicle, 0, true)
		SetVehicleDoorBroken(currentVehicle, 1, true)
		SetVehicleDoorBroken(currentVehicle, 2, true)
		SetVehicleDoorBroken(currentVehicle, 3, true)
		SetVehicleDoorBroken(currentVehicle, 4, true)
        SetVehicleDoorBroken(currentVehicle, 5, true)
		SetVehicleDoorBroken(currentVehicle, 6, true)
	end
end

function close()
    Menu.hidden = true
end

function closeMenuFull()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
end

function ClearMenu()
	Menu.GUI = {}
	Menu.buttonCount = 0
	Menu.selection = 0
end

function custom_garage(k)
    menu1 = MenuV:CreateMenu(false, 'Garage', 'topright', 0, 100, 0, 'size-125', 'none', 'menuv')
    menu2 = MenuV:CreateMenu(false, 'My Vehicles', 'topright', 0, 100, 0, 'size-125', 'none', 'menuv')
    local jacob_button = menu1:AddButton({
        icon = '🚗',
        label = 'My Vehicles',
        value = menu2,
        description = 'Vehicle List You Have'
    })
    print(k)
    custom_garage_vehiclelist(k)
end

function custom_garage_vehiclelist(k)
    MRFW.Functions.TriggerCallback("mr-garage:server:GetUserVehicles", function(result)
        ped = PlayerPedId();
        MenuTitle = "My Vehicles :"

        if result == nil then
            MRFW.Functions.Notify("You have no vehicles in this garage", "error", 5000)
        else
            for k, v in pairs(result) do
                -- enginePercent = round(v.engine / 10, 0)
                -- bodyPercent = round(v.body / 10, 0)moods.fuelLevel
                
                curGarage = Garages[v.garage].label
                m = json.decode(v.mods)
                enginePercent = round(m.engineHealth / 10, 0)
                bodyPercent = round(m.bodyHealth / 10, 0)
                currentFuel = round(m.fuelLevel, 1)
                if v.state == 0 then
                    v.state = "Out"
                elseif v.state == 1 then
                    v.state = "Garage"
                elseif v.state == 2 then
                    v.state = "Impound"
                end
                local label2 = MRFW.Shared.Vehicles[v.vehicle]["name"]
                if MRFW.Shared.Vehicles[v.vehicle]["brand"] ~= nil then
                    label2 = MRFW.Shared.Vehicles[v.vehicle]["brand"].." "..MRFW.Shared.Vehicles[v.vehicle]["name"]
                end
                -- print(v.state)
                if v.type == Garages[v.garage].access then
                    menu2:AddButton({
                        icon = '🚗',
                        label = label2 .." <br> Motor: " .. enginePercent .. " | Body: " .. bodyPercent.. " | Fuel: "..currentFuel,
                        description = v.state,
                        select = function(btn)
                            MenuV:CloseAll()
                            custom_garage_TakeOutVehicle(v,m)
                        end
                    })
                end
            end
            MenuV:OpenMenu(menu2)
        end
    end, k)
end

function custom_garage_TakeOutVehicle(vehicle, moods)
    if vehicle.state == "Garage" then
        enginePercent = round(moods.engineHealth / 10, 1)
        bodyPercent = round(moods.bodyHealth / 10, 1)
        currentFuel = round(moods.fuelLevel, 1)
        local vehNear = MRFW.Functions.CheckFuckingCar(Garages[currentGarage].spawnPoint)
        if vehNear < 5 then
           MRFW.Functions.Notify('There is a vehicle at the spot', 'error', 3000)
        else
            MRFW.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
                MRFW.Functions.TriggerCallback('mr-garage:server:GetVehicleProperties', function(properties)
    
                    if vehicle.plate ~= nil then
                        OutsideVehicles[vehicle.plate] = veh
                        TriggerServerEvent('mr-garages:server:UpdateOutsideVehicles', OutsideVehicles)
                    end
    
                    if vehicle.vehicle == "urus" then
                        SetVehicleExtra(veh, 1, false)
                        SetVehicleExtra(veh, 2, true)
                    end
    
                    MRFW.Functions.SetVehicleProperties(veh, properties)
                    SetVehicleNumberPlateText(veh, vehicle.plate)
                    SetEntityHeading(veh, Garages[currentGarage].spawnPoint.w)
                    print('[Garage Debug Variable veh Line:640 Type: ]'.. type(veh)..' Value: '..veh)
                    exports['mr-fuel']:SetFuel(veh,currentFuel)
                    doCarDamage(veh, vehicle)
                    SetEntityAsMissionEntity(veh, true, true)
                    TriggerServerEvent('mr-garage:server:updateVehicleState', 0, vehicle.plate, vehicle.garage)
                    MRFW.Functions.Notify("Vehicle Off:Engine " .. enginePercent .. "% Body: " .. bodyPercent.. "% Fuel: "..currentFuel.. "%", "primary", 4500)
                    if showText then
                        exports['mr-text']:HideText(1)
                        showText = false
                    end
                    TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                    TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
                    SetVehicleEngineOn(veh, true, true)
                end, vehicle.plate)
            end, Garages[currentGarage].spawnPoint, true)
            if showText then
                exports['mr-text']:HideText(1)
                showText = false
            end
        end
    elseif vehicle.state == "Out" then
        MRFW.Functions.Notify("Is your vehicle in the Depot", "error", 2500)
    elseif vehicle.state == "Impound" then
        MRFW.Functions.Notify("This vehicle was impounded by the Police", "error", 4000)
    end
end

function custom_ganggarage(k)
    menu1 = MenuV:CreateMenu(false, 'Garage', 'topright', 0, 100, 0, 'size-125', 'none', 'menuv')
    menu2 = MenuV:CreateMenu(false, 'My Vehicles', 'topright', 0, 100, 0, 'size-125', 'none', 'menuv')
    local jacob_button = menu1:AddButton({
        icon = '🚗',
        label = 'My Vehicles',
        value = menu2,
        description = 'Vehicle List You Have'
    })
    custom_ganggarage_vehiclelist(k)
end

function custom_ganggarage_vehiclelist(k)
    MRFW.Functions.TriggerCallback("mr-garage:server:GetUserVehicles", function(result)
        ped = PlayerPedId();
        MenuTitle = "My Vehicles :"

        if result == nil then
            MRFW.Functions.Notify("You have no vehicles in this garage", "error", 5000)
        else
            for k, v in pairs(result) do
                -- enginePercent = round(v.engine / 10, 0)
                -- bodyPercent = round(v.body / 10, 0)
                curGarage = GangGarages[v.garage].label
                m = json.decode(v.mods)
                enginePercent = round(m.engineHealth / 10, 0)
                bodyPercent = round(m.bodyHealth / 10, 0)
                currentFuel = round(m.fuelLevel, 1)
                if v.state == 0 then
                    v.state = "Out"
                elseif v.state == 1 then
                    v.state = "Garage"
                elseif v.state == 2 then
                    v.state = "Impound"
                end
                local label2 = MRFW.Shared.Vehicles[v.vehicle]["name"]
                if MRFW.Shared.Vehicles[v.vehicle]["brand"] ~= nil then
                    label2 = MRFW.Shared.Vehicles[v.vehicle]["brand"].." "..MRFW.Shared.Vehicles[v.vehicle]["name"]
                end
                -- print(v.state)
                if v.type == GangGarages[v.garage].access then
                    menu2:AddButton({
                        icon = '🚗',
                        label = label2 .." <br> Motor: " .. enginePercent .. " | Body: " .. bodyPercent.. " | Fuel: "..currentFuel,
                        description = v.state,
                        select = function(btn)
                            MenuV:CloseAll()
                            custom_ganggarage_TakeOutVehicle(v,m)
                        end
                    })
                end
            end
            MenuV:OpenMenu(menu2)
        end
    end, currentGarage)
end

function custom_ganggarage_TakeOutVehicle(vehicle, moods)
    if vehicle.state == "Garage" then
        enginePercent = round(moods.engineHealth / 10, 1)
        bodyPercent = round(moods.bodyHealth / 10, 1)
        currentFuel = round(moods.fuelLevel, 1)
        local vehNear = MRFW.Functions.CheckFuckingCar(GangGarages[currentGarage].spawnPoint)
        if vehNear < 5 then
            MRFW.Functions.Notify('There is a vehicle at the spot', 'error', 3000)
        else
            MRFW.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
                MRFW.Functions.TriggerCallback('mr-garage:server:GetVehicleProperties', function(properties)

                    if vehicle.plate ~= nil then
                        OutsideVehicles[vehicle.plate] = veh
                        TriggerServerEvent('mr-garages:server:UpdateOutsideVehicles', OutsideVehicles)
                    end

                    if vehicle.vehicle == "urus" then
                        SetVehicleExtra(veh, 1, false)
                        SetVehicleExtra(veh, 2, true)
                    end

                    MRFW.Functions.SetVehicleProperties(veh, properties)
                    SetVehicleNumberPlateText(veh, vehicle.plate)
                    SetEntityHeading(veh, GangGarages[currentGarage].spawnPoint.w)
                    print('[Garage Debug Variable veh Line:739 Type: ]'.. type(veh)..' Value: '..veh)
                    exports['mr-fuel']:SetFuel(veh, currentFuel)
                    doCarDamage(veh, vehicle)
                    SetEntityAsMissionEntity(veh, true, true)
                    TriggerServerEvent('mr-garage:server:updateVehicleState', 0, vehicle.plate, vehicle.garage)
                    MRFW.Functions.Notify("Vehicle Off:Engine " .. enginePercent .. "% Body: " .. bodyPercent.. "% Fuel: "..currentFuel.. "%", "primary", 4500)
                    TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                    TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
                    SetVehicleEngineOn(veh, true, true)
                end, vehicle.plate)

            end, GangGarages[currentGarage].spawnPoint, true)
            if showText then
                exports['mr-text']:HideText(1)
                showText = false
            end
        end
    elseif vehicle.state == "Out" then
        MRFW.Functions.Notify("Is your vehicle in the Depot", "error", 2500)
    elseif vehicle.state == "Impound" then
        MRFW.Functions.Notify("This vehicle was impounded by the Police", "error", 4000)
    end
end

function jacob_depot_menu_garage(k)
    menu1 = MenuV:CreateMenu(false, 'Depot', 'topright', 0, 100, 0, 'size-125', 'none', 'menuv')
    menu2 = MenuV:CreateMenu(false, 'Depot Vehicles', 'topright', 0, 100, 0, 'size-125', 'none', 'menuv')
    local jacob_button = menu1:AddButton({
        icon = '🚗',
        label = 'Depot Vehicles',
        value = menu2,
        description = 'Depot Vehicles List You Have'
    })
    jacob_DepotList(k)
    MenuV:OpenMenu(menu1)
end

function jacob_DepotList(lj)
    MRFW.Functions.TriggerCallback("mr-garage:server:GetDepotVehicles", function(result)
        ped = PlayerPedId();
        if result == nil then
            MRFW.Functions.Notify("There are no vehicles in the Impound", "error", 5000)
            MenuV:CloseAll()
        else
            for k, v in pairs(result) do
                m = json.decode(v.mods)
                enginePercent = round(m.engineHealth / 10, 0)
                bodyPercent = round(m.bodyHealth / 10, 0)
                currentFuel = round(m.fuelLevel, 1)


                if v.state == 0 then
                    v.state = "Impound"
                end

                local label2 = MRFW.Shared.Vehicles[v.vehicle]["name"]
                if MRFW.Shared.Vehicles[v.vehicle]["brand"] ~= nil then
                    label2 = MRFW.Shared.Vehicles[v.vehicle]["brand"].." "..MRFW.Shared.Vehicles[v.vehicle]["name"]
                end
                if Depots[lj].access == 'normal' then
                    if v.type ~= 'boat' and v.type ~= 'plane' and v.type ~= 'heli' then
                        menu2:AddButton({
                            icon = '🚗',
                            label = label2 .." <br> Motor: " .. enginePercent .. " | Body: " .. bodyPercent.. " | Fuel: "..currentFuel,
                            description = v.depotprice,
                            select = function(btn)
                                MenuV:CloseAll()
                                jacob_TakeOutDepotVehicle(v, m)
                            end
                        })
                    end
                elseif Depots[lj].access == 'boat' then
                    if v.type ~= 'normal' and v.type ~= 'plane' and v.type ~= 'heli' then
                        menu2:AddButton({
                            icon = '🚗',
                            label = label2 .." <br> Motor: " .. enginePercent .. " | Body: " .. bodyPercent.. " | Fuel: "..currentFuel,
                            description = v.depotprice,
                            select = function(btn)
                                MenuV:CloseAll()
                                jacob_TakeOutDepotVehicle(v, m)
                            end
                        })
                    end
                elseif Depots[lj].access == 'plane' then
                    if v.type ~= 'boat' and v.type ~= 'normal' and v.type ~= 'heli' then
                        menu2:AddButton({
                            icon = '🚗',
                            label = label2 .." <br> Motor: " .. enginePercent .. " | Body: " .. bodyPercent.. " | Fuel: "..currentFuel,
                            description = v.depotprice,
                            select = function(btn)
                                MenuV:CloseAll()
                                jacob_TakeOutDepotVehicle(v, m)
                            end
                        })
                    end
                elseif Depots[lj].access == 'heli' then
                    if v.type ~= 'boat' and v.type ~= 'plane' and v.type ~= 'normal' then
                        menu2:AddButton({
                            icon = '🚗',
                            label = label2 .." <br> Motor: " .. enginePercent .. " | Body: " .. bodyPercent.. " | Fuel: "..currentFuel,
                            description = v.depotprice,
                            select = function(btn)
                                MenuV:CloseAll()
                                jacob_TakeOutDepotVehicle(v, m)
                            end
                        })
                    end
                end
            end
        end
    end)
end

function jacob_TakeOutDepotVehicle(vehicle, moods)
    if vehicle.state == "Impound" then
        TriggerServerEvent("mr-garage:server:PayDepotPrice", vehicle, moods)
        Citizen.Wait(1000)
        if showText then
            exports['mr-text']:HideText(1)
            showText = false
        end
    end
end

function jacob_Menu_House_Garage(house)
    menu1 = MenuV:CreateMenu(false, HouseGarages[house].label, 'topright', 0, 100, 0, 'size-125', 'none', 'menuv')
    menu2 = MenuV:CreateMenu(false, 'My Vehicles', 'topright', 0, 100, 0, 'size-125', 'none', 'menuv')
    local jacob_button = menu1:AddButton({
        icon = '🚗',
        label = 'My Vehicles',
        value = menu2,
        description = 'Vehicle List You Have'
    })
    jacob_HouseGarage(house)
    -- MenuV:OpenMenu(menu1)
end

function jacob_HouseGarage(house)
    MRFW.Functions.TriggerCallback("mr-garage:server:GetHouseVehicles", function(result)
        ped = PlayerPedId();

        if result == nil then
            MRFW.Functions.Notify("You have no vehicles in your garage", "error", 5000)
            MenuV:CloseAll()
        else
            for k, v in pairs(result) do
                m = json.decode(v.mods)
                enginePercent = round(m.engineHealth / 10, 0)
                bodyPercent = round(m.bodyHealth / 10, 0)
                currentFuel = round(m.fuelLevel, 1)
                curGarage = HouseGarages[house].label

                if v.state == 0 then
                    v.state = "Out"
                elseif v.state == 1 then
                    v.state = "Garage"
                elseif v.state == 2 then
                    v.state = "Impound"
                end

                local label2 = MRFW.Shared.Vehicles[v.vehicle]["name"]
                if MRFW.Shared.Vehicles[v.vehicle]["brand"] ~= nil then
                    label2 = MRFW.Shared.Vehicles[v.vehicle]["brand"].." "..MRFW.Shared.Vehicles[v.vehicle]["name"]
                end

                menu2:AddButton({
                    icon = '🚗',
                    label = label2 .." <br> Motor: " .. enginePercent .. " | Body: " .. bodyPercent.. " | Fuel: "..currentFuel,
                    description = v.state,
                    select = function(btn)
                        MenuV:CloseAll()
                        jacob_TakeOutGarageVehicle(v, m)
                    end
                })
            end
            MenuV:OpenMenu(menu2)
        end
    end, house)
end

function jacob_TakeOutGarageVehicle(vehicle, moods)
    if vehicle.state == "Garage" then
        MRFW.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
            MRFW.Functions.TriggerCallback('mr-garage:server:GetVehicleProperties', function(properties)
                MRFW.Functions.SetVehicleProperties(veh, properties)
                enginePercent = round(moods.engineHealth / 10, 1)
                bodyPercent = round(moods.bodyHealth / 10, 1)
                currentFuel = round(moods.fuelLevel, 1)

                if vehicle.plate ~= nil then
                    OutsideVehicles[vehicle.plate] = veh
                    TriggerServerEvent('mr-garages:server:UpdateOutsideVehicles', OutsideVehicles)
                end

                if vehicle.vehicle == "urus" then
                    SetVehicleExtra(veh, 1, false)
                    SetVehicleExtra(veh, 2, true)
                end

                SetVehicleNumberPlateText(veh, vehicle.plate)
                SetEntityHeading(veh, HouseGarages[currentHouseGarage].takeVehicle.h)
                TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                print('[Garage Debug Variable veh Line:901 Type: ]'.. type(veh)..' Value: '..veh)
                exports['mr-fuel']:SetFuel(veh, currentFuel)
                SetEntityAsMissionEntity(veh, true, true)
                doCarDamage(veh, vehicle)
                TriggerServerEvent('mr-garage:server:updateVehicleState', 0, vehicle.plate, vehicle.garage)
                MRFW.Functions.Notify("Vehicle Off:Engine " .. enginePercent .. "% Body: " .. bodyPercent.. "% Fuel: "..currentFuel.. "%", "primary", 4500)
                TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
                SetVehicleEngineOn(veh, true, true)
            end, vehicle.plate)
        end, HouseGarages[currentHouseGarage].takeVehicle, true)
        if showText then
            exports['mr-text']:HideText(1)
            showText = false
        end
    end
end


CreateThread(function()
    Wait(1000)
    while true do
        Wait(5)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local inGarageRange = false

        for k, v in pairs(Garages) do
            local takeDist = #(pos - vector3(Garages[k].takeVehicle.x, Garages[k].takeVehicle.y, Garages[k].takeVehicle.z))
            if takeDist <= 15 and not IsPedInAnyVehicle(ped) then
                inGarageRange = true
                if not IsPedInAnyVehicle(ped) then
                    DrawMarker(2, Garages[k].takeVehicle.x, Garages[k].takeVehicle.y, Garages[k].takeVehicle.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                end
                if takeDist <= 1.5 then
                    if not showText then
                        exports['mr-text']:DrawText(
                            '[E] Garage',
                            0, 94, 255,0.7,
                            1,
                            50
                        )
                        showText = true
                    end
                    if IsControlJustPressed(1, 177) and not Menu.hidden then
                        close()
                        PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                    end
                    if IsControlJustPressed(0, 38) then
                        menu1_open = true
                        custom_garage(k)
                        currentGarage = k
                    end
                elseif takeDist >= 1.6 and takeDist < 3 then
                    if showText then
                        exports['mr-text']:HideText(1)
                        showText = false
                    end
                end

                -- Menu.renderGUI()

                if takeDist >= 2 then
                    if menu1_open then
                        menu1_open = false
                        MenuV:CloseAll() 
                    end
                end
            end

            local putDist = #(pos - vector3(Garages[k].putVehicle.x, Garages[k].putVehicle.y, Garages[k].putVehicle.z))

            if putDist <= 25 and IsPedInAnyVehicle(ped) then
                inGarageRange = true
                DrawMarker(2, Garages[k].putVehicle.x, Garages[k].putVehicle.y, Garages[k].putVehicle.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 255, 255, 255, 255, false, false, false, true, false, false, false)
                if putDist <= 1.5 then
                    if not showText then
                        exports['mr-text']:DrawText(
                            '[E] Park Vehicle',
                            0, 94, 255,0.7,
                            1,
                            50
                        )
                        showText = true
                    end
                    -- DrawText3Ds(Garages[k].putVehicle.x, Garages[k].putVehicle.y, Garages[k].putVehicle.z + 0.5, '~g~E~w~ - Park Vehicle')
                    if IsControlJustPressed(0, 38) then
                        local curVeh = GetVehiclePedIsIn(ped)
                        local plate = MRFW.Functions.GetPlate(curVeh)
                        MRFW.Functions.TriggerCallback('mr-garage:server:checkVehicleOwner', function(owned, allowedtostore)
                            if owned then
                                if allowedtostore then
                                    local bodyDamage = math.ceil(GetVehicleBodyHealth(curVeh))
                                    local engineDamage = math.ceil(GetVehicleEngineHealth(curVeh))
                                    local totalFuel = exports['mr-fuel']:GetFuel(curVeh)
                                    local passenger = GetVehicleMaxNumberOfPassengers(curVeh)
                                    local vehProperties = MRFW.Functions.GetVehicleProperties(curVeh)
                                    TriggerServerEvent('mr-garage:server:updateVehicleStatus', totalFuel, engineDamage, bodyDamage, plate, k)
                                    CheckPlayers(curVeh)
                                    TriggerServerEvent('mr-garage:server:updateVehicleState', 1, plate, k)
                                    TriggerServerEvent('mr-vehicletuning:server:SaveVehicleProps', vehProperties)
                                
                                    if plate ~= nil then
                                        OutsideVehicles[plate] = veh
                                        TriggerServerEvent('mr-garages:server:UpdateOutsideVehicles', OutsideVehicles)
                                    end
                                    MRFW.Functions.Notify("Vehicle Parked In, "..Garages[k].label, "primary", 4500)
                                else
                                    MRFW.Functions.Notify("You Can't store this vehicle here", "error", 3500)
                                end
                            else
                                MRFW.Functions.Notify("Nobody owns this vehicle", "error", 3500)
                            end
                        end, plate, Garages[k].access)
                    end
                elseif putDist >= 1.6 and putDist < 3 then
                    if showText then
                        exports['mr-text']:HideText(1)
                        showText = false
                    end
                end
            end
        end

        if not inGarageRange then
            Wait(1000)
        end
    end
end)

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
   if showText then
    exports['mr-text']:HideText(1)
    showText = false
end
end


CreateThread(function()
    Wait(1000)
    while true do
        Wait(5)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local inGarageRange = false
        if PlayerGang.name ~= nil then
        Name = PlayerGang.name.."garage"
        end
         for k, v in pairs(GangGarages) do
            
            if PlayerGang.name == GangGarages[k].job then
                local ballasDist = #(pos - vector3(GangGarages[Name].takeVehicle.x, GangGarages[Name].takeVehicle.y, GangGarages[Name].takeVehicle.z))
                if ballasDist <= 15 then
                    inGarageRange = true
                    DrawMarker(2, GangGarages[Name].takeVehicle.x, GangGarages[Name].takeVehicle.y, GangGarages[Name].takeVehicle.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                    if ballasDist <= 1.5 then
                        if not IsPedInAnyVehicle(ped) then
                            if not showText then
                                exports['mr-text']:DrawText(
                                    '[E] Garage',
                                    0, 94, 255,0.7,
                                    1,
                                    50
                                )
                                showText = true
                            end
                            -- DrawText3Ds(GangGarages[Name].takeVehicle.x, GangGarages[Name].takeVehicle.y, GangGarages[Name].takeVehicle.z + 0.5, '~g~E~w~ - Garage')
                            if IsControlJustPressed(1, 177) and not Menu.hidden then
                                close()
                                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            end
                            if IsControlJustPressed(0, 38) then
                                custom_ganggarage(k)
                                -- Menu.hidden = not Menu.hidden
                                currentGarage = Name
                            end
                        -- else
                            -- DrawText3Ds(GangGarages[Name].takeVehicle.x, GangGarages[Name].takeVehicle.y, GangGarages[Name].takeVehicle.z, GangGarages[Name].label)
                        end
                    elseif ballasDist >= 1.6 and ballasDist < 3 then
                        if showText then
                            exports['mr-text']:HideText(1)
                            showText = false
                        end
                    end

                    -- Menu.renderGUI()
                    if ballasDist >= 2 then
                        if menu1_open then
                            menu1_open = false
                            MenuV:CloseAll() 
                        end
                    end
                end

                local putDist = #(pos - vector3(GangGarages[Name].putVehicle.x, GangGarages[Name].putVehicle.y, GangGarages[Name].putVehicle.z))

                if putDist <= 25 and IsPedInAnyVehicle(ped) then
                    inGarageRange = true
                    DrawMarker(2, GangGarages[Name].putVehicle.x, GangGarages[Name].putVehicle.y, GangGarages[Name].putVehicle.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 255, 255, 255, 255, false, false, false, true, false, false, false)
                    if putDist <= 1.5 then
                        if not showText then
                            exports['mr-text']:DrawText(
                                '[E] Park Vehicle',
                                0, 94, 255,0.7,
                                1,
                                50
                            )
                            showText = true
                        end
                        -- DrawText3Ds(GangGarages[Name].putVehicle.x, GangGarages[Name].putVehicle.y, GangGarages[Name].putVehicle.z + 0.5, '~g~E~w~ - Park Vehicle')
                        if IsControlJustPressed(0, 38) then
                            local curVeh = GetVehiclePedIsIn(ped)
                            local plate = MRFW.Functions.GetPlate(curVeh)
                            MRFW.Functions.TriggerCallback('mr-garage:server:checkVehicleOwner', function(owned)
                                if owned then
                                    local bodyDamage = math.ceil(GetVehicleBodyHealth(curVeh))
                                    local engineDamage = math.ceil(GetVehicleEngineHealth(curVeh))
                                    local totalFuel = exports['mr-fuel']:GetFuel(curVeh)
                                    local vehProperties = MRFW.Functions.GetVehicleProperties(curVeh)
                                    TriggerServerEvent('mr-garage:server:updateVehicleStatus', totalFuel, engineDamage, bodyDamage, plate, Name)
                                    CheckPlayers(curVeh)
                                    Wait(500)
                                    if DoesEntityExist(curVeh) then
                                        MRFW.Functions.Notify("The wasn't deleted, please check if is someone inside the car.", "error", 4500)
                                    else
                                    TriggerServerEvent('mr-garage:server:updateVehicleState', 1, plate, Name)
                                    TriggerServerEvent('mr-vehicletuning:server:SaveVehicleProps', vehProperties)
                                    if plate ~= nil then
                                        OutsideVehicles[plate] = veh
                                        TriggerServerEvent('mr-garages:server:UpdateOutsideVehicles', OutsideVehicles)
                                    end
                                    MRFW.Functions.Notify("Vehicle Parked In, "..GangGarages[Name].label, "primary", 4500)
                                end
                                else
                                    MRFW.Functions.Notify("Nobody owns this vehicle", "error", 3500)
                                end
                            end, plate)
                        end
                    elseif putDist >= 1.6 and putDist < 3 then
                        if showText then
                            exports['mr-text']:HideText(1)
                            showText = false
                        end
                    end
                end
            end
        end
        if not inGarageRange then
            Wait(1000)
        end
    end
end)

CreateThread(function()
    while true do
        sleep = 1000
        if LocalPlayer.state['isLoggedIn'] then
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            inGarageRange = false
            if HouseGarages and currentHouseGarage then
                if hasGarageKey and HouseGarages[currentHouseGarage] and HouseGarages[currentHouseGarage].takeVehicle and HouseGarages[currentHouseGarage].takeVehicle.x then
                    local takeDist = #(pos - vector3(HouseGarages[currentHouseGarage].takeVehicle.x, HouseGarages[currentHouseGarage].takeVehicle.y, HouseGarages[currentHouseGarage].takeVehicle.z))
                    if takeDist <= 15 then
                        sleep = 5
                        inGarageRange = true
                        DrawMarker(2, HouseGarages[currentHouseGarage].takeVehicle.x, HouseGarages[currentHouseGarage].takeVehicle.y, HouseGarages[currentHouseGarage].takeVehicle.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                        if takeDist < 2.0 then
                            if not IsPedInAnyVehicle(ped) then
                                if not showText then
                                    exports['mr-text']:DrawText(
                                        '[E] Garage ('..currentHouseGarage..')',
                                        0, 94, 255,0.7,
                                        1,
                                        50
                                    )
                                    showText = true
                                end
                                -- DrawText3Ds(HouseGarages[currentHouseGarage].takeVehicle.x, HouseGarages[currentHouseGarage].takeVehicle.y, HouseGarages[currentHouseGarage].takeVehicle.z + 0.5, '~g~E~w~ - Garage (~r~'..currentHouseGarage.."~w~)")
                                if IsControlJustPressed(1, 177) and not Menu.hidden then
                                    close()
                                    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                                end
                                if IsControlJustPressed(0, 38) then
                                    menu1_open = true
                                    jacob_Menu_House_Garage(currentHouseGarage)
                                    -- Menu.hidden = not Menu.hidden
                                end
                            elseif IsPedInAnyVehicle(ped) then
                                if not showText then
                                    exports['mr-text']:DrawText(
                                        '[E] To Park (~r~'..currentHouseGarage.."~w~)",
                                        0, 94, 255,0.7,
                                        1,
                                        50
                                    )
                                    showText = true
                                end
                                -- DrawText3Ds(HouseGarages[currentHouseGarage].takeVehicle.x, HouseGarages[currentHouseGarage].takeVehicle.y, HouseGarages[currentHouseGarage].takeVehicle.z + 0.5, '~g~E~w~ - To Park (~r~'..currentHouseGarage.."~w~)")
                                if IsControlJustPressed(0, 38) then
                                    local curVeh = GetVehiclePedIsIn(ped)
                                    local plate = MRFW.Functions.GetPlate(curVeh)
                                    MRFW.Functions.TriggerCallback('mr-garage:server:checkVehicleHouseOwner', function(owned)
                                        if owned then
                                            local bodyDamage = round(GetVehicleBodyHealth(curVeh), 1)
                                            local engineDamage = round(GetVehicleEngineHealth(curVeh), 1)
                                            local totalFuel = exports['mr-fuel']:GetFuel(curVeh)
                                            local vehProperties = MRFW.Functions.GetVehicleProperties(curVeh)
                                                TriggerServerEvent('mr-garage:server:updateVehicleStatus', totalFuel, engineDamage, bodyDamage, plate, currentHouseGarage)
                                                CheckPlayers(curVeh)
                                            if DoesEntityExist(curVeh) then
                                                MRFW.Functions.Notify("The Vehicle wasn't deleted, please check if is someone inside the car.", "error", 4500)
                                            else
                                                TriggerServerEvent('mr-garage:server:updateVehicleState', 1, plate, currentHouseGarage)
                                                TriggerServerEvent('mr-vehicletuning:server:SaveVehicleProps', vehProperties)
                                                MRFW.Functions.DeleteVehicle(curVeh)
                                                if plate ~= nil then
                                                    OutsideVehicles[plate] = veh
                                                    TriggerServerEvent('mr-garages:server:UpdateOutsideVehicles', OutsideVehicles)
                                                end
                                                MRFW.Functions.Notify("Vehicle Parked In, "..HouseGarages[currentHouseGarage], "primary", 4500)
                                            end
                                        else
                                            MRFW.Functions.Notify("Nobody owns this House", "error", 3500)
                                        end
                                  
                                    end, plate, currentHouseGarage)
                                end
                            end
                            -- Menu.renderGUI()
                        elseif takeDist >= 2.0 and takeDist < 3 then
                            if showText then
                                exports['mr-text']:HideText(1)
                                showText = false
                            end
                        end
                        if takeDist >= 2.01 then
                            if menu1_open then
                                menu1_open = false
                                MenuV:CloseAll() 
                            end
                        end
                    end
                end
            end
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    Wait(1000)
    while true do
        Wait(5)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local inGarageRange = false

        for k, v in pairs(Depots) do
            local takeDist = #(pos - vector3(Depots[k].takeVehicle.x, Depots[k].takeVehicle.y, Depots[k].takeVehicle.z))
            if takeDist <= 15 then
                inGarageRange = true
                DrawMarker(2, Depots[k].takeVehicle.x, Depots[k].takeVehicle.y, Depots[k].takeVehicle.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                if takeDist <= 1.5 then
                    if not IsPedInAnyVehicle(ped) then
                        if not showText then
                            exports['mr-text']:DrawText(
                                '[E] Depot',
                                0, 94, 255,0.7,
                                1,
                                50
                            )
                            showText = true
                        end
                        -- DrawText3Ds(Depots[k].takeVehicle.x, Depots[k].takeVehicle.y, Depots[k].takeVehicle.z + 0.5, '~g~E~w~ - Garage')
                        if IsControlJustPressed(1, 177) and not Menu.hidden then
                            close()
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                        end
                        if IsControlJustPressed(0, 38) then
                            menu1_open = true
                            jacob_depot_menu_garage(k)
                            -- Menu.hidden = not Menu.hidden
                            currentGarage = k
                        end
                    end
                elseif takeDist >= 1.6 and takeDist < 3 then
                    if showText then
                        exports['mr-text']:HideText(1)
                        showText = false
                    end
                end

                Menu.renderGUI()

                if takeDist >= 2 then
                    if menu1_open then
                        menu1_open = false
                        MenuV:CloseAll() 
                    end
                end
            end
        end

        if not inGarageRange then
            Wait(5000)
        end
    end
end)

function round(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end
