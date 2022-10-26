-- MRFW = nil

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(1)
-- 		if MRFW == nil then

--             TriggerEvent("MRFW:GetObject", function(obj) MRFW = obj end)
--             Citizen.Wait(200)
--         end
--     end
-- end)

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(30 * 60000)
		-- print('aj Coke Table')
		TriggerServerEvent('coke:updateTable', false)
	end
end)

local inUse = false
local process
local coord
local location = nil
local enroute
local fueling
local suntrap
local delivering
local hangar
local jerrycan
local checkBoat
local flying
local landing
local hasLanded
local pilot
local ajpboat
local boathash
local driveHangar
local blip
local isProcessing = false


Citizen.CreateThread(function()
	while MRFW == nil do Wait(100) end
    MRFW.Functions.TriggerCallback('jacob:get:coke', function(Coke_start, Coke_Process, Coke_boat)
		coord            = Coke_start
        process          = Coke_Process
		Config.locations = Coke_boat
	end)
end)

-- Citizen.CreateThread(function()
-- 	while MRFW == nil do Wait(100) end
--     MRFW.Functions.TriggerCallback('coke:startcoords', function(servercoords)
--         coord = servercoords
-- 	end)
-- end)

--[[Citizen.CreateThread(function()
	local sleep
	while not coord do
		Citizen.Wait(0)
	end

	while true do
		sleep = 5
		local player = PlayerPedId()
		local playercoords = GetEntityCoords(player)
		local dist = #(vector3(playercoords.x, playercoords.y, playercoords.z)-vector3(coord.x, coord.y, coord.z))
		if not inUse then
			if dist <= 2.0 then
				sleep = 5
				DrawText3D(coord.x, coord.y, coord.z, 'Press ~g~[ E ]~w~ to rent a Boat')
				if IsControlJustPressed(1, 51) then
					MRFW.Functions.TriggerCallback('MRFW:HasItem', function(result)
						--MRFW.Functions.TriggerCallback('coke:pay' , function(success)
							if result then
								TriggerServerEvent('coke:paid')
								main()
							else
								MRFW.Functions.Notify("आपके पास आवश्यक सामग्री नहीं है|", "error")
							end
						--end)
					end, 'greychip')
				end
			else
				sleep = 2000
			end
		elseif dist <= 3 and inUse then
			sleep = 5
			DrawText3D(coord.x, coord.y, coord.z, 'Someone has already requested a boat.')
		else
			sleep = 5000
		end
		Citizen.Wait(sleep)
	end
end)]]

Citizen.CreateThread(function()
	local sleep
	while not coord do
		Citizen.Wait(0)
	end

	while true do
		sleep = 5
		local player = PlayerPedId()
		local playercoords = GetEntityCoords(player)
		local dist = #(vector3(playercoords.x, playercoords.y, playercoords.z)-vector3(coord.x, coord.y, coord.z))
		if not inUse then
			if dist <= 2.0 then
				sleep = 5
				DrawText3D(coord.x, coord.y, coord.z, 'Press ~g~[ E ]~w~ to rent a Boat')
				if IsControlJustPressed(1, 51) then
					MRFW.Functions.TriggerCallback('coke:itemTake', function(HasItem, type)
						if HasItem then
							TriggerServerEvent('coke:paid')
							main()
						else
							MRFW.Functions.Notify("आपके पास आवश्यक सामग्री नहीं है|", "error")

						end
					end)
				end
			else
				sleep = 2000
			end
		elseif dist <= 3 and inUse then
			sleep = 5
			DrawText3D(coord.x, coord.y, coord.z, 'Someone has already requested a boat.')
		else
			sleep = 5000
		end
		Citizen.Wait(sleep)
	end
end)




RegisterNetEvent('coke:syncTable')
AddEventHandler('coke:syncTable', function(bool)
    inUse = bool
end)

RegisterNetEvent('coke:onUse')
AddEventHandler('coke:onUse', function()
	if Config.useMythic then
		MRFW.Functions.Notify("You used Coke", "success")
	end
	local crackhead = PlayerPedId()
	SetPedArmour(crackhead, 30)
	SetTimecycleModifier("DRUG_gas_huffin")
	Citizen.Wait(Config.cokeTime)
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)
	DoScreenFadeIn(2000)
	if Config.useMythic then
		MRFW.Functions.Notify("You are feeling normal now..", "success")
	end
	SetPedArmour(crackhead, 0)
	ClearTimecycleModifier()
end)

