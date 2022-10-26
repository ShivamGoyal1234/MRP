local MRFW = exports['mrfw']:GetCoreObject()

local PlayerData = {}
local working = false
local confirm = false
local Routing = false
local hunting = false
local vehicle = nil
local processed = false
local packing = false
local selling = false
local plate = nil
local TotalAnimals = #Config.Locations['animals']
local slaughteredAnimals = 0

local Blips = {
    ['cancel'] = nil,
    ['hunting'] = nil,
    ['pos'] = nil,
}

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

local function LoadModel(model)
    while not HasModelLoaded(model) do
          RequestModel(model)
          Citizen.Wait(10)
    end
end

local function Notify(text)
    MRFW.Functions.Notify(text, 'success', 3000)
end

local function CheckPlayers(vehicle)
    for i = -1, 5,1 do                
        seat = GetPedInVehicleSeat(vehicle,i)
        if seat ~= 0 then
            TaskLeaveVehicle(seat,vehicle,0)
            SetVehicleDoorsLocked(vehicle)
            Wait(1500)
            MRFW.Functions.DeleteVehicle(vehicle)
        end
   end
end

local function SlaughterAnimal(AnimalId)
    MRFW.Functions.Progressbar('Slaughtering_Animal', 'Slaughtering Animal...', 20000, false, true, { -- Name | Label | Time | useWhileDead | canCancel
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
        TriggerEvent('dpemote:custom:animation', {"bumbin"})
    }, {}, {}, {}, function()
        TriggerEvent('dpemote:custom:animation', {"c"})
        local AnimalWeight = math.random(10, 160) / 10
        Notify('You slaughtered the animal and recieved an meat of ' ..AnimalWeight.. 'kg')
        TriggerServerEvent('Hunting:Server:Reward', AnimalWeight)
        DeleteEntity(AnimalId)
        slaughteredAnimals = slaughteredAnimals + 1
    end, function()
        TriggerEvent('dpemote:custom:animation', {"c"})
    end)
end

