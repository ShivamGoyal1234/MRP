local AJFW = exports['ajfw']:GetCoreObject()

RegisterServerEvent('aj-rentals:server:depositpayout', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    Player.Functions.AddMoney('bank', Config.Deposit)
end)

RegisterServerEvent('aj-rental:rentalpapers')
AddEventHandler('aj-rental:rentalpapers', function(plate, model, money)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local info = {}
    info.citizenid = Player.PlayerData.citizenid
    info.firstname = Player.PlayerData.charinfo.firstname
    info.lastname = Player.PlayerData.charinfo.lastname
    info.plate = plate
    info.model = model
    TriggerClientEvent('inventory:client:ItemBox', src,  AJFW.Shared.Items["rentalpapers"], 'add')
    Player.Functions.AddItem('rentalpapers', 1, false, info)
    Player.Functions.RemoveMoney('bank', money, "vehicle-rental")
end)


RegisterServerEvent('aj-rental:removepapers')
AddEventHandler('aj-rental:removepapers', function(plate, model, money)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    TriggerClientEvent('inventory:client:ItemBox', src,  AJFW.Shared.Items["rentalpapers"], 'remove')
    Player.Functions.RemoveItem('rentalpapers', 1, false, info)
end)


RegisterNetEvent('aj-rentals:server:healthcheck')
AddEventHandler('aj-rentals:server:healthcheck', function(health)
    local src = source
    local charges = Config.Repaircost
    local Player = AJFW.Functions.GetPlayer(src)
    local bankBalance = Player.PlayerData.money["bank"]
    if health <= Config.Damage then 
            TriggerClientEvent("AJFW:Notify", src, "The car seems damaged you are being charged $"..Config.Repaircost.." for the repairs.", "error", 5000)
            Player.Functions.RemoveMoney("bank", Config.Repaircost , "Vehicle has been sent for repairs.")
    elseif health <= Config.Damage2 and Config.Repair2 then
        TriggerClientEvent("AJFW:Notify", src, "The car seems damaged you are being charged $"..Config.Repaircost2.." for the repairs.", "error", 5000)
        Player.Functions.RemoveMoney("bank", Config.Repaircost2 , "Vehicle has been sent for repairs.")
    end
end)



