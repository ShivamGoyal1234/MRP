--New MRFW way of getting the Object comment out if your using old QB
MRFW = exports['mrfw']:GetCoreObject()
isFueling = false
CurrentWeaponData = nil
local patrolcan = 0
--Pulls Current Weapon data from qb-weapons event calls
AddEventHandler("weapons:client:SetCurrentWeapon",function(weaponData,canShoot) 
    CurrentWeaponData = weaponData
end)

function CheckDecor(vehicle)
    if not vehicle then return end
    if not DecorExistOn(vehicle,Config.FuelDecor) then
        DecorSetFloat(vehicle, Config.FuelDecor, GetFuel(vehicle))
    end
end

--Fuel siphon event
RegisterNetEvent("cc-fuel:client:siphonfuel",function() 
    local petrolCanDurability = GetCurrentGasCanDurability()

    local PlayerPed = PlayerPedId()
    local Vehicle = MRFW.Functions.GetClosestVehicle()

    local PlayerCoords = GetEntityCoords(PlayerPed)
    local vehicleCoords = GetEntityCoords(Vehicle)

    local distanceToVehicle =  #(PlayerCoords - vehicleCoords)
    
    local petrolCanDurability = GetCurrentGasCanDurability()

    
    if distanceToVehicle > 2.5 then
        MRFW.Functions.Notify("You are too far away from the vehicle","error")
        return
    end

    --Check petrol can is able to take fuel
    if petrolCanDurability == nil then
        MRFW.Functions.Notify("You need a petrol can in your hands","error")
        return
    elseif petrolCanDurability == 100 then
        MRFW.Functions.Notify("You petrol can is full","error")
        return
    end
    local currentFuel = GetFuel(Vehicle)
    --Check car is able to have fuel taken
    if currentFuel > 0 then
        --Start taking the fuel
        TaskTurnPedToFaceEntity(PlayerPed, Vehicle, 1000)
	    Wait(1000)
	
	    LoadAnimDict("timetable@gardener@filling_can")
	    TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)

        isFueling = true
        CheckDecor(Vehicle)
        CreateThread(function() 
            local fuelToTake = Config.SiphonRate
            while isFueling do
                Wait(500)

		        currentFuel = (currentFuel - fuelToTake)
                petrolCanDurability = (petrolCanDurability + fuelToTake)

                if currentFuel <= 0 then
                    currentFuel = 0
                    isFueling = false
                end

                --SetFuel(Vehicle, currentFuel)
                
                if petrolCanDurability >= 100 then
                    isFueling = false
                end

                SetPetrolCanDurability(petrolCanDurability)
            end
            -- print(petrolCanDurability)
            SetFuel(Vehicle,GetFuel(Vehicle))
        end)

        while isFueling do
            for _, controlIndex in pairs(Config.DisableKeys) do
                DisableControlAction(0, controlIndex)
            end

			DrawText3Ds(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z + 0.5, Config.Strings.CancelSiphoningFuel .. " | Vehicle: " .. Round(currentFuel, 1) .. "%")

            if not IsEntityPlayingAnim(PlayerPed, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 3) then
                TaskPlayAnim(PlayerPed, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
            end

            if IsControlJustReleased(0, 38) or DoesEntityExist(GetPedInVehicleSeat(vehicle, -1)) then
                isFueling = false
            end

            Wait(0)
        end

        ClearPedTasks(PlayerPed)
        MRFW.Functions.Notify("You siphoned fuel","success")
    else
        MRFW.Functions.Notify("The tank is empty","error")
    end


end)

