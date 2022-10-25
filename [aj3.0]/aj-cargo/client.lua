local AJFW = exports['ajfw']:GetCoreObject()

local doingHack = false
local Attempts = 0
local failed = false
local activeDrop = {}

local function hackingCompleted(success, timeremaining)
	if success then
        -- print(Attempts)
        Attempts = Attempts + 1
        -- print(Attempts)
        if Attempts == 1 and doingHack then
            AJFW.Functions.Notify('Hack Successfull 1/3', 'success', 5000)
        elseif Attempts == 2 and doingHack then
            AJFW.Functions.Notify('Hack Successfull 2/3', 'success', 5000)
        elseif Attempts == 3 and doingHack then
            AJFW.Functions.Notify('Hack Successfull 3/3', 'success', 5000)
        else
            Attempts = 0
            AJFW.Functions.Notify('hack Failed', 'error', 3000)
        end
        if Attempts == 3 and doingHack then
            Attempts = 0
            TriggerEvent('dpemote:custom:animation', {"c"})
            TriggerServerEvent('aj-cargo:hackingCompleted')
        elseif failed then
            AJFW.Functions.Notify('hack Failed', 'error', 3000)
            TriggerEvent('dpemote:custom:animation', {"c"})
            TriggerServerEvent('aj-cargo:server:available', false)
            doingHack = false
            Attempts = 0
            failed = false
        end
        -- print(Attempts)
	else
        AJFW.Functions.Notify('hack Failed', 'error', 3000)
        failed = true
        Attempts = 3
        if Attempts == 3 and doingHack then
            TriggerEvent('dpemote:custom:animation', {"c"})
            TriggerServerEvent('aj-cargo:server:available', false)
            doingHack = false
            Attempts = 0
            failed = false
        end
	end
	TriggerEvent('mhackings:hide')
end

RegisterNetEvent('AJFW:Client:OnPlayerUnload', function()
    if doingHack then
        doingHack = false
        Attempts = 0
        failed = false
        activeDrop = {}
        TriggerServerEvent('aj-cargo:server:available', false)
    end
end)

