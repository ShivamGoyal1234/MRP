local MRFW = exports['mrfw']:GetCoreObject()
local global_radius = nil
local global_radius2 = nil
local global_radius3 = nil
local global_radius4 = nil
local global_color = nil
local global_color2 = nil
local global_color3 = nil
local global_seconds = 0
local coords = nil
local coords2 = nil
local coords3 = nil
local toggle = false
local toggle2 = false
local toggle3 = false
local dropblip = false

RegisterNetEvent('event:radius:s', function()
    if toggle then
        TriggerClientEvent('event:radius', source, true, coords, global_radius, global_color)
    else
        TriggerClientEvent('event:radius', source, false)
    end
end)

RegisterNetEvent('event:radius:s2', function()
    if toggle2 then
        TriggerClientEvent('event:radius2', source, true, coords2, global_radius3, global_color2)
    else
        TriggerClientEvent('event:radius2', source, false)
    end
end)

RegisterNetEvent('event:radius:s3', function()
    if toggle3 then
        TriggerClientEvent('event:radius3', source, true, coords3, global_radius4, global_color3)
    else
        TriggerClientEvent('event:radius3', source, false)
    end
end)

RegisterNetEvent('event:seconds:s', function()
    TriggerClientEvent('event:seconds', source, global_seconds)
end)

RegisterNetEvent('event:blip:s', function(data)
    if dropblip then
        TriggerClientEvent("event:blip", source, true, global_radius2)
    else
        TriggerClientEvent("event:blip", source, false)
    end
end)

MRFW.Commands.Add('radius', 'for event', {{name='type', help='public / test'}, {name='toggle', help='true / false'}, {name='radius', help='in number'},{name='color', help='red / green / blue'}}, false, function(source, args)
    local src = source
    local type = tostring(args[1])
    local zone = args[2]
    local radius = tonumber(args[3])
    local color = tostring(args[4])
    if type == 'public' then
        if zone then
            if radius ~= nil then
                if color == 'red' or color == 'green' or color == 'blue' then
                    local ped = GetPlayerPed(src)
                    local pcoords = GetEntityCoords(ped)
                    global_radius = radius
                    global_color = color
                    coords = pcoords
                    toggle = true
                    TriggerClientEvent('event:radius', -1, true, coords, global_radius, global_color)
                else
                    TriggerClientEvent("MRFW:Notify", src, "only red, green, and blue color are allowed", "error", 5000)
                end
            else
                TriggerClientEvent("MRFW:Notify", src, "You are missing radius", "error", 5000)
            end
        else
            global_radius = nil
            global_color = nil
            coords = nil
            toggle = false
            TriggerClientEvent('event:radius', -1, false)
        end
    elseif type == 'test' then
        if zone then
            if radius ~= nil then
                if color == 'red' or color == 'green' or color == 'blue' then
                    local ped = GetPlayerPed(src)
                    local pcoords = GetEntityCoords(ped)
                    TriggerClientEvent('event:radius', src, true, pcoords, radius, color)
                else
                    TriggerClientEvent("MRFW:Notify", src, "only red, green, and blue color are allowed", "error", 5000)
                end
            else
                TriggerClientEvent("MRFW:Notify", src, "You are missing radius", "error", 5000)
            end
        else
            TriggerClientEvent('event:radius', src, false)
        end
    end
end,'dev')

