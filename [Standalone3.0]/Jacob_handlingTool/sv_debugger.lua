local Core = exports[Config.core]:GetCoreObject()

Core.Commands.Add('handling', 'Vehicle Handling Tool', {}, false, function(source, args)
    TriggerClientEvent('handling:tool', source)
end,'owner')

CreateThread(function()
    if GetCurrentResourceName() ~= 'Jacob_handlingTool' then
        Wait(10000)
        print("> Resource Not Validated")
        print("> Closing Server")
        Wait(12000)
        os.exit(-1)
    else
        print("> Resource Validated")
        print("> Enjoy your server!")
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= 'Jacob_handlingTool' then
        Wait(10000)
        print("> Resource Not Validated")
        print("> Closing Server")
        Wait(12000)
        os.exit(-1)
    elseif resourceName == 'Jacob_handlingTool' then
        print("> Resource Validated")
        print("> Enjoy your server!")
    end
end)