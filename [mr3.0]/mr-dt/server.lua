local MRFW = exports['mrfw']:GetCoreObject()

RegisterServerEvent('mr-dt:server:purchaseItem')
AddEventHandler('mr-dt:server:purchaseItem', function(data,amount,StashItems)
	local xPlayer = MRFW.Functions.GetPlayer(source)
	local cash = xPlayer.PlayerData.money.cash
	local Item = xPlayer.Functions.GetItemByName(data.item)
    if Item == nil then
        TriggerEvent('mr-inventory:server:SaveStashItems', "Drive_Through", StashItems)
        xPlayer.Functions.RemoveMoney('cash', amount * data.data.price)
        TriggerEvent('mr-bossmenu:server:addAccountMoney', "mcd", amount * data.data.price)
        xPlayer.Functions.AddItem(data.item, amount)
        TriggerClientEvent("inventory:client:ItemBox", source, MRFW.Shared.Items[data.item], "add")
    else	
		if Item.amount < 5 then
            if Item.amount + amount <= 5 then
                TriggerEvent('mr-inventory:server:SaveStashItems', "Drive_Through", StashItems)
                xPlayer.Functions.RemoveMoney('cash', amount * data.data.price)
                TriggerEvent('mr-bossmenu:server:addAccountMoney', "mcd", amount * data.data.price)
                xPlayer.Functions.AddItem(data.item, amount)
                TriggerClientEvent("inventory:client:ItemBox", source, MRFW.Shared.Items[data.item], "add")
            else
                TriggerClientEvent('MRFW:Notify', source, 'Reduce your order cause you already have '..Item.amount.." "..data.data.label, "error")
            end
		else
			TriggerClientEvent('MRFW:Notify', source, 'You can\'t buy this more', "error")
		end
	end
end)