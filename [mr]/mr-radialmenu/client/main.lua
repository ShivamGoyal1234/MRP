local inRadialMenu = false

RegisterCommand('radialmenu', function()
	MRFW.Functions.GetPlayerData(function(PlayerData)
        if not PlayerData.metadata["ishandcuffed"] and not IsPauseMenuActive() then
			openRadial(true)
			SetCursorLocation(0.5, 0.5)
		end
	end)
end)

RegisterKeyMapping('radialmenu', 'Open Radial Menu', 'keyboard', 'F1')

function setupSubItems()
    MRFW.Functions.GetPlayerData(function(PlayerData)
        if PlayerData.metadata["isdead"] then
            if PlayerData.job.name == "police" or PlayerData.job.name == "ambulance" then
                Config.MenuItems[4].items = {
                    [1] = {
                        id = 'emergencybutton2',
                        title = 'Emergencybutton',
                        icon = '#general',
                        type = 'client',
                        event = 'police:client:SendPoliceEmergencyAlert',
                        shouldClose = true,
                    },
                }
            end
        else
            if Config.JobInteractions[PlayerData.job.name] ~= nil and next(Config.JobInteractions[PlayerData.job.name]) ~= nil then
                Config.MenuItems[4].items = Config.JobInteractions[PlayerData.job.name]
            else 
                Config.MenuItems[4].items = {}
            end
        end
    end)

    local Vehicle = GetVehiclePedIsIn(PlayerPedId())

    if Vehicle ~= nil or Vehicle ~= 0 then
        local AmountOfSeats = GetVehicleModelNumberOfSeats(GetEntityModel(Vehicle))

        if AmountOfSeats == 2 then
            Config.MenuItems[3].items[3].items = {
                [1] = {
                    id    = -1,
                    title = 'Driver',
                    icon = 'caret-up',
                    type = 'client',
                    event = 'mr-radialmenu:client:ChangeSeat',
                    shouldClose = false,
                },
                [2] = {
                    id    = 0,
                    title = 'Passenger',
                    icon = 'caret-up',
                    type = 'client',
                    event = 'mr-radialmenu:client:ChangeSeat',
                    shouldClose = false,
                },
            }
        elseif AmountOfSeats == 3 then
            Config.MenuItems[3].items[3].items = {
                [4] = {
                    id    = -1,
                    title = 'Driver',
                    icon = 'caret-up',
                    type = 'client',
                    event = 'mr-radialmenu:client:ChangeSeat',
                    shouldClose = false,
                },
                [1] = {
                    id    = 0,
                    title = 'Passenger',
                    icon = 'caret-up',
                    type = 'client',
                    event = 'mr-radialmenu:client:ChangeSeat',
                    shouldClose = false,
                },
                [3] = {
                    id    = 1,
                    title = 'Other',
                    icon = 'caret-down',
                    type = 'client',
                    event = 'mr-radialmenu:client:ChangeSeat',
                    shouldClose = false,
                },
            }
        elseif AmountOfSeats == 4 then
            Config.MenuItems[3].items[3].items = {
                [4] = {
                    id    = -1,
                    title = 'Driver',
                    icon = 'caret-up',
                    type = 'client',
                    event = 'mr-radialmenu:client:ChangeSeat',
                    shouldClose = false,
                },
                [1] = {
                    id    = 0,
                    title = 'Passenger',
                    icon = 'caret-up',
                    type = 'client',
                    event = 'mr-radialmenu:client:ChangeSeat',
                    shouldClose = false,
                },
                [3] = {
                    id    = 1,
                    title = 'Rear Left',
                    icon = 'caret-down',
                    type = 'client',
                    event = 'mr-radialmenu:client:ChangeSeat',
                    shouldClose = false,
                },
                [2] = {
                    id    = 2,
                    title = 'Rear Right',
                    icon = 'caret-down',
                    type = 'client',
                    event = 'mr-radialmenu:client:ChangeSeat',
                    shouldClose = false,
                },
            }
        end
    end
