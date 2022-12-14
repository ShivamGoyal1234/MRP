-- Variables
local MRFW = exports['mrfw']:GetCoreObject()
local PlayerData = MRFW.Functions.GetPlayerData() -- Just for resource restart (same as event handler)
local testDriveZone = nil
local vehicleMenu

local testDriveVeh, inTestDrive = 0, false
local ClosestVehicle = 1
local zones = {}

local insideShop = nil
-- Handlers

AddEventHandler('MRFW:Client:OnPlayerLoaded', function()
    PlayerData = MRFW.Functions.GetPlayerData()
    local citizenid = PlayerData.citizenid
    local gameTime = GetGameTimer()
    TriggerServerEvent('mr-vehicleshop:server:addPlayer', citizenid, gameTime)
    TriggerServerEvent('mr-vehicleshop:server:checkFinance')
end)

RegisterNetEvent('MRFW:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

RegisterNetEvent('MRFW:Client:OnPlayerUnload', function()
    local citizenid = PlayerData.citizenid
    TriggerServerEvent('mr-vehicleshop:server:removePlayer', citizenid)
    PlayerData = {}
end)

-- Static Headers

local vehHeaderMenu = {
    {
        header = 'Vehicle Options',
        txt = 'Interact with the current vehicle',
        params = {
            event = 'mr-vehicleshop:client:showVehOptions'
        }
    }
}

local financeMenu = {
    {
        header = 'Financed Vehicles',
        txt = 'Browse your owned vehicles',
        params = {
            event = 'mr-vehicleshop:client:getVehicles'
        }
    }
}

local returnTestDrive = {
    {
        header = 'Finish Test Drive',
        params = {
            event = 'mr-vehicleshop:client:TestDriveReturn'
        }
    }
}

-- Functions

local function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

local function comma_value(amount)
    local formatted = amount
    local k
    while true do
      formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
      if (k==0) then
        break
      end
    end
    return formatted
end

local function getVehName()
    return MRFW.Shared.Vehicles[Config.Shops[insideShop]["ShowroomVehicles"][ClosestVehicle].chosenVehicle]["name"]
end

local function getVehPrice()
    return comma_value(MRFW.Shared.Vehicles[Config.Shops[insideShop]["ShowroomVehicles"][ClosestVehicle].chosenVehicle]["price"])
end

local function getVehBrand()
    return MRFW.Shared.Vehicles[Config.Shops[insideShop]["ShowroomVehicles"][ClosestVehicle].chosenVehicle]["brand"]
end

local function setClosestShowroomVehicle()
    local pos = GetEntityCoords(PlayerPedId(), true)
    local current = nil
    local dist = nil
    local closestShop = insideShop
    for id, veh in pairs(Config.Shops[closestShop]["ShowroomVehicles"]) do
        local dist2 = #(pos - vector3(Config.Shops[closestShop]["ShowroomVehicles"][id].coords.x, Config.Shops[closestShop]["ShowroomVehicles"][id].coords.y, Config.Shops[closestShop]["ShowroomVehicles"][id].coords.z))
        if current ~= nil then
            if dist2 < dist then
                current = id
                dist = dist2
            end
        else
            dist = dist2
            current = id
        end
    end
    if current ~= ClosestVehicle then
        ClosestVehicle = current
    end
end

local function createTestDriveReturn()
    testDriveZone = BoxZone:Create(
        Config.Shops[insideShop]["ReturnLocation"],
        3.0,
        5.0, {
        name="box_zone"
    })

    testDriveZone:onPlayerInOut(function(isPointInside)
        if isPointInside and IsPedInAnyVehicle(PlayerPedId()) then
			SetVehicleForwardSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 0)
            exports['mr-menu']:openMenu(returnTestDrive)
        else
            exports['mr-menu']:closeMenu()
        end
    end)
end

