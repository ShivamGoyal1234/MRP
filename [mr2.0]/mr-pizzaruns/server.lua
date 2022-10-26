RegisterServerEvent('mr-pizzaruns:Payment')
AddEventHandler('mr-pizzaruns:Payment', function()
	local _source = source
	local Player = MRFW.Functions.GetPlayer(_source)
    Player.Functions.AddMoney("cash", 100, "sold-pizza")
    TriggerClientEvent("MRFW:Notify", _source, "You recieved $100", "success")
end)

RegisterServerEvent('mr-pizzaruns:TakeDeposit')
AddEventHandler('mr-pizzaruns:TakeDeposit', function()
	local _source = source
	local Player = MRFW.Functions.GetPlayer(_source)
    Player.Functions.RemoveMoney("bank", 200, _source, "pizza-deposit")
    TriggerClientEvent("MRFW:Notify", _source, "You were charged a deposit of $200", "error")
end)

RegisterServerEvent('mr-pizzaruns:ReturnDeposit')
AddEventHandler('mr-pizzaruns:ReturnDeposit', function(info)
	local _source = source
    local Player = MRFW.Functions.GetPlayer(_source)
    
    if info == 'cancel' then
        Player.Functions.AddMoney("cash", 0, "pizza-return-vehicle")
        TriggerClientEvent("MRFW:Notify", _source, "You returned the vehicle.", "success")
    elseif info == 'end' then
        Player.Functions.AddMoney("cash", 200, "pizza-return-vehicle")
        TriggerClientEvent("MRFW:Notify", _source, "You returned the vehicle.", "success")
    end
end)

RegisterNetEvent("mr-pizzaruns:items")
AddEventHandler("mr-pizzaruns:items", function(item, count)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local luck1 = math.random(1, 100)
    local itemFound1 = true
    local itemCount1 = 1

    if itemFound1 then
        for i = 1, itemCount1, 1 do
            local randomItem
            local itemInfo
            if luck1 > 90 and luck1 <= 100 then
                randomItem = "bluechip"
                itemInfo = MRFW.Shared.Items[randomItem]
               
                Player.Functions.AddItem(randomItem, 1)
                TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "add")
               
			elseif luck1 > 87 and luck1 <= 90 then
				randomItem = "labkey5"
				itemInfo = MRFW.Shared.Items[randomItem]
                
                Player.Functions.AddItem(randomItem, 1)
                TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "add")
            elseif luck1 > 73 and luck1 <= 85 then
				randomItem = "empty_bag"
				itemInfo = MRFW.Shared.Items[randomItem]
                
                Player.Functions.AddItem(randomItem, 1)
                TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "add")
                
			elseif luck1 > 53 and luck1 <= 60 then
                local blackamount = math.random(20,30) 
				randomItem = "blackmoney"
				itemInfo = MRFW.Shared.Items[randomItem]
                
                Player.Functions.AddItem(randomItem, blackamount)
                TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "add", blackamount)

            elseif luck1 > 25 and luck1 <= 45 then
                TriggerClientEvent('MRFW:Notify', src, "कुछ नहीं मिलेगा , निकल पहली फुर्सत में" , "error", 5000)
                
			elseif luck1 > 10 and luck1 <= 25 then
				TriggerClientEvent('MRFW:Notify', src, "कुछ नहीं मिलेगा , निकल पहली फुर्सत में" , "error", 5000)
                
            elseif luck1 <= 10 then
                TriggerClientEvent('MRFW:Notify', src, "कुछ नहीं मिलेगा , निकल पहली फुर्सत में" , "error", 5000)
                
            end
            Citizen.Wait(500)
        end
    end
end)

-----------------------------mr--------------------------------------