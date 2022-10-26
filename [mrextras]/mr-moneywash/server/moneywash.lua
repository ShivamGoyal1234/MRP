-- MRFW = nil
-- TriggerEvent('MRFW:GetObject', function(obj) MRFW = obj end)

local tpLocatio = {

    ['FirstMoneyWash'] = {
        ['Enter'] = { 
            ['x'] = 121.23, 
            ['y'] = -2468.87, 
            ['z'] = 6.1
        },
        ['Exit'] = {
            ['x'] = 1138.0439453125, 
            ['y'] = -3199.1455078125, 
            ['z'] = -39.6657371521
        },
    },
   
}

passwor = 'sabghostkigaltihai'

local target = vector3(121.23, -2468.87, 6.1)

MRFW.Functions.CreateCallback('jacob:get:wash', function(source, cb)
    cb(tpLocatio, passwor, target)
end)

MRFW.Functions.CreateCallback('mr-moneywash:server:checkWash', function(source, cb)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local blackmoney = Player.Functions.GetItemByName("blackmoney")
    local tamount = 0
	
    for k, v in pairs(Player.PlayerData.items) do 
        if Player.PlayerData.items[k] ~= nil then 
            if Player.PlayerData.items[k].name == "blackmoney" then 
                tamount = Player.PlayerData.items[k].amount
            end
        end
    end
    if blackmoney ~= nil  then
        cb(true,tamount)
    else
       cb(false,nil)
    end
end)

RegisterServerEvent("mr-moneywash:server:getItem")
AddEventHandler("mr-moneywash:server:getItem", function(amt)
    local src = source
	local Player = MRFW.Functions.GetPlayer(src)
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k] ~= nil then 
                if Player.PlayerData.items[k].name == "blackmoney" then 
                    blackCount = Player.PlayerData.items[k].amount
                end
            end
        end
        
		TriggerClientEvent('MRFW:Notify', src, "You have "..blackCount.. " black money notes ")
	end
end)


RegisterNetEvent("mr-moneywash:server:checkInv")
AddEventHandler("mr-moneywash:server:checkInv", function()
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)

        if Player.Functions.GetItemByName('blackmoney') ~= nil then
            local amt = Player.Functions.GetItemByName('blackmoney').amount
            TriggerClientEvent('mr-moneywash:client:startTimer', src, amt)
            TriggerClientEvent('MRFW:Notify', src, 'You put the black money in the washer.', 'success')
            Player.Functions.RemoveItem('blackmoney', amt)
 
        else
            TriggerClientEvent('MRFW:Notify', src, 'You have no black money.', 'error') 
        end

end)

RegisterServerEvent("mr-moneywash:server:giveMoney")
AddEventHandler("mr-moneywash:server:giveMoney", function(amt)
    
  
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    Player.Functions.AddMoney("cash", amt)
	TriggerClientEvent('MRFW:Notify', src, "You have received your white money with 20% deduction fee of washing")

end)


MRFW.Functions.CreateUseableItem("blackkey", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
    TriggerClientEvent("JcaobMoneyWash", source)
end)