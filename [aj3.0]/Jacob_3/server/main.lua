local AJFW = exports['ajfw']:GetCoreObject()

-------------------Task 2 server side---------------------

AJFW.Commands.Add('getlocation', 'Get Your Loaction', {}, false, function(source, args)
    TriggerClientEvent("client:getpos", source)
end)
