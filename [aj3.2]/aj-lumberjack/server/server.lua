local AJFW = exports['ajfw']:GetCoreObject()
local Chopped = false

RegisterNetEvent('aj-lumberjack:sellItems', function()
    local source = source
    local price = 0
    local Player = AJFW.Functions.GetPlayer(source)
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then
        for k, v in pairs(Player.PlayerData.items) do
            if Player.PlayerData.items[k] ~= nil then
                if Config.Sell[Player.PlayerData.items[k].name] ~= nil then
                    price = price + (Config.Sell[Player.PlayerData.items[k].name].price * Player.PlayerData.items[k].amount)
                    Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k)
                    TriggerClientEvent('inventory:client:ItemBox', source, AJFW.Shared.Items[Player.PlayerData.items[k].name], "remove")
                end
            end
        end
        Player.Functions.AddMoney("cash", price)
        TriggerClientEvent('AJFW:Notify', source, Config.Alerts["successfully_sold"])
    else 
		TriggerClientEvent('AJFW:Notify', source, Config.Alerts["error_sold"])
	end
end)

RegisterNetEvent('aj-lumberjack:BuyAxe', function()
    local source = source
    local Player = AJFW.Functions.GetPlayer(tonumber(source))
    local TRAxeClassicPrice = LumberJob.AxePrice
    local axe = Player.Functions.GetItemByName('weapon_battleaxe')
    if not axe then
        Player.Functions.AddItem('weapon_battleaxe', 1)
        TriggerClientEvent('inventory:client:ItemBox', source, AJFW.Shared.Items['weapon_battleaxe'], "add")
        Player.Functions.RemoveMoney("cash", TRAxeClassicPrice)
        TriggerClientEvent('AJFW:Notify', source, Config.Alerts["axe_bought"])
    elseif axe then
        TriggerClientEvent('AJFW:Notify', source, Config.Alerts["axe_check"])
    end
end)

AJFW.Functions.CreateCallback('aj-lumberjack:axe', function(source, cb)
    local Player = AJFW.Functions.GetPlayer(source)
    if Player ~= nil then
        if Player.Functions.GetItemByName("weapon_battleaxe") ~= nil then
            cb(true)
        else
            cb(false)
        end
    end
end)

RegisterNetEvent('aj-lumberjack:setLumberStage', function(stage, state, k)
    Config.TreeLocations[k][stage] = state
    TriggerClientEvent('aj-lumberjack:getLumberStage', -1, stage, state, k)
end)

RegisterNetEvent('aj-lumberjack:setChoppedTimer', function()
    if not Chopped then
        Chopped = true
        CreateThread(function()
            Wait(Config.Timeout)
            for k, v in pairs(Config.TreeLocations) do
                Config.TreeLocations[k]["isChopped"] = false
                TriggerClientEvent('aj-lumberjack:getLumberStage', -1, 'isChopped', false, k)
            end
            Chopped = false
        end)
    end
end)

RegisterServerEvent('aj-lumberjack:recivelumber', function()
    local source = source
    local Player = AJFW.Functions.GetPlayer(tonumber(source))
    local lumber = math.random(LumberJob.LumberAmount_Min, LumberJob.LumberAmount_Max)
    local bark = math.random(LumberJob.TreeBarkAmount_Min, LumberJob.TreeBarkAmount_Max)
    Player.Functions.AddItem('tree_lumber', lumber)
    TriggerClientEvent('inventory:client:ItemBox', source, AJFW.Shared.Items['tree_lumber'], "add", lumber)
    Player.Functions.AddItem('tree_bark', bark)
    TriggerClientEvent('inventory:client:ItemBox', source, AJFW.Shared.Items['tree_bark'], "add", bark)
end)

AJFW.Functions.CreateCallback('aj-lumberjack:lumber', function(source, cb)
    local Player = AJFW.Functions.GetPlayer(source)
    if Player ~= nil then
        if Player.Functions.GetItemByName("tree_lumber") ~= nil then
            cb(true)
        else
            cb(false)
        end
    end
end)

RegisterServerEvent('aj-lumberjack:lumberprocessed', function()
    local source = source
    local Player = AJFW.Functions.GetPlayer(tonumber(source))
    local lumber = Player.Functions.GetItemByName('tree_lumber')
    local TradeAmount = math.random(LumberJob.TradeAmount_Min, LumberJob.TradeAmount_Max)
    local TradeRecevied = math.random(LumberJob.TradeRecevied_Min, LumberJob.TradeRecevied_Max)
    if not lumber then 
        TriggerClientEvent('AJFW:Notify', source, Config.Alerts['error_lumber'])
        return false
    end

    local amount = lumber.amount
    if amount >= 1 then
        amount = TradeAmount
    else
      return false
    end
    
    if not Player.Functions.RemoveItem('tree_lumber', amount) then 
        TriggerClientEvent('AJFW:Notify', source, Config.Alerts['itemamount'])
        return false 
    end

    TriggerClientEvent('inventory:client:ItemBox', source, AJFW.Shared.Items['tree_lumber'], "remove")
    TriggerClientEvent('AJFW:Notify', source, Config.Alerts["lumber_processed_trade"] ..TradeAmount.. Config.Alerts["lumber_processed_lumberamount"] ..TradeRecevied.. Config.Alerts["lumber_processed_received"])
    Wait(750)
    Player.Functions.AddItem('wood_plank', TradeRecevied)
    TriggerClientEvent('inventory:client:ItemBox', source, AJFW.Shared.Items['wood_plank'], "add", TradeRecevied)
end)