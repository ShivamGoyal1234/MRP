-- MRFW = nil
-- TriggerEvent('MRFW:GetObject', function(obj) MRFW = obj end)

-- Code

local locations = {
    ["laboratories"] = {
        [1] = {
            coords = {x = 986.59, y = -2211.32, z = 37.0, h = 188.99, r = 1.0},
        },
    },
    ["exit"] = {
        coords = {x = 997.01, y = -3200.65, z = -36.4, h = 275.5, r = 1.0}, 
    },
    ["laptop"] = {
        coords = {x = 1002.0, y = -3194.87, z = -39.0, h = 2.5, r = 1.0},
        inUse = false,
    }
}

local carspawns = {
	[1] =  { ['x'] = 1001.49,['y'] = -2226.09,['z'] = 30.21,['h'] = 355.07 }
}

local store = vector3(989.4, -2273.37, 30.16)


MRFW.Functions.CreateCallback('jacob:get:meth', function(source, cb)
    cb(locations, carspawns, store)
end)

Citizen.CreateThread(function()
    Config.CurrentLab = math.random(1, #locations["laboratories"])
    -- print('Lab entry has been set to location: '..Config.CurrentLab)
end)

MRFW.Functions.CreateCallback('mr-methlab:server:GetData', function(source, cb)
    local LabData = {
        CurrentLab = Config.CurrentLab
    }
    cb(LabData)
end)

MRFW.Functions.CreateCallback('methlab:check:SecretDrive', function(source, cb)
    local src = source
    local PLayer = MRFW.Functions.GetPlayer(src)
    local HasDrive = PLayer.Functions.GetItemByName("secretdrive")
    cb(HasDrive)
end)

MRFW.Functions.CreateUseableItem("labkey", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
    local LabKey = item.info.lab ~= nil and item.info.lab or 1

    TriggerClientEvent('mr-methlab:client:UseLabKey', source, LabKey)
end)

function GenerateRandomLab()
    local Lab = math.random(1, #locations["laboratories"])
    return Lab
end

RegisterServerEvent('mr-methlab:server:receiveoxy')
AddEventHandler('mr-methlab:server:receiveoxy', function()
	local Player = MRFW.Functions.GetPlayer(source)

	Player.Functions.AddItem('aluminumoxide', 1)
	TriggerClientEvent("inventory:client:ItemBox", source, MRFW.Shared.Items['aluminumoxide'], "add")
end)

RegisterServerEvent('mr-methlab:server:re:ac')
AddEventHandler('mr-methlab:server:re:ac', function()
	local Player = MRFW.Functions.GetPlayer(source)

	Player.Functions.AddItem('acetone', 1)
	TriggerClientEvent("inventory:client:ItemBox", source, MRFW.Shared.Items['acetone'], "add")
end)

MRFW.Functions.CreateCallback('mr-methlab:server:ingredient', function(source, cb)
    local src = source
    local Ply = MRFW.Functions.GetPlayer(src)
    local acetone = Ply.Functions.GetItemByName("acetone")
    local aluminumoxide = Ply.Functions.GetItemByName("aluminumoxide")
    local sodiumchloride = Ply.Functions.GetItemByName("sodiumchloride")
    if acetone ~= nil and aluminumoxide ~= nil and sodiumchloride ~= nil then
        cb(true)
    else
        cb(false)
    end
end)


RegisterServerEvent("mr-methlab:server:processed")
AddEventHandler("mr-methlab:server:processed", function(x,y,z)
  	local src = source
  	local Player = MRFW.Functions.GetPlayer(src)

		
	Player.Functions.RemoveItem('acetone', 1)
    Player.Functions.RemoveItem('aluminumoxide', 1)
    Player.Functions.RemoveItem('sodiumchloride', 1)
	Player.Functions.AddItem('meth_raw', 1)
	TriggerClientEvent("inventory:client:ItemBox", source, MRFW.Shared.Items['acetone'], "remove")
    TriggerClientEvent("inventory:client:ItemBox", source, MRFW.Shared.Items['aluminumoxide'], "remove")
    TriggerClientEvent("inventory:client:ItemBox", source, MRFW.Shared.Items['sodiumchloride'], "remove")
	TriggerClientEvent("inventory:client:ItemBox", source, MRFW.Shared.Items['meth_raw'], "add")
		
end)


MRFW.Functions.CreateCallback('mr-methlab:server:packing', function(source, cb)
    local src = source
    local Ply = MRFW.Functions.GetPlayer(src)
    local meth_raw = Ply.Functions.GetItemByName("meth_raw")
    local meth_bag = Ply.Functions.GetItemByName("empty_bag")
	local highqualityscales = Ply.Functions.GetItemByName("highqualityscales")
    local lighter = Ply.Functions.GetItemByName("lighter")
    if meth_raw ~= nil and highqualityscales ~= nil and lighter ~= nil and meth_bag ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent("mr-methlab:server:packed")
AddEventHandler("mr-methlab:server:packed", function(x,y,z)
  	local src = source
  	local Player = MRFW.Functions.GetPlayer(src)

		
	Player.Functions.RemoveItem('meth_raw', 1)
    Player.Functions.RemoveItem('empty_bag', 1)

	Player.Functions.AddItem('meth_pooch', 2)
	TriggerClientEvent("inventory:client:ItemBox", source, MRFW.Shared.Items['meth_raw'], "remove")
    TriggerClientEvent("inventory:client:ItemBox", source, MRFW.Shared.Items['empty_bag'], "remove")

	TriggerClientEvent("inventory:client:ItemBox", source, MRFW.Shared.Items['meth_pooch'], "add")
		
end)

