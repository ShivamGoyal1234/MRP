-- Variables
local currentGarage = 1
local inFingerprint = false
local FingerPrintSessionId = nil
local ismenu = false
local ismenu2 = false

-- Functions

local function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local function loadAnimDict(dict) -- interactions, job,
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end
end

local function GetClosestPlayer() -- interactions, job, tracker
    local closestPlayers = MRFW.Functions.GetPlayersFromCoords()
    local closestDistance = -1
    local closestPlayer = -1
    local coords = GetEntityCoords(PlayerPedId())

    for i = 1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = #(pos - coords)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = closestPlayers[i]
                closestDistance = distance
            end
        end
    end

    return closestPlayer, closestDistance
end

local function Input(Titel, Placeholder, MaxLenght)
	AddTextEntry('FMMC_KEY_TIP1', Titel)
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", Placeholder, "", "", "", MaxLenght)
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result --Returns the result
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end

local function openFingerprintUI()
    SendNUIMessage({
        type = "fingerprintOpen"
    })
    inFingerprint = true
    SetNuiFocus(true, true)
end

local function SetCarItemsInfo()
	local items = {}
	for k, item in pairs(Config.CarItems) do
		local itemInfo = MRFW.Shared.Items[item.name:lower()]
		items[item.slot] = {
			name = itemInfo["name"],
			amount = tonumber(item.amount),
			info = item.info,
			label = itemInfo["label"],
			description = itemInfo["description"] and itemInfo["description"] or "",
			weight = itemInfo["weight"], 
			type = itemInfo["type"], 
			unique = itemInfo["unique"], 
			useable = itemInfo["useable"], 
			image = itemInfo["image"],
			slot = item.slot,
		}
	end
	Config.CarItems = items
end

local function doCarDamage(currentVehicle, veh)
	smash = false
	damageOutside = false
	damageOutside2 = false 
	local engine = veh.engine + 0.0
	local body = veh.body + 0.0
	if engine < 200.0 then
		engine = 200.0
    end

    if engine  > 1000.0 then
        engine = 950.0
    end

	if body < 150.0 then
		body = 150.0
	end
	if body < 950.0 then
		smash = true
	end

	if body < 920.0 then
		damageOutside = true
	end

	if body < 920.0 then
		damageOutside2 = true
	end

    Citizen.Wait(100)
    SetVehicleEngineHealth(currentVehicle, engine)
	if smash then
		SmashVehicleWindow(currentVehicle, 0)
		SmashVehicleWindow(currentVehicle, 1)
		SmashVehicleWindow(currentVehicle, 2)
		SmashVehicleWindow(currentVehicle, 3)
		SmashVehicleWindow(currentVehicle, 4)
	end
	if damageOutside then
		SetVehicleDoorBroken(currentVehicle, 1, true)
		SetVehicleDoorBroken(currentVehicle, 6, true)
		SetVehicleDoorBroken(currentVehicle, 4, true)
	end
	if damageOutside2 then
		SetVehicleTyreBurst(currentVehicle, 1, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 2, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 3, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 4, false, 990.0)
	end
	if body < 1000 then
		SetVehicleBodyHealth(currentVehicle, 985.1)
	end
end

function TakeOutImpound(vehicle)
    enginePercent = round(vehicle.engine / 10, 0)
    bodyPercent = round(vehicle.body / 10, 0)
    currentFuel = vehicle.fuel
    local coords = Config.Locations["impound"][currentGarage]
    MRFW.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
        MRFW.Functions.TriggerCallback('mr-garage:server:GetVehicleProperties', function(properties)
            MRFW.Functions.SetVehicleProperties(veh, properties)
            SetVehicleNumberPlateText(veh, vehicle.plate)
            SetEntityHeading(veh, coords.w)
            exports['mr-fuel']:SetFuel(veh, vehicle.fuel)
            doCarDamage(veh, vehicle)
            TriggerServerEvent('police:server:TakeOutImpound',vehicle.plate, currentGarage)
            closeMenuFull()
            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
            TriggerEvent("vehiclekeys:client:SetOwner", MRFW.Functions.GetPlate(veh))
            SetVehicleEngineOn(veh, true, true)
        end, vehicle.plate)
    end, coords, true)
