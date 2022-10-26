isLoggedIn = true
local MRFW = exports['mrfw']:GetCoreObject()
local PlayerJob = {}
local JobsDone = 0
local LocationsDone = {}
local CurrentLocation = nil
local CurrentBlip = nil
local hasBox = false
local isWorking = false
local currentCount = 0
local CurrentPlate = nil
local CurrentTow = nil
local jobscando = 4
local jobsdone = 0
local cooldowntime = 0
local selectedVeh = nil
local TruckVehBlip = nil
RegisterNetEvent('updatejobs')
AddEventHandler('updatejobs', function()
jobscando = math.random(4,8)
currentCount = 0
 MRFW.Functions.Notify('You Have '..jobscando.." Jobs to do", 'success')
end)
RegisterNetEvent('MRFW:Client:OnPlayerLoaded')
AddEventHandler('MRFW:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerJob = MRFW.Functions.GetPlayerData().job
    CurrentLocation = nil
    CurrentBlip = nil
    hasBox = false
    isWorking = false
    JobsDone = 0

    if PlayerJob.name == "trucker" then
        TruckVehBlip = AddBlipForCoord(Config.Locationstruck["vehicle"].coords.x, Config.Locationstruck["vehicle"].coords.y, Config.Locationstruck["vehicle"].coords.z)
        SetBlipSprite(TruckVehBlip, 326)
        SetBlipDisplay(TruckVehBlip, 4)
        SetBlipScale(TruckVehBlip, 0.6)
        SetBlipAsShortRange(TruckVehBlip, true)
        SetBlipColour(TruckVehBlip, 5)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.Locationstruck["vehicle"].label)
        EndTextCommandSetBlipName(TruckVehBlip)
    end
end)

RegisterNetEvent('MRFW:Client:OnPlayerUnload')
AddEventHandler('MRFW:Client:OnPlayerUnload', function()
    RemoveTruckerBlips()
    CurrentLocation = nil
    CurrentBlip = nil
    hasBox = false
    isWorking = false
    JobsDone = 0
end)

RegisterNetEvent('MRFW:Client:OnJobUpdate')
AddEventHandler('MRFW:Client:OnJobUpdate', function(JobInfo)
    local OldlayerJob = PlayerJob.name
    PlayerJob = JobInfo

    if PlayerJob.name == "trucker" then
        TruckVehBlip = AddBlipForCoord(Config.Locationstruck["vehicle"].coords.x, Config.Locationstruck["vehicle"].coords.y, Config.Locationstruck["vehicle"].coords.z)
        SetBlipSprite(TruckVehBlip, 326)
        SetBlipDisplay(TruckVehBlip, 4)
        SetBlipScale(TruckVehBlip, 0.6)
        SetBlipAsShortRange(TruckVehBlip, true)
        SetBlipColour(TruckVehBlip, 5)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.Locationstruck["vehicle"].label)
        EndTextCommandSetBlipName(TruckVehBlip)
    elseif OldlayerJob == "trucker" then
        RemoveTruckerBlips()
    end
end)
RegisterNetEvent('startcooldown')
AddEventHandler('startcooldown', function()
cooldowntime = 900000

end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        if cooldowntime >= 1 then
            Citizen.Wait(1000)
            cooldowntime = cooldowntime - 1000
        end
    end
end)

