Config = {}

Config.PlateLetters  = 4
Config.PlateNumbers  = 4
Config.PlateUseSpace = false

Config.SpawnVehicle = true  -- TRUE if you want spawn vehicle when buy

Config.TestDrive = true     -- TRUE if you want enable test drive
Config.TestDriveTime = 60   -- TIME in SEC

Config.Blip = {
    vector3(-56.49, -1096.58, 26.42) -- Main Car Dealer Blip
}

Config.Shops = {
    [1] = {
        category = 'pdm', 
        coords = vector3(-46.86, -1095.55, 27.27)
    },
    [2] = {
        category = 'pdm', 
        coords = vector3(-40.4, -1094.55, 27.27)
    },
    [3] = {
        category = 'edm',
        coords = vector3(-783.31, -212.68, 37.15)
    },
    [4] = {
        category = 'tunner',
        coords = vector3(-1347.3, 159.63, -99.19)
    }
}