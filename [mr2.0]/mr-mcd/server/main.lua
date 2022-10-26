MRFW = exports['mrfw']:GetCoreObject()

MRFW.Functions.CreateCallback('mr-mcd:server:IsmcdAvailable', function(source, cb)
	local amount = 0
	for k, v in pairs(MRFW.Functions.GetPlayers()) do
        local Player = MRFW.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "mcd" and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
    end
    cb(amount)
end)




