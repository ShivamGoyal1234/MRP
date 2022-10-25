local AJFW = exports['ajfw']:GetCoreObject()

local function cv(amount)
    local formatted = amount
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k==0) then
            break
        end
    end
    return formatted
end


---- BANK STUFF
RegisterServerEvent('jim-payments:server:ATM:use', function(amount, billtype, baccount, account, society, gsociety)
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)
	local cashB = Player.Functions.GetMoney("cash")
	local bankB = Player.Functions.GetMoney("bank")
	local amount = tonumber(amount)
			--TriggerClientEvent("AJFW:Notify", src, tostring(account), "error")

	--Simple transfers from bank to wallet --
	if account == "bank" or account == "atm" then
		if billtype == "withdraw" then
			if bankB < amount then TriggerClientEvent("AJFW:Notify", src, "Bank Balance too low", "error")
			elseif bankB >= tonumber(amount) then
				TriggerClientEvent("AJFW:Notify", src, "Withdrew $"..cv(amount).." from the bank", "success") -- Don't really need this as phone gets notified when money is withdrawn
				Player.Functions.RemoveMoney('bank', amount) Wait(1500)
				Player.Functions.AddMoney('cash', amount)
			end
		elseif billtype == "deposit" then
			if cashB < amount then TriggerClientEvent("AJFW:Notify", src, "Not enough cash", "error")
			elseif cashB >= amount then
				Player.Functions.RemoveMoney('cash', amount) Wait(1500)
				Player.Functions.AddMoney('bank', amount)
				TriggerClientEvent("AJFW:Notify", src, "Deposited $"..cv(amount).." into the Bank", "success")
			end
		end
	-- Transfers from bank to savings account --
	elseif account == "savings" then
		local getSavingsAccount = MySQL.Sync.fetchAll('SELECT * FROM bank_accounts WHERE citizenid = ? AND account_type = ?', { Player.PlayerData.citizenid, 'Savings' })
		if getSavingsAccount[1] ~= nil then savbal = tonumber(getSavingsAccount[1].amount) aid = getSavingsAccount[1].record_id end
		
		if billtype == "withdraw" then
			if savbal >= amount then
				savbal = savbal - amount
				Player.Functions.AddMoney('bank', amount)
				TriggerClientEvent("AJFW:Notify", src, "$"..cv(amount).." Withdrawn from savings into bank account", "success")
				MySQL.Async.execute('UPDATE bank_accounts SET amount = ? WHERE citizenid = ? AND record_id = ?', { savbal, Player.PlayerData.citizenid, getSavingsAccount[1].record_id }, function(success)
					if success then	return true	else return false end
				end)
			elseif savbal < amount then
				TriggerClientEvent("AJFW:Notify", src, "Savings Balance too low", "error")
			end
		elseif billtype == "deposit" then
			if amount < bankB then
				savbal = savbal + amount
				Player.Functions.RemoveMoney('bank', amount) 
				TriggerClientEvent("AJFW:Notify", src, "$"..cv(amount).." Deposited from bank account into savings", "success")
				MySQL.Async.execute('UPDATE bank_accounts SET amount = ? WHERE citizenid = ? AND record_id = ?', { savbal, Player.PlayerData.citizenid, getSavingsAccount[1].record_id }, function(success)
					if success then	return true	else return false end
				end)
			else TriggerClientEvent("AJFW:Notify", src, "Bank Balance too low", "error")
			end
		end
	--Simple transfers from society account to bank --
	elseif account == "society" then
		if billtype == "withdraw" then
			if tonumber(society) < amount then TriggerClientEvent("AJFW:Notify", src, "Society balance too low", "error")
			elseif tonumber(society) >= amount then
				TriggerClientEvent("AJFW:Notify", src, "Withdrew $"..cv(amount).." from the "..Player.PlayerData.job.label.." account", "success")
				Player.Functions.AddMoney('bank', amount)
				TriggerEvent("aj-bossmenu:server:removeAccountMoney", tostring(Player.PlayerData.job.name), amount)
			end
		elseif billtype == "deposit" then
			if bankB < amount then TriggerClientEvent("AJFW:Notify", src, "Not enough money in your bank", "error")
			elseif bankB >= amount then
				TriggerEvent("aj-bossmenu:server:addAccountMoney", tostring(Player.PlayerData.job.name), amount)
				Player.Functions.RemoveMoney('bank', amount) Wait(1500)
				TriggerClientEvent("AJFW:Notify", src, "Deposited $"..cv(amount).." into the "..Player.PlayerData.job.label.." account", "success")
			end
		end
	-- Transfer from boss account to players --
	elseif account == "societytransfer" then
		local bannedCharacters = {'%','$',';'}
		local newAmount = tostring(amount)
		local newiban = tostring(baccount)
		for k, v in pairs(bannedCharacters) do
			newAmount = string.gsub(newAmount, '%' .. v, '')
			newiban = string.gsub(newiban, '%' .. v, '')
		end
		baccount = newiban
		amount = tonumber(newAmount)
		
		local Player = AJFW.Functions.GetPlayer(src)
		if (society - amount) >= 0 then
			local query = '%"account":"' .. baccount .. '"%'
			local result = MySQL.Sync.fetchAll('SELECT * FROM players WHERE charinfo LIKE ?', {query})
			if result[1] ~= nil then
				local Reciever = AJFW.Functions.GetPlayerByCitizenId(result[1].citizenid)
				TriggerEvent("aj-bossmenu:server:removeAccountMoney", tostring(Player.PlayerData.job.name), amount)
				if Reciever ~= nil then
					Reciever.Functions.AddMoney('bank', amount)
					TriggerClientEvent("AJFW:Notify", src, "Sent $"..amount.." to "..Reciever.PlayerData.charinfo.firstname.." "..Reciever.PlayerData.charinfo.lastname, "success")
					TriggerClientEvent("AJFW:Notify", Reciever.PlayerData.source, "Recieved $"..cv(amount).." from "..tostring(Player.PlayerData.job.label).." account", "success")
				else
					local RecieverMoney = json.decode(result[1].money)
					RecieverMoney.bank = (RecieverMoney.bank + amount)
					MySQL.Async.execute('UPDATE players SET money = ? WHERE citizenid = ?', {json.encode(RecieverMoney), result[1].citizenid})
				end
			elseif result[1] == nil then TriggerClientEvent("AJFW:Notify", src, "Error: Account '"..baccount.."' not found", "error")
			end
		end
	
	--Simple transfers from gang society account to bank --
	elseif account == "gang" then
		if billtype == "withdraw" then
			if tonumber(gsociety) < amount then TriggerClientEvent("AJFW:Notify", src, "Society balance too low", "error")
			elseif tonumber(gsociety) >= amount then
				TriggerClientEvent("AJFW:Notify", src, "Withdrew $"..cv(amount).." from the "..Player.PlayerData.gang.label.." account", "success")
				Player.Functions.AddMoney('bank', amount)
				TriggerEvent("aj-gangmenu:server:removeAccountMoney", tostring(Player.PlayerData.gang.name), amount)
			end
		elseif billtype == "deposit" then
			if bankB < amount then TriggerClientEvent("AJFW:Notify", src, "Not enough money in your bank", "error")
			elseif bankB >= amount then
				TriggerEvent("aj-gangmenu:server:addAccountMoney", tostring(Player.PlayerData.gang.name), amount)
				Player.Functions.RemoveMoney('bank', amount) Wait(1500)
				TriggerClientEvent("AJFW:Notify", src, "Deposited $"..cv(amount).." into the "..Player.PlayerData.gang.label.." account", "success")
			end
		end
	-- Transfer from gang account to players --
	elseif account == "gangtransfer" then
		local bannedCharacters = {'%','$',';'}
		local newAmount = tostring(amount)
		local newiban = tostring(baccount)
		for k, v in pairs(bannedCharacters) do
			newAmount = string.gsub(newAmount, '%' .. v, '')
			newiban = string.gsub(newiban, '%' .. v, '')
		end
		baccount = newiban
		amount = tonumber(newAmount)
		
		local Player = AJFW.Functions.GetPlayer(src)
		if (gsociety - amount) >= 0 then
			local query = '%"account":"' .. baccount .. '"%'
			local result = MySQL.Sync.fetchAll('SELECT * FROM players WHERE charinfo LIKE ?', {query})
			if result[1] ~= nil then
				local Reciever = AJFW.Functions.GetPlayerByCitizenId(result[1].citizenid)
				TriggerEvent("aj-bossmenu:server:removeAccountMoney", tostring(Player.PlayerData.gang.name), amount)
				if Reciever ~= nil then
					Reciever.Functions.AddMoney('bank', amount)
					TriggerClientEvent("AJFW:Notify", src, "Sent $"..amount.." to "..Reciever.PlayerData.charinfo.firstname.." "..Reciever.PlayerData.charinfo.lastname, "success")
					TriggerClientEvent("AJFW:Notify", Reciever.PlayerData.source, "Recieved $"..cv(amount).." from "..tostring(Player.PlayerData.gang.label).." account", "success")
				else
					local RecieverMoney = json.decode(result[1].money)
					RecieverMoney.bank = (RecieverMoney.bank + amount)
					MySQL.Async.execute('UPDATE players SET money = ? WHERE citizenid = ?', {json.encode(RecieverMoney), result[1].citizenid})
				end
			elseif result[1] == nil then TriggerClientEvent("AJFW:Notify", src, "Error: Account '"..baccount.."' not found", "error")

			end
		end
	
	elseif account == "transfer" then
	
		local bannedCharacters = {'%','$',';'}
		local newAmount = tostring(amount)
		local newiban = tostring(baccount)
		for k, v in pairs(bannedCharacters) do
			newAmount = string.gsub(newAmount, '%' .. v, '')
			newiban = string.gsub(newiban, '%' .. v, '')
		end
		baccount = newiban
		amount = tonumber(newAmount)
		
		local Player = AJFW.Functions.GetPlayer(src)
		if (Player.PlayerData.money.bank - amount) >= 0 then
			local query = '%"account":"' .. baccount .. '"%'
			local result = MySQL.Sync.fetchAll('SELECT * FROM players WHERE charinfo LIKE ?', {query})
			if result[1] ~= nil then
				local Reciever = AJFW.Functions.GetPlayerByCitizenId(result[1].citizenid)
				Player.Functions.RemoveMoney('bank', amount)
				if Reciever ~= nil then
					Reciever.Functions.AddMoney('bank', amount)
					TriggerClientEvent("AJFW:Notify", src, "Sent $"..cv(amount).." to "..Reciever.PlayerData.charinfo.firstname.." "..Reciever.PlayerData.charinfo.lastname, "success")
					TriggerClientEvent("AJFW:Notify", Reciever.PlayerData.source, "Recieved $"..cv(amount).." from "..Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname, "success")
				else
					local RecieverMoney = json.decode(result[1].money)
					RecieverMoney.bank = (RecieverMoney.bank + amount)
					MySQL.Async.execute('UPDATE players SET money = ? WHERE citizenid = ?', {json.encode(RecieverMoney), result[1].citizenid})
				end
			elseif result[1] == nil then TriggerClientEvent("AJFW:Notify", src, "Error: Account '"..baccount.."' not found", "error")

			end
		end
	end	
