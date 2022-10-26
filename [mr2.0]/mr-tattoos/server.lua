MRFW = exports['mrfw']:GetCoreObject()

MRFW.Functions.CreateCallback('mr-tattoos:GetPlayerTattoos', function(source, cb)
	local src = source
	local xPlayer = MRFW.Functions.GetPlayer(src)

	if xPlayer then
		local db = MySQL.Sync.fetchAll('SELECT tattoos FROM players WHERE citizenid = ?', {xPlayer.PlayerData.citizenid})
    	if db ~= nil then
			if db[1] ~= nil then
				if db[1].tattoos then
					cb(json.decode(db[1].tattoos))
				else
					cb()
				end
			end
		end
	else
		cb()
	end
end)

MRFW.Functions.CreateCallback('mr-tattoos:GetPlayerTattoosMC', function(source, cb, citizenid)
	local src = source
	local xPlayer = MRFW.Functions.GetPlayer(src)
	local db = MySQL.Sync.fetchAll('SELECT tattoos FROM players WHERE citizenid = ?', {citizenid})
    if db ~= nil then
		if db[1].tattoos then
			cb(json.decode(db[1].tattoos))
		else
			cb()
		end
	end
end)

MRFW.Functions.CreateCallback('mr-tattoos:PurchaseTattoo', function(source, cb, tattooList, price, tattoo, tattooName)
	local src = source
	local xPlayer = MRFW.Functions.GetPlayer(src)

	if xPlayer.PlayerData.money.cash >= price then
		xPlayer.Functions.RemoveMoney('cash', price, "tattoo-shop")
		table.insert(tattooList, tattoo)
		
		MySQL.Async.execute('UPDATE players SET tattoos = ? WHERE citizenid = ?', {json.encode(tattooList), xPlayer.PlayerData.citizenid})

		TriggerClientEvent('MRFW:Notify', src, "You have the tattoo " .. tattooName .. " bought for $" .. price, 'success', 3500)
		Wait(100)
		local db = MySQL.Sync.fetchAll('SELECT tattoos FROM players WHERE citizenid = ?', {xPlayer.PlayerData.citizenid})
		if db ~= nil then
			if db[1].tattoos then
				TriggerClientEvent('mr-tattoos:update', src, json.decode(db[1].tattoos))
			end
		end
		cb(true)
	elseif xPlayer.PlayerData.money.bank >= price then
		xPlayer.Functions.RemoveMoney('bank', price, "tattoo-shop")
		table.insert(tattooList, tattoo)
		MySQL.Async.execute('UPDATE players SET tattoos = ? WHERE citizenid = ?', {json.encode(tattooList), xPlayer.PlayerData.citizenid})

		TriggerClientEvent('MRFW:Notify', src, "You have the tattoo " .. tattooName .. " bought for $" .. price, 'success', 3500)
		Wait(100)
		local db = MySQL.Sync.fetchAll('SELECT tattoos FROM players WHERE citizenid = ?', {xPlayer.PlayerData.citizenid})
		if db ~= nil then
			if db[1].tattoos then
				TriggerClientEvent('mr-tattoos:update', src, json.decode(db[1].tattoos))
			end
		end
		cb(true)
	else
		TriggerClientEvent('MRFW:Notify', src, 'You dont have enough money for this tattoo.', 'error', 3500)
		cb(false)
	end
end)

RegisterServerEvent('mr-tattoos:RemoveTattoo')
AddEventHandler('mr-tattoos:RemoveTattoo', function (tattooList)
	local src = source
	local xPlayer = MRFW.Functions.GetPlayer(src)
	MySQL.Async.execute('UPDATE players SET tattoos = ? WHERE citizenid = ?', {json.encode(tattooList), xPlayer.PlayerData.citizenid})
	Wait(100)
	local db = MySQL.Sync.fetchAll('SELECT tattoos FROM players WHERE citizenid = ?', {xPlayer.PlayerData.citizenid})
	if db ~= nil then
		if db[1].tattoos then
			TriggerClientEvent('mr-tattoos:update', src, json.decode(db[1].tattoos))
		end
	end
end)