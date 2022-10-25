AJFW = exports['ajfw']:GetCoreObject()

-- Code

RegisterNetEvent('aj-policealerts:server:AddPoliceAlert')
AddEventHandler('aj-policealerts:server:AddPoliceAlert', function(data, forBoth)
    forBoth = forBoth ~= nil and forBoth or false
    TriggerClientEvent('aj-policealerts:client:AddPoliceAlert', -1, data, forBoth)
end)