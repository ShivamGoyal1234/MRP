-- MRFW = nil

-- TriggerEvent('MRFW:GetObject', function(obj) MRFW = obj end)

RegisterServerEvent('mr-plasticsurgery:surgery')
AddEventHandler('mr-plasticsurgery:surgery', function()
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    Player.Functions.RemoveItem('surgerypass', 1)
   
    TriggerClientEvent("inventory:client:ItemBox", source, MRFW.Shared.Items['surgerypass'], "remove")
end)