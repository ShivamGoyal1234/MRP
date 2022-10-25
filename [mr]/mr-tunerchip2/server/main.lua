local tunedVehicles = {}
local VehicleNitrous = {}

MRFW.Functions.CreateUseableItem("tunerlaptop2", function(source, item)
    local src = source
    local player = MRFW.Functions.GetPlayer(src)
    if item.info.uses >= 1 then
        TriggerClientEvent('mr-tunerchip2:client:openChip', src, item)
    else
        TriggerClientEvent("MRFW:Notify", src, "Brocken Chip", "error", 4000)
    end
    -- if player.PlayerData.job.name == 'tunnermechanic' then
        -- TriggerClientEvent('mr-tunerchip:client:checkvehicle', src, item.slot, item.info)
    -- else
        -- TriggerClientEvent('MRFW:Notify', src, "You Can't Use This Chip", 'error')
    -- end
end)

RegisterNetEvent('mr-tunerchip2:server:checkvehicle',function(slot, info)
    local src = source
    local player = MRFW.Functions.GetPlayer(src)
    if info.uses ~= 0 then
        local infos = {}
              infos.uses = info.uses - 1
        player.Functions.RemoveItem('tunerlaptop', 1, slot)
        player.Functions.AddItem('tunerlaptop', 1, slot, infos)
        TriggerClientEvent('mr-tunerchip2:client:openChip', src)
    else
        TriggerClientEvent('MRFW:Notify', src, "Chip Is Broken", 'error')
    end
end)

RegisterServerEvent('mr-tunerchip2:server:TuneStatus')
AddEventHandler('mr-tunerchip2:server:TuneStatus', function(plate, bool)
    if bool then
        tunedVehicles[plate] = bool
    else
        tunedVehicles[plate] = nil
    end
end)

MRFW.Functions.CreateCallback('mr-tunerchip2:server:HasChip', function(source, cb)
    local src = source
    local Ply = MRFW.Functions.GetPlayer(src)
    local Chip = Ply.Functions.GetItemByName('tunerlaptop2')

    if Chip ~= nil then
        cb(true)
    else
        DropPlayer(src, 'This is not the idea, is it?')
        cb(true)
    end
end)

MRFW.Functions.CreateCallback('mr-tunerchip2:server:GetStatus', function(source, cb, plate)
    cb(tunedVehicles[plate])
end)