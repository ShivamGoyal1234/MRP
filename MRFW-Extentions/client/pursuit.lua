local Control = 172
local defaultHash, defaultHash2, defaultHash3, defaultHash4, defaultHash5 = "npolchal","npolvette","npolstang","npolchar","npolvic"
local pursuitEnabled = false
local InPursuitModeAPlus = false
local InPursuitModeB = false
local SelectedPursuitMode =0

RegisterNetEvent("police:Ghost:Pursuit:Mode:A", function()
	local ped = PlayerPedId()
	if (IsPedInAnyVehicle(PlayerPedId(), true)) then
		local veh = GetVehiclePedIsIn(PlayerPedId(),false)  
		local Driver = GetPedInVehicleSeat(veh, -1)
		local fInitialDriveForce = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce')
		local First = 'A +'
		if IsPedSittingInAnyVehicle(ped) and IsVehicleModel(veh,defaultHash) or IsVehicleModel(veh,defaultHash2) or IsVehicleModel(veh,defaultHash3)
		   or IsVehicleModel(veh,defaultHash4) or IsVehicleModel(veh,defaultHash5) and PlayerData.metadata['pursuit'] then
			SetVehicleModKit(veh, 0)
			SetVehicleMod(veh, 46, 4, true) 
			SetVehicleMod(veh, 11, 4, true)
			SetVehicleMod(veh, 12, 4, false)
			SetVehicleMod(veh, 13, 4, false)  
			ToggleVehicleMod(veh,  18, false)          
            -- TriggerEvent('PursuitModeIcon:Enable:A+')
            MRFW.Functions.Notify('New Mode : ' ..First, 'error', 3000) 
			PursuitEnabled = true
			SetVehicleHandlingField(veh, 'CHandlingData', 'fInitialDriveForce', 0.3970000)
			SetVehicleHandlingField(veh, 'CHandlingData', 'fDriveInertia', 1.100000)
            if IsVehicleModel(veh,defaultHash) then --npolchal
                SetVehicleHandlingField(veh, 'CHandlingData', 'fInitialDriveMaxFlatVel', 179.0) --179.0
                SetVehicleHandlingField(veh, 'CHandlingData', 'nInitialDriveGears', 6)
                SetVehicleHandlingField(veh, 'CHandlingData', 'fClutchChangeRateScaleUpShift', 4.0000000476837)
            elseif IsVehicleModel(veh,defaultHash2) then --npolvette
                SetVehicleHandlingField(veh, 'CHandlingData', 'fInitialDriveMaxFlatVel', 178.0) --178.0
                SetVehicleHandlingField(veh, 'CHandlingData', 'nInitialDriveGears', 6)
                SetVehicleHandlingField(veh, 'CHandlingData', 'fClutchChangeRateScaleUpShift', 3.2000000476837)
            elseif IsVehicleModel(veh,defaultHash3) then --npolstang
                SetVehicleHandlingField(veh, 'CHandlingData', 'fInitialDriveMaxFlatVel', 180.0) --180.0
                SetVehicleHandlingField(veh, 'CHandlingData', 'fClutchChangeRateScaleUpShift', 4.0000000476837)
            elseif IsVehicleModel(veh,defaultHash4) then --polchar
                SetVehicleHandlingField(veh, 'CHandlingData', 'fInitialDriveMaxFlatVel', 180.0) --180.0
                SetVehicleHandlingField(veh, 'CHandlingData', 'nInitialDriveGears', 5)
            elseif IsVehicleModel(veh,defaultHash5) then --npolvic
                SetVehicleHandlingField(veh, 'CHandlingData', 'fInitialDriveMaxFlatVel', 175.0) --175.0
                SetVehicleHandlingField(veh, 'CHandlingData', 'nInitialDriveGears', 5)
            end
            SelectedPursuitMode = 35
		else
            MRFW.Functions.Notify('You are not in a HEAT vehicle', 'error', 3000) 
		end
	end
end)

