local nbrDisplaying = 0

local function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function Display(mePlayer, text)
    local displaying = true
    CreateThread(function()
        Wait(5000)
        displaying = false
    end)
    CreateThread(function()
        local offset = 0 + (nbrDisplaying*0.14)
        nbrDisplaying = nbrDisplaying + 1
        while displaying do
            sleep = 1000
            local coordsMe = GetEntityCoords(GetPlayerPed(mePlayer), false)
            local coords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist2(coordsMe, coords)
            if dist < 250 then
                sleep = 5
                DrawText3Ds(coordsMe['x'], coordsMe['y'], coordsMe['z'] + offset, text, 1)
            end
            Wait(sleep)
        end
        nbrDisplaying = nbrDisplaying - 1
    end)
end

RegisterNetEvent('3dme:triggerDisplay')
AddEventHandler('3dme:triggerDisplay', function(text, source, coords)
    local pedPos = GetEntityCoords(PlayerPedId())
    if #(pedPos - coords) <= 10.0 then
        Display(GetPlayerFromServerId(source), text)
    end
end)