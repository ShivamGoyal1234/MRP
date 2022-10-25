AJFW = exports['ajfw']:GetCoreObject()

local playersProcessingCannabis = {}

RegisterServerEvent('aj-weed:pickedUpCannabis')
AddEventHandler('aj-weed:pickedUpCannabis', function()
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)

	  if TriggerClientEvent("AJFW:Notify", src, "Picked up some Cannabis!!", "Success", 8000) then
		  Player.Functions.AddItem('cannabis', 1) ---- change this shit 
		  TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['cannabis'], "add")
	  end
  end)



RegisterServerEvent('aj-weed:processCannabis')
AddEventHandler('aj-weed:processCannabis', function()
		local src = source
    	local Player = AJFW.Functions.GetPlayer(src)

		Player.Functions.RemoveItem('cannabis', 1)----change this
		Player.Functions.RemoveItem('empty_weed_bag', 1)----change this
		Player.Functions.AddItem('weed_2og', 4)-----change this
		TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['cannabis'], "remove")
		TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['empty_weed_bag'], "remove")
		TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['weed_2og'], "add")
		TriggerClientEvent('AJFW:Notify', src, 'weed_processed', "success")                                                                         				
end)



function CancelProcessing(playerId)
	if playersProcessingCannabis[playerId] then
		ClearTimeout(playersProcessingCannabis[playerId])
		playersProcessingCannabis[playerId] = nil
	end
end

RegisterServerEvent('aj-weed:cancelProcessing')
AddEventHandler('aj-weed:cancelProcessing', function()
	CancelProcessing(source)
end)

AddEventHandler('aj-weed:playerDropped', function(playerId, reason)
	CancelProcessing(playerId)
end)

RegisterServerEvent('aj-weed:onPlayerDeath')
AddEventHandler('aj-weed:onPlayerDeath', function(data)
	local src = source
	CancelProcessing(src)
end)

AJFW.Functions.CreateCallback('weed:process', function(source, cb)
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)
	 
	if Player.PlayerData.item ~= nil and next(Player.PlayerData.items) ~= nil then
		for k, v in pairs(Player.PlayerData.items) do
		    if Player.Playerdata.items[k] ~= nil then
				if Player.Playerdata.items[k].name == "cannabis" and Player.Playerdata.items[k].name == "empty_weed_bag" and Player.Playerdata.items[k].name == "drugscales" then
					cb(true)
			    else
					TriggerClientEvent("AJFW:Notify", src, "You missing something", "error", 10000)
					cb(false)
				end
	        end
		end	
	end
end)

AJFW.Functions.CreateCallback('weed:ingredient', function(source, cb)
    local src = source
    local Ply = AJFW.Functions.GetPlayer(src)
    local cannabis = Ply.Functions.GetItemByName("cannabis")
	local empty_weed_bag = Ply.Functions.GetItemByName("empty_weed_bag")
	local drugscales = Ply.Functions.GetItemByName("drugscales")
    local lighter = Ply.Functions.GetItemByName("lighter")
    if cannabis ~= nil and empty_weed_bag ~= nil and drugscales ~= nil and lighter ~= nil then
        cb(true)
    else
        cb(false)
    end
end)


AJFW.Functions.CreateCallback('weed:ingredient2', function(source, cb)
    local src = source
	local Ply = AJFW.Functions.GetPlayer(src)

	local weed_2og = Ply.Functions.GetItemByName("weed_2og")

	
	if weed_2og ~=nil then
        cb(true)
    else
        cb(false)
    end
end)


local process = {
    ["weed_2og"] = 2,
}

RegisterServerEvent("aj-weed:server:process")
AddEventHandler("aj-weed:server:process", function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local weed = 0
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k] ~= nil then 
                if process[Player.PlayerData.items[k].name] ~= nil then 
                    local amount = (Player.PlayerData.items[k].amount / process[Player.PlayerData.items[k].name])
                    if amount < 1 then
                        TriggerClientEvent('AJFW:Notify', src, "You dont have enough " .. Player.PlayerData.items[k].label, "error")
                    else
                        amount = math.ceil(Player.PlayerData.items[k].amount / process[Player.PlayerData.items[k].name])
                        if amount > 0 then
                            --if Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k) then
								--weed = weed + amount
								Player.Functions.RemoveItem('weed_2og', 2)----change this
								Player.Functions.AddItem('weed_4og', 1)----change this
							
								TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['weed_2og'], "remove")

								TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['weed_4og'], "add")
								TriggerClientEvent('AJFW:Notify', src, 'weed_processed', "success")      
                            --end
                        end
                    end
                end
            end
        end
       
    end
end)


RegisterNetEvent("aj-weed:weed")
AddEventHandler("aj-weed:weed", function(item, count)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local luckseed = math.random(1, 100)
    local itemFound = true
    local itemCount = 1

    if itemFound then
        for i = 1, itemCount, 1 do
            local randomItem = Config.weedItems["type"]math.random(1, 2)
            local itemInfo = AJFW.Shared.Items[randomItem]
            if luckseed == 100 then
                randomItem = "weed_ak47_seed"
                itemInfo = AJFW.Shared.Items[randomItem]
               
                Player.Functions.AddItem(randomItem, 1)
                TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "add")
                
			elseif luckseed >= 80 and luckseed <= 90 then
				randomItem = "weed_purple-haze_seed"
				itemInfo = AJFW.Shared.Items[randomItem]
                
                Player.Functions.AddItem(randomItem, 1)
                TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "add")
                
			elseif luckseed >= 50 and luckseed <= 80 then
				randomItem = "weed_amnesia_seed"
				itemInfo = AJFW.Shared.Items[randomItem]
                
                Player.Functions.AddItem(randomItem, 1)
                TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "add")
                
			elseif luckseed >= 30 and luckseed <= 50 then
				randomItem = "weed_og-kush_seed"
				itemInfo = AJFW.Shared.Items[randomItem]
                
				Player.Functions.AddItem(randomItem, 1)
                TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "add")
                
            elseif luckseed >= 0 and luckseed <= 30 then
                TriggerClientEvent("AJFW:Notify", src, "अजी तन मेरा", "error", 5000)
                
                
            end
            Citizen.Wait(500)
		end
    end
end)
