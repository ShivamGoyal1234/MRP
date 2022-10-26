local MRFW = exports['mrfw']:GetCoreObject()
local sleep = 1 * 1000
local queueNumber = 0


AddEventHandler('onResourceStart', function (resource)
   if resource == GetCurrentResourceName() then
      Queue()
      DeleteExpiredContract()
      GenerateVIN()
      PerformHttpRequest('https://raw.githubusercontent.com/JustLazzy/jl-carboost/master/version', CheckVersion, 'GET')
   end
end)

Citizen.CreateThread(function()
   while true do
       local result = MySQL.Sync.fetchAll('SELECT * FROM players',{})
       if result[1] ~= nil then
           for k,v in pairs(result) do
               if v.timeout > 0 then
                   local t = v.timeout -1
                   MySQL.Sync.execute('UPDATE players SET timeout = ? WHERE citizenid = ?',{ t, v.citizenid})
               end
           end
       end
       Citizen.Wait(3600000)
   end
end)
-- function to get next boost class?, hit me up if you what the better way to do this
local function GetNextClass(class)
   if class == 'D' then
      return 'C' 
   elseif class == 'C' then
      return 'B'
   elseif class == 'B' then
      return 'A'
   elseif class == 'A' then
      return 'S'
   elseif class == 'S' then
      return 'S+'
   elseif class == 'S+' then
      return 'X'
   end
end

-- Event
RegisterNetEvent('jacob-carboost:server:saveBoostData', function (citizenid)
   MySQL.Async.execute('UPDATE boost_data SET data = @data WHERE citizenid = @citizenid', {
      ['@citizenid'] = citizenid,
      ['@data'] = json.encode(Config.QueueList[citizenid])
   })
end)

