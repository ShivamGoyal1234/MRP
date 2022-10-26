local MRFW = exports['mrfw']:GetCoreObject()

-------------------Task 2 server side---------------------

MRFW.Commands.Add('getlocation', 'Get Your Loaction', {}, false, function(source, args)
    TriggerClientEvent("client:getpos", source)
end)
