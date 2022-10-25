CreateThread(function()

    exports['aj-eye']:AddTargetBone(Config.PetrolCanRefuelBones,{ 
        options = {
            { 
                type = "client",
                event = 'cc-fuel:client:petrolcanrefuel',
                label = 'Refuel Car', 
                icon = 'fas fa-gas-pump',
                item = 'weapon_petrolcan',
                canInteract = function(entity)
                    if GetVehicleEngineHealth(entity) <= 0 then return false end
                    if isFueling == false then
                        local curGasCanDurability = GetCurrentGasCanDurability()
                        if curGasCanDurability == nil then return false end
                        if curGasCanDurability > 0 then return true end
                        return false
                    end
                    return false
                end
            },
        },
        distance = 2.5,
    })
    
    exports['aj-eye']:AddTargetBone(Config.SiphonBones,{
        options = {
            {
                type="client",
                event="cc-fuel:client:siphonfuel",
                label = "Siphon Fuel",
                icon = 'fas fa-gas-pump',
                item = 'fuelsiphon',
                canInteract = function(entity)
                    if GetVehicleEngineHealth(entity) <= 0 then return false end
                    if isFueling then return false end
                    local curGasCanDurability = GetCurrentGasCanDurability()
                    if curGasCanDurability == nil then return false end
                    if curGasCanDurability >= 100 then return false end
                    
                    return Config.AllowFuelSiphoning
                end
            }
        },
        distance = 3.0,
    })
    
    exports['aj-eye']:AddTargetModel(Config.GasPumpModels, {
        options = {
            {
                icon = "fas fa-gas-pump",
                label = "Get Fuel",
                action = function(entity)
                    TriggerEvent("cc-fuel:client:pumprefuel", entity)
                end
            },
            {
                type = "client",
                event = "cc-fuel:client:buypetrolcan",
                icon =  "fas fa-gas-pump",
                label = "Buy Petrol Can"
            },
            {
                type = "client",
                event = "cc-fuel:client:refillpetrolcan",
                icon =  "fas fa-gas-pump",
                label = "Refuel Petrol Can"
            }
        },
        distance = 3.0
    })
end)

AddEventHandler('onResourceStop',function(name) 
    if (GetCurrentResourceName() ~= name) then return end
end)

function CreateBlip(coords)
	local blip = AddBlipForCoord(coords)
	SetBlipSprite(blip, 361)
	SetBlipScale(blip, 0.6)
	SetBlipColour(blip, 1)
	SetBlipDisplay(blip, 4)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Gas Station")
	EndTextCommandSetBlipName(blip)
	return blip
end


CreateThread(function()
	local currentGasBlip = 0
	while true do
		local coords = GetEntityCoords(PlayerPedId())
		local closest = 1000
		local closestCoords

		for _, gasStationCoords in pairs(Config.FuelStations) do
			local dstcheck = #(coords - gasStationCoords)
			if dstcheck < closest then
				closest = dstcheck
				closestCoords = gasStationCoords
			end
		end
		if DoesBlipExist(currentGasBlip) then
			RemoveBlip(currentGasBlip)
		end
		currentGasBlip = CreateBlip(closestCoords)
		Wait(10000)
	end
end)