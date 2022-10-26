Config = {}
Config.MaxWidth = 5.0
Config.MaxHeight = 5.0
Config.MaxLength = 5.0
Config.DamageNeeded = 100.0
Config.EnableProne = true
Config.JointEffectTime = 60
Config.RemoveWeaponDrops = true
Config.RemoveWeaponDropsTimer = 25
Config.DefaultPrice = 20 
Config.DirtLevel = 0.1 --carwash dirt level

Consumeables = {
    ["sandwich"] = math.random(10, 20),
    ["pillbox-sandwich"] = math.random(5, 8),
    ["mcd-burger"] = math.random(13, 17),
    ["mcd-fries"] = math.random(8, 12),
    ["chicken-burger"] = math.random(14, 18),
    ["chicken-meal"] = math.random(20, 30),
    ["chicken-fries"] = math.random(10, 13),
    ["mcd-desert"] = math.random(10, 14),
    ["mcd-meal"] = math.random(18, 25),
    ["mcd-wrap"] = math.random(8, 12),
    ["water_bottle"] = math.random(15, 25),
    ["tosti"] = math.random(4, 6),
    ["kurkakola"] = math.random(8, 12),
    ["twerks_candy"] = math.random(2, 4),
    ["snikkel_candy"] = math.random(2, 4),
    ["coffee"] = math.random(10, 15),
    ["pillbox-coffee"] = math.random(10, 15),
    ["whiskey"] = math.random(1, 2),
    ["beer"] = math.random(1, 2),
    ["vodka"] = math.random(1, 2),
    ["hotdog"] = math.random(5, 6),
    ["bahamsspecial"] = math.random(5, 10),
    ["champagne"] = math.random(1, 2),
    ["tequila"] = math.random(3, 6),
    ["vine"] = math.random(1, 2),
    ["monster"] = math.random(10, 12),
    ["redbull"] = math.random(12, 14),
    ["mcd-burger-c"] = math.random(15, 20),
    ["mcd-wrap-c"] = math.random(10, 15),
    ["tea"] = math.random(10, 15),
    ["brownies"] = math.random(6, 9),
    ["cookies"] = math.random(4, 6),
    ["tompasta"] = math.random(10, 20),
    ["cheesepasta"] = math.random(10, 20),

    ["hi-tea"] = math.random(20, 25),

    ["tsoup"] = math.random(10, 15),
    ["msoup"] = math.random(10, 16),
    ["rggol"] = math.random(5, 10),
    ["belachi"] = math.random(1, 2),
    ["gulabjamun"] = math.random(3, 5),
    ["paan"] = math.random(1, 2),
    ["rosogulla"] = math.random(3, 5),
    ["chai"] = math.random(5, 10),

    ["chickenmasala"] = math.random(22, 25),
    ["pannermasala"] = math.random(19, 22),
    ["cookedchicken"] = math.random(1, 2),
    ["chickenroll"] = math.random(10, 15),
    ["brownbread"] = math.random(7, 14),
    ["naan"] = math.random(8, 10),

    ["mcd-nuggets"] = math.random(5, 10),
    ["mcd-maharaja"] = math.random(30, 40),
    ["mcd-chickenpop"] = math.random(5, 7),
    ["mcd-icetea"] = math.random(10, 15),
    ["mcd-spicypaneer"] = math.random(20, 25),
    ["mcd-egg"] = math.random(15, 18),
    ["mcd-strawberry"] = math.random(15, 20),
    ["mcd-caramel"] = math.random(15, 20),
    ["mcd-mango"] = math.random(15, 20),
    ["mcd-cappuccino"] = math.random(15, 20),
    ["mcd-iced"] = math.random(15, 20),
    ["mcd-hchocolate"] = math.random(15, 20),
    ["mcd-cola"] = math.random(12, 15),

    ["garlicbread"] = math.random(8, 10),
    ["hotchocolate"] = math.random(15, 20),
    ["coldcoffee"] = math.random(15, 20),
    ["donuts"] = math.random(8, 12),
    ["icecream2"] = math.random(6, 10),
    ["lassi"] = math.random(10, 15),
    ["nimbupani"] = math.random(10, 15),
    ["uwupancake"] = math.random(25, 34),
    ["uwubudhabowl"] = math.random(50, 60),
    ["uwusushi"] = math.random(35, 40),
    ["uwucupcake"] = math.random(40, 45),
    ["uwuvanillasandy"] = math.random(30, 40),
    ["uwuchocsandy"] = math.random(30, 40),

    ["uwububbleteablueberry"] = math.random(40, 45),
    ["uwububbletearose"] = math.random(40, 45),
    ["uwububbleteamint"] = math.random(40, 50),
    ["uwumisosoup"] = math.random(80, 90),
}

