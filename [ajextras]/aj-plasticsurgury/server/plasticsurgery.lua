-- AJFW = nil

-- TriggerEvent('AJFW:GetObject', function(obj) AJFW = obj end)

RegisterServerEvent('aj-plasticsurgery:surgery')
AddEventHandler('aj-plasticsurgery:surgery', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    Player.Functions.RemoveItem('surgerypass', 1)
   
    TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['surgerypass'], "remove")
end)