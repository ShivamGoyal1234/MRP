local density = {
    ['parked'] = 0.5,
    ['vehicle'] = 0.3,
    ['multiplier'] = 1.0,
    ['peds'] = 1.0,
    ['scenario'] = 1.0,
}

CreateThread(function()
	while true do
		SetParkedVehicleDensityMultiplierThisFrame(density['parked'])
		SetVehicleDensityMultiplierThisFrame(density['vehicle'])
		SetRandomVehicleDensityMultiplierThisFrame(density['multiplier'])
		SetPedDensityMultiplierThisFrame(density['peds'])
		SetScenarioPedDensityMultiplierThisFrame(density['scenario'], density['scenario']) -- Walking NPC Density
		SetPickupAmmoAmountScaler(0)
		SetPlayerHealthRechargeMultiplier(PlayerId(), 0)
		Wait(5)
	end
end)

CreateThread(function()
	while true do
		sleep = 200
		local veh = GetVehiclePedIsIn(PlayerPedId(), false)
		if DoesEntityExist(veh) and not IsEntityDead(veh) then
			if IsPedInAnyVehicle(PlayerPedId(), false) then
				sleep = 5
				local model = GetEntityModel(veh)
				if not IsThisModelABoat(model) and not IsThisModelAHeli(model) and not IsThisModelAPlane(model) and IsEntityInAir(veh) then
					DisableControlAction(0, 59)
                	DisableControlAction(0, 60)
				end
			end
		end
		Wait(sleep)
	end
end)
function DecorSet(Type, Value)
    if Type == 'parked' then
        density['parked'] = Value
    elseif Type == 'vehicle' then
        density['vehicle'] = Value
    elseif Type == 'multiplier' then
        density['multiplier'] = Value
    elseif Type == 'peds' then
        density['peds'] = Value
    elseif Type == 'scenario' then
        density['scenario'] = Value
    end
end

exports('DecorSet', DecorSet)