--Action events
RegisterNetEvent("cc-fuel:client:refillpetrolcan", function()
    local petrolCanDurability = GetCurrentGasCanDurability()
    if petrolCanDurability ~= nil then
        if CurrentWeaponData.info.ammo == 100 then
            MRFW.Functions.Notify("Your can is full","error")
        else
            local refillCost = 4000 - CurrentWeaponData.info.ammo
            -- print(refillCost)
            if refillCost > 0 then
                local currentCash = MRFW.Functions.GetPlayerData().money['cash']  
                local lMera = refillCost / 40
			    if currentCash >= lMera then
					TriggerServerEvent('cc-fuel:server:pay', lMera, GetPlayerServerId(PlayerId()))
                    -- local infos = {}
                    -- infos.uses = 100
                    -- TriggerServerEvent("MRFW:Server:AddItem", CurrentWeaponData.name, CurrentWeaponData.amount, CurrentWeaponData.slot, infos)
                    -- TriggerServerEvent('Perform:Decay:item2', CurrentWeaponData.name, CurrentWeaponData.slot, 100)
                    -- Wait(1000)
					SetPetrolCanDurability2(4000)
				    MRFW.Functions.Notify("You refilled your petrol can","success")
                else
                    MRFW.Functions.Notify("Not enough cash to refill the can","error")
                end
            end
        end
    else
        MRFW.Functions.Notify("You don't have a petrol can to refill","error")
    end
end)

RegisterNetEvent("cc-fuel:client:buypetrolcan", function()
    local currentCash = MRFW.Functions.GetPlayerData().money['cash']
    if currentCash >= Config.JerryCanCost then
        local infos = {}
        infos.ammo = 4000
        -- infos.uses = 100
		TriggerServerEvent('MRFW:Server:AddItem', "weapon_petrolcan", 1, nil,infos)
		TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["weapon_petrolcan"], "add")
		TriggerServerEvent('cc-fuel:server:pay', Config.JerryCanCost, GetPlayerServerId(PlayerId()))
		MRFW.Functions.Notify("You bought a jerry can","success")
	else
		MRFW.Functions.Notify("You don't have enough money to buy a jerry can","error")
	end
end)

RegisterNetEvent("cc-fuel:client:pumprefuel", function(pump) 
    local PlayerPed = PlayerPedId()
    local Vehicle = MRFW.Functions.GetClosestVehicle()

    --Check player is close to pump
    local pumpCoords = GetEntityCoords(pump)
    local PlayerCoords = GetEntityCoords(PlayerPed)
    local vehicleCoords = GetEntityCoords(Vehicle)

    local distanceToPump =  #(PlayerCoords - pumpCoords)
    local distanceToVehicle =  #(PlayerCoords - vehicleCoords)

    
    if distanceToVehicle > 2.5 then
        MRFW.Functions.Notify("You are too far away from the vehicle","error")
        return
    end

    --Check car is able to be fueled
    

    if CanFuelVehicle(Vehicle) then
        --Start the fueling
        TaskTurnPedToFaceEntity(PlayerPed, Vehicle, 1000)
	    Wait(1000)
	
	    LoadAnimDict("timetable@gardener@filling_can")
	    TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)

        --Go Kaboom if the engine on
        if GetIsVehicleEngineRunning(Vehicle) and Config.VehicleEngineOnBlowUp then
            local Chance = math.random(1, 100)
            if Chance <= Config.VehicleBlowUpChance then
                AddExplosion(vehicleCoords, 5, 50.0, true, false, true)
                return
            end
        end

        isFueling = true
        local currentCost = 0
        local currentFuel = GetFuel(Vehicle)
        local currentCash = MRFW.Functions.GetPlayerData().money['cash']

        CheckDecor(Vehicle)
        CreateThread(function() 
            local fuelToAdd = Config.PetrolPumpRefuelRate
            while isFueling do
                Wait(500)
		        
		        local extraCost = fuelToAdd / 1 * Config.CostMultiplier
                
                currentFuel = currentFuel + fuelToAdd

                if currentFuel > 100.0 then
                    currentFuel = 100.0
                    isFueling = false
                end

                currentCost = currentCost + extraCost

                if currentCash >= currentCost then
                    SetFuel(Vehicle, currentFuel)
                else
                    isFueling = false
                end
            end
            SetFuel(Vehicle,GetFuel(Vehicle))
        end)

        while isFueling do
            for _, controlIndex in pairs(Config.DisableKeys) do
                DisableControlAction(0, controlIndex)
            end

            local extraString = "\n" .. "Cost " .. ": ~b~$" .. Round(currentCost, 1)

			DrawText3Ds(pumpCoords.x, pumpCoords.y, pumpCoords.z + 1.2, Config.Strings.CancelFuelingPump .. extraString)
			DrawText3Ds(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z + 0.5, Round(currentFuel, 1) .. "%")

            if not IsEntityPlayingAnim(PlayerPed, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 3) then
                TaskPlayAnim(PlayerPed, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
            end

            if IsControlJustReleased(0, 38) or DoesEntityExist(GetPedInVehicleSeat(vehicle, -1)) then
                isFueling = false
            end

            Wait(0)
        end

        ClearPedTasks(PlayerPed)

		TriggerServerEvent('cc-fuel:server:pay', currentCost, GetPlayerServerId(PlayerId()))
        MRFW.Functions.Notify("You paid $" .. currentCost .. " for fuel","success")
    else
        MRFW.Functions.Notify("The tank is full","error")
    end

end)