local function startTestDriveTimer(testDriveTime)
    local gameTimer = GetGameTimer()
    CreateThread(function()
        while inTestDrive do
            Wait(1)
            if GetGameTimer() < gameTimer+tonumber(1000*testDriveTime) then
                local secondsLeft = GetGameTimer() - gameTimer
                drawTxt('Test Drive Time Remaining: '..math.ceil(testDriveTime - secondsLeft/1000),4,0.5,0.93,0.50,255,255,255,180)
            end
        end
    end)
end

local function isInShop() 
    for shopName, isInside in pairs(insideZones) do
        if isInside then
            return true
        end
    end

    return false
end

local function createVehZones(shopName) -- This will create an entity zone if config is true that you can use to target and open the vehicle menu
    if not Config.UsingTarget then
        for i = 1, #Config.Shops[shopName]['ShowroomVehicles'] do
            zones[#zones+1] = BoxZone:Create(
                vector3(Config.Shops[shopName]['ShowroomVehicles'][i]['coords'].x,
                Config.Shops[shopName]['ShowroomVehicles'][i]['coords'].y,
                Config.Shops[shopName]['ShowroomVehicles'][i]['coords'].z),
                2.75,
                2.75, {
                name="box_zone",
                debugPoly=false,
            })
        end
        local combo = ComboZone:Create(zones, {name = "vehCombo", debugPoly = false})
        combo:onPlayerInOut(function(isPointInside)
            if isPointInside then
                if (PlayerData.job.name == Config.Shops[insideShop]['Job'] and PlayerData.job.grade.level >= Config.Shops[insideShop]['jobgrade']) or Config.Shops[insideShop]['Job'] == 'none' then
                    exports['mr-menu']:showHeader(vehHeaderMenu)
                end
            else
                exports['mr-menu']:closeMenu()
            end
        end)
    else
        exports['mr-eye']:AddGlobalVehicle({
            options = {
                {
                    type = "client",
                    event = "mr-vehicleshop:client:showVehOptions",
                    icon = "fas fa-car",
                    label = "Vehicle Interaction",
                    canInteract = function(entity)
                        local closestShop = insideShop
                        if (closestShop ~= nil) and (Config.Shops[closestShop]['Job'] == 'none' or (PlayerData.job.name == Config.Shops[closestShop]['Job'] and PlayerData.job.grade.level >= Config.Shops[closestShop]['jobgrade'])) then
                            return true
                        end
                        return false
                    end
                },
            },
            distance = 4.0
        })
    end
end

-- Zones

function createFreeUseShop(shopShape, name)
    local zone = PolyZone:Create(shopShape, {  -- create the zone
        name= name,
        minZ = shopShape.minZ,
        maxZ = shopShape.maxZ
    })
    
    zone:onPlayerInOut(function(isPointInside)
        if isPointInside then
            insideShop = name
            CreateThread(function()
                while insideShop  do
                    setClosestShowroomVehicle()
                    if Config.Shops[name]['allowedFinance'] then
                        vehicleMenu = {
                            {
                                isMenuHeader = true,
                                header = getVehBrand():upper().. ' '..getVehName():upper().. ' - $' ..getVehPrice(),
                            },
                            {
                                header = "Buy Vehicle",
                                txt = 'Purchase currently selected vehicle',
                                params = {
                                    isServer = true,
                                    event = 'mr-vehicleshop:server:buyShowroomVehicle',
                                    args = {
                                        buyVehicle = Config.Shops[insideShop]["ShowroomVehicles"][ClosestVehicle].chosenVehicle,
                                        type2 = Config.Shops[insideShop]['Type2']
                                    }
                                }
                            },
                            {
                                header = 'Finance Vehicle',
                                txt = 'Finance currently selected vehicle',
                                params = {
                                    event = 'mr-vehicleshop:client:openFinance',
                                    args = {
                                        price = getVehPrice(),
                                        buyVehicle = Config.Shops[insideShop]["ShowroomVehicles"][ClosestVehicle].chosenVehicle,
                                        type2 = Config.Shops[insideShop]['Type2']
                                    }
                                }
                            },
                            {
                                header = 'Swap Vehicle',
                                txt = 'Change currently selected vehicle',
                                params = {
                                    event = 'mr-vehicleshop:client:vehCategories',
                                }
                            },
                        }
                        Wait(1000)
                    else
                        vehicleMenu = {
                            {
                                isMenuHeader = true,
                                header = getVehBrand():upper().. ' '..getVehName():upper().. ' - $' ..getVehPrice(),
                            },
                            {
                                header = "Buy Vehicle",
                                txt = 'Purchase currently selected vehicle',
                                params = {
                                    isServer = true,
                                    event = 'mr-vehicleshop:server:buyShowroomVehicle',
                                    args = {
                                        buyVehicle = Config.Shops[insideShop]["ShowroomVehicles"][ClosestVehicle].chosenVehicle,
                                        type2 = Config.Shops[insideShop]['Type2']
                                    }
                                }
                            },
                            {
                                header = 'Swap Vehicle',
                                txt = 'Change currently selected vehicle',
                                params = {
                                    event = 'mr-vehicleshop:client:vehCategories',
                                }
                            },
                        }
                        Wait(1000)
                    end
                end
            end)
        else
            insideShop = nil -- leave the shops zone
            ClosestVehicle = 1
        end
    end)
