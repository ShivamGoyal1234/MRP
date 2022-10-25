local kmh = 3.6
local mph = 2.23693629
local carspeed = 0
local driftmode = false
local speed = mph
local drift_speed_limit = 120.0 
local toggle = 118
CreateThread(function()
	while true do
		Wait(20)
		if IsControlJustPressed(1, 118) then
			driftmode = not driftmode
			if driftmode then
				MRFW.Functions.Notify("Drift Mode on..", "primary")
			else
				MRFW.Functions.Notify("Drift Mode off..", "primary")
			end
		end
		if driftmode then
			if IsPedInAnyVehicle(GetPed(), false) then
				CarSpeed = GetEntitySpeed(GetCar()) * speed
				if GetPedInVehicleSeat(GetCar(), -1) == GetPed() then
					if CarSpeed <= drift_speed_limit then  
						if IsControlPressed(1, 21) then
							SetVehicleReduceGrip(GetCar(), true)
						else
							SetVehicleReduceGrip(GetCar(), false)
						end
					end
				end
			end
		end
	end 
end)
function GetPed() return PlayerPedId() end
function GetCar() return GetVehiclePedIsIn(PlayerPedId(),false) end