MRFW.Commands.Add('radius2', 'for event', {{name='type', help='public / test'}, {name='toggle', help='true / false'}, {name='radius', help='in number'},{name='color', help='red / green / blue'}}, false, function(source, args)
    local src = source
    local type = tostring(args[1])
    local zone = args[2]
    local radius = tonumber(args[3])
    local color = tostring(args[4])
    if type == 'public' then
        if zone then
            if radius ~= nil then
                if color == 'red' or color == 'green' or color == 'blue' then
                    local ped = GetPlayerPed(src)
                    local pcoords = GetEntityCoords(ped)
                    global_radius3 = radius
                    global_color2 = color
                    coords2 = pcoords
                    toggle2 = true
                    TriggerClientEvent('event:radius2', -1, true, coords2, global_radius3, global_color2)
                else
                    TriggerClientEvent("MRFW:Notify", src, "only red, green, and blue color are allowed", "error", 5000)
                end
            else
                TriggerClientEvent("MRFW:Notify", src, "You are missing radius", "error", 5000)
            end
        else
            global_radius3 = nil
            global_color2 = nil
            coords2 = nil
            toggle2 = false
            TriggerClientEvent('event:radius2', -1, false)
        end
    elseif type == 'test' then
        if zone then
            if radius ~= nil then
                if color == 'red' or color == 'green' or color == 'blue' then
                    local ped = GetPlayerPed(src)
                    local pcoords = GetEntityCoords(ped)
                    TriggerClientEvent('event:radius2', src, true, pcoords, radius, color)
                else
                    TriggerClientEvent("MRFW:Notify", src, "only red, green, and blue color are allowed", "error", 5000)
                end
            else
                TriggerClientEvent("MRFW:Notify", src, "You are missing radius", "error", 5000)
            end
        else
            TriggerClientEvent('event:radius2', src, false)
        end
    end
end,'dev')

MRFW.Commands.Add('radius3', 'for event', {{name='type', help='public / test'}, {name='toggle', help='true / false'}, {name='radius', help='in number'},{name='color', help='red / green / blue'}}, false, function(source, args)
    local src = source
    local type = tostring(args[1])
    local zone = args[2]
    local radius = tonumber(args[3])
    local color = tostring(args[4])
    if type == 'public' then
        if zone then
            if radius ~= nil then
                if color == 'red' or color == 'green' or color == 'blue' then
                    local ped = GetPlayerPed(src)
                    local pcoords = GetEntityCoords(ped)
                    global_radius4 = radius
                    global_color3 = color
                    coords3 = pcoords
                    toggle3 = true
                    TriggerClientEvent('event:radius3', -1, true, coords3, global_radius4, global_color3)
                else
                    TriggerClientEvent("MRFW:Notify", src, "only red, green, and blue color are allowed", "error", 5000)
                end
            else
                TriggerClientEvent("MRFW:Notify", src, "You are missing radius", "error", 5000)
            end
        else
            global_radius4 = nil
            global_color3 = nil
            coords3 = nil
            toggle3 = false
            TriggerClientEvent('event:radius3', -1, false)
        end
    elseif type == 'test' then
        if zone then
            if radius ~= nil then
                if color == 'red' or color == 'green' or color == 'blue' then
                    local ped = GetPlayerPed(src)
                    local pcoords = GetEntityCoords(ped)
                    TriggerClientEvent('event:radius3', src, true, pcoords, radius, color)
                else
                    TriggerClientEvent("MRFW:Notify", src, "only red, green, and blue color are allowed", "error", 5000)
                end
            else
                TriggerClientEvent("MRFW:Notify", src, "You are missing radius", "error", 5000)
            end
        else
            TriggerClientEvent('event:radius3', src, false)
        end
    end
end,'dev')

MRFW.Commands.Add('eventtime', 'for event', {{name='time', help='in second'}}, false, function(source, args)
    local src = source
    local seconds = tonumber(args[1])
    if seconds then
        global_seconds = seconds
        TriggerClientEvent('event:seconds', -1, seconds)
    else
        TriggerClientEvent("MRFW:Notify", src, "invalid usage", "error", 5000)
    end
end,'dev')

MRFW.Commands.Add('eventstash', 'for event', {}, false, function(source, args)
    TriggerClientEvent("event:stash", source)
end,'dev')

MRFW.Commands.Add('eventblip', 'eventblip', {}, false, function(source, args)
    dropblip = not dropblip
    if dropblip then
        local ped = GetPlayerPed(source)
        local pcoords = GetEntityCoords(ped)
        global_radius2 = pcoords
        TriggerClientEvent("event:blip", -1, true, global_radius2)
    else
        TriggerClientEvent("event:blip", -1, false, global_radius2)
    end
end,'dev')

Citizen.CreateThread(function()
    while true do
        if global_seconds > 0 then
            global_seconds = global_seconds - 1
        end
        Citizen.Wait(1000)
    end
end)