end


local function IsArmoryWhitelist() -- being removed
    local retval = false

    if MRFW.Functions.GetPlayerData().job.name == 'police' then
        retval = true
    end
    return retval
end

local function SetWeaponSeries()
    for k, v in pairs(Config.Items.items) do
        if k < 6 then
            Config.Items.items[k].info.serie = tostring(Config.RandomInt(2) .. Config.RandomStr(3) .. Config.RandomInt(1) .. Config.RandomStr(2) .. Config.RandomInt(3) .. Config.RandomStr(4))
        end
    end
end

function round(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

-- GUI Menu Functions (being replaced)

local ayush

function PoliceGarage()
    ayush = MenuV:CreateMenu(false,"Police Garage", 'topright', 1, 59, 254, 'size-125', 'none', 'menuv')
    ayush_VehicleList()
end

function ayush_VehicleList()
    local authorizedVehicles = Config.AuthorizedVehicles[MRFW.Functions.GetPlayerData().job.grade.level]
    for k, v in pairs(authorizedVehicles) do
        ayush:AddButton({
            icon = '🚔',
            label = v,
            select = function(btn)
            MenuV:CloseAll()
            ayush_TakeOutVehicle(k)
            end
        })
    end
    MenuV:OpenMenu(ayush)
end

function ayush_TakeOutVehicle(vehicleInfo)
    local coords = Config.Locations["vehicle"][currentGarage]
    local callSign = MRFW.Functions.GetPlayerData().metadata["callsign"]
    MRFW.Functions.SpawnVehicle(vehicleInfo, function(veh)
	    SetCarItemsInfo()
        SetVehicleCustomPrimaryColour(veh, 0, 0, 0)
        SetVehicleCustomSecondaryColour(veh, 0, 0, 0)
        SetVehicleNumberPlateText(veh, callSign)
        exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'body', 1000.0)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'engine', 1000.0)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'fuel', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'clutch', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'brakes', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'axle', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'radiator', 100)
        SetVehicleModKit(veh, 0)
            SetVehicleNumberPlateTextIndex(veh, 1)
            SetVehicleMod(veh, 11, 3, false)
            SetVehicleMod(veh, 12, 2, false)
            SetVehicleMod(veh, 13, 2, false)
            SetVehicleMod(veh, 15, 3, false)
            SetVehicleMod(veh, 16, 4, false)
            ToggleVehicleMod(veh, 18, true)
            SetVehicleMod(veh, 14, 1, false)
            SetVehicleMod(veh, 42, 0, false)
            ToggleVehicleMod(veh, 22, true)
            SetVehicleXenonLightsColor(veh, 0)
            for id = 0, 12 do
                if DoesExtraExist(veh, id) then
                    SetVehicleExtra(veh, id, false)
                end
            end
            SetVehicleMod(veh, 48, 1, false)
            -- SetVehicleLivery(veh, 1)
            SetEntityHeading(veh, coords.w)
            exports['mr-fuel']:SetFuel(veh, 100.0)
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", MRFW.Functions.GetPlate(veh))
        TriggerServerEvent("inventory:server:addTrunkItems", MRFW.Functions.GetPlate(veh), Config.CarItems)
        SetVehicleEngineOn(veh, true, true)
        SetVehicleDirtLevel(veh)
        WashDecalsFromVehicle(veh, 1.0)
    end, coords, true)
end

function PoliceImpound()
    ayush = MenuV:CreateMenu(false,"Police Impound", 'topright', 1, 59, 254, 'size-125', 'none', 'menuv')
    impound_VehicleList()
end

function impound_VehicleList()
    MRFW.Functions.TriggerCallback("police:GetImpoundedVehicles", function(result)
        ped = PlayerPedId();
        

        if result == nil then
            MRFW.Functions.Notify("There are no impounded vehicles", "error", 5000)
        else
            for k, v in pairs(result) do
                enginePercent = round(v.engine / 10, 0)
                bodyPercent = round(v.body / 10, 0)
                currentFuel = v.fuel
                ayush:AddButton({
                    icon = '🚔',
                    label = MRFW.Shared.Vehicles[v.vehicle]["name"] .." <br> Motor: " .. enginePercent .. " | Body: " .. bodyPercent.. " | Fuel: "..currentFuel,
                    select = function(btn)
                    MenuV:CloseAll()
                    impound_TakeOutVehicle(v)
                    end
                })
            end
            MenuV:OpenMenu(ayush)
        end
    end)