RegisterNetEvent("police:Ghost:Pursuit:B:Plus", function()
    local ped = PlayerPedId()
	if (IsPedInAnyVehicle(PlayerPedId(), true)) then
		local veh = GetVehiclePedIsIn(PlayerPedId(),false)  
		local Driver = GetPedInVehicleSeat(veh, -1)
        local fInitialDriveForce = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce')
		local mode1 = 'B +'
        
        if IsPedSittingInAnyVehicle(ped) and IsVehicleModel(veh,defaultHash) or IsVehicleModel(veh,defaultHash2) or IsVehicleModel(veh,defaultHash3)  -- Vehicle Checks
	       or IsVehicleModel(veh,defaultHash4) or IsVehicleModel(veh,defaultHash5) and PlayerData.metadata['pursuit'] then
            SetVehicleModKit(veh, 0)
            SetVehicleMod(veh, 46, 4, true)
            SetVehicleMod(veh, 11, 4, true)
            SetVehicleMod(veh, 12, 4, true)
            SetVehicleMod(veh, 13, 4, true)  
            ToggleVehicleMod(veh,  18, true)          
            -- TriggerEvent('PursuitModeIcon:Enable:B+') 
            MRFW.Functions.Notify('New Mode : ' ..mode1, 'error', 3000) 
            PursuitEnabled = true
            SetVehicleHandlingField(veh, 'CHandlingData', 'fInitialDriveForce', 0.4270000)
            SetVehicleHandlingField(veh, 'CHandlingData', 'fDriveInertia', 1.200000)
            if IsVehicleModel(veh,defaultHash) then --npolchal
                SetVehicleHandlingField(veh, 'CHandlingData', 'fInitialDriveMaxFlatVel', 179.0) --179.0
                SetVehicleHandlingField(veh, 'CHandlingData', 'nInitialDriveGears', 6)
                SetVehicleHandlingField(veh, 'CHandlingData', 'fClutchChangeRateScaleUpShift', 4.0000000476837)
            elseif IsVehicleModel(veh,defaultHash2) then --npolvette
                SetVehicleHandlingField(veh, 'CHandlingData', 'fInitialDriveMaxFlatVel', 178.0) --178.0
                SetVehicleHandlingField(veh, 'CHandlingData', 'nInitialDriveGears', 6)
                SetVehicleHandlingField(veh, 'CHandlingData', 'fClutchChangeRateScaleUpShift', 3.2000000476837)
            elseif IsVehicleModel(veh,defaultHash3) then --npolstang
                SetVehicleHandlingField(veh, 'CHandlingData', 'fInitialDriveMaxFlatVel', 180.0) --180.0
                SetVehicleHandlingField(veh, 'CHandlingData', 'fClutchChangeRateScaleUpShift', 4.0000000476837)
            elseif IsVehicleModel(veh,defaultHash4) then --polchar
                SetVehicleHandlingField(veh, 'CHandlingData', 'fInitialDriveMaxFlatVel', 180.0) --180.0
                SetVehicleHandlingField(veh, 'CHandlingData', 'nInitialDriveGears', 5)
            elseif IsVehicleModel(veh,defaultHash5) then --npolvic
                SetVehicleHandlingField(veh, 'CHandlingData', 'fInitialDriveMaxFlatVel', 175.0) --175.0
                SetVehicleHandlingField(veh, 'CHandlingData', 'nInitialDriveGears', 5)
            end
            SelectedPursuitMode = 50
        else
            MRFW.Functions.Notify('You are not in a HEAT vehicle', 'error', 3000)
        end
    end
end)