function main()
	local player = PlayerPedId()
	SetEntityCoords(player, coord.x-0.1,coord.y-0.1,coord.z-1, 0.0,0.0,0.0, false)
	SetEntityHeading(player, Config.doorHeading)
	playAnim("mp_common", "givetake1_a", 3000)
	Citizen.Wait(2000)
	TriggerServerEvent('coke:updateTable', true)
	if Config.useMythic then
		MRFW.Functions.Notify("Go to the Pier.", "success")
	end
	rand = math.random(1,#Config.locations)
	location = Config.locations[rand]
	blip1 = AddBlipForCoord(location.fuel.x,location.fuel.y,location.fuel.z)
	SetBlipRoute(blip1, true)
	enroute = true
	-- print('ajpop')
	Citizen.CreateThread(function()
		while enroute do
			sleep = 5
			local player = PlayerPedId()
			playerpos = GetEntityCoords(player)
			local disttocoord = #(vector3(location.fuel.x,location.fuel.y,location.fuel.z)-vector3(playerpos.x,playerpos.y,playerpos.z))
			if disttocoord <= 20 then
				-- print('ok')
				--boatFly()
				BoatSpawn()
				enroute = false
			else
				sleep = 1500
			end
			Citizen.Wait(sleep)
		end
	end)
end

function BoatSpawn()

	if DoesEntityExist(ajpboat) then

	    SetVehicleHasBeenOwnedByPlayer(ajpboat,false)
		SetEntityAsNoLongerNeeded(ajpboat)
		DeleteEntity(ajpboat)
	end

	local boathash = GetHashKey("suntrap")

    RequestModel(boathash)
    while not HasModelLoaded(boathash) do
        Citizen.Wait(0)
    end

    ajpboat = CreateVehicle(boathash, location.parking.x, location.parking.y, location.parking.z, 100, true, false)
    local plt = MRFW.Functions.GetPlate(ajpboat)
	SetVehicleHasBeenOwnedByPlayer(ajpboat,true)

	local plate = MRFW.Functions.GetPlate(ajpboat)
	--TriggerServerEvent('garage:addKeys', plate)
	TriggerEvent("vehiclekeys:client:SetOwner", plate)
	-- SetVehicleFuelLevel(boat, 5)
	-- exports['mr-fuel']:SetFuel(boat, 5)
	exports['mr-fuel']:SetFuel(boat, 100.0)

	RemoveBlip(blip1)
	SetBlipRoute(blip1, false)

	suntrap = false
	delivering = true
	delivery()


    while true do
    	Citizen.Wait(1)
    	 DrawText3D(location.parking.x, location.parking.y, location.parking.z, "Cocaine Boat.")
		 if #(GetEntityCoords(PlayerPedId()) - vector3(location.parking.x, location.parking.y, location.parking.z)) < 8.0 then
    	 	return
    	 end
	end
end

function boatFly()


end


Citizen.CreateThread(function()
	checkBoat = true
	while checkBoat do
		sleep = 100
		if DoesEntityExist(ajpboat) then
			if GetVehicleEngineHealth(ajpboat) < 0 then
				if Config.useMythic then
					MRFW.Functions.Notify("Failed, your boat was Destroyed", "error")
				end
				TriggerServerEvent('coke:updateTable', false)
				RemoveBlip(blip)
				SetBlipRoute(blip, false)
				DeleteEntity(pickupSpawn)
				delivering = false
				checkBoat = false
			end
		else
			sleep = 3000
		end
		Citizen.Wait(sleep)
	end
end)

function delivery()
	if Config.useMythic then
		MRFW.Functions.Notify("Get in the boat and pick up the delivery marked on your GPS", "success")
	end
	local pickup = GetHashKey("prop_barrel_float_1")
	blip = AddBlipForCoord(location.delivery.x,location.delivery.y,location.delivery.z)
	SetBlipRoute(blip, true)
	RequestModel(pickup)
	while not HasModelLoaded(pickup) do
		Citizen.Wait(0)
	end
	local pickupSpawn = CreateObject(pickup, location.delivery.x,location.delivery.y,location.delivery.z, true, true, true)
	local player = PlayerPedId()
	Citizen.CreateThread(function()
		while delivering do
			sleep = 5
			local playerpos = GetEntityCoords(player)
			local disttocoord = #(vector3(location.delivery.x,location.delivery.y,location.delivery.z)-vector3(playerpos.x,playerpos.y,playerpos.z))
			if disttocoord <= 10 then
				RemoveBlip(blip)
				SetBlipRoute(blip, false)
				DrawText3D(location.delivery.x,location.delivery.y,location.delivery.z-1, 'Press ~g~[ E ]~w~ to pick up the delivery')
				if IsControlJustPressed(1, 51) then
					delivering = false

					MRFW.Functions.Progressbar("picking_", "Picking up the delivery..", 5000, false, true, {
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = false,
						disableCombat = true,
					}, {}, {}, {}, function() -- Done
						DeleteEntity(pickupSpawn)
					end, function() -- Cancel
						MRFW.Functions.Notify("Canceled!", "error")
					end)

					Citizen.Wait(2000)
					MRFW.Functions.Notify("Picked up the delivery. Return to the Pier marked on your GPS.", "success")
					Citizen.Wait(2000)
					final()
				end
			else
				sleep = 1500
			end
			Citizen.Wait(sleep)
		end
	end)
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
function final()
	MRFW.Functions.Notify("Deliver the boat back to a hangar", "success")
	blip = AddBlipForCoord(location.hangar.x,location.hangar.y,location.hangar.z)
	SetBlipRoute(blip, true)
	hangar = true
	local player = PlayerPedId()
	Citizen.CreateThread(function()
		while hangar do
			sleep = 5
			local playerpos = GetEntityCoords(player)
			local disttocoord = #(vector3(location.hangar.x,location.hangar.y,location.hangar.z)-vector3(playerpos.x,playerpos.y,playerpos.z))
			if IsPedInAnyBoat(PlayerPedId()) and disttocoord <= 10 then
				RemoveBlip(blip)
				SetBlipRoute(blip, false)
				DrawText3D(location.hangar.x,location.hangar.y,location.hangar.z-1, 'Press [E] to park the boat.')
				DrawMarker(27, location.hangar.x,location.hangar.y,location.hangar.z-0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 2.0, 3, 252, 152, 100, false, true, 2, false, false, false, false)
				if IsControlJustPressed(1, 51) then
					hangar = false
					FreezeEntityPosition(ajpboat, true)
					MRFW.Functions.Progressbar("lockpick_vehicledoor", "Returning..", 2500, false, true, {
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = false,
						disableCombat = true,
					}, {}, {}, {}, function() -- Done
						DeleteEntity(ajpboat)
					end, function() -- Cancel
						DeleteEntity(ajpboat)
					end)

					Citizen.Wait(2000)
					TriggerServerEvent('coke:GiveItem')
					TaskLeaveVehicle(player, ajpboat, 0)
					SetVehicleDoorsLocked(ajpboat, 2)
					Citizen.Wait(1000)
					if Config.useCD then
						cooldown()
					else
						TriggerServerEvent('coke:updateTable', false)
					end
				end
			else
				sleep = 1500
			end
			Citizen.Wait(sleep)
		end
	end)
end

Citizen.CreateThread(function()
	local sleep
	while not process do
		Citizen.Wait(0)
	end
	while true do
		sleep = 5
		local player = PlayerPedId()
		local playercoords = GetEntityCoords(player)
		local dist = #(vector3(playercoords.x,playercoords.y,playercoords.z)-vector3(process.x,process.y,process.z))
		if dist <= 3 and not isProcessing then
			sleep = 5
			DrawText3D(process.x, process.y, process.z, 'Press [ E ] to process coke')
			if IsControlJustPressed(1, 51) then
				isProcessing = true
				MRFW.Functions.TriggerCallback('coke:ingredient', function(HasItem, type)
					if HasItem then
						processing()
					else
						MRFW.Functions.Notify("You are missing something", "error")
						isProcessing = false
					end
				end)
			end
		else
			sleep = 1500
		end
		Citizen.Wait(sleep)
	end
end)

function processing()
	local player = PlayerPedId()
	SetEntityCoords(player, process.x,process.y,process.z-1, 0.0, 0.0, 0.0, false)
	SetEntityHeading(player, 286.84)
	FreezeEntityPosition(player, true)
	playAnim("anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 30000)

	MRFW.Functions.Progressbar("coke-", "Breaking down the coke..", 30000, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {}, {}, {}, function() -- Done
		FreezeEntityPosition(player, false)
		TriggerServerEvent('coke:processed')
		isProcessing = false
	end, function() -- Cancel
		isProcessing = false
		ClearPedTasksImmediately(player)
		FreezeEntityPosition(player, false)
	end)

end

function cooldown()
	Citizen.Wait(Config.cdTime)
	TriggerServerEvent('coke:updateTable', false)
end

function playAnimPed(animDict, animName, duration, buyer, x,y,z)
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
      Citizen.Wait(0)
    end
    TaskPlayAnim(pilot, animDict, animName, 1.0, -1.0, duration, 49, 1, false, false, false)
    RemoveAnimDict(animDict)
end

function playAnim(animDict, animName, duration)
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
      Citizen.Wait(0)
    end
    TaskPlayAnim(PlayerPedId(), animDict, animName, 1.0, -1.0, duration, 49, 1, false, false, false)
    RemoveAnimDict(animDict)
end
