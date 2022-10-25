local MRFW = exports['mrfw']:GetCoreObject()
local inside = false
local currentHouse = nil
local closestHouse
local inRange
local lockpicking = false
local houseObj = {}
local POIOffsets = nil
local usingAdvanced = false
local requiredItemsShowed = false
local requiredItems = {}
local CurrentCops = 0
local disturbance = 0
local PlayerData = {}

RegisterNetEvent('MRFW:Client:OnPlayerUnload', function()
    TriggerServerEvent('MRFW:Server:playtime:leave', PlayerData.citizenid)
    PlayerData = {}
end)

RegisterNetEvent('MRFW:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

RegisterNetEvent('MRFW:Client:OnPlayerLoaded', function()
    MRFW.Functions.TriggerCallback('mr-houserobbery:server:GetHouseConfig', function(HouseConfig)
        Config.Houses = HouseConfig
    end)
    PlayerData = MRFW.Functions.GetPlayerData()
    TriggerServerEvent('MRFW:Server:playtime:join', PlayerData.citizenid)
end)

function DrawText3Ds(x, y, z, text)
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

local police_close_house = nil

CreateThread(function()
    while true do
        sleep = 2500
        police_close_house = nil
        if MRFW ~= nil and PlayerData.job ~= nil then
            sleep = 2000
            if PlayerData.job.name == 'police' and MRFW.Functions.GetPlayerData().job.onduty then
                sleep = 1000
                local PlayerPos = GetEntityCoords(PlayerPedId())
                for k,v in pairs(Config.Houses) do
                    local dist = #(PlayerPos - vector3(Config.Houses[k]["coords"]["x"], Config.Houses[k]["coords"]["y"], Config.Houses[k]["coords"]["z"]))
                    if dist <= 1.5 then
                        police_close_house = k
                    end
                end
            end
        end
        Wait(sleep)
    end
end)

RegisterNetEvent('jacob:client:reset:door:pd', function()
    if PlayerData.job.name == 'police' and MRFW.Functions.GetPlayerData().job.onduty then
        TriggerServerEvent('jacob:server:reset:door:pd', police_close_house)
    else
        MRFW.Functions.Notify('You can\'t use this command', 'error', 3000)
    end
end)

CreateThread(function()
    Wait(500)
    requiredItems = {
        [1] = {name = MRFW.Shared.Items["lockpick"]["name"], image = MRFW.Shared.Items["lockpick"]["image"]},
        [2] = {name = MRFW.Shared.Items["screwdriverset"]["name"], image = MRFW.Shared.Items["screwdriverset"]["image"]},
    }
    while true do
        inRange = false
        
        closestHouse = nil
        if MRFW ~= nil then
            -- local hours = GetClockHours()
            -- if hours >= Config.MinimumTime or hours <= Config.MaximumTime then
                if not inside then
                    local PlayerPed = PlayerPedId()
                    local PlayerPos = GetEntityCoords(PlayerPed)
                    for k, v in pairs(Config.Houses) do
                        dist = #(PlayerPos - vector3(Config.Houses[k]["coords"]["x"], Config.Houses[k]["coords"]["y"], Config.Houses[k]["coords"]["z"]))
                        if dist <= 1.5 then
                            closestHouse = k
                            inRange = true
                            if CurrentCops >= Config.MinimumHouseRobberyPolice then
                                if Config.Houses[k]["opened"] then
                                    DrawText3Ds(Config.Houses[k]["coords"]["x"], Config.Houses[k]["coords"]["y"], Config.Houses[k]["coords"]["z"], '~g~E~w~ - To Enter')
                                    if IsControlJustPressed(0, 38) then
                                        enterRobberyHouse(k)
                                    end
                                else
                                    if not requiredItemsShowed then
                                        requiredItemsShowed = true
                                        -- TriggerEvent('inventory:client:requiredItems', requiredItems, true)
                                    end
                                end
                            end
                        end
                    end
                end
            -- end
            if inside then Wait(1000) end
            if not inRange then
                if requiredItemsShowed then
                    requiredItemsShowed = false
                    -- TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                end
                Wait(1000)
            end
        end
        Wait(5)
    end
end)

CreateThread(function()
    while true do
        

        if inside then
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            if #(pos - vector3(Config.Houses[currentHouse]["coords"]["x"] + POIOffsets.exit.x, Config.Houses[currentHouse]["coords"]["y"] + POIOffsets.exit.y, Config.Houses[currentHouse]["coords"]["z"] - Config.MinZOffset + POIOffsets.exit.z)) < 1.5 then
                DrawText3Ds(Config.Houses[currentHouse]["coords"]["x"] + POIOffsets.exit.x, Config.Houses[currentHouse]["coords"]["y"] + POIOffsets.exit.y, Config.Houses[currentHouse]["coords"]["z"] - Config.MinZOffset + POIOffsets.exit.z, '~g~E~w~ - To leave home')
                if IsControlJustPressed(0, 38) then
                    leaveRobberyHouse(currentHouse)
                end
            end

            for k, v in pairs(Config.Houses[currentHouse]["furniture"]) do
                if #(pos - vector3(Config.Houses[currentHouse]["coords"]["x"] + Config.Houses[currentHouse]["furniture"][k]["coords"]["x"], Config.Houses[currentHouse]["coords"]["y"] + Config.Houses[currentHouse]["furniture"][k]["coords"]["y"], Config.Houses[currentHouse]["coords"]["z"] + Config.Houses[currentHouse]["furniture"][k]["coords"]["z"] - Config.MinZOffset)) < 1 then
                    if not Config.Houses[currentHouse]["furniture"][k]["searched"] then
                        if not Config.Houses[currentHouse]["furniture"][k]["isBusy"] then
                            DrawText3Ds(Config.Houses[currentHouse]["coords"]["x"] + Config.Houses[currentHouse]["furniture"][k]["coords"]["x"], Config.Houses[currentHouse]["coords"]["y"] + Config.Houses[currentHouse]["furniture"][k]["coords"]["y"], Config.Houses[currentHouse]["coords"]["z"] + Config.Houses[currentHouse]["furniture"][k]["coords"]["z"] - Config.MinZOffset, '~g~E~w~ - '..Config.Houses[currentHouse]["furniture"][k]["text"]..currentHouse)
                            -- if not IsLockpicking then
                                if IsControlJustReleased(0, 38) then
                                    
                                    searchCabin(k)
                                end
                            -- end
                        else
                            DrawText3Ds(Config.Houses[currentHouse]["coords"]["x"] + Config.Houses[currentHouse]["furniture"][k]["coords"]["x"], Config.Houses[currentHouse]["coords"]["y"] + Config.Houses[currentHouse]["furniture"][k]["coords"]["y"], Config.Houses[currentHouse]["coords"]["z"] + Config.Houses[currentHouse]["furniture"][k]["coords"]["z"] - Config.MinZOffset, 'Searching..')
                        end
                    else
                        DrawText3Ds(Config.Houses[currentHouse]["coords"]["x"] + Config.Houses[currentHouse]["furniture"][k]["coords"]["x"], Config.Houses[currentHouse]["coords"]["y"] + Config.Houses[currentHouse]["furniture"][k]["coords"]["y"], Config.Houses[currentHouse]["coords"]["z"] + Config.Houses[currentHouse]["furniture"][k]["coords"]["z"] - Config.MinZOffset, 'Empty..')
                    end
                end
            end

            TriggerEvent("robbery:guiupdate", math.ceil(disturbance))

            if GetEntitySpeed(PlayerPedId()) > 1.4 then
                local distance, pedcount = closestNPC()
                local alteredsound = 0.2
                if pedcount > 0 then
                    alteredsound = alteredsound + (pedcount / 100)
                    local distancealter = (8.0 - distance) / 100
                    alteredsound = alteredsound + distancealter
                end

                disturbance = disturbance + alteredsound
                if GetEntitySpeed(PlayerPedId()) > 2.0 then
                    disturbance = disturbance + alteredsound
                end

                if GetEntitySpeed(PlayerPedId()) > 3.0 then
                    disturbance = disturbance + alteredsound
                end
            else
                disturbance = disturbance - 0.04
                if disturbance < 0 then
                    disturbance = 0
                end
            end

            if disturbance > 85 then
                if not calledin then
                    local num = 150 - disturbance
                    -- print(num..' 1')
                    -- print(math.ceil(num)..' 2')
                    num = math.random(math.ceil(num))
                    -- print(num..' 3')
                    local fuckup = math.ceil(num)
                    -- print(fuckup..' 4')

                    if fuckup == 2 and GetEntitySpeed(PlayerPedId()) > 0.8 then
                        calledin = true
                        PoliceCall()
                    end
                end
            end
            if IsPedShooting(PlayerPedId()) then
                disturbance = 90
                PoliceCall()
            end
        end

        if not inside then 
            Wait(5000)
        end
        Wait(5)
    end
end)

function enterRobberyHouse(house)
    local hours = GetClockHours()
    if hours >= Config.MinimumTime or hours <= Config.MaximumTime then
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.25)
        openHouseAnim()
        Wait(250)
        local coords = { x = Config.Houses[house]["coords"]["x"], y = Config.Houses[house]["coords"]["y"], z= Config.Houses[house]["coords"]["z"] - Config.MinZOffset}
        if Config.Houses[house]["tier"] == 1 then
            data = exports['mr-interior']:CreateTier1HouseFurnished(coords)
        end
        Wait(100)
        houseObj = data[1]
        POIOffsets = data[2]
        inside = true
        currentHouse = house
        Wait(500)
        SetRainFxIntensity(0.0)
        TriggerEvent('mr-weathersync:client:EnableSync')
        Citizen.Wait(100)
        SetWeatherTypePersist('EXTRASUNNY')
        SetWeatherTypeNow('EXTRASUNNY')
        SetWeatherTypeNowPersist('EXTRASUNNY')
        NetworkOverrideClockTime(23, 0, 0)
    end
