local function VehicleShooting(vehdata)
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local heading = getCardinalDirectionFromHeading()
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "vehicleshots", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-60",
        firstStreet = locationInfo,
        model = vehdata.name,
        plate = vehdata.plate,
        priority = 2,
        firstColor = vehdata.colour,
        heading = heading,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = "Shots Fired from Vehicle",
        job = {"doctor","police"}
    })
end exports('VehicleShooting', VehicleShooting)

local function Shooting()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "shooting", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-13",
        firstStreet = locationInfo,
        gender = gender,
        model = nil,
        plate = nil,
        priority = 2,
        firstColor = nil,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = "Shots Fired",
        job = {"police"}
    })
end exports('Shooting', Shooting)

-- local function Shooting2()
--     local currentPos = GetEntityCoords(PlayerPedId())
--     local locationInfo = getStreetandZone(currentPos)
--     local gender = GetPedGender()
--     TriggerServerEvent("dispatch:server:notify",{
--         dispatchcodename = "shooting2", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
--         dispatchCode = "10-11",
--         firstStreet = locationInfo,
--         gender = gender,
--         model = nil,
--         plate = nil,
--         priority = 2,
--         firstColor = nil,
--         automaticGunfire = false,
--         origin = {
--             x = currentPos.x,
--             y = currentPos.y,
--             z = currentPos.z
--         },
--         dispatchMessage = "Friendly Shots Fired",
--         job = {"police"}
--     })
-- end exports('Shooting2', Shooting2)

local function SpeedingVehicle(vehdata)
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local heading = getCardinalDirectionFromHeading()
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "speeding", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-56",
        firstStreet = locationInfo,
        model = vehdata.name,
        plate = vehdata.plate,
        priority = 2,
        firstColor = vehdata.colour,
        heading = heading,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = "Speeding Vehicle",
        job = {"police"}
    })
end exports('SpeedingVehicle', SpeedingVehicle)

local function Fight()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "fight", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-10",
        firstStreet = locationInfo,
        gender = gender,
        model = nil,
        plate = nil,
        priority = 2,
        firstColor = nil,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = "Fight In Progress",
        job = {"police"}
    })
end exports('Fight', Fight)

local function InjuriedPerson()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "civdown", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-69",
        firstStreet = locationInfo,
        gender = gender,
        model = nil,
        plate = nil,
        priority = 2, -- priority
        firstColor = nil,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = "Civilian Down", -- message
        job = {"doctor"} -- jobs that will get the alerts
    })
end exports('InjuriedPerson', InjuriedPerson)


local function StoreRobbery(camId,coords)
    local currentPos = coords
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "storerobbery", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-90C",
        firstStreet = locationInfo,
        gender = gender,
        camId = camId,
        model = nil,
        plate = nil,
        priority = 2, -- priority
        firstColor = nil,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = "Store Robbery", -- message
        job = {"police"} -- jobs that will get the alerts
    })
end exports('StoreRobbery', StoreRobbery)

local function FleecaBankRobbery(camId, coords)
    local currentPos = coords
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "bankrobbery", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-90A",
        firstStreet = locationInfo,
        gender = gender,
        camId = camId,
        model = nil,
        plate = nil,
        priority = 2, -- priority
        firstColor = nil,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = "Fleeca Bank Robbery", -- message
        job = {"police"} -- jobs that will get the alerts
    })
end exports('FleecaBankRobbery', FleecaBankRobbery)

local function PaletoBankRobbery(camId, coords)
    local currentPos = coords
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "paletobankrobbery", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-90A",
        firstStreet = locationInfo,
        gender = gender,
        camId = camId,
        model = nil,
        plate = nil,
        priority = 2, -- priority
        firstColor = nil,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = "Paleto Bank Robbery", -- message
        job = {"police"} -- jobs that will get the alerts
    })
end exports('PaletoBankRobbery', PaletoBankRobbery)

