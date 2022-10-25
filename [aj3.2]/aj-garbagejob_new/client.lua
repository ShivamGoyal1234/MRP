local AJFW = exports['ajfw']:GetCoreObject()

local PlayerJob = {}

local showText = false
local showText2 = false

local showRadar = false

local jobStarted = false
local arrived    = false
local collecting = true
local dumping = true
local submiting = true

local loop1 = false
local loop2 = false
local loop3 = false

local maxRuns = 0

local truck = nil
local plate = nil

local TotalAreas   = #Config.Areas
-- print(TotalAreas)    
local TotalDumpers = #Config.Dumpsters

local blips = {
    ['hq'] = nil,
    ['mission'] = nil,
    ['dump'] = nil,
    ['submit'] = nil,
}

local zz = nil
local yy = nil
local xx = nil

local Timeout = false
local timeouts = 10000

local function DrawText3D(type, x, y, z, text, container, hi)
    if type == 'ui' then
        if hi == nil then
            hi = 50
        end
        exports['aj-text']:DrawText(text, 0, 94, 255,0.7,container,hi)
    elseif type == 'dui' then
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
end

local function HideTextUI(container)
    exports['aj-text']:HideText(container)
end

local function LoadModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(10)
    end
end

local function LoadAnimation(dict)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(1)
	end
end

local function CheckPlayers(vehicle)
    for i = -1, 5,1 do                
        seat = GetPedInVehicleSeat(vehicle,i)
        if seat ~= 0 then
            TaskLeaveVehicle(seat,vehicle,0)
            SetVehicleDoorsLocked(vehicle)
            Wait(1500)
            AJFW.Functions.DeleteVehicle(vehicle)
        end
    end
end

function GetClosestVehicleNearThisMotherfuckingsPlace(o)
    local H = 1000
    local q, z = FindFirstVehicle()
    local r
    repeat
        local E = GetDistanceBetweenCoords(GetEntityCoords(z), o.x, o.y, o.z)
        if E < H then
            H = E
        end
        r, z = FindNextVehicle(q, z)
    until not r
    EndFindVehicle(q)
    return H
end