Citizen.CreateThread(function()
    --  TruckerBlip = AddBlipForCoord(Config.Locationstruck["main"].coords.x, Config.Locationstruck["main"].coords.y, Config.Locationstruck["main"].coords.z)
    -- SetBlipSprite(TruckerBlip, 479)
    -- SetBlipDisplay(TruckerBlip, 4)
    -- SetBlipScale(TruckerBlip, 0.6)
    -- SetBlipAsShortRange(TruckerBlip, true)
    -- SetBlipColour(TruckerBlip, 5)
    -- BeginTextCommandSetBlipName("STRING")
    -- AddTextComponentSubstringPlayerName(Config.Locationstruck["main"].label)
    -- EndTextCommandSetBlipName(TruckerBlip)
    while true do 
        Citizen.Wait(5)
        if isLoggedIn and MRFW ~= nil then
            if PlayerJob.name == "trucker" then
                if IsControlJustReleased(0, Keys["DEL"]) then
                    if IsPedInAnyVehicle(PlayerPedId()) and isTruckerVehicle(GetVehiclePedIsIn(PlayerPedId(), false)) then
                        getNewLocation()
                        CurrentPlate = MRFW.Functions.GetPlate(GetVehiclePedIsIn(PlayerPedId(), false))
                    end
                end
                local pos = GetEntityCoords(PlayerPedId())
                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locationstruck["vehicle"].coords.x, Config.Locationstruck["vehicle"].coords.y, Config.Locationstruck["vehicle"].coords.z, true) < 10.0) then
                    DrawMarker(2, Config.Locationstruck["vehicle"].coords.x, Config.Locationstruck["vehicle"].coords.y, Config.Locationstruck["vehicle"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locationstruck["vehicle"].coords.x, Config.Locationstruck["vehicle"].coords.y, Config.Locationstruck["vehicle"].coords.z, true) < 1.5) then
                        if IsPedInAnyVehicle(PlayerPedId(), false) then
                            DrawText3D(Config.Locationstruck["vehicle"].coords.x, Config.Locationstruck["vehicle"].coords.y, Config.Locationstruck["vehicle"].coords.z, "~g~E~w~ - Store the vehicle")
                        else
                            DrawText3D(Config.Locationstruck["vehicle"].coords.x, Config.Locationstruck["vehicle"].coords.y, Config.Locationstruck["vehicle"].coords.z, "~g~E~w~ - Vehicle")
                        end
                        if IsControlJustReleased(0, Keys["E"]) then
                            if IsPedInAnyVehicle(PlayerPedId(), false) then
                                if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() then
                                    if isTruckerVehicle(GetVehiclePedIsIn(PlayerPedId(), false)) then
                                        DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
                                        TriggerServerEvent('mr-trucker:server:DoBail', false)
                                        TriggerEvent('startcooldown')
                                        RemoveBlip(CurrentBlip)
                                        CurrentBlip = nil
                                    else
                                        MRFW.Functions.Notify('This is not the commercial vehicle!', 'error')
                                    end
                                else
                                    MRFW.Functions.Notify('You must be a driver..')
                                end
                            else
                                MenuGarage()
                                Menu.hidden = not Menu.hidden
                            end
                        end
                        Menu.renderGUI()
                    end 
                end
    
                --[[if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locationstruck["main"].coords.x, Config.Locationstruck["main"].coords.y, Config.Locationstruck["main"].coords.z, true) < 4.5) then
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locationstruck["main"].coords.x, Config.Locationstruck["main"].coords.y, Config.Locationstruck["main"].coords.z, true) < 1.5) then
                        DrawText3D(Config.Locationstruck["main"].coords.x, Config.Locationstruck["main"].coords.y, Config.Locationstruck["main"].coords.z, "~g~E~w~ - Payslip")
                        if IsControlJustReleased(0, Keys["E"]) then
                            if JobsDone > 0 then
                                TriggerServerEvent("mr-trucker:server:01101110", JobsDone)
                                JobsDone = 0
                                if #LocationsDone == #Config.Locationstruck["stores"] then
                                    LocationsDone = {}
                                end
                                if CurrentBlip ~= nil then
                                    RemoveBlip(CurrentBlip)
                                    CurrentBlip = nil
                                end
                            else
                                MRFW.Functions.Notify("You haven't done any work yet..", "error")
                            end
                        end
                    elseif (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locationstruck["main"].coords.x, Config.Locationstruck["main"].coords.y, Config.Locationstruck["main"].coords.z, true) < 2.5) then
                        DrawText3D(Config.Locationstruck["main"].coords.x, Config.Locationstruck["main"].coords.y, Config.Locationstruck["main"].coords.z, "Payslip")
                    end  
                end]]
    
                if CurrentLocation ~= nil  and currentCount < jobscando then
                    if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, CurrentLocation.x, CurrentLocation.y, CurrentLocation.z, true) < 40.0 then
                        if not IsPedInAnyVehicle(PlayerPedId()) then
                            if not hasBox then
                                local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
                                if isTruckerVehicle(vehicle) and CurrentPlate == MRFW.Functions.GetPlate(vehicle) then
                                    local trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.8, 0)
                                    if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, trunkpos.x, trunkpos.y, trunkpos.z, true) < 1.5 and not isWorking then
                                        DrawText3D(trunkpos.x, trunkpos.y, trunkpos.z, "~g~E~w~ - Pick up products")
                                        if IsControlJustReleased(0, Keys["E"]) then
                                            isWorking = true
                                            MRFW.Functions.Progressbar("work_carrybox", "Pack box of products..", 2000, false, true, {
                                                disableMovement = true,
                                                disableCarMovement = true,
                                                disableMouse = false,
                                                disableCombat = true,
                                            }, {
                                                animDict = "anim@gangops@facility@servers@",
                                                anim = "hotwire",
                                                flags = 16,
                                            }, {}, {}, function() -- Done
                                                isWorking = false
                                                StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
                                                TriggerEvent('dpemote:custom:animation', {"box"})
                                                hasBox = true
                                            end, function() -- Cancel
                                                isWorking = false
                                                StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
                                                MRFW.Functions.Notify("Canceled..", "error")
                                            end)
                                        end
                                    else
                                        DrawText3D(trunkpos.x, trunkpos.y, trunkpos.z, "Pick up products")
                                    end
                                end
                            elseif hasBox then
                                if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, CurrentLocation.x, CurrentLocation.y, CurrentLocation.z, true) < 1.5 and not isWorking then
                                    DrawText3D(CurrentLocation.x, CurrentLocation.y, CurrentLocation.z, "~g~E~w~ - Deliver products")
                                    if IsControlJustReleased(0, Keys["E"]) then
                                        isWorking = true
                                        TriggerEvent('dpemote:custom:animation', {"c"})
                                        Citizen.Wait(500)
                                        
                                        MRFW.Functions.Progressbar("work_dropbox", "Deliver box of products..", 2000, false, true, {
                                            disableMovement = true,
                                            disableCarMovement = true,
                                            disableMouse = false,
                                            disableCombat = true,
                                            TriggerEvent('dpemote:custom:animation', {"bumbin"})
                                        }, {}, {}, {}, function() -- Done
                                            isWorking = false
                                            TriggerEvent('dpemote:custom:animation', {"c"})
                                            hasBox = false
                                            currentCount = currentCount + 1
                                            if currentCount == CurrentLocation.dropcount then
                                                table.insert(LocationsDone, CurrentLocation.id)
                                                TriggerServerEvent("mr-shops:server:RestockShopItems", CurrentLocation.store)
                                                TriggerServerEvent("mr-trucker:server:01101110")
                                                TriggerServerEvent('mr-trucker:server:RewardItem')
                                                Citizen.Wait(1000)
                                                MRFW.Functions.Notify("You have delivered all products, Go to the next point")
                                                if CurrentBlip ~= nil then
                                                    RemoveBlip(CurrentBlip)
                                                    CurrentBlip = nil
                                                end
                                                CurrentLocation = nil
                                                currentCount = 0
                                                JobsDone = JobsDone + 1
                                                getNewLocation()
                                            end
                                        end, function() -- Cancel
                                            isWorking = false
                                            ClearPedTasks(PlayerPedId())
                                            MRFW.Functions.Notify("Cancelled..", "error")
                                        end)
                                    end
                                else
                                    DrawText3D(CurrentLocation.x, CurrentLocation.y, CurrentLocation.z, "Deliver products")
                                end
                            end
                        end
                    end
                end
            else
                Citizen.Wait(1000)
            end
        else
            Citizen.Wait(1000)
        end
    end
