-- AJFW = nil
-- TriggerEvent('AJFW:GetObject', function(obj) AJFW = obj end)

RegisterServerEvent('aj-grandmas:server:HealSomeShit')
AddEventHandler('aj-grandmas:server:HealSomeShit', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)

    if TriggerClientEvent("AJFW:Notify", src, "You Were Billed For $4,000 For Medical Services & Expenses", "Success", 8000) then
        Player.Functions.RemoveMoney('bank', 4000) 
    end
end)