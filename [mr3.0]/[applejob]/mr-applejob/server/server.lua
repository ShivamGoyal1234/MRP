MRFW = nil
local MRFW = exports['mrfw']:GetCoreObject()
TriggerEvent('MRFW:GetObject', function(obj) MRFW = obj end)


RegisterServerEvent('apple:getItem')
AddEventHandler('apple:getItem', function()
	local xPlayer, randomItem = MRFW.Functions.GetPlayer(source), Config.Items[math.random(1, #Config.Items)]
	
	-- if math.random(0, 100) <= Config.ChanceToGetItem then
		local Item = xPlayer.Functions.GetItemByName('apple')
		if Item == nil then
			xPlayer.Functions.AddItem(randomItem, 1)
			TriggerClientEvent("inventory:client:ItemBox", source, MRFW.Shared.Items[randomItem], "add")
		else	
		if Item.amount < 20 then
		xPlayer.Functions.AddItem(randomItem, 1)
		TriggerClientEvent("inventory:client:ItemBox", source, MRFW.Shared.Items[randomItem], "add")
		else
			TriggerClientEvent('MRFW:Notify', source, 'full inventory, go make Apple Juice!', "error")  
		end
	    end
    -- end
end)


RegisterServerEvent('apple:process')
AddEventHandler('apple:process', function()
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)

	if Player.Functions.GetItemByName('apple') and Player.Functions.GetItemByName('empty_bottle')then
		local chance = math.random(1, 8)
		if chance == 1 or chance == 2 or chance == 3 or chance == 4 or chance == 5 or chance == 6 or chance == 7 or chance == 8 then
			Player.Functions.RemoveItem('apple', 1)
			Player.Functions.RemoveItem('empty_bottle', 1)
			Player.Functions.AddItem('apple_juice', 1)
			TriggerClientEvent("inventory:client:ItemBox", source, MRFW.Shared.Items['apple'], "remove")
			TriggerClientEvent("inventory:client:ItemBox", source, MRFW.Shared.Items['empty_bottle'], "remove")
			TriggerClientEvent("inventory:client:ItemBox", source, MRFW.Shared.Items['apple_juice'], "add")
			TriggerClientEvent('MRFW:Notify', src, 'Your Apple Juice has been Made!', "success")  
		else
			
		end 
	else
		TriggerClientEvent('MRFW:Notify', src, 'You don\'t have the right items to make Apple juice!', "error") 
	end
end)


MRFW.Functions.CreateCallback('apple:ingredient', function(source, cb)
    local src = source
    local Ply = MRFW.Functions.GetPlayer(src)
    local apple = Ply.Functions.GetItemByName("apple")
	local empty_bottle = Ply.Functions.GetItemByName("empty_bottle")
    if apple ~= nil and empty_bottle ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

