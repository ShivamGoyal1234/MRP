-- Events

RegisterNetEvent('mr-printer:client:UseDocument', function(ItemData)
    local DocumentUrl = ItemData.info.url ~= nil and ItemData.info.url or false
    SendNUIMessage({
        action = "open",
        url = DocumentUrl
    })
    SetNuiFocus(true, false)
end)

RegisterNetEvent('mr-printer:client:SpawnPrinter', function(ItemData)
    local playerPed = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)
    local forward   = GetEntityForwardVector(playerPed)
    local x, y, z   = table.unpack(coords + forward * 1.0)

    local model = `prop_printer_01`
    RequestModel(model)
    while (not HasModelLoaded(model)) do
        Wait(1)
    end
    obj = CreateObject(model, x, y, z, true, false, true)
    PlaceObjectOnGroundProperly(obj)
    SetModelAsNoLongerNeeded(model)
    SetEntityAsMissionEntity(obj)
end)

-- NUI

RegisterNUICallback('SaveDocument', function(data)
    if data.url then
        TriggerServerEvent('mr-printer:server:SaveDocument', data.url)
    end
end)

RegisterNUICallback('CloseDocument', function()
    SetNuiFocus(false, false)
end)

-- Command

RegisterCommand('useprinter', function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local PrinterObject = GetClosestObjectOfType(pos.x, pos.y, pos.z, 1.5, `prop_printer_01`, false, false, false)
    local PrinterObject2 = GetClosestObjectOfType(pos.x, pos.y, pos.z, 1.5, `prop_printer_02`, false, false, false)
    local PrinterObject3 = GetClosestObjectOfType(pos.x, pos.y, pos.z, 1.5, `v_res_printer`, false, false, false)
    if PrinterObject ~= 0 then
        SendNUIMessage({
            action = "start"
        })
        SetNuiFocus(true, true)
    elseif PrinterObject2 ~= 0 then
        SendNUIMessage({
            action = "start"
        })
        SetNuiFocus(true, true)
    elseif PrinterObject3 ~= 0 then
        SendNUIMessage({
            action = "start"
        })
        SetNuiFocus(true, true)
    end
end)