RegisterNetEvent('aj-cargo:client:startHack', function(item)
    if not doingHack then
        doingHack = true
        TriggerServerEvent('aj-cargo:server:available', true)
        TriggerEvent('dpemote:custom:animation', {"type4"})
        AJFW.Functions.Progressbar('connectingDrive', 'Connecting Drive On PC', 15000, false, true, { -- Name | Label | Time | useWhileDead | canCancel
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Play When Done
            local infos = {}
            infos.uses = item.info.uses - 1
            TriggerServerEvent('AJFW:Server:RemoveItem', item.name, item.amount, item.slot)
            TriggerServerEvent("AJFW:Server:AddItem", item.name, item.amount, item.slot, infos)
            if StartHacking() then
                TriggerEvent('dpemote:custom:animation', {"c"})
                -- TriggerServerEvent('aj-cargo:hackingCompleted')
                TriggerEvent('aj-cargo:hackingMinigame')
            else
                TriggerEvent('dpemote:custom:animation', {"c"})
                doingHack = false
                Attempts = 0
                failed = false
                TriggerServerEvent('aj-cargo:server:available', false)
            end
        end, function() -- Play When Cancel
            TriggerEvent('dpemote:custom:animation', {"c"})
            doingHack = false
            Attempts = 0
            failed = false
            TriggerServerEvent('aj-cargo:server:available', false)
        end)
        
    else
        AJFW.Functions.Notify('Already Doing Hack', 'error', 3000)
    end
end)

RegisterNetEvent('aj-cargo:client:DoneHack', function()
    doingHack = false
    Attempts = 0
            failed = false
end)

RegisterNetEvent('aj-cargo:client:Decrypt', function(item)
    TriggerEvent('dpemote:custom:animation', {"type4"})
    AJFW.Functions.Progressbar('Decrypting_key', 'Decrypting Code...', 15000, false, true, { -- Name | Label | Time | useWhileDead | canCancel
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        TriggerEvent('dpemote:custom:animation', {"c"})
        TriggerServerEvent('aj-cargo:server:decryptSuccess',item)
    end, function()
        TriggerEvent('dpemote:custom:animation', {"c"})
        TriggerServerEvent('aj-cargo:server:decryptFailed')
    end)
end) 

RegisterNetEvent('aj-cargo:hackingMinigame')
AddEventHandler('aj-cargo:hackingMinigame', function()
    TriggerEvent('dpemote:custom:animation', {"phone"})
    TriggerEvent("mhacking:seqstart", {math.random(4,7),math.random(4,7),math.random(4,7)}, {math.random(15,25),math.random(15,25),math.random(15,25)}, hackingCompleted)
end)

RegisterNetEvent('aj-cargo:load:model',function(model,entity)
	if not HasModelLoaded(model) then
		RequestModel(model)

		while not HasModelLoaded(model) do
			Citizen.Wait(1)
		end
	end
    PlaceObjectOnGroundProperly(entity)
end)

RegisterNetEvent('aj-cargo:create:Drop',function(entity, id, coordss)
    local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, coordss.x, coordss.y, coordss.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 ~= nil then 
        streetLabel = streetLabel .. " " .. street2
    end
    local data = {}
    data.coords = coordss
    data.blip = AddBlipForCoord(coordss.x,coordss.y,coordss.z)
    data.id   = id
	activeDrop[id] = data
    SetBlipSprite(activeDrop[id].blip, 478)
	SetBlipScale(activeDrop[id].blip, 0.9)
	SetBlipColour(activeDrop[id].blip, 4)
	SetBlipDisplay(activeDrop[id].blip, 4)
	SetBlipAsShortRange(activeDrop[id].blip, false)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentString('Weapon Crate')
	EndTextCommandSetBlipName(activeDrop[id].blip)
    Citizen.Wait(30000)
    TriggerServerEvent('police:server:gunhiestalert', streetLabel, coordss)
end)

RegisterNetEvent('aj-cargo:client:syncDrop', function(id, coords)
    if activeDrop[id] == nil then
        local data = {}
        data.coords = coords
        data.id   = id
        activeDrop[id] = data
    end
end)

RegisterNetEvent('aj-cargo:client:sync', function(drop)
    if activeDrop[drop] and activeDrop[drop].blip ~= nil then
        RemoveBlip(activeDrop[drop].blip)
    end
    activeDrop[drop] = nil
end)

RegisterNetEvent('aj-cargo:reset:Hacking', function()
    if doingHack then
        doingHack = false
    end
end)
Citizen.CreateThread(function()
    local has_drill = false
    local done_drill = false
    local drill_info = nil
    local Presses = false
    while true do
        sleep = 2500
        if LocalPlayer.state['isLoggedIn'] then
            sleep = 1500
            
            for k,v in pairs(activeDrop) do
                if v.coords ~= nil then
                    local ped = PlayerPedId()
                    local pos = GetEntityCoords(ped)
                    local dist = #(pos-v.coords)
                    if dist <=10 then
                        sleep = 5
                        if dist <= 2 then
                            if IsControlJustPressed(0, 38) and not Presses then
                                Presses = true
                                AJFW.Functions.TriggerCallback('AJFW:HasItemV2', function(has, info)
                                    if has then
                                        if info.info.uses >= 1 then
                                            has_drill = true
                                            drill_info = info
                                            done_drill = true
                                            Presses = false
                                        else
                                            done_drill = true
                                            Presses = false
                                            AJFW.Functions.Notify("Drill not Working ..", "error")
                                        end
                                    else
                                        done_drill = true
                                        Presses = false
                                        AJFW.Functions.Notify("Looks like the box lock is too strong ..", "error")
                                    end
                                end, 'drill')
                                while not done_drill do
                                    Wait(0)
                                end
                                if has_drill then
                                    has_drill = false
                                    done_drill = false
                                    AJFW.Functions.TriggerCallback('AJFW:HasItemV2', function(has, info)
                                        if has then
                                            if info.info.uses >= 1 then
                                                TriggerEvent('dpemote:custom:animation', {"mechanic4"})
                                                AJFW.Functions.Progressbar('Drilling', 'Drilling', 30000, false, true, { -- Name | Label | Time | useWhileDead | canCancel
                                                    disableMovement = true,
                                                    disableCarMovement = true,
                                                    disableMouse = false,
                                                    disableCombat = true,
                                                }, {}, {}, {}, function()
                                                    RemoveBlip(v.blip)
                                                    TriggerServerEvent('aj-cargo:server:removeDrop:Giveitem',k)
                                                    activeDrop[k] = nil
                                                    local infos = {}
                                                    infos.uses = drill_info.info.uses - 1
                                                    TriggerServerEvent('AJFW:Server:RemoveItem', drill_info.name, drill_info.amount, drill_info.slot)
                                                    TriggerServerEvent("AJFW:Server:AddItem", drill_info.name, drill_info.amount, drill_info.slot, infos)
                                                    local infos2 = {}
                                                    infos2.uses = info.info.uses - 1
                                                    TriggerServerEvent('AJFW:Server:RemoveItem', info.name, info.amount, info.slot)
                                                    TriggerServerEvent("AJFW:Server:AddItem", info.name, info.amount, info.slot, infos2)
                                                    TriggerEvent('dpemote:custom:animation', {"c"})
                                                    Presses = false
                                                end,function()
                                                    TriggerEvent('dpemote:custom:animation', {"c"})
                                                    Presses = false
                                                end)
                                            else
                                                Presses = false
                                                AJFW.Functions.Notify("Drill bit broken", "error")
                                            end
                                        else
                                            Presses = false
                                            AJFW.Functions.Notify("Missing Drill bit", "error")
                                        end
                                    end, 'drillbit')
                                end
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)