Config.BlacklistedScenarios = {
    ['TYPES'] = {
        "WORLD_VEHICLE_MILITARY_PLANES_SMALL",
        "WORLD_VEHICLE_MILITARY_PLANES_BIG",
        "WORLD_VEHICLE_AMBULANCE",
        "WORLD_VEHICLE_POLICE_NEXT_TO_CAR",
        "WORLD_VEHICLE_POLICE_CAR",
        "WORLD_VEHICLE_POLICE_BIKE",
    },
    ['GROUPS'] = {
        2017590552,
        2141866469,
        1409640232,
        `ng_planes`,
    }
}

Config.BlacklistedVehs = {
    --[`SHAMAL`] = true,
    --[`LUXOR`] = true,
    --[`LUXOR2`] = true,
    --[`JET`] = true,
    [`LAZER`] = true,
    [`BUZZARD`] = true,
    --[`BUZZARD2`] = true,
    [`ANNIHILATOR`] = true,
    [`SAVAGE`] = true,
    --[`TITAN`] = true,
    [`RHINO`] = true,
    [`POLICE`] = true,
    [`POLICE2`] = true,
    [`POLICE3`] = true,
    [`vigilante`] = true,
    [`POLICEB`] = true,
    [`POLICET`] = true,
    [`SHERIFF`] = true,
    [`SHERIFF2`] = true,
    -- [`FIRETRUK`] = true,
    --[`MULE`] = true,
    -- [`POLMAV`] = true,
    [`MAVERICK`] = true,
    [`BLIMP`] = true,
    -- [`AIRTUG`] = true,
    --[`CAMPER`] = true,
}

Config.BlacklistedPeds = {
    [`s_m_y_ranger_01`] = true,
    [`s_m_y_sheriff_01`] = true,
    [`s_m_y_cop_01`] = true,
    [`s_f_y_sheriff_01`] = true,
    [`s_f_y_cop_01`] = true,
    [`s_m_y_hwaycop_01`] = true,
}