end

function openRadial(bool)    
    setupSubItems()

    SetNuiFocus(bool, bool)
    SendNUIMessage({
        action = "ui",
        radial = bool,
        items = Config.MenuItems
    })
    inRadialMenu = bool
end

function closeRadial(bool)    
    SetNuiFocus(false, false)
    inRadialMenu = bool
end

function getNearestVeh()
    local pos = GetEntityCoords(PlayerPedId())
    local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)

    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
    local _, _, _, _, vehicleHandle = GetRaycastResult(rayHandle)
    return vehicleHandle
end

RegisterNUICallback('closeRadial', function()
    closeRadial(false)
end)

RegisterNUICallback('selectItem', function(data)
    local itemData = data.itemData

    if itemData.type == 'client' then
        TriggerEvent(itemData.event, itemData)
    elseif itemData.type == 'server' then
        TriggerServerEvent(itemData.event, itemData)
    end
end)

RegisterNetEvent('mr-radialmenu:client:noPlayers')
AddEventHandler('mr-radialmenu:client:noPlayers', function(data)
    MRFW.Functions.Notify('There arent any people close', 'error', 2500)
end)

RegisterNetEvent('mr-radialmenu:client:giveidkaart')
AddEventHandler('mr-radialmenu:client:giveidkaart', function(data)
    -- ??
end)

RegisterNetEvent('mr-radialmenu:client:openDoor')
AddEventHandler('mr-radialmenu:client:openDoor', function(data)
    local string = data.id
    local replace = string:gsub("door", "")
    local door = tonumber(replace)
    local ped = PlayerPedId()
    local closestVehicle = nil

    if IsPedInAnyVehicle(ped, false) then
        closestVehicle = GetVehiclePedIsIn(ped)
    else
        closestVehicle = getNearestVeh()
    end

    if closestVehicle ~= 0 then
        if closestVehicle ~= GetVehiclePedIsIn(ped) then
            local plate = MRFW.Functions.GetPlate(closestVehicle)
            if GetVehicleDoorAngleRatio(closestVehicle, door) > 0.0 then
                if not IsVehicleSeatFree(closestVehicle, -1) then
                    TriggerServerEvent('mr-radialmenu:trunk:server:Door', false, plate, door)
                else
                    SetVehicleDoorShut(closestVehicle, door, false)
                end
            else
                if not IsVehicleSeatFree(closestVehicle, -1) then
                    TriggerServerEvent('mr-radialmenu:trunk:server:Door', true, plate, door)
                else
                    SetVehicleDoorOpen(closestVehicle, door, false, false)
                end
            end
        else
            if GetVehicleDoorAngleRatio(closestVehicle, door) > 0.0 then
                SetVehicleDoorShut(closestVehicle, door, false)
            else
                SetVehicleDoorOpen(closestVehicle, door, false, false)
            end
        end
    else
        MRFW.Functions.Notify('There is no vehicle in sight...', 'error', 2500)
    end
end)

RegisterNetEvent('mr-radialmenu:client:setExtra')
AddEventHandler('mr-radialmenu:client:setExtra', function(data)
    local string = data.id
    local replace = string:gsub("extra", "")
    local extra = tonumber(replace)
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped)
    if veh ~= nil then
        local plate = MRFW.Functions.GetPlate(closestVehicle)
        if GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
            SetVehicleAutoRepairDisabled(veh, true) -- Forces Auto Repair off when Toggling Extra [GTA 5 Niche Issue]
            if DoesExtraExist(veh, extra) then 
                if IsVehicleExtraTurnedOn(veh, extra) then
                    SetVehicleExtra(veh, extra, 1)
                    MRFW.Functions.Notify('Extra ' .. extra .. ' Deactivated', 'error', 2500)
                else
                    SetVehicleExtra(veh, extra, 0)
                    MRFW.Functions.Notify('Extra ' .. extra .. ' Activated', 'success', 2500)
                end    
            else
                MRFW.Functions.Notify('Extra ' .. extra .. ' is not present on this vehicle ', 'error', 2500)
            end
        else
            MRFW.Functions.Notify('You\'re not a driver of a vehicle!', 'error', 2500)
        end
    end
