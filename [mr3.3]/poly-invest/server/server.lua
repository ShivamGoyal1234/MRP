--------------------------------------------------
-- 				Don't edit anything here		--
--				  Recreated by Polygon			--
--------------------------------------------------


Cache = {}
MRFW = exports['mrfw']:GetCoreObject()

-- Get balance of invested companies
RegisterServerEvent("invest:balance")
AddEventHandler("invest:balance", function()
    local src = source
    local xPlayer = MRFW.Functions.GetPlayer(src)
    local id = xPlayer.PlayerData.citizenid
    local user = MySQL.Sync.fetchAll('SELECT amount FROM invest WHERE identifier= ? AND active=1', {id})
    local invested = 0
    for k, v in pairs(user) do
        -- print(k, v.identifier, v.amount, v.job)
        invested = invested + v.amount
    end
    TriggerClientEvent("invest:nui", src, {
        type = "balance",
        player = GetPlayerName(src),
        balance = invested
    })
end)

-- Get available companies
RegisterServerEvent("invest:list")
AddEventHandler("invest:list", function()
    TriggerClientEvent("invest:nui", source, {
        type = "list",
        cache = Cache
    })
end)

-- Get all invested companies
RegisterServerEvent("invest:all")
AddEventHandler("invest:all", function(special)
    local src = source
    local xPlayer = MRFW.Functions.GetPlayer(src)
    local sql = 'SELECT invest.*, companies.name,companies.investRate,companies.label FROM invest '..
                'INNER JOIN companies ON invest.job = companies.label '..
                'WHERE invest.identifier=?'

    if(special) then 
        sql = sql .. " AND invest.active=1"
    end

    local id = xPlayer.PlayerData.citizenid
    local user =  MySQL.Sync.fetchAll(sql, {id})

    -- for k, v in pairs(user) do
    --     print(k, v.identifier, v.amount, v.job, v.name, v.active, v.created, v.investRate)
    -- end

    if(special) then
        TriggerClientEvent("invest:nui", src, {
            type = "sell",
            cache = user
        })
    else 
        TriggerClientEvent("invest:nui", src, {
            type = "all",
            cache = user
        })
    end
end)

-- Invest into a job
RegisterServerEvent("invest:buy")
AddEventHandler("invest:buy", function(job, amount, rate)
    local src = source
    local xPlayer = MRFW.Functions.GetPlayer(src)
    local bank = xPlayer.PlayerData.money["bank"]
    local id = xPlayer.PlayerData.citizenid
    amount = tonumber(amount)

    local inf = MySQL.Sync.fetchAll('SELECT * FROM invest WHERE identifier=? AND active=1 AND job=? LIMIT 1', {id, job})
    for k, v in pairs(inf) do inf = v end

    if(amount == nil or amount <= 0) then
        return TriggerClientEvent('MRFW:Notify', src, _U('invalid_amount'), 'error')
    elseif(Config.Stock.Limit ~= 0 and amount > Config.Stock.Limit) then
        return TriggerClientEvent('MRFW:Notify', src, string.gsub(_U('to_much'), "{limit}", format_int(Config.Stock.Limit)), 'error')
    else
        if(bank < amount) then
            return TriggerClientEvent('MRFW:Notify', src, _U('broke_amount'), 'error')
        end
        xPlayer.Functions.RemoveMoney('bank', amount)
        TriggerEvent("mr-log:server:CreateLog", "stocks", "Invested", "green", "**"..GetPlayerName(src) .. "** has invested $"..amount.." in stocks")
    end

    if(type(inf) == "table" and inf.job ~= nil) then
        if Config.Debug then
            print("Adding money to an existing investment")
        end

        MySQL.Async.execute("UPDATE invest SET amount=amount+? WHERE identifier=? AND active=1 AND job=?", {amount,id,job})
        
        TriggerClientEvent('MRFW:Notify', src, _U('added'), 'success')
    else
        if Config.Debug then
            print("User new investment")
        end

        if rate == nil then
            return TriggerClientEvent('MRFW:Notify', src, _U('unexpected_error'), 'error')
        end

        MySQL.Async.insert("INSERT INTO invest (identifier, job, amount, rate) VALUES (?, ?, ?, ?)", {
            id,
            job,
            amount,
            rate
        })
        
        TriggerClientEvent('MRFW:Notify', src, _U('buy'), 'success')
    end

    TriggerEvent(src, "invest:balance")
end)

