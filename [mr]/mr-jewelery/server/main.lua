local timeOut = false

local alarmTriggered = false

local inusess = false

local unlocked = false
local coordsHack = vector3(-602.47, -263.81, 52.31)

RegisterServerEvent('mr-jewellery:server:setVitrineState')
AddEventHandler('mr-jewellery:server:setVitrineState', function(stateType, state, k)
    Config.Locations[k][stateType] = state
    TriggerClientEvent('mr-jewellery:client:setVitrineState', -1, stateType, state, k)
end)

RegisterNetEvent('mr-jewellery:server:updateTable')
AddEventHandler('mr-jewellery:server:updateTable', function(bool)
    TriggerClientEvent('mr-jewellery:client:syncTable', -1, bool)
end)

RegisterNetEvent('mr-jewellery:server:updateTable2')
AddEventHandler('mr-jewellery:server:updateTable2', function(bool)
    unlocked = bool
    TriggerClientEvent('mr-jewellery:client:syncTable2', -1, bool)
end)


RegisterNetEvent('mr-jewellery:server:setDoorTimeout')
AddEventHandler('mr-jewellery:server:setDoorTimeout', function()
    SetTimeout(3600000, function()
        unlocked = false
        TriggerClientEvent('mr-jewellery:client:syncTable2', -1, false)
    end)
end)

MRFW.Functions.CreateCallback('mr-jewellery:server:getactiverob2', function(source, cb)
	cb(unlocked, coordsHack)
end)

RegisterServerEvent('mr-jewellery:server:vitrineReward')
AddEventHandler('mr-jewellery:server:vitrineReward', function()
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local otherchance = math.random(1, 4)
    local odd = math.random(1, 4)

    if otherchance == odd then
        local item = math.random(1, #Config.VitrineRewards)
        local amount = math.random(Config.VitrineRewards[item]["amount"]["min"], Config.VitrineRewards[item]["amount"]["max"])
        if Player.Functions.AddItem(Config.VitrineRewards[item]["item"], amount) then
            TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items[Config.VitrineRewards[item]["item"]], 'add', amount)
        else
            TriggerClientEvent('MRFW:Notify', src, 'You have to much in your pocket', 'error')
        end
    else
        local amount = math.random(2, 4)
        if Player.Functions.AddItem("10kgoldchain", amount) then
            TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items["10kgoldchain"], 'add', amount)
        else
            TriggerClientEvent('MRFW:Notify', src, 'You have to much in your pocket..', 'error')
        end
    end
end)

RegisterServerEvent('mr-jewellery:server:setTimeout')
AddEventHandler('mr-jewellery:server:setTimeout', function()
    if not timeOut then
        inusess = true
        timeOut = true
        TriggerEvent('mr-scoreboard:server:SetActivityBusy', "jewellery", true)
        Citizen.CreateThread(function()
            Citizen.Wait(2700000)
            inusess = false
            for k, v in pairs(Config.Locations) do
                Config.Locations[k]["isOpened"] = false
                TriggerClientEvent('mr-jewellery:client:setVitrineState', -1, 'isOpened', false, k)
                TriggerClientEvent('mr-jewellery:client:setAlertState', -1, false)
                TriggerEvent('mr-scoreboard:server:SetActivityBusy', "jewellery", false)
	            TriggerEvent('mr-jewellery:server:updateTable', false)
            end
            timeOut = false
            alarmTriggered = false
        end)
    end
end)

RegisterServerEvent('mr-jewellery:server:PoliceAlertMessage')
AddEventHandler('mr-jewellery:server:PoliceAlertMessage', function(title, coords, blip)
    local src = source
    local alertData = {
        title = title,
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = "Possible robbery going on at Vangelico Jewelry Store<br>Available camera's: 31, 32, 33, 34",
    }
    TriggerClientEvent("mr-jewellery:client:PoliceAlertMessage", source, title, coords, blip)

    for k, v in pairs(MRFW.Functions.GetPlayers()) do
        local Player = MRFW.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                if blip then
                    if not alarmTriggered then
                        TriggerClientEvent("mr-phone:client:addPoliceAlert", v, alertData)
                        alarmTriggered = true
                    end
                else
                    TriggerClientEvent("mr-phone:client:addPoliceAlert", v, alertData)
                end
            end
        end
    end
end)

MRFW.Functions.CreateCallback('mr-jewellery:server:getCops', function(source, cb)
	local amount = 0
    for k, v in pairs(MRFW.Functions.GetPlayers()) do
        local Player = MRFW.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
	end
	cb(amount)
end)

MRFW.Functions.CreateCallback('mr-jewellery:server:getactiverob', function(source, cb)
	cb(inusess)
end)

MRFW.Commands.Add("ljrob", "Lock Jewelery Robbery", {}, false, function(source, args)
    inusess = false
	for k, v in pairs(Config.Locations) do
        Config.Locations[k]["isOpened"] = false
        TriggerClientEvent('mr-jewellery:client:setVitrineState', -1, 'isOpened', false, k)
        TriggerClientEvent('mr-jewellery:client:setAlertState', -1, false)
        TriggerEvent('mr-scoreboard:server:SetActivityBusy', "jewellery", false)
        TriggerEvent('mr-jewellery:server:updateTable', false)
    end
    timeOut = false
    alarmTriggered = false
end, 'police')
