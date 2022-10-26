

local MRFW = exports['mrfw']:GetCoreObject()

local ItemTable = {
    "metalscrap",
    "plastic",
    "copper",
    "iron",
    "aluminum",
    "steel",
    "glass",
    "rubber",
}

--- Event For Getting Recyclable Material----

RegisterServerEvent("jim-recycle:getrecyclablematerial")
AddEventHandler("jim-recycle:getrecyclablematerial", function()
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local amount = math.random(5, 10)
    Player.Functions.AddItem("recyclablematerial", amount, false, {["quality"] = nil})
    TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items["recyclablematerial"], 'add', amount)
    Citizen.Wait(500)

	local chance = math.random(1, 100)
    if chance < 7 then
        Player.Functions.AddItem("cryptostick", 1, false)
        TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items["cryptostick"], "add")
    end
end)

--------------------------------------------------

---- Trade Event Starts Over Here ------

RegisterServerEvent("jim-recycle:TradeItems")
AddEventHandler("jim-recycle:TradeItems", function(data)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
	local randItem = ""
	local amount = 0
	if data == 1 then
		if Player.Functions.GetItemByName('recyclablematerial') ~= nil and Player.Functions.GetItemByName('recyclablematerial').amount >= 1 then
			Player.Functions.RemoveItem("recyclablematerial", 1)
			TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items["recyclablematerial"], 'remove', 1)
			Citizen.Wait(1000)
			randItem = ItemTable[math.random(1, #ItemTable)]
			amount = math.random(Config.onemin, Config.onemax)
			Player.Functions.AddItem(randItem, amount, false, {["quality"] = nil})
			TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items[randItem], 'add', amount)
			else
				TriggerClientEvent('MRFW:Notify', src, "You Don't Have Enough Items")
			end
	elseif data == 2 then
		if Player.Functions.GetItemByName('recyclablematerial') ~= nil and Player.Functions.GetItemByName('recyclablematerial').amount >= 10 then
			Player.Functions.RemoveItem("recyclablematerial", 10)
			TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items["recyclablematerial"], 'remove', 10)
			Citizen.Wait(1000)
			randItem = ItemTable[math.random(1, #ItemTable)]
			amount = math.random(Config.tenmin, Config.tenmax)
			Player.Functions.AddItem(randItem, amount, false, {["quality"] = nil})
			TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items[randItem], 'add', amount)
			randItem = ItemTable[math.random(1, #ItemTable)]
			amount = math.random(Config.tenmin, Config.tenmax)
			Citizen.Wait(1000)
			Player.Functions.AddItem(randItem, amount, false, {["quality"] = nil})
			TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items[randItem], 'add', amount)
			randItem = ItemTable[math.random(1, #ItemTable)]
			amount = math.random(Config.tenmin, Config.tenmax)
			Citizen.Wait(1000)
			Player.Functions.AddItem(randItem, amount, false, {["quality"] = nil})
			TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items[randItem], 'add', amount)
			else
				TriggerClientEvent('MRFW:Notify', src, "You Don't Have Enough Items")
			end
	elseif data == 3 then
		if Player.Functions.GetItemByName('recyclablematerial') ~= nil and Player.Functions.GetItemByName('recyclablematerial').amount >= 100 then
			Player.Functions.RemoveItem("recyclablematerial", "100")
			TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items["recyclablematerial"], 'remove', 100)
			Citizen.Wait(1000)

			randItem = ItemTable[math.random(1, #ItemTable)]
			amount = math.random(Config.bulkmin, Config.bulkmax)
			Player.Functions.AddItem(randItem, amount, false, {["quality"] = nil})
			TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items[randItem], 'add', amount)
			Citizen.Wait(1000) 

			randItem = ItemTable[math.random(1, #ItemTable)]
			amount = math.random(Config.bulkmin, Config.bulkmax)
			Player.Functions.AddItem(randItem, amount, false, {["quality"] = nil})
			TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items[randItem], 'add', amount)
			Citizen.Wait(1000)

			randItem = ItemTable[math.random(1, #ItemTable)]
			amount = math.random(Config.bulkmin, Config.bulkmax)
			Player.Functions.AddItem(randItem, amount, false, {["quality"] = nil})
			TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items[randItem], 'add', amount)
			Citizen.Wait(1000)

			randItem = ItemTable[math.random(1, #ItemTable)]
			amount = math.random(Config.bulkmin, Config.bulkmax)
			Player.Functions.AddItem(randItem, amount, false, {["quality"] = nil})
			TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items[randItem], 'add', amount)
			Citizen.Wait(1000)

			randItem = ItemTable[math.random(1, #ItemTable)]
			amount = math.random(Config.bulkmin, Config.bulkmax)
			Player.Functions.AddItem(randItem, amount, false, {["quality"] = nil})
			TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items[randItem], 'add', amount)
			Citizen.Wait(1000)

			randItem = ItemTable[math.random(1, #ItemTable)]
			amount = math.random(Config.bulkmin, Config.bulkmax)       
			Player.Functions.AddItem(randItem, amount, false, {["quality"] = nil})
			TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items[randItem], 'add', amount)
			Citizen.Wait(1000)
			
			randItem = ItemTable[math.random(1, #ItemTable)]
			amount = math.random(Config.bulkmin, Config.bulkmax)
			Player.Functions.AddItem(randItem, amount, false, {["quality"] = nil})
			TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items[randItem], 'add', amount)
			Citizen.Wait(1000)

			randItem = ItemTable[math.random(1, #ItemTable)]
			amount = math.random(Config.bulkmin, Config.bulkmax)
			Player.Functions.AddItem(randItem, amount, false, {["quality"] = nil})
			TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items[randItem], 'add', amount)
			Citizen.Wait(1000)

			local chance = math.random(1, 100)
    		if chance < 50 then
				Player.Functions.AddItem("wire", 6, false)
				TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items["wire"], "add", 6)
			end
		else
			TriggerClientEvent('MRFW:Notify', src, "You Do Not Have Enough Items")
		end
    end
end)

---- Trade Event End Over Here ------

RegisterServerEvent("jim-recycle:Selling:All")
AddEventHandler("jim-recycle:Selling:All", function()
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local payment = 0
	for k, v in pairs(Config.Prices) do
        if Player.Functions.GetItemByName(v.name) ~= nil then
            copper = Player.Functions.GetItemByName(v.name).amount
            pay = (copper * v.amount)
            Player.Functions.RemoveItem(v.name, copper)
            Player.Functions.AddMoney('cash', pay)
            TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items[v.name], 'remove', copper)
        payment = payment + pay
        end
    end
    Citizen.Wait(500)
	TriggerClientEvent("MRFW:Notify", src, "Total: $"..payment, 'success')
end)

RegisterNetEvent("jim-recycle:Selling:Mat")
AddEventHandler("jim-recycle:Selling:Mat", function(data)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)

    if Player.Functions.GetItemByName(data) ~= nil then
        local amount = Player.Functions.GetItemByName(data).amount
        local pay = (amount * Config.Prices[data].amount)
        Player.Functions.RemoveItem(data, amount)
        Player.Functions.AddMoney('cash', pay)
        TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items[data], 'remove', amount)
        TriggerClientEvent("MRFW:Notify", src, "Payment received", "Total: $"..pay, "error")
    else
        TriggerClientEvent("MRFW:Notify", src, "You don't have any "..MRFW.Shared.Items[data].label.. "", "error")
    end
    Citizen.Wait(1000)
end)


RegisterServerEvent('jim-recycle:Dumpsters:Reward')
AddEventHandler('jim-recycle:Dumpsters:Reward', function(listKey)
    local src = source 
    local Player = MRFW.Functions.GetPlayer(src)
	local chance = math.random(1, 100)
	-- print(chance)
    if chance < 50 then
        for i = 1, math.random(1, 2), 1 do
            local item = Config.DumpItems[math.random(1, #Config.DumpItems)]
            local amount = math.random(1, 2)
            Player.Functions.AddItem(item, amount, false, {["quality"] = nil})
            TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items[item], 'add', amount)
            Citizen.Wait(500)
        end
	else
		TriggerClientEvent("MRFW:Notify", src, "No item found", "error")
	end
end)
