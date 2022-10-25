local trunkBusy = {}

RegisterServerEvent('mr-trunk:server:setTrunkBusy')
AddEventHandler('mr-trunk:server:setTrunkBusy', function(plate, busy)
    trunkBusy[plate] = busy
end)

MRFW.Functions.CreateCallback('mr-trunk:server:getTrunkBusy', function(source, cb, plate)
    if trunkBusy[plate] then
        cb(true)
    end
    cb(false)
end)

RegisterServerEvent('mr-trunk:server:KidnapTrunk')
AddEventHandler('mr-trunk:server:KidnapTrunk', function(targetId, closestVehicle)
    TriggerClientEvent('mr-trunk:client:KidnapGetIn', targetId, closestVehicle)
end)

MRFW.Commands.Add("getintrunk", "Get In Trunk", {}, false, function(source, args)
    TriggerClientEvent('mr-trunk:client:GetIn', source)
end)

MRFW.Commands.Add("putintrunk", "Put Player In Trunk", {}, false, function(source, args)
    TriggerClientEvent('mr-trunk:server:KidnapTrunk', source)
end)