RegisterNetEvent("police:Ghost:Pursuit:SPlusMode", function()
    local ped = PlayerPedId()
	if (IsPedInAnyVehicle(PlayerPedId(), true)) then
		local veh = GetVehiclePedIsIn(PlayerPedId(),false)  
		local Driver = GetPedInVehicleSeat(veh, -1)
        local fInitialDriveForce = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce')
		local mode2 = 'S +'
        
        if IsPedSittingInAnyVehicle(ped) and IsVehicleModel(veh,defaultHash) or IsVehicleModel(veh,defaultHash2) or IsVehicleModel(veh,defaultHash3)  -- Vehicle Checks
	      or IsVehicleModel(veh,defaultHash4) or IsVehicleModel(veh,defaultHash5) and PlayerData.metadata['pursuit'] then
            SetVehicleModKit(veh, 0)
            SetVehicleMod(veh, 46, 4, true)
            SetVehicleMod(veh, 11, 4, true)
            SetVehicleMod(veh, 12, 4, true)
            SetVehicleMod(veh, 13, 4, true)  
            ToggleVehicleMod(veh,  18, true)          
            -- TriggerEvent('PursuitModeIcon:Enable:S+') 
            MRFW.Functions.Notify('New Mode : ' ..mode2, 'error', 3000) 
            PursuitEnabled = true
            SetVehicleHandlingField(veh, 'CHandlingData', 'fInitialDriveForce', 0.5170000)
            SetVehicleHandlingField(veh, 'CHandlingData', 'fDriveInertia', 1.300000)
            if IsVehicleModel(veh,defaultHash) then --npolchal
                SetVehicleHandlingField(veh, 'CHandlingData', 'fInitialDriveMaxFlatVel', 250.0) --179.0
                SetVehicleHandlingField(veh, 'CHandlingData', 'nInitialDriveGears', 7)
                SetVehicleHandlingField(veh, 'CHandlingData', 'fClutchChangeRateScaleUpShift', 2.0000000476837)
            elseif IsVehicleModel(veh,defaultHash2) then --npolvette
                SetVehicleHandlingField(veh, 'CHandlingData', 'fInitialDriveMaxFlatVel', 270.0) --178.0
                SetVehicleHandlingField(veh, 'CHandlingData', 'nInitialDriveGears', 6)
                SetVehicleHandlingField(veh, 'CHandlingData', 'fClutchChangeRateScaleUpShift', 2.2000000476837)
            elseif IsVehicleModel(veh,defaultHash3) then --npolstang
                SetVehicleHandlingField(veh, 'CHandlingData', 'fInitialDriveMaxFlatVel', 200.0) --180.0
                SetVehicleHandlingField(veh, 'CHandlingData', 'fClutchChangeRateScaleUpShift', 3.5000000476837)
            elseif IsVehicleModel(veh,defaultHash4) then --polchar
                SetVehicleHandlingField(veh, 'CHandlingData', 'fInitialDriveMaxFlatVel', 190.0) --180.0
                SetVehicleHandlingField(veh, 'CHandlingData', 'nInitialDriveGears', 6)
            elseif IsVehicleModel(veh,defaultHash5) then --npolvic
                SetVehicleHandlingField(veh, 'CHandlingData', 'fInitialDriveMaxFlatVel', 180.0) --175.0
                SetVehicleHandlingField(veh, 'CHandlingData', 'nInitialDriveGears', 4)
            end
            SelectedPursuitMode = 100
        else
            MRFW.Functions.Notify('You are not in a HEAT vehicle', 'error', 3000)
        end
    end
end)

RegisterNetEvent("police:pursuitmodeOff", function()
    local ped = PlayerPedId()
	if (IsPedInAnyVehicle(PlayerPedId(), true)) then
		local veh = GetVehiclePedIsIn(PlayerPedId(),false)  
		local Driver = GetPedInVehicleSeat(veh, -1)
        local fInitialDriveForce = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce')
		if IsPedSittingInAnyVehicle(ped) and IsVehicleModel(veh,defaultHash) or IsVehicleModel(veh,defaultHash2) or IsVehicleModel(veh,defaultHash3) or IsVehicleModel(veh,defaultHash4) or IsVehicleModel(veh,defaultHash5) and PlayerData.metadata['pursuit'] then
            -- TriggerEvent('PursuitModeIcon:Disable')
            SetVehicleModKit(veh, 0)
            SetVehicleMod(veh, 46, 4, false)
            SetVehicleMod(veh, 13, 4, false)
            SetVehicleMod(veh, 12, 4, false)
            SetVehicleMod(veh, 11, 4, false)
            ToggleVehicleMod(veh,  18, false)
            MRFW.Functions.Notify('Pursuit Mode Disabled', 'error', 3000)
            InPursuitModeAPlus = false
            pursuitEnabled = false
            InPursuitModeB = false
            SetVehicleHandlingField(veh, 'CHandlingData', 'fInitialDriveForce', 0.3050000)
            SetVehicleHandlingField(veh, 'CHandlingData', 'fDriveInertia', 1.00000)
            if IsVehicleModel(veh,defaultHash) then --npolchal
                SetVehicleHandlingField(veh, 'CHandlingData', 'fInitialDriveMaxFlatVel', 179.0) --179.0
                SetVehicleHandlingField(veh, 'CHandlingData', 'nInitialDriveGears', 6)
                SetVehicleHandlingField(veh, 'CHandlingData', 'fClutchChangeRateScaleUpShift', 4.0000000476837)
            elseif IsVehicleModel(veh,defaultHash2) then --npolvette
                SetVehicleHandlingField(veh, 'CHandlingData', 'fInitialDriveMaxFlatVel', 178.0) --178.0
                SetVehicleHandlingField(veh, 'CHandlingData', 'nInitialDriveGears', 6)
                SetVehicleHandlingField(veh, 'CHandlingData', 'fClutchChangeRateScaleUpShift', 3.2000000476837)
            elseif IsVehicleModel(veh,defaultHash3) then --npolstang
                SetVehicleHandlingField(veh, 'CHandlingData', 'fInitialDriveMaxFlatVel', 180.0) --180.0
                SetVehicleHandlingField(veh, 'CHandlingData', 'fClutchChangeRateScaleUpShift', 4.0000000476837)
            elseif IsVehicleModel(veh,defaultHash4) then --polchar
                SetVehicleHandlingField(veh, 'CHandlingData', 'fInitialDriveMaxFlatVel', 180.0) --180.0
                SetVehicleHandlingField(veh, 'CHandlingData', 'nInitialDriveGears', 5)
            elseif IsVehicleModel(veh,defaultHash5) then --npolvic
                SetVehicleHandlingField(veh, 'CHandlingData', 'fInitialDriveMaxFlatVel', 175.0) --175.0
                SetVehicleHandlingField(veh, 'CHandlingData', 'nInitialDriveGears', 5)
            end
            SelectedPursuitMode = 0
        else
            MRFW.Functions.Notify('You are not in a HEAT vehicle', 'error', 3000)
        end
    end
end)
local mode = 0
local allow = true