local function SpawnAnimals()
    for k,v in pairs(Config.Locations['animals'])do
        local index = math.random(1, #Config.Animals)
        LoadModel(Config.Animals[index])
        local Animal = CreatePed(5, GetHashKey(Config.Animals[index]), v.x, v.y, v.z, 0.0, true, false)
        
        TaskWanderStandard(Animal, true, true)
		SetEntityAsMissionEntity(Animal, true, true)

        local AnimalBlip = AddBlipForEntity(Animal)

        SetBlipSprite(AnimalBlip, 684)
        SetBlipColour(AnimalBlip, 1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Animal')
        EndTextCommandSetBlipName(AnimalBlip)
        table.insert(Config.AnimalsInSession, {id = Animal, x = v.x, y = v.y, z = v.z, Blipid = AnimalBlip})
    end

    while hunting do
        sleep = 500
        for k,v in pairs(Config.AnimalsInSession) do
            if DoesEntityExist(v.id) then
                local AnimalCoords = GetEntityCoords(v.id)
                local PlyCoords = GetEntityCoords(PlayerPedId())
                local AnimalHealth = GetEntityHealth(v.id)
                local distAnimal = #(PlyCoords - AnimalCoords)
                if AnimalHealth <= 0 then
                    SetBlipColour(v.Blipid, 3)
                    if distAnimal < 2.0 then
                        sleep = 5
                        DrawText3D(AnimalCoords.x, AnimalCoords.y, AnimalCoords.z + 1, "[E] Slaughter Animal")
                        if IsControlJustReleased(0, 38) then
                            if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey('WEAPON_KNIFE')  then
                                if DoesEntityExist(v.id) then
                                    table.remove(Config.AnimalsInSession, k)
                                    SlaughterAnimal(v.id)
                            	end
                            else
                                Notify('You need to use the knife!')
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(sleep)
    end
end

local function inRoute()
    local coords = Config.Locations['area']
    while Routing do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local dist = #(pos - coords)
        sleep = 1000
        if dist <= 10 then
            Routing = false
            hunting = true
            RemoveBlip(Blips['pos'])
        end
        Citizen.Wait(sleep)
    end
    SpawnAnimals()
end

local function setGPS()
    if Blips['pos'] ~= nil or Blips['pos'] ~= 0 then
        local coords = Config.Locations['area']
        Blips['pos'] = AddBlipForCoord(coords)
        SetBlipRoute(Blips['pos'], true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Location')
        EndTextCommandSetBlipName(Blips['pos'])
    else
        RemoveBlip(Blips['pos'])
        local coords = Config.Locations['area']
        Blips['pos'] = AddBlipForCoord(coords)
        SetBlipRoute(Blips['pos'], true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Location')
        EndTextCommandSetBlipName(Blips['pos'])
    end
    Notify('Go to the marker')
    Routing = true
    inRoute()
end

RegisterNetEvent('MRFW:Client:OnPlayerLoaded', function()
    PlayerData = MRFW.Functions.GetPlayerData()
end)

RegisterNetEvent('MRFW:Client:OnPlayerUnload', function()
    PlayerData = {}
    working = false
    confirm = false
    Routing = false
    hunting = false
    vehicle = nil
    processed = false
    packing = false
    selling = false
    plate = nil
    slaughteredAnimals = 0
    RemoveBlip(Blips['obj'])
end)

RegisterNetEvent('Hunting:Client:Start', function()
    working = true
    local coords = Config.Locations['vehicle']
    local model = Config.Model
    MRFW.Functions.SpawnVehicle(model, function(veh)
        SetVehicleNumberPlateText(veh, "HUNT"..tostring(math.random(1000, 9999)))
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
        plate = MRFW.Functions.GetPlate(veh)
        vehicle = veh
    end, coords, true)
    setGPS()
end)

RegisterNetEvent('Hunting:Client:process', function(heading)
    processed = true
    
    if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey('WEAPON_KNIFE')  then
        local PedCoords = GetEntityCoords(PlayerPedId())
        SetEntityHeading(PlayerPedId(), heading)
        MRFW.Functions.Progressbar('Slaughtering_meat', 'Slaughtering Meat', 20000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = 'anim@amb@business@coc@coc_unpack_cut_left@',
            anim = 'coke_cut_v1_coccutter',
            flags = 16,
        }, {}, {}, function()
            MRFW.Functions.Notify("Now Pack slaughtered Meat!", "primary")
            TriggerServerEvent("Hunting:Server:GetItemProcessed")
            FreezeEntityPosition(PlayerPedId(),false)
            Citizen.Wait(500)
            processed = false
        end, function()
            FreezeEntityPosition(PlayerPedId(),false)
            ClearPedTasks(PlayerPedId())
            processed = false
        end)
    else
        MRFW.Functions.Notify("missing Knife", "error")
        FreezeEntityPosition(PlayerPedId(),false)
        processed = false
    end
end)

RegisterNetEvent('Hunting:Client:Packing', function(heading)
    packing = true
    MRFW.Functions.TriggerCallback('MRFW:HasItem', function(has)
        if has then	
            MRFW.Functions.Progressbar('Packing_meat', 'Packing Meat', 20000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = 'anim@amb@business@coc@coc_unpack_cut_left@',
                anim = 'petting_franklin',
                flags = 16,
            }, {}, {}, function()
                MRFW.Functions.Notify("Now Sell Packed Meat!", "primary")
                TriggerServerEvent("Hunting:Server:GetPackedItems")
                Citizen.Wait(500)
                packing = false
            end, function()
                packing = false
            end)
        else
            MRFW.Functions.Notify("missing empty box", "error")
            FreezeEntityPosition(PlayerPedId(),false)
            packing = false
        end
    end, 'empty_box')
end)

RegisterNetEvent('Hunting:Client:Selling', function(heading)
    selling = true
    MRFW.Functions.TriggerCallback('MRFW:HasItem', function(has)
        if has then	
            MRFW.Functions.Progressbar('Packing_meat', 'Selling Meat', 20000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = 'amb@medic@standing@tendtodead@idle_a',
                anim = 'idle_a',
                flags = 16,
            }, {}, {}, function()
                TriggerServerEvent("Hunting:Server:Rewards")
                Citizen.Wait(500)
                selling = false
            end, function()
                selling = false
            end)
        else
            MRFW.Functions.Notify("missing ID Card", "error")
            FreezeEntityPosition(PlayerPedId(),false)
            selling = false
        end
    end, 'id_card')
end)

Citizen.CreateThread(function()
    while true do
        sleep = 2500
        if LocalPlayer.state['isLoggedIn'] then
            sleep = 1500
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)

            for k,v in pairs(Config.Locations['start'])do
                local start = #(pos - vector3(v.x, v.y, v.z))
                if start <= 5 then
                    sleep = 5
                    DrawMarker(2, v.x, v.y, v.z - 0.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 255, 255, 255, 255, false, false, false, true, false, false, false)
                    if start <= 3 then
                        if not working then
                            if not confirm then
                                DrawText3D( v.x, v.y, v.z, "[~g~E~w~] ~y~Start ~r~Hunting")
                                if IsControlJustPressed(0, 38) then
                                    confirm = true
                                end
                            else
                                DrawText3D( v.x, v.y, v.z + 0.4, "~y~Are You Sure You Want To Start Hunting~r~?")
                                DrawText3D( v.x, v.y, v.z + 0.2, "~b~Some Peoples Not Feel Good When Doing Hunting.")
                                DrawText3D( v.x, v.y, v.z, "[~g~7~w~] Yes or [~r~8~w~] No")
                                if IsControlJustPressed(0, 161) then
                                    confirm = false
                                    local vehNear = MRFW.Functions.CheckFuckingCar(Config.Locations['vehicle'])
                                    if vehNear < 5 then
                                       MRFW.Functions.Notify('There is a vehicle at the spot', 'error', 3000)
                                    else
                                        TriggerServerEvent('Hunting:Server:TakeDeposit')

                                    end
                                end
                                if IsControlJustPressed(0, 162) then
                                    confirm = false
                                end
                            end
                        end
                    end
                end
            end
            if slaughteredAnimals == TotalAnimals then
                slaughteredAnimals = 0
                working = false
            end
            for k,v in pairs(Config.Locations['sell'])do
                local sell = #(pos - vector3(v.x, v.y, v.z))
                if sell <= 5 then
                    if not selling then
                        sleep = 5
                        DrawMarker(2, v.x, v.y, v.z - 0.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 255, 255, 255, 255, false, false, false, true, false, false, false)
                        if sell <= 2 then
                            DrawText3D( v.x, v.y, v.z, "[~g~E~w~] ~y~Sell ~r~Meat")
                            if IsControlJustPressed(0, 38) then
                                TriggerServerEvent('Hunting:Server:Selling')
                            end
                        end
                    end
                end
            end
            for k,v in pairs(Config.Locations['process'])do
                local process = #(pos - vector3(v.x, v.y, v.z))
                if process <= 5 and not processed then
                    sleep = 5
                    DrawMarker(2, v.x, v.y, v.z - 0.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 255, 255, 255, 255, false, false, false, true, false, false, false)
                    if process <= 2 then
                        DrawText3D( v.x, v.y, v.z, "[~g~E~w~] ~y~Start ~r~Processing")
                        if IsControlJustPressed(0, 38) then
                            TriggerServerEvent('Hunting:Server:process', v.w)
                        end
                    end
                end
            end
            for k,v in pairs(Config.Locations['packing'])do
                local pack = #(pos - vector3(v.x, v.y, v.z))
                if pack <= 5 and not packing then
                    sleep = 5
                    DrawMarker(2, v.x, v.y, v.z - 0.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 255, 255, 255, 255, false, false, false, true, false, false, false)
                    if pack <= 2 then
                        DrawText3D( v.x, v.y, v.z, "[~g~E~w~] ~y~Start ~r~Packing")
                        if IsControlJustPressed(0, 38) then
                            TriggerServerEvent('Hunting:Server:Packing', v.w)
                        end
                    end
                end
            end
            if working then
                for k,v in pairs(Config.Locations['return']) do
                    local Return = #(pos - vector3(v.x, v.y, v.z))
                    if Return <= 5 then
                        sleep = 5
                        DrawMarker(2, v.x, v.y, v.z - 0.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 255, 255, 255, 255, false, false, false, true, false, false, false)
                        if Return <= 3 then
                            DrawText3D( v.x, v.y, v.z, "[~g~E~w~] ~y~To Return ~r~Vehicle")
                            if IsControlJustPressed(0, 38) then
                                local vehicle = GetVehiclePedIsIn(ped, false)
                                local plate2 = MRFW.Functions.GetPlate(vehicle)
                                if IsPedInAnyVehicle(ped, false) then
                                    if plate2 ~= nil then
                                        if plate2 == plate then
                                            working = false
                                            for l,n in pairs(Config.AnimalsInSession) do
                                                table.remove(Config.AnimalsInSession, l)
                                            end
                                            slaughteredAnimals = 0
                                            RemoveBlip(Blips['pos'])
                                            CheckPlayers(vehicle)
                                            plate = nil
                                            TriggerServerEvent('Hunting:Server:ReturnDeposit')
                                        else
                                            Notify('This is Not Our Vehicle')
                                        end
                                    end
                                else
                                    Notify('not in a vehicle')
                                end
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)