if Config.Framework == "NEW" then
    MRFW = exports['mrfw']:GetCoreObject()
elseif Config.Framework == "OLD" then 
    MRFW = nil
    TriggerEvent('MRFW:GetObject', function(obj) MRFW = obj end) 
else
    print("The Framework '", Config.Framework, "' is not support, please change in config.lua")
end

MRFW.Functions.CreateCallback('m-Repairs:server:VerificarGuita', function(source, cb)
    if MRFW.Functions.GetPlayer(source).Functions.RemoveMoney("cash", Config.Amount) then
        cb({
            state   = true,
        })
    else
        TriggerClientEvent('MRFW:Notify', source,Config["Language"]['Notificacoes']['SemGuita'], 'error', 3500)
    end
end)