end

function leaveRobberyHouse(house)
    local ped = PlayerPedId()
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.25)
    openHouseAnim()
    Wait(250)
    DoScreenFadeOut(250)
    Wait(500)
    exports['mr-interior']:DespawnInterior(houseObj, function()
        TriggerEvent('mr-weathersync:client:EnableSync')
        Wait(250)
        DoScreenFadeIn(250)
        SetEntityCoords(ped, Config.Houses[house]["coords"]["x"], Config.Houses[house]["coords"]["y"], Config.Houses[house]["coords"]["z"] + 0.5)
        SetEntityHeading(ped, Config.Houses[house]["coords"]["h"])
        inside = false
        currentHouse = nil
    end)
    TriggerEvent("robbery:guiclose")
    disturbance = 0
end

RegisterNetEvent('mr-houserobbery:client:ResetHouseState', function(house)
    Config.Houses[house]["opened"] = false
    for k, v in pairs(Config.Houses[house]["furniture"]) do
        v["searched"] = false
    end
end)

RegisterNetEvent('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

RegisterNetEvent('mr-houserobbery:client:enterHouse', function(house)
    enterRobberyHouse(house)
end)

function openHouseAnim()
    loadAnimDict("anim@heists@keycard@") 
    TaskPlayAnim( PlayerPedId(), "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0 )
    Wait(400)
    ClearPedTasks(PlayerPedId())
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

RegisterNetEvent('lockpicks:UseLockpick', function(isAdvanced, quality)
    local hours = GetClockHours()
    if hours >= Config.MinimumTime or hours <= Config.MaximumTime then
        usingAdvanced = isAdvanced
        if usingAdvanced then
            MRFW.Functions.TriggerCallback('MRFW:HasItemV2', function(has, info)
                if closestHouse ~= nil then
                    if has then
                        if CurrentCops >= Config.MinimumHouseRobberyPolice then
                            if not Config.Houses[closestHouse]["opened"] then
                                PoliceCall()
                                if itemquality == nil then
                                    itemquality = quality
                                end
                                local infos = {}
                                infos.uses = info.info.uses - 1
                                TriggerServerEvent('MRFW:Server:RemoveItem', info.name, info.amount, info.slot)
                                TriggerServerEvent("MRFW:Server:AddItem", info.name, info.amount, info.slot, infos)
                                -- TriggerServerEvent('Perform:Decay:item', info.name, info.slot, 20) -- item name, item slot, amount to decay
                                TriggerEvent('mr-lockpick:client:openLockpick', lockpickFinish)
                                if math.random(1, 100) <= 85 and not IsWearingHandshoes() then
                                    local pos = GetEntityCoords(PlayerPedId())
                                    TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
                                end
                            else
                                MRFW.Functions.Notify('The door is already open..', 'error', 3500)
                            end
                        else
                            MRFW.Functions.Notify('Not enough Police..', 'error', 3500)
                        end
                    else
                        MRFW.Functions.Notify('It looks like you are missing something...', 'error', 3500)
                    end
                end
            end, 'screwdriverset')
        else
            MRFW.Functions.TriggerCallback('MRFW:HasItemV2', function(has, info)
                if closestHouse ~= nil then
                    if has then
                        if info.info.uses >= 1 then
                            if CurrentCops >= Config.MinimumHouseRobberyPolice then
                                if not Config.Houses[closestHouse]["opened"] then
                                    PoliceCall()
                                    if itemquality == nil then
                                        itemquality = quality
                                    end
                                    local infos = {}
                                    infos.uses = info.info.uses - 1
                                    TriggerServerEvent('MRFW:Server:RemoveItem', info.name, info.amount, info.slot)
                                    TriggerServerEvent("MRFW:Server:AddItem", info.name, info.amount, info.slot, infos)
                                    -- TriggerServerEvent('Perform:Decay:item', info.name, info.slot, 20) -- item name, item slot, amount to decay
                                    TriggerEvent('mr-lockpick:client:openLockpick', lockpickFinish)
                                    if math.random(1, 100) <= 85 and not IsWearingHandshoes() then
                                        local pos = GetEntityCoords(PlayerPedId())
                                        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
                                    end
                                else
                                    MRFW.Functions.Notify('The door is already open..', 'error', 3500)
                                end
                            else
                                MRFW.Functions.Notify('Not enough Police..', 'error', 3500)
                            end
                        else
                            MRFW.Functions.Notify('Tool kit broken', 'error', 3500)
                        end
                    else
                        MRFW.Functions.Notify('It looks like you are missing something...', 'error', 3500)
                    end
                end
            end, 'screwdriverset')
        end
    end
end)

function PoliceCall()
    local pos = GetEntityCoords(PlayerPedId())
    local chance = 75
    if GetClockHours() >= 1 and GetClockHours() <= 6 then
        chance = 25
    end
    if math.random(1, 100) <= chance then
        local closestPed = GetNearbyPed()
        if closestPed ~= nil then
            local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
            local streetLabel = GetStreetNameFromHashKey(s1)
            local street2 = GetStreetNameFromHashKey(s2)
            if street2 ~= nil and street2 ~= "" then 
                streetLabel = streetLabel .. " " .. street2
            end
            local gender = "Man"
            if MRFW.Functions.GetPlayerData().charinfo.gender == 1 then
                gender = "Woman"
            end
            local msg = "Attempted burglary into a house by one " .. gender .." at " .. streetLabel
            TriggerServerEvent("police:server:HouseRobberyCall", pos, msg, gender, streetLabel)
        end
    end
end

function GetNearbyPed()
	local retval = nil
	local PlayerPeds = {}
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        PlayerPeds[#PlayerPeds+1] = ped
    end
    local player = PlayerPedId()
    local coords = GetEntityCoords(player)
	local closestPed, closestDistance = MRFW.Functions.GetClosestPed(coords, PlayerPeds)
	if not IsEntityDead(closestPed) and closestDistance < 50.0 then
		retval = closestPed
	end
	return retval
end
function lockpickFinish(success)
    if success then
        if usingAdvanced then
            local infos = {}
            infos.uses = itemquality.info.uses - 1
            TriggerServerEvent('MRFW:Server:RemoveItem', itemquality.name, itemquality.amount, itemquality.slot)
            TriggerServerEvent("MRFW:Server:AddItem", itemquality.name, itemquality.amount, itemquality.slot, infos)
            -- TriggerServerEvent('Perform:Decay:item', itemquality.name, itemquality.slot, 2)
        else
            local infos = {}
            infos.uses = itemquality.info.uses - 1
            TriggerServerEvent('MRFW:Server:RemoveItem', itemquality.name, itemquality.amount, itemquality.slot)
            TriggerServerEvent("MRFW:Server:AddItem", itemquality.name, itemquality.amount, itemquality.slot, infos)
            -- TriggerServerEvent('Perform:Decay:item', itemquality.name, itemquality.slot, 5)
        end
        itemquality = nil
        TriggerServerEvent('mr-houserobbery:server:enterHouse', closestHouse)
        MRFW.Functions.Notify('It worked!', 'success', 2500)
    else
        if usingAdvanced then
            local infos = {}
            infos.uses = itemquality.info.uses - 1
            TriggerServerEvent('MRFW:Server:RemoveItem', itemquality.name, itemquality.amount, itemquality.slot)
            TriggerServerEvent("MRFW:Server:AddItem", itemquality.name, itemquality.amount, itemquality.slot, infos)
            -- TriggerServerEvent('Perform:Decay:item', itemquality.name, itemquality.slot, math.random(2, 5))
        else
            local infos = {}
            infos.uses = itemquality.info.uses - 1
            TriggerServerEvent('MRFW:Server:RemoveItem', itemquality.name, itemquality.amount, itemquality.slot)
            TriggerServerEvent("MRFW:Server:AddItem", itemquality.name, itemquality.amount, itemquality.slot, infos)
            -- TriggerServerEvent('Perform:Decay:item', itemquality.name, itemquality.slot, math.random(5, 10))
        end
        itemquality = nil
        MRFW.Functions.Notify('It did not work..', 'error', 2500)
    end
end

RegisterNetEvent('mr-houserobbery:client:setHouseState', function(house, state)
    Config.Houses[house]["opened"] = state
end)

local openingDoor = false
local SucceededAttempts = 0
local NeededAttempts = 4

function searchCabin(cabin)
    local ped = PlayerPedId()

    local Skillbar = exports['mr-skillbar']:GetSkillbarObject()
    if math.random(1, 100) <= 85 and not IsWearingHandshoes() then
        local pos = GetEntityCoords(PlayerPedId())
        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
    end
    local lockpickTime = math.random(15000, 30000)
    LockpickDoorAnim(lockpickTime)
    TriggerServerEvent('mr-houserobbery:server:SetBusyState', cabin, currentHouse, true)
    FreezeEntityPosition(ped, true)
    TriggerEvent('close:inventory:bug')
    MRFW.Functions.Progressbar("search_cabin", "Searching the box..", lockpickTime, false, true, {
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
        TriggerServerEvent('mr-houserobbery:server:searchCabin', cabin, currentHouse)
        Config.Houses[currentHouse]["furniture"][cabin]["searched"] = true
        TriggerServerEvent('mr-houserobbery:server:SetBusyState', cabin, currentHouse, false)
        FreezeEntityPosition(ped, false)
    end, function() -- Cancel
        openingDoor = false
        ClearPedTasks(PlayerPedId())
        TriggerServerEvent('mr-houserobbery:server:SetBusyState', cabin, currentHouse, false)
        MRFW.Functions.Notify("Canceled..", "error")
        FreezeEntityPosition(ped, false)
    end)
    Citizen.CreateThread(function()
        if disturbance > 20 then
            TriggerServerEvent('hud:server:GainStress', math.random(5, 10))
            Citizen.Wait(5000)
        end
    end)
end

function LockpickDoorAnim(time)
    time = time / 1000
    loadAnimDict("veh@break_in@0h@p_m_one@")
    TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds" ,3.0, 3.0, -1, 16, 0, false, false, false)
    openingDoor = true
    Citizen.CreateThread(function()
        while openingDoor do
            TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
            Citizen.Wait(1000) disturbance = disturbance + 3.65
            time = time - 1
            if time <= 0 then
                openingDoor = false
                StopAnimTask(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0)
            end
        end
    end)
end

RegisterNetEvent('mr-houserobbery:client:setCabinState', function(house, cabin, state)
    Config.Houses[house]["furniture"][cabin]["searched"] = state
end)

RegisterNetEvent('mr-houserobbery:client:SetBusyState', function(cabin, house, bool)
    Config.Houses[house]["furniture"][cabin]["isBusy"] = bool
end)

function IsWearingHandshoes()
    local armIndex = GetPedDrawableVariation(PlayerPedId(), 3)
    local model = GetEntityModel(PlayerPedId())
    local retval = true
    if model == GetHashKey("mp_m_freemode_01") then
        if MRFW.Shared.MaleNoGloves[armIndex] ~= nil and MRFW.Shared.MaleNoGloves[armIndex] then
            retval = false
        end
    else
        if MRFW.Shared.FemaleNoGloves[armIndex] ~= nil and MRFW.Shared.FemaleNoGloves[armIndex] then
            retval = false
        end
    end
    return retval
end

RegisterCommand('gethroffset', function()
    local coords = GetEntityCoords(PlayerPedId())
    local houseCoords = vector3(
        Config.Houses[currentHouse]["coords"]["x"],
        Config.Houses[currentHouse]["coords"]["y"],
        Config.Houses[currentHouse]["coords"]["z"] - Config.MinZOffset
    )
    if inside then
        local xdist = coords.x - houseCoords.x
        local ydist = coords.y - houseCoords.y
        local zdist = coords.z - houseCoords.z
        -- print('X: '..xdist)
        -- print('Y: '..ydist)
        -- print('Z: '..zdist)
    end
end)

-- New Functions

function closestNPC()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local handle, ped = FindFirstPed()
    local success
    local rped = nil
    local distanceFrom = 999.0
    local pedcount = 0
    repeat
        local pos = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(playerCoords, pos, true)
        if distance < 25.0 and ped ~= PlayerPedId() and not IsPedAPlayer(ped) then
            pedcount = pedcount + 1
            if (distance < distanceFrom) then
                distanceFrom = distance
                rped = ped
            end
        end
        success, ped = FindNextPed(handle)
    until not success
    EndFindPed(handle)
    return distanceFrom, pedcount
end