local function submit()
    loop2 = false
    loop3 = true
    submiting = false
    Citizen.CreateThread(function()
        while loop3 do
            sleep = 100
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local Submit = Config.Locations['submit']
            local dist = #(pos - Submit)
            if dist <= 20 then
                sleep = 5
                if IsPedInAnyVehicle(ped, false) then
                    DrawMarker(2, Submit+vector3(0.0,0.0,1.0), 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 150, false, true, 2, false, false, false, false)
                    local veh = GetVehiclePedIsIn(ped, false)
                    local plate2 = GetVehicleNumberPlateText(veh)
                    if dist <= 2 then
                        if not showText and not submiting then
                            DrawText3D('ui', nil, nil, nil, '[E] to collect trash', 1)
                            showText = true
                        end
                        if IsControlJustPressed(0, 38) and not submiting then
                            submiting = true
                            if showText then
                                HideTextUI(1)
                                showText = false
                            end
                            SetBlipRoute(blips['submit'], false)
                            RemoveBlip(blips['submit'])
                            blips['submit'] = nil
                            if plate == plate2 then
                                AJFW.Functions.Progressbar('Garbage_dropoff', 'Droping off Trash', 5000, false, true, { -- Name | Label | Time | useWhileDead | canCancel
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {}, {}, {}, function() -- Play When Done
                                    local Pay = math.random(Config.payMin, Config.payMax)
                                    local finalPay = Pay * maxRuns
                                    CheckPlayers(truck)
                                    showRadar = false
                                    DisplayRadar(false)
                                    for i=1,200,1 do 
                                        if DoesEntityExist(truck) then
                                            CheckPlayers(truck)
                                        else
                                            plate = nil
                                            truck = nil
                                            submiting = false 
                                            jobStarted = false   
                                            TriggerServerEvent('aj-garage_new:server:GiveMoney', finalPay)
                                            loop3 = false
                                            arrived = false
                                            return
                                        end
                                    end
                                    plate = nil
                                    truck = nil
                                    Citizen.Wait(1000)
                                    submiting = false 
                                    jobStarted = false   
                                    arrived = false
                                    TriggerServerEvent('aj-garage_new:server:GiveMoney', finalPay)
                                    loop3 = false
                                    return
                                end, function() -- Play When Cancel
                                    submiting = false
                                end)
                            else
                                AJFW.Functions.Notify("this not our vehicle", "error", 5000)
                                submiting = false
                            end
                        end
                    else
                        if showText then
                            HideTextUI(1)
                            showText = false
                        end
                    end
                end
            end
            Citizen.Wait(sleep)
        end
    end)
end

local function findtrashbins(coords, pickups)
    -- print(coords,pickups)
    zz = coords
    yy = pickups
    showRadar = true
    collecting = false
    loop1 = true
    LoadAnimation("anim@heists@narcotics@trash")
    if pickups < maxRuns then
        angle = math.random()*math.pi*2;
        r = math.sqrt(math.random());
        x = coords.x + r * math.cos(angle) * 100;     
        y = coords.y + r * math.sin(angle) * 100;
        local ret = math.random(1, TotalDumpers)
        -- print(ret)
        local object = Config.Dumpsters[ret]
        -- print(object)
        local NewBin = GetClosestObjectOfType(x, y, coords.z, 150.0, object, false)
        -- print(NewBin)
        if NewBin ~= 0 then
            xx = NewBin
            local loop = true
            local dumpCoords = GetEntityCoords(NewBin)
            -- print(dumpCoords)
            blips['dump'] = AddBlipForCoord(dumpCoords)
            -- print(blips['dump'])
            SetBlipSprite(blips['dump'], Config.BlipSetting['dump'].sprite)
            SetBlipScale (blips['dump'], Config.BlipSetting['dump'].scale)
            SetBlipColour(blips['dump'], Config.BlipSetting['dump'].color)
            SetBlipRoute(blips['dump'], true)
            SetBlipRouteColour(blips['dump'], Config.BlipSetting['dump'].routeColor)
            while loop1 do
                sleep = 100
                local ped = PlayerPedId()
                local pos = GetEntityCoords(ped)
                local dist = #(pos - dumpCoords)
                local bone = GetPedBoneIndex(ped, 57005)
                if dist <= 20 then
                    sleep = 5
                    DrawMarker(20, dumpCoords + vector3(0.0,0.0,2.0), 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.7, 0.7, 0.5, 0, 120, 0, 200, false, true, 2, false, false, false, false)
                    if dist <= 2 then
                        if not showText and not collecting then
                            DrawText3D('ui', nil, nil, nil, '[E] to collect trash', 1)
                            showText = true
                        end
                        if IsControlJustPressed(0, 38) and not collecting then
                            collecting = true
                            if showText then
                                HideTextUI(1)
                                showText = false
                            end
                            local bag = CreateObject(Config.Bag, 0, 0, 0, true, true, true)
                            AttachEntityToEntity(bag, ped, bone, 0.12, 0.0, 0.00, 25.0, 270.0, 180.0, true, true, false, true, 1, true)
                            TaskPlayAnim(ped, 'anim@heists@narcotics@trash', 'walk', 1.0, -1.0,-1,49,0,0, 0,0)
                            SetBlipRoute(blips['dump'], false)
                            RemoveBlip(blips['dump'])
                            blips['dump'] = nil
                            Collected(bag, coords, pickups, NewBin)
                            return
                        end
                    else
                        if showText then
                            HideTextUI(1)
                            showText = false
                        end
                    end
                end
                Citizen.Wait(sleep)
            end
            return
        else
            findtrashbins(coords, pickups)
            -- AJFW.Functions.Notify('Something went wrong contact Server Developers', 'error', 3000)
        end
    else
        arrived = false
        zz = nil
        yy = nil
        xx = nil
        submit()
        AJFW.Functions.Notify("Job done! Return to HQ", "Success", 5000)
        local cc = Config.Locations['spawn']
        blips['submit'] = AddBlipForCoord(cc)
        SetBlipRoute(blips['submit'], true)
        SetBlipRouteColour(blips['submit'], Config.BlipSetting['submit'].routeColor)
        SetBlipColour(blips['submit'], Config.BlipSetting['submit'].color)
    end
end

function Collected(bag, coords, runs, NewBin)
    dumping = false
    loop1 = false
    loop2 = true
    while loop2 do
        sleep = 100
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local trunkcoord = GetWorldPositionOfEntityBone(truck, GetEntityBoneIndexByName(truck, "platelight"))
        local dist = #(pos - trunkcoord)
        if dist <= 20 then
            sleep = 5
            if dist <= 1.5 then
                if not showText and not dumping then
                    DrawText3D('ui', nil, nil, nil, '[E] to throw trash', 1)
                    showText = true
                end
                if IsControlJustPressed(0, 38) and not dumping then
                    dumping = true
                    if showText then
                        HideTextUI(1)
                        showText = false
                    end
                    TriggerServerEvent('aj-garage_new:server:Giveitem')
                    ClearPedTasksImmediately(ped)
					TaskPlayAnim(ped, 'anim@heists@narcotics@trash', 'throw_b', 1.0, -1.0,-1,2,0,0, 0,0)
                    Citizen.Wait(100)
                    DeleteObject(bag)
                    SetEntityAsMissionEntity(NewBin, true, true)
                    -- DeleteEntity(NewBin)
                    Citizen.Wait(100)
                    if DoesEntityExist(NewBin) and IsEntityAMissionEntity(NewBin) then
                        SetEntityAsNoLongerNeeded(NewBin)
                    end
                    Citizen.Wait(3000)
                    ClearPedTasksImmediately(ped)
                    local tt = runs + 1
                    AJFW.Functions.Notify(tt .."/"..maxRuns.." Trash bags picked", "success", 5000)
                    findtrashbins(pos, runs + 1)
                    dumping = false
                    loop2 = false
                    return
                end
            else
                if showText then
                    HideTextUI(1)
                    showText = false
                end
            end
        end
        Citizen.Wait(sleep)
    end
end

local function missionStart(coords)
    blips['mission'] = AddBlipForCoord(coords)
    SetBlipRoute(blips['mission'], true)
    SetBlipRouteColour(blips['mission'], Config.BlipSetting['mission'].routeColor)
    SetBlipColour(blips['mission'], Config.BlipSetting['mission'].color)
    Citizen.CreateThread(function()
        while not arrived do
            sleep = 100
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local dist = #(pos - coords)
            if dist < 50 then
                sleep = 5
                DrawMarker(20, coords + vector3(0.0, 0.0, 1.5), 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 1.0, 0, 120, 0, 200, false, true, 2, false, false, false, false)
                if dist <= 2 then
                    arrived = true
                    maxRuns = math.random(Config.RunMin, Config.RunMax)
                    AJFW.Functions.Notify("you need to pick "..maxRuns.." Trashbags to Complete this job", "success", 5000)
                    Citizen.Wait(1000)
                    SetBlipRoute(blips['mission'], false)
                    RemoveBlip(blips['mission'])
                    blips['mission'] = nil
                    findtrashbins(coords, 0)
                end
            end
            Citizen.Wait(sleep)
        end
    end)
end

local function startJob()
    local random = math.random(1, TotalAreas)
    local coords = Config.Areas[random]
    local model  = Config.Truck
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(0)
    end
    truck = CreateVehicle(model, Config.Locations['spawn'].x, Config.Locations['spawn'].y, Config.Locations['spawn'].z, Config.Locations['spawn'].w, true, false)
    exports['aj-fuel']:SetFuel(truck, 100.0)
    plate = GetVehicleNumberPlateText(truck)
    SetEntityAsMissionEntity(truck, true, true)
    TriggerEvent("vehiclekeys:client:SetOwner", plate)
    Citizen.Wait(1000)
    missionStart(coords)
end


RegisterNetEvent('AJFW:Client:OnPlayerLoaded', function()
    PlayerData = AJFW.Functions.GetPlayerData()
    PlayerJob = PlayerData.job
end)

RegisterNetEvent('AJFW:Client:OnPlayerUnload', function()
    PlayerJob = {}

    showText = false
    showText2 = false

    showRadar = false

    jobStarted = false
    arrived    = false
    collecting = true
    dumping = true
    submiting = true

    loop1 = false
    loop2 = false
    loop3 = false

    maxRuns = 0

    truck = nil
    plate = nil

    zz = nil
    yy = nil
    xx = nil

    blips = {
        ['hq'] = nil,
        ['mission'] = nil,
        ['dump'] = nil,
        ['submit'] = nil,
    }

    Timeout = false
    timeouts = 10000

    RemoveBlip(blips['hq'])
    RemoveBlip(blips['mission'])
    RemoveBlip(blips['dump'])
    RemoveBlip(blips['submit'])
end)

AddEventHandler('onResourceStop', function(resource)
   if resource == GetCurrentResourceName() then
        PlayerJob = {}

        showText = false
        showText2 = false

        showRadar = false

        jobStarted = false
        arrived    = false
        collecting = true
        dumping = true
        submiting = true

        loop1 = false
        loop2 = false
        loop3 = false

        maxRuns = 0

        truck = nil
        plate = nil

        zz = nil
        yy = nil
        xx = nil

        blips = {
            ['hq'] = nil,
            ['mission'] = nil,
            ['dump'] = nil,
            ['submit'] = nil,
        }

        Timeout = false
        timeouts = 10000
        
        RemoveBlip(blips['hq'])
        RemoveBlip(blips['mission'])
        RemoveBlip(blips['dump'])
        RemoveBlip(blips['submit'])
   end
end)

RegisterNetEvent('AJFW:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

RegisterNetEvent('garbage:client:skip', function(a,b)
    loop1 = false
    Wait(100)
    findtrashbins(a,b)
end)

Citizen.CreateThread(function()
    while true do
        sleep = 2500
        if LocalPlayer.state['isLoggedIn'] then
            if Config.JobRequired then
                if PlayerJob.name == 'garbage' then
                    sleep = 1000
                    local ped = PlayerPedId()
                    local pos = GetEntityCoords(ped)
                    local start = Config.Locations['start']
                    local dist = #(pos - start)
                    if dist <= 10 then
                        sleep = 5
                        if dist <= 1 then
                            if not showText then
                                DrawText3D('ui', nil, nil, nil, '[E] To Start', 1)
                                showText = true
                            end
                            if IsControlJustPressed(0, 38) and not jobStarted then
                                jobStarted = true
                                local O = GetClosestVehicleNearThisMotherfuckingsPlace(Config.Locations['spawn'])
                                if O < 5 then
                                    jobStarted = false
                                    AJFW.Functions.Notify('there is a vehicle at the spot', 'error', 3000)
                                else
                                    startJob()
                                end
                            end
                        else
                            if showText then
                                HideTextUI(1)
                                showText = false
                            end
                        end
                    end
                    if blips['hq'] == nil or blips['hq'] == 0 then
                        blips['hq'] = AddBlipForCoord(start)
                        SetBlipSprite(blips['hq'], Config.BlipSetting['hq'].sprite)
                        SetBlipDisplay(blips['hq'], Config.BlipSetting['hq'].display)
                        SetBlipScale(blips['hq'], Config.BlipSetting['hq'].scale)
                        SetBlipColour(blips['hq'], Config.BlipSetting['hq'].color)
                        SetBlipAsShortRange(blips['hq'], true)
                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentString(Config.BlipSetting['hq'].text)
                        EndTextCommandSetBlipName(blips['hq'])
                    end
                else
                    if blips['hq'] ~= nil or blips['hq'] ~= 0 then
                        RemoveBlip(blips['hq'])
                        blips['hq'] = nil
                    end
                end
            else
                sleep = 1000
                local ped = PlayerPedId()
                local pos = GetEntityCoords(ped)
                local start = Config.Locations['start']
                local dist = #(pos - start)
                if dist <= 10 then
                    sleep = 5
                    if dist <= 1 then
                        if not showText then
                            DrawText3D('ui', nil, nil, nil, '[E] To Start', 1)
                            showText = true
                        end
                        if IsControlJustPressed(0, 38) and not jobStarted then
                            jobStarted = true
                            local O = GetClosestVehicleNearThisMotherfuckingsPlace(Config.Locations['spawn'])
                            if O < 5 then
                                jobStarted = false
                                AJFW.Functions.Notify('there is a vehicle at the spot', 'error', 3000)
                            else
                                startJob()
                            end
                        end
                    else
                        if showText then
                            HideTextUI(1)
                            showText = false
                        end
                    end
                end
                -- if blips['hq'] == nil or blips['hq'] == 0 then
                --     blips['hq'] = AddBlipForCoord(start)
                --     SetBlipSprite(blips['hq'], Config.BlipSetting['hq'].sprite)
                --     SetBlipDisplay(blips['hq'], Config.BlipSetting['hq'].display)
                --     SetBlipScale(blips['hq'], Config.BlipSetting['hq'].scale)
                --     SetBlipColour(blips['hq'], Config.BlipSetting['hq'].color)
                --     SetBlipAsShortRange(blips['hq'], true)
                --     BeginTextCommandSetBlipName("STRING")
                --     AddTextComponentString(Config.BlipSetting['hq'].text)
                --     EndTextCommandSetBlipName(blips['hq'])
                -- end
                if arrived then
                    if not showText2 then
                        DrawText3D('ui', nil, nil, nil, '[DELETE] To skip dumpster', 2, 60)
                        showText2 = true
                    end
                    sleep = 5
                    if IsControlJustPressed(0, 178) and not Timeout then
                        Timeout = true
                        -- print('ok')
                        SetEntityAsMissionEntity(xx, true, true)
                        Wait(100)
                        if DoesEntityExist(xx) and IsEntityAMissionEntity(xx) then
                            SetEntityAsNoLongerNeeded(xx)
                        end
                        SetBlipRoute(blips['dump'], false)
                        RemoveBlip(blips['dump'])
                        blips['dump'] = nil
                        TriggerEvent('garbage:client:skip',zz,yy)
                        -- print('ok2')
                    end
                else
                    if showText2 then
                        HideTextUI(2)
                        showText2 = false
                    end
                end
                if Timeout then
                    if timeouts >= 0 then
                        timeouts = timeouts - 10
                    else
                        Timeout = false
                        timeouts = 10000
                    end
                end
                -- print(timeouts)
            end
        end
        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    while true do
        sleep = 2500
        if LocalPlayer.state['isLoggedIn'] then
            if Config.JobRequired then
                if PlayerJob.name == 'garbage' then
                    sleep = 1000
                    if showRadar then
                        sleep = 3
                        DisplayRadar(true)
                    end
                end
            else
                sleep = 1000
                if showRadar then
                    sleep = 3
                    DisplayRadar(true)
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)