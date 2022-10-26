local MRFW                  = exports['mrfw']:GetCoreObject()
local CurrentAction     = nil
local CurrentActionMsg  = nil
local CurrentActionData = nil
local Licenses          = {}
local CurrentTest       = nil
local CurrentTestType   = nil
local CurrentVehicle    = nil
local CurrentCheckPoint, DriveErrors = 0, 0
local LastCheckPoint    = -1
local CurrentBlip       = nil
local CurrentZoneType   = nil
local IsAboveSpeedLimit = false
local LastVehicleHealth = nil

function DrawMissionText(msg, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandPrint(time, true)
end

function StartTheoryTest()
	CurrentTest = 'theory'

	SendNUIMessage({
		openQuestion = true
	})

	SetTimeout(200, function()
		SetNuiFocus(true, true)
	end)


end

function StopTheoryTest(success)
	CurrentTest = nil

	SendNUIMessage({
		openQuestion = false
	})

	SetNuiFocus(false)

	if success then
		
		--helptext(_U('passed_test'))
		MRFW.Functions.Notify("Passed Theory Test , Start your practical test!", "success" , 5000)
		StartDriveTest()
	else
		--helptext(_U('failed_test'))
		MRFW.Functions.Notify("Failed Theory Test", "error")
	end
end

function StartDriveTest()

	local coords = {
        x = 231.36,
        y = -1394.49,
        z = 30.5,
        h = 239.94,
    }
    local plate = "TESTDRIVE"..math.random(1111, 9999)
    MRFW.Functions.SpawnVehicle('blista', function(vehicle)
        SetVehicleNumberPlateText(vehicle, "TESTDRIVE"..tostring(math.random(1000, 9999)))
        SetEntityHeading(vehicle, coords.h)
        exports['mr-fuel']:SetFuel(vehicle, 100.0)
		exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(vehicle), 'body', 1000.0)
		exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(vehicle), 'engine', 1000.0)
		exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(vehicle), 'fuel', 100)
		exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(vehicle), 'clutch', 100)
		exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(vehicle), 'brakes', 100)
		exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(vehicle), 'axle', 100)
		exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(vehicle), 'radiator', 100)
        Menu.hidden = true
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))
        SetVehicleCustomPrimaryColour(vehicle, 0, 0, 0)
        SetVehicleEngineOn(vehicle, true, true)
        SetVehicleDirtLevel(vehicle)
        SetVehicleUndriveable(vehicle, false)
        WashDecalsFromVehicle(vehicle, 1.0)
		CurrentTest       = 'drive'
		CurrentTestType   = 'drive_test'
		CurrentCheckPoint = 0
		LastCheckPoint    = -1
		CurrentZoneType   = 'residence'
		DriveErrors       = 0
		IsAboveSpeedLimit = false
		CurrentVehicle    = vehicle
		LastVehicleHealth = GetEntityHealth(vehicle)
    end, coords, true)

	
end

function StopDriveTest(success)
	if success then
		TriggerServerEvent('mr-drivingschool:server:GetLicense')
		MRFW.Functions.Notify("Passed Driving Test", "success")
	else
		--helptext(_U('failed_test'))
		MRFW.Functions.Notify("Failed Driving Test", "error")
	end

	CurrentTest     = nil
	CurrentTestType = nil
end

function SetCurrentZoneType(type)
CurrentZoneType = type
end

RegisterNUICallback('question', function(data, cb)
	SendNUIMessage({
		openSection = 'question'
	})

	cb()
end)

RegisterNUICallback('close', function(data, cb)
	StopTheoryTest(true)
	cb()
end)

RegisterNUICallback('kick', function(data, cb)
	StopTheoryTest(false)
	cb()
end)

AddEventHandler('mr-drivingschool:hasEnteredMarker', function(zone)
	if zone == 'DMVSchool' then
		CurrentAction     = 'dmvschool_menu'
		CurrentActionMsg  = ('Press E to give driving test - $500')
		CurrentActionData = {}
	end
end)

AddEventHandler('mr-drivingschool:hasExitedMarker', function(zone)
	CurrentAction = nil
end)


-- Create Blips
-- Citizen.CreateThread(function()
-- 	local blip = AddBlipForCoord(Config.Zones.DMVSchool.Pos.x, Config.Zones.DMVSchool.Pos.y, Config.Zones.DMVSchool.Pos.z)

-- 	SetBlipSprite (blip, 525)
-- 	SetBlipDisplay(blip, 4)
-- 	SetBlipScale  (blip, 0.7)
-- 	SetBlipColour (blip , 4)
-- 	SetBlipAsShortRange(blip, true)

-- 	BeginTextCommandSetBlipName("STRING")
-- 	AddTextComponentString('Driving School')
-- 	EndTextCommandSetBlipName(blip)
-- end)

-- Display markers
-- Citizen.CreateThread(function()
-- 	while true do
-- 		sleep = 1000

-- 		local coords = GetEntityCoords(PlayerPedId())

-- 		for k,v in pairs(Config.Zones) do
-- 			if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
-- 				sleep = 5
-- 				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
-- 			end
-- 		end
-- 		Wait(sleep)
-- 	end
-- end)

