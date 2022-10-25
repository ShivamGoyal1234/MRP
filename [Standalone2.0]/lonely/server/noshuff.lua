-- MRFW = nil
-- TriggerEvent('MRFW:GetObject', function(obj) MRFW = obj end)

-- Code

MRFW.Commands.Add("shuff", "Switch from seats", {}, false, function(source, args)
    TriggerClientEvent('mr-seatshuff:client:Shuff', source)
end)