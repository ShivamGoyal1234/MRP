RegisterNetEvent('mr-vineyard:server:getGrapes')
AddEventHandler('mr-vineyard:server:getGrapes', function()
    local Player = MRFW.Functions.GetPlayer(source)

    Player.Functions.AddItem("grape", Config.GrapeAmount)
    TriggerClientEvent('inventory:client:ItemBox', source, MRFW.Shared.Items['grape'], "add", Config.GrapeAmount)
end)

RegisterServerEvent('mr-vineyard:server:loadIngredients') 
AddEventHandler('mr-vineyard:server:loadIngredients', function()
	local xPlayer = MRFW.Functions.GetPlayer(tonumber(source))
    local grape = xPlayer.Functions.GetItemByName('grapejuice')

	if xPlayer.PlayerData.items ~= nil then 
        if grape ~= nil then 
            if grape.amount >= 23 then 

                xPlayer.Functions.RemoveItem("grapejuice", 23, false)
                TriggerClientEvent('inventory:client:ItemBox', source, MRFW.Shared.Items['grapejuice'], "remove", 23)
                
                TriggerClientEvent("mr-vineyard:client:loadIngredients", source)

            else
                TriggerClientEvent('MRFW:Notify', source, "You do not have the correct items", 'error')   
            end
        else
            TriggerClientEvent('MRFW:Notify', source, "You do not have the correct items", 'error')   
        end
	else
		TriggerClientEvent('MRFW:Notify', source, "You Have Nothing...", "error")
	end 
	
end) 

RegisterServerEvent('mr-vineyard:server:grapeJuice') 
AddEventHandler('mr-vineyard:server:grapeJuice', function()
	local xPlayer = MRFW.Functions.GetPlayer(tonumber(source))
    local grape = xPlayer.Functions.GetItemByName('grape')

	if xPlayer.PlayerData.items ~= nil then 
        if grape ~= nil then 
            if grape.amount >= 16 then 

                xPlayer.Functions.RemoveItem("grape", 16, false)
                TriggerClientEvent('inventory:client:ItemBox', source, MRFW.Shared.Items['grape'], "remove", 16)
                
                TriggerClientEvent("mr-vineyard:client:grapeJuice", source)

            else
                TriggerClientEvent('MRFW:Notify', source, "You do not have the correct items", 'error')   
            end
        else
            TriggerClientEvent('MRFW:Notify', source, "You do not have the correct items", 'error')   
        end
	else
		TriggerClientEvent('MRFW:Notify', source, "You Have Nothing...", "error")
	end 
	
end) 

RegisterServerEvent('mr-vineyard:server:receiveWine')
AddEventHandler('mr-vineyard:server:receiveWine', function()
	local xPlayer = MRFW.Functions.GetPlayer(tonumber(source))

	xPlayer.Functions.AddItem("wine", Config.WineAmount, false)
	TriggerClientEvent('inventory:client:ItemBox', source, MRFW.Shared.Items['wine'], "add", Config.WineAmount)
end)

RegisterServerEvent('mr-vineyard:server:receiveGrapeJuice')
AddEventHandler('mr-vineyard:server:receiveGrapeJuice', function()
	local xPlayer = MRFW.Functions.GetPlayer(tonumber(source))

	xPlayer.Functions.AddItem("grapejuice", Config.GrapeJuiceAmount, false)
	TriggerClientEvent('inventory:client:ItemBox', source, MRFW.Shared.Items['grapejuice'], "add", Config.GrapeJuiceAmount)
end)


-- Hire/Fire

--[[ MRFW.Commands.Add("hirevineyard", "Hire a player to the Vineyard!", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = MRFW.Functions.GetPlayer(tonumber(args[1]))
    local Myself = MRFW.Functions.GetPlayer(source)
    if Player ~= nil then 
        if (Myself.PlayerData.gang.name == "la_familia") then
            Player.Functions.SetJob("vineyard")
        end
    end
end)

MRFW.Commands.Add("firevineyard", "Fire a player to the Vineyard!", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = MRFW.Functions.GetPlayer(tonumber(args[1]))
    local Myself = MRFW.Functions.GetPlayer(source)
    if Player ~= nil then 
        if (Myself.PlayerData.gang.name == "la_familia") then
            Player.Functions.SetJob("unemployed")
        end
    end
end) ]]

RegisterServerEvent("mr-vineyard:sellWine")
AddEventHandler("mr-vineyard:sellWine", function()
    local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	local price = 0
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k] ~= nil then 
                if Player.PlayerData.items[k].name == "wine" then 
                    price = price + (Config.AppleItems["wine"]["price"] * Player.PlayerData.items[k].amount)
                    Player.Functions.RemoveItem("wine", Player.PlayerData.items[k].amount, k)
                end
            end
        end
        Player.Functions.AddMoney("cash", price, "sold-wine")
		TriggerClientEvent('MRFW:Notify', src, "You have sold your Wine Pretty Tasty BTW!")
	end
end)

RegisterServerEvent("mr-vineyard:sellgrapes")
AddEventHandler("mr-vineyard:sellgrapes", function()
    local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	local price = 0
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k] ~= nil then 
                if Player.PlayerData.items[k].name == "grapejuice" then 
                    price = price + (Config.AppleItems["grapejuice"]["price"] * Player.PlayerData.items[k].amount)
                    Player.Functions.RemoveItem("grapejuice", Player.PlayerData.items[k].amount, k)
                end
            end
        end
        Player.Functions.AddMoney("cash", price, "sold-grapejuice")
		TriggerClientEvent('MRFW:Notify', src, "You have sold your Grape Juice Pretty Tasty BTW!")
	end
end)