local statusCheckPed = nil
local PlayerJob = {}
local onDuty = false
local currentGarage = 1
onDutyasDoc = false
local ismenu = false
-- Functions

local function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

local function GetClosestPlayer()
    local closestPlayers = MRFW.Functions.GetPlayersFromCoords()
    local closestDistance = -1
    local closestPlayer = -1
    local coords = GetEntityCoords(PlayerPedId())

    for i=1, #closestPlayers, 1 do
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

function TakeOutVehicle(vehicleInfo)
    local coords = Config.Locations["vehicle"][currentGarage]
    MRFW.Functions.SpawnVehicle(vehicleInfo[1], function(veh)
        SetVehicleNumberPlateText(veh, "AMBU"..tostring(math.random(1000, 9999)))
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

function VehicleList(isDown)
    MenuTitle = "Vehicles:"
    ClearMenu()
    local authorizedVehicles = Config.AuthorizedVehicles[MRFW.Functions.GetPlayerData().job.grade.level]
    for k, v in pairs(authorizedVehicles) do
        Menu.addButton(authorizedVehicles[k], "TakeOutVehicle", {k, isDown}, "Garage", " Engine: 100%", " Body: 100%", " Fuel: 100%")
    end

    Menu.addButton("Back", "MenuGarage",nil)
end

function closeMenuFull()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
end

function MenuGarage(isDown)
    MenuTitle = "Garage"
    ClearMenu()
    Menu.addButton("My vehicles", "VehicleList", isDown)
    Menu.addButton("Close Menu", "closeMenuFull", nil)
end

-- Events

RegisterNetEvent('MRFW:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    TriggerServerEvent("hospital:server:SetDoctor")
end)

RegisterNetEvent('MRFW:Client:OnPlayerLoaded', function()
    exports.spawnmanager:setAutoSpawn(false)
    local ped = PlayerPedId()
    local player = PlayerId()
    TriggerServerEvent("hospital:server:SetDoctor")
    CreateThread(function()
        Wait(5000)
        SetEntityMaxHealth(ped, 200)
        -- SetEntityHealth(ped, 200)
        SetPlayerHealthRechargeMultiplier(player, 0.0)
        SetPlayerHealthRechargeLimit(player, 0.0)
    end)
    CreateThread(function()
        Wait(1000)
        MRFW.Functions.GetPlayerData(function(PlayerData)
            PlayerJob = PlayerData.job
            onDuty = PlayerData.job.onduty
            SetPedArmour(PlayerPedId(), PlayerData.metadata["armor"])
            SetEntityHealth(PlayerPedId(), PlayerData.metadata["health"])
            if (not PlayerData.metadata["inlaststand"] and PlayerData.metadata["isdead"]) then
                deathTime = Laststand.ReviveInterval
                OnDeath(true)
                DeathTimer()
            elseif (PlayerData.metadata["inlaststand"] and not PlayerData.metadata["isdead"]) then
                SetLaststand(true, true)
            else
                TriggerServerEvent("hospital:server:SetDeathStatus", false)
                TriggerServerEvent("hospital:server:SetLaststandStatus", false)
            end
        end)
    end)
end)

RegisterNetEvent('MRFW:Client:SetDuty', function(duty)
    onDuty = duty
    TriggerServerEvent("hospital:server:SetDoctor")
end)

RegisterNetEvent('hospital:client:CheckStatus', function()
    local player, distance = GetClosestPlayer()
    if player ~= -1 and distance < 5.0 then
        local playerId = GetPlayerServerId(player)
        statusCheckPed = GetPlayerPed(player)
        MRFW.Functions.TriggerCallback('hospital:GetPlayerStatus', function(result)
            if result then
                for k, v in pairs(result) do
                    if k ~= "BLEED" and k ~= "WEAPONWOUNDS" then
                        statusChecks[#statusChecks+1] = {bone = Config.BoneIndexes[k], label = v.label .." (".. Config.WoundStates[v.severity] ..")"}
                    elseif result["WEAPONWOUNDS"] then
                        for k, v in pairs(result["WEAPONWOUNDS"]) do
                            TriggerEvent('chat:addMessage', {
                                color = { 255, 0, 0},
                                multiline = false,
                                args = {"Status Check", WeaponDamageList[v]}
                            })
                        end
                    elseif result["BLEED"] > 0 then
                        TriggerEvent('chat:addMessage', {
                            color = { 255, 0, 0},
                            multiline = false,
                            args = {"Status Check", "Is "..Config.BleedingStates[v].label}
                        })
                    else
                        MRFW.Functions.Notify('Player Is Healthy', 'success')
                    end
                end
                isStatusChecking = true
                statusCheckTime = Config.CheckTime
            end
        end, playerId)
    else
        MRFW.Functions.Notify('No Player Nearby', 'error')
    end
end)

RegisterNetEvent('hospital:client:RevivePlayer', function()
    MRFW.Functions.TriggerCallback('hospital:server:Hascprkit', function(hasItem)
        if hasItem then
            local player, distance = GetClosestPlayer()
            if player ~= -1 and distance < 5.0 then
                local playerId = GetPlayerServerId(player)
                isHealingPerson = true
                MRFW.Functions.Progressbar("hospital_revive", "Reviving person..", 5000, false, true, {
                    disableMovement = false,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = healAnimDict,
                    anim = healAnim,
                    flags = 16,
                }, {}, {}, function() -- Done
                    isHealingPerson = false
                    StopAnimTask(PlayerPedId(), healAnimDict, "exit", 1.0)
                    MRFW.Functions.Notify("You revived the person!")
                    TriggerServerEvent("hospital:server:RevivePlayer", playerId)
                end, function() -- Cancel
                    isHealingPerson = false
                    StopAnimTask(PlayerPedId(), healAnimDict, "exit", 1.0)
                    MRFW.Functions.Notify("Failed!", "error")
                end)
            else
                MRFW.Functions.Notify("No Player Nearby", "error")
            end
        else
            MRFW.Functions.Notify("You Need A CPR Kit", "error")
        end
    end, 'cprkit')
end)

RegisterNetEvent('hospital:client:TreatWounds', function()
    MRFW.Functions.TriggerCallback('hospital:server:HasBandage', function(hasItem)
        if hasItem then
            local player, distance = GetClosestPlayer()
            if player ~= -1 and distance < 5.0 then
                local playerId = GetPlayerServerId(player)
                isHealingPerson = true
                MRFW.Functions.Progressbar("hospital_healwounds", "Healing wounds..", 5000, false, true, {
                    disableMovement = false,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = healAnimDict,
                    anim = healAnim,
                    flags = 16,
                }, {}, {}, function() -- Done
                    isHealingPerson = false
                    StopAnimTask(PlayerPedId(), healAnimDict, "exit", 1.0)
                    MRFW.Functions.Notify("You helped the person!")
                    TriggerServerEvent("hospital:server:TreatWounds", playerId)
                end, function() -- Cancel
                    isHealingPerson = false
                    StopAnimTask(PlayerPedId(), healAnimDict, "exit", 1.0)
                    MRFW.Functions.Notify("Failed!", "error")
                end)
            else
                MRFW.Functions.Notify("No Player Nearby", "error")
            end
        else
            MRFW.Functions.Notify("You Need A Bandage", "error")
        end
    end, 'bandage')
end)

-- Threads

CreateThread(function()
    while true do
        sleep = 5000
        if LocalPlayer.state.isLoggedIn then
            sleep = 2000
            if PlayerJob.name =="doctor" then
                if isStatusChecking then
                    sleep = 5
                    for k, v in pairs(statusChecks) do
                        local x,y,z = table.unpack(GetPedBoneCoords(statusCheckPed, v.bone))
                        DrawText3D(x, y, z, v.label)
                    end
                end
                if isHealingPerson then
                    sleep = 5
                    local ped = PlayerPedId()
                    if not IsEntityPlayingAnim(ped, healAnimDict, healAnim, 3) then
                        loadAnimDict(healAnimDict)	
                        TaskPlayAnim(ped, healAnimDict, healAnim, 3.0, 3.0, -1, 49, 0, 0, 0, 0)
                    end
                end
            end
        end
        Wait(sleep)
    end
end)

RegisterNetEvent('hospital:ToggleDuty', function()
    onDuty = not onDuty
    TriggerServerEvent("MRFW:ToggleDuty")
    TriggerServerEvent("police:server:UpdateBlips")
end)

RegisterNetEvent('hospital:ToggleDuty2', function()
    if onDuty then
        if not onDutyasDoc then
            TriggerServerEvent('hospital:server:SetDoctorSign',true)
            MRFW.Functions.Notify('You signed in as Doctor', 'success')
        else
            TriggerServerEvent('hospital:server:SetDoctorSign',false)
            MRFW.Functions.Notify('You signed out as Doctor', 'error')
        end
    else
        MRFW.Functions.Notify('First go onduty', 'error')
    end
end)


local showText = false
local showText2 = false

CreateThread(function()
    while true do
        sleep = 5000
        if LocalPlayer.state['isLoggedIn'] then
            sleep = 2000
            if PlayerJob.name =="doctor" then
                local ped = PlayerPedId()
                local pos = GetEntityCoords(ped)
                sleep = 1000

                for k, v in pairs(Config.Locations['pstash']) do
                    local dist = #(pos - v)
                    if dist < 5 then
                        -- if onDuty then
                            if dist < 1.5 then
                                sleep = 15
                                if not showText then
                                    exports['mr-text']:DrawText(
                                        '[E] Personal Stash ',
                                        0, 94, 255,0.7,
                                        1,
                                        50
                                    )
                                    showText = true
                                end
                                if IsControlJustPressed(0, 38) then
                                    TriggerServerEvent("inventory:server:OpenInventory", "stash", "drstash"..MRFW.Functions.GetPlayerData().citizenid)
                                    TriggerEvent("inventory:client:SetCurrentStash", "drstash"..MRFW.Functions.GetPlayerData().citizenid)
                                end
                            else
                                if showText then
                                    exports['mr-text']:HideText(1)
                                    showText = false
                                end
                            end
                        -- end
                    end
                end

                for k, v in pairs(Config.Locations["armory"]) do
                    local dist = #(pos - v)
                    if dist < 4.5 then
                        if onDuty then
                            if dist < 1.5 then
                                sleep = 15
                                if not showText then
                                    exports['mr-text']:DrawText(
                                        '[E] Pharmacy ',
                                        128, 0, 32,0.7,
                                        1,
                                        50
                                    )
                                    showText = true
                                end
                                if IsControlJustReleased(0, 38) then
                                    TriggerServerEvent("inventory:server:OpenInventory", "shop", "hospital", Config.Items)
                                end
                            else
                                if showText then
                                    exports['mr-text']:HideText(1)
                                    showText = false
                                end
                            end  
                        end
                    end
                end

                for k, v in pairs(Config.Locations["vehicle"]) do
                    local dist = #(pos - vector3(v.x, v.y, v.z))
                    if dist < 4.5 then
                        sleep = 5
                        DrawMarker(2, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                        if dist < 1.5 then
                            if IsPedInAnyVehicle(ped, false) then
                                if not showText then
                                    exports['mr-text']:DrawText(
                                        '[E] Store vehicle ',
                                        128, 0, 32,0.7,
                                        1,
                                        50
                                    )
                                    showText = true
                                end
                            else
                                if not showText then
                                    exports['mr-text']:DrawText(
                                        '[E] Vehicles ',
                                        128, 0, 32,0.7,
                                        1,
                                        50
                                    )
                                    showText = true
                                end
                            end
                            if IsControlJustReleased(0, 38) then
                                if IsPedInAnyVehicle(ped, false) then
                                    CheckPlayers(GetVehiclePedIsIn(PlayerPedId()))
                                else
                                    ismenu = true
                                    EMSGarage()
                                    currentGarage = k
                                end
                            end
                            -- Menu.renderGUI()
                        else
                            if showText then
                                exports['mr-text']:HideText(1)
                                showText = false
                            end
                            if ismenu then
                                ismenu = false
                                MenuV:CloseAll() 
                            end
                        end
                    end
                end

                for k, v in pairs(Config.Locations["helicopter"]) do
                    local dist = #(pos - vector3(v.x, v.y, v.z))
                    if dist < 7.5 then
                        if onDuty then
                            sleep = 5
                            DrawMarker(2, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                            if dist < 1.5 then
                                if IsPedInAnyVehicle(ped, false) then
                                    if not showText then
                                        exports['mr-text']:DrawText(
                                            '[E] Store helicopter ',
                                            128, 0, 32,0.7,
                                            1,
                                            50
                                        )
                                        showText = true
                                    end
                                else
                                    if not showText then
                                        exports['mr-text']:DrawText(
                                            '[E] Take a helicopter ',
                                            128, 0, 32,0.7,
                                            1,
                                            50
                                        )
                                        showText = true
                                    end
                                end
                                if IsControlJustReleased(0, 38) then
                                    if IsPedInAnyVehicle(ped, false) then
                                        CheckPlayers(GetVehiclePedIsIn(PlayerPedId()))
                                    else
                                        local coords = Config.Locations["helicopter"][k]
                                        MRFW.Functions.SpawnVehicle(Config.Helicopter, function(veh)
                                            SetVehicleNumberPlateText(veh, "LIFE"..tostring(math.random(1000, 9999)))
                                            exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'body', 1000.0)
                                            exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'engine', 1000.0)
                                            exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'fuel', 100)
                                            exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'clutch', 100)
                                            exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'brakes', 100)
                                            exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'axle', 100)
                                            exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'radiator', 100)
                                            SetEntityHeading(veh, coords.w)
                                            SetVehicleLivery(veh, 1) -- Ambulance Livery
                                            exports['mr-fuel']:SetFuel(veh, 100.0)
                                            closeMenuFull()
                                            TaskWarpPedIntoVehicle(ped, veh, -1)
                                            TriggerEvent("vehiclekeys:client:SetOwner", MRFW.Functions.GetPlate(veh))
                                            SetVehicleEngineOn(veh, true, true)
                                        end, coords, true)
                                        if showText then
                                            exports['mr-text']:HideText(1)
                                            showText = false
                                        end
                                    end
                                end
                            else
                                if showText then
                                    exports['mr-text']:HideText(1)
                                    showText = false
                                end
                            end  
                        end
                    end
                end
            end
        end
        Wait(sleep)
    end
