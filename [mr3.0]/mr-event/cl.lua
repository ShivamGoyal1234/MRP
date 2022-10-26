local MRFW = exports['mrfw']:GetCoreObject()
local blip = nil
local blip2 = nil
local blip3 = nil
local blip4 = nil
local timeleft = 0

local function SecondsToClock(seconds)
    local mins = string.format("%02.f", math.floor(seconds/60));
    local secs = string.format("%02.f", math.floor(seconds - mins *60));
    local timer = mins..":"..secs
    return timer
end

local function Text(content, font, scale, x, y)
    SetTextFont(font)
    SetTextScale(scale, scale)
    SetTextProportional(0)
    SetTextColour(255,255,255,255)
    SetTextEntry("STRING")
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    AddTextComponentString(content)
    DrawText(x, y)
end

RegisterNetEvent('event:radius', function(toggle, coords, radius, color)
    if toggle then
        RemoveBlip(blip)
        blip = nil
        blip = AddBlipForRadius(coords.x,coords.y,0.0, radius+0.0)
        SetBlipSprite(blip, 9)
        -- SetBlipSprite(blip,1)
        if color == 'red' then
            SetBlipColour(blip,1)
        elseif color == 'green' then
            SetBlipColour(blip,25)
        elseif color == 'blue' then
            SetBlipColour(blip,38)
        end
        SetBlipAlpha(blip,100)
    else
        RemoveBlip(blip)
        blip = nil
    end
end)

RegisterNetEvent('event:radius2', function(toggle, coords, radius, color)
    if toggle then
        RemoveBlip(blip3)
        blip3 = nil
        blip3 = AddBlipForRadius(coords.x,coords.y,0.0, radius+0.0)
        SetBlipSprite(blip3, 9)
        -- SetBlipSprite(blip,1)
        if color == 'red' then
            SetBlipColour(blip3,1)
        elseif color == 'green' then
            SetBlipColour(blip3,25)
        elseif color == 'blue' then
            SetBlipColour(blip3,38)
        end
        SetBlipAlpha(blip3,150)
    else
        RemoveBlip(blip3)
        blip3 = nil
    end
end)

RegisterNetEvent('event:radius3', function(toggle, coords, radius, color)
    if toggle then
        RemoveBlip(blip4)
        blip4 = nil
        blip4 = AddBlipForRadius(coords.x,coords.y,0.0, radius+0.0)
        SetBlipSprite(blip4, 9)
        -- SetBlipSprite(blip,1)
        if color == 'red' then
            SetBlipColour(blip4,1)
        elseif color == 'green' then
            SetBlipColour(blip4,25)
        elseif color == 'blue' then
            SetBlipColour(blip4,38)
        end
        SetBlipAlpha(blip4,200)
    else
        RemoveBlip(blip4)
        blip4 = nil
    end
end)

RegisterNetEvent('event:blip', function(toggle, coords)
    if toggle then
        RemoveBlip(blip2)
        blip2 = nil
        blip2 = AddBlipForCoord(coords)
        SetBlipSprite(blip2, 568)
        SetBlipColour(blip2, 1)
        SetBlipScale(blip2, 0.8)
    else
        RemoveBlip(blip2)
        blip2 = nil
    end
end)

RegisterNetEvent('MRFW:Client:OnPlayerUnload', function()
    blip = nil
    blip2 = nil
    blip3 = nil
    blip4 = nil
    timeleft = 0
end)

RegisterNetEvent('MRFW:Client:OnPlayerLoaded', function()
    TriggerServerEvent('event:radius:s')
    TriggerServerEvent('event:radius:s2')
    TriggerServerEvent('event:radius:s3')
    TriggerServerEvent('event:seconds:s')
end)

RegisterNetEvent('event:seconds', function(sec)
    timeleft = sec
end)

RegisterNetEvent('event:stash', function()
    TriggerEvent("inventory:client:SetCurrentStash", "event-hotdrop")
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "event-hotdrop", {
        maxweight = 2000000,
        slots = 25,
    })
end)

Citizen.CreateThread(function()
    while true do
        if timeleft > 0 then
            Citizen.Wait(5)
            Text('(~y~Remaining Time~w~: ~r~'..SecondsToClock(timeleft)..'~w~)', 4, 0.40, 0.829, 0.965)
        else
            Citizen.Wait(500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if timeleft > 0 then
            timeleft = timeleft - 1
        end
        Citizen.Wait(1000)
    end
end)