MRFW.Functions.CreateUseableItem("fitbit", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
    TriggerClientEvent('mr-fitbit:use', source)
end)

RegisterServerEvent('mr-fitbit:server:setValue')
AddEventHandler('mr-fitbit:server:setValue', function(type, value)
    local src = source
    local ply = MRFW.Functions.GetPlayer(src)
    local fitbitData = {}

    if type == "thirst" then
        local currentMeta = ply.PlayerData.metadata["fitbit"]
        fitbitData = {
            thirst = value,
            food = currentMeta.food
        }
    elseif type == "food" then
        local currentMeta = ply.PlayerData.metadata["fitbit"]
        fitbitData = {
            thirst = currentMeta.thirst,
            food = value
        }
    end

    ply.Functions.SetMetaData('fitbit', fitbitData)
end)

MRFW.Functions.CreateCallback('mr-fitbit:server:HasFitbit', function(source, cb)
    local Ply = MRFW.Functions.GetPlayer(source)
    local Fitbit = Ply.Functions.GetItemByName("fitbit")

    if Fitbit ~= nil then
        cb(true)
    else
        cb(false)
    end
end)