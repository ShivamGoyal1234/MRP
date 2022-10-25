local MRFW = exports['mrfw']:GetCoreObject()
local camZPlus1 = 1500
local camZPlus2 = 50
local pointCamCoords = 75
local pointCamCoords2 = 0
local cam1Time = 500
local cam2Time = 1000
local choosingSpawn = false
local cam, cam2 = nil, nil

-- Functions

local function SetDisplay(bool)
    choosingSpawn = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool
    })
end

-- Events

RegisterNetEvent('mr-spawn:client:openUI', function(value)
    SetEntityVisible(PlayerPedId(), false)
    DoScreenFadeOut(1000)
    -- Wait(1000)
    -- DoScreenFadeIn(250)
    MRFW.Functions.GetPlayerData(function(PlayerData)
        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", PlayerData.position.x, PlayerData.position.y, PlayerData.position.z + camZPlus1, -85.00, 0.00, 0.00, 100.00, false, 0)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 1, true, true)
    end)
    Wait(500)
    SetDisplay(value)
end)

RegisterNetEvent('mr-houses:client:setHouseConfig', function(houseConfig)
    Config.Houses = houseConfig
end)

RegisterNetEvent('mr-spawn:client:setupSpawns', function(cData, new, apps)
    if not new then
        MRFW.Functions.TriggerCallback('mr-spawn:server:getOwnedHouses', function(houses)
            local myHouses = {}
            if houses ~= nil then
                for i = 1, (#houses), 1 do
                    myHouses[#myHouses+1] = {
                        house = houses[i].house,
                        label = Config.Houses[houses[i].house].adress,
                    }
                end
            end
            print(cData.job.name)
            Wait(500)
            if cData.job.name == 'police' then
                SendNUIMessage({
                    action = "setupLocations",
                    locations = QB.SpawnsPolice,
                    houses = myHouses,
                })
            elseif cData.job.name == 'doctor' then
                SendNUIMessage({
                    action = "setupLocations",
                    locations = QB.SpawnsDoctor,
                    houses = myHouses,
                })
            elseif cData.job.name == 'pdm' then
                SendNUIMessage({
                    action = "setupLocations",
                    locations = QB.SpawnsPDM,
                    houses = myHouses,
                })
            elseif cData.job.name == 'mechanic' then
                SendNUIMessage({
                    action = "setupLocations",
                    locations = QB.SpawnsMechanic,
                    houses = myHouses,
                })
            elseif cData.job.name == 'bennys' then
                SendNUIMessage({
                    action = "setupLocations",
                    locations = QB.SpawnsBennys,
                    houses = myHouses,
                })
            elseif cData.job.name == 'government' then
                SendNUIMessage({
                    action = "setupLocations",
                    locations = QB.SpawnsGovernment,
                    houses = myHouses,
                })
            elseif cData.job.name == 'doj' then
                SendNUIMessage({
                    action = "setupLocations",
                    locations = QB.SpawnsDOJ,
                    houses = myHouses,
                })
            elseif cData.job.name == 'edm' then
                SendNUIMessage({
                    action = "setupLocations",
                    locations = QB.SpawnsEDM,
                    houses = myHouses,
                })
            else
                SendNUIMessage({
                    action = "setupLocations",
                    locations = QB.SpawnsPlayers,
                    houses = myHouses,
                })
            end
        end, cData.citizenid)
    elseif new then
        SendNUIMessage({
            action = "setupAppartements",
            locations = apps,
        })
    end
end)

-- NUI Callbacks

RegisterNUICallback("exit", function(data)
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "ui",
        status = false
    })
    choosingSpawn = false
end)

local cam = nil
local cam2 = nil

local function SetCam(campos)
    cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", campos.x, campos.y, campos.z + camZPlus1, 300.00,0.00,0.00, 110.00, false, 0)
    PointCamAtCoord(cam2, campos.x, campos.y, campos.z + pointCamCoords)
    SetCamActiveWithInterp(cam2, cam, cam1Time, true, true)
    if DoesCamExist(cam) then
        DestroyCam(cam, true)
    end
    Wait(cam1Time)

    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", campos.x, campos.y, campos.z + camZPlus2, 300.00,0.00,0.00, 110.00, false, 0)
    PointCamAtCoord(cam, campos.x, campos.y, campos.z + pointCamCoords2)
    SetCamActiveWithInterp(cam, cam2, cam2Time, true, true)
    SetEntityCoords(PlayerPedId(), campos.x, campos.y, campos.z)
end

