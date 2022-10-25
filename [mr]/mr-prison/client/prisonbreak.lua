local currentGate = 0
local requiredItemsShowed = false
local requiredItems = {}
local inRange = false
local securityLockdown = false

local Gates = {
    [1] = {
        gatekey = 'prison_big_gate_1',
        coords = vector3(1845.99, 2604.7, 45.58),
        hit = false,
    },
    [2] = {
        gatekey = 'prison_big_gate_2',
        coords = vector3(1819.47, 2604.67, 45.56),
        hit = false,
    },
    [3] = {
        gatekey = 'prison_big_gate_3',
        coords = vector3(1804.74, 2616.311, 45.61),
        hit = false,
    }
}

-- Functions

local function OnHackDone(success)
    if success then
        TriggerServerEvent("prison:server:SetGateHit", currentGate)
        TriggerServerEvent('nui_doorlock:server:updateState', Gates[currentGate].gatekey, false, nil, false, true, false)
		TriggerEvent('mhacking:hide')
    else
        TriggerServerEvent("prison:server:SecurityLockdown")
		TriggerEvent('mhacking:hide')
	end
end

-- Events

RegisterNetEvent('electronickit:UseElectronickit', function(info)
    if currentGate ~= 0 and not securityLockdown and not Gates[currentGate].hit then
        MRFW.Functions.TriggerCallback('MRFW:HasItemV2', function(has, info2)
            if has then
                if info2.info.uses > 0 then
                    TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                    -- TriggerServerEvent('Perform:Decay:item', info2.name, info2.slot, 10) -- item name, item slot, amount to decay
                    MRFW.Functions.Progressbar("hack_gate", "Electronic kit plug in..", math.random(5000, 10000), false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {
                        animDict = "anim@gangops@facility@servers@",
                        anim = "hotwire",
                        flags = 16,
                    }, {}, {}, function() -- Done
                        local infos = {}
                        infos.uses = info2.info.uses - 1
                        TriggerServerEvent('MRFW:Server:RemoveItem', info2.name, info2.amount, info2.slot)
                        TriggerServerEvent("MRFW:Server:AddItem", info2.name, info2.amount, info2.slot, infos)
                        local infos2 = {}
                        infos2.uses = info.info.uses - 1
                        TriggerServerEvent('MRFW:Server:RemoveItem', info.name, info.amount, info.slot)
                        TriggerServerEvent("MRFW:Server:AddItem", info.name, info.amount, info.slot, infos2)
                        StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
                        -- TriggerServerEvent('Perform:Decay:item', info.name, info.slot, 5)
                        TriggerEvent("mhacking:show")
                        TriggerEvent("mhacking:start", math.random(5, 9), math.random(10, 18), OnHackDone)
                    end, function() -- Cancel
                        StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
                        MRFW.Functions.Notify(Lang:t("error.cancelled"), "error")
                    end)
                else
                    MRFW.Functions.Notify("Your GateCrack is broken", "error")
                end
            else
                MRFW.Functions.Notify(Lang:t("error.item_missing"), "error")
            end
        end, 'gatecrack')
    end
end)

RegisterNetEvent('prison:client:SetLockDown', function(isLockdown)
    securityLockdown = isLockdown
    if securityLockdown and inJail then
        TriggerEvent("chatMessage", "HOSTAGE", "error", "Highest security level is active, stay with the cell blocks!")
    end
end)

RegisterNetEvent('prison:client:PrisonBreakAlert', function()
    -- TriggerEvent("chatMessage", "ALERT", "error", "Attentie alle eenheden! Poging tot uitbraak in de gevangenis!")
    -- TriggerEvent('mr-policealerts:client:AddPoliceAlert', {
    --     timeOut = 10000,
    --     alertTitle = "Prison outbreak",
    --     details = {
    --         [1] = {
    --             icon = '<i class="fas fa-lock"></i>',
    --             detail = "Boilingbroke Penitentiary",
    --         },
    --         [2] = {
    --             icon = '<i class="fas fa-globe-europe"></i>',
    --             detail = "Route 68",
    --         },
    --     },
    --     callSign = MRFW.Functions.GetPlayerData().metadata["callsign"],
    -- })

    -- local BreakBlip = AddBlipForCoord(Config.Locations["middle"].coords.x, Config.Locations["middle"].coords.y, Config.Locations["middle"].coords.z)
    -- TriggerServerEvent('prison:server:JailAlarm')
	-- SetBlipSprite(BreakBlip , 161)
	-- SetBlipScale(BreakBlip , 3.0)
	-- SetBlipColour(BreakBlip, 3)
	-- PulseBlip(BreakBlip)
    -- PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    -- Wait(100)
    -- PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
    -- Wait(100)
    -- PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    -- Wait(100)
    -- PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
    -- Wait((1000 * 60 * 5))
    -- RemoveBlip(BreakBlip)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    exports['mr-dispatch']:PrisonBreak(coords)
end)

