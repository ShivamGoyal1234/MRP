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

AJFW.Commands.Add("cashregister", "Use mobile cash register", {}, false, function(source, data) 
    local Player = AJFW.Functions.GetPlayer(source)
	if Player.PlayerData.job.name == "mcd" or Player.PlayerData.job.name == "catcafe" or Player.PlayerData.job.name == "shopone" then
		TriggerClientEvent("jim-payments:client:Charge", source, data, true) 
	else
        TriggerClientEvent('AJFW:Notify', source, 'You are not authorized', 'error')
    end
end)

RegisterServerEvent('jim-payments:Tickets:Give', function(amount, job)
	if Config.TicketSystem then
		for k, v in pairs(AJFW.Functions.GetPlayers()) do
			local Player = AJFW.Functions.GetPlayer(v)
			if Player ~= nil then
				if Player.PlayerData.job.name == job and Player.PlayerData.job.onduty then
					if amount >= Config.Jobs[job].MinAmountforTicket then
						Player.Functions.AddItem('payticket', 1, false, {["quality"] = nil})
						TriggerClientEvent('AJFW:Notify', Player.PlayerData.source, 'Receipt received', 'success')
						TriggerClientEvent('inventory:client:ItemBox', Player.PlayerData.source, AJFW.Shared.Items['payticket'], "add", 1) 
					elseif amount < Config.Jobs[job].MinAmountforTicket then
						TriggerClientEvent("AJFW:Notify", Player.PlayerData.source, "Amount too low, didn't receive a receipt", "error")
					end
				end
			end
		end
	end
end)

RegisterServerEvent('jim-payments:Tickets:Sell', function()
    local Player = AJFW.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName("payticket") == nil then TriggerClientEvent('AJFW:Notify', source, "No tickets to trade", 'error') return
	else
		tickets = Player.Functions.GetItemByName("payticket").amount
		Player.Functions.RemoveItem('payticket', tickets)
		pay = (tickets * Config.Jobs[Player.PlayerData.job.name].PayPerTicket)
		Player.Functions.AddMoney('bank', pay, 'ticket-payment')
		TriggerClientEvent('inventory:client:ItemBox', source, AJFW.Shared.Items['payticket'], "remove", tickets)
		TriggerClientEvent('AJFW:Notify', source, "Tickets traded: "..tickets.." Total: $"..cv(pay), 'success')
	end
end)

AJFW.Functions.CreateCallback('jim-payments:Ticket:Count', function(source, cb) 
	if AJFW.Functions.GetPlayer(source).Functions.GetItemByName('payticket') == nil then amount = 0
	else amount = AJFW.Functions.GetPlayer(source).Functions.GetItemByName('payticket').amount end 
	cb(amount) 
end)

RegisterServerEvent("jim-payments:server:Charge", function(citizen, price, billtype)
    local src = source
	local biller = AJFW.Functions.GetPlayer(src)
    local billed = AJFW.Functions.GetPlayer(tonumber(citizen))
    local amount = tonumber(price)

	if amount and amount > 0 then
		if billtype == "cash" then balance = billed.Functions.GetMoney(billtype)
			if balance >= amount then
				TriggerClientEvent("jim-payments:client:PayPopup", billed.PlayerData.source, amount, src, billtype)
			elseif balance < amount then
				TriggerClientEvent("AJFW:Notify", src, "Customer doesn't have enough cash to pay", "error")
				TriggerClientEvent("AJFW:Notify", tonumber(citizen), "You don't have enough cash to pay", "error")
			end
		elseif billtype == "card" then
			if Config.PhoneBank == false then
				TriggerClientEvent("jim-payments:client:PayPopup", billed.PlayerData.source, amount, src, billtype)
			else
				MySQL.Async.insert(
					'INSERT INTO phone_invoices (citizenid, amount, society, sender, sendercitizenid) VALUES (?, ?, ?, ?, ?)',
					{billed.PlayerData.citizenid, amount, biller.PlayerData.job.name, biller.PlayerData.charinfo.firstname, biller.PlayerData.citizenid})
				TriggerClientEvent('aj-phone:RefreshPhone', billed.PlayerData.source)
				TriggerClientEvent('AJFW:Notify', src, 'Invoice Successfully Sent', 'success')
				TriggerClientEvent('AJFW:Notify', billed.PlayerData.source, 'New Invoice Received')
			end
		end
	else TriggerClientEvent('AJFW:Notify', source, "You can't charge $0", 'error') return end
end)

RegisterServerEvent("jim-payments:server:PayPopup", function(data)
	local src = source
	local billtype = data.billtype
	local billed = AJFW.Functions.GetPlayer(src)
	local biller = AJFW.Functions.GetPlayer(tonumber(data.biller))
		if billtype == "card" then billtype = "bank" end
	if data.accept == true then
		billed.Functions.RemoveMoney(tostring(billtype), data.amount) 
		TriggerEvent("aj-bossmenu:server:addAccountMoney", tostring(biller.PlayerData.job.name), data.amount)
		TriggerEvent('jim-payments:Tickets:Give', data.amount, tostring(biller.PlayerData.job.name))
		TriggerClientEvent("AJFW:Notify", data.biller, billed.PlayerData.charinfo.firstname.." accepted the payment", "success")
	elseif data.accept == false then
		TriggerClientEvent("AJFW:Notify", src, "You declined the payment")
		TriggerClientEvent("AJFW:Notify", data.biller, billed.PlayerData.charinfo.firstname.." declined the payment", "error")
	end
end)

AJFW.Functions.CreateCallback('jim-payments:MakePlayerList', function(source, cb)
	local onlineList = {}
	for k, v in pairs(AJFW.Functions.GetPlayers()) do
		local P = AJFW.Functions.GetPlayer(v)
		onlineList[#onlineList+1] = { value = tonumber(v), text = "["..v.."] - "..P.PlayerData.charinfo.firstname..' '..P.PlayerData.charinfo.lastname  }
	end
	cb(onlineList) 
end)