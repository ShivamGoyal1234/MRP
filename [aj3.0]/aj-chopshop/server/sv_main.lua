if Config.Version == "new" then
    AJFW = exports['ajfw']:GetCoreObject()
end

RegisterNetEvent("aj-chopshop:syncchopcars")
AddEventHandler("aj-chopshop:syncchopcars", SyncCars)

function GiveReward(data)
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)

	if data == "wheel1" or data == "wheel2" or data == "wheel3" or data == "wheel4" then
    		Player.Functions.AddItem("carpart_wheel", 1)
            TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items['carpart_wheel'], "add")

	elseif data == "door" then
    	Player.Functions.AddItem("carpart_door", 1)
        TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items['carpart_door'], "add")
		
	elseif data == "hood" then
    	Player.Functions.AddItem("carpart_hood", 1)
        TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items['carpart_hood'], "add")

	elseif data == "trunk" then 
		local randomitem = math.random(1, 8)
		local item = Config.TrunkItems[randomitem]["item"]
		local amount = Config.TrunkItems[randomitem]["amount"]
		Player.Functions.AddItem(item, amount, false, info)
		TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items[item], "add", amount)
		TriggerClientEvent('AJFW:Notify', src, "You found "..amount.." "..item.." in the trunk", 'success')
		Citizen.Wait(8500)
		Player.Functions.AddItem("carpart_trunk", 1)
        TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items['carpart_trunk'], "add")
	end
end

-- RegisterServerEvent('aj-chopshop:server:callCops')
-- AddEventHandler('aj-chopshop:server:callCops', function(type, bank, streetLabel, coords)
--     local msg = ""
--     msg = "Possible Vehicle Robbery"
--     local alertData = {
--         title = "Chopshop",
--         coords = {x = coords.x, y = coords.y, z = coords.z},
--         description = msg,
--     }
--     TriggerClientEvent("aj-chopshop:client:robberyCall", -1, type, bank, streetLabel, coords)
--     TriggerClientEvent("aj-phone:client:addPoliceAlert", -1, alertData)
-- end)

RegisterNetEvent("aj-chopshop:server:rewardplayer")
AddEventHandler("aj-chopshop:server:rewardplayer", GiveReward)

function SyncCars(list) 
	TriggerClientEvent('aj-chopshop:carlist', -1,list) 
end

RegisterNetEvent("aj-chopshop:server:chopdoor")
AddEventHandler("aj-chopshop:server:chopdoor", function()
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)
	local door = "carpart_door"
	
	if Player.Functions.GetItemByName(door) ~= nil then
		local randomitem = math.random(1, 7)
		local item = Config.DoorItems[randomitem]["item"]
		local amount = Config.DoorItems[randomitem]["amount"]
		Player.Functions.RemoveItem("carpart_door", 1)
		TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items['carpart_door'], "remove")
		TriggerClientEvent('aj-chopshop:doorchopanim', src)
		Citizen.Wait(12500)
		Player.Functions.AddItem(item, amount, false, info)
		TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items[item], "add", amount)
	else
		TriggerClientEvent('AJFW:Notify', src, 'You have no doors to scrap..', 'error')
	end
end)

RegisterNetEvent("aj-chopshop:server:chopwheel")
AddEventHandler("aj-chopshop:server:chopwheel", function()
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)
	local wheel = "carpart_wheel"

	if Player.Functions.GetItemByName(wheel) ~= nil then
		local randomitem = math.random(1, 3)
		local item = Config.WheelItems[randomitem]["item"]
		local amount = Config.WheelItems[randomitem]["amount"]
		Player.Functions.RemoveItem("carpart_wheel", 1)
        TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items['carpart_wheel'], "remove")
		TriggerClientEvent('aj-chopshop:wheelchopanim', src)
		Citizen.Wait(14000)
		Player.Functions.AddItem(item, amount, false, info)
		TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items[item], "add", amount)
	else
		TriggerClientEvent('AJFW:Notify', src, 'You have no wheels to scrap..', 'error')
	end
end)


RegisterNetEvent("aj-chopshop:server:chophood")
AddEventHandler("aj-chopshop:server:chophood", function()
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)
	local hood = "carpart_hood" 

	if Player.Functions.GetItemByName(hood) ~= nil then
		local randomitem = math.random(1, 7)
		local item = Config.DoorItems[randomitem]["item"]
		local amount = Config.DoorItems[randomitem]["amount"]
		Player.Functions.RemoveItem("carpart_hood", 1)
		TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items['carpart_hood'], "remove")
		TriggerClientEvent('aj-chopshop:hoodchopanim', src)
		Citizen.Wait(12500)
		Player.Functions.AddItem(item, amount, false, info)
		TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items[item], "add", amount)
	else
		TriggerClientEvent('AJFW:Notify', src, 'You have no hoods to scrap..', 'error')
	end
end)


RegisterNetEvent("aj-chopshop:server:choptrunk")
AddEventHandler("aj-chopshop:server:choptrunk", function()
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)
	local trunk = "carpart_trunk"

	if Player.Functions.GetItemByName(trunk) ~= nil then
		local randomitem = math.random(1, 7)
		local item = Config.DoorItems[randomitem]["item"]
		local amount = Config.DoorItems[randomitem]["amount"]
		Player.Functions.RemoveItem("carpart_trunk", 1)
        TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items['carpart_trunk'], "remove")
		TriggerClientEvent('aj-chopshop:trunkchopanim', src)
		Citizen.Wait(12500)
		Player.Functions.AddItem(item, amount, false, info)
		TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items[item], "add", amount)
	else
		TriggerClientEvent('AJFW:Notify', src, 'You have no trunks to scrap..', 'error')
	end
end)

RegisterServerEvent("aj-chopshop:server:crush")
AddEventHandler("aj-chopshop:server:crush", function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
	local amount = math.random(1, 3)
    Player.Functions.AddItem("wire", amount, false)
    TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items["wire"], "add", amount)
end)

