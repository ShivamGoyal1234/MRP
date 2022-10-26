MRFW = exports['mrfw']:GetCoreObject()

-- Oxy Run

local carspawns = {
	[1] =  { ['x'] = 2739.77,['y'] = 4274.51,['z'] = 48.16,['h'] = 107.9, ['info'] = ' car 8' },
	[2] =  { ['x'] = 2739.77,['y'] = 4274.51,['z'] = 48.16,['h'] = 107.9, ['info'] = ' car 1' },
	[3] =  { ['x'] = 2739.77,['y'] = 4274.51,['z'] = 48.16,['h'] = 107.9, ['info'] = ' car 2' },
	[4] =  { ['x'] = 2739.77,['y'] = 4274.51,['z'] = 48.16,['h'] = 107.9, ['info'] = ' car 3' },
	[5] =  { ['x'] = 2739.77,['y'] = 4274.51,['z'] = 48.16,['h'] = 107.9, ['info'] = ' car 4' },
	[6] =  { ['x'] = 2739.77,['y'] = 4274.51,['z'] = 48.16,['h'] = 107.9, ['info'] = ' car 5' },
	[7] =  { ['x'] = 2739.77,['y'] = 4274.51,['z'] = 48.16,['h'] = 107.9, ['info'] = ' car 6' },
	[8] =  { ['x'] = 2739.77,['y'] = 4274.51,['z'] = 48.16,['h'] = 107.9, ['info'] = ' car 7' },
}

local pillWorker = { ['x'] = 2728.66,['y'] = 4142.04,['z'] = 44.29,['h'] = 257.82, ['info'] = 'boop bap' }


MRFW.Functions.CreateCallback('jacob:get:oxy', function(source, cb)
    cb(carspawns, pillWorker)
end)
	
	
RegisterServerEvent('oxydelivery:server')
AddEventHandler('oxydelivery:server', function()
    local Player = MRFW.Functions.GetPlayer(source)

    if Player.Functions.RemoveMoney('cash', Config.DefaultPrice, "Oxy-run") then
		Player.Functions.RemoveItem('lotto', 1)
		TriggerClientEvent("inventory:client:ItemBox", source, MRFW.Shared.Items['lotto'], "remove")
        TriggerClientEvent('oxydelivery:startDealing', source)
 
    else
        TriggerClientEvent('MRFW:Notify', source, "You do not have enough money", "error")
    end
end)		

RegisterServerEvent('oxydelivery:receiveBigRewarditem')
AddEventHandler('oxydelivery:receiveBigRewarditem', function()
	local Player = MRFW.Functions.GetPlayer(source)

	Player.Functions.AddItem(Config.BigRewarditem, 1)
	TriggerClientEvent('inventory:client:ItemBox', source, MRFW.Shared.Items[Config.BigRewarditem], "add")
end)

RegisterServerEvent('oxydelivery:receiveBigRewarditem2')
AddEventHandler('oxydelivery:receiveBigRewarditem2', function()
	local Player = MRFW.Functions.GetPlayer(source)

	Player.Functions.AddItem(Config.BigRewarditem2, 1)
	TriggerClientEvent('inventory:client:ItemBox', source, MRFW.Shared.Items[Config.BigRewarditem2], "add")
end)

RegisterServerEvent('oxydelivery:receiveoxy')
AddEventHandler('oxydelivery:receiveoxy', function()
	local Player = MRFW.Functions.GetPlayer(source)

	Player.Functions.AddMoney('cash', Config.Payment / 2)
	Player.Functions.AddItem('oxy', Config.OxyAmount)
end)

RegisterServerEvent('oxydelivery:receivemoneyyy')
AddEventHandler('oxydelivery:receivemoneyyy', function()
	local Player = MRFW.Functions.GetPlayer(source)

	Player.Functions.AddMoney('cash', Config.Payment)
end)

MRFW.Functions.CreateCallback('mr-oxy:server:start', function(source, cb)
    local src = source
    local Ply = MRFW.Functions.GetPlayer(src)
    local lotto = Ply.Functions.GetItemByName("lotto")
    if lotto ~= nil then
        cb(true)
    else
        cb(false)
    end
end)