Config.Teleports = {
    --Elevator @ labs
    [1] = {
        [1] = {
            coords = vector4(3540.74, 3675.59, 20.99, 167.5),
            ["AllowVehicle"] = false,
            drawText = '[E] Take Elevator Up'
        },
        [2] = {
            coords = vector4(3540.74, 3675.59, 28.11, 172.5),
            ["AllowVehicle"] = false,
            drawText = '[E] Take Elevator Down'
        },
        
    },
    [2] = { -- Pilbox
        [1] = {
            coords = vector4(332.4, -595.68, 43.28, 65.3),
            ["AllowVehicle"] = false, 
            drawText = '[E] Take Elevator Up'
        },
        [2] = {
            coords = vector4(338.54, -583.74, 74.16, 245.72),
            ["AllowVehicle"] = false,
            drawText = '[E] Take Elevator Down'
        },
    },
    [3]= { -- Pilbox
        [1] = {
            coords = vector4(330.18, -601.28, 43.28, 71.95),
            ["AllowVehicle"] = false, 
            drawText = '[E] Take Elevator Down'
        },
        [2] = {
            coords = vector4(342.26, -585.55, 28.8, 71.95),
            ["AllowVehicle"] = false,
            drawText = '[E] Take Elevator Up'
        },
    },
    [4] = { -- CityHall
        [1] = {
            coords = vector4(-1309.48, -559.05, 20.8, 215.46),
            ["AllowVehicle"] = false, 
            drawText = '[E] Take Elevator Up'
        },
        [2] = {
            coords = vector4(-1309.56, -563.37, 30.57, 219.16),
            ["AllowVehicle"] = false,
            drawText = '[E] Take Elevator Down'
        },
    },
    [5] = { -- CityHall
        [1] = {
            coords = vector4(-1309.39, -563.54, 34.37, 223.1),
            ["AllowVehicle"] = false, 
            drawText = '[E] Take Elevator Down'
        },
        [2] = {
            coords = vector4(-1307.33, -562.12, 30.57, 223.1),
            ["AllowVehicle"] = false,
            drawText = '[E] Take Elevator Up'
        },
    },
    [6] = { -- CityHall
        [1] = {
            coords = vector4(-1309.43, -563.54, 37.37, 223.1),
            ["AllowVehicle"] = false, 
            drawText = '[E] Take Elevator Down'
        },
        [2] = {
            coords = vector4(-1307.45, -561.67, 34.37, 223.1),
            ["AllowVehicle"] = false,
            drawText = '[E] Take Elevator Up'
        },
    },
    [7] = { -- CityHall
        [1] = {
            coords = vector4(-1309.47, -563.62, 41.18, 223.1),
            ["AllowVehicle"] = false, 
            drawText = '[E] Take Elevator Down'
        },
        [2] = {
            coords = vector4(-1307.55, -557.43, 20.8, 223.1),
            ["AllowVehicle"] = false,
            drawText = '[E] Take Elevator Up'
        },
    },
    [8] = { -- Nightclup
        [1] = {
            coords = vector4(4.03, 220.55, 107.77, 253.37),
            ["AllowVehicle"] = false, 
            drawText = '[E] To Enter In NightClub'
        },
        [2] = {
            coords = vector4(-1569.27, -3017.63, -74.41, 358.23),
            ["AllowVehicle"] = false,
            drawText = '[E] To Exit In NightClub'
        },
    },
}

Config.CarWash = { -- carwash
    [1] = {
        ["label"] = "Hands Free Carwash",
        ["coords"] = vector3(25.29, -1391.96, 29.33),
    },
    [2] = {
        ["label"] = "Hands Free Carwash",
        ["coords"] = vector3(174.18, -1736.66, 29.35),
    },
    [3] = {
        ["label"] = "Hands Free Carwash",
        ["coords"] = vector3(-74.56, 6427.87, 31.44),
    },
    [4] = {
        ["label"] = "Hands Free Carwash",
        ["coords"] = vector3(1363.22, 3592.7, 34.92),
    },
    [5] = {
        ["label"] = "Hands Free Carwash",
        ["coords"] = vector3(-699.62, -932.7, 19.01),
    }
}


Config.Exercises = {
    ["Pushups"] = {
        ["idleDict"] = "amb@world_human_push_ups@male@idle_a",
        ["idleAnim"] = "idle_c",
        ["actionDict"] = "amb@world_human_push_ups@male@base",
        ["actionAnim"] = "base",
        ["actionTime"] = 1100,
        ["enterDict"] = "amb@world_human_push_ups@male@enter",
        ["enterAnim"] = "enter",
        ["enterTime"] = 3050,
        ["exitDict"] = "amb@world_human_push_ups@male@exit",
        ["exitAnim"] = "exit",
        ["exitTime"] = 3400,
        ["actionProcent"] = 1,
        ["actionProcentTimes"] = 3,
    },
    ["Situps"] = {
        ["idleDict"] = "amb@world_human_sit_ups@male@idle_a",
        ["idleAnim"] = "idle_a",
        ["actionDict"] = "amb@world_human_sit_ups@male@base",
        ["actionAnim"] = "base",
        ["actionTime"] = 3400,
        ["enterDict"] = "amb@world_human_sit_ups@male@enter",
        ["enterAnim"] = "enter",
        ["enterTime"] = 4200,
        ["exitDict"] = "amb@world_human_sit_ups@male@exit",
        ["exitAnim"] = "exit", 
        ["exitTime"] = 3700,
        ["actionProcent"] = 1,
        ["actionProcentTimes"] = 10,
    },
    ["Chins"] = {
        ["idleDict"] = "amb@prop_human_muscle_chin_ups@male@idle_a",
        ["idleAnim"] = "idle_a",
        ["actionDict"] = "amb@prop_human_muscle_chin_ups@male@base",
        ["actionAnim"] = "base",
        ["actionTime"] = 3000,
        ["enterDict"] = "amb@prop_human_muscle_chin_ups@male@enter",
        ["enterAnim"] = "enter",
        ["enterTime"] = 1600,
        ["exitDict"] = "amb@prop_human_muscle_chin_ups@male@exit",
        ["exitAnim"] = "exit",
        ["exitTime"] = 3700,
        ["actionProcent"] = 1,
        ["actionProcentTimes"] = 10,
    },
}