end)
RegisterNetEvent('mr-trucker:removeblip')
AddEventHandler('mr-trucker:removeblip', function()
   RemoveBlip(TruckerBlip)
end)

function getNewLocation()
    local location = getNextClosestLocation()
    if location ~= 0 then
        CurrentLocation = {}
        CurrentLocation.id = location
        CurrentLocation.dropcount = math.random(1, 3)
        CurrentLocation.store = Config.Locationstruck["stores"][location].name
        CurrentLocation.x = Config.Locationstruck["stores"][location].coords.x
        CurrentLocation.y = Config.Locationstruck["stores"][location].coords.y
        CurrentLocation.z = Config.Locationstruck["stores"][location].coords.z

        CurrentBlip = AddBlipForCoord(CurrentLocation.x, CurrentLocation.y, CurrentLocation.z)
        SetBlipColour(CurrentBlip, 3)
        SetBlipRoute(CurrentBlip, true)
        SetBlipRouteColour(CurrentBlip, 3)
    else
        MRFW.Functions.Notify("You went to all the shops. Store Back the vehicle!")
        if CurrentBlip ~= nil then
            RemoveBlip(CurrentBlip)
            CurrentBlip = nil
        end
    end
end

function getNextClosestLocation()
    local pos = GetEntityCoords(PlayerPedId(), true)
    local current = 0
    local dist = nil

    for k, _ in pairs(Config.Locationstruck["stores"]) do
        if current ~= 0 then
            if(GetDistanceBetweenCoords(pos, Config.Locationstruck["stores"][k].coords.x, Config.Locationstruck["stores"][k].coords.y, Config.Locationstruck["stores"][k].coords.z, true) < dist)then
                if not hasDoneLocation(k) then
                    current = k
                    dist = GetDistanceBetweenCoords(pos, Config.Locationstruck["stores"][k].coords.x, Config.Locationstruck["stores"][k].coords.y, Config.Locationstruck["stores"][k].coords.z, true)    
                end
            end
        else
            if not hasDoneLocation(k) then
                current = k
                dist = GetDistanceBetweenCoords(pos, Config.Locationstruck["stores"][k].coords.x, Config.Locationstruck["stores"][k].coords.y, Config.Locationstruck["stores"][k].coords.z, true)    
            end
        end
    end

    return current