RegisterNetEvent("cc-fuel:client:petrolcanrefuel", function() 
    local PlayerPed = PlayerPedId()
    local Vehicle = MRFW.Functions.GetClosestVehicle()

    local PlayerCoords = GetEntityCoords(PlayerPed)
    local vehicleCoords = GetEntityCoords(Vehicle)

    local distanceToVehicle =  #(PlayerCoords - vehicleCoords)
    
    local petrolCanDurability = GetCurrentGasCanDurability()

    
    if distanceToVehicle > 2.5 then
        MRFW.Functions.Notify("You are too far away from the vehicle","error")
        return
    end

    --Check petrol can can fuel car
    if petrolCanDurability == nil then
        MRFW.Functions.Notify("You need a petrol can in your hands","error")
        return
    elseif CurrentWeaponData.info.ammo <= 0 then
        MRFW.Functions.Notify("You petrol can is empty","error")
        return
    end

    --Check car is able to be fueled
    if CanFuelVehicle(Vehicle) then
        --Start the fueling
        TaskTurnPedToFaceEntity(PlayerPed, Vehicle, 1000)
	    Wait(1000)
	
	    LoadAnimDict("timetable@gardener@filling_can")
	    TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)

        --Go Kaboom if the engine on
        if GetIsVehicleEngineRunning(Vehicle) and Config.VehicleEngineOnBlowUp then
            local Chance = math.random(1, 100)
            if Chance <= Config.VehicleBlowUpChance then
                AddExplosion(vehicleCoords, 5, 50.0, true, false, true)
                return
            end
        end

        isFueling = true
        local currentFuel = GetFuel(Vehicle)
        local currentCash = MRFW.Functions.GetPlayerData().money['cash']

        CheckDecor(Vehicle)
        CreateThread(function()
            local fuelToAdd = Config.PetrolCanRefuelRate
            patrolcan = CurrentWeaponData.info.uses
            LocalPlayer.state:set("inv_busy", true, true)
            while isFueling do
                Wait(500)
		        
                currentFuel = currentFuel + fuelToAdd
                -- petrolCanDurability = (petrolCanDurability - fuelToAdd)

                if currentFuel > 100.0 then
                    currentFuel = 100.0
                    isFueling = false
                    SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'), true)
                    -- local infos = {}
                    -- infos.uses = patrolcan
                    -- TriggerServerEvent("MRFW:Server:AddItem", CurrentWeaponData.name, CurrentWeaponData.amount, CurrentWeaponData.slot, infos)
                    LocalPlayer.state:set("inv_busy", false, true)
                end

                SetFuel(Vehicle, currentFuel)
                
                if CurrentWeaponData.info.ammo <= 0 then
                    isFueling = false
                    SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'), true)
                    -- local infos = {}
                    -- infos.uses = patrolcan
                    -- TriggerServerEvent("MRFW:Server:AddItem", CurrentWeaponData.name, CurrentWeaponData.amount, CurrentWeaponData.slot, infos)
                    LocalPlayer.state:set("inv_busy", false, true)
                end
                -- print(petrolCanDurability)
                SetPetrolCanDurability(petrolCanDurability)
                -- patrolcan = patrolcan - Config.PetrolCanRefuelRate2
                -- TriggerServerEvent('Perfor/m:Decay:item', CurrentWeaponData.name, CurrentWeaponData.slot, Config.PetrolCanRefuelRate2)
            end
            SetFuel(Vehicle,GetFuel(Vehicle))
        end)

        while isFueling do
            for _, controlIndex in pairs(Config.DisableKeys) do
                DisableControlAction(0, controlIndex)
            end

			DrawText3Ds(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z + 0.5, Config.Strings.CancelFuelingJerryCan .. "| Vehicle: " .. Round(currentFuel, 1) .. "%")

            if not IsEntityPlayingAnim(PlayerPed, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 3) then
                TaskPlayAnim(PlayerPed, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
            end

            if IsControlJustReleased(0, 38) or DoesEntityExist(GetPedInVehicleSeat(vehicle, -1)) then
                isFueling = false
                SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'), true)
                -- local infos = {}
                -- infos.uses = patrolcan
                -- TriggerServerEvent("MRFW:Server:AddItem", CurrentWeaponData.name, CurrentWeaponData.amount, CurrentWeaponData.slot, infos)
                LocalPlayer.state:set("inv_busy", false, true)
            end

            Wait(0)
        end

        ClearPedTasks(PlayerPed)
        MRFW.Functions.Notify("You refueled your car","success")
    else
        MRFW.Functions.Notify("The tank is full","error")
    end

end)