RegisterNetEvent('prison:client:SetGateHit', function(key, isHit)
    Gates[key].hit = isHit
end)

RegisterNetEvent('prison:client:JailAlarm', function(toggle)
    if toggle then
        local alarmIpl = GetInteriorAtCoordsWithType(1787.004,2593.1984,45.7978, "int_prison_main")

        RefreshInterior(alarmIpl)
        EnableInteriorProp(alarmIpl, "prison_alarm")

        CreateThread(function()
            while not PrepareAlarm("PRISON_ALARMS") do
                Wait(100)
            end
            StartAlarm("PRISON_ALARMS", true)
        end)
    else
        local alarmIpl = GetInteriorAtCoordsWithType(1787.004,2593.1984,45.7978, "int_prison_main")

        RefreshInterior(alarmIpl)
        DisableInteriorProp(alarmIpl, "prison_alarm")

        CreateThread(function()
            while not PrepareAlarm("PRISON_ALARMS") do
                Wait(100)
            end
            StopAllAlarms(true)
        end)
    end
end)

-- Threads

CreateThread(function()
    Wait(500)
    requiredItems = {
        [1] = {name = MRFW.Shared.Items["electronickit"]["name"], image = MRFW.Shared.Items["electronickit"]["image"]},
        [2] = {name = MRFW.Shared.Items["gatecrack"]["name"], image = MRFW.Shared.Items["gatecrack"]["image"]},
    }
    while true do
        Wait(5)
        inRange = false
        currentGate = 0
        if LocalPlayer.state.isLoggedIn then
            if PlayerJob.name ~= "police" then
                local pos = GetEntityCoords(PlayerPedId())
                for k, v in pairs(Gates) do
                    local dist =  #(pos - Gates[k].coords)
                    if (dist < 1.5) then
                        currentGate = k
                        inRange = true
                        if securityLockdown then
                            DrawText3D(Gates[k].coords.x, Gates[k].coords.y, Gates[k].coords.z, "~r~SYSTEM LOCKDOWN")
                        elseif Gates[k].hit then
                            DrawText3D(Gates[k].coords.x, Gates[k].coords.y, Gates[k].coords.z, "SYSTEM BREACH")
                        elseif not requiredItemsShowed then
                            requiredItemsShowed = true
                            TriggerEvent('inventory:client:requiredItems', requiredItems, true)
                        end
                    end
                end

                if not inRange then
                    if requiredItemsShowed then
                        requiredItemsShowed = false
                        TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                    end
                    Wait(1000)
                end
            else
                Wait(1000)
            end
        else
            Wait(5000)
        end
    end
end)

CreateThread(function()
	while true do
		Wait(5)
		local pos = GetEntityCoords(PlayerPedId(), true)
        if #(pos - vector3(Config.Locations["middle"].coords.x, Config.Locations["middle"].coords.y, Config.Locations["middle"].coords.z)) > 200 and inJail then
			inJail = false
            jailTime = 0
            RemoveBlip(currentBlip)
            RemoveBlip(CellsBlip)
            CellsBlip = nil
            RemoveBlip(TimeBlip)
            TimeBlip = nil
            RemoveBlip(ShopBlip)
            ShopBlip = nil
            TriggerServerEvent("prison:server:SecurityLockdown")
            TriggerEvent('prison:client:PrisonBreakAlert')
            TriggerServerEvent("prison:server:SetJailStatus", 0)
            TriggerServerEvent("MRFW:Server:SetMetaData", "jailitems", {})
            MRFW.Functions.Notify(Lang:t("error.escaped"), "error")
        else
            Wait(1000)
		end
	end
end)