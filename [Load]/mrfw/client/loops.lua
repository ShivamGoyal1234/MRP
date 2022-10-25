CreateThread(function()
    while true do
        Wait(0)
        if LocalPlayer.state['isLoggedIn'] then
            Wait((1000 * 60) * MRFW.Config.UpdateInterval)
            TriggerServerEvent('MRFW:UpdatePlayer')
        else
            Wait(2500)
        end
    end
end)

CreateThread(function()
	while true do
		Wait(5)
		if LocalPlayer.state['isLoggedIn'] then
			Wait((1000 * 60) * 10)
            -- print('run')
			TriggerServerEvent("MRFW:Player:UpdatePlayerPayment")
		else
			Wait(5000)
		end
	end
end)

CreateThread(function()
    while true do
        Wait(MRFW.Config.StatusInterval)
        if LocalPlayer.state['isLoggedIn'] then
            if MRFW.Functions.GetPlayerData().metadata['hunger'] <= 0 or
                    MRFW.Functions.GetPlayerData().metadata['thirst'] <= 0 and (not PlayerData.metadata['isdead']) then
                local ped = PlayerPedId()
                local currentHealth = GetEntityHealth(ped)
                SetEntityHealth(ped, currentHealth - math.random(5, 10))
            end
        end
    end
end)