end)

RegisterNetEvent('hospital:client:SendAlert', function(msg)
    PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
    TriggerEvent("chatMessage", "PAGER", "error", msg)
end)

RegisterNetEvent('112:client:SendAlert', function(msg, blipSettings)
    if (PlayerJob.name == "police" or PlayerJob.name == "doctor") and onDuty then
        if blipSettings ~= nil then
            local transG = 250
            local blip = AddBlipForCoord(blipSettings.x, blipSettings.y, blipSettings.z)
            SetBlipSprite(blip, blipSettings.sprite)
            SetBlipColour(blip, blipSettings.color)
            SetBlipDisplay(blip, 4)
            SetBlipAlpha(blip, transG)
            SetBlipScale(blip, blipSettings.scale)
            SetBlipAsShortRange(blip, false)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(blipSettings.text)
            EndTextCommandSetBlipName(blip)
            while transG ~= 0 do
                Wait(180 * 4)
                transG = transG - 1
                SetBlipAlpha(blip, transG)
                if transG == 0 then
                    SetBlipSprite(blip, 2)
                    RemoveBlip(blip)
                    return
                end
            end
        end
    end
end)

RegisterNetEvent('hospital:client:AiCall', function()
    local PlayerPeds = {}
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        table.insert(PlayerPeds, ped)
    end
    local player = PlayerPedId()
    local coords = GetEntityCoords(player)
    local closestPed, closestDistance = MRFW.Functions.GetClosestPed(coords, PlayerPeds)
    local gender = MRFW.Functions.GetPlayerData().gender
    local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, coords.x, coords.y, coords.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    if closestDistance < 50.0 and closestPed ~= 0 then
        MakeCall(closestPed, gender, street1, street2)
    end
end)

