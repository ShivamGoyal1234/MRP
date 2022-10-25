Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local inRange = true

        local PaletoDist = #(pos - Config.BigBanks["paleto"]["coords"])
        local PacificDist = #(pos - Config.BigBanks["pacific"]["coords"][2])

        if PaletoDist < 15 then
            inRange = true
            if Config.BigBanks["paleto"]["isOpened"] then
                TriggerServerEvent('nui_doorlock:server:updateState', 'paleto_door_1', false, nil, false, true, false)
                local object = GetClosestObjectOfType(Config.BigBanks["paleto"]["coords"]["x"], Config.BigBanks["paleto"]["coords"]["y"], Config.BigBanks["paleto"]["coords"]["z"], 5.0, Config.BigBanks["paleto"]["object"], false, false, false)
            
                if object ~= 0 then
                    SetEntityHeading(object, Config.BigBanks["paleto"]["heading"].open)
                end
            else
                TriggerServerEvent('nui_doorlock:server:updateState', 'paleto_door_1', true, nil, false, true, false)
                local object = GetClosestObjectOfType(Config.BigBanks["paleto"]["coords"]["x"], Config.BigBanks["paleto"]["coords"]["y"], Config.BigBanks["paleto"]["coords"]["z"], 5.0, Config.BigBanks["paleto"]["object"], false, false, false)
            
                if object ~= 0 then
                    SetEntityHeading(object, Config.BigBanks["paleto"]["heading"].closed)
                end
            end
        end

        -- Pacific Check
        if PacificDist < 50 then
            inRange = true
            if Config.BigBanks["pacific"]["isOpened"] then
                local object = GetClosestObjectOfType(Config.BigBanks["pacific"]["coords"][2]["x"], Config.BigBanks["pacific"]["coords"][2]["y"], Config.BigBanks["pacific"]["coords"][2]["z"], 20.0, Config.BigBanks["pacific"]["object"], false, false, false)
                if object ~= 0 then
                    SetEntityHeading(object, Config.BigBanks["pacific"]["heading"].open)
                end
            else
                local object = GetClosestObjectOfType(Config.BigBanks["pacific"]["coords"][2]["x"], Config.BigBanks["pacific"]["coords"][2]["y"], Config.BigBanks["pacific"]["coords"][2]["z"], 20.0, Config.BigBanks["pacific"]["object"], false, false, false)
                if object ~= 0 then
                    SetEntityHeading(object, Config.BigBanks["pacific"]["heading"].closed)
                end
            end
        end

        if not inRange then
            Citizen.Wait(5000)
        end

        Citizen.Wait(1000)
    end
end)

RegisterNetEvent('mr-bankrobbery:client:ClearTimeoutDoors')
AddEventHandler('mr-bankrobbery:client:ClearTimeoutDoors', function()
    TriggerServerEvent('mr-doorlock:server:updateState', 85, true)
    local PaletoObject = GetClosestObjectOfType(Config.BigBanks["paleto"]["coords"]["x"], Config.BigBanks["paleto"]["coords"]["y"], Config.BigBanks["paleto"]["coords"]["z"], 5.0, Config.BigBanks["paleto"]["object"], false, false, false)
    if PaletoObject ~= 0 then
        SetEntityHeading(PaletoObject, Config.BigBanks["paleto"]["heading"].closed)
    end

    local object = GetClosestObjectOfType(Config.BigBanks["pacific"]["coords"][2]["x"], Config.BigBanks["pacific"]["coords"][2]["y"], Config.BigBanks["pacific"]["coords"][2]["z"], 20.0, Config.BigBanks["pacific"]["object"], false, false, false)
    if object ~= 0 then
        SetEntityHeading(object, Config.BigBanks["pacific"]["heading"].closed)
    end

    for k, v in pairs(Config.BigBanks["pacific"]["lockers"]) do
        Config.BigBanks["pacific"]["lockers"][k]["isBusy"] = false
        Config.BigBanks["pacific"]["lockers"][k]["isOpened"] = false
    end

    for k, v in pairs(Config.BigBanks["paleto"]["lockers"]) do
        Config.BigBanks["paleto"]["lockers"][k]["isBusy"] = false
        Config.BigBanks["paleto"]["lockers"][k]["isOpened"] = false
    end

    Config.BigBanks["paleto"]["isOpened"] = false
    Config.BigBanks["pacific"]["isOpened"] = false
end)