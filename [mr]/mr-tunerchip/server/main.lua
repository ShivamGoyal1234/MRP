local tunedVehicles = {}
local VehicleNitrous = {}

MRFW.Functions.CreateUseableItem("tunerlaptop", function(source, item)
    local src = source
    local player = MRFW.Functions.GetPlayer(src)
    if item.info.uses >= 1 then
        TriggerClientEvent('mr-tunerchip:client:openChip', src, item)
    else
        TriggerClientEvent("MRFW:Notify", src, "Brocken Chip", "error", 4000)
    end
    -- if player.PlayerData.job.name == 'tunnermechanic' then
        -- TriggerClientEvent('mr-tunerchip:client:checkvehicle', src, item.slot, item.info)
    -- else
        -- TriggerClientEvent('MRFW:Notify', src, "You Can't Use This Chip", 'error')
    -- end
end)

RegisterNetEvent('mr-tunerchip:server:checkvehicle',function(slot, info)
    local src = source
    local player = MRFW.Functions.GetPlayer(src)
    if info.uses ~= 0 then
        local infos = {}
              infos.uses = info.uses - 1
        player.Functions.RemoveItem('tunerlaptop', 1, slot)
        player.Functions.AddItem('tunerlaptop', 1, slot, infos)
        TriggerClientEvent('mr-tunerchip:client:openChip', src)
    else
        TriggerClientEvent('MRFW:Notify', src, "Chip Is Broken", 'error')
    end
end)

RegisterServerEvent('mr-tunerchip:server:TuneStatus')
AddEventHandler('mr-tunerchip:server:TuneStatus', function(plate, bool)
    if bool then
        tunedVehicles[plate] = bool
    else
        tunedVehicles[plate] = nil
    end
end)

MRFW.Functions.CreateCallback('mr-tunerchip:server:HasChip', function(source, cb)
    local src = source
    local Ply = MRFW.Functions.GetPlayer(src)
    local Chip = Ply.Functions.GetItemByName('tunerlaptop')

    if Chip ~= nil then
        cb(true)
    else
        DropPlayer(src, 'This is not the idea, is it?')
        cb(true)
    end
end)

MRFW.Functions.CreateCallback('mr-tunerchip:server:GetStatus', function(source, cb, plate)
    cb(tunedVehicles[plate])
end)

MRFW.Functions.CreateUseableItem("nitrous", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)

    TriggerClientEvent('smallresource:client:LoadNitrous', source)
end)

RegisterServerEvent('nitrous:server:LoadNitrous')
AddEventHandler('nitrous:server:LoadNitrous', function(Plate)
    VehicleNitrous[Plate] = {
        hasnitro = true,
        level = 100,
    }
    TriggerClientEvent('nitrous:client:LoadNitrous', -1, Plate)
end)

RegisterServerEvent('nitrous:server:SyncFlames')
AddEventHandler('nitrous:server:SyncFlames', function(netId)
    TriggerClientEvent('nitrous:client:SyncFlames', -1, netId, source)
end)

RegisterServerEvent('nitrous:server:UnloadNitrous')
AddEventHandler('nitrous:server:UnloadNitrous', function(Plate)
    VehicleNitrous[Plate] = nil
    TriggerClientEvent('nitrous:client:UnloadNitrous', -1, Plate)
end)
RegisterServerEvent('nitrous:server:UpdateNitroLevel')
AddEventHandler('nitrous:server:UpdateNitroLevel', function(Plate, level)
    VehicleNitrous[Plate].level = level
    TriggerClientEvent('nitrous:client:UpdateNitroLevel', -1, Plate, level)
end)

RegisterServerEvent('nitrous:server:StopSync')
AddEventHandler('nitrous:server:StopSync', function(plate)
    TriggerClientEvent('nitrous:client:StopSync', -1, plate)
end)