end

function impound_TakeOutVehicle(vehicle)
    enginePercent = round(vehicle.engine / 10, 0)
    bodyPercent = round(vehicle.body / 10, 0)
    currentFuel = vehicle.fuel
    local coords = Config.Locations["impound"][currentGarage]
    MRFW.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
        MRFW.Functions.TriggerCallback('mr-garage:server:GetVehicleProperties', function(properties)
            MRFW.Functions.SetVehicleProperties(veh, properties)
            SetVehicleNumberPlateText(veh, vehicle.plate)
            SetEntityHeading(veh, coords.h)
            exports['mr-fuel']:SetFuel(veh, vehicle.fuel)
            doCarDamage(veh, vehicle)
            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
            TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
            SetVehicleEngineOn(veh, true, true)
        end, vehicle.plate)
    end, coords, true)
end

function CheckPlayers(vehicle)
    for i = -1, 5,1 do                
        seat = GetPedInVehicleSeat(vehicle,i)
        if seat ~= 0 then
            TaskLeaveVehicle(seat,vehicle,0)
            SetVehicleDoorsLocked(vehicle)
            Wait(1500)
            MRFW.Functions.DeleteVehicle(vehicle)
        end
   end
end

function MenuGarage()
    MenuTitle = "Garage"
    ClearMenu()
    Menu.addButton("Vehicles", "VehicleList", nil)
    Menu.addButton("Close menu", "closeMenuFull", nil)
end

function VehicleList()
    MenuTitle = "Vehicles:"
    ClearMenu()
    local authorizedVehicles = Config.AuthorizedVehicles[MRFW.Functions.GetPlayerData().job.grade.level]
    for k, v in pairs(authorizedVehicles) do
        Menu.addButton(authorizedVehicles[k], "TakeOutVehicle", k, "Garage", " Engine: 100%", " Body: 100%", " Fuel: 100%")
    end
    if IsArmoryWhitelist() then
        for veh, label in pairs(Config.WhitelistedVehicles) do
            Menu.addButton(label, "TakeOutVehicle", veh, "Garage", " Engine: 100%", " Body: 100%", " Fuel: 100%")
        end
    end

    Menu.addButton("Back", "MenuGarage",nil)
end

function MenuImpound()
    ped = PlayerPedId();
    MenuTitle = "Impounded"
    ClearMenu()
    Menu.addButton("Police Impound", "ImpoundVehicleList", nil)
    Menu.addButton("Close menu", "closeMenuFull", nil) 
end

function ImpoundVehicleList()
    MRFW.Functions.TriggerCallback("police:GetImpoundedVehicles", function(result)
        ped = PlayerPedId();
        MenuTitle = "Impounded Vehicles:"
        ClearMenu()

        if result == nil then
            MRFW.Functions.Notify("There are no impounded vehicles", "error", 5000)
            closeMenuFull()
        else
            for k, v in pairs(result) do
                enginePercent = round(v.engine / 10, 0)
                bodyPercent = round(v.body / 10, 0)
                currentFuel = v.fuel

                Menu.addButton(MRFW.Shared.Vehicles[v.vehicle]["name"], "TakeOutImpound", v, "Impounded", " Engine: " .. enginePercent .. "%", " Body: " .. bodyPercent.. "%", " Fuel: "..currentFuel.. "%")
            end
        end

        Menu.addButton("Back", "MenuImpound",nil)
    end)
end

function closeMenuFull()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
end

-- NUI

RegisterNUICallback('closeFingerprint', function()
    SetNuiFocus(false, false)
    inFingerprint = false
end)

-- Events

RegisterNetEvent('police:client:showFingerprint', function(playerId)
    openFingerprintUI()
    FingerPrintSessionId = playerId
end)

RegisterNetEvent('police:client:showFingerprintId', function(fid)
    SendNUIMessage({
        type = "updateFingerprintId",
        fingerprintId = fid
    })
    PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
end)
local cooldown = false

