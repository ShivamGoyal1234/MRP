if Config.Framework == "NEW" then
    MRFW = exports['mrfw']:GetCoreObject()
elseif Config.Framework == "OLD" then 
        local MRFW = nil
        Citizen.CreateThread(function()
        while MRFW == nil do 
            TriggerEvent("MRFW:GetObject", function(obj)MRFW = obj end) 
            Citizen.Wait(200) 
        end 
    end) 
else
    print("The Framework '", Config.Framework, "' is not support, please change in config.lua")
end

local BlacklistVehicles = { -- Used from mr-vehicle failure <3
'ninef',
'adder',
'vagner',
't20',
'infernus',
'zentorno',
'reaper',
'comet2',
'comet3',
'jester',
'jester2',
'cheetah',
'cheetah2',
'prototipo',
'turismor',
'pfister811',
'ardent',
'nero',
'nero2',
'tempesta',
'vacca',
'bullet',
'osiris',
'entityxf',
'turismo2',
'fmj',
're7b',
'tyrus',
'italigtb',
'penetrator',
'monroe',
'ninef2',
'stingergt',
'surfer',
'surfer2',
'comet3',
}

local PedsRepairs = {}
local Reparar = false

CreateThread(function()
while true do
    Wait(500)
    for k = 1, #Config.PedListRepairs, 1 do
        v = Config.PedListRepairs[k]
        local playerCoords = GetEntityCoords(PlayerPedId())
        local dist = #(playerCoords - v.coords)

            if dist < 50.0 and not PedsRepairs[k] then
                local ped = nearPed(v.model, v.coords, v.heading, v.gender, v.animDict, v.animName, v.scenario)
                PedsRepairs[k] = {ped = ped}
            end

            if dist >= 50.0 and PedsRepairs[k] then
                for i = 255, 0, -51 do
                    Wait(50)
                    SetEntityAlpha(PedsRepairs[k].ped, i, false)
                end
                DeletePed(PedsRepairs[k].ped)
                PedsRepairs[k] = nil
            end
        end
    end
end)

nearPed = function(model, coords, heading, gender, animDict, animName, scenario)
    RequestModel(GetHashKey(model))
    while not HasModelLoaded(GetHashKey(model)) do
        Wait(1)
    end

    if gender == 'male' then
        genderNum = 4
    elseif gender == 'female' then 
        genderNum = 5
    else
        print("No gender provided! Check your configuration!")
    end 

    ped = CreatePed(genderNum, GetHashKey(v.model), coords, heading, false, true)
    SetEntityAlpha(ped, 0, false)

    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    if animDict and animName then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(1)
        end
        TaskPlayAnim(ped, animDict, animName, 8.0, 0, -1, 1, 0, 0, 0)
    end
    if scenario then
        TaskStartScenarioInPlace(ped, scenario, 0, true) 
    end
    for i = 0, 255, 51 do
        Wait(50)
        SetEntityAlpha(ped, i, false)
    end

    return ped
end

--- BLIPS

Citizen.CreateThread(function()
    if Config.BlipRepair.Enable then
        if Config.BlipRepair.OneBlip then
            for _, info in pairs(Config["Repairs"]) do
              info.blip = AddBlipForCoord(info.x, info.y, info.z)
              SetBlipSprite(info.blip, Config.BlipRepair.Sprite)
              SetBlipDisplay(info.blip, 4)
              SetBlipScale(info.blip, Config.BlipRepair.Scale)
              SetBlipColour(info.blip, Config.BlipRepair.Colour)
              SetBlipAsShortRange(info.blip, true)
              BeginTextCommandSetBlipName("STRING")
              AddTextComponentSubstringPlayerName(Config.BlipRepair.Name) 
              EndTextCommandSetBlipName(info.blip)
            end
        end
    else
        return false
    end
end)

Citizen.CreateThread(function ()
    for k, v in pairs(Config["Repairs"]) do
        if Config.Function == 'colour' then
            name = "Min"..k
            exports["mr-eye"]:AddBoxZone(name, vector3(v.x, v.y, v.z), 2, 2, {
                name = name,
                heading = 0,
                debugPoly = false,
            }, {
                options = {
                    {
                        event = "m-Repairs:client:Reparar",
                        icon = Config["Language"]["QBTarget"]["Icon"],
                        label = Config["Language"]["QBTarget"]["Pintar"],
                    },
                },
                distance = 5.0
            })
        elseif Config.Function == 'repair' then
            name = "Min"..k
            exports["mr-eye"]:AddBoxZone(name, vector3(v.x, v.y, v.z), 2, 2, {
                name = name,
                heading = 0,
                debugPoly = false,
            }, {
                options = {
                    {
                        event = "m-Repairs:client:Reparar",
                        icon = Config["Language"]["QBTarget"]["Icon"],
                        label = Config["Language"]["QBTarget"]["Reparar"],
                    },
                },
                distance = 5.0
            })
        elseif Config.Function == 'all' then
            name = "Min"..k
            exports["mr-eye"]:AddBoxZone(name, vector3(v.x, v.y, v.z), 2, 2, {
                name = name,
                heading = 0,
                debugPoly = false,
            }, {
                options = {
                    {
                        event = "m-Repairs:client:Reparar",
                        icon = Config["Language"]["QBTarget"]["Icon"],
                        label = Config["Language"]["QBTarget"]["Falar"],
                    },
                },
                distance = 5.0
            })
        end
    end
end)

