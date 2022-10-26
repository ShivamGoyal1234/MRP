local function HideText(types)
    -- print('[HideText ]'..types)
    SendNUIMessage({
        action = 'HIDE_TEXT',
        type = types
    })
end

local function DrawText(text,r,g,b,aa,types,top,position)
    -- print('[Drawtext ]'..text,r,g,b,aa,types,top)
    if (not type(position) == "string") then position = "left" end
    SendNUIMessage({
        action = 'DRAW_TEXT',
        data = {
            text = text,
            position = position
        },
        r = r,
        g = g,
        b = b,
        a = aa,
        type = types,
        top = top
    })
end


local function ChangeText(text,r,g,b,aa,types,top,position)
    if (not type(position) == "string") then position = "left" end
    -- print('[ChangeText ]'..text,r,g,b,aa,types,top)
    SendNUIMessage({
        action = 'CHANGE_TEXT',
        data = {
            text = text,
            position = position
        },
        r = r,
        g = g,
        b = b,
        a = aa,
        type = types,
        top = top
    })
end

local function KeyPressed()
    Citizen.CreateThread(function() -- Not sure if a thread is needed but why not eh?
        SendNUIMessage({
            action = 'KEY_PRESSED',
        })
        Wait(500)
        HideText()
    end)
end

RegisterNetEvent('mr-text:client:DrawText', function(text, position,r,g,b,a)
    DrawText(text, position,r,g,b,a)
end)

RegisterNetEvent('mr-text:client:ChangeText', function(text, position)
    ChangeText(text, position)
end)

RegisterNetEvent('mr-text:client:HideText', function()
    HideText()
end)

RegisterNetEvent('mr-text:client:KeyPressed', function()
    KeyPressed()
end)

exports('DrawText', DrawText)
exports('ChangeText', ChangeText)
exports('HideText', HideText)
exports('KeyPressed', KeyPressed)