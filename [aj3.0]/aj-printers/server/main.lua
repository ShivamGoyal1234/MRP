local AJFW = exports['ajfw']:GetCoreObject()

local ValidExtensions = {
    [".png"] = true,
    [".gif"] = true,
    [".jpg"] = true,
    [".jpeg"] = true
}

local ValidExtensionsText = '.png, .gif, .jpg, .jpeg'

AJFW.Functions.CreateUseableItem("printerdocument", function(source, item)
    TriggerClientEvent('aj-printer:client:UseDocument', source, item)
end)

AJFW.Commands.Add("spawnprinter", "Spawn a printer", {}, true, function(source, args)
	TriggerClientEvent('aj-printer:client:SpawnPrinter', source)
end, "owner")

RegisterNetEvent('aj-printer:server:SaveDocument', function(url)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local info = {}
    local extension = string.sub(url, -4)
    local validexts = ValidExtensions
    if url ~= nil then
        if validexts[extension] then
            info.url = url
            Player.Functions.AddItem('printerdocument', 1, nil, info)
            TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items['printerdocument'], "add")
        else
            TriggerClientEvent('AJFW:Notify', src, 'Thats not a valid extension, only '..ValidExtensionsText..' extension links are allowed.', "error")
        end
    end
end)