-- Enter / Exit marker events
-- Citizen.CreateThread(function()
-- 	while true do

-- 		Citizen.Wait(100)

-- 		local coords      = GetEntityCoords(PlayerPedId())
-- 		local isInMarker  = false
-- 		local currentZone = nil

-- 		for k,v in pairs(Config.Zones) do
-- 			if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
-- 				isInMarker  = true
-- 				currentZone = k
-- 			end
-- 		end

-- 		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
-- 			HasAlreadyEnteredMarker = true
-- 			LastZone                = currentZone
-- 			TriggerEvent('mr-drivingschool:hasEnteredMarker', currentZone)
-- 		end

-- 		if not isInMarker and HasAlreadyEnteredMarker then
-- 			HasAlreadyEnteredMarker = false
-- 			TriggerEvent('mr-drivingschool:hasExitedMarker', LastZone)
-- 		end
-- 	end
-- end)

-- Block UI
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)

		if CurrentTest == 'theory' then
			local playerPed = PlayerPedId()

			DisableControlAction(0, 1, true) -- LookLeftRight
			DisableControlAction(0, 2, true) -- LookUpDown
			DisablePlayerFiring(playerPed, true) -- Disable weapon firing
			DisableControlAction(0, 142, true) -- MeleeAttackAlternate
			DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
		else
			Citizen.Wait(1000)
		end
	end
end)


RegisterNetEvent('driving:test', function()
	MRFW.Functions.TriggerCallback('MRFW:HasItem', function(result1)
		if result1 then
			MRFW.Functions.Notify("You Already have License!", "error")
		else
			MRFW.Functions.Notify("You cannot close screen until and unless you give theory test", "error")
			TriggerServerEvent('mr-drivingschool:Payaj')
			StartTheoryTest()
		end
	end, 'driver_license')
end)

-- Drive test
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(5)

		if CurrentTest == 'drive' then
			local playerPed      = PlayerPedId()
			local coords         = GetEntityCoords(playerPed)
			local nextCheckPoint = CurrentCheckPoint + 1

			if Config.CheckPoints[nextCheckPoint] == nil then
				if DoesBlipExist(CurrentBlip) then
					RemoveBlip(CurrentBlip)
				end

				CurrentTest = nil

				--helptext('driving_test_complete')
				MRFW.Functions.Notify("Driving Test Complete", "error")

				if DriveErrors < Config.MaxErrors then
					StopDriveTest(true)
				else
					StopDriveTest(false)
				end
			else

				if CurrentCheckPoint ~= LastCheckPoint then
					if DoesBlipExist(CurrentBlip) then
						RemoveBlip(CurrentBlip)
					end

					CurrentBlip = AddBlipForCoord(Config.CheckPoints[nextCheckPoint].Pos.x, Config.CheckPoints[nextCheckPoint].Pos.y, Config.CheckPoints[nextCheckPoint].Pos.z)
					SetBlipRoute(CurrentBlip, 1)

					LastCheckPoint = CurrentCheckPoint
				end

				local distance = GetDistanceBetweenCoords(coords, Config.CheckPoints[nextCheckPoint].Pos.x, Config.CheckPoints[nextCheckPoint].Pos.y, Config.CheckPoints[nextCheckPoint].Pos.z, true)

				if distance <= 100.0 then
					DrawMarker(1, Config.CheckPoints[nextCheckPoint].Pos.x, Config.CheckPoints[nextCheckPoint].Pos.y, Config.CheckPoints[nextCheckPoint].Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 102, 204, 102, 100, false, true, 2, false, false, false, false)
				end

				if distance <= 3.0 then
					Config.CheckPoints[nextCheckPoint].Action(playerPed, CurrentVehicle, SetCurrentZoneType)
					CurrentCheckPoint = CurrentCheckPoint + 1
				end
			end
		else
			-- not currently taking driver test
			Citizen.Wait(1000)
		end
	end
end)

-- Speed / Damage control
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)

		if CurrentTest == 'drive' then

			local playerPed = PlayerPedId()

			if IsPedInAnyVehicle(playerPed, false) then

				local vehicle      = GetVehiclePedIsIn(playerPed, false)
				local speed        = GetEntitySpeed(vehicle) * Config.SpeedMultiplier
				local tooMuchSpeed = false

				for k,v in pairs(Config.SpeedLimits) do
					if CurrentZoneType == k and speed > v then
						tooMuchSpeed = true

						if not IsAboveSpeedLimit then
							DriveErrors       = DriveErrors + 1
							IsAboveSpeedLimit = true

							MRFW.Functions.Notify("Driving Too Fast", "error")
							MRFW.Functions.Notify(" "..v.." " ,"error")
							MRFW.Functions.Notify("Mistakes - "..DriveErrors.." / "..Config.MaxErrors.." ","error")
						end
					end
				end

				if not tooMuchSpeed then
					IsAboveSpeedLimit = false
				end

				local health = GetEntityHealth(vehicle)
				if health < LastVehicleHealth then

					DriveErrors = DriveErrors + 1

					
					MRFW.Functions.Notify("You damaged veh", "error")
					MRFW.Functions.Notify("Mistakes - "..DriveErrors.." / "..Config.MaxErrors.." ", "error")
					--helptext('errors', DriveErrors, Config.MaxErrors)

					-- avoid stacking faults
					LastVehicleHealth = health
					Citizen.Wait(1500)
				end
			end
		else
			-- not currently taking driver test
			Citizen.Wait(1000)
		end
	end
end)

helpText = function(msg)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end