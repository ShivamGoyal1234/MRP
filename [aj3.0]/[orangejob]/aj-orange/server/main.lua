AJFW = nil
local AJFW = exports['ajfw']:GetCoreObject()

TriggerEvent('AJFW:GetObject', function(obj) AJFW = obj end)

AJFW.Functions.CreateCallback('aj-orange:GetItemData', function(source, cb, itemName)
	local retval = false
	local Player = AJFW.Functions.GetPlayer(source)
	if Player ~= nil then 
		if Player.Functions.GetItemByName(itemName) ~= nil then
			retval = true
		end
	end
	
	cb(retval)
end)	

RegisterServerEvent("aj-orange:sellorange")
AddEventHandler("aj-orange:sellorange", function()
    local src = source
	local Player = AJFW.Functions.GetPlayer(src)
	local price = 0
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k] ~= nil then 
                if Player.PlayerData.items[k].name == "orange_juice" then 
                    price = price + (Config.OrangeItems["orange_juice"]["price"] * Player.PlayerData.items[k].amount)
                    Player.Functions.RemoveItem("orange_juice", Player.PlayerData.items[k].amount, k)
                end
            end
        end
        Player.Functions.AddMoney("cash", price, "sold-orangejuice")
		TriggerClientEvent('AJFW:Notify', src, "You have sold your Orange Juice Pretty Tasty BTW!")
	end
end)