end

function createManagedShop(shopShape, name, jobName)
    local zone = PolyZone:Create(shopShape, {  -- create the zone
        name= name,
        minZ = shopShape.minZ,
        maxZ = shopShape.maxZ,
        -- debugPoly = true
    })
    
    zone:onPlayerInOut(function(isPointInside)
        if isPointInside then
            insideShop = name
            CreateThread(function()
                while insideShop and PlayerData.job ~= nil and PlayerData.job.name == Config.Shops[name]['Job'] and PlayerData.job.grade.level >= Config.Shops[name]['jobgrade'] do
                    setClosestShowroomVehicle()
                    if Config.Shops[name]['allowedFinance'] then
                        vehicleMenu = {
                            {
                                isMenuHeader = true,
                                header = getVehBrand():upper().. ' '..getVehName():upper().. ' - $' ..getVehPrice(),
                            },
                            {
                                header = "Sell Vehicle",
                                txt = 'Sell vehicle to Player',
                                params = {
                                    event = 'mr-vehicleshop:client:openIdMenu',
                                    args = {
                                        vehicle = Config.Shops[insideShop]["ShowroomVehicles"][ClosestVehicle].chosenVehicle,
                                        type = 'sellVehicle',
                                        type2 = Config.Shops[insideShop]['Type2']

                                    }
                                }
                            },
                            {
                                header = 'Finance Vehicle',
                                txt = 'Finance vehicle to Player',
                                params = {
                                    event = 'mr-vehicleshop:client:openCustomFinance',
                                    args = {
                                        price = getVehPrice(),
                                        vehicle = Config.Shops[insideShop]["ShowroomVehicles"][ClosestVehicle].chosenVehicle,
                                        type2 = Config.Shops[insideShop]['Type2']
                                    }
                                }
                            },
                            {
                                header = 'Swap Vehicle',
                                txt = 'Change currently selected vehicle',
                                params = {
                                    event = 'mr-vehicleshop:client:vehCategories',
                                }
                            },
                        }
                        Wait(1000)
                    else
                        vehicleMenu = {
                            {
                                isMenuHeader = true,
                                header = getVehBrand():upper().. ' '..getVehName():upper().. ' - $' ..getVehPrice(),
                            },
                            {
                                header = "Sell Vehicle",
                                txt = 'Sell vehicle to Player',
                                params = {
                                    event = 'mr-vehicleshop:client:openIdMenu',
                                    args = {
                                        vehicle = Config.Shops[insideShop]["ShowroomVehicles"][ClosestVehicle].chosenVehicle,
                                        type = 'sellVehicle',
                                        type2 = Config.Shops[insideShop]['Type2']
                                    }
                                }
                            },
                            {
                                header = 'Swap Vehicle',
                                txt = 'Change currently selected vehicle',
                                params = {
                                    event = 'mr-vehicleshop:client:vehCategories',
                                }
                            },
                        }
                        Wait(1000)
                    end
                end
            end)
        else
            insideShop = nil -- leave the shops zone
            ClosestVehicle = 1
        end
    end)