Config.Blips = {
    [1] = {["x"] = -1201.0078125, ["y"] = -1568.3903808594, ["z"] = 4.6110973358154, ["id"] = 311, ["color"] = 49, ["scale"] = 0.7, ["text"] = "The Gym"},
    [2] = {["x"] = 107.89, ["y"] = -1305.11, ["z"] = 28.79, ["id"] = 121, ["color"] = 1,  ["scale"] = 0.65,["text"] = "Venilla Unicorn"},
    [3] = {["x"] = 4.03, ["y"] = 220.55, ["z"] = 107.77, ["id"] = 614, ["color"] = 83,  ["scale"] = 0.65,["text"] = "NightClub"},
    [4] = {["x"] = -509.74, ["y"] = -21.72, ["z"] = 45.61, ["id"] = 537, ["color"] = 31,  ["scale"] = 0.65,["text"] = "The little Teapot"},
    [5] = {["x"] = -379.4, ["y"] = 6061.95, ["z"] = 31.5, ["id"] = 542, ["color"] = 50,  ["scale"] = 0.65,["text"] = "Hunting"},
    [6] = {["x"] = 981.61, ["y"] = -2122.45, ["z"] = 30.48, ["id"] = 154, ["color"] = 41,  ["scale"] = 0.65,["text"] = "Hunting Proccess"},
    [7] = {["x"] = 350.95, ["y"] = 6515.83, ["z"] = 28.54, ["id"] = 270, ["color"] = 17,  ["scale"] = 0.65,["text"] = "Orange Garden"},
    [8] = {["x"] = 2741.4, ["y"] = 4412.58, ["z"] = 48.62, ["id"] = 365, ["color"] = 17,  ["scale"] = 0.65,["text"] = "Juice Factory"},
    [9] = {["x"] = 248.36, ["y"] = 6514.25, ["z"] = 31.03, ["id"] = 270, ["color"] = 1,  ["scale"] = 0.65,["text"] = "Apple Garden"},
    [10] = {["x"] = -1080.55, ["y"] = -250.54, ["z"] = 37.76, ["id"] = 351, ["color"] = 1,  ["scale"] = 1.0,["text"] = "Life Invader"},
    [11] = {["x"] = -1187.33, ["y"] = -1536.05, ["z"] = 4.38, ["id"] = 385, ["color"] = 52,  ["scale"] = 0.80,["text"] = "Juice Dealer"},
    [12] = {["x"] = -1928.84, ["y"] = 2059.75, ["z"] = 140.84, ["id"] = 472, ["color"] = 52,  ["scale"] = 0.80,["text"] = "Vineyard"},
    [13] = {["x"] = -1582.39, ["y"] = -556.78, ["z"] = 34.95, ["id"] = 374, ["color"] = 5,  ["scale"] = 0.80,["text"] = "LOM BANK"},
    [14] = {["x"] = -1395.73, ["y"] = -606.48, ["z"] = 30.32, ["id"] = 106, ["color"] = 27,  ["scale"] = 0.70,["text"] = "Bahama Mamas"},
    [15] = {["x"] = -625.99, ["y"] = 233.33, ["z"] = 81.88, ["id"] = 256, ["color"] = 21,  ["scale"] = 0.80,["text"] = "Bean Machine Coffee"},
    [16] = {["x"] = -1189.61, ["y"] = -888.12, ["z"] = 13.98, ["id"] = 106, ["color"] = 5,  ["scale"] = 0.70,["text"] = "BurgerShot"},
    [17] = {["x"] = 341.52, ["y"] = -881.89, ["z"] = 29.34, ["id"] = 436, ["color"] = 1,  ["scale"] = 0.80,["text"] = "KFC"},
    [18] = {["x"] = -253.94, ["y"] = 6317.46, ["z"] = 32.41, ["id"] = 61, ["color"] = 25,  ["scale"] = 0.80,["text"] = "Abandoned Hospital"},
    [19] = {["x"] = -1826.41, ["y"] = -1194.84, ["z"] = 14.34, ["id"] = 267, ["color"] = 50,  ["scale"] = 0.70,["text"] = "Pearls Restaurant"},
    [20] = {["x"] = -1491.49, ["y"] = -1481.7, ["z"] = 5.7, ["id"] = 489, ["color"] = 48,  ["scale"] = 0.90,["text"] = "Wedding Area"},
    [21] = {["x"] = -1652.292, ["y"] = -1082.437, ["z"] = 12.15424, ["id"] = 76, ["color"] = 69,  ["scale"] = 0.70,["text"] = "Arcade"},
    [22] = {["x"] = -581.06, ["y"] = -1066.22, ["z"] = 22.34, ["id"] = 89, ["color"] = 48,  ["scale"] = 0.60,["text"] = "Cat Cafe"},
    [23] = {["x"] = 758.522, ["y"] = -777.252, ["z"] = 26.64883, ["id"] = 536, ["color"] = 64,  ["scale"] = 0.70,["text"] = "8 Balls"},
    [24] = {["x"] = 1595.537, ["y"] = 6451.94, ["z"] = 25.01383, ["id"] = 538, ["color"] = 82,  ["scale"] = 0.70,["text"] = "Diner"},
    [25] = {["x"] = 814.5675, ["y"] = -762.8239, ["z"] = 27.04651, ["id"] = 267, ["color"] = 44,  ["scale"] = 0.70,["text"] = "Pizza Restaurant"},
    [26] = {["x"] = -3542.82200000, ["y"] = 1488.25000000, ["z"] = 5.42990900, ["id"] = 455, ["color"] = 2,  ["scale"] = 0.70,["text"] = "Yacht"},
    [27] = {["x"] = -3148.37900000, ["y"] = 2807.55500000, ["z"] = 5.43004400, ["id"] = 455, ["color"] = 2,  ["scale"] = 0.70,["text"] = "Yacht"},
    [28] = {["x"] = -3280.50100000, ["y"] = 2140.50700000, ["z"] = 5.42995500, ["id"] = 455, ["color"] = 2,  ["scale"] = 0.70,["text"] = "Yacht"},
    [29] = {["x"] = -2814.48900000, ["y"] = 4072.74000000, ["z"] = 5.42835300, ["id"] = 455, ["color"] = 2,  ["scale"] = 0.70,["text"] = "Yacht"},
    [30] = {["x"] = -3254.55200000, ["y"] = 3685.67600000, ["z"] = 5.42995500, ["id"] = 455, ["color"] = 2,  ["scale"] = 0.70,["text"] = "Yacht"},
    [31] = {["x"] = -2368.44100000, ["y"] = 4697.87400000, ["z"] = 5.42995500, ["id"] = 455, ["color"] = 2,  ["scale"] = 0.70,["text"] = "Yacht"},
    [32] = {["x"] = -3205.34400000, ["y"] = -219.01040000, ["z"] = 5.42995500, ["id"] = 455, ["color"] = 2,  ["scale"] = 0.70,["text"] = "Yacht"},
    [33] = {["x"] = -3448.25400000, ["y"] = 311.50180000, ["z"] = 5.42995500, ["id"] = 455, ["color"] = 2,  ["scale"] = 0.70,["text"] = "Yacht"},
    [34] = {["x"] = -2697.86200000, ["y"] = -540.61230000, ["z"] = 5.42995500, ["id"] = 455, ["color"] = 2,  ["scale"] = 0.70,["text"] = "Yacht"},
    [35] = {["x"] = -1995.72500000, ["y"] = -1523.69400000, ["z"] = 5.42997000, ["id"] = 455, ["color"] = 2,  ["scale"] = 0.70,["text"] = "Yacht"},
    [36] = {["x"] = -2117.58100000, ["y"] = -2543.34600000, ["z"] = 5.42995500, ["id"] = 455, ["color"] = 2,  ["scale"] = 0.70,["text"] = "Yacht"},
    [37] = {["x"] = -1605.07400000, ["y"] = -1872.46800000, ["z"] = 5.42995500, ["id"] = 455, ["color"] = 2,  ["scale"] = 0.70,["text"] = "Yacht"},
    [38] = {["x"] = -753.08170000, ["y"] = -3919.06800000, ["z"] = 5.42995500, ["id"] = 455, ["color"] = 2,  ["scale"] = 0.70,["text"] = "Yacht"},
    [39] = {["x"] = -351.06080000, ["y"] = -3553.32300000, ["z"] = 5.42995500, ["id"] = 455, ["color"] = 2,  ["scale"] = 0.70,["text"] = "Yacht"},
    [40] = {["x"] = -1460.53600000, ["y"] = -3761.46700000, ["z"] = 5.42995500, ["id"] = 455, ["color"] = 2,  ["scale"] = 0.70,["text"] = "Yacht"},
    [41] = {["x"] = 1546.89200000, ["y"] = -3045.62700000, ["z"] = 5.43018400, ["id"] = 455, ["color"] = 2,  ["scale"] = 0.70,["text"] = "Yacht"},
    [42] = {["x"] = 2490.88600000, ["y"] = -2428.84800000, ["z"] = 5.42995500, ["id"] = 455, ["color"] = 2,  ["scale"] = 0.70,["text"] = "Yacht"},
    [43] = {["x"] = 2049.79000000, ["y"] = -2821.62400000, ["z"] = 5.42995500, ["id"] = 455, ["color"] = 2,  ["scale"] = 0.70,["text"] = "Yacht"},
    [44] = {["x"] = 3029.01800000, ["y"] = -1495.70200000, ["z"] = 5.42996800, ["id"] = 455, ["color"] = 2,  ["scale"] = 0.70,["text"] = "Yacht"},
    [45] = {["x"] = 3021.25400000, ["y"] = -723.39030000, ["z"] = 5.42998600, ["id"] = 455, ["color"] = 2,  ["scale"] = 0.70,["text"] = "Yacht"},
    [46] = {["x"] = 2976.62200000, ["y"] = -1994.76000000, ["z"] = 5.42995500, ["id"] = 455, ["color"] = 2,  ["scale"] = 0.70,["text"] = "Yacht"},
    [47] = {["x"] = 3404.51000000, ["y"] = 1977.04400000, ["z"] = 5.42995500, ["id"] = 455, ["color"] = 2,  ["scale"] = 0.70,["text"] = "Yacht"},
    [48] = {["x"] = 3411.10000000, ["y"] = 1193.44500000, ["z"] = 5.43006200, ["id"] = 455, ["color"] = 2,  ["scale"] = 0.70,["text"] = "Yacht"},
    [49] = {["x"] = 3784.80200000, ["y"] = 2548.54100000, ["z"] = 5.42995500, ["id"] = 455, ["color"] = 2,  ["scale"] = 0.70,["text"] = "Yacht"},
    [50] = {["x"] = 4225.02800000, ["y"] = 3988.00200000, ["z"] = 5.42995500, ["id"] = 455, ["color"] = 2,  ["scale"] = 0.70,["text"] = "Yacht"},
    [51] = {["x"] = 4250.58100000, ["y"] = 4576.56500000, ["z"] = 5.42995500, ["id"] = 455, ["color"] = 2,  ["scale"] = 0.70,["text"] = "Yacht"},
    [52] = {["x"] = 4204.35600000, ["y"] = 3373.70000000, ["z"] = 5.42995500, ["id"] = 455, ["color"] = 2,  ["scale"] = 0.70,["text"] = "Yacht"},
    [53] = {["x"] = 3751.68100000, ["y"] = 5753.50100000, ["z"] = 5.42995500, ["id"] = 455, ["color"] = 2,  ["scale"] = 0.70,["text"] = "Yacht"},
    [54] = {["x"] = 3490.10500000, ["y"] = 6305.78500000, ["z"] = 5.42995500, ["id"] = 455, ["color"] = 2,  ["scale"] = 0.70,["text"] = "Yacht"},
    [55] = {["x"] = 3684.85300000, ["y"] = 5212.23800000, ["z"] = 5.42995500, ["id"] = 455, ["color"] = 2,  ["scale"] = 0.70,["text"] = "Yacht"},
    [56] = {["x"] = 581.59550000, ["y"] = 7124.55800000, ["z"] = 5.42995500, ["id"] = 455, ["color"] = 2,  ["scale"] = 0.70,["text"] = "Yacht"},
    [57] = {["x"] = 2004.46200000, ["y"] = 6907.15700000, ["z"] = 5.42997400, ["id"] = 455, ["color"] = 2,  ["scale"] = 0.70,["text"] = "Yacht"},
    [58] = {["x"] = 1396.63800000, ["y"] = 6860.20300000, ["z"] = 5.42995900, ["id"] = 455, ["color"] = 2,  ["scale"] = 0.70,["text"] = "Yacht"},
    [59] = {["x"] = -1170.69000000, ["y"] = 5980.68100000, ["z"] = 5.42994400, ["id"] = 455, ["color"] = 2,  ["scale"] = 0.70,["text"] = "Yacht"},
    [60] = {["x"] = -777.48650000, ["y"] = 6566.90700000, ["z"] = 5.42995500, ["id"] = 455, ["color"] = 2,  ["scale"] = 0.70,["text"] = "Yacht"},
    [61] = {["x"] = -381.77390000, ["y"] = 6946.96000000, ["z"] = 5.42990000, ["id"] = 455, ["color"] = 2,  ["scale"] = 0.70,["text"] = "Yacht"},
    [62] = {["x"] = 376.67, ["y"] = -1598.09, ["z"] = 30.06, ["id"] = 60, ["color"] = 29,  ["scale"] = 0.80,["text"] = "Abandoned PD"},
    [63] = {["x"] = 833.99, ["y"] = -1291.5, ["z"] = 28.24, ["id"] = 60, ["color"] = 29,  ["scale"] = 0.80,["text"] = "Abandoned PD"},
    [64] = {["x"] = 385.94, ["y"] = 797.6, ["z"] = 187.46, ["id"] = 60, ["color"] = 29,  ["scale"] = 0.80,["text"] = "Abandoned PD"},
    [65] = {["x"] = 1835.1, ["y"] = 3676.24, ["z"] = 34.19, ["id"] = 60, ["color"] = 29,  ["scale"] = 0.80,["text"] = "Abandoned PD"},
    [66] = {["x"] = 4892.14, ["y"] = -4921.72, ["z"] = 3.37, ["id"] = 93, ["color"] = 35,  ["scale"] = 0.80,["text"] = "Cayo Perico Party Area"},
}


