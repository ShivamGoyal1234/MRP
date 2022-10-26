MRFW = exports['mrfw']:GetCoreObject()

-- Code

RegisterNetEvent('mr-policealerts:server:AddPoliceAlert')
AddEventHandler('mr-policealerts:server:AddPoliceAlert', function(data, forBoth)
    forBoth = forBoth ~= nil and forBoth or false
    TriggerClientEvent('mr-policealerts:client:AddPoliceAlert', -1, data, forBoth)
end)