end

for name, shop in pairs(Config.Shops) do 
    if shop['Type'] == 'free-use' then
        createFreeUseShop(shop['Zone']['Shape'], name)
    elseif shop['Type'] == 'managed' then
        createManagedShop(shop['Zone']['Shape'], name)
    end
end

-- Events

RegisterNetEvent('mr-vehicleshop:client:homeMenu', function()
    exports['mr-menu']:openMenu(vehicleMenu)
end)

RegisterNetEvent('mr-vehicleshop:client:showVehOptions', function()
    if MRFW.Functions.GetPlayerData().job.onduty then
        exports['mr-menu']:openMenu(vehicleMenu)
    else
        MRFW.Functions.Notify('Go On Duty First', 'error', 3000)
    end
end)

RegisterNetEvent('mr-vehicleshop:client:TestDrive', function()
    if not inTestDrive and ClosestVehicle ~= 0 then
        inTestDrive = true
        local prevCoords = GetEntityCoords(PlayerPedId())
        MRFW.Functions.SpawnVehicle(Config.Shops[insideShop]["ShowroomVehicles"][ClosestVehicle].chosenVehicle, function(veh)
            local closestShop = insideShop
            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
            exports['mr-fuel']:SetFuel(veh, 100)
            SetVehicleNumberPlateText(veh, 'TESTDRIVE')
            exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'body', 1000.0)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'engine', 1000.0)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'fuel', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'clutch', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'brakes', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'axle', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'radiator', 100)
            SetEntityAsMissionEntity(veh, true, true)
            SetEntityHeading(veh, Config.Shops[closestShop]["VehicleSpawn"].w)
            TriggerEvent('vehiclekeys:client:SetOwner', MRFW.Functions.GetPlate(veh))
            TriggerServerEvent('mr-vehicletuning:server:SaveVehicleProps', MRFW.Functions.GetVehicleProperties(veh))
            testDriveVeh = veh
            MRFW.Functions.Notify('You have '..Config.Shops[closestShop]["TestDriveTimeLimit"]..' minutes remaining')
            SetTimeout(Config.Shops[closestShop]["TestDriveTimeLimit"] * 60000, function()
                if testDriveVeh ~= 0 then
                    testDriveVeh = 0
                    inTestDrive = false
                    MRFW.Functions.DeleteVehicle(veh)
                    SetEntityCoords(PlayerPedId(), prevCoords)
                    MRFW.Functions.Notify('Vehicle test drive complete')
                end
            end)
        end, Config.Shops[insideShop]["VehicleSpawn"], false)
        createTestDriveReturn()
        startTestDriveTimer(Config.Shops[insideShop]["TestDriveTimeLimit"] * 60)
    else
        MRFW.Functions.Notify('Already in test drive', 'error')
    end
end)

RegisterNetEvent('mr-vehicleshop:client:customTestDrive', function(data)
    if not inTestDrive then
        inTestDrive = true
        local vehicle = data
        local prevCoords = GetEntityCoords(PlayerPedId())
        MRFW.Functions.SpawnVehicle(vehicle, function(veh)
            exports['mr-fuel']:SetFuel(veh, 100)
            SetVehicleNumberPlateText(veh, 'TESTDRIVE')
            exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'body', 1000.0)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'engine', 1000.0)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'fuel', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'clutch', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'brakes', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'axle', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'radiator', 100)
            SetEntityAsMissionEntity(veh, true, true)
            SetEntityHeading(veh, Config.Shops[insideShop]["VehicleSpawn"].w)
            TriggerEvent('vehiclekeys:client:SetOwner', MRFW.Functions.GetPlate(veh))
            TriggerServerEvent('mr-vehicletuning:server:SaveVehicleProps', MRFW.Functions.GetVehicleProperties(veh))
            testDriveVeh = veh
            MRFW.Functions.Notify('You have '..Config.Shops[shopInsideOf]["TestDriveTimeLimit"]..' minutes remaining')
            SetTimeout(Config.Shops[insideShop]["TestDriveTimeLimit"] * 60000, function()
                if testDriveVeh ~= 0 then
                    testDriveVeh = 0
                    inTestDrive = false
                    MRFW.Functions.DeleteVehicle(veh)
                    SetEntityCoords(PlayerPedId(), prevCoords)
                    MRFW.Functions.Notify('Vehicle test drive complete')
                end
            end)
        end, Config.Shops[insideShop]["VehicleSpawn"], false)
        createTestDriveReturn()
        startTestDriveTimer(Config.Shops[insideShop]["TestDriveTimeLimit"] * 60)
    else
        MRFW.Functions.Notify('Already in test drive', 'error')
    end