function RepararCarro()
    MRFW.Functions.Progressbar("RepararCarro", Config["Language"]["ProgressBars"]["Reparar"], 5000, false, true, {disableMovement = true,disableCarMovement = true,disableMouse = false,disableCombat = true,
    }, {}, {}, {}, function() 
    end)
end

function PintarCarro()
    MRFW.Functions.Progressbar("RepararCarro", Config["Language"]["ProgressBars"]["Pintar"], 5000, false, true, {disableMovement = true,disableCarMovement = true,disableMouse = false,disableCombat = true,
    }, {}, {}, {}, function() 
    end)
end

function RepararPopo(vehicle)
    local playerPed = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    FreezeEntityPosition(vehicle, true)  
    Citizen.Wait(1000)
    SetVehicleFixed(vehicle)
    SetVehicleEngineHealth(vehicle, 1000.0)
    SetVehicleBodyHealth(vehicle, 1000.0)
    SetVehiclePetrolTankHealth(vehicle, 1000.0)
    SetVehicleDirtLevel(vehicle, 0)
    SetVehicleOnGroundProperly(vehicle)  
    FreezeEntityPosition(vehicle, false) 
end

local Cores = {
    000,
    001,
    002,
    003,
    004,
    005,
    006,
    007,
    008,
    009,
    010,
    011,
    012,
    013,
    014,
    015,
    016,
    017,
    018,
    019,
    020,
    021,
    022,
    023,
    024,
    025,
    026,
    027,
    028,
    029,
    030,
    031,
    032,
    033,
    034,
    035,
    036,
    037,
    038,
    039,
    040,
    041,
    042,
    043,
    044,
    045,
    046,
    047,
    048,
    049,
    050,
    051,
    052,
    053,
    054,
    055,
    056,
    057,
    058,
    059,
    060,
    061,
    062,
    063,
    064,
    065,
    066,
    067,
    068,
    069,
    070,
    071,
    072,
    073,
    074,
    075,
    076,
    077,
    078,
    079,
    080,
    081,
    082,
    083,
    084,
    085,
    086,
    087,
    088,
    089,
    090,
    091,
    092,
    093,
    094,
    095,
    096,
    097,
    098,
    099,
    100,
    101,
    102,
    103,
    104,
    105,
    106,
    107,
    108,
    109,
    110,
    111,
    112,
    113,
    114,
    115,
    116,
    117,
    118,
    119,
    120,
    121,
    122,
    123,
    124,
    125,
    126,
    127,
    128,
    129,
    130,
    131,
    132,
    133,
    134,
    135,
    136,
    137,
    138,
    139,
    140,
    141,
    142,
    143,
    144,
    145,
    146,
}

RegisterNetEvent('m-Repairs:client:Reparar')
AddEventHandler("m-Repairs:client:Reparar", function()
    local playerPed = GetPlayerPed(-1)
    local vehicle   = GetVehiclePedIsIn(playerPed, false)
    if Config.Function == 'all' then
        if Config.Payment == 'off' then
            RepararCarro()
            Wait(5000)
            -- SetVehicleColours(vehicle, math.random(1, #Cores),math.random(1, #Cores))
            RepararPopo(vehicle)
        elseif Config.Payment == 'cash' then
            MRFW.Functions.TriggerCallback("m-Repairs:server:VerificarGuita", function(cb)
                if cb.state then
                    RepararCarro()
                    Wait(5000)
                    -- SetVehicleColours(vehicle, math.random(1, #Cores),math.random(1, #Cores))
                    RepararPopo(vehicle)
                end
            end)
        end
    elseif Config.Function == 'colour' then
        if Config.Payment == 'off' then
            PintarCarro()
            Wait(5000)
            -- SetVehicleColours(vehicle, math.random(1, #Cores),math.random(1, #Cores))
        elseif Config.Payment == 'cash' then
            MRFW.Functions.TriggerCallback("m-Repairs:server:VerificarGuita", function(cb)
                if cb.state then
                    PintarCarro()
                    Wait(5000)
                    -- SetVehicleColours(vehicle, math.random(1, #Cores),math.random(1, #Cores))
                end
            end)
        end
    elseif Config.Function == 'repair' then
        if Config.Payment == 'off' then
            RepararCarro()
            Wait(5000)
            -- SetVehicleColours(vehicle, math.random(1, #Cores),math.random(1, #Cores))
        elseif Config.Payment == 'cash' then
            MRFW.Functions.TriggerCallback("m-Repairs:server:VerificarGuita", function(cb)
                if cb.state then
                    RepararCarro()
                    Wait(5000)
                    RepararPopo(vehicle)
                end
            end)
        end
    end
end)