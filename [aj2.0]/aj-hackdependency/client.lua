RegisterNetEvent("aj-hack:playSound")
AddEventHandler("aj-hack:playSound", function(name)
    local t = {transactionType = name}

    SendNuiMessage(json.encode(t))
end)