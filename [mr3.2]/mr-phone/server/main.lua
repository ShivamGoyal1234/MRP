local MRFW = exports['mrfw']:GetCoreObject()
local QBPhone = {}
local Tweets = {}
local Anons = {}
local AppAlerts = {}
local MentionedTweets = {}
local Hashtags = {}
local Hashtags_dark = {}
local MentionedAnons = {}
local Calls = {}
local Adverts = {}
local GeneratedPlates = {}
local WebHook = "https://discord.com/api/webhooks/994049632516714596/CqwVGiD3BPcCTrTePn-xD4speGoXEvTcLKq--qBIv1GmGQBhC3rQBmm9lzc01QHT5d6-"
local bannedCharacters = {'%','$',';'}

local vpnPassword = 'iamnotop'

RegisterNetEvent("9d:Initialize", function()
    local src = source
    TriggerClientEvent("9d:ShowPasswordPrompt", src)
end)

RegisterNetEvent('9d:CheckPassword', function(Newpassword, attempts)
    local src = source
    if Newpassword == vpnPassword then
        TriggerClientEvent('9d:PassedPassword', src)
    elseif vpnPasswork ~= vpnPassword then
        if attempts <= 0 then
            TriggerClientEvent('9d:FailedPassword', src, true)
        else
            TriggerClientEvent("9d:ShowPasswordPrompt", src)
        end
    else
        TriggerClientEvent('9d:FailedPassword', src, false)
    end
end)


-- Functions

local function GetOnlineStatus(number)
    local Target = MRFW.Functions.GetPlayerByPhone(number)
    local retval = false
    if Target ~= nil then
        retval = true
    end
    return retval
end

local function GenerateMailId()
    return math.random(111111, 999999)
end

local function escape_sqli(source)
    local replacements = {
        ['"'] = '\\"',
        ["'"] = "\\'"
    }
    return source:gsub("['\"]", replacements)
end

local function round(num, numDecimalPlaces)
    if numDecimalPlaces and numDecimalPlaces > 0 then
        local mult = 10 ^ numDecimalPlaces
        return math.floor(num * mult + 0.5) / mult
    end
    return math.floor(num + 0.5)
end