function MakeCall(ped, male, street1, street2)
    local callAnimDict = "cellphone@"
    local callAnim = "cellphone_call_listen_base"
    local rand = (math.random(6,9) / 100) + 0.3
    local rand2 = (math.random(6,9) / 100) + 0.3
    local coords = GetEntityCoords(PlayerPedId())
    local blipsettings = {
        x = coords.x,
        y = coords.y,
        z = coords.z,
        sprite = 280,
        color = 4,
        scale = 0.9,
        text = "Wounded person"
    }

    if math.random(10) > 5 then
        rand = 0.0 - rand
    end

    if math.random(10) > 5 then
        rand2 = 0.0 - rand2
    end

    local moveto = GetOffsetFromEntityInWorldCoords(PlayerPedId(), rand, rand2, 0.0)

    TaskGoStraightToCoord(ped, moveto, 2.5, -1, 0.0, 0.0)
    SetPedKeepTask(ped, true)

    local dist = GetDistanceBetweenCoords(moveto, GetEntityCoords(ped), false)

    while dist > 3.5 and isDead do
        TaskGoStraightToCoord(ped, moveto, 2.5, -1, 0.0, 0.0)
        dist = GetDistanceBetweenCoords(moveto, GetEntityCoords(ped), false)
        Wait(100)
    end

    ClearPedTasksImmediately(ped)
    TaskLookAtEntity(ped, PlayerPedId(), 5500.0, 2048, 3)
    TaskTurnPedToFaceEntity(ped, PlayerPedId(), 5500)

    Wait(3000)

    --TaskStartScenarioInPlace(ped,"WORLD_HUMAN_STAND_MOBILE", 0, 1)
    loadAnimDict(callAnimDict)
    TaskPlayAnim(ped, callAnimDict, callAnim, 1.0, 1.0, -1, 49, 0, 0, 0, 0)

    SetPedKeepTask(ped, true)

    Wait(5000)
    -- TriggerServerEvent("hospital:server:MakeDeadCall", blipsettings, male, street1, street2)
    exports['mr-dispatch']:InjuriedPerson()

    SetEntityAsNoLongerNeeded(ped)
    ClearPedTasks(ped)