end)

RegisterNetEvent('mr-radialmenu:trunk:client:Door')
AddEventHandler('mr-radialmenu:trunk:client:Door', function(plate, door, open)
    local veh = GetVehiclePedIsIn(PlayerPedId())

    if veh ~= 0 then
        local pl = MRFW.Functions.GetPlate(veh)

        if pl == plate then
            if open then
                SetVehicleDoorOpen(veh, door, false, false)
            else
                SetVehicleDoorShut(veh, door, false)
            end
        end
    end
end)

local Seats = {
    ["-1"] = "Driver's Seat",
    ["0"] = "Passenger's Seat",
    ["1"] = "Rear Left Seat",
    ["2"] = "Rear Right Seat",
}

RegisterNetEvent('mr-radialmenu:client:ChangeSeat')
AddEventHandler('mr-radialmenu:client:ChangeSeat', function(data)
    local Veh = GetVehiclePedIsIn(PlayerPedId())
    local IsSeatFree = IsVehicleSeatFree(Veh, data.id)
    local speed = GetEntitySpeed(Veh)
    local HasHarnass = exports['mr-smallresources']:HasHarness()
    if not HasHarnass then
        local kmh = (speed * 3.6);  

        if IsSeatFree then
            if kmh <= 100.0 then
                SetPedIntoVehicle(PlayerPedId(), Veh, data.id)
                MRFW.Functions.Notify('You are now on the  '..data.title..'!')
            else
                MRFW.Functions.Notify('This vehicle is going too fast..')
            end
        else
            MRFW.Functions.Notify('This seat is occupied..')
        end
    else
        MRFW.Functions.Notify('You have a race harness on you cant switch..', 'error')
    end
end)

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

local First = vector3(0.0, 0.0, 0.0)
local Second = vector3(5.0, 5.0, 5.0)

RegisterNetEvent('mr-radialmenu:client:flip:vehicle')
AddEventHandler('mr-radialmenu:client:flip:vehicle', function()
    local ped = PlayerPedId()
    local posped = GetEntityCoords(ped)
    local entityWorld = GetOffsetFromEntityInWorldCoords(ped, 0.0, 20.0, 0.0)
    local rayHandle = CastRayPointToPoint(posped.x, posped.y, posped.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, ped, 0)
    local a, b, c, d, closestVehicle = GetRaycastResult(rayHandle)
    local Distance = GetDistanceBetweenCoords(c.x, c.y, c.z, posped.x, posped.y, posped.z, false);
    local vehicleCoords = GetEntityCoords(closestVehicle)
    local dimension = GetModelDimensions(GetEntityModel(closestVehicle), First, Second)
    if Distance < 6.0  and not IsPedInAnyVehicle(ped, false) then
        if GetDistanceBetweenCoords(GetEntityCoords(closestVehicle) + GetEntityForwardVector(closestVehicle), GetEntityCoords(ped), true) > GetDistanceBetweenCoords(GetEntityCoords(closestVehicle) + GetEntityForwardVector(closestVehicle) * -1, GetEntityCoords(ped), true) then
            -- if IsVehicleOnAllWheels(closestVehicle) then
                NetworkRequestControlOfEntity(closestVehicle)
                local coords = GetEntityCoords(ped)
                FreezeEntityPosition(ped, true)
                RequestAnimDict(dict)
                TaskPlayAnim(ped, dict, anim, 2.0, -8.0, -1, 35, 0, 0, 0, 0)
                TriggerEvent('dpemote:custom:animation', {"push"})
                MRFW.Functions.Progressbar("flipping", "Flipping vehicle..", math.random(10000, 15000), false, true, {
                    disableMovement = false,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = true,
                }, {}, {}, {}, function() -- Done
                    isvehrotated = false
                    SetVehicleOnGroundProperly(closestVehicle)
                    DetachEntity(ped, false, false)
                    StopAnimTask(ped, dict, anim, 2.0)
                    FreezeEntityPosition(ped, false)
                    TriggerEvent('dpemote:custom:animation', {"c"})
                end, function()
                    MRFW.Functions.Notify("Canceled..", "error")
                    DetachEntity(ped, false, false)
                    StopAnimTask(ped, dict, anim, 2.0)
                    FreezeEntityPosition(ped, false)
                    TriggerEvent('dpemote:custom:animation', {"c"})
                end)
            -- else
            --     MRFW.Functions.Notify("not flipped", "error")
            -- end
        else
            MRFW.Functions.Notify("No vehicle / Vehicle not flipped", "error")
        end
    end
end)

