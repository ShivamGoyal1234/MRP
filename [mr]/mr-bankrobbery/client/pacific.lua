local requiredItemsShowed = false
local requiredItemsShowed2 = false
local requiredItemsShowed3 = false
local requiredItemsShowed4 = false

Citizen.CreateThread(function()
    Citizen.Wait(2000)
    local requiredItems3 = {
        [1] = {name = MRFW.Shared.Items["thermite2"]["name"], image = MRFW.Shared.Items["thermite2"]["image"]},
    }
    local requiredItems2 = {
        [1] = {name = MRFW.Shared.Items["electronickit"]["name"], image = MRFW.Shared.Items["electronickit"]["image"]},
        [2] = {name = MRFW.Shared.Items["trojan_usb"]["name"], image = MRFW.Shared.Items["trojan_usb"]["image"]},
    }
    local requiredItems = {
        [1] = {name = MRFW.Shared.Items["security_card_02"]["name"], image = MRFW.Shared.Items["security_card_02"]["image"]},
    }
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local inRange = false
        if MRFW ~= nil then
            if #(pos - Config.BigBanks["pacific"]["coords"][1]) < 10.0 then
                inRange = true
                if not Config.BigBanks["pacific"]["isOpened"] then
                    local dist = #(pos - Config.BigBanks["pacific"]["coords"][1])
                    if dist < 1 then
                        if not requiredItemsShowed then
                            requiredItemsShowed = true
                            TriggerEvent('inventory:client:requiredItems', requiredItems, true)
                        end
                    else
                        if requiredItemsShowed then
                            requiredItemsShowed = false
                            TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                        end
                    end
                end
            end
            if #(pos - Config.BigBanks["pacific"]["coords"][2]) < 10.0 then
                inRange = true
                if not Config.BigBanks["pacific"]["isOpened"] then
                    local dist = #(pos - Config.BigBanks["pacific"]["coords"][2])
                    if dist < 1 then
                        if not requiredItemsShowed2 then
                            requiredItemsShowed2 = true
                            TriggerEvent('inventory:client:requiredItems', requiredItems2, true)
                        end
                    else
                        if requiredItemsShowed2 then
                            requiredItemsShowed2 = false
                            TriggerEvent('inventory:client:requiredItems', requiredItems2, false)
                        end
                    end
                end
            end
            if #(pos - Config.BigBanks["pacific"]["thermite"][1]["coords"]) < 10.0 then
                inRange = true
                if not Config.BigBanks["pacific"]["thermite"][1]["isOpened"] then
                    local dist = #(pos - Config.BigBanks["pacific"]["thermite"][1]["coords"])
                    if dist < 1 then
                        currentThermiteGate = Config.BigBanks["pacific"]["thermite"][1]["doorId"]
                        if not requiredItemsShowed3 then
                            requiredItemsShowed3 = true
                            TriggerEvent('inventory:client:requiredItems', requiredItems3, true)
                        end
                    else
                        currentThermiteGate = 0
                        if requiredItemsShowed3 then
                            requiredItemsShowed3 = false
                            TriggerEvent('inventory:client:requiredItems', requiredItems3, false)
                        end
                    end
                end
            end

            if Config.BigBanks["pacific"]["isOpened"] then
                for k, v in pairs(Config.BigBanks["pacific"]["lockers"]) do
                    local lockerDist = #(pos - Config.BigBanks["pacific"]["lockers"][k]["coords"])
                    if not Config.BigBanks["pacific"]["lockers"][k]["isBusy"] then
                        if not Config.BigBanks["pacific"]["lockers"][k]["isOpened"] then
                            if lockerDist < 5 then
                                inRange = true
                                DrawMarker(2, Config.BigBanks["pacific"]["lockers"][k]["coords"].x, Config.BigBanks["pacific"]["lockers"][k]["coords"].y, Config.BigBanks["pacific"]["lockers"][k]["coords"].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                                if lockerDist < 0.5 then
                                    DrawText3Ds(Config.BigBanks["pacific"]["lockers"][k]["coords"].x, Config.BigBanks["pacific"]["lockers"][k]["coords"].y, Config.BigBanks["pacific"]["lockers"][k]["coords"].z + 0.3, '[E] Break open the safe')
                                    if IsControlJustPressed(0, 38) then
                                        if CurrentCops >= Config.MinimumPacificPolice then
                                            openLocker("pacific", k)
                                        else
                                            MRFW.Functions.Notify('Minimum Of '..Config.MinimumPacificPolice..' Police Needed', "error")
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if not inRange then
                Citizen.Wait(2500)
            end
        end
        Citizen.Wait(5)
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(2000)
    local requiredItems4 = {
        [1] = {name = MRFW.Shared.Items["thermite2"]["name"], image = MRFW.Shared.Items["thermite2"]["image"]},
    }
    while true do 
        Citizen.Wait(5)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local inRange = false
        if MRFW ~= nil then
            if #(pos - Config.BigBanks["pacific"]["thermite"][2]["coords"]) < 10.0 then
                inRange = true
                if not Config.BigBanks["pacific"]["thermite"][1]["isOpened"] then
                    local dist = #(pos - Config.BigBanks["pacific"]["thermite"][2]["coords"])
                    if dist < 1 then
                        currentThermiteGate = Config.BigBanks["pacific"]["thermite"][2]["doorId"]
                        if not requiredItemsShowed4 then
                            requiredItemsShowed4 = true
                            TriggerEvent('inventory:client:requiredItems', requiredItems4, true)
                        end
                    else
                        currentThermiteGate = 0
                        if requiredItemsShowed4 then
                            requiredItemsShowed4 = false
                            TriggerEvent('inventory:client:requiredItems', requiredItems4, false)

                        end
                    end
                end
            else
                Wait(1000)
            end
        end
    end
end)

RegisterNetEvent('electronickit:UseElectronickit')
AddEventHandler('electronickit:UseElectronickit', function(item)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local dist = #(pos - Config.BigBanks["pacific"]["coords"][2])
    if dist < 1.5 then
        MRFW.Functions.TriggerCallback('mr-bankrobbery:server:isRobberyActive', function(isBusy)
            if not isBusy then
                local dist = #(pos - Config.BigBanks["pacific"]["coords"][2])
                if dist < 1.5 then
                    if CurrentCops >= Config.MinimumPacificPolice then
                        if not Config.BigBanks["pacific"]["isOpened"] then 
                            MRFW.Functions.TriggerCallback('MRFW:HasItemV2', function(has, info2)
                                if has then
                                    if info2.info.uses > 0 then
                                        -- TriggerServerEvent('Perform:Decay:item', info2.name, info2.slot, 10) -- item name, item slot, amount to decay
                                        TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                                        MRFW.Functions.Progressbar("hack_gate", "Connecting the hacking device ..", math.random(5000, 10000), false, true, {
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
                                            infos.uses = item.info.uses - 1
                                            TriggerServerEvent('MRFW:Server:RemoveItem', item.name, item.amount, item.slot)
                                            TriggerServerEvent("MRFW:Server:AddItem", item.name, item.amount, item.slot, infos)
                                            local infos2 = {}
                                            infos2.uses = info2.info.uses - 1
                                            TriggerServerEvent('MRFW:Server:RemoveItem', info2.name, info2.amount, info2.slot)
                                            TriggerServerEvent("MRFW:Server:AddItem", info2.name, info2.amount, info2.slot, infos2)
                                            -- TriggerServerEvent('Perform:Decay:item', item.name, item.slot, 10)
                                            -- TriggerServerEvent("MRFW:Server:RemoveItem", "electronickit", 1)
                                            -- TriggerEvent('inventory:client:ItemBox', MRFW.Shared.Items["electronickit"], "remove")
                                            -- TriggerServerEvent("MRFW:Server:RemoveItem", "trojan_usb", 1)
                                            -- TriggerEvent('inventory:client:ItemBox', MRFW.Shared.Items["trojan_usb"], "remove")
                                            StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
                                            TriggerEvent("mhacking:show")
                                            TriggerEvent("mhacking:start", math.random(5, 9), math.random(10, 15), OnHackPacificDone)
                                    
                                            if not copsCalled then
                                                local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, pos.x, pos.y, pos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
                                                local street1 = GetStreetNameFromHashKey(s1)
                                                local street2 = GetStreetNameFromHashKey(s2)
                                                local streetLabel = street1
                                                if street2 ~= nil then 
                                                    streetLabel = streetLabel .. " " .. street2
                                                end
                                                if Config.BigBanks["pacific"]["alarm"] then
                                                    TriggerServerEvent("mr-bankrobbery:server:callCops", "pacific", 0, streetLabel, pos)
                                                    copsCalled = true
                                                end
                                            end
                                        end, function() -- Cancel
                                            StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
                                            MRFW.Functions.Notify("Canceled", "error")
                                        end)
                                    else
                                        MRFW.Functions.Notify("Your Trojan Usb is broken", "error")
                                    end
                                else
                                    MRFW.Functions.Notify("You're missing an item ..", "error")
                                end
                            end, 'trojan_usb')
                        else
                            MRFW.Functions.Notify("Looks like the bank is already open", "error")
                        end
                    else
                        MRFW.Functions.Notify('Minimum Of '..Config.MinimumPacificPolice..' Police Needed', "error")
                    end
                end
            else
                MRFW.Functions.Notify("The security lock is active, opening the door is currently not possible.", "error", 5500)
            end
        end)
    end
end)

RegisterNetEvent('mr-bankrobbery:UseBankcardB')
AddEventHandler('mr-bankrobbery:UseBankcardB', function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local dist = #(pos - Config.BigBanks["pacific"]["coords"][1])
    if math.random(1, 100) <= 85 and not IsWearingHandshoes() then
        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
    end
    if dist < 1.5 then
        MRFW.Functions.TriggerCallback('mr-bankrobbery:server:isRobberyActive', function(isBusy)
            if not isBusy then
                if CurrentCops >= Config.MinimumPacificPolice then
                    if not Config.BigBanks["pacific"]["isOpened"] then 
                        TriggerEvent('inventory:client:requiredItems', requiredItems2, false)
                        MRFW.Functions.Progressbar("security_pass", "Please validate ..", math.random(5000, 10000), false, true, {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        }, {
                            animDict = "anim@gangops@facility@servers@",
                            anim = "hotwire",
                            flags = 16,
                        }, {}, {}, function() -- Done
                            StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
                            TriggerServerEvent('nui_doorlock:server:updateState', 'pacific_door_3', false, nil, false, true, false)
                            TriggerServerEvent("MRFW:Server:RemoveItem", "security_card_02", 1)
                            if not copsCalled then
                                local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, pos.x, pos.y, pos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
                                local street1 = GetStreetNameFromHashKey(s1)
                                local street2 = GetStreetNameFromHashKey(s2)
                                local streetLabel = street1
                                if street2 ~= nil then 
                                    streetLabel = streetLabel .. " " .. street2
                                end
                                if Config.BigBanks["pacific"]["alarm"] then
                                    TriggerServerEvent("mr-bankrobbery:server:callCops", "pacific", 0, streetLabel, pos)
                                    copsCalled = true
                                end
                            end
                        end, function() -- Cancel
                            StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
                            MRFW.Functions.Notify("Canceled..", "error")
                        end)
                    else
                        MRFW.Functions.Notify("Looks like the bank is already open ..", "error")
                    end
                else
                    MRFW.Functions.Notify('Minimum Of '..Config.MinimumPacificPolice..' Police Needed', "error")
                end
            else
                MRFW.Functions.Notify("The security lock is active, opening the door is currently not possible.", "error", 5500)
            end
        end)
    end 
end)

function OnHackPacificDone(success, timeremaining)
    if success then
        TriggerEvent('mhacking:hide')
        TriggerServerEvent('mr-bankrobbery:server:setBankState', "pacific", true)
    else
		TriggerEvent('mhacking:hide')
	end
end

function OpenPacificDoor()
    local object = GetClosestObjectOfType(Config.BigBanks["pacific"]["coords"][2]["x"], Config.BigBanks["pacific"]["coords"][2]["y"], Config.BigBanks["pacific"]["coords"][2]["z"], 20.0, Config.BigBanks["pacific"]["object"], false, false, false)
    local timeOut = 10
    local entHeading = Config.BigBanks["pacific"]["heading"].closed

    if object ~= 0 then
        Citizen.CreateThread(function()
            while true do

                if entHeading > Config.BigBanks["pacific"]["heading"].open then
                    SetEntityHeading(object, entHeading - 10)
                    entHeading = entHeading - 0.5
                else
                    break
                end

                Citizen.Wait(10)
            end
        end)
    end
end