local function PacificBankRobbery(camId, coords)
    local currentPos = coords
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "pacificbankrobbery", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-90A",
        firstStreet = locationInfo,
        gender = gender,
        camId = camId,
        model = nil,
        plate = nil,
        priority = 2, -- priority
        firstColor = nil,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = "Pacific Bank Robbery", -- message
        job = {"police"} -- jobs that will get the alerts
    })
end exports('PacificBankRobbery', PacificBankRobbery)

local function PrisonBreak(coords)
    local currentPos = coords
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "prisonbreak", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-90",
        firstStreet = locationInfo,
        gender = gender,
        model = nil,
        plate = nil,
        priority = 2, -- priority
        firstColor = nil,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = "Prison Break In Progress", -- message
        job = {"police"} -- jobs that will get the alerts
    })
end exports('PrisonBreak', PrisonBreak)

local function VangelicoRobbery(coords)
    local currentPos = coords
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "vangelicorobbery", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-90B",
        firstStreet = locationInfo,
        gender = gender,
        camId = true,
        model = nil,
        plate = nil,
        priority = 2, -- priority
        firstColor = nil,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = "Vangelico Robbery", -- message
        job = {"police"} -- jobs that will get the alerts
    })
end exports('VangelicoRobbery', VangelicoRobbery)

local function HouseRobbery(coords)
    local currentPos = coords
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "houserobbery", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-90D",
        firstStreet = locationInfo,
        gender = gender,
        model = nil,
        plate = nil,
        priority = 2, -- priority
        firstColor = nil,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = "House Robbery", -- message
        job = {"police"} -- jobs that will get the alerts
    })
end exports('HouseRobbery', HouseRobbery)

local function DrugSale()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "suspicioushandoff", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-60",
        firstStreet = locationInfo,
        gender = gender,
        model = nil,
        plate = nil,
        priority = 2, -- priority
        firstColor = nil,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = "Suspicious Handoff", -- message
        job = {"police"} -- jobs that will get the alerts
    })
end exports('DrugSale', DrugSale)


RegisterNetEvent("mr-dispatch:client:officerdown", function()
    local plyData = MRFW.Functions.GetPlayerData()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "officerdown", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-99",
        firstStreet = locationInfo,
        name = plyData.charinfo.firstname:sub(1,1):upper()..plyData.charinfo.firstname:sub(2).. " ".. plyData.charinfo.lastname:sub(1,1):upper()..plyData.charinfo.lastname:sub(2),
        model = nil,
        plate = nil,
        priority = 2, -- priority
        firstColor = nil,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = "Officer Down", -- message
        job = {"police", "doctor"} -- jobs that will get the alerts
    })
end) 

RegisterNetEvent("mr-dispatch:client:emsdown", function()
    local plyData = MRFW.Functions.GetPlayerData()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "emsdown", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-99",
        firstStreet = locationInfo,
        name = plyData.charinfo.firstname:sub(1,1):upper()..plyData.charinfo.firstname:sub(2).. " ".. plyData.charinfo.lastname:sub(1,1):upper()..plyData.charinfo.lastname:sub(2),
        model = nil,
        plate = nil,
        priority = 2, -- priority
        firstColor = nil,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = "EMS Down", -- message
        job = {"police", "doctor"} -- jobs that will get the alerts
    })
end) 

local function Vehicletheft(vehicle, coords)
    local vehdata = vehicleData(vehicle)
    local currentPos = coords
    local locationInfo = getStreetandZone(currentPos)
    local heading = getCardinalDirectionFromHeading()
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "vehicletheft", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-60",
        firstStreet = locationInfo,
        model = vehdata.name, -- vehicle name
        plate = vehdata.plate, -- vehicle plate
        priority = 2, 
        firstColor = vehdata.colour, -- vehicle color
        heading = heading, 
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = "Vehicle Theft",
        job = {"police"}
    })
end exports('Vehicletheft',Vehicletheft)

RegisterCommand('testdispatch',function()
    TriggerEvent('')
end)