function QBPhone.AddMentionedTweet(citizenid, TweetData)
    if MentionedTweets[citizenid] == nil then
        MentionedTweets[citizenid] = {}
    end
    MentionedTweets[citizenid][#MentionedTweets[citizenid]+1] = TweetData
end

function QBPhone.AddMentionedAnon(citizenid, AnonData)
    if MentionedAnons[citizenid] == nil then
        MentionedAnons[citizenid] = {}
    end
    MentionedAnons[citizenid][#MentionedAnons[citizenid]+1] = AnonData
end

function QBPhone.SetPhoneAlerts(citizenid, app, alerts)
    if citizenid ~= nil and app ~= nil then
        if AppAlerts[citizenid] == nil then
            AppAlerts[citizenid] = {}
            if AppAlerts[citizenid][app] == nil then
                if alerts == nil then
                    AppAlerts[citizenid][app] = 1
                else
                    AppAlerts[citizenid][app] = alerts
                end
            end
        else
            if AppAlerts[citizenid][app] == nil then
                if alerts == nil then
                    AppAlerts[citizenid][app] = 1
                else
                    AppAlerts[citizenid][app] = 0
                end
            else
                if alerts == nil then
                    AppAlerts[citizenid][app] = AppAlerts[citizenid][app] + 1
                else
                    AppAlerts[citizenid][app] = AppAlerts[citizenid][app] + 0
                end
            end
        end
    end
end

local function SplitStringToArray(string)
    local retval = {}
    for i in string.gmatch(string, "%S+") do
        retval[#retval+1] = i
    end
    return retval
end

local function GenerateOwnerName()
    local names = {
        [1] = {
            name = "Jan Bloksteen",
            citizenid = "DSH091G93"
        },
        [2] = {
            name = "Jay Dendam",
            citizenid = "AVH09M193"
        },
        [3] = {
            name = "Ben Klaariskees",
            citizenid = "DVH091T93"
        },
        [4] = {
            name = "Karel Bakker",
            citizenid = "GZP091G93"
        },
        [5] = {
            name = "Klaas Adriaan",
            citizenid = "DRH09Z193"
        },
        [6] = {
            name = "Nico Wolters",
            citizenid = "KGV091J93"
        },
        [7] = {
            name = "Mark Hendrickx",
            citizenid = "ODF09S193"
        },
        [8] = {
            name = "Bert Johannes",
            citizenid = "KSD0919H3"
        },
        [9] = {
            name = "Karel de Grote",
            citizenid = "NDX091D93"
        },
        [10] = {
            name = "Jan Pieter",
            citizenid = "ZAL0919X3"
        },
        [11] = {
            name = "Huig Roelink",
            citizenid = "ZAK09D193"
        },
        [12] = {
            name = "Corneel Boerselman",
            citizenid = "POL09F193"
        },
        [13] = {
            name = "Hermen Klein Overmeen",
            citizenid = "TEW0J9193"
        },
        [14] = {
            name = "Bart Rielink",
            citizenid = "YOO09H193"
        },
        [15] = {
            name = "Antoon Henselijn",
            citizenid = "QBC091H93"
        },
        [16] = {
            name = "Aad Keizer",
            citizenid = "YDN091H93"
        },
        [17] = {
            name = "Thijn Kiel",
            citizenid = "PJD09D193"
        },
        [18] = {
            name = "Henkie Krikhaar",
            citizenid = "RND091D93"
        },
        [19] = {
            name = "Teun Blaauwkamp",
            citizenid = "QWE091A93"
        },
        [20] = {
            name = "Dries Stielstra",
            citizenid = "KJH0919M3"
        },
        [21] = {
            name = "Karlijn Hensbergen",
            citizenid = "ZXC09D193"
        },
        [22] = {
            name = "Aafke van Daalen",
            citizenid = "XYZ0919C3"
        },
        [23] = {
            name = "Door Leeferds",
            citizenid = "ZYX0919F3"
        },
        [24] = {
            name = "Nelleke Broedersen",
            citizenid = "IOP091O93"
        },
        [25] = {
            name = "Renske de Raaf",
            citizenid = "PIO091R93"
        },
        [26] = {
            name = "Krisje Moltman",
            citizenid = "LEK091X93"
        },
        [27] = {
            name = "Mirre Steevens",
            citizenid = "ALG091Y93"
        },
        [28] = {
            name = "Joosje Kalvenhaar",
            citizenid = "YUR09E193"
        },
        [29] = {
            name = "Mirte Ellenbroek",
            citizenid = "SOM091W93"
        },
        [30] = {
            name = "Marlieke Meilink",
            citizenid = "KAS09193"
        }
    }
    return names[math.random(1, #names)]
end

-- Callbacks

MRFW.Functions.CreateCallback('mr-phone:server:GetCallState', function(source, cb, ContactData)
    local Target = MRFW.Functions.GetPlayerByPhone(ContactData.number)
    if Target ~= nil then
        if Calls[Target.PlayerData.citizenid] ~= nil then
            if Calls[Target.PlayerData.citizenid].inCall then
                -- print("false, true")
                cb(false, true)
            else
                -- print("true, true")
                cb(true, true)
            end
        else
            -- print("true, true")
            cb(true, true)
        end
    else
        -- print("false, false")
        cb(false, false)
    end
end)

MRFW.Functions.CreateCallback('mr-phone:server:GetPhoneData', function(source, cb)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player ~= nil then
        local PhoneData = {
            Applications = {},
            PlayerContacts = {},
            MentionedTweets = {},
            Chats = {},
            Hashtags = {},
            Hashtags_dark = {},
            Invoices = {},
            Garage = {},
            Mails = {},
            Adverts = {},
            CryptoTransactions = {},
            Tweets = {},
            Anons = {},
            Images = {},
            InstalledApps = Player.PlayerData.metadata["phonedata"].InstalledApps
        }
        PhoneData.Adverts = Adverts

        local result = MySQL.query.await('SELECT * FROM player_contacts WHERE citizenid = ? ORDER BY name ASC', {Player.PlayerData.citizenid})
        local Contacts = {}
        if result[1] ~= nil then
            for k, v in pairs(result) do
                v.status = GetOnlineStatus(v.number)
            end

            PhoneData.PlayerContacts = result
        end

        local invoices = MySQL.query.await('SELECT * FROM phone_invoices WHERE citizenid = ?', {Player.PlayerData.citizenid})
        if invoices[1] ~= nil then
            for k, v in pairs(invoices) do
                local Ply = MRFW.Functions.GetPlayerByCitizenId(v.sender)
                if Ply ~= nil then
                    v.number = Ply.PlayerData.charinfo.phone
                else
                    local res = MySQL.query.await('SELECT * FROM players WHERE citizenid = ?', {v.sender})
                    if res[1] ~= nil then
                        res[1].charinfo = json.decode(res[1].charinfo)
                        v.number = res[1].charinfo.phone
                    else
                        v.number = nil
                    end
                end
            end
            PhoneData.Invoices = invoices
        end

        local garageresult = MySQL.query.await('SELECT * FROM player_vehicles WHERE citizenid = ?', {Player.PlayerData.citizenid})
        if garageresult[1] ~= nil then
            for k, v in pairs(garageresult) do
                local vehicleModel = v.vehicle
                if (MRFW.Shared.Vehicles[vehicleModel] ~= nil) and (Garages[v.garage] ~= nil) then
                    v.garage = Garages[v.garage].label
                    v.vehicle = MRFW.Shared.Vehicles[vehicleModel].name
                    v.brand = MRFW.Shared.Vehicles[vehicleModel].brand
                end

            end
            PhoneData.Garage = garageresult
        end

        local messages = MySQL.query.await('SELECT * FROM phone_messages WHERE citizenid = ?', {Player.PlayerData.citizenid})
        if messages ~= nil and next(messages) ~= nil then
            PhoneData.Chats = messages
        end

        if AppAlerts[Player.PlayerData.citizenid] ~= nil then
            PhoneData.Applications = AppAlerts[Player.PlayerData.citizenid]
        end

        if MentionedTweets[Player.PlayerData.citizenid] ~= nil then
            PhoneData.MentionedTweets = MentionedTweets[Player.PlayerData.citizenid]
        end

        if MentionedAnons[Player.PlayerData.citizenid] ~= nil then
            PhoneData.MentionedAnons = MentionedAnons[Player.PlayerData.citizenid]
        end

        if Hashtags ~= nil and next(Hashtags) ~= nil then
            PhoneData.Hashtags = Hashtags
        end

        if Hashtags_dark ~= nil and next(Hashtags_dark) ~= nil then
            PhoneData.Hashtags = Hashtags_dark
        end

        local Tweets = MySQL.query.await('SELECT * FROM phone_tweets WHERE `date` > NOW() - INTERVAL ? hour', {Config.TweetDuration})
        local Anons = MySQL.query.await('SELECT * FROM phone_anons WHERE `date` > NOW() - INTERVAL ? hour', {Config.DarkWebDuration})

        if Tweets ~= nil and next(Tweets) ~= nil then
            PhoneData.Tweets = Tweets
        end
        if Anons ~= nil and next(Anons) ~= nil then
            PhoneData.Anons = Anons
            DNData = Anons
        end

        local mails = MySQL.query.await('SELECT * FROM player_mails WHERE citizenid = ? ORDER BY `date` ASC', {Player.PlayerData.citizenid})
        if mails[1] ~= nil then
            for k, v in pairs(mails) do
                if mails[k].button ~= nil then
                    mails[k].button = json.decode(mails[k].button)
                end
            end
            PhoneData.Mails = mails
        end

        local transactions = MySQL.query.await('SELECT * FROM crypto_transactions WHERE citizenid = ? ORDER BY `date` ASC', {Player.PlayerData.citizenid})
        if transactions[1] ~= nil then
            for _, v in pairs(transactions) do
                PhoneData.CryptoTransactions[#PhoneData.CryptoTransactions+1] = {
                    TransactionTitle = v.title,
                    TransactionMessage = v.message
                }
            end
        end
        local images = MySQL.query.await('SELECT * FROM phone_gallery WHERE citizenid = ? ORDER BY `date` DESC',{Player.PlayerData.citizenid})
        if images ~= nil and next(images) ~= nil then
            PhoneData.Images = images
        end
        cb(PhoneData)
    end
end)

MRFW.Functions.CreateCallback('mr-phone:server:PayInvoice', function(source, cb, society, amount, invoiceId, sendercitizenid)
    local Invoices = {}
    local Ply = MRFW.Functions.GetPlayer(source)
    local SenderPly = MRFW.Functions.GetPlayerByCitizenId(sendercitizenid)
    local invoiceMailData = {}
    if SenderPly and Config.BillingCommissions[society] then
        local commission = round(amount * Config.BillingCommissions[society])
        SenderPly.Functions.AddMoney('bank', commission)
        invoiceMailData = {
            sender = 'Billing Department',
            subject = 'Commission Received',
            message = string.format('You received a commission check of $%s when %s %s paid a bill of $%s.', commission, Ply.PlayerData.charinfo.firstname, Ply.PlayerData.charinfo.lastname, amount)
        }
    elseif not SenderPly and Config.BillingCommissions[society] then
        invoiceMailData = {
            sender = 'Billing Department',
            subject = 'Bill Paid',
            message = string.format('%s %s paid a bill of $%s', Ply.PlayerData.charinfo.firstname, Ply.PlayerData.charinfo.lastname, amount)
        }
    end
    Ply.Functions.RemoveMoney('bank', amount, "paid-invoice")
    TriggerEvent('mr-phone:server:sendNewMailToOffline', sendercitizenid, invoiceMailData)
    TriggerEvent("mr-bossmenu:server:addAccountMoney", society, amount)
    MySQL.query('DELETE FROM phone_invoices WHERE id = ?', {invoiceId})
    local invoices = MySQL.query.await('SELECT * FROM phone_invoices WHERE citizenid = ?', {Ply.PlayerData.citizenid})
    if invoices[1] ~= nil then
        Invoices = invoices
    end
    cb(true, Invoices)
end)

MRFW.Functions.CreateCallback('mr-phone:server:DeclineInvoice', function(source, cb, sender, amount, invoiceId)
    local Invoices = {}
    local Ply = MRFW.Functions.GetPlayer(source)
    MySQL.query('DELETE FROM phone_invoices WHERE id = ?', {invoiceId})
    local invoices = MySQL.query.await('SELECT * FROM phone_invoices WHERE citizenid = ?', {Ply.PlayerData.citizenid})
    if invoices[1] ~= nil then
        Invoices = invoices
    end
    cb(true, Invoices)
end)

MRFW.Functions.CreateCallback('mr-phone:server:GetContactPictures', function(source, cb, Chats)
    for k, v in pairs(Chats) do
        local Player = MRFW.Functions.GetPlayerByPhone(v.number)

        local query = '%' .. v.number .. '%'
        local result = MySQL.query.await('SELECT * FROM players WHERE charinfo LIKE ?', {query})
        if result[1] ~= nil then
            local MetaData = json.decode(result[1].metadata)

            if MetaData.phone.profilepicture ~= nil then
                v.picture = MetaData.phone.profilepicture
            else
                v.picture = "default"
            end
        end
    end
    SetTimeout(100, function()
        cb(Chats)
    end)
end)

MRFW.Functions.CreateCallback('mr-phone:server:GetContactPicture', function(source, cb, Chat)
    local query = '%' .. Chat.number .. '%'
    local result = MySQL.query.await('SELECT * FROM players WHERE charinfo LIKE ?', {query})
    local MetaData = json.decode(result[1].metadata)
    if MetaData.phone.profilepicture ~= nil then
        Chat.picture = MetaData.phone.profilepicture
    else
        Chat.picture = "default"
    end
    SetTimeout(100, function()
        cb(Chat)
    end)
end)

MRFW.Functions.CreateCallback('mr-phone:server:GetPicture', function(source, cb, number)
    local Picture = nil
    local query = '%' .. number .. '%'
    local result = MySQL.query.await('SELECT * FROM players WHERE charinfo LIKE ?', {query})
    if result[1] ~= nil then
        local MetaData = json.decode(result[1].metadata)
        if MetaData.phone.profilepicture ~= nil then
            Picture = MetaData.phone.profilepicture
        else
            Picture = "default"
        end
        cb(Picture)
    else
        cb(nil)
    end
end)

MRFW.Functions.CreateCallback('mr-phone:server:FetchResult', function(source, cb, search)
    local search = escape_sqli(search)
    local searchData = {}
    local ApaData = {}
    local query = 'SELECT * FROM `players` WHERE `citizenid` = "' .. search .. '"'
    local searchParameters = SplitStringToArray(search)
    if #searchParameters > 1 then
        query = query .. ' OR `charinfo` LIKE "%' .. searchParameters[1] .. '%"'
        for i = 2, #searchParameters do
            query = query .. ' AND `charinfo` LIKE  "%' .. searchParameters[i] .. '%"'
        end
    else
        query = query .. ' OR `charinfo` LIKE "%' .. search .. '%"'
    end
    local ApartmentData = MySQL.query.await('SELECT * FROM apartments', {})
    for k, v in pairs(ApartmentData) do
        ApaData[v.citizenid] = ApartmentData[k]
    end
    local result = MySQL.query.await(query)
    if result[1] ~= nil then
        for k, v in pairs(result) do
            local charinfo = json.decode(v.charinfo)
            local metadata = json.decode(v.metadata)
            local appiepappie = {}
            if ApaData[v.citizenid] ~= nil and next(ApaData[v.citizenid]) ~= nil then
                appiepappie = ApaData[v.citizenid]
            end
            searchData[#searchData+1] = {
                citizenid = v.citizenid,
                firstname = charinfo.firstname,
                lastname = charinfo.lastname,
                birthdate = charinfo.birthdate,
                phone = charinfo.phone,
                nationality = charinfo.nationality,
                gender = charinfo.gender,
                warrant = false,
                driverlicense = metadata["licences"]["driver"],
                appartmentdata = appiepappie
            }
        end
        cb(searchData)
    else
        cb(nil)
    end
end)

MRFW.Functions.CreateCallback('mr-phone:server:GetVehicleSearchResults', function(source, cb, search)
    local search = escape_sqli(search)
    local searchData = {}
    local query = '%' .. search .. '%'
    local result = MySQL.query.await('SELECT * FROM player_vehicles WHERE plate LIKE ? OR citizenid = ?',
        {query, search})
    if result[1] ~= nil then
        for k, v in pairs(result) do
            local player = MySQL.query.await('SELECT * FROM players WHERE citizenid = ?', {result[k].citizenid})
            if player[1] ~= nil then
                local charinfo = json.decode(player[1].charinfo)
                local vehicleInfo = MRFW.Shared.Vehicles[result[k].vehicle]
                if vehicleInfo ~= nil then
                    searchData[#searchData+1] = {
                        plate = result[k].plate,
                        status = true,
                        owner = charinfo.firstname .. " " .. charinfo.lastname,
                        citizenid = result[k].citizenid,
                        label = vehicleInfo["name"]
                    }
                else
                    searchData[#searchData+1] = {
                        plate = result[k].plate,
                        status = true,
                        owner = charinfo.firstname .. " " .. charinfo.lastname,
                        citizenid = result[k].citizenid,
                        label = "Name not found.."
                    }
                end
            end
        end
    else
        if GeneratedPlates[search] ~= nil then
            searchData[#searchData+1] = {
                plate = GeneratedPlates[search].plate,
                status = GeneratedPlates[search].status,
                owner = GeneratedPlates[search].owner,
                citizenid = GeneratedPlates[search].citizenid,
                label = "Brand unknown.."
            }
        else
            local ownerInfo = GenerateOwnerName()
            GeneratedPlates[search] = {
                plate = search,
                status = true,
                owner = ownerInfo.name,
                citizenid = ownerInfo.citizenid
            }
            searchData[#searchData+1] = {
                plate = search,
                status = true,
                owner = ownerInfo.name,
                citizenid = ownerInfo.citizenid,
                label = "Brand unknown.."
            }
        end
    end
    cb(searchData)
end)

MRFW.Functions.CreateCallback('mr-phone:server:ScanPlate', function(source, cb, plate)
    local src = source
    local vehicleData = {}
    if plate ~= nil then
        local result = MySQL.query.await('SELECT * FROM player_vehicles WHERE plate = ?', {plate})
        if result[1] ~= nil then
            local player = MySQL.query.await('SELECT * FROM players WHERE citizenid = ?', {result[1].citizenid})
            local charinfo = json.decode(player[1].charinfo)
            vehicleData = {
                plate = plate,
                status = true,
                owner = charinfo.firstname .. " " .. charinfo.lastname,
                citizenid = result[1].citizenid
            }
        elseif GeneratedPlates ~= nil and GeneratedPlates[plate] ~= nil then
            vehicleData = GeneratedPlates[plate]
        else
            local ownerInfo = GenerateOwnerName()
            GeneratedPlates[plate] = {
                plate = plate,
                status = true,
                owner = ownerInfo.name,
                citizenid = ownerInfo.citizenid
            }
            vehicleData = {
                plate = plate,
                status = true,
                owner = ownerInfo.name,
                citizenid = ownerInfo.citizenid
            }
        end
        cb(vehicleData)
    else
        TriggerClientEvent('MRFW:Notify', src, 'No Vehicle Nearby', 'error')
        cb(nil)
    end
end)

local function GetGarageNamephone(name)
    for k,v in pairs(Garages) do
        if k == name then
            return true
        end
    end
end

MRFW.Functions.CreateCallback('mr-phone:server:GetGarageVehicles', function(source, cb)
    local Player = MRFW.Functions.GetPlayer(source)
    local Vehicles = {}
    local result = MySQL.query.await('SELECT * FROM player_vehicles WHERE citizenid = ?',
        {Player.PlayerData.citizenid})
    if result[1] ~= nil then
        for k, v in pairs(result) do
            local VehicleData = MRFW.Shared.Vehicles[v.vehicle]
            local VehicleGarage = "None"
            if v.garage ~= nil then
                if GetGarageNamephone(v.garage) then
                    if Garages[v.garage] or GangGarages[v.garage] or JobGarages[v.garage] then
                        if Garages[v.garage] ~= nil then
                            VehicleGarage = Garages[v.garage]["label"]
                        elseif GangGarages[v.garage] ~= nil then
                            VehicleGarage = GangGarages[v.garage]["label"]
                        elseif JobGarages[v.garage] ~= nil then
                            VehicleGarage = JobGarages[v.garage]["label"]
                        end
                    end
                else
                    VehicleGarage = v.garage
                end
            end
            
            local VehicleState = "In"
            if v.state == 0 then
                VehicleState = "Out"
            elseif v.state == 2 then
                VehicleState = "Impounded"
            end

            local vehdata = {}
            if VehicleData["brand"] ~= nil then
                vehdata = {
                    fullname = VehicleData["brand"] .. " " .. VehicleData["name"],
                    brand = VehicleData["brand"],
                    model = VehicleData["name"],
                    plate = v.plate,
                    garage = VehicleGarage,
                    state = VehicleState,
                    type = v.type,
                    fuel = v.fuel,
                    engine = v.engine,
                    body = v.body
                }
            else
                vehdata = {
                    fullname = VehicleData["name"],
                    brand = VehicleData["name"],
                    model = VehicleData["name"],
                    plate = v.plate,
                    garage = VehicleGarage,
                    state = VehicleState,
                    type = v.type,
                    fuel = v.fuel,
                    engine = v.engine,
                    body = v.body
                }
            end
            Vehicles[#Vehicles+1] = vehdata
        end
        cb(Vehicles)
    else
        cb(nil)
    end
end)

MRFW.Functions.CreateCallback('mr-phone:server:HasPhone', function(source, cb)
    local Player = MRFW.Functions.GetPlayer(source)
    if Player ~= nil then
        local HasPhone = Player.Functions.GetItemByName("phone")
        if HasPhone ~= nil then
            cb(true)
        else
            cb(false)
        end
    end
end)

MRFW.Functions.CreateCallback('mr-phone:server:CanTransferMoney', function(source, cb, amount, iban)
    local newAmount = tostring(amount)
    local newiban = tostring(iban)
    for k, v in pairs(bannedCharacters) do
        newAmount = string.gsub(newAmount, '%' .. v, '')
        newiban = string.gsub(newiban, '%' .. v, '')
    end
    iban = newiban
    amount = tonumber(newAmount)
    
    local Player = MRFW.Functions.GetPlayer(source)
    if (Player.PlayerData.money.bank - amount) >= 0 then
        local query = '%"account":"' .. iban .. '"%'
        local result = MySQL.query.await('SELECT * FROM players WHERE charinfo LIKE ?', {query})
        if result[1] ~= nil then
            local Reciever = MRFW.Functions.GetPlayerByCitizenId(result[1].citizenid)
            Player.Functions.RemoveMoney('bank', amount)
            if Reciever ~= nil then
                Reciever.Functions.AddMoney('bank', amount)
            else
                local RecieverMoney = json.decode(result[1].money)
                RecieverMoney.bank = (RecieverMoney.bank + amount)
                MySQL.query('UPDATE players SET money = ? WHERE citizenid = ?', {json.encode(RecieverMoney), result[1].citizenid})
            end
            cb(true)
        else
            cb(false)
        end
    end
end)

MRFW.Functions.CreateCallback('mr-phone:server:GetCurrentLawyers', function(source, cb)
    local Lawyers = {}
    for k, v in pairs(MRFW.Functions.GetPlayers()) do
        local Player = MRFW.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.job.name == "lawyer" or Player.PlayerData.job.name == "realestate" or
            Player.PlayerData.job.name == "mechanic" or Player.PlayerData.job.name == "taxi" or
            Player.PlayerData.job.name == "edm" or Player.PlayerData.job.name == "pdm" or
            Player.PlayerData.job.name == "mcd" or Player.PlayerData.job.name == "catcafe" or
            Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "doctor" or
            Player.PlayerData.job.name == "bennys") and
                Player.PlayerData.job.onduty then
                Lawyers[#Lawyers+1] = {
                    name = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname,
                    phone = Player.PlayerData.charinfo.phone,
                    typejob = Player.PlayerData.job.name
                }
            end
        end
    end
    cb(Lawyers)
end)

MRFW.Functions.CreateCallback("mr-phone:server:GetWebhook",function(source,cb)
		cb(WebHook)
end)

-- Events

RegisterNetEvent('mr-phone:server:AddAdvert', function(msg, url)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local CitizenId = Player.PlayerData.citizenid
    if Adverts[CitizenId] ~= nil then
        Adverts[CitizenId].message = msg
        Adverts[CitizenId].name = "@" .. Player.PlayerData.charinfo.firstname .. "" .. Player.PlayerData.charinfo.lastname
        Adverts[CitizenId].number = Player.PlayerData.charinfo.phone
        Adverts[CitizenId].url = url
    else
        Adverts[CitizenId] = {
            message = msg,
            name = "@" .. Player.PlayerData.charinfo.firstname .. "" .. Player.PlayerData.charinfo.lastname,
            number = Player.PlayerData.charinfo.phone,
            url = url
        }
    end
    TriggerClientEvent('mr-phone:client:UpdateAdverts', -1, Adverts, "@" .. Player.PlayerData.charinfo.firstname .. "" .. Player.PlayerData.charinfo.lastname)
end)

RegisterNetEvent('mr-phone:server:DeleteAdvert', function()
    local Player = MRFW.Functions.GetPlayer(source)
    local citizenid = Player.PlayerData.citizenid
    Adverts[citizenid] = nil
    TriggerClientEvent('mr-phone:client:UpdateAdvertsDel', -1, Adverts)
end)

RegisterNetEvent('mr-phone:server:SetCallState', function(bool)
    local src = source
    local Ply = MRFW.Functions.GetPlayer(src)
    if Calls[Ply.PlayerData.citizenid] ~= nil then
        Calls[Ply.PlayerData.citizenid].inCall = bool
    else
        Calls[Ply.PlayerData.citizenid] = {}
        Calls[Ply.PlayerData.citizenid].inCall = bool
    end
end)

RegisterNetEvent('mr-phone:server:RemoveMail', function(MailId)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    MySQL.query('DELETE FROM player_mails WHERE mailid = ? AND citizenid = ?', {MailId, Player.PlayerData.citizenid})
    SetTimeout(100, function()
        local mails = MySQL.query.await('SELECT * FROM player_mails WHERE citizenid = ? ORDER BY `date` ASC', {Player.PlayerData.citizenid})
        if mails[1] ~= nil then
            for k, v in pairs(mails) do
                if mails[k].button ~= nil then
                    mails[k].button = json.decode(mails[k].button)
                end
            end
        end
        TriggerClientEvent('mr-phone:client:UpdateMails', src, mails)
    end)
end)

RegisterNetEvent('mr-phone:server:sendNewMail', function(mailData)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if mailData.button == nil then
        MySQL.insert('INSERT INTO player_mails (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES (?, ?, ?, ?, ?, ?)', {Player.PlayerData.citizenid, mailData.sender, mailData.subject, mailData.message, GenerateMailId(), 0})
    else
        MySQL.insert('INSERT INTO player_mails (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES (?, ?, ?, ?, ?, ?, ?)', {Player.PlayerData.citizenid, mailData.sender, mailData.subject, mailData.message, GenerateMailId(), 0, json.encode(mailData.button)})
    end
    TriggerClientEvent('mr-phone:client:NewMailNotify', src, mailData)
    SetTimeout(200, function()
        local mails = MySQL.query.await('SELECT * FROM player_mails WHERE citizenid = ? ORDER BY `date` DESC',
            {Player.PlayerData.citizenid})
        if mails[1] ~= nil then
            for k, v in pairs(mails) do
                if mails[k].button ~= nil then
                    mails[k].button = json.decode(mails[k].button)
                end
            end
        end

        TriggerClientEvent('mr-phone:client:UpdateMails', src, mails)
    end)
end)

RegisterNetEvent('mr-phone:server:sendNewMailToOffline', function(citizenid, mailData)
    local Player = MRFW.Functions.GetPlayerByCitizenId(citizenid)
    if Player then
        local src = Player.PlayerData.source
        if mailData.button == nil then
            MySQL.insert('INSERT INTO player_mails (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES (?, ?, ?, ?, ?, ?)', {Player.PlayerData.citizenid, mailData.sender, mailData.subject, mailData.message, GenerateMailId(), 0})
            TriggerClientEvent('mr-phone:client:NewMailNotify', src, mailData)
        else
            MySQL.insert('INSERT INTO player_mails (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES (?, ?, ?, ?, ?, ?, ?)', {Player.PlayerData.citizenid, mailData.sender, mailData.subject, mailData.message, GenerateMailId(), 0, json.encode(mailData.button)})
            TriggerClientEvent('mr-phone:client:NewMailNotify', src, mailData)
        end
        SetTimeout(200, function()
            local mails = MySQL.query.await(
                'SELECT * FROM player_mails WHERE citizenid = ? ORDER BY `date` ASC', {Player.PlayerData.citizenid})
            if mails[1] ~= nil then
                for k, v in pairs(mails) do
                    if mails[k].button ~= nil then
                        mails[k].button = json.decode(mails[k].button)
                    end
                end
            end

            TriggerClientEvent('mr-phone:client:UpdateMails', src, mails)
        end)
    else
        if mailData.button == nil then
            MySQL.insert('INSERT INTO player_mails (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES (?, ?, ?, ?, ?, ?)', {citizenid, mailData.sender, mailData.subject, mailData.message, GenerateMailId(), 0})
        else
            MySQL.insert('INSERT INTO player_mails (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES (?, ?, ?, ?, ?, ?, ?)', {citizenid, mailData.sender, mailData.subject, mailData.message, GenerateMailId(), 0, json.encode(mailData.button)})
        end
    end
end)

RegisterNetEvent('mr-phone:server:sendNewEventMail', function(citizenid, mailData)
    local Player = MRFW.Functions.GetPlayerByCitizenId(citizenid)
    if mailData.button == nil then
        MySQL.insert('INSERT INTO player_mails (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES (?, ?, ?, ?, ?, ?)', {citizenid, mailData.sender, mailData.subject, mailData.message, GenerateMailId(), 0})
    else
        MySQL.insert('INSERT INTO player_mails (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES (?, ?, ?, ?, ?, ?, ?)', {citizenid, mailData.sender, mailData.subject, mailData.message, GenerateMailId(), 0, json.encode(mailData.button)})
    end
    SetTimeout(200, function()
        local mails = MySQL.query.await('SELECT * FROM player_mails WHERE citizenid = ? ORDER BY `date` ASC', {citizenid})
        if mails[1] ~= nil then
            for k, v in pairs(mails) do
                if mails[k].button ~= nil then
                    mails[k].button = json.decode(mails[k].button)
                end
            end
        end
        TriggerClientEvent('mr-phone:client:UpdateMails', Player.PlayerData.source, mails)
    end)
end)

RegisterNetEvent('mr-phone:server:ClearButtonData', function(mailId)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    MySQL.query('UPDATE player_mails SET button = ? WHERE mailid = ? AND citizenid = ?', {'', mailId, Player.PlayerData.citizenid})
    SetTimeout(200, function()
        local mails = MySQL.query.await('SELECT * FROM player_mails WHERE citizenid = ? ORDER BY `date` ASC', {Player.PlayerData.citizenid})
        if mails[1] ~= nil then
            for k, v in pairs(mails) do
                if mails[k].button ~= nil then
                    mails[k].button = json.decode(mails[k].button)
                end
            end
        end
        TriggerClientEvent('mr-phone:client:UpdateMails', src, mails)
    end)
end)

RegisterNetEvent('mr-phone:server:MentionedPlayer', function(firstName, lastName, TweetMessage)
    for k, v in pairs(MRFW.Functions.GetPlayers()) do
        local Player = MRFW.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.charinfo.firstname == firstName and Player.PlayerData.charinfo.lastname == lastName) then
                QBPhone.SetPhoneAlerts(Player.PlayerData.citizenid, "twitter")
                QBPhone.AddMentionedTweet(Player.PlayerData.citizenid, TweetMessage)
                TriggerClientEvent('mr-phone:client:GetMentioned', Player.PlayerData.source, TweetMessage, AppAlerts[Player.PlayerData.citizenid]["twitter"])
            else
                local query1 = '%' .. firstName .. '%'
                local query2 = '%' .. lastName .. '%'
                local result = MySQL.query.await('SELECT * FROM players WHERE charinfo LIKE ? AND charinfo LIKE ?', {query1, query2})
                if result[1] ~= nil then
                    local MentionedTarget = result[1].citizenid
                    QBPhone.SetPhoneAlerts(MentionedTarget, "twitter")
                    QBPhone.AddMentionedTweet(MentionedTarget, TweetMessage)
                end
            end
        end
    end
end)

RegisterNetEvent('mr-phone:server:MentionedPlayer-dark', function(firstName, lastName, AnonMessage)
    for k, v in pairs(MRFW.Functions.GetPlayers()) do
        local Player = MRFW.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.charinfo.firstname == firstName and Player.PlayerData.charinfo.lastname == lastName) then
                QBPhone.SetPhoneAlerts(Player.PlayerData.citizenid, "darkweb")
                QBPhone.AddMentionedAnon(Player.PlayerData.citizenid, AnonMessage)
                TriggerClientEvent('mr-phone:client:GetMentioned-dark', Player.PlayerData.source, AnonMessage, AppAlerts[Player.PlayerData.citizenid]["twitter"])
            else
                local query1 = '%' .. firstName .. '%'
                local query2 = '%' .. lastName .. '%'
                local result = MySQL.Sync.fetchAll('SELECT * FROM players WHERE charinfo LIKE ? AND charinfo LIKE ?', {query1, query2})
                if result[1] ~= nil then
                    local MentionedTarget = result[1].citizenid
                    QBPhone.SetPhoneAlerts(MentionedTarget, "darkweb")
                    QBPhone.AddMentionedAnon(MentionedTarget, AnonMessage)
                end
            end
        end
    end
end)


RegisterNetEvent('mr-phone:server:CallContact', function(TargetData, CallId, AnonymousCall)
    local src = source
    local Ply = MRFW.Functions.GetPlayer(src)
    local Target = MRFW.Functions.GetPlayerByPhone(TargetData.number)
    if Target ~= nil then
        TriggerClientEvent('mr-phone:client:GetCalled', Target.PlayerData.source, Ply.PlayerData.charinfo.phone, CallId, AnonymousCall)
    end
end)

RegisterNetEvent('mr-phone:server:BillingEmail', function(data, paid)
    for k, v in pairs(MRFW.Functions.GetPlayers()) do
        local target = MRFW.Functions.GetPlayer(v)
        if target.PlayerData.job.name == data.society then
            if paid then
                local name = '' .. MRFW.Functions.GetPlayer(source).PlayerData.charinfo.firstname .. ' ' .. MRFW.Functions.GetPlayer(source).PlayerData.charinfo.lastname .. ''
                TriggerClientEvent('mr-phone:client:BillingEmail', target.PlayerData.source, data, true, name)
            else
                local name = '' .. MRFW.Functions.GetPlayer(source).PlayerData.charinfo.firstname .. ' ' .. MRFW.Functions.GetPlayer(source).PlayerData.charinfo.lastname .. ''
                TriggerClientEvent('mr-phone:client:BillingEmail', target.PlayerData.source, data, false, name)
            end
        end
    end
end)

RegisterNetEvent('mr-phone:server:UpdateHashtags', function(Handle, messageData)
    if Hashtags[Handle] ~= nil and next(Hashtags[Handle]) ~= nil then
        Hashtags[Handle].messages[#Hashtags[Handle].messages+1] = messageData
    else
        Hashtags[Handle] = {
            hashtag = Handle,
            messages = {}
        }
        Hashtags[Handle].messages[#Hashtags[Handle].messages+1] = messageData
    end
    TriggerClientEvent('mr-phone:client:UpdateHashtags', -1, Handle, messageData)
end)

RegisterNetEvent('mr-phone:server:UpdateHashtags-dark', function(Handle, messageData)
    if Hashtags_dark[Handle] ~= nil and next(Hashtags_dark[Handle]) ~= nil then
        Hashtags_dark[Handle].messages[#Hashtags_dark[Handle].messages+1] = messageData
    else
        Hashtags_dark[Handle] = {
            hashtag = Handle,
            messages = {}
        }
        Hashtags_dark[Handle].messages[#Hashtags_dark[Handle].messages+1] = messageData
    end
    TriggerClientEvent('mr-phone:client:UpdateHashtags-dark', -1, Handle, messageData)
end)

RegisterNetEvent('mr-phone:server:SetPhoneAlerts', function(app, alerts)
    local src = source
    local CitizenId = MRFW.Functions.GetPlayer(src).citizenid
    QBPhone.SetPhoneAlerts(CitizenId, app, alerts)
end)

RegisterNetEvent('mr-phone:server:DeleteTweet', function(tweetId)
    local src = source
    for i = 1, #Tweets do
        if Tweets[i].tweetId == tweetId then
            Tweets[i] = nil
        end
    end
    TriggerClientEvent('mr-phone:client:UpdateTweets', -1, src, Tweets, {}, true)
end)

RegisterNetEvent('mr-phone:server:DeleteAnon', function(anonId)
    local Player = MRFW.Functions.GetPlayer(source)
    local delete = false
    local TID = anonId
    local Data = MySQL.Sync.fetchScalar('SELECT citizenid FROM phone_anons WHERE tweetId = ?', {TID})
    if Data == Player.PlayerData.citizenid then
        local Data2 = MySQL.Sync.fetchAll('DELETE FROM phone_anons WHERE tweetId = ?', {TID})
        delete = true
    end
    
    if delete then
        delete = not delete
        for k, v in pairs(DNData) do
            if DNData[k].anonId == TID then
                DNData = nil
            end
        end
        TriggerClientEvent('mr-phone:client:UpdateAnons', -1, DNData)
    end
end)


RegisterNetEvent('mr-phone:server:UpdateTweets', function(NewTweets, TweetData)
    local src = source
    local InsertTweet = MySQL.insert('INSERT INTO phone_tweets (citizenid, firstName, lastName, message, date, url, picture, tweetid) VALUES (?, ?, ?, ?, NOW(), ?, ?, ?)', {
        TweetData.citizenid,
        TweetData.firstName,
        TweetData.lastName,
        TweetData.message,
        TweetData.url,
        TweetData.picture,
        TweetData.tweetId
    })
    TriggerClientEvent('mr-phone:client:UpdateTweets', -1, src, NewTweets, TweetData, false)
end)

RegisterNetEvent('mr-phone:server:UpdateAnons', function(NewAnons, AnonData)
    local src = source
    if Config.Linux then
	local InsertAnon = MySQL.Async.insert('INSERT INTO phone_anons (citizenid, firstName, lastName, message, date, url, picture, anonid, anon) VALUES (?, ?, ?, ?, NOW(), ?, ?, ?, ?)', {
    AnonData.citizenid,
    AnonData.firstName,
    AnonData.lastName,
    AnonData.message,
    AnonData.url:gsub("[%<>\"()\' $]",""),
    AnonData.picture,
    AnonData.anonId,
    AnonData.anonym
	})
	TriggerClientEvent('mr-phone:client:UpdateAnons', -1, src, NewAnons, AnonData, false)
    else
	local InsertAnon = MySQL.Async.insert('INSERT INTO phone_anons (citizenid, firstName, lastName, message, date, url, picture, anonid, anon) VALUES (?, ?, ?, ?, NOW(), ?, ?, ?, ?)', {
    AnonData.citizenid,
	AnonData.firstName,
	AnonData.lastName,
	AnonData.message,
	AnonData.url:gsub("[%<>\"()\' $]",""),
	AnonData.picture,
	AnonData.anonId,
    AnonData.anonym
	})
	TriggerClientEvent('mr-phone:client:UpdateAnons', -1, src, NewAnons, AnonData, false)		
    end
end)


RegisterNetEvent('mr-phone:server:TransferMoney', function(iban, amount)
    local src = source
    local sender = MRFW.Functions.GetPlayer(src)

    local query = '%' .. iban .. '%'
    local result = MySQL.query.await('SELECT * FROM players WHERE charinfo LIKE ?', {query})
    if result[1] ~= nil then
        local reciever = MRFW.Functions.GetPlayerByCitizenId(result[1].citizenid)

        if reciever ~= nil then
            local PhoneItem = reciever.Functions.GetItemByName("phone")
            reciever.Functions.AddMoney('bank', amount, "phone-transfered-from-" .. sender.PlayerData.citizenid)
            sender.Functions.RemoveMoney('bank', amount, "phone-transfered-to-" .. reciever.PlayerData.citizenid)

            if PhoneItem ~= nil then
                TriggerClientEvent('mr-phone:client:TransferMoney', reciever.PlayerData.source, amount,
                    reciever.PlayerData.money.bank)
            end
        else
            local moneyInfo = json.decode(result[1].money)
            moneyInfo.bank = round((moneyInfo.bank + amount))
            MySQL.query('UPDATE players SET money = ? WHERE citizenid = ?',
                {json.encode(moneyInfo), result[1].citizenid})
            sender.Functions.RemoveMoney('bank', amount, "phone-transfered")
        end
    else
        TriggerClientEvent('MRFW:Notify', src, "That account number doesn't exist!", "error")
    end
end)

RegisterNetEvent('mr-phone:server:EditContact', function(newName, newNumber, newIban, oldName, oldNumber, oldIban)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    MySQL.query(
        'UPDATE player_contacts SET name = ?, number = ?, iban = ? WHERE citizenid = ? AND name = ? AND number = ?',
        {newName, newNumber, newIban, Player.PlayerData.citizenid, oldName, oldNumber})
end)

RegisterNetEvent('mr-phone:server:RemoveContact', function(Name, Number)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    MySQL.query('DELETE FROM player_contacts WHERE name = ? AND number = ? AND citizenid = ?',
        {Name, Number, Player.PlayerData.citizenid})
end)

RegisterNetEvent('mr-phone:server:AddNewContact', function(name, number, iban)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    MySQL.insert('INSERT INTO player_contacts (citizenid, name, number, iban) VALUES (?, ?, ?, ?)', {Player.PlayerData.citizenid, tostring(name), tostring(number), tostring(iban)})
end)

RegisterNetEvent('mr-phone:server:UpdateMessages', function(ChatMessages, ChatNumber, New)
    local src = source
    local SenderData = MRFW.Functions.GetPlayer(src)
    local query = '%' .. ChatNumber .. '%'
    local Player = MySQL.query.await('SELECT * FROM players WHERE charinfo LIKE ?', {query})
    if Player[1] ~= nil then
        local TargetData = MRFW.Functions.GetPlayerByCitizenId(Player[1].citizenid)
        if TargetData ~= nil then
            local Chat = MySQL.query.await('SELECT * FROM phone_messages WHERE citizenid = ? AND number = ?', {SenderData.PlayerData.citizenid, ChatNumber})
            if Chat[1] ~= nil then
                MySQL.query('UPDATE phone_messages SET messages = ? WHERE citizenid = ? AND number = ?', {json.encode(ChatMessages), TargetData.PlayerData.citizenid, SenderData.PlayerData.charinfo.phone})
                MySQL.query('UPDATE phone_messages SET messages = ? WHERE citizenid = ? AND number = ?', {json.encode(ChatMessages), SenderData.PlayerData.citizenid, TargetData.PlayerData.charinfo.phone})
                TriggerClientEvent('mr-phone:client:UpdateMessages', TargetData.PlayerData.source, ChatMessages, SenderData.PlayerData.charinfo.phone, false)
            else
                MySQL.insert('INSERT INTO phone_messages (citizenid, number, messages) VALUES (?, ?, ?)', {TargetData.PlayerData.citizenid, SenderData.PlayerData.charinfo.phone, json.encode(ChatMessages)})
                MySQL.insert('INSERT INTO phone_messages (citizenid, number, messages) VALUES (?, ?, ?)', {SenderData.PlayerData.citizenid, TargetData.PlayerData.charinfo.phone, json.encode(ChatMessages)})
                TriggerClientEvent('mr-phone:client:UpdateMessages', TargetData.PlayerData.source, ChatMessages, SenderData.PlayerData.charinfo.phone, true)
            end
        else
            local Chat = MySQL.query.await('SELECT * FROM phone_messages WHERE citizenid = ? AND number = ?', {SenderData.PlayerData.citizenid, ChatNumber})
            if Chat[1] ~= nil then
                MySQL.query('UPDATE phone_messages SET messages = ? WHERE citizenid = ? AND number = ?', {json.encode(ChatMessages), Player[1].citizenid, SenderData.PlayerData.charinfo.phone})
                Player[1].charinfo = json.decode(Player[1].charinfo)
                MySQL.query('UPDATE phone_messages SET messages = ? WHERE citizenid = ? AND number = ?', {json.encode(ChatMessages), SenderData.PlayerData.citizenid, Player[1].charinfo.phone})
            else
                MySQL.insert('INSERT INTO phone_messages (citizenid, number, messages) VALUES (?, ?, ?)', {Player[1].citizenid, SenderData.PlayerData.charinfo.phone, json.encode(ChatMessages)})
                Player[1].charinfo = json.decode(Player[1].charinfo)
                MySQL.insert('INSERT INTO phone_messages (citizenid, number, messages) VALUES (?, ?, ?)', {SenderData.PlayerData.citizenid, Player[1].charinfo.phone, json.encode(ChatMessages)})
            end
        end
    end
end)

RegisterNetEvent('mr-phone:server:AddRecentCall', function(type, data)
    local src = source
    local Ply = MRFW.Functions.GetPlayer(src)
    local Hour = os.date("%H")
    local Minute = os.date("%M")
    local label = Hour .. ":" .. Minute
    TriggerClientEvent('mr-phone:client:AddRecentCall', src, data, label, type)
    local Trgt = MRFW.Functions.GetPlayerByPhone(data.number)
    if Trgt ~= nil then
        TriggerClientEvent('mr-phone:client:AddRecentCall', Trgt.PlayerData.source, {
            name = Ply.PlayerData.charinfo.firstname .. " " .. Ply.PlayerData.charinfo.lastname,
            number = Ply.PlayerData.charinfo.phone,
            anonymous = data.anonymous
        }, label, "outgoing")
    end
end)

RegisterNetEvent('mr-phone:server:CancelCall', function(ContactData)
    local Ply = MRFW.Functions.GetPlayerByPhone(ContactData.TargetData.number)
    if Ply ~= nil then
        TriggerClientEvent('mr-phone:client:CancelCall', Ply.PlayerData.source)
    end
end)

RegisterNetEvent('mr-phone:server:AnswerCall', function(CallData)
    local Ply = MRFW.Functions.GetPlayerByPhone(CallData.TargetData.number)
    if Ply ~= nil then
        TriggerClientEvent('mr-phone:client:AnswerCall', Ply.PlayerData.source)
    end
end)

RegisterNetEvent('mr-phone:server:SaveMetaData', function(MData)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local result = MySQL.query.await('SELECT * FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid})
    local MetaData = json.decode(result[1].metadata)
    MetaData.phone = MData
    MySQL.query('UPDATE players SET metadata = ? WHERE citizenid = ?',
        {json.encode(MetaData), Player.PlayerData.citizenid})
    Player.Functions.SetMetaData("phone", MData)
end)

RegisterNetEvent('mr-phone:server:GiveContactDetails', function(PlayerId)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local SuggestionData = {
        name = {
            [1] = Player.PlayerData.charinfo.firstname,
            [2] = Player.PlayerData.charinfo.lastname
        },
        number = Player.PlayerData.charinfo.phone,
        bank = Player.PlayerData.charinfo.account
    }

    TriggerClientEvent('mr-phone:client:AddNewSuggestion', PlayerId, SuggestionData)
end)

RegisterNetEvent('mr-phone:server:AddTransaction', function(data)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    MySQL.insert('INSERT INTO crypto_transactions (citizenid, title, message) VALUES (?, ?, ?)', {
        Player.PlayerData.citizenid,
        data.TransactionTitle,
        data.TransactionMessage
    })
end)

RegisterNetEvent('mr-phone:server:InstallApplication', function(ApplicationData)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    Player.PlayerData.metadata["phonedata"].InstalledApps[ApplicationData.app] = ApplicationData
    Player.Functions.SetMetaData("phonedata", Player.PlayerData.metadata["phonedata"])
end)

RegisterNetEvent('mr-phone:server:RemoveInstallation', function(App)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    Player.PlayerData.metadata["phonedata"].InstalledApps[App] = nil
    Player.Functions.SetMetaData("phonedata", Player.PlayerData.metadata["phonedata"])
end)

RegisterNetEvent('mr-phone:server:addImageToGallery', function(image)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    MySQL.insert('INSERT INTO phone_gallery (`citizenid`, `image`) VALUES (?, ?)',{Player.PlayerData.citizenid,image})
end)
RegisterNetEvent('mr-phone:server:getImageFromGallery', function()
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local images = MySQL.query.await('SELECT * FROM phone_gallery WHERE citizenid = ? ORDER BY `date` DESC',{Player.PlayerData.citizenid})
    TriggerClientEvent('mr-phone:refreshImages', src, images)
end)

RegisterNetEvent('mr-phone:server:RemoveImageFromGallery', function(data)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local image = data.image
    MySQL.query('DELETE FROM phone_gallery WHERE citizenid = ? AND image = ?',{Player.PlayerData.citizenid,image})
end)

-- Command

MRFW.Commands.Add("setmetadata", "Set Player Metadata (God Only)", {}, false, function(source, args)
    local Player = MRFW.Functions.GetPlayer(source)
    if args[1] then
        if args[1] == "trucker" then
            if args[2] then
                local newrep = Player.PlayerData.metadata["jobrep"]
                newrep.trucker = tonumber(args[2])
                Player.Functions.SetMetaData("jobrep", newrep)
            end
        end
    end
end, "god")

MRFW.Commands.Add('ac', 'accept Call', {}, false, function(source, args)
    TriggerClientEvent('accept:call',source)
end)

MRFW.Commands.Add('cc', 'cancel Call', {}, false, function(source, args)
    TriggerClientEvent('decline:call',source)
end)

MRFW.Commands.Add('bill', 'Bill A Player', {{name = 'id', help = 'Player ID'}, {name = 'amount', help = 'Fine Amount'}}, false, function(source, args)
    local biller = MRFW.Functions.GetPlayer(source)
    local billed = MRFW.Functions.GetPlayer(tonumber(args[1]))
    local amount = tonumber(args[2])
    if biller.PlayerData.job.name == "police" or biller.PlayerData.job.name == 'doctor' or biller.PlayerData.job.name == 'mechanic' then
        if billed ~= nil then
            if biller.PlayerData.citizenid ~= billed.PlayerData.citizenid then
                if amount and amount > 0 then
                    MySQL.insert(
                        'INSERT INTO phone_invoices (citizenid, amount, society, sender, sendercitizenid) VALUES (?, ?, ?, ?, ?)',
                        {billed.PlayerData.citizenid, amount, biller.PlayerData.job.name,
                         biller.PlayerData.charinfo.firstname, biller.PlayerData.citizenid})
                    TriggerClientEvent('mr-phone:RefreshPhone', billed.PlayerData.source)
                    TriggerClientEvent('MRFW:Notify', source, 'Invoice successfully sent', 'success')
                    TriggerClientEvent('MRFW:Notify', billed.PlayerData.source, 'New Invoice Received')
                else
                    TriggerClientEvent('MRFW:Notify', source, 'Must be a valid amount above 0', 'error')
                end
            else
                TriggerClientEvent('MRFW:Notify', source, 'You cannot bill yourself...', 'error')
            end
        else
            TriggerClientEvent('MRFW:Notify', source, 'Player not Online', 'error')
        end
    else
        TriggerClientEvent('MRFW:Notify', source, 'No Access', 'error')
    end
end)


-- ping

local Pings = {}

RegisterNetEvent('mr-pings:server:SendPing2', function(id)
    local src = source

    TriggerClientEvent('mr-pings:client:DoPing', src, tonumber(id))
end)

RegisterNetEvent('mr-pings:server:acceptping', function()
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Pings[src] ~= nil then
        TriggerClientEvent('mr-pings:client:AcceptPing', src, Pings[src], MRFW.Functions.GetPlayer(Pings[src].sender))
        TriggerClientEvent('MRFW:Notify', Pings[src].sender, Player.PlayerData.source.." ID accepted your ping request!")
        Pings[src] = nil
    else
        TriggerClientEvent('MRFW:Notify', src, "You have no ping...", "error")
    end
end)

RegisterNetEvent('mr-pings:server:denyping', function()
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Pings[src] ~= nil then
        TriggerClientEvent('MRFW:Notify', Pings[src].sender, "Your ping request has been rejected...", "error")
        TriggerClientEvent('MRFW:Notify', src, "You turned down the ping...", "success")
        Pings[src] = nil
    else
        TriggerClientEvent('MRFW:Notify', src, "You have no ping...", "error")
    end
end)

RegisterNetEvent('mr-pings:server:SendPing', function(id)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local Target = MRFW.Functions.GetPlayer(id)
    local ped = GetPlayerPed(id)
    local coords = GetEntityCoords(ped)

    if Target ~= nil then
        local OtherItem = Target.Functions.GetItemByName("phone")
        if OtherItem ~= nil then
            TriggerClientEvent('MRFW:Notify', src, "You have requested the location of ID "..Target.PlayerData.source)
            Pings[id] = {
                coords = coords,
                sender = src,
            }
            TriggerClientEvent('MRFW:Notify', id, "You have received a ping request from ID "..Player.PlayerData.source..". Use the app to allow or reject!")
            TriggerClientEvent('mr-phone:ping:client:UiUppers', id, true)
        else
            TriggerClientEvent('MRFW:Notify', src, "Could not send ping...", "error")
        end
    else
        TriggerClientEvent('MRFW:Notify', src, "This person is not in the city...", "error")
    end
end)

RegisterNetEvent('mr-pings:server:SendLocation', function(PingData, SenderData)
    TriggerClientEvent('mr-pings:client:SendLocation', PingData.sender, PingData, SenderData)
end)

MRFW.Commands.Add("p#", "Provide Phone Number", {{name = "id", help='id of player'}}, false, function(source, args)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local number = Player.PlayerData.charinfo.phone
    local target = args[1]
    if target and target ~='' then
        target = tonumber(args[1])
        local tPLayer = MRFW.Functions.GetPlayer(target)
        if tPLayer then
            if tPLayer.PlayerData.source ~= src then
                local ped = GetPlayerPed(src)
                local coords = GetEntityCoords(ped)
                local ped2 = GetPlayerPed(target)
                local coords2 = GetEntityCoords(ped2)
                local dist = #(coords - coords2)
                if dist < 2 then
                    TriggerClientEvent("mr-phone:client-annphonenumber", tPLayer.PlayerData.source, number, true)
                end
            end
        else
            TriggerClientEvent("MRFW:Notify", src, "Player is not online", "error", 5000)
        end
        TriggerClientEvent("mr-phone:client-annphonenumber", src, number, true)
    else
        local Players = MRFW.Functions.GetPlayers()
        for k,v in pairs(Players) do
            if v ~= src then
                local tPLayer = MRFW.Functions.GetPlayer(tonumber(v))
                if tPLayer then
                    local ped = GetPlayerPed(src)
                    local coords = GetEntityCoords(ped)
                    local ped2 = GetPlayerPed(v)
                    local coords2 = GetEntityCoords(ped2)
                    local dist = #(coords - coords2)
                    if dist < 2 then
                        TriggerClientEvent("mr-phone:client-annphonenumber", tPLayer.PlayerData.source, number, false)
                    end
                end
            end
        end
        TriggerClientEvent("mr-phone:client-annphonenumber", src, number, false)
    end
end)

local CasinoTable = {}
local BetNumber = 0
RegisterNetEvent('mr-phone:server:CasinoAddBet', function(data)
    BetNumber = BetNumber + 1
    CasinoTable[BetNumber] = {['Name'] = data.name, ['chanse'] = data.chanse, ['id'] = BetNumber}
    TriggerClientEvent('mr-phone:client:addbetForAll', -1, CasinoTable)
end)

local CasinoBetList = {}
local casino_status = true

RegisterNetEvent('mr-phone:server:BettingAddToTable', function(data)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local amount = tonumber(data.amount)
    local CSN = Player.PlayerData.citizenid
    if casino_status then
        if Player.PlayerData.money.bank >= amount then
            if not CasinoBetList[CSN] then
                Player.Functions.RemoveMoney('bank', amount, "casino betting")
                CasinoBetList[CSN] = {['csn'] = CSN, ['amount'] = amount, ['player'] = data.player, ['chanse'] = data.chanse, ['id'] = data.id}
            else
                TriggerClientEvent('MRFW:Notify', src, "You are already betting...", "error")
            end
        else
            TriggerClientEvent('MRFW:Notify', src, "You do not have enough money!", "error")
        end
    else
        TriggerClientEvent('MRFW:Notify', src, "Betting is not active...", "error")
    end
end)

RegisterNetEvent('mr-phone:server:DeleteAndClearTable', function()
    local src = source
    CasinoTable = {}
    CasinoBetList = {}
    BetNumber = 0
    TriggerClientEvent('mr-phone:client:addbetForAll', -1, CasinoTable)
    TriggerClientEvent('MRFW:Notify', src, "Done", "success")
end)

MRFW.Functions.CreateCallback('mr-phone:server:CheckHasBetTable', function(source, cb)
    cb(CasinoTable)
end)


RegisterNetEvent('mr-phone:server:casino_status', function()
    casino_status = not casino_status
end)

MRFW.Functions.CreateCallback('mr-phone:server:CheckHasBetStatus', function(source, cb)
    cb(casino_status)
end)

RegisterNetEvent('mr-phone:server:WineridCasino', function(data)
    local Winer = data.id
    for k, v in pairs(CasinoBetList) do
        if v.id == Winer then
            local OtherPly = MRFW.Functions.GetPlayerByCitizenId(v.csn)
            if OtherPly then
                local amount = v.amount * v.chanse
                OtherPly.Functions.AddMoney('bank', tonumber(amount), "casino winner")
            end
        end
    end
end)

RegisterNetEvent('mr-phone:server:SetJobJobCenter', function(data)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player.Functions.SetJob(data.job) then
        TriggerClientEvent('MRFW:Notify', src, 'Changed your job to: '..data.label)
    else
        TriggerClientEvent('MRFW:Notify', src, 'Invalid Job...', 'error')
    end
end)

local EmploymentGroup = {}
RegisterNetEvent('mr-phone:server:employment_CreateJobGroup', function(data)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local CSN = Player.PlayerData.citizenid
    if Player then
        if not EmploymentGroup[CSN] then
            EmploymentGroup[CSN] = {['CSN'] = CSN, ['GName'] = data.name, ['GPass'] = data.pass, ['Users'] = 1, ['UserName'] = {CSN,}}
            TriggerClientEvent('mr-phone:client:EveryoneGrupAddsForAll', -1, EmploymentGroup)
            TriggerClientEvent('MRFW:Notify', src, "Group created!", "success")
        else
            TriggerClientEvent('MRFW:Notify', src, "You have already created a group...", "error")
        end
    end
end)

RegisterNetEvent('mr-phone:server:employment_DeleteGroup', function(data)
    EmploymentGroup[data.delete] = nil
    TriggerClientEvent('mr-phone:client:EveryoneGrupAddsForAll', -1, EmploymentGroup)
end)

MRFW.Functions.CreateCallback('mr-phone:server:GetGroupsApp', function(source, cb)
    cb(EmploymentGroup)
end)

RegisterNetEvent('mr-phone:server:employment_JoinTheGroup', function(data)
    local src = source
    for k, v in pairs(EmploymentGroup) do
        for ke, ve in pairs(v['UserName']) do
            if ve == data.PCSN then
                TriggerClientEvent('MRFW:Notify', src, "You have already joined a group!", "error")
                return
            end
        end
        table.insert(EmploymentGroup[data.id]['UserName'], data.PCSN)
        EmploymentGroup[data.id]['Users'] = v.Users + 1
        TriggerClientEvent('MRFW:Notify', src, "You joined the group!", "success")
        TriggerClientEvent('mr-phone:client:EveryoneGrupAddsForAll', -1, EmploymentGroup)
        return
    end
end)

MRFW.Functions.CreateCallback('mr-phone:server:employment_CheckPlayerNames', function(source, cb, csn)
    local Names = {}
    for k, v in pairs(EmploymentGroup[csn]['UserName']) do
        local OtherPlayer = MRFW.Functions.GetPlayerByCitizenId(v)
        if OtherPlayer then
            local Name = OtherPlayer.PlayerData.charinfo.firstname.." "..OtherPlayer.PlayerData.charinfo.lastname
            table.insert(Names, Name)
        end
    end
    cb(Names)
end)

MRFW.Functions.CreateCallback('mr-phone:server:GetGroupCSNs', function(source, cb, csn)
    if EmploymentGroup[csn] then
        cb(EmploymentGroup[csn]['UserName'])
    else
        cb(false)
    end
end)

RegisterNetEvent('mr-phone:server:employment_leave_grouped', function(data)
    local src = source
    for k, v in pairs(EmploymentGroup[data.id]['UserName']) do
        if v == data.csn then
            table.remove(EmploymentGroup[data.id]['UserName'], k)
            EmploymentGroup[data.id]['Users'] = EmploymentGroup[data.id]['Users'] - 1
            TriggerClientEvent('MRFW:Notify', src, "Done", "success")
            TriggerClientEvent('mr-phone:client:EveryoneGrupAddsForAll', -1, EmploymentGroup)
            return
        end
    end
end)

RegisterNetEvent('mr-phone:server:SendBillForPlayer_debt', function(data)
    local src = source
    local biller = MRFW.Functions.GetPlayer(src)
    local billed = MRFW.Functions.GetPlayer(tonumber(data.ID))
    local amount = tonumber(data.Amount)
    if billed then
            if amount and amount > 0 then
                MySQL.insert('INSERT INTO phone_debt (citizenid, amount,  sender, sendercitizenid, reason) VALUES (?, ?, ?, ?, ?)',{billed.PlayerData.citizenid, amount, biller.PlayerData.charinfo.firstname.." "..biller.PlayerData.charinfo.lastname, biller.PlayerData.citizenid, data.Reason})
                TriggerClientEvent('MRFW:Notify', src, 'Debt successfully sent!', 'success')
                TriggerClientEvent('MRFW:Notify', billed.PlayerData.source, 'New Invoice Received')
                Wait(1)
                TriggerClientEvent('mr-phone:RefreshPhoneForDebt', billed.PlayerData.source)
            else
                TriggerClientEvent('MRFW:Notify', src, 'Must be a valid amount above 0', 'error')
            end
    else
        TriggerClientEvent('MRFW:Notify', src, 'Player not Online', 'error')
    end
end)

MRFW.Functions.CreateCallback('mr-phone:server:GetHasBills_debt', function(source, cb)
    local src = source
    local Ply = MRFW.Functions.GetPlayer(src)
    local Debt = MySQL.query.await('SELECT * FROM phone_debt WHERE citizenid = ?', {Ply.PlayerData.citizenid})
    Wait(400)
    if Debt[1] ~= nil then
        cb(Debt)
    end
end)

RegisterNetEvent('mr-phone:server:debit_AcceptBillForPay', function(data)
    local src = source
    local Ply = MRFW.Functions.GetPlayer(src)
    local OtherPly = MRFW.Functions.GetPlayerByCitizenId(data.CSN)
    local ID = tonumber(data.id)
    local Amount = tonumber(data.Amount)
    if OtherPly then
        if Ply.PlayerData.money.bank then
            Ply.Functions.RemoveMoney('bank', Amount, "Remove Money For Debt")
            OtherPly.Functions.AddMoney('bank', Amount,"Add Money For Debt")
            MySQL.query('DELETE FROM phone_debt WHERE id = ?', {ID})
            Wait(1)
            TriggerClientEvent('mr-phone:RefreshPhoneForDebt', OtherPly.PlayerData.source)
        else
            TriggerClientEvent('MRFW:Notify', src, 'You don\'t have enough money...', 'error')
        end
    else
        TriggerClientEvent('MRFW:Notify', src, 'Player not Online', 'error')
    end
end)

RegisterNetEvent('mr-phone:server:wenmo_givemoney_toID', function(data)
    local src = source
    local Ply = MRFW.Functions.GetPlayer(src)
    local OtherPly = MRFW.Functions.GetPlayer(tonumber(data.ID))
    local Amount = tonumber(data.Amount)
    local Reason = data.Reason
    if OtherPly then
        if Amount <= Ply.PlayerData.money.bank then
            Ply.Functions.RemoveMoney('bank', Amount, "Money Transfer: "..Reason)
            OtherPly.Functions.AddMoney('bank', Amount,"Money Transfer: "..Reason)
        else
            TriggerClientEvent('MRFW:Notify', src, 'You don\'t have enough money', 'error')
        end
    else
        TriggerClientEvent('MRFW:Notify', src, 'Player not Online', 'error')
    end
end)

RegisterNetEvent('mr-phone:server:documents_Save_Note_As', function(data)
    local src = source
    local Ply = MRFW.Functions.GetPlayer(src)
    if data.Type == "New" then
        MySQL.insert('INSERT INTO phone_note (citizenid, title,  text, lastupdate) VALUES (?, ?, ?, ?)',{Ply.PlayerData.citizenid, data.Title, data.Text, data.Time})
        TriggerClientEvent('MRFW:Notify', src, 'Note Saved')
    elseif data.Type == "Update" then
        local ID = tonumber(data.ID)
        local Note = MySQL.query.await('SELECT * FROM phone_note WHERE id = ?', {ID})
        if Note[1] ~= nil then
            MySQL.query('DELETE FROM phone_note WHERE id = ?', {ID})
            MySQL.insert('INSERT INTO phone_note (citizenid, title,  text, lastupdate) VALUES (?, ?, ?, ?)',{Ply.PlayerData.citizenid, data.Title, data.Text, data.Time})
            TriggerClientEvent('MRFW:Notify', src, 'Note Updated', 'success')
        end
    elseif data.Type == "Delete" then
        local ID = tonumber(data.ID)
        MySQL.query('DELETE FROM phone_note WHERE id = ?', {ID})
        TriggerClientEvent('MRFW:Notify', src, 'Note Deleted', 'error')
    end
    Wait(100)
    TriggerClientEvent('mr-phone:RefReshNotes_Free_Documents', src)
end)

MRFW.Functions.CreateCallback('mr-phone:server:GetNote_for_Documents_app', function(source, cb)
    local src = source
    local Ply = MRFW.Functions.GetPlayer(src)
    local Note = MySQL.query.await('SELECT * FROM phone_note WHERE citizenid = ?', {Ply.PlayerData.citizenid})
    Wait(400)
    if Note[1] ~= nil then
        cb(Note)
    end
end)


local LSBNTable = {}
local LSBNTableID = 0
RegisterNetEvent('mr-phone:server:Send_lsbn_ToChat', function(data)
    LSBNTableID = LSBNTableID + 1
    if data.Type == "Text" then
        LSBNTable[LSBNTableID] = {['Text'] = data.Text, ['Image'] = "none", ['ID'] = LSBNTableID, ['Type'] = data.Type, ['Time'] = data.Time,}
    elseif data.Type == "Image" then
        LSBNTable[LSBNTableID] = {['Text'] = data.Text, ['Image'] = data.Image, ['ID'] = LSBNTableID, ['Type'] = data.Type, ['Time'] = data.Time,}
    end
    local Tables = {
        {
            ['Text'] = data.Text, ['Image'] = data.Image, ['ID'] = LSBNTableID, ['Type'] = data.Type, ['Time'] = data.Time,
        },
    }
    TriggerClientEvent('mr-phone:LSBN-reafy-for-add', -1, Tables, true, data.Text)
end)

RegisterNetEvent('mr-phone:server:GetLSBNchats', function()
    local src = source
    TriggerClientEvent('mr-phone:LSBN-reafy-for-add', src, LSBNTable, false, nil)
end)