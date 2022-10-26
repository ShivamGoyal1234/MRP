-- MRFW = nil
-- TriggerEvent('MRFW:GetObject', function(obj) MRFW = obj end)

RegisterServerEvent('mr-grandmas:server:HealSomeShit')
AddEventHandler('mr-grandmas:server:HealSomeShit', function()
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)

    if TriggerClientEvent("MRFW:Notify", src, "You Were Billed For $4,000 For Medical Services & Expenses", "Success", 8000) then
        Player.Functions.RemoveMoney('bank', 4000) 
    end
end)