-- Sell an investment
RegisterServerEvent("invest:sell")
AddEventHandler("invest:sell", function(job)
    local src = source
    local xPlayer = MRFW.Functions.GetPlayer(src)

    local id = xPlayer.PlayerData.citizenid

    local result = MySQL.Sync.fetchAll( 'SELECT invest.*, companies.investRate FROM invest '..
                                            'INNER JOIN companies ON invest.job = companies.label '..
                                            'WHERE identifier=? AND active=1 AND job=?', {id,job})
    for k, v in pairs(result) do result = v end

    local amount = result.amount
    local sellRate = math.abs(result.investRate - result.rate)
    local addMoney = amount + ((amount * sellRate) / 100)

    
    -- print("intrest calc: " .. result.investRate .. " -> " .. result.rate .. " = " .. sellRate)
    -- print("money calc: " .. amount .. " -> " .. addMoney)

    MySQL.Async.execute("UPDATE invest SET active=0, sold=now(), soldAmount=?, rate=? WHERE id=?", {addMoney, sellRate, result.id})

    if(addMoney > 0) then
        xPlayer.Functions.AddMoney('bank', addMoney)
        TriggerEvent("mr-log:server:CreateLog", "stocks", "Sold", "blue", "**"..GetPlayerName(src) .. "** has sold his stocks for $"..addMoney.." ")
    else
        addMoney = math.abs(addMoney)*-1
        xPlayer.Functions.RemoveMoney('bank', addMoney)
        TriggerEvent("mr-log:server:CreateLog", "stocks", "Lost", "red", "**"..GetPlayerName(src) .. "** has lost his $"..addMoney.." in stocks ")
    end
    
    TriggerClientEvent('MRFW:Notify', src, _U('sold'), 'success')
    TriggerEvent(src, "invest:balance")
end)

-- Gives a random number
function genRand(min, max, decimalPlaces)
    local rand = math.random()*(max-min) + min;
    local power = math.pow(10, decimalPlaces);
    return math.floor(rand*power) / power;
end

-- Loop invest rates
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    function loopUpdate()
        Citizen.Wait(60000*Config.Stock.Time)

        if Config.Debug then
            print("Creating new investments")
        end

        local companies = MySQL.Sync.fetchAll("SELECT * FROM companies")
        for k, v in pairs(companies) do
            newRate = genRand(Config.Stock.Minimum, Config.Stock.Maximum, 2)

            local rate = "stale"
            if newRate > v.investRate then
                rate = "up"
            elseif newRate < v.investRate then
                rate = "down"
            end

            if(Config.Stock.Lost ~= 0 and newRate < 0) then
                MySQL.Async.execute("UPDATE invest SET amount=(amount/100*(100-?)) WHERE active=1 AND job=?", {
                    Config.Stock.Lost,
                    v.label
                })
            end

            
            MySQL.Async.execute("UPDATE companies SET investRate=?, rate=? WHERE label=?", {
                newRate,
                rate,
                v.label
            })
            Cache[v.label] = {stock = newRate, rate = rate, label = v.label, name = v.name}
        end
        loopUpdate()
    end

    Citizen.Wait(0) --Don't remove, crashes SQL

    if Config.Debug then
        print("Powering Up")
    end

    local companies = MySQL.Sync.fetchAll("SELECT * FROM companies")
    for k, v in pairs(companies) do
        if(v.investRate == nil) then
            v.investRate = genRand(Config.Stock.Minimum, Config.Stock.Maximum, 2)

            MySQL.Async.execute("UPDATE companies SET investRate=? WHERE label=?", {
                v.investRate,
                v.label
            })
        end

        Cache[v.label] = {stock = v.investRate, rate = v.rate, label = v.label, name = v.name}
    end
    loopUpdate()
end)

function format_int(number)
    local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')
    int = int:reverse():gsub("(%d%d%d)", "%1,")
    return minus .. int:reverse():gsub("^,", "") .. fraction
end

-- v1.2 >
-- print(genRand(0, 2, 2)) -- from 0.00 to 2.00
-- print(genRand(1, 2, 2)) -- from 1.00 to 2.00

-- v1.2 <
-- print(genRand(-5, 5, 2)) -- from -5% to 5%
-- print(math.abs(-1 - -2.95)) -- difference between -1% and -2.95%