end)

AJFW.Functions.CreateCallback('jim-payments:ATM:Find', function(source, cb)
	local Player = AJFW.Functions.GetPlayer(source)
	local name = Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname
	local cid = Player.PlayerData.citizenid.." ["..source.."]"
	local cash = Player.Functions.GetMoney("cash")
	local bank = Player.Functions.GetMoney("bank")
	local account = Player.PlayerData.charinfo.account
	
	local getSavingsAccount = MySQL.Sync.fetchAll('SELECT * FROM bank_accounts WHERE citizenid = ? AND account_type = ?', { Player.PlayerData.citizenid, 'Savings' })
    if getSavingsAccount[1] ~= nil then
        aid = getSavingsAccount[1].record_id
        savbal = getSavingsAccount[1].amount
	else 
		MySQL.Async.insert('INSERT INTO bank_accounts (citizenid, amount, account_type) VALUES (?, ?, ?)', { Player.PlayerData.citizenid, 0, 'Savings' }, function() completed = true end) repeat Wait(0) until completed == true
		aid = getSavingsAccount[1].record_id
		savbal = getSavingsAccount[1].amount
    end
	
	cb(name, cash, bank, account, cid, savbal, aid) 
end)

AJFW.Commands.Add("cashgive", "Pay a user nearby", {}, false, function(source) TriggerClientEvent("jim-payments:client:ATM:give", source) end)

RegisterServerEvent("jim-payments:server:ATM:give", function(citizen, price)
    local Player = AJFW.Functions.GetPlayer(source)
    local Reciever = AJFW.Functions.GetPlayer(tonumber(citizen))
    local amount = tonumber(price)
	local balance = Player.Functions.GetMoney("cash")
	
	if amount and amount > 0 then
		if balance >= amount then
			Player.Functions.RemoveMoney('cash', amount)
			TriggerClientEvent("AJFW:Notify", source, "You gave "..Reciever.PlayerData.charinfo.firstname.." $"..cv(amount), "success")
			Reciever.Functions.AddMoney('cash', amount)
			TriggerClientEvent("AJFW:Notify", tonumber(citizen), "You got $"..cv(amount).." from "..Player.PlayerData.charinfo.firstname, "success")
		elseif balance < amount then
			TriggerClientEvent("AJFW:Notify", source, "You don't have enough cash to give", "error")
		end
	else TriggerClientEvent('AJFW:Notify', source, "You can't give $0", 'error') end
end)