RegisterNUICallback('doFingerScan', function(data)
    if cooldown then return end
    if not cooldown then
        TriggerServerEvent('police:server:showFingerprintId', FingerPrintSessionId)
        cooldown = true
    end
    if cooldown then
        SetTimeout(20000, function() cooldown = false end)
    end
end)

RegisterNetEvent('police:client:SendEmergencyMessage', function(coords,message)
    -- local coords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent("police:server:SendEmergencyMessage", coords, message)
    TriggerEvent("police:client:CallAnim")
end)

RegisterNetEvent('police:client:SendEmergencyMessages')
AddEventHandler('police:client:SendEmergencyMessages', function(coords,message)
    -- local coords = GetEntityCoords(PlayerPedId())

    TriggerServerEvent("police:server:SendEmergencyMessages", coords, message)
    TriggerEvent("police:client:CallAnim")
end)

RegisterNetEvent('police:client:EmergencySound', function()
    PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
end)

RegisterNetEvent('police:client:CallAnim', function()
    local isCalling = true
    local callCount = 5
    loadAnimDict("cellphone@")   
    TaskPlayAnim(PlayerPedId(), 'cellphone@', 'cellphone_call_listen_base', 3.0, -1, -1, 49, 0, false, false, false)
    Citizen.Wait(1000)
    Citizen.CreateThread(function()
        while isCalling do
            Citizen.Wait(1000)
            callCount = callCount - 1
            if callCount <= 0 then
                isCalling = false
                StopAnimTask(PlayerPedId(), 'cellphone@', 'cellphone_call_listen_base', 1.0)
            end
        end
    end)
end)

RegisterNetEvent('police:client:ImpoundVehicle', function(fullImpound, price)
    if not IsPedInAnyVehicle(ped) then
        local vehicle2 = MRFW.Functions.GetClosestVehicle()
        local ped2 = PlayerPedId()
        local pos2 = GetEntityCoords(ped)
        local vehpos2 = GetEntityCoords(vehicle2)
        if vehicle2 ~= 0 and vehicle2 then
            if #(pos2 - vehpos2) < 2.0 then 
                MRFW.Functions.Progressbar('impound', 'Calling Tow...', 5000, false, true, { -- Name | Label | Time | useWhileDead | canCancel
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                    TriggerEvent('dpemote:custom:animation', {"mechanic4"})
                }, {}, {}, {}, function() -- Play When Done
                    TriggerEvent('dpemote:custom:animation', {"c"})
                    local vehicle = MRFW.Functions.GetClosestVehicle()
                    local bodyDamage = math.ceil(GetVehicleBodyHealth(vehicle))
                    local engineDamage = math.ceil(GetVehicleEngineHealth(vehicle))
                    local totalFuel = exports['mr-fuel']:GetFuel(vehicle)
                    if vehicle ~= 0 and vehicle then
                        local ped = PlayerPedId()
                        local pos = GetEntityCoords(ped)
                        local vehpos = GetEntityCoords(vehicle)
                        if #(pos - vehpos) < 5.0 then 
                            
                                local plate = MRFW.Functions.GetPlate(vehicle)
                                TriggerServerEvent("police:server:Impound", plate, fullImpound, price, bodyDamage, engineDamage, totalFuel)
                                MRFW.Functions.DeleteVehicle(vehicle)
                            
                        end
                    end
                end, function()
                    TriggerEvent('dpemote:custom:animation', {"c"})
                end)
            else
                MRFW.Functions.Notify('Too far from vehicle', 'error', 3000)
            end
        else
            MRFW.Functions.Notify('no vehicle found', 'error', 3000)
        end
    else
        MRFW.Functions.Notify('Badhir gadi se neeche uttar', 'error', 3000)
    end
end)

RegisterNetEvent('police:client:CheckStatus', function()
    MRFW.Functions.GetPlayerData(function(PlayerData)
        if PlayerData.job.name == "police" then
            local player, distance = GetClosestPlayer()
            if player ~= -1 and distance < 5.0 then
                local playerId = GetPlayerServerId(player)
                MRFW.Functions.TriggerCallback('police:GetPlayerStatus', function(result)
                    if result then
                        for k, v in pairs(result) do
                            MRFW.Functions.Notify(''..v..'')
                        end
                    end
                end, playerId)
            else
                MRFW.Functions.Notify("No One Nearby", "error")
            end
        end
    end)
end)

