AJFW = exports['ajfw']:GetCoreObject()

RegisterNetEvent('aj-drivingschool:Payaj')
AddEventHandler('aj-drivingschool:Payaj', function()
	local src = source
    local xPlayer = AJFW.Functions.GetPlayer(src)
	local bankamount = xPlayer.PlayerData.money["bank"]
	local ghuu = 500

	if bankamount >= ghuu then
		xPlayer.Functions.RemoveMoney('bank', 500)
	end
end)

RegisterServerEvent('aj-drivingschool:server:GetLicense')
AddEventHandler('aj-drivingschool:server:GetLicense', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)


    local info = {}
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.gender = Player.PlayerData.charinfo.gender
        info.type = "A1-A2-A | AM-B | C1-C-CE"

    local licenseTable = Player.PlayerData.metadata["licences"]
    licenseTable["driver"] = true
    Player.Functions.SetMetaData("licences", licenseTable)
    Player.Functions.AddItem('driver_license', 1, nil, info)

    TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items['driver_license'], 'add')
end)

