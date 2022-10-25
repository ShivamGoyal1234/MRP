-- MRFW = nil

-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(10)
-- 		if MRFW == nil then
-- 			TriggerEvent('MRFW:GetObject', function(obj) MRFW = obj end)
-- 			Citizen.Wait(200)
-- 		end
-- 	end
-- end)

-- Code

local disableShuffle = true

Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		local veh = GetVehiclePedIsIn(ped)

		if IsPedInAnyVehicle(ped, false) and disableShuffle then
			if GetPedInVehicleSeat(veh, false, 0) == ped then
				if GetIsTaskActive(ped, 165) then
					SetPedIntoVehicle(ped, veh, 0)
				end
			end
		end

		Citizen.Wait(5)
	end
end)

RegisterNetEvent("mr-seatshuff:client:Shuff")
AddEventHandler("mr-seatshuff:client:Shuff", function()
	local ped = PlayerPedId()
	if IsPedInAnyVehicle(ped, false) then
		disableShuffle = false
		SetTimeout(5000, function()
			disableShuffle = true
		end)
	else
		CancelEvent()
	end
end)