end)

RegisterNetEvent('mr-vehicleshop:client:TestDriveReturn', function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped)
    if veh == testDriveVeh then
        testDriveVeh = 0
        inTestDrive = false
        MRFW.Functions.DeleteVehicle(veh)
        exports['mr-menu']:closeMenu()
        testDriveZone:destroy()
    else
        MRFW.Functions.Notify('This is not your test drive vehicle', 'error')
    end
end)

RegisterNetEvent('mr-vehicleshop:client:vehCategories', function()
    local categoryMenu = {
        {
            header = '< Go Back',
            params = {
                event = 'mr-vehicleshop:client:homeMenu'
            }
        }
    }
    for k,v in pairs(Config.Shops[insideShop]['Categories']) do
        categoryMenu[#categoryMenu + 1] = {
            header = v,
            params = {
                event = 'mr-vehicleshop:client:openVehCats',
                args = {
                    catName = k
                }
            }
        }
    end
    exports['mr-menu']:openMenu(categoryMenu)
end)

RegisterNetEvent('mr-vehicleshop:client:openVehCats', function(data)
    local vehMenu  = {
        {
            header = '< Go Back',
            params = {
                event = 'mr-vehicleshop:client:vehCategories'
            }
        }
    }
    for k,v in pairs(MRFW.Shared.Vehicles) do
        if MRFW.Shared.Vehicles[k]["category"] == data.catName and MRFW.Shared.Vehicles[k]["shop"] == insideShop then
            vehMenu[#vehMenu + 1] = {
                header = v.name,
                txt = 'Price: $'..v.price,
                params = {
                    isServer = true,
                    event = 'mr-vehicleshop:server:swapVehicle',
                    args = {
                        toVehicle = v.model,
                        ClosestVehicle = ClosestVehicle,
                        ClosestShop = insideShop
                    }
                }
            }
        end
    end
    exports['mr-menu']:openMenu(vehMenu)
end)

RegisterNetEvent('mr-vehicleshop:client:openFinance', function(data)
    local dialog = exports['mr-input']:ShowInput({
        header = getVehBrand():upper().. ' ' ..data.buyVehicle:upper().. ' - $' ..data.price,
        submitText = "Submit",
        inputs = {
            {
                type = 'number',
                isRequired = true,
                name = 'downPayment',
                text = 'Down Payment Amount - Min ' ..Config.MinimumDown..'%'
            },
            {
                type = 'number',
                isRequired = true,
                name = 'paymentAmount',
                text = 'Total Payments - Min '..Config.MaximumPayments
            }
        }
    })
    if dialog then
        if not dialog.downPayment or not dialog.paymentAmount then return end
        TriggerServerEvent('mr-vehicleshop:server:financeVehicle', dialog.downPayment, dialog.paymentAmount, data.buyVehicle)
    end
end)

