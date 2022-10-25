-- local Objectfinder = false
-- local GunDeleter = false

-- -- RegisterCommand("objectfinder", function(src)
-- -- 	Objectfinder = not Objectfinder
-- -- end)

-- -- RegisterCommand("gundeleter", function(src)
-- -- 	GunDeleter = not GunDeleter
-- -- end)

-- Citizen.CreateThread(function()
-- 	while true do
-- 		local sleep = 500

-- 		if GunDeleter then
-- 			sleep = 5

-- 			local IsFound, Object = GetEntityPlayerIsFreeAimingAt(PlayerId())

-- 			if IsFound then
-- 				SetEntityAsMissionEntity(Object, false, false)
-- 				DeleteObject(Object)
-- 			end
-- 		end

-- 		if Objectfinder then
-- 			sleep = 5

-- 			if IsPedShooting(PlayerPedId()) then
-- 				local IsFound, Object = GetEntityPlayerIsFreeAimingAt(PlayerId())

-- 				if IsFound then
-- 					print("Object ID: " .. Object)
-- 					print("Model Hash: " .. GetEntityModel(Object))
-- 					print("Coords: " .. GetEntityCoords(Object))
-- 				end
-- 			end
-- 		end

-- 		Citizen.Wait(sleep)
-- 	end
-- end)

RegisterCommand('nostuck', function(source, args)
    local ped = PlayerPedId()
    if not IsPedInAnyVehicle(ped, false) then
        ClearPedTasksImmediately(PlayerPedId())
        FreezeEntityPosition(PlayerPedId(), false)
		SetNuiFocus(false, false)
    else
        MRFW.Functions.Notify('Chala jaa kal aana kal', 'error')
    end

end, false)

RegisterCommand('closegui', function(source, args)
		SetNuiFocus(false, false)
end, false)