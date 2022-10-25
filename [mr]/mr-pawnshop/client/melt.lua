local openingDoor = false

RegisterNetEvent("MRFW:Client:OnPlayerLoaded")
AddEventHandler("MRFW:Client:OnPlayerLoaded", function()
    MRFW.Functions.TriggerCallback('mr-pawnshop:melting:server:GetConfig', function(IsMelting, MeltTime, CanTake)
        Config.IsMelting = IsMelting
        Config.MeltTime = MeltTime
        Config.CanTake = CanTake

        if Config.IsMelting then
            Citizen.CreateThread(function()
                while Config.IsMelting do
                    if LocalPlayer.state['isLoggedIn'] then
                        Config.MeltTime = Config.MeltTime - 1
                        if Config.MeltTime <= 0 then
                            Config.CanTake = true
                            Config.IsMelting = false
                        end
                    else
                        break
                    end
                    Citizen.Wait(1000)
                end
            end)
        end
    end)
end)

RegisterNetEvent("MRFW:Client:OnPlayerUnload")
AddEventHandler("MRFW:Client:OnPlayerUnload", function()
    Config.IsMelting = false
    Config.MeltTime = 300
    Config.CanTake = false
end)

Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(5)
		local inRange = false
		local pos = GetEntityCoords(PlayerPedId())
		if #(pos - Config.MeltLocation) < 3.0 then
			inRange = true
			if #(pos - Config.MeltLocation) < 1.5 then
                if not Config.IsMelting then
                    if Config.CanTake then
                        DrawText3D(Config.MeltLocation.x, Config.MeltLocation.y, Config.MeltLocation.z, "~g~E~w~ - Grab gold bars")
                        if IsControlJustReleased(0, 38) then
                            TriggerServerEvent("mr-pawnshop:server:getGoldBars")
                        end
                    else
                        DrawText3D(Config.MeltLocation.x, Config.MeltLocation.y, Config.MeltLocation.z, "~g~E~w~ - Melt Gold Items")
                        if IsControlJustReleased(0, 38) then 
                            local waitTime = math.random(10000, 15000)
                            ScrapAnim(1000)
                            MRFW.Functions.Progressbar("drop_golden_stuff", "Grab Items", 1000, false, true, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {}, {}, {}, function() -- Done
                                if not Config.IsMelting then
                                    StopAnimTask(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 1.0)
                                    TriggerServerEvent("mr-pawnshop:server:meltItems")
                                end
                            end)
                        end
                    end
                elseif Config.IsMelting and Config.MeltTime > 0 then
                    DrawText3D(Config.MeltLocation.x, Config.MeltLocation.y, Config.MeltLocation.z, "Melting: " .. Config.MeltTime..'s')
                end
			end
		end
		if not inRange then
			Citizen.Wait(2500)
		end
	end
end)
local sellItemsSet = false
local hasGold = false
Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(5)
		local inRange = false
		local pos = GetEntityCoords(PlayerPedId())
		if #(pos - Config.SellGold) < 3.0 then
			inRange = true
            if #(pos - Config.SellGold) < 1.5 then
                if GetClockHours() >= 9 and GetClockHours() <= 18 then
                    if not sellItemsSet then 
						hasGold = HasPlayerGold()
						sellItemsSet = true
                    elseif sellItemsSet and hasGold then
                        DrawText3D(Config.SellGold.x, Config.SellGold.y, Config.SellGold.z, "~g~E~w~ - Sell Gold Bars")
                        if IsControlJustReleased(0, 38) then
                            local lockpickTime = 20000
                            ScrapAnim(lockpickTime)
                            MRFW.Functions.Progressbar("sell_gold", "Selling Gold", lockpickTime, false, true, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {
                                animDict = "veh@break_in@0h@p_m_one@",
                                anim = "low_force_entry_ds",
                                flags = 16,
                            }, {}, {}, function() -- Done
                                openingDoor = false
                                ClearPedTasks(PlayerPedId())
                                TriggerServerEvent('mr-pawnshop:server:sellGold')
                            end, function() -- Cancel
                                openingDoor = false
                                ClearPedTasks(PlayerPedId())
                                MRFW.Functions.Notify("Process Canceled", "error")
                            end)
                        end
                    else
                        DrawText3D(Config.SellGold.x, Config.SellGold.y, Config.SellGold.z, "You have no gold on you")
                    end
                    
                else
                    DrawText3D(Config.SellGold.x, Config.SellGold.y, Config.SellGold.z, "Trader is not available")
                end
			end
		end
        if not inRange then
            sellItemsSet = false
			Citizen.Wait(2500)
		end
	end
end)

function ScrapAnim(time)
    local time = time / 1000
    loadAnimDict("mp_car_bomb")
    TaskPlayAnim(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic" ,3.0, 3.0, -1, 16, 0, false, false, false)
    openingDoor = true
    Citizen.CreateThread(function()
        while openingDoor do
            TaskPlayAnim(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
            Citizen.Wait(2000)
            time = time - 2
            if time <= 0 then
                openingDoor = false
                StopAnimTask(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 1.0)
            end
        end
    end)
end

function HasPlayerGold()
	local retval = false
	MRFW.Functions.TriggerCallback('mr-pawnshop:server:hasGold', function(result)
		retval = result
	end)
    Citizen.Wait(500)
	return retval
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

RegisterNetEvent('mr-pawnshop:client:startMelting')
AddEventHandler('mr-pawnshop:client:startMelting', function()
    if not Config.IsMelting then
        Config.IsMelting = true
        Config.MeltTime = 300
        Citizen.CreateThread(function()
            while Config.IsMelting do
                if LocalPlayer.state['isLoggedIn'] then
                    Config.MeltTime = Config.MeltTime - 1
                    if Config.MeltTime <= 0 then
                        Config.CanTake = true
                        Config.IsMelting = false
                    end
                else
                    break
                end
                Citizen.Wait(1000)
            end
        end)
    end
end)

RegisterNetEvent('mr-pawnshop:client:SetTakeState')
AddEventHandler('mr-pawnshop:client:SetTakeState', function(state)
    Config.CanTake = state
    Config.IsMelting = state
    if not state then
        Config.MeltTime = 300
    end

    MRFW.Functions.TriggerCallback('mr-pawnshop:melting:server:GetConfig', function(IsMelting, MeltTime, CanTake)
        Config.IsMelting = IsMelting
        Config.MeltTime = MeltTime
        Config.CanTake = CanTake

        if Config.IsMelting then
            Citizen.CreateThread(function()
                while Config.IsMelting do
                    if LocalPlayer.state['isLoggedIn'] then
                        Config.MeltTime = Config.MeltTime - 1
                        if Config.MeltTime <= 0 then
                            Config.CanTake = true
                            Config.IsMelting = false
                        end
                    else
                        break
                    end
                    Citizen.Wait(1000)
                end
            end)
        end
    end)
end)