RegisterCommand('Pursuit', function()
    local ped = PlayerPedId()
	local veh = GetVehiclePedIsIn(ped,false)
    if IsPedSittingInAnyVehicle(ped) and IsVehicleModel(veh,defaultHash) or IsVehicleModel(veh,defaultHash2) or IsVehicleModel(veh,defaultHash3) or IsVehicleModel(veh,defaultHash4) or IsVehicleModel(veh,defaultHash5) and PlayerData.metadata['pursuit'] then
        if InPursuitModeAPlus == false then 
            if (not IsPauseMenuActive()) then 
                if PlayerData.metadata['pursuit'] and allow then
                    allow = false
                    if mode == 0 then
                        mode = 1
                        TriggerEvent('police:Ghost:Pursuit:Mode:A') --1
                    elseif mode == 1 then
                        mode = 2
                        TriggerEvent('police:Ghost:Pursuit:B:Plus') --2
                    elseif mode == 2 then
                        mode = 3
                        TriggerEvent('police:Ghost:Pursuit:SPlusMode') --3
                    elseif mode == 3 then
                        mode = 0
                        TriggerEvent('police:pursuitmodeOff') --0
                    end
                    Citizen.Wait(15)
                    allow = true
                end
            end
        end
    end
end)

RegisterCommand('Pursuit2', function()
    local ped = PlayerPedId()
	local veh = GetVehiclePedIsIn(ped,false)
    if IsPedSittingInAnyVehicle(ped) and IsVehicleModel(veh,defaultHash) or IsVehicleModel(veh,defaultHash2) or IsVehicleModel(veh,defaultHash3) or IsVehicleModel(veh,defaultHash4) or IsVehicleModel(veh,defaultHash5) and PlayerData.metadata['pursuit'] then
        if InPursuitModeAPlus == false then 
            if (not IsPauseMenuActive()) then 
                if PlayerData.metadata['pursuit'] and allow then
                    allow = false
                    if mode == 0 then
                        mode = 3
                        TriggerEvent('police:Ghost:Pursuit:SPlusMode')
                    elseif mode == 3 then
                        mode = 2
                        TriggerEvent('police:Ghost:Pursuit:B:Plus')
                    elseif mode == 2 then
                        mode = 1
                        TriggerEvent('police:Ghost:Pursuit:Mode:A')
                    elseif mode == 1 then
                        mode = 0
                        TriggerEvent('police:pursuitmodeOff')
                    end
                    Citizen.Wait(15)
                    allow = true
                end
            end
        end
    end
end)

RegisterKeyMapping("Pursuit", "Pusuit Mode +", "keyboard", "")
RegisterKeyMapping("Pursuit2", "Pusuit Mode -", "keyboard", "")