end

CreateThread(function()
    while true do
        if MRFW ~= nil then
            MRFW.Functions.TriggerCallback('jacob:server:checkDoctor', function(count)
                if count == 0 then
                    if onDutyasDoc then
                        -- TriggerServerEvent('hospital:server:SetDoctorSign',false)
                        onDutyasDoc = false
                    end
                end
            end)
            Wait(30000)
        else
            Wait(2500)
        end
    end
end)

RegisterNetEvent('hospital:client:SetSignDoc', function(signindoo)
    onDutyasDoc = signindoo
end)

local ayush
function EMSGarage()
    ayush = MenuV:CreateMenu(false,"EMS Garage", 'topright', 234, 31, 31, 'size-125', 'none', 'menuv')
    ayush_VehicleList()
end

function ayush_VehicleList()
    local authorizedVehicles = Config.AuthorizedVehicles[MRFW.Functions.GetPlayerData().job.grade.level]
    for k, v in pairs(authorizedVehicles) do
        ayush:AddButton({
            icon = '🚑',
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
        exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'body', 1000.0)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'engine', 1000.0)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'fuel', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'clutch', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'brakes', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'axle', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'radiator', 100)
        -- SetVehicleMod(veh, 11, 3, false)
        -- SetVehicleMod(veh, 12, 2, false)
        -- SetVehicleMod(veh, 13, 2, false)
        -- SetVehicleMod(veh, 15, 3, false)
        SetVehicleMod(veh, 16, 4, false)
        -- ToggleVehicleMod(veh, 18, true)
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
        SetEntityHeading(veh, coords.h)
        exports['mr-fuel']:SetFuel(veh, 100.0)
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
        SetVehicleDirtLevel(veh)
        WashDecalsFromVehicle(veh, 1.0)
    end, coords, true)
    if showText then
        exports['mr-text']:HideText(1)
        showText = false
    end
end

function CheckPlayers(vehicle)
    for i = -1, 5,1 do                
        seat = GetPedInVehicleSeat(vehicle,i)
        if seat ~= 0 then
            TaskLeaveVehicle(seat,vehicle,0)
            SetVehicleDoorsLocked(vehicle)
            Wait(1500)
            MRFW.Functions.DeleteVehicle(vehicle)
            if showText then
                exports['mr-text']:HideText(1)
                showText = false
            end
        end
   end
end