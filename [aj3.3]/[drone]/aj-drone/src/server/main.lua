local AJFW = exports['ajfw']:GetCoreObject()

RegisterServerEvent("Drones:Disconnect")
AddEventHandler('Drones:Disconnect', function(drone, drone_data, pos)
    local src = source
    local xPlayer = AJFW.Functions.GetPlayer(src)
    TriggerClientEvent('Drones:DropDrone', xPlayer.PlayerData.source, drone, drone_data, pos)
end)

RegisterServerEvent("Drones:Back")
AddEventHandler('Drones:Back', function(drone_data)
    local src = source
    local xPlayer = AJFW.Functions.GetPlayer(src)
    xPlayer.Functions.AddItem(drone_data.name, 1)
end)

AJFW.Functions.CreateUseableItem("drone", function(source)
    local xPlayer = AJFW.Functions.GetPlayer(source)

    local drone_data = Config.Drones[1]
    TriggerClientEvent("Drones:UseDrone", source, drone_data)
    xPlayer.Functions.RemoveItem('drone', 1)
end)

AJFW.Functions.CreateUseableItem("drone2", function(source)
    local xPlayer = AJFW.Functions.GetPlayer(source)

    local drone_data = Config.Drones[2]
    TriggerClientEvent("Drones:UseDrone", source, drone_data)
    xPlayer.Functions.RemoveItem('drone2', 1)
end)

AJFW.Functions.CreateUseableItem("drone3", function(source)
    local xPlayer = AJFW.Functions.GetPlayer(source)

    local drone_data = Config.Drones[3]
    TriggerClientEvent("Drones:UseDrone", source, drone_data)
    xPlayer.Functions.RemoveItem('drone3', 1)
end)

AJFW.Functions.CreateUseableItem("drone4", function(source)
    local xPlayer = AJFW.Functions.GetPlayer(source)

    local drone_data = Config.Drones[4]
    TriggerClientEvent("Drones:UseDrone", source, drone_data)
    xPlayer.Functions.RemoveItem('drone4', 1)
end)

AJFW.Functions.CreateUseableItem("drone5", function(source)
    local xPlayer = AJFW.Functions.GetPlayer(source)

    local drone_data = Config.Drones[5]
    TriggerClientEvent("Drones:UseDrone", source, drone_data)
    xPlayer.Functions.RemoveItem('drone5', 1)
end)

AJFW.Functions.CreateUseableItem("drone6", function(source)
    local xPlayer = AJFW.Functions.GetPlayer(source)

    local drone_data = Config.Drones[6]
    TriggerClientEvent("Drones:UseDrone", source, drone_data)
    xPlayer.Functions.RemoveItem('drone6', 1)
end)

AJFW.Functions.CreateUseableItem("drone7", function(source)
    local xPlayer = AJFW.Functions.GetPlayer(source)

    local drone_data = Config.Drones[7]
    TriggerClientEvent("Drones:UseDrone", source, drone_data)
    xPlayer.Functions.RemoveItem('drone7', 1)
end)