RegisterNUICallback('setCam', function(data)
    local location = tostring(data.posname)
    local type = tostring(data.type)

    -- DoScreenFadeOut(200)
    -- Wait(500)
    -- DoScreenFadeIn(200)

    if DoesCamExist(cam) then
        DestroyCam(cam, true)
    end

    if DoesCamExist(cam2) then
        DestroyCam(cam2, true)
    end

    if type == "current" then
        MRFW.Functions.GetPlayerData(function(PlayerData)
            SetCam(PlayerData.position)
        end)
    elseif type == "house" then
        SetCam(Config.Houses[location].coords.enter)
    elseif type == "normal" then
        SetCam(QB.SpawnsDefault[location].coords)
    elseif type == "appartment" then
        SetCam(Apartments.Locations[location].coords.enter)
    end
end)

RegisterNUICallback('chooseAppa', function(data)
    local ped = PlayerPedId()
    local appaYeet = data.appType
    SetDisplay(false)
    DoScreenFadeOut(500)
    Wait(5000)
    TriggerServerEvent("apartments:server:CreateApartment", appaYeet, Apartments.Locations[appaYeet].label)
    TriggerServerEvent('MRFW:Server:OnPlayerLoaded')
    TriggerEvent('MRFW:Client:OnPlayerLoaded')
    FreezeEntityPosition(ped, false)
    RenderScriptCams(false, true, 500, true, true)
    SetCamActive(cam, false)
    DestroyCam(cam, true)
    SetCamActive(cam2, false)
    DestroyCam(cam2, true)
    SetEntityVisible(ped, true)
end)

local function PreSpawnPlayer()
    SetDisplay(false)
    DoScreenFadeOut(500)
    Wait(2000)
end

local function PostSpawnPlayer(ped)
    FreezeEntityPosition(ped, false)
    RenderScriptCams(false, true, 500, true, true)
    SetCamActive(cam, false)
    DestroyCam(cam, true)
    SetCamActive(cam2, false)
    DestroyCam(cam2, true)
    SetEntityVisible(PlayerPedId(), true)
    Wait(500)
    DoScreenFadeIn(1000)
end

RegisterNUICallback('spawnplayer', function(data)
    local location = tostring(data.spawnloc)
    local type = tostring(data.typeLoc)
    local ped = PlayerPedId()
    local PlayerData = MRFW.Functions.GetPlayerData()
    local insideMeta = PlayerData.metadata["inside"]

    if type == "current" then
        PreSpawnPlayer()
        MRFW.Functions.GetPlayerData(function(PlayerData)
            SetEntityCoords(PlayerPedId(), PlayerData.position.x, PlayerData.position.y, PlayerData.position.z)
            SetEntityHeading(PlayerPedId(), PlayerData.position.a)
            FreezeEntityPosition(PlayerPedId(), false)
        end)

        if insideMeta.house ~= nil then
            local houseId = insideMeta.house
            TriggerEvent('mr-houses:client:LastLocationHouse', houseId)
        elseif insideMeta.apartment.apartmentType ~= nil or insideMeta.apartment.apartmentId ~= nil then
            local apartmentType = insideMeta.apartment.apartmentType
            local apartmentId = insideMeta.apartment.apartmentId
            TriggerEvent('mr-apartments:client:LastLocationHouse', apartmentType, apartmentId)
        end
        TriggerServerEvent('MRFW:Server:OnPlayerLoaded')
        TriggerEvent('MRFW:Client:OnPlayerLoaded')
        PostSpawnPlayer()
    elseif type == "house" then
        PreSpawnPlayer()
        TriggerEvent('mr-houses:client:enterOwnedHouse', location)
        TriggerServerEvent('MRFW:Server:OnPlayerLoaded')
        TriggerEvent('MRFW:Client:OnPlayerLoaded')
        TriggerServerEvent('mr-houses:server:SetInsideMeta', 0, false)
        TriggerServerEvent('mr-apartments:server:SetInsideMeta', 0, 0, false)
        PostSpawnPlayer()
    elseif type == "normal" then
        local pos = QB.SpawnsDefault[location].coords
        PreSpawnPlayer()
        SetEntityCoords(ped, pos.x, pos.y, pos.z)
        TriggerServerEvent('MRFW:Server:OnPlayerLoaded')
        TriggerEvent('MRFW:Client:OnPlayerLoaded')
        TriggerServerEvent('mr-houses:server:SetInsideMeta', 0, false)
        TriggerServerEvent('mr-apartments:server:SetInsideMeta', 0, 0, false)
        Wait(500)
        SetEntityCoords(ped, pos.x, pos.y, pos.z)
        SetEntityHeading(ped, pos.w)
        PostSpawnPlayer()
    end
end)

-- Threads

CreateThread(function()
    while true do
        Wait(5)
        if choosingSpawn then
            DisableAllControlActions(0)
        else
            Wait(1000)
        end
    end
end)
