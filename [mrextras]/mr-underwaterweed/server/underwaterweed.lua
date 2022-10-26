-- MRFW = nil

-- TriggerEvent('MRFW:GetObject', function(obj) MRFW = obj end)

local playersProcessingWeed = {}

RegisterServerEvent('mr-underwaterweed:pickedUpWeed')
AddEventHandler('mr-underwaterweed:pickedUpWeed', function()
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)

	  if TriggerClientEvent("MRFW:Notify", src, "Picked up some Weed!!", "Success", 8000) then
		  Player.Functions.AddItem('skunk', 1) ---- change this shit 
		  TriggerClientEvent("inventory:client:ItemBox", source, MRFW.Shared.Items['skunk'], "add")
	  end
  end)



RegisterServerEvent('mr-underwaterweed:processWeed')
AddEventHandler('mr-underwaterweed:processWeed', function()
		local src = source
    	local Player = MRFW.Functions.GetPlayer(src)

		Player.Functions.RemoveItem('skunk', 1)----change this
		Player.Functions.RemoveItem('empty_weed_bag', 1)----change this
		Player.Functions.AddItem('weed_skunk', 2)-----change this
		TriggerClientEvent("inventory:client:ItemBox", source, MRFW.Shared.Items['skunk'], "remove")
		TriggerClientEvent("inventory:client:ItemBox", source, MRFW.Shared.Items['empty_weed_bag'], "remove")
		TriggerClientEvent("inventory:client:ItemBox", source, MRFW.Shared.Items['weed_skunk'], "add")
		TriggerClientEvent('MRFW:Notify', src, 'weed_processed', "success")                                                                         				
end)



function CancelProcessing(playerId)
	if playersProcessingWeed[playerId] then
		ClearTimeout(playersProcessingWeed[playerId])
		playersProcessingWeed[playerId] = nil
	end
end

RegisterServerEvent('mr-underwaterweed:cancelProcessing')
AddEventHandler('mr-underwaterweed:cancelProcessing', function()
	CancelProcessing(source)
end)

AddEventHandler('mr-underwaterweed:playerDropped', function(playerId, reason)
	CancelProcessing(playerId)
end)

RegisterServerEvent('mr-underwaterweed:onPlayerDeath')
AddEventHandler('mr-underwaterweed:onPlayerDeath', function(data)
	local src = source
	CancelProcessing(src)
end)

MRFW.Functions.CreateCallback('mr-underwaterweed:process', function(source, cb)
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	 
	if Player.PlayerData.item ~= nil and next(Player.PlayerData.items) ~= nil then
		for k, v in pairs(Player.PlayerData.items) do
		    if Player.Playerdata.items[k] ~= nil then
				if Player.Playerdata.items[k].name == "skunk" and Player.Playerdata.items[k].name == "empty_weed_bag" and Player.Playerdata.items[k].name == "drugscales" then
					cb(true)
			    else
					TriggerClientEvent("MRFW:Notify", src, "You missing something", "error", 10000)
					cb(false)
				end
	        end
		end	
	end
end)

MRFW.Functions.CreateCallback('mr-underwaterweed:ingredient', function(source, cb)
    local src = source
    local Ply = MRFW.Functions.GetPlayer(src)
    local skunk = Ply.Functions.GetItemByName("skunk")
	local empty_weed_bag = Ply.Functions.GetItemByName("empty_weed_bag")
	local drugscales = Ply.Functions.GetItemByName("drugscales")
	local lighter = Ply.Functions.GetItemByName("lighter")
    if skunk ~= nil and empty_weed_bag ~= nil and drugscales ~= nil and lighter ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

