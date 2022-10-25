local CurrentCops = 0

RegisterNetEvent('police:SetCopCount')
AddEventHandler('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

-- Code

RegisterNetEvent('mr-drugs:AddWeapons')
AddEventHandler('mr-drugs:AddWeapons', function()
    Config.Dealers[2]["products"][#Config.Dealers[2]["products"]+1] = {
        name = "weapon_snspistol",
        price = 5000,
        amount = 1,
        info = {
            serie = tostring(Config.RandomInt(2) .. Config.RandomStr(3) .. Config.RandomInt(1) .. Config.RandomStr(2) .. Config.RandomInt(3) .. Config.RandomStr(4))
        },
        type = "item",
        slot = 5,
        minrep = 200,
    }
    Config.Dealers[3]["products"][#Config.Dealers[3]["products"]+1] = {
        name = "weapon_snspistol",
        price = 5000,
        amount = 1,
        info = {
            serie = tostring(Config.RandomInt(2) .. Config.RandomStr(3) .. Config.RandomInt(1) .. Config.RandomStr(2) .. Config.RandomInt(3) .. Config.RandomStr(4))
        },
        type = "item",
        slot = 5,
        minrep = 200,
    }
end)

Citizen.CreateThread(function()
	while MRFW == nil do Wait(100) end
    MRFW.Functions.TriggerCallback('jacob:get:drugs', function(Drug_DeliveryLocations)
		Config.DeliveryLocations = Drug_DeliveryLocations
	end)
	while Config.DeliveryLocations == nil do Wait(100) end
end)