CreateThread(function()
	local vehicleWhitelist = {[0]=true,[1]=true,[2]=true,[3]=true,[4]=true,[5]=true,[6]=true,[7]=true,[8]=true,[9]=true,[10]=true,[11]=true,[12]=true,[17]=true,[19]=true,[20]=true}
	local sleep = 500
	while true do
        local playerPed = PlayerPedId()
        if (not isPlayerWhitelisted or Config.Debug) then
            for k, v in pairs(Config.Timer) do
                if v > 0 then Config.Timer[k] = v - 1 end
            end
            if GetVehiclePedIsUsing(playerPed) ~= 0 then
                local vehicle = GetVehiclePedIsUsing(playerPed, true)
                if vehicleWhitelist[GetVehicleClass(vehicle)] then
                    local driver = GetPedInVehicleSeat(vehicle, -1)
                    if Config.Timer['Shooting'] == 0 and not BlacklistedWeapon(playerPed) and not IsPedCurrentWeaponSilenced(playerPed) and IsPedArmed(playerPed, 4) then
                        sleep = 10
                        if IsPedShooting(playerPed) then
                            local vehicle = vehicleData(vehicle)
                            exports['mr-dispatch']:VehicleShooting(vehicle)
                            Config.Timer['Shooting'] = Config.Shooting.Success
                        else
                            Config.Timer['Shooting'] = Config.Shooting.Fail
                        end
                    else 
                        sleep = 500 
                    end
                end
            else
                if Config.Timer['Shooting'] == 0  and not IsPedCurrentWeaponSilenced(playerPed) and IsPedArmed(playerPed, 4) then
                    sleep = 50
                    if IsPedShooting(playerPed) and not BlacklistedWeapon(playerPed) then
                        exports['mr-dispatch']:Shooting()
                        Config.Timer['Shooting'] = Config.Shooting.Success
                    else
                        Config.Timer['Shooting'] = Config.Shooting.Fail
                    end
                else sleep = 500 end
            end
        end
		Wait(sleep)
	end
end)