Config.JointEffectTime = 60
Config.logout = {
    ["logout"] = {
        [1] = {x = -212.08, y = -1033.77, z = 30.14},
        [2] = {x = 475.63, y = -980.67, z = 30.69},
        [3] = {x = 332.89, y = -568.85, z = 43.28},
        [4] = {x = 437.87, y = -624.34, z = 28.71},
        [5] = {x = 82.59, y = 6421.85, z = 31.68},
        [6] = {x = -1290.18, y = -564.97, z = 41.23},
        [7] = {x = -340.15, y = -167.12, z = 44.59},
        [8] = {x = 907.33, y = -3200.01, z = -96.94},
    }, 
}

Config.GYM = {      -- REMINDER. If you want it to set coords+heading then enter heading, else put nil ( ["h"] )
    {["x"] = -1200.08, ["y"] = -1571.15, ["z"] = 4.6115 - 0.98, ["h"] = 214.37, ["exercise"] = "Chins"},
    {["x"] = -1205.0118408203, ["y"] = -1560.0671386719,["z"] = 4.614236831665 - 0.98, ["h"] = nil, ["exercise"] = "Situps"},
    {["x"] = -1203.3094482422, ["y"] = -1570.6759033203, ["z"] = 4.6079330444336 - 0.98, ["h"] = nil, ["exercise"] = "Pushups"},
    --{["x"] = -1206.76, ["y"] = -1572.93, ["z"] = 4.61 - 0.98, ["h"] = nil, ["exercise"] = "Pushups"},
    -- ^^ You can add more locations like this
}