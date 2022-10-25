AJFW = nil
local AJFW = exports['ajfw']:GetCoreObject()
TriggerEvent('AJFW:GetObject', function(obj) AJFW = obj end)


RegisterServerEvent('orange:getItem')
AddEventHandler('orange:getItem', function()
	local xPlayer, randomItem = AJFW.Functions.GetPlayer(source), Config.Items[math.random(1, #Config.Items)]
	
	-- if math.random(0, 100) <= Config.ChanceToGetItem then
		local Item = xPlayer.Functions.GetItemByName('orange')
		if Item == nil then
			xPlayer.Functions.AddItem(randomItem, 1)
			TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items[randomItem], "add")
		else	
		if Item.amount < 20 then
		xPlayer.Functions.AddItem(randomItem, 1)
		TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items[randomItem], "add")
		else
			TriggerClientEvent('AJFW:Notify', source, 'full inventory, go make Orange Juice!', "error")  
		end
	    end
    -- end
end)


RegisterServerEvent('orange:process')
AddEventHandler('orange:process', function()
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)

	if Player.Functions.GetItemByName('orange') and Player.Functions.GetItemByName('empty_bottle')then
		local chance = math.random(1, 8)
		if chance == 1 or chance == 2 or chance == 3 or chance == 4 or chance == 5 or chance == 6 or chance == 7 or chance == 8 then
			Player.Functions.RemoveItem('orange', 1)
			Player.Functions.RemoveItem('empty_bottle', 1)
			Player.Functions.AddItem('orange_juice', 1)
			TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['orange'], "remove")
			TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['empty_bottle'], "remove")
			TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['orange_juice'], "add")
			TriggerClientEvent('AJFW:Notify', src, 'Your Orange Juice has been Made!', "success")  
		else
			
		end 
	else
		TriggerClientEvent('AJFW:Notify', src, 'You don\'t have the right items to make Orange juice!', "error") 
	end
end)


AJFW.Functions.CreateCallback('orange:ingredient', function(source, cb)
    local src = source
    local Ply = AJFW.Functions.GetPlayer(src)
    local orange = Ply.Functions.GetItemByName("orange")
	local empty_bottle = Ply.Functions.GetItemByName("empty_bottle")
    if orange ~= nil and empty_bottle ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