RegisterNetEvent('mr-vehicleshop:client:openCustomFinance', function(data)
    TriggerEvent('animations:client:EmoteCommandStart', {"tablet2"})
    local dialog = exports['mr-input']:ShowInput({
        header = getVehBrand():upper().. ' ' ..data.vehicle:upper().. ' - $' ..data.price,
        submitText = "Submit",
        inputs = {
            {
                type = 'number',
                isRequired = true,
                name = 'downPayment',
                text = 'Down Payment Amount - Min 10%'
            },
            {
                type = 'number',
                isRequired = true,
                name = 'paymentAmount',
                text = 'Total Payments - Max '..Config.MaximumPayments
            },
            {
                text = "Server ID (#)",
                name = "playerid", 
                type = "number",
                isRequired = true
            }
        }
    })
    if dialog then
        if not dialog.downPayment or not dialog.paymentAmount or not dialog.playerid then return end
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        TriggerServerEvent('mr-vehicleshop:server:sellfinanceVehicle', dialog.downPayment, dialog.paymentAmount, data.vehicle, dialog.playerid, data.type2)
    end
end)

RegisterNetEvent('mr-vehicleshop:client:swapVehicle', function(data)
    local shopName = data.ClosestShop
    if shopName ~= nil then
        if Config.Shops[shopName]["ShowroomVehicles"][data.ClosestVehicle].chosenVehicle ~= data.toVehicle then
            local closestVehicle, closestDistance = MRFW.Functions.GetClosestVehicle(vector3(Config.Shops[shopName]["ShowroomVehicles"][data.ClosestVehicle].coords.x, Config.Shops[shopName]["ShowroomVehicles"][data.ClosestVehicle].coords.y, Config.Shops[shopName]["ShowroomVehicles"][data.ClosestVehicle].coords.z))
            if closestVehicle == 0 then return end
            if closestDistance < 5 then MRFW.Functions.DeleteVehicle(closestVehicle) end
            while DoesEntityExist(closestVehicle) do
                Wait(50)
            end
            local model = GetHashKey(data.toVehicle)
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(50)
            end
            local veh = CreateVehicle(model, Config.Shops[shopName]["ShowroomVehicles"][data.ClosestVehicle].coords.x, Config.Shops[shopName]["ShowroomVehicles"][data.ClosestVehicle].coords.y, Config.Shops[shopName]["ShowroomVehicles"][data.ClosestVehicle].coords.z, false, false)
            while not DoesEntityExist(veh) do
                Wait(50)
            end
            SetModelAsNoLongerNeeded(model)
            SetVehicleOnGroundProperly(veh)
            SetEntityInvincible(veh,true)
            SetEntityHeading(veh, Config.Shops[shopName]["ShowroomVehicles"][data.ClosestVehicle].coords.w)
            SetVehicleDoorsLocked(veh, 3)
            FreezeEntityPosition(veh, true)
            SetVehicleNumberPlateText(veh, 'BUY ME')
            exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'body', 1000.0)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'engine', 1000.0)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'fuel', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'clutch', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'brakes', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'axle', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'radiator', 100)
            Config.Shops[shopName]["ShowroomVehicles"][data.ClosestVehicle].chosenVehicle = data.toVehicle
        end
    end
end)

CreateThread(function()
    for k,v in pairs(Config.Shops) do
        for i = 1, #Config.Shops[k]['ShowroomVehicles'] do
            local model = GetHashKey(Config.Shops[k]["ShowroomVehicles"][i].defaultVehicle)
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(0)
            end
            local veh = CreateVehicle(model, Config.Shops[k]["ShowroomVehicles"][i].coords.x, Config.Shops[k]["ShowroomVehicles"][i].coords.y, Config.Shops[k]["ShowroomVehicles"][i].coords.z, false, false)
            while not DoesEntityExist(veh) do
                Wait(50)
            end
            SetModelAsNoLongerNeeded(model)
            SetVehicleOnGroundProperly(veh)
            SetEntityInvincible(veh,true)
            SetVehicleDirtLevel(veh, 0.0)
            SetVehicleDoorsLocked(veh, 3)
            SetEntityHeading(veh, Config.Shops[k]["ShowroomVehicles"][i].coords.w)
            FreezeEntityPosition(veh,true)
            SetVehicleNumberPlateText(veh, 'BUY ME')
            exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'body', 1000.0)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'engine', 1000.0)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'fuel', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'clutch', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'brakes', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'axle', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'radiator', 100)
        end
			
        createVehZones(k)
    end