--Update fuel thread
CreateThread(function()
    DecorRegister(Config.FuelDecor, 1)
    for index = 1, #Config.Blacklist do
		if type(Config.Blacklist[index]) == 'string' then
			Config.Blacklist[GetHashKey(Config.Blacklist[index])] = true
		else
			Config.Blacklist[Config.Blacklist[index]] = true
		end
	end

	for index = #Config.Blacklist, 1, -1 do
		table.remove(Config.Blacklist, index)
	end

    local fuelSynced = false

    local inBlacklisted = false
	while true do
		Wait(1000)

		local ped = PlayerPedId()

		if IsPedInAnyVehicle(ped) then
			local vehicle = GetVehiclePedIsIn(ped)

			if Config.Blacklist[GetEntityModel(vehicle)] then
				inBlacklisted = true
			else
				inBlacklisted = false
			end
            
			if not inBlacklisted and GetPedInVehicleSeat(vehicle, -1) == ped then
				if not DecorExistOn(vehicle, Config.FuelDecor) then
                    SetFuel(vehicle,math.random(200, 800) / 10)
                elseif IsVehicleEngineOn(vehicle) then
                    if GetVehicleClass(vehicle) ~= 15 then
                        SetFuel(vehicle, GetFuel(vehicle) - Config.FuelUsage[Round(GetVehicleCurrentRpm(vehicle), 1)] * (Config.Classes[GetVehicleClass(vehicle)] or 1.0) / 10)
                    elseif GetVehicleClass(vehicle) == 15 then
                        local speed = GetEntitySpeed(vehicle) * 2.23694
                        if speed >= 170 then
                            SetFuel(vehicle, GetFuel(vehicle) - 0.1)
                        elseif speed >= 120 then
                            SetFuel(vehicle, GetFuel(vehicle) - 0.07)
                        elseif speed >= 60 then
                            SetFuel(vehicle, GetFuel(vehicle) - 0.04)
                        else
                            SetFuel(vehicle, GetFuel(vehicle) - 0.01)
                        end
                    end
                elseif not fuelSynced then   
                    fuelSynced = true
                end
                SetFuel(vehicle, GetFuel(vehicle))
			else
                SetFuel(vehicle,GetFuel(vehicle))
            end
		else
            local closestPlayer, distance = MRFW.Functions.GetClosestPlayer()
            local playerPed = GetPlayerPed(closestPlayer)
            if IsPedInAnyVehicle(playerPed) then
                local closestVehicle = GetVehiclePedIsIn(playerPed,false)
                SetFuel(closestVehicle,GetFuel(closestVehicle))
            end
            
			if fuelSynced then
				fuelSynced = false
			end

			if inBlacklisted then
				inBlacklisted = false
			end
		end
	end
end)