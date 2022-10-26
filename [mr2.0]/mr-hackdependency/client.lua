RegisterNetEvent("mr-hack:playSound")
AddEventHandler("mr-hack:playSound", function(name)
    local t = {transactionType = name}

    SendNuiMessage(json.encode(t))
end)