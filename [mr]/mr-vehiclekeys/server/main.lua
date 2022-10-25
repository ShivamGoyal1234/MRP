-----------------------
----   Variables   ----
-----------------------
local MRFW = exports['mrfw']:GetCoreObject()
local VehicleList = {}

-----------------------
----   Threads     ----
-----------------------

-----------------------
---- Server Events ----
-----------------------

-- Event to give keys. receiver can either be a single id, or a table of ids.
-- Must already have keys to the vehicle, trigger the event from the server, or pass forcegive paramter as true.
RegisterNetEvent('mr-vehiclekeys:server:GiveVehicleKeys', function(receiver, plate)
    local giver = source

    if HasKeys(giver, plate) then
        TriggerClientEvent('MRFW:Notify', giver, "You hand over the keys.", 'success')
        if type(receiver) == 'table' then
            for _,r in ipairs(receiver) do
                GiveKeys(receiver[r], plate)
            end
        else
            GiveKeys(receiver, plate)
        end
    else
        TriggerClientEvent('MRFW:Notify', giver, "You don't have keys to this vehicle.", "error")
    end
end)

RegisterNetEvent('mr-vehiclekeys:server:AcquireVehicleKeys', function(plate)
    local src = source
    GiveKeys(src, plate)
end)

MRFW.Functions.CreateCallback('mr-vehiclekeys:server:GetVehicleKeys', function(source, cb)
    local citizenid = MRFW.Functions.GetPlayer(source).PlayerData.citizenid
    local keysList = {}
    for plate, citizenids in pairs (VehicleList) do
        if citizenids[citizenid] then
            keysList[plate] = true
        end
    end
    cb(keysList)
end)

-----------------------
----   Functions   ----
-----------------------

function GiveKeys(id, plate)
    local citizenid = MRFW.Functions.GetPlayer(id).PlayerData.citizenid

    if not VehicleList[plate] then VehicleList[plate] = {} end
    VehicleList[plate][citizenid] = true
    
    TriggerClientEvent('MRFW:Notify', id, "You get keys to the vehicle!")
    TriggerClientEvent('mr-vehiclekeys:client:AddKeys', id, plate)
end

function RemoveKeys(id, plate)
    local citizenid = MRFW.Functions.GetPlayer(id).PlayerData.citizenid

    if VehicleList[plate] and VehicleList[plate][citizenid] then
        VehicleList[plate][citizenid] = nil
    end

    TriggerClientEvent('mr-vehiclekeys:client:RemoveKeys', id, plate)
end

function HasKeys(id, plate)
    local citizenid = MRFW.Functions.GetPlayer(id).PlayerData.citizenid
    if VehicleList[plate] and VehicleList[plate][citizenid] then
        return true
    end
    return false
end

MRFW.Commands.Add("engine", "Toggle Engine", {}, false, function(source)
	TriggerClientEvent('mr-vehiclekeys:client:ToggleEngine', source)
end)

MRFW.Commands.Add("givekeys", "Hand over the keys to someone. If no ID, gives to closest person or everyone in the vehicle.", {{name = "id", help = "Player ID"}}, false, function(source, args)
	local src = source
    TriggerClientEvent('mr-vehiclekeys:client:GiveKeys', src, tonumber(args[1]))
end)

MRFW.Commands.Add("addkeys", "Adds keys to a vehicle for someone.", {{name = "id", help = "Player ID"}, {name = "plate", help = "Plate"}}, true, function(source, args)
	local src = source
    if not args[1] or not args[2] then
        TriggerClientEvent('MRFW:Notify', src, 'Fill out the player ID and Plate arguments.')
        return
    end
    GiveKeys(tonumber(args[1]), args[2])
end, 'admin')

MRFW.Commands.Add("removekeys", "Remove keys to a vehicle for someone.", {{name = "id", help = "Player ID"}, {name = "plate", help = "Plate"}}, true, function(source, args)
	local src = source
    if not args[1] or not args[2] then
        TriggerClientEvent('MRFW:Notify', src, 'Fill out the player ID and Plate arguments.')
        return
    end
    RemoveKeys(tonumber(args[1]), args[2])
end, 'admin')