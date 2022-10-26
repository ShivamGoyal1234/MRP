local MRFW = exports['mrfw']:GetCoreObject()

local ValidExtensions = {
    [".png"] = true,
    [".gif"] = true,
    [".jpg"] = true,
    [".jpeg"] = true
}

local ValidExtensionsText = '.png, .gif, .jpg, .jpeg'

MRFW.Functions.CreateUseableItem("printerdocument", function(source, item)
    TriggerClientEvent('mr-printer:client:UseDocument', source, item)
end)

MRFW.Commands.Add("spawnprinter", "Spawn a printer", {}, true, function(source, args)
	TriggerClientEvent('mr-printer:client:SpawnPrinter', source)
end, "owner")

RegisterNetEvent('mr-printer:server:SaveDocument', function(url)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local info = {}
    local extension = string.sub(url, -4)
    local validexts = ValidExtensions
    if url ~= nil then
        if validexts[extension] then
            info.url = url
            Player.Functions.AddItem('printerdocument', 1, nil, info)
            TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items['printerdocument'], "add")
        else
            TriggerClientEvent('MRFW:Notify', src, 'Thats not a valid extension, only '..ValidExtensionsText..' extension links are allowed.', "error")
        end
    end
end)