end)


RegisterNetEvent('mr-vehicleshop:client:buyShowroomVehicle', function(vehicle, plate)
    MRFW.Functions.SpawnVehicle(vehicle, function(veh)
        SetVehicleDoorsLocked(veh, 4)
        FreezeEntityPosition(veh, true)
        exports['mr-fuel']:SetFuel(veh, 100)
        SetVehicleNumberPlateText(veh, plate)
        SetEntityHeading(veh, Config.Shops[insideShop]["VehicleSpawn"].w)
        SetEntityAsMissionEntity(veh, true, true)
        TriggerEvent("vehiclekeys:client:SetOwner", MRFW.Functions.GetPlate(veh))
        TriggerEvent('perform:vehicle:damage', veh)
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        MRFW.Functions.Notify('Please Wait Installing ECU Software', 'error', 12000)
        Citizen.Wait(10000)
        TriggerServerEvent("mr-vehicletuning:server:SaveVehicleProps", MRFW.Functions.GetVehicleProperties(veh))
        Citizen.Wait(3000)
        FreezeEntityPosition(veh, false)
        SetVehicleDoorsLocked(veh, 1)
        MRFW.Functions.Notify('ECU Installation Successful', 'success', 3000)
    end, Config.Shops[insideShop]["VehicleSpawn"], true)
end)

RegisterNetEvent('perform:vehicle:damage', function(vehicle)
    SetVehicleBodyHealth(vehicle, 1000.0)
    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(vehicle), 'body', 1000.0)
    SetVehicleEngineHealth(vehicle, 1000.0)
    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(vehicle), 'engine', 1000.0)
    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(vehicle), 'fuel', 100)
    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(vehicle), 'clutch', 100)
    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(vehicle), 'brakes', 100)
    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(vehicle), 'radiator', 100)
    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(vehicle), 'axle', 100)
end)

RegisterNetEvent('mr-vehicleshop:client:getVehicles', function()
    MRFW.Functions.TriggerCallback('mr-vehicleshop:server:getVehicles', function(vehicles)
        local ownedVehicles = {}
        for _, v in pairs(vehicles) do
            if v.balance ~= 0 then
                local name = MRFW.Shared.Vehicles[v.vehicle]["name"]
                local plate = v.plate:upper()
                ownedVehicles[#ownedVehicles + 1] = {
                    header = ''..name..'',
                    txt = 'Plate: ' ..plate,
                    params = {
                        event = 'mr-vehicleshop:client:getVehicleFinance',
                        args = {
                            vehiclePlate = plate,
                            balance = v.balance,
                            paymentsLeft = v.paymentsleft,
                            paymentAmount = v.paymentamount
                        }
                    }
                }
            end
        end
        exports['mr-menu']:openMenu(ownedVehicles)
    end)
end)

RegisterNetEvent('mr-vehicleshop:client:getVehicleFinance', function(data)
    local vehFinance = {
        {
            header = '< Go Back',
            params = {
                event = 'mr-vehicleshop:client:getVehicles'
            }
        },
        {
            isMenuHeader = true,
            header = 'Total Balance Remaining',
            txt = '$'..comma_value(data.balance)..''
        },
        {
            isMenuHeader = true,
            header = 'Total Payments Remaining',
            txt = ''..data.paymentsLeft..''
        },
        {
            isMenuHeader = true,
            header = 'Recurring Payment Amount',
            txt = '$'..comma_value(data.paymentAmount)..''
        },
        {
            header = 'Make a payment',
            params = {
                event = 'mr-vehicleshop:client:financePayment',
                args = {
                    vehData = data,
                    paymentsLeft = data.paymentsleft,
                    paymentAmount = data.paymentamount
                }
            }
        },
        {
            header = 'Payoff vehicle',
            params = {
                isServer = true,
                event = 'mr-vehicleshop:server:financePaymentFull',
                args = {
                    vehBalance = data.balance,
                    vehPlate = data.vehiclePlate
                }
            }
        },
    }
    exports['mr-menu']:openMenu(vehFinance)
end)

