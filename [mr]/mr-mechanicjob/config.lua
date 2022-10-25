Config = {}

Config.AttachedVehicle = nil

Config.AuthorizedIds = {
    "EZT73604",
    "UGU71986",
    "WNP12923",
}

Config.MaxStatusValues = {
    ["engine"] = 1000.0,
    ["body"] = 1000.0,
    ["radiator"] = 100,
    ["axle"] = 100,
    ["brakes"] = 100,
    ["clutch"] = 100,
    ["fuel"] = 100,
}

Config.ValuesLabels = {
    ["engine"] = "Motor",
    ["body"] = "Body",
    ["radiator"] = "Radiator",
    ["axle"] = "Drive Shaft",
    ["brakes"] = "Brakes",
    ["clutch"] = "Clutch",
    ["fuel"] = "Fuel Ttank",
}

Config.RepairCost = {
    ["body"] = "glass",
    ["radiator"] = "plastic",
    ["axle"] = "steel",
    ["brakes"] = "iron",
    ["clutch"] = "aluminum",
    ["fuel"] = "plastic",
}

Config.RepairCostAmount = {
    ["engine"] = {
        item = "metalscrap",
        costs = 4,
    },
    ["body"] = {
        item = "glass",
        costs = 5,
    },
    ["radiator"] = {
        item = "steel",
        costs = 5,
    },
    ["axle"] = {
        item = "aluminum",
        costs = 6,
    },
    ["brakes"] = {
        item = "copper",
        costs = 3,
    },
    ["clutch"] = {
        item = "iron",
        costs = 4,
    },
    ["fuel"] = {
        item = "plastic",
        costs = 5,
    },
}

Config.Businesses = {
    "Auto Repair",
}

Config.Plates = {
    [1] = {
        coords = vector4(-326.19, -144.36, 38.67, 72.23),
        AttachedVehicle = nil,
        job = 'mechanic',
        ignore = {1,2,3},
        variable = 1,
    },
    [2] = {
        coords = vector4(-319.1, -123.8, 39.02, 61.64),
        AttachedVehicle = nil,
        job = 'mechanic',
        ignore = {1,2,3},
        variable = 1,
    },
    [3] = {
        coords = vector4(-311.45, -102.85, 38.67, 67.78),
        AttachedVehicle = nil,
        job = 'mechanic',
        ignore = {1,2,3},
        variable = 1,
    },
    [4] = {
        coords = vector4(-178.33, -1286.37, 30.87, 93.21),
        AttachedVehicle = nil,
        job = 'bennys',
        ignore = {4,5},
        variable = 2,
    },
    [5] = {
        coords = vector4(-221.68, -1329.73, 30.46, 88.33),
        AttachedVehicle = nil,
        job = 'bennys',
        ignore = {4,5},
        variable = 2,
    },
}

Config.Locations = {
    ["exit"] = vector3(-339.04, -135.53, 39),
    ["stash"] = vector3(-317.01, -130.02, 39.02),
    ["duty"] = vector3(-339.79, -155.44, 44.59), 
    ["vehicle"] = vector4(-356.19, -159.83, 38.73, 32.55), 
    ["pstash"] = vector3(-337.18, -162.19, 44.59) 
}

Config.Vehicles = {
    ["towtruck"] = "Towtruck",
    ["towtruck2"] = "Mini Towtruck",
    ["f450s"] = "MR- Tow",
    ["minivan"] = "Minivan (Rental car)",
    ["blista"] = "Blista",
    ["flatbed"] = "Flatbed",
    ["f550rbc"] = "Mechanic Truck",
}

Config.MinimalMetersForDamage = {
    [1] = {
        min = 8000,
        max = 12000,
        multiplier = {
            min = 1,
            max = 8,
        }
    },
    [2] = {
        min = 12000,
        max = 16000,
        multiplier = {
            min = 8,
            max = 16,
        }
    },
    [3] = {
        min = 12000,
        max = 16000,
        multiplier = {
            min = 16,
            max = 24,
        }
    },
}

Config.Damages = {
    ["radiator"] = "Radiator",
    ["axle"] = "Drive Shaft",
    ["brakes"] = "Brakes",
    ["clutch"] = "Clutch",
    ["fuel"] = "Fuel Tank",
}
