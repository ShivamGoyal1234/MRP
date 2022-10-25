--[[Citizen.CreateThread(function()
    local blip = AddBlipForCoord(243.63, -1078.53, 29.29)
	SetBlipSprite(blip, 304)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.6)
	SetBlipAsShortRange(blip, true)
	SetBlipColour(blip, 5)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName("Court of Justice")
    EndTextCommandSetBlipName(blip)
end)]]

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(-530.19, -173.02, 38.22)
	SetBlipSprite(blip, 304)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.6)
	SetBlipAsShortRange(blip, true)
	SetBlipColour(blip, 5)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName("Court of Justice")
    EndTextCommandSetBlipName(blip)
end)

RegisterNetEvent("aj-justice:client:showLawyerLicense")
AddEventHandler("aj-justice:client:showLawyerLicense", function(sourceId, data)
    local sourcePos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(sourceId)), false)
    local pos = GetEntityCoords(PlayerPedId(), false)
    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true) < 2.0) then
        TriggerEvent('chat:addMessage', {
            template = '<div class="chat-message advert"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>Pass-ID:</strong> {1} <br><strong>First Name:</strong> {2} <br><strong>Last Name:</strong> {3} <br><strong>CSN:</strong> {4} </div></div>',
            args = {'Advocate pass', data.id, data.firstname, data.lastname, data.citizenid}
        })
    end
end)

RegisterNetEvent("aj-justice:client:showMayorPass")
AddEventHandler("aj-justice:client:showMayorPass", function(sourceId, data)
    local sourcePos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(sourceId)), false)
    local pos = GetEntityCoords(PlayerPedId(), false)
    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true) < 2.0) then
        TriggerEvent('chat:addMessage', {
            template = '<div class="chat-message advert"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>Pass-ID:</strong> {1} <br><strong>First Name:</strong> {2} <br><strong>Last Name:</strong> {3} <br><strong>CSN:</strong> {4} </div></div>',
            args = {'Mayor Pass', data.id, data.firstname, data.lastname, data.citizenid}
        })
    end
end)


function DrawText3D(x, y, z, text)
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

RegisterNetEvent('covidvac:client:vaccination')
AddEventHandler('covidvac:client:vaccination', function(source)
    TriggerEvent("inventory:client:ItemBox", AJFW.Shared.Items["covidvac"], "remove")
    TriggerServerEvent("AJFW:Server:RemoveItem", "covidvac", 1)    
end)


RegisterNetEvent('DOJ:ToggleDuty', function()
    onDuty = not onDuty
    TriggerServerEvent("AJFW:ToggleDuty")
end)