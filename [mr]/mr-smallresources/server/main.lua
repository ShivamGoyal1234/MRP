local VehicleNitrous = {}

RegisterNetEvent('tackle:server:TacklePlayer', function(playerId)
    TriggerClientEvent("tackle:client:GetTackled", playerId)
end)

MRFW.Functions.CreateCallback('nos:GetNosLoadedVehs', function(source, cb)
    cb(VehicleNitrous)
end)

MRFW.Commands.Add("id", "Check Your ID #", {}, false, function(source, args)
    TriggerClientEvent('MRFW:Notify', source,  "ID: "..source)
end)

MRFW.Functions.CreateUseableItem("harness", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
    TriggerClientEvent('seatbelt:client:UseHarness', source, item)
end)

RegisterNetEvent('equip:harness', function(item)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player.PlayerData.items[item.slot].info.uses - 1 == 0 then
        TriggerClientEvent("inventory:client:ItemBox", source, MRFW.Shared.Items['harness'], "remove")
        Player.Functions.RemoveItem('harness', 1)
    else
        Player.PlayerData.items[item.slot].info.uses = Player.PlayerData.items[item.slot].info.uses - 1
        Player.Functions.SetInventory(Player.PlayerData.items)
    end
end)

MRFW.Functions.CreateUseableItem("parachute", function(source, item)
  local Player = MRFW.Functions.GetPlayer(source)
    if item.info.uses > 0 then
        TriggerClientEvent("consumables:client:UseParachute", source, item)
    else
        TriggerClientEvent("MRFW:Notify", source, "parachute is damaged", "error", 10000)
    end
end)

RegisterNetEvent('equip:parachute', function(item)
  local src = source
  local Player = MRFW.Functions.GetPlayer(src)
  if Player.PlayerData.items[item.slot].info.uses - 1 == 0 then
      TriggerClientEvent("inventory:client:ItemBox", source, MRFW.Shared.Items['parachute'], "remove")
      Player.Functions.RemoveItem('parachute', 1)
  else
      Player.PlayerData.items[item.slot].info.uses = Player.PlayerData.items[item.slot].info.uses - 1
      Player.Functions.SetInventory(Player.PlayerData.items)
  end
end)

RegisterNetEvent('smallresources:server:ragdoll', function()
  local src = source
  local Player = MRFW.Functions.GetPlayer(src)
  if Player ~= nil then
    local w = MRFW.Player.LoadInventory(Player.PlayerData)
    local a = MRFW.Player.GetTotalWeight(w.items)
    TriggerClientEvent("smallresources:client:ragdoll", src, a)
  end
end)

RegisterNetEvent('seatbelt:DoHarnessDamage', function(hp, data)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)

    if hp == 0 then
        Player.Functions.RemoveItem('harness', 1, data.slot)
    else
        Player.PlayerData.items[data.slot].info.uses = Player.PlayerData.items[data.slot].info.uses - 1
        Player.Functions.SetInventory(Player.PlayerData.items)
    end
end)

MRFW.Functions.CreateCallback('smallresources:server:GetCurrentPlayers', function(source, cb)
    local TotalPlayers = 0
    for k, v in pairs(MRFW.Functions.GetPlayers()) do
        TotalPlayers = TotalPlayers + 1
    end
    cb(TotalPlayers)
end)

-- MRFW.Commands.Add("givecash", "Give money to a person", {{name="id", help="Player ID"},{name="amount", help="Amount of money"}}, true, function(source, args)
--     local Player = MRFW.Functions.GetPlayer(source)
--     local TargetId = tonumber(args[1])
--     local Target = MRFW.Functions.GetPlayer(TargetId)
--     local amount = tonumber(args[2])
    
--     if Target ~= nil then
--       if amount ~= nil then
--         if amount > 0 then
--           if Player.PlayerData.money.cash >= amount and amount > 0 then
--             if TargetId ~= source then
--               TriggerClientEvent('banking:client:CheckDistance', source, TargetId, amount)
--             else
--               TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "You can't give money to yourself.")     
--             end
--           else
--             TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "You do not have enough money.")
--           end
--         else
--           TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Quantity must be greater than 0.")
--         end
--       else
--         TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Fill an amount.")
--       end
--     else
--       TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Citizen is not in the city.")
--     end    
-- end)
  
RegisterNetEvent('banking:server:giveCash', function(trgtId, amount)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local Target = MRFW.Functions.GetPlayer(trgtId)
  
    -- print(src)
    -- print(trgtId)
  
    if src ~= trgtId then
      Player.Functions.RemoveMoney('cash', amount, "Cash given to "..Player.PlayerData.citizenid)
      Target.Functions.AddMoney('cash', amount, "Cash received from "..Target.PlayerData.citizenid)
  
      TriggerEvent("mr-log:server:CreateLog", "banking", "Give money", "blue", "**"..GetPlayerName(src) .. "** has $"..amount.." given to **" .. GetPlayerName(trgtId) .. "**")
      
      TriggerClientEvent('MRFW:Notify', trgtId, "You received $"..amount.." of "..Player.PlayerData.charinfo.firstname.."!", 'success')
      TriggerClientEvent('MRFW:Notify', src, "You gave $"..amount.." for "..Target.PlayerData.charinfo.firstname.."!", 'success')
    else
      TriggerEvent("mr-anticheat:server:banPlayer", "Cheating")
      TriggerEvent("mr-log:server:CreateLog", "anticheat", "Player banished! (Not really natural, this is a test, duuuhhh)", "red", "** @everyone " ..GetPlayerName(player).. "** has tried to **"..amount.."reveal oneself")  
    end
end)

MRFW.Functions.CreateCallback('joint:ingredient', function(source, cb)
  local src = source
  local Ply = MRFW.Functions.GetPlayer(src)
  local weed_2og = Ply.Functions.GetItemByName("weed_2og")
  local rolling_paper = Ply.Functions.GetItemByName("rolling_paper")
  
  if weed_2og ~= nil and rolling_paper ~= nil then
      cb(true)
else
      cb(false)
  end
end)

MRFW.Functions.CreateCallback('sjoint:ingredient', function(source, cb)
local src = source
local Ply = MRFW.Functions.GetPlayer(src)
local weed_skunk = Ply.Functions.GetItemByName("weed_skunk")
local rolling_paper = Ply.Functions.GetItemByName("rolling_paper")

if weed_skunk ~= nil and rolling_paper ~= nil then
    cb(true)
else
    cb(false)
end
end)

MRFW.Commands.Add('cinematic', 'Add cinematic bar', { { name = 'size', help = 'Bar size(0 to 10)' }, }, true, function(source, args)
  local size=tonumber(args[1])
  if size and size >= 0 and size<=10 then
      local src = source
      TriggerClientEvent('mr-smallresources:client:cinematic', src, size)
  end
end, 'user')