end

function hasDoneLocation(locationId)
    local retval = false
    if LocationsDone ~= nil and next(LocationsDone) ~= nil then 
        for k, v in pairs(LocationsDone) do
            if v == locationId then
                retval = true
            end
        end
    end
    return retval
end

function isTruckerVehicle(vehicle)
    local retval = false
    for k, v in pairs(Config.Vehiclestruck) do
        if GetEntityModel(vehicle) == GetHashKey(k) then
            retval = true
        end
    end
    return retval
end

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
    for k, v in pairs(Config.Vehiclestruck) do
        Menu.addButton(Config.Vehiclestruck[k], "TakeOutVehicle", k, "Garage", " Motor: 100%", " Body: 100%", " Fuel: 100%")
    end
        
    Menu.addButton("Back", "MenuGarage",nil)
end

function TakeOutVehicle(vehicleInfo)
if cooldowntime >= 1 then
    MRFW.Functions.Notify("You need to wait ".. cooldowntime/1000 .."seconds to start job again")
else
    TriggerServerEvent('mr-trucker:server:DoBail', true, vehicleInfo)
    selectedVeh = vehicleInfo
end
end

function RemoveTruckerBlips()
    if TruckVehBlip ~= nil then
        RemoveBlip(TruckVehBlip)
        TruckVehBlip = nil
    end

    if CurrentBlip ~= nil then
        RemoveBlip(CurrentBlip)
        CurrentBlip = nil
    end
end

RegisterNetEvent('mr-trucker:client:SpawnVehicle')
AddEventHandler('mr-trucker:client:SpawnVehicle', function()
    local vehicleInfo = selectedVeh
    local coords = Config.Locationstruck["vehicle"].coords
    MRFW.Functions.SpawnVehicle(vehicleInfo, function(veh)
        SetVehicleNumberPlateText(veh, "AMAZON"..tostring(math.random(10, 99)))
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
        SetEntityAsMissionEntity(veh, true, true)
        TriggerEvent("vehiclekeys:client:SetOwner", MRFW.Functions.GetPlate(veh))
        SetVehicleEngineOn(veh, true, true)
        CurrentPlate = MRFW.Functions.GetPlate(veh)
        getNewLocation()
    end, coords, true)
end)

function closeMenuFull()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
end

function DrawText3D(x, y, z, text)
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