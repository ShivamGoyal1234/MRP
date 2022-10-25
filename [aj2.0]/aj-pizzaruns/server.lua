RegisterServerEvent('aj-pizzaruns:Payment')
AddEventHandler('aj-pizzaruns:Payment', function()
	local _source = source
	local Player = AJFW.Functions.GetPlayer(_source)
    Player.Functions.AddMoney("cash", 100, "sold-pizza")
    TriggerClientEvent("AJFW:Notify", _source, "You recieved $100", "success")
end)

RegisterServerEvent('aj-pizzaruns:TakeDeposit')
AddEventHandler('aj-pizzaruns:TakeDeposit', function()
	local _source = source
	local Player = AJFW.Functions.GetPlayer(_source)
    Player.Functions.RemoveMoney("bank", 200, _source, "pizza-deposit")
    TriggerClientEvent("AJFW:Notify", _source, "You were charged a deposit of $200", "error")
end)

RegisterServerEvent('aj-pizzaruns:ReturnDeposit')
AddEventHandler('aj-pizzaruns:ReturnDeposit', function(info)
	local _source = source
    local Player = AJFW.Functions.GetPlayer(_source)
    
    if info == 'cancel' then
        Player.Functions.AddMoney("cash", 0, "pizza-return-vehicle")
        TriggerClientEvent("AJFW:Notify", _source, "You returned the vehicle.", "success")
    elseif info == 'end' then
        Player.Functions.AddMoney("cash", 200, "pizza-return-vehicle")
        TriggerClientEvent("AJFW:Notify", _source, "You returned the vehicle.", "success")
    end
end)

RegisterNetEvent("aj-pizzaruns:items")
AddEventHandler("aj-pizzaruns:items", function(item, count)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local luck1 = math.random(1, 100)
    local itemFound1 = true
    local itemCount1 = 1

    if itemFound1 then
        for i = 1, itemCount1, 1 do
            local randomItem
            local itemInfo
            if luck1 > 90 and luck1 <= 100 then
                randomItem = "bluechip"
                itemInfo = AJFW.Shared.Items[randomItem]
               
                Player.Functions.AddItem(randomItem, 1)
                TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "add")
               
			elseif luck1 > 87 and luck1 <= 90 then
				randomItem = "labkey5"
				itemInfo = AJFW.Shared.Items[randomItem]
                
                Player.Functions.AddItem(randomItem, 1)
                TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "add")
            elseif luck1 > 73 and luck1 <= 85 then
				randomItem = "empty_bag"
				itemInfo = AJFW.Shared.Items[randomItem]
                
                Player.Functions.AddItem(randomItem, 1)
                TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "add")
                
			elseif luck1 > 53 and luck1 <= 60 then
                local blackamount = math.random(20,30) 
				randomItem = "blackmoney"
				itemInfo = AJFW.Shared.Items[randomItem]
                
                Player.Functions.AddItem(randomItem, blackamount)
                TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "add", blackamount)

            elseif luck1 > 25 and luck1 <= 45 then
                TriggerClientEvent('AJFW:Notify', src, "कुछ नहीं मिलेगा , निकल पहली फुर्सत में" , "error", 5000)
                
			elseif luck1 > 10 and luck1 <= 25 then
				TriggerClientEvent('AJFW:Notify', src, "कुछ नहीं मिलेगा , निकल पहली फुर्सत में" , "error", 5000)
                
            elseif luck1 <= 10 then
                TriggerClientEvent('AJFW:Notify', src, "कुछ नहीं मिलेगा , निकल पहली फुर्सत में" , "error", 5000)
                
            end
            Citizen.Wait(500)
        end
    end
end)

-----------------------------aj--------------------------------------