RegisterNetEvent('jacob-carboost:server:newContract', function (source)
   local src = source
   local Player = MRFW.Functions.GetPlayer(src)
   local citizenid = Player.PlayerData.citizenid
   local config = Config.QueueList[citizenid]
   local tier = RandomTier(config.tier)
   local car = Config.Tier[tier].car[math.random(#Config.Tier[tier].car)]
   local owner = Config.RandomName[math.random(1, #Config.RandomName)]
   local randomHour = math.random(Config.Expire)
   local contractData = {
      owner = owner,
      car = car,
      tier = tier,
      plate = RandomPlate(),
   }
   if #Config.QueueList[citizenid].contract <= Config.MaxContract then     
      MySQL.Async.insert('INSERT INTO boost_contract (owner, data, started, expire) VALUES (@owner, @data, NOW(),DATE_ADD(NOW(), INTERVAL @expire HOUR))', {
         ['@owner'] = citizenid,
         ['@data'] = json.encode(contractData),
         ['@expire'] = randomHour
      }, function (id)
         contractData.id = id
         contractData.expire = GetHoursFromNow(randomHour)
         Config.QueueList[citizenid].contract[#Config.QueueList[citizenid].contract+1] = contractData
         TriggerClientEvent('jacob-carboost:client:addContract', src, contractData)
      end)
   end
end)

RegisterNetEvent('jacob-carboost:server:joinQueue', function (status, citizenid)
   local src = source
   local Player = MRFW.Functions.GetPlayer(src)
   if status then
      Config.QueueList[citizenid] = {
         getContract = false,
         status = true,
         tier = Player.PlayerData.metadata['carboostclass'],
         startContract = false,
         contract = {}
      }
      queueNumber = queueNumber + 1
      TriggerEvent('jacob-carboost:server:log', 'Player with CID: '..citizenid..' joined the queue, queue number: '..queueNumber)
      TriggerEvent('jacob-carboost:server:getContract', Player.PlayerData.citizenid)
   else
      Config.QueueList[citizenid] = {
         status =  false,
         tier = Player.PlayerData.metadata['carboostclass'],
         startContract = false,
         contract = {}
      }
      queueNumber = queueNumber - 1
      if queueNumber < 0 then
         queueNumber = 0
      end
      TriggerEvent('jacob-carboost:server:log', 'Player with CID: '..citizenid..' has left the queue, queue number: '..queueNumber)
   end
end)

-- This one is only for serverside
RegisterNetEvent('jacob-carboost:server:getContract', function (citizenid)
   local result = MySQL.Sync.fetchAll('SELECT * FROM boost_contract WHERE owner = @owner', {
      ['@owner'] = citizenid
   })
   if result[1] then
      for _, v in pairs(result) do
         Config.QueueList[citizenid].contract[#Config.QueueList[citizenid].contract+1] = json.decode(v.data)
      end
   end
end)

RegisterNetEvent('jacob-carboost:server:takeItem', function (name, quantity)
   local src = source
   local Player = MRFW.Functions.GetPlayer(src)
   Player.Functions.AddItem(name, quantity)
   TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items[name], "add")
end)

RegisterNetEvent('jacob-carboost:server:getItem', function ()
   local src = source
   local pData = MRFW.Functions.GetPlayer(src)
   local result = MySQL.Sync.fetchScalar('SELECT items FROM bennys_shop WHERE citizenid = @citizenid', {
      ['@citizenid'] = pData.PlayerData.citizenid
   })
   if result then
      TriggerClientEvent('jacob-carboost:client:setConfig', src, json.decode(result))
   end
end)

RegisterNetEvent('jacob-carboost:server:setConfig', function ()
   TriggerClientEvent('jacob-carboost:client:setConfig', -1, Config.BennysItems)
end)

RegisterNetEvent('jacob-carboost:server:giveContract', function ()
   local src = source
   local pData = MRFW.Functions.GetPlayer(src)
   TriggerEvent('jacob-carboost:server:newContract', src,pData.PlayerData.citizenid)
end)

RegisterNetEvent('jacob-carboost:server:buyItem', function (price, config, first)
   local src = source 
   local pData = MRFW.Functions.GetPlayer(src)
   pData.Functions.RemoveMoney('bank', price, 'bought-bennys-item')
      MySQL.Async.insert('INSERT INTO bennys_shop (citizenid, items) VALUES (@citizenid, @items) ON DUPLICATE KEY UPDATE items = @items', {
         ['@citizenid'] = pData.PlayerData.citizenid,
         ['@items'] = json.encode(config)
      })
end)

RegisterNetEvent('jacob-carboost:server:log', function (string, type)
   if type == "discord" then
   else
      print(string)
   end
end)

RegisterNetEvent('jacob-carboost:server:finishBoosting', function (type, tier)
   local isNextLevel = false
   local src = source
   local pData = MRFW.Functions.GetPlayer(src)
   local configTier = Config.Tier[tier]
   local amountMoney = math.random(configTier.priceminimum, configTier.pricemaximum)
   local currentRep = pData.PlayerData.metadata['carboostrep']
   local randomRep = math.random(Config.MinRep, Config.MaxRep)
   if type ~= 'vin' then
      pData.Functions.AddMoney(Config.Payment, amountMoney, 'finished-boosting')
      -- pData.Functions.AddItem('vehicleticket',math.random(1,2))
      local chance = math.random(1, 100)
      if chance < 80 then
         pData.Functions.AddItem("vehicleticket", 1, false)
         TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items["vehicleticket"], "add")
      end
      if Config.Payment == 'crypto' then
         TriggerClientEvent('MRFW:Notify', src, Lang:t('info.payment_crypto', {
            amount = amountMoney
         }), 'success')
      end
      local total = currentRep + randomRep
      if total >= 500 then
         total = total - 500
         local class = GetNextClass(pData.PlayerData.metadata['carboostclass'])
         pData.Functions.SetMetaData('carboostclass', class)
         isNextLevel = true
      end
      pData.Functions.SetMetaData("carboostrep", total)
      TriggerClientEvent('jacob-carboost:client:updateProggress', src, isNextLevel)
      TriggerClientEvent('MRFW:Notify', src, Lang:t('info.get_rep', {
         rep = randomRep
      }), "primary")  
   end 
end)

RegisterNetEvent('jacob-carboost:server:deleteContract', function (contractid)
   local src = source
   local Player = MRFW.Functions.GetPlayer(src)
   MySQL.Async.execute('DELETE FROM boost_contract WHERE owner = @citizenid AND id = @id',{
      ['@citizenid'] = Player.PlayerData.citizenid,
      ['@id'] = contractid
   }, function (result)
      if result > 0 then
         TriggerEvent('jacob-carboost:server:log', 'Contract '..contractid..' deleted, CID:'..Player.PlayerData.citizenid)
      end
   end)
   -- print("END OF THE DELETE CONTRACT")
end)

RegisterNetEvent('jacob-carboost:server:updateBennysConfig', function (data)
   local src = source 
   local pData = MRFW.Functions.GetPlayer(src)
   MySQL.Async.execute('UPDATE bennys_shop SET items = @items WHERE citizenid = @citizenid', {
      ['@citizenid'] = pData.PlayerData.citizenid,
      ['@items'] = json.encode(data)
   })
end)

RegisterNetEvent('jacob-carboost:server:vinscratch', function(NetworkID, mods, model)
   local src = source 
   local pData = MRFW.Functions.GetPlayer(src)
   local entity = NetworkGetEntityFromNetworkId(NetworkID)
   local plate = GetVehicleNumberPlateText(entity)
   local citizenid = pData.PlayerData.citizenid
   local timeout = MySQL.Sync.prepare('SELECT timeout FROM players WHERE citizenid = ?',{citizenid})
   if timeout == 0 then
      pData.Functions.RemoveItem('vehicleticket',3)
      MySQL.Sync.execute('UPDATE players SET timeout = ? WHERE citizenid = ?',{Config.Timeout, citizenid})
      MySQL.Async.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state, vinscratch, vinnumber) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)', {
         pData.PlayerData.license,
         pData.PlayerData.citizenid,
         model,
         entity,
         json.encode(mods),
         plate,
         0,
         1,
         RandomVIN()
      })
      TriggerClientEvent('vehiclekeys:client:SetOwner', src, plate)
      TriggerClientEvent("MRFW:Notify", src, "VIN Scratched, you can change your plate number", "error", 5000)
      TriggerEvent("mr-log:server:CreateLog", 'cardelivery', "Scratch", "blue", '**Source**: '..pData.PlayerData.name..'\n**car**: '..model..'\n**plate**: '..plate)
   else
      TriggerClientEvent("MRFW:Notify", src, "Please wait "..timeout.." hour(s) before doing this thing again", "error", 5000)
   end
end)

