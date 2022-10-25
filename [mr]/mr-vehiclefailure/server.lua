MRFW.Commands.Add("fix", "Repair your vehicle (Admin Only)", {}, false, function(source, args)
    TriggerClientEvent('iens:repaira', source)
    TriggerClientEvent('vehiclemod:client:fixEverything', source)
end, "h-admin")

MRFW.Functions.CreateUseableItem("repairkit", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("mr-vehiclefailure:client:RepairVehicle", source)
    end
end)

MRFW.Functions.CreateUseableItem("cleaningkit", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("mr-vehiclefailure:client:CleanVehicle", source)
    end
end)

MRFW.Functions.CreateUseableItem("advancedrepairkit", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("mr-vehiclefailure:client:RepairVehicleFull", source)
    end
end)

MRFW.Functions.CreateUseableItem("ugrepairkit", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("mr-vehiclefailure:client:ugrepair", source)
    end
end)

RegisterServerEvent('mr-vehiclefailure:removeItem')
AddEventHandler('mr-vehiclefailure:removeItem', function(item)
    local src = source
    local ply = MRFW.Functions.GetPlayer(src)
    ply.Functions.RemoveItem(item, 1)
end)

RegisterServerEvent('mr-vehiclefailure:server:removewashingkit')
AddEventHandler('mr-vehiclefailure:server:removewashingkit', function(veh)
    local src = source
    local ply = MRFW.Functions.GetPlayer(src)
    ply.Functions.RemoveItem("cleaningkit", 1)
    TriggerClientEvent('mr-vehiclefailure:client:SyncWash', -1, veh)
end)