function round(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

RegisterNetEvent('mr-radialmenu:check:vehiclehealth',function()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        local vehicle = GetVehiclePedIsIn(ped, false)
        local engine = Round(exports['mr-mechanicjob']:GetVehicleStatus(MRFW.Functions.GetPlate(vehicle), 'engine') / 10, 0)
        local body = Round(exports['mr-mechanicjob']:GetVehicleStatus(MRFW.Functions.GetPlate(vehicle), 'body') / 10, 0)
        local fuel = Round(exports['mr-fuel']:GetFuel(vehicle) / 1, 1)
        local gggg = Round(exports['mr-mechanicjob']:GetVehicleStatus(MRFW.Functions.GetPlate(vehicle), "fuel") / 1, 1)
        local hhhh = Round(exports['mr-mechanicjob']:GetVehicleStatus(MRFW.Functions.GetPlate(vehicle), "clutch") / 1, 1)
        local iiii = Round(exports['mr-mechanicjob']:GetVehicleStatus(MRFW.Functions.GetPlate(vehicle), "brakes") / 1, 1)
        local jjjj = Round(exports['mr-mechanicjob']:GetVehicleStatus(MRFW.Functions.GetPlate(vehicle), "axle") / 1, 1)
        local kkkk = Round(exports['mr-mechanicjob']:GetVehicleStatus(MRFW.Functions.GetPlate(vehicle), "radiator") / 1, 1)
        TriggerEvent('chat:addMessage', {
            template = "<div class=chat-message server'><strong>Engine</strong>: {0}%<br><strong>Body</strong>: {1}%<br><strong>Fuel</strong>: {2}%<br><strong>Fuel Tank</strong>: {3}%<br><strong>Clutch</strong>: {4}%<br><strong>Brakes</strong>: {5}%<br><strong>Axle</strong>: {6}%<br><strong>Radiator</strong>: {7}%</div>",
            args = {engine, body, fuel, gggg, hhhh, iiii, jjjj, kkkk}
        })
    else
        MRFW.Functions.Notify('You\'re not in vehicle', 'error', 3000)
    end
end)

RegisterNetEvent('police:client:takeoffmask')
AddEventHandler('police:client:takeoffmask', function()
    local player, distance = GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        MRFW.Functions.GetPlayerData(function(PlayerData)
            if PlayerData.job.name == "police" or PlayerData.job.name == "government" or PlayerData.job.name == "doctor" and PlayerData.job.onduty then
                TriggerServerEvent("police:server:takeoffmask", playerId)
            end
        end)
    else
        MRFW.Functions.Notify("No one nearby!", "error")
    end
end)

RegisterNetEvent('police:client:takeoffmaskc')
AddEventHandler('police:client:takeoffmaskc', function()
    local ad = "missheist_agency2ahelmet"
    loadAnimDict(ad)
    TaskPlayAnim(PlayerPedId(), ad, "take_off_helmet_stand", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
    Wait(600)
    ClearPedSecondaryTask(PlayerPedId())
    SetPedComponentVariation(PlayerPedId(), 1, 0, 0, 2)
    MRFW.Functions.Notify("Taken your mask off", "error")
end)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end