RegisterNetEvent('mr-vehicleshop:client:financePayment', function(data)
    local dialog = exports['mr-input']:ShowInput({
        header = 'Vehicle Payment',
        submitText = "Make Payment",
        inputs = {
            {
                type = 'number',
                isRequired = true,
                name = 'paymentAmount',
                text = 'Payment Amount ($)'
            }
        }
    })
    if dialog then
        if not dialog.paymentAmount then return end
        TriggerServerEvent('mr-vehicleshop:server:financePayment', dialog.paymentAmount, data.vehData)
    end
end)

RegisterNetEvent('mr-vehicleshop:client:openIdMenu', function(data)
    local dialog = exports['mr-input']:ShowInput({
        header = MRFW.Shared.Vehicles[data.vehicle]["name"],
        submitText = "Submit",
        inputs = {
            {
                text = "Server ID (#)",
                name = "playerid", 
                type = "number",
                isRequired = true
            }
        }
    })
    if dialog then
        if not dialog.playerid then return end
        if data.type == 'testDrive' then
            TriggerServerEvent('mr-vehicleshop:server:customTestDrive', data.vehicle, dialog.playerid)
        elseif data.type == 'sellVehicle' then
            TriggerServerEvent('mr-vehicleshop:server:sellShowroomVehicle', data.vehicle, dialog.playerid, data.type2)
        end
    end
end)

-- Threads

CreateThread(function()
    for k,v in pairs(Config.Shops) do
        if v.showBlip then
	    local Dealer = AddBlipForCoord(Config.Shops[k]["Location"])
	    SetBlipSprite (Dealer, 326)
            SetBlipDisplay(Dealer, 4)
            SetBlipScale  (Dealer, 0.75)
	    SetBlipAsShortRange(Dealer, true)
	    SetBlipColour(Dealer, 3)
            BeginTextCommandSetBlipName("STRING")
	    AddTextComponentSubstringPlayerName(Config.Shops[k]["ShopLabel"])
	    EndTextCommandSetBlipName(Dealer)
	end
    end
end)

CreateThread(function()
    local financeZone = BoxZone:Create(Config.FinanceZone, 2.0, 2.0, {
        name="financeZone",
        offset={0.0, 0.0, 0.0},
        scale={1.0, 1.0, 1.0},
        debugPoly=false,
    })

    financeZone:onPlayerInOut(function(isPointInside)
        if isPointInside then
            exports['mr-menu']:showHeader(financeMenu)
        else
            exports['mr-menu']:closeMenu()
        end
    end)
end)

RegisterNetEvent('PDM:ToggleDuty', function()
    onDuty = not onDuty
    TriggerServerEvent("MRFW:ToggleDuty")
end)

RegisterNetEvent('EDM:ToggleDuty', function()
    onDuty = not onDuty
    TriggerServerEvent("MRFW:ToggleDuty")
end)

RegisterNetEvent('Tunner:ToggleDuty', function()
    onDuty = not onDuty
    TriggerServerEvent("MRFW:ToggleDuty")
end)


RegisterNetEvent('PDM:PersonalStash', function()
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "pdmstash"..MRFW.Functions.GetPlayerData().citizenid)
    TriggerEvent("inventory:client:SetCurrentStash", "pdmstash"..MRFW.Functions.GetPlayerData().citizenid)
end)

-- if td == nil then
--     RequestModel(GetHashKey("xm_prop_x17_computer_01"))
--     while not HasModelLoaded(GetHashKey("xm_prop_x17_computer_01")) do Citizen.Wait(1) end
--     td = CreateObject(GetHashKey("xm_prop_x17_computer_01"),-1346.20, 159.8, -99.10,false,false,false)
--     SetEntityHeading(td,282.49)
--     FreezeEntityPosition(td, true)
-- end