RegisterNetEvent('mr-policejob:ToggleDuty', function()
    onDuty = not onDuty
    TriggerServerEvent("police:server:UpdateCurrentCops")
    TriggerServerEvent("MRFW:ToggleDuty")
    TriggerServerEvent("police:server:UpdateBlips")
end)

RegisterNetEvent('mr-policejob:armory', function()
    if onDuty then
        local authorizedItems = {
            label = "Police Armory",
            slots = 30,
            items = {}
        }
        local index = 1
        for _, armoryItem in pairs(Config.Items.items) do
            for i=1, #armoryItem.authorizedJobGrades do
                if armoryItem.authorizedJobGrades[i] == PlayerJob.grade.level then
                    authorizedItems.items[index] = armoryItem
                    authorizedItems.items[index].slot = index
                    index = index + 1
                end
            end
        end
        SetWeaponSeries()
        TriggerServerEvent("inventory:server:OpenInventory", "shop", "police", authorizedItems)
    else
        MRFW.Functions.Notify("Go on duty First", "error")
    end
end)

--Threads

CreateThread(function()
    while true do
        sleep = 2000 
        if LocalPlayer.state['isLoggedIn'] and PlayerJob.name == "police" then
            local pos = GetEntityCoords(PlayerPedId())
            -- for k, v in pairs(Config.Locations["duty"]) do
            --     if #(pos - v) < 5 then
            --         sleep = 5
            --         if #(pos - v) < 1.5 then
            --             if not onDuty then
            --                 DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Go on duty")
            --             else
            --                 DrawText3D(v.x, v.y, v.z, "~r~E~w~ - Go off duty")
            --             end
            --             if IsControlJustReleased(0, 38) then
            --                 onDuty = not onDuty
            --                 TriggerServerEvent("police:server:UpdateCurrentCops")
            --                 TriggerServerEvent("MRFW:ToggleDuty")
            --                 TriggerServerEvent("police:server:UpdateBlips")
            --             end
            --         elseif #(pos - v) < 2.5 then
            --             DrawText3D(v.x, v.y, v.z, "on/off duty")
            --         end
            --     end
            -- end

            for k, v in pairs(Config.Locations["evidence"]) do
                if #(pos - v) < 2 then
                    sleep = 5
                    if #(pos - v) < 1.0 then
                        DrawText3D(v.x, v.y, v.z, "~g~E~w~ -    Evidence stash")
                        if IsControlJustReleased(0, 38) then
                            TriggerServerEvent("inventory:server:OpenInventory", "stash", "policeevidence", {
                                maxweight = 4000000,
                                slots = 500,
                            })
                            TriggerEvent("inventory:client:SetCurrentStash", "policeevidence")
                        end
                    elseif #(pos - v) < 1.5 then
                        DrawText3D(v.x, v.y, v.z, "Stash 1")
                    end
                end
            end

            for k, v in pairs(Config.Locations["evidence2"]) do
                if #(pos - v) < 2 then
                    sleep = 5
                    if #(pos - v) < 1.0 then
                        DrawText3D(v.x, v.y, v.z, "~g~E~w~ - evidence stash")
                        if IsControlJustReleased(0, 38) then
                            TriggerServerEvent("inventory:server:OpenInventory", "stash", "policeevidence2", {
                                maxweight = 4000000,
                                slots = 500,
                            })
                            TriggerEvent("inventory:client:SetCurrentStash", "policeevidence2")
                        end
                    elseif #(pos - v) < 1.5 then
                        DrawText3D(v.x, v.y, v.z, "Stash 2")
                    end
                end
            end

            for k, v in pairs(Config.Locations["evidence3"]) do
                if #(pos - v) < 2 then
                    sleep = 5
                    if #(pos - v) < 1.0 then
                        DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Evidence stash")
                        if IsControlJustReleased(0, 38) then
                            TriggerServerEvent("inventory:server:OpenInventory", "stash", "policeevidence3", {
                                maxweight = 4000000,
                                slots = 500,
                            })
                            TriggerEvent("inventory:client:SetCurrentStash", "policeevidence3")
                        end
                    elseif #(pos - v) < 1.5 then
                        DrawText3D(v.x, v.y, v.z, "Stash 3")
                    end
                end
            end

            for k, v in pairs(Config.Locations["trash"]) do
                if #(pos - v) < 2 then
                    sleep = 5
                    if #(pos - v) < 1.0 then
                        DrawText3D(v.x, v.y, v.z, "~r~E~w~ - Bin")
                        if IsControlJustReleased(0, 38) then
                            TriggerServerEvent("inventory:server:OpenInventory", "stash", "policetrash", {
                                maxweight = 4000000,
                                slots = 300,
                            })
                            TriggerEvent("inventory:client:SetCurrentStash", "policetrash")
                        end
                    elseif #(pos - v) < 1.5 then
                        DrawText3D(v.x, v.y, v.z, "Bin")
                    end
                end
            end

            for k, v in pairs(Config.Locations["vehicle"]) do
                if #(pos - vector3(v.x, v.y, v.z)) < 7.5 then
                    if onDuty then
                        sleep = 5
                        DrawMarker(2, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                        if #(pos - vector3(v.x, v.y, v.z)) < 1.5 then
                            if IsPedInAnyVehicle(PlayerPedId(), false) then
                                DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Store vehicle")
                            else
                                DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Vehicles")
                            end
                            if IsControlJustReleased(0, 38) then
                                if IsPedInAnyVehicle(PlayerPedId(), false) then
                                    CheckPlayers(GetVehiclePedIsIn(PlayerPedId()))
                                else
                                    ismenu = true
                                    PoliceGarage()
                                    currentGarage = k
                                    -- Menu.hidden = not Menu.hidden
                                end
                            end
                        else
                            if ismenu then
                                ismenu = false
                                MenuV:CloseAll() 
                            end
                        end
                    end
                end
            end

            for k, v in pairs(Config.Locations["impound"]) do
                if #(pos - vector3(v.x, v.y, v.z)) < 7.5 then
                    if onDuty then
                        sleep = 5
                        DrawMarker(2, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                        if #(pos - vector3(v.x, v.y, v.z)) < 1.5 then
                            if IsPedInAnyVehicle(PlayerPedId(), false) then
                                DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Impound Vehicle")
                            else
                                DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Police Impound")
                            end
                            if IsControlJustReleased(0, 38) then
                                if IsPedInAnyVehicle(PlayerPedId(), false) then
                                    CheckPlayers(GetVehiclePedIsIn(PlayerPedId()))
                                else
                                    ismenu2 = true
                                    PoliceImpound()
                                    currentGarage = k
                                    -- Menu.hidden = not Menu.hidden
                                end
                            end
                            -- Menu.renderGUI()
                        else
                            if ismenu2 then
                                ismenu2 = false
                                MenuV:CloseAll() 
                            end
                        end  
                    end
                end
            end

            for k, v in pairs(Config.Locations["helicopter"]) do
                if #(pos - vector3(v.x, v.y, v.z)) < 7.5 then
                    if onDuty and md['airone'] then
                        sleep = 5
                        DrawMarker(2, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                        if #(pos - vector3(v.x, v.y, v.z)) < 1.5 then
                            if IsPedInAnyVehicle(PlayerPedId(), false) then
                                DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Store helicopter")
                            else
                                DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Take a helicopter")
                            end
                            if IsControlJustReleased(0, 38) then
                                if IsPedInAnyVehicle(PlayerPedId(), false) then
                                    CheckPlayers(GetVehiclePedIsIn(PlayerPedId()))
                                else
                                    local coords = Config.Locations["helicopter"][k]
                                    MRFW.Functions.SpawnVehicle(Config.Helicopter, function(veh)
                                        SetVehicleModKit(veh, 0)
                                        SetVehicleNumberPlateTextIndex(veh, 1)
                                        SetVehicleMod(veh, 11, 3, false)
                                        SetVehicleMod(veh, 12, 2, false)
                                        SetVehicleMod(veh, 13, 2, false)
                                        SetVehicleMod(veh, 15, 3, false)
                                        SetVehicleMod(veh, 16, 4, false)
                                        ToggleVehicleMod(veh, 18, true)
                                        SetVehicleMod(veh, 14, 1, false)
                                        SetVehicleMod(veh, 42, 0, false)
                                        ToggleVehicleMod(veh, 22, true)
                                        SetVehicleXenonLightsColor(veh, 0)
                                        for id = 0, 12 do
                                            if DoesExtraExist(veh, id) then
                                                SetVehicleExtra(veh, id, false)
                                            end
                                        end
                                        SetVehicleMod(veh, 48, 1, false)
                                        SetVehicleNumberPlateText(veh, "ZULU"..tostring(math.random(1000, 9999)))
                                        exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'body', 1000.0)
                                        exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'engine', 1000.0)
                                        exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'fuel', 100)
                                        exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'clutch', 100)
                                        exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'brakes', 100)
                                        exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'axle', 100)
                                        exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'radiator', 100)
                                        SetEntityHeading(veh, coords.w)
                                        exports['mr-fuel']:SetFuel(veh, 100.0)
                                        closeMenuFull()
                                        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                                        TriggerEvent("vehiclekeys:client:SetOwner", MRFW.Functions.GetPlate(veh))
                                        SetVehicleEngineOn(veh, true, true)
                                    end, coords, true)
                                end
                            end
                        end  
                    end
                end
            end

            -- for k, v in pairs(Config.Locations["armory"]) do
            --     if #(pos - v) < 4.5 then
            --         if onDuty then
            --             sleep = 5
            --             if #(pos - v) < 1.5 then
            --                 DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Armory")
            --                 if IsControlJustReleased(0, 38) then
            --                     local authorizedItems = {
            --                         label = "Police Armory",
            --                         slots = 30,
            --                         items = {}
            --                     }
            --                     local index = 1
            --                     for _, armoryItem in pairs(Config.Items.items) do
            --                         for i=1, #armoryItem.authorizedJobGrades do
            --                             if armoryItem.authorizedJobGrades[i] == PlayerJob.grade.level then
            --                                 authorizedItems.items[index] = armoryItem
            --                                 authorizedItems.items[index].slot = index
            --                                 index = index + 1
            --                             end
            --                         end
            --                     end
            --                     SetWeaponSeries()
            --                     TriggerServerEvent("inventory:server:OpenInventory", "shop", "police", authorizedItems)
            --                 end
            --             elseif #(pos - v) < 2.5 then
            --                 DrawText3D(v.x, v.y, v.z, "Armory")
            --             end
            --         end
            --     end
            -- end

            for k, v in pairs(Config.Locations["stash"]) do
                if #(pos - v) < 4.5 then
                    if onDuty then
                        sleep = 5
                        if #(pos - v) < 1.5 then
                            DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Personal stash")
                            if IsControlJustReleased(0, 38) then
                                TriggerServerEvent("inventory:server:OpenInventory", "stash", "policestash_"..MRFW.Functions.GetPlayerData().citizenid)
                                TriggerEvent("inventory:client:SetCurrentStash", "policestash_"..MRFW.Functions.GetPlayerData().citizenid)
                            end
                        elseif #(pos - v) < 2.5 then
                            DrawText3D(v.x, v.y, v.z, "Personal stash")
                        end
                    end
                end
            end

            for k, v in pairs(Config.Locations["fingerprint"]) do
                if #(pos - v) < 4.5 then
                    if onDuty then
                        sleep = 5
                        if #(pos - v) < 1.5 then
                            DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Scan fingerprint")
                            if IsControlJustReleased(0, 38) then
                                local player, distance = GetClosestPlayer()
                                if player ~= -1 and distance < 2.5 then
                                    local playerId = GetPlayerServerId(player)
                                    TriggerServerEvent("police:server:showFingerprint", playerId)
                                else
                                    MRFW.Functions.Notify("No one nearby!", "error")
                                end
                            end
                        elseif #(pos - v) < 2.5 then
                            DrawText3D(v.x, v.y, v.z, "Finger scan")
                        end  
                    end
                end
            end
        end
        Wait(sleep)
    end
end)