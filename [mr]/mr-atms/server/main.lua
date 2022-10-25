local dailyWithdraws = {}
local MRFW = exports['mrfw']:GetCoreObject()

-- Thread

CreateThread(function()
    while true do
        Wait(3600000)
        dailyWithdraws = {}
        TriggerClientEvent('MRFW:Notify', -1, "Daily Withdraw Limit Reset", "success")
    end
end)

-- Command
if not Config.UseTarget then
RegisterCommand('atm', function(source)
    local src = source
    local xPlayer = MRFW.Functions.GetPlayer(src)
    local visas = xPlayer.Functions.GetItemsByName('visa')
    local masters = xPlayer.Functions.GetItemsByName('mastercard')
    local cards = {}

    if visas ~= nil and masters ~= nil then
        for _, v in pairs(visas) do
            local info = v.info
            local cardNum = info.cardNumber
            local cardHolder = info.citizenid
            local xCH = MRFW.Functions.GetPlayerByCitizenId(cardHolder)
            if xCH ~= nil then
                if xCH.PlayerData.charinfo.card ~= cardNum then
                    info.cardActive = false
                end
            else
                local player = MySQL.query.await('SELECT charinfo FROM players WHERE citizenid = ?', { info.citizenid })
                local xCH = player
                if xCH.card ~= cardNum then
                    info.cardActive = false
                end
            end
            cards[#cards+1] = v.info
        end
        for _, v in pairs(masters) do
            local info = v.info
            local cardNum = info.cardNumber
            local cardHolder = info.citizenid
            local xCH = MRFW.Functions.GetPlayerByCitizenId(cardHolder)
            if xCH ~= nil then
                if xCH.PlayerData.charinfo.card ~= cardNum then
                    info.cardActive = false
                end
            else
                local player = MySQL.query.await('SELECT charinfo FROM players WHERE citizenid = ?', { info.citizenid })
                xCH = player
                if xCH.card ~= cardNum then
                    info.cardActive = false
                end
            end
            cards[#cards+1] = v.info
        end
    end
    TriggerClientEvent('mr-atms:client:loadATM', src, cards)
end)
end
-- Event

RegisterNetEvent('mr-atms:server:enteratm',function ()
    local src = source
    local xPlayer = MRFW.Functions.GetPlayer(src)
    local visas = xPlayer.Functions.GetItemsByName('visa')
    local masters = xPlayer.Functions.GetItemsByName('mastercard')
    local cards = {}

    if visas ~= nil and masters ~= nil then
        for _, v in pairs(visas) do
            local info = v.info
            local cardNum = info.cardNumber
            local cardHolder = info.citizenid
            local xCH = MRFW.Functions.GetPlayerByCitizenId(cardHolder)
            if xCH ~= nil then
                if xCH.PlayerData.charinfo.card ~= cardNum then
                    info.cardActive = false
                end
            else
                local player = MySQL.query.await('SELECT charinfo FROM players WHERE citizenid = ?', { info.citizenid })
                local xCH = player
                if xCH.card ~= cardNum then
                    info.cardActive = false
                end
            end
            cards[#cards+1] = v.info
        end
        for _, v in pairs(masters) do
            local info = v.info
            local cardNum = info.cardNumber
            local cardHolder = info.citizenid
            local xCH = MRFW.Functions.GetPlayerByCitizenId(cardHolder)
            if xCH ~= nil then
                if xCH.PlayerData.charinfo.card ~= cardNum then
                    info.cardActive = false
                end
            else
                local player = MySQL.query.await('SELECT charinfo FROM players WHERE citizenid = ?', { info.citizenid })
                xCH = player
                if xCH.card ~= cardNum then
                    info.cardActive = false
                end
            end
            cards[#cards+1] = v.info
        end
    end
    TriggerClientEvent('mr-atms:client:loadATM', src, cards)
end)

RegisterNetEvent('mr-atms:server:doAccountWithdraw', function(data)
    if data ~= nil then
        local src = source
        local xPlayer = MRFW.Functions.GetPlayer(src)
        local cardHolder = data.cid
        local xCH = MRFW.Functions.GetPlayerByCitizenId(cardHolder)

        if not dailyWithdraws[cardHolder] then
            dailyWithdraws[cardHolder] = 0
        end

        local dailyWith = tonumber(dailyWithdraws[cardHolder]) + tonumber(data.amount)

        if dailyWith < Config.DailyLimit then
            local banking = {}
            if xCH ~= nil then
                local bank = xCH.Functions.GetMoney('bank')
                local bankCount = xCH.Functions.GetMoney('bank') - tonumber(data.amount)
                if bankCount > 0 then
                    xCH.Functions.RemoveMoney('bank', tonumber(data.amount))
                    xPlayer.Functions.AddMoney('cash', tonumber(data.amount))
                    dailyWithdraws[cardHolder] = dailyWithdraws[cardHolder] + tonumber(data.amount)
                    TriggerClientEvent('MRFW:Notify', src, "Withdraw $" .. data.amount .. ' from credit card. Daily Withdraws: ' .. dailyWithdraws[cardHolder], "success")
                else
                    TriggerClientEvent('MRFW:Notify', src, "Not Enough Money", "error")
                end

                banking['online'] = true
                banking['name'] = xCH.PlayerData.charinfo.firstname .. ' ' .. xCH.PlayerData.charinfo.lastname
                banking['bankbalance'] = xCH.Functions.GetMoney('bank')
                banking['accountinfo'] = xCH.PlayerData.charinfo.account
                banking['cash'] = xPlayer.Functions.GetMoney('cash')
            else
                local player = MySQL.query.await('SELECT * FROM players WHERE citizenid = ?', { cardHolder })
                local xCH = json.decode(player[1])
                local bankCount = tonumber(xCH.money.bank) - tonumber(data.amount)
                if bankCount > 0  then
                    xPlayer.Functions.AddMoney('cash', tonumber(data.amount))
                    xCH.money.bank = bankCount
                    MySQL.update('UPDATE players SET money = ? WHERE citizenid = ?', { xCH.money, cardHolder })
                    dailyWithdraws[cardHolder] = dailyWithdraws[cardHolder] + tonumber(data.amount)
                    TriggerClientEvent('MRFW:Notify', src, "Withdraw $" .. data.amount .. ' from credit card. Daily Withdraws: ' .. dailyWithdraws[cardHolder], "success")
                else
                    TriggerClientEvent('MRFW:Notify', src, "Not Enough Money", "error")
                end

                banking['online'] = false
                banking['name'] = xCH.charinfo.firstname .. ' ' .. xCH.charinfo.lastname
                banking['bankbalance'] = xCH.money.bank
                banking['accountinfo'] = xCH.charinfo.account
                banking['cash'] = xPlayer.Functions.GetMoney('cash')
            end
            TriggerClientEvent('mr-atms:client:updateBankInformation', src, banking)
        else
            TriggerClientEvent('MRFW:Notify', src, "You have reached the daily limit", "error")
        end
    end
end)

-- Callbacks

MRFW.Functions.CreateCallback('mr-debitcard:server:requestCards', function(source, cb)
    local src = source
    local xPlayer = MRFW.Functions.GetPlayer(src)
    local visas = xPlayer.Functions.GetItemsByName('visa')
    local masters = xPlayer.Functions.GetItemsByName('mastercard')
    local cards = {}

    if visas ~= nil and masters ~= nil then
        for _, v in visas do
            cards[#cards+1] = v.info
        end
        for _, v in masters do
            cards[#cards+1] = v.info
        end
    end
    return cards
end)

MRFW.Functions.CreateCallback('mr-debitcard:server:deleteCard', function(source, cb, data)
    local cn = data.cardNumber
    local ct = data.cardType
    local src = source
    local xPlayer = MRFW.Functions.GetPlayer(src)
    local found = xPlayer.Functions.GetCardSlot(cn, ct)
    if found ~= nil then
        xPlayer.Functions.RemoveItem(ct, 1, found)
        cb(true)
    else
        cb(false)
    end
end)

MRFW.Functions.CreateCallback('mr-atms:server:loadBankAccount', function(source, cb, cid, cardnumber)
    local src = source
    local xPlayer = MRFW.Functions.GetPlayer(src)
    local cardHolder = cid
    local xCH = MRFW.Functions.GetPlayerByCitizenId(cardHolder)
    local banking = {}
    if xCH ~= nil then
        banking['online'] = true
        banking['name'] = xCH.PlayerData.charinfo.firstname .. ' ' .. xCH.PlayerData.charinfo.lastname
        banking['bankbalance'] = xCH.Functions.GetMoney('bank')
        banking['accountinfo'] = xCH.PlayerData.charinfo.account
        banking['cash'] = xPlayer.Functions.GetMoney('cash')
    else
        local player = MySQL.query.await('SELECT * FROM players WHERE citizenid = ?', { cardHolder })
        local xCH = json.decode(player[1])
        banking['online'] = false
        banking['name'] = xCH.charinfo.firstname .. ' ' .. xCH.charinfo.lastname
        banking['bankbalance'] = xCH.money.bank
        banking['accountinfo'] = xCH.charinfo.account
        banking['cash'] = xPlayer.Functions.GetMoney('cash')
    end
    cb(banking)
end)
