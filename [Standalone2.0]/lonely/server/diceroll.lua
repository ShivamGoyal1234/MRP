-- MRFW = nil

-- TriggerEvent('MRFW:GetObject', function(obj) MRFW = obj end) -- Getest op mn eigen framework dus moet je ff verandere naar t inladen van ESX

MRFW.Commands.Add("roll", "Roll a number of dice :)", {{name="ammount", help="Amount of dices"}, {name="sides", help="Amount of sides of the dice"}}, true, function(source, args) -- Eigen add command functie mot je vervangen naar esx versie
    local amount = tonumber(args[1])
    local sides = tonumber(args[2])
    local src = source
    local Players = MRFW.Functions.GetPlayers()
    if (sides > 0 and sides <= DiceRoll.maxsides) and (amount > 0 and amount <= DiceRoll.maxamount) then 
        local result = {}
        for i=1, amount do 
            table.insert(result, math.random(1, sides))
        end
        for k,v in pairs(Players) do
			local ply = GetPlayerPed(src)
			local target = GetPlayerPed(v)
			local dist = #( GetEntityCoords(ply) - GetEntityCoords(target) )
			if dist < 5 then
				TriggerClientEvent("diceroll:client:roll", v, source, DiceRoll.maxdistance, result, sides)
			end
		end
    else
        TriggerClientEvent('MRFW:Notify', source, "Too many sides of 0 (max: "..DiceRoll.maxsides..") or amount of dices or 0 (max: "..DiceRoll.maxamount..")", "error") -- Hier moet je ff esx melding neerzetten
    end
end)