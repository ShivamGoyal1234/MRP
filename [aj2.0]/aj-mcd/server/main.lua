AJFW = exports['ajfw']:GetCoreObject()

AJFW.Functions.CreateCallback('aj-mcd:server:IsmcdAvailable', function(source, cb)
	local amount = 0
	for k, v in pairs(AJFW.Functions.GetPlayers()) do
        local Player = AJFW.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "mcd" and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
    end
    cb(amount)
end)