MRFW.Commands.Add('settier', 'Set Boosting Tier', {
   {
      name = 'tier',
      help = 'Tier of contract, D,C,B,A,S,S+,X'
   },
   {
      name = 'id',
      help = 'Player ID',
   },
}, false,function (source,args)
   local src = source
   if not args[1] or not type(args[1]) == "string" or Config.Tier[tostring(args[1])] == nil then
      return TriggerClientEvent('MRFW:Notify', src, Lang:t('error.invalid_tier'), "error")
   end
   local PlayerID = tonumber(args[2])
   local player
   if PlayerID then
      player = MRFW.Functions.GetPlayer(PlayerID)
      if not player or player == nil then
         return TriggerClientEvent('MRFW:Notify', src, Lang:t('error.invalid_player'), "error")
      end
   else
      player = MRFW.Functions.GetPlayer(src)
   end
   player.Functions.SetMetaData('carboostclass', tostring(args[1]))
   TriggerClientEvent('MRFW:Notify', src, Lang:t('success.set_tier', {
      tier = args[1]
   }), "success")
end, 'god')

MRFW.Commands.Add('giveContract', 'Give contract, admin only', {
   {
      name = 'tier',
      help = 'Tier of contract, D, C, B, A, S, S+, X',
   },
   {
      name = 'playerid',
      help = 'Player id',
   }
}, false, function(source, args)
   local src = source
   local PlayerID =  tonumber(args[2])
   local player
   if type(args[1]) == "number" then
      return TriggerClientEvent('MRFW:Notify', src, Lang:t('error.invalid_tier'), "error")
   end
   if PlayerID then
      player = MRFW.Functions.GetPlayer(PlayerID)
      if not player or player == nil then
         return TriggerClientEvent('MRFW:Notify', src, Lang:t('error.invalid_player'), "error")
      end
   else
      player = MRFW.Functions.GetPlayer(src)
   end
   if Config.Tier[tostring(args[1])] ~= nil then
      local config = Config.Tier[tostring(args[1])]
      local car = config.car[math.random(#config.car)]
      local owner = Config.RandomName[math.random(1, #Config.RandomName)]
      local expireTime = math.random(Config.Expire)
      local contractData = {
         owner = owner,
         car = car,
         tier = args[1],
         plate = RandomPlate(),
         
      }
      MySQL.Async.insert('INSERT INTO boost_contract (owner, data, started, expire) VALUES (@owner, @data, NOW(),DATE_ADD(NOW(), INTERVAL @expire HOUR))', {
         ['@owner'] = player.PlayerData.citizenid,
         ['@data'] = json.encode(contractData),
         ['@expire'] = expireTime
      }, function (id)
         contractData.id = id
         contractData.expire = GetHoursFromNow(expireTime)
         TriggerClientEvent('jacob-carboost:client:addContract', player.PlayerData.source, contractData)
         TriggerClientEvent('MRFW:Notify', src, Lang:t('success.contract_give', {
            player = player.PlayerData.name,
         }), "success")
      end)

   else
      return TriggerClientEvent('MRFW:Notify', src, Lang:t('error.invalid_tier'), "error")
   end
end, 'god')

RegisterNetEvent('jacob-carboost:server:takeAll', function (data)
   local src = source
   local Player = MRFW.Functions.GetPlayer(src)
   for _, v in pairs(data) do
      local item = v.item
      Player.Functions.AddItem(item.name, item.quantity)
      -- print(item.name)
      TriggerClientEvent('inventory:client:itemBox', src, MRFW.Shared.Items[item.name], 'add')
   end
   MySQL.Async.execute('UPDATE bennys_shop SET items = @items WHERE citizenid = @citizenid', {
      ['@citizenid'] = Player.PlayerData.citizenid,
      ['@items'] = json.encode({})
   })
   TriggerClientEvent('MRFW:Notify', src, Lang:t('success.take_all'), "success")
end)

RegisterNetEvent('jacob-carboost:server:getBoostSale', function()
   local src = source
   local result = MySQL.Sync.fetchAll('SELECT * FROM boost_contract WHERE onsale = 1')
   if result[1] then
      TriggerClientEvent('jacob-carboost:client:loadBoostStore', src,result)
   end
end)

RegisterNetEvent('jacob-carboost:server:setPlate', function (oldPlate, newPlate)
   MySQL.Async.execute('UPDATE player_vehicles SET plate = @newPlate WHERE plate = @oldPlate', {
      ['@oldPlate'] = oldPlate,
      ['@newPlate'] = newPlate
   })
   TriggerEvent("mr-log:server:CreateLog", 'cardelivery', "Plate Change", "red", '**Old Plate**: '..oldPlate..'\n** New Plate**: '..newPlate)
end)

-- Alert
RegisterNetEvent('jacob-carboost:notifyboosting', function (pos, car)
   TriggerClientEvent('jacob-carboost:notifyboosting', -1, pos, car)
end)

RegisterNetEvent('jacob-carboost:notifypolice', function (car)
   TriggerClientEvent('jacob-carboost:notifypolice', -1, car)
end)

-- Callback
MRFW.Functions.CreateCallback('jacob-carboost:server:canBuy', function(source, cb, data)
   local src = source
   local pData = MRFW.Functions.GetPlayer(src)
   local bankAccount = pData.PlayerData.money["crypto"]
   if bankAccount >= data then
      cb(true)
   else
      cb(false)
   end
   return cb
end)

MRFW.Functions.CreateCallback('jacob-carboost:server:sellContract', function (source, cb, data, toggle)
   local data = data.data
   local src = source
   local Player = MRFW.Functions.GetPlayer(src)
   local result = MySQL.Sync.fetchAll('SELECT * FROM boost_contract WHERE id = @id AND owner = @owner', {
      ['@owner'] = Player.PlayerData.citizenid,
      ['@id'] = data.id
   })
   if toggle then
      return cb(false)
   end
   if result[1] then
      if tonumber(data.price) >= 10 and tonumber(data.price) <= 50 then
         local contractInfo = result[1]
         local contractData = json.decode(contractInfo.data)
         MySQL.Async.execute('UPDATE boost_contract SET price = @price, onsale = 1 WHERE id = @id AND owner = @owner', {
            ['@id'] = data.id,
            ['@price'] = tonumber(data.price),
            ['@owner'] = Player.PlayerData.citizenid
         })
         contractData.id = data.id
         contractData.expire = result[1].expire
         contractData.price = tonumber(data.price)
         TriggerClientEvent('jacob-carboost:client:newContractSale', -1, contractData)
         return cb({
            success = Lang:t('success.sell_contract', {
               amount = data.price,
               payment = Config.Payment
            })
         })
      else
         return cb(false)
      end
   end
end)

MRFW.Functions.CreateCallback('jacob-carboost:server:buycontract', function(source, cb, data)
   local src = source
   local Player = MRFW.Functions.GetPlayer(src)
   local toPlayer
   local result = MySQL.Sync.fetchAll('SELECT * FROM boost_contract WHERE id = @id AND onsale = 1', {
      ['@id'] = data.id
   })
   if result[1] then
      if Player.PlayerData.citizenid ==  result[1].owner then return cb({error = Lang:t('error.buy_yourcontract')}) end
      toPlayer = MRFW.Functions.GetPlayerByCitizenId(result[1].owner)
      if not toPlayer then
         return cb({error = Lang:t('error.player_not_found')})
      end
      local contractInfo = result[1]
      local moneyAmount = tonumber(contractInfo.price)
      local money = Player.PlayerData.money[Config.Payment]
      if money < moneyAmount then
         return cb({
            error = Lang:t('error.not_enough_money', {money = Config.Payment})
         })
      end
      local contractData = json.decode(contractInfo.data)
      if TierCheck(Player.PlayerData.metadata.carboostclass, contractData.tier) then
         Player.Functions.RemoveMoney(Config.Payment, moneyAmount, 'bought-contract')
         toPlayer.Functions.AddMoney(Config.Payment, moneyAmount, 'bought-contract')
         TriggerClientEvent('MRFW:Notify', toPlayer.PlayerData.source, Lang:t('info.contract_buyed', {amount = moneyAmount}), "success")
         MySQL.Async.execute('UPDATE boost_contract SET onsale = 0, owner = @owner WHERE id = @id', {
            ['@id'] = data.id,
            ['@owner'] = Player.PlayerData.citizenid
         })
         TriggerClientEvent('jacob-carboost:client:contractBought', -1, data.id)
         contractData.expire, contractData.id = result[1].expire, data.id
         TriggerClientEvent('jacob-carboost:client:addContract', src, contractData)
         return cb({
            success = Lang:t('success.buy_contract', {
               amount = moneyAmount,
               payment = Config.Payment
            })
         })
      else
         return cb({
            error = "Purchase Failed."
         })
      end
   end
end)

function TierCheck(var1,var2)
   local currentTier = var1
   local DataTier = var2
   local retval = false
   print(var1,var2)
   if currentTier == 'X' then
      retval = true
   elseif currentTier == 'S+' then
      if DataTier ~= 'X' then
         retval = true
      end
   elseif currentTier == 'S' then
      if DataTier ~= 'X' and DataTier ~= 'S+' then
         retval = true
      end
   elseif currentTier == 'A+' then
      if DataTier ~= 'X' and DataTier ~= 'S+' and DataTier ~= 'S' then
         retval = true
      end
   elseif currentTier == 'A' then
      if DataTier ~= 'X' and DataTier ~= 'S+' and DataTier ~= 'S' and 
         DataTier ~= 'A+' then
         retval = true
      end
   elseif currentTier == 'B' then
      if DataTier ~= 'X' and DataTier ~= 'S+' and DataTier ~= 'S' and 
         DataTier ~= 'A+' and DataTier ~= 'A' then
         retval = true
      end
   elseif currentTier == 'C' then
      if DataTier ~= 'X' and DataTier ~= 'S+' and DataTier ~= 'S' and 
         DataTier ~= 'A+' and DataTier ~= 'A' and DataTier ~= 'B' then
         retval = true
      end
   elseif currentTier == 'D' then
      if DataTier ~= 'X' and DataTier ~= 'S+' and DataTier ~= 'S' and 
         DataTier ~= 'A+' and DataTier ~= 'A' and DataTier ~= 'B' and 
         DataTier ~= 'C' then
         retval = true
      end
   end
   return retval
end

MRFW.Functions.CreateCallback('jacob-carboost:server:transfercontract', function (source, cb, data, toggle)
   local src = source
   local id = tonumber(data.id) 
   local contractid = tonumber(data.contractid)
   local toPlayer = MRFW.Functions.GetPlayer(id)
   local Player = MRFW.Functions.GetPlayer(src)
   if src == id then
      return cb({
         error = "You can't transfer contract to yourself"
      })
   end
   if toggle then
      return cb({
         error = 'Can\'t transfer because contract already started'
      })
   end
   if not toPlayer or not Player then
      return cb({
         error = "Invalid player"
      })
   end
   local result = MySQL.Sync.fetchAll('SELECT * FROM boost_contract WHERE id = @id AND owner = @owner', {
      ['@owner'] = Player.PlayerData.citizenid,
      ['@id'] = contractid
   })
   if result[1] then
      local data = json.decode(result[1].data)
      if TierCheck(toPlayer.PlayerData.metadata.carboostclass, data.tier)then
         MySQL.Async.execute('UPDATE boost_contract SET owner = @owner WHERE owner = @citizenid', {
            ['@owner'] = toPlayer.PlayerData.citizenid,
            ['@citizenid'] = Player.PlayerData.citizenid
         }, function ()
            local contractData = {
               id = contractid,
               owner = data.owner,
               car = data.car,
               tier = data.tier,
               plate = data.plate,
               expire = result[1].expire
            }
            TriggerClientEvent('MRFW:Notify', src, Lang:t('success.contract_transfer', {
               player = toPlayer.PlayerData.name
            }), "success")
            TriggerClientEvent('MRFW:Notify', id, Lang:t('info.receive_transfer', {
               player = Player.PlayerData.name,
            }), "primary")
            TriggerClientEvent('jacob-carboost:client:addContract', toPlayer.PlayerData.source, contractData)
            return cb({
               success = true
            })
         end)
      else
         return cb({
            error = "Transfer Failed."
         })
      end
   end
end)

MRFW.Functions.CreateCallback('jacob-carboost:server:vinmoney', function (source, cb, data)
   local src = source
   local Player = MRFW.Functions.GetPlayer(src)
   local money = Player.PlayerData.money[Config.Payment]
   if money > Config.Tier[data.tier].vinprice then
      Player.Functions.RemoveMoney(Config.Payment, Config.Tier[data.tier].vinprice, 'vin-money')
      return cb({
         success = true
      })
   else
      return cb({
         error = Lang:t('error.not_enough_money', {money = Config.Payment})
      })
   end
end)

MRFW.Functions.CreateCallback('jacob-carboost:server:getboostdata', function (source, cb, citizenid)
   local Player = MRFW.Functions.GetPlayerByCitizenId(citizenid)
   local contractData = {
      class = Player.PlayerData.metadata['carboostclass'],
      rep = Player.PlayerData.metadata['carboostrep'],
      contract = {}
   }
   local result = MySQL.Sync.fetchAll('SELECT * FROM boost_contract WHERE owner = @owner AND onsale = 0', {
      ['@owner'] = citizenid
   })
   if result[1] then
      for _, v in pairs(result) do
         if v.onsale == 1 then
            return
         end
         local data = json.decode(v.data)
         contractData.contract[#contractData.contract+1] = {
            id = v.id,
            owner = data.owner,
            car = data.car,
            tier = data.tier,
            plate = data.plate,
            expire = v.expire
         }
      end
   end
   return cb(contractData)
end)

MRFW.Functions.CreateCallback('jacob-carboost:server:getContractData', function (source, cb, data)
   if not data then return end
   local boostdata = data.data
   local Player = MRFW.Functions.GetPlayer(source)
   local result = MySQL.Sync.fetchAll('SELECT * FROM boost_contract WHERE id = @id AND owner = @owner', {
      ['@id'] = boostdata.id,
      ['@owner'] = Player.PlayerData.citizenid
   })
   if result[1] then
      local res = result[1]
      local contractdata = {
         id = res.id,
         type = boostdata.type,
         data = json.decode(res.data),
      }
      return cb(contractdata)
   end
end)

MRFW.Functions.CreateCallback('jacob-carboost:server:spawnCar', function (source, cb, data)
   local src = source
   local cardata = data
   local boosttier = Config.Tier[cardata.data.tier]
   local coords = boosttier.location[math.random(1, #boosttier.location)]
   local npcCoords
   if boosttier.spawnnpc then
      npcCoords = coords.npc
   end
   local carhash = GetHashKey(data.data.car)
   local CreateAutomobile = GetHashKey('CREATE_AUTOMOBILE')
   local car = Citizen.InvokeNative(CreateAutomobile, carhash, coords.car, coords.car.h, true, false)
   local data
   while not DoesEntityExist(car) do
      Wait(25)
   end
   if DoesEntityExist(car) then
      SetVehicleDoorsLocked(car, 2) -- Lock the vehicle
      SetVehicleNumberPlateText(car, cardata.data.plate)
      SetVehicleColours(car, math.random(159))
      local netId = NetworkGetNetworkIdFromEntity(car)
      data = {
         id = cardata.id,
         networkID = netId,
         spawnlocation = coords.car,
         npc = npcCoords,
         carmodel = car,
         car = cardata.data.car,
         type = cardata.type
      }
      cb(data)
   else
      data = {
         networkID = 0,
      }
      cb(data)
   end
end)

MRFW.Functions.CreateCallback('jacob-carboost:server:checkvin', function (source, cb, data)
   local src = source
   local veh = NetworkGetEntityFromNetworkId(data)
   local plate = GetVehicleNumberPlateText(veh)
   local result = MySQL.Sync.fetchAll('SELECT vinnumber, vinscratch,citizenid  FROM player_vehicles WHERE plate = @plate', {
      ['@plate'] = plate
   })
   if result[1] then
      local vin
      if result[1].vinscratch == 1 then
         if math.random() <= Config.VINChance then
            vin = "Seems like the VIN got scratched!"
         else
            vin = "The VIN number is: " .. result[1].vinnumber
         end
      else
         vin = "The VIN number is: " .. result[1].vinnumber
      end
      return cb({success = true, message = vin, vin = result[1].vinnumber, owner = result[1].citizenid, vinscratch = result[1].vinscratch})
   else
      return cb({success = false, message = "Test"})
   end
end)


-- Simple Queue System
function Queue()
   if queueNumber ~= 0 then
      local num = 0
      local player = 0
      local inqueue = 0
      Wait(Config.WaitTime * 1000 * 60)
      for k, v in pairs(Config.QueueList) do
         local Player = MRFW.Functions.GetPlayerByCitizenId(k)
         if not v.getContract and v.status and Player and num <= Config.MaxQueueContract then
            TriggerClientEvent('MRFW:Notify', Player.PlayerData.source, Lang:t('info.new_contract'), "primary")
            TriggerEvent('jacob-carboost:server:newContract', Player.PlayerData.source, k)
            num = (num or 0) + 1
            v.getContract = true
         end
         if v.getContract then
            inqueue = inqueue + 1
         end
         player = player + 1
      end
      if queueNumber == inqueue then
         inqueue = 0
         queueNumber = 0
      end
   end
   SetTimeout(sleep, function ()
      Queue()
   end)
end

-- Delete expired contracts
function DeleteExpiredContract()
   MySQL.Async.execute('DELETE FROM boost_contract WHERE expire < NOW()',{}, function (result)
      if result > 0 then
         -- print('Deleted ' .. result .. ' expired contracts')
      end
   end)
   SetTimeout(sleep,function ()
      DeleteExpiredContract()
   end)
end

function RandomVIN()
   local random = tostring(MRFW.Shared.RandomInt(3) .. MRFW.Shared.RandomStr(3) .. MRFW.Shared.RandomInt(2)):upper()
   return random
end

function CheckVersion(err, resp, headers)
   -- https://raw.githubusercontent.com/JustLazzy/jacob-carboost/master/version
   local curVersion = LoadResourceFile(GetCurrentResourceName(), 'version')
   if curVersion ~= resp and tonumber(curVersion) < tonumber(resp) then
      print('[jacob-carboost] New version available: ' .. resp)
   else
      print('[jacob-carboost] No new version available')
   end
end

function GenerateVIN()
   local result = MySQL.Sync.fetchAll('SELECT * FROM player_vehicles WHERE vinnumber IS NULL')
   if result[1] then
      for _, v in pairs(result) do
         local vin = RandomVIN()
         MySQL.Sync.execute('UPDATE player_vehicles SET vinnumber = @vin WHERE id = @id', {
            ['@vin'] = vin,
            ['@id'] = v.id
         })
      end
   end
end

-- Random Plate
function RandomPlate()
	local random = tostring(MRFW.Shared.RandomInt(1) .. MRFW.Shared.RandomStr(2) .. MRFW.Shared.RandomInt(3) .. MRFW.Shared.RandomStr(2)):upper()
   return random
end

function GetHoursFromNow(hours)
   local hours = tonumber(hours)
   local time = os.date("%c", os.time() + hours * 60 * 60)
   return time
end

function AddVIN(plate)
   local vin = RandomVIN()
   MySQL.Sync.execute('UPDATE player_vehicles SET vinnumber = @vin WHERE plate = @plate', {
      ['@vin'] = vin,
      ['@plate'] = plate
   })
end

RegisterNetEvent('jacob-testing', function ()
   local tier = RandomTier('A')
   -- print(tier)
end)

function RandomTier(tier)
   local chance = math.random(1, 100)
   local tierName = {
      'D',
      'C',
      'B',
      'A',
      'A+',
      'S',
      'S+',
      'X'
   }
   if tier == 'X' then
      if chance >= 98 then
         return 'X'
      else
         return tierName[math.random(1, 7)]
      end
   elseif tier == 'S+' then
      if chance >= 92 then
         return 'S+'
      else
         return tierName[math.random(1, 6)]
      end
   elseif tier == 'S' then
      if chance >= 80 then
         return 'S'
      else
         return tierName[math.random(1, 5)]
      end
   elseif tier == 'A+' then
      if chance >= 70 then
         return 'A+'
      else
         return tierName[math.random(1, 4)]
      end
   elseif tier == 'A' then
      if chance >= 70 then
         return 'A'
      else
         return tierName[math.random(1, 3)]
      end
   elseif tier == 'B' then
      if chance >= 70 then
         return 'B'
      else
         return tierName[math.random(1, 2)]
      end
   elseif tier == 'C' then
      if chance >= 70 then
         return 'C'
      else
         return tierName[math.random(1, 1)]
      end
   elseif tier == 'D' then
      return 'D'
   end
end

exports('AddVIN', AddVIN)

-- make the laptop usable
MRFW.Functions.CreateUseableItem('tablet2' , function(source, item)
   local Player = MRFW.Functions.GetPlayer(source)
   if Player.Functions.GetItemByName('tablet2') ~= nil then
      if item.info.uses >= 1 then
         TriggerClientEvent('jacob-carboost:client:openLaptop', source, item)
      else
         TriggerClientEvent("MRFW:Notify", source, "You System is corrupted", "error", 10000)
      end
   end
end)

-- MRFW.Functions.CreateUseableItem('hacking_device',  function (source, item)
--    TriggerClientEvent('jacob-carboost:client:useHackingDevice', source)
-- end)

MRFW.Functions.CreateUseableItem("disabler", function(source, item)
   local Player = MRFW.Functions.GetPlayer(source)
   if Player.Functions.GetItemByName('disabler') ~= nil then
       if item.info.uses >= 1 then
         TriggerClientEvent('jacob-carboost:client:useHackingDevice', source, item)
       else
           TriggerClientEvent("MRFW:Notify", source, "Chip Broken", "error", 10000)
       end
   end
end)

MRFW.Functions.CreateUseableItem('fake_plate', function(source, item)
   TriggerClientEvent('jacob-carboost:client:fakeplate', source)
end)

MRFW.Commands.Add('crypto', 'Check You Current Crypto Currency', {}, false, function(source, args)
   local src = source
   local Player = MRFW.Functions.GetPlayer(src)
   local crypto = Player.PlayerData.money.crypto
   TriggerClientEvent('chat:addMessage',src, {
      template = "<div class=chat-message server'>You Have <strong>(</strong> {0} <strong>)</strong> <strong>Cryptos</strong></div>",
      args = {crypto}
   })
end)