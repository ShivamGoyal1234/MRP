Config = {}
Config.UsingTarget = true -- If you are using qb-target (uses entity zones to target vehicles)
Config.Commission = 0.10 -- Percent that goes to sales person from a full car sale 10%
Config.FinanceCommission = 0.05 -- Percent that goes to sales person from a finance sale 5%
Config.FinanceZone = vector3(-32.95, -1097.49, 27.27) -- Where the finance menu is located
Config.PaymentWarning = 10 -- time in minutes that player has to make payment before repo
Config.PaymentInterval = 168 -- time in hours between payment being due
Config.MinimumDown = 10 -- minimum percentage allowed down
Config.MaximumPayments = 6 -- maximum payments allowed
Config.Shops = {
    ['pdm'] = {
        ['Type'] = 'managed',  -- no player interaction is required to purchase a car vector3(-56.73, -1086.24, 26.42)
        ['Type2'] = 'normal',
        ['Zone'] = {
            ['Shape'] = { --polygon that surrounds the shop 
                vector2(-51.4, -1071.86),
                vector2(-60.612808227539, -1096.7795410156),
                vector2(-58.26834487915, -1100.572265625),
                vector2(-26.32, -1111.9),
                vector2(-15.06, -1083.73),
            },
            ['minZ'] = 25.0,  -- min height of the shop zone
            ['maxZ'] = 28.0  -- max height of the shop zone
        },
        ['Job'] = 'pdm', -- Name of job or none
        ['jobgrade'] = 0, -- Grades
        ['ShopLabel'] = 'Premium Deluxe Motorsport', -- Blip name
        ['showBlip'] = true,  --- true or false
        ['Categories'] = { -- Categories available to browse
            ['sportsclassics'] = 'Sports Classics',
            ['sedans'] = 'Sedans',
            ['coupes'] = 'Coupes',
            ['suvs'] = 'SUVs',
            ['offroad'] = 'Offroad',
            ['muscle'] = 'Muscle',
            ['compacts'] = 'Compacts',
            ['motorcycles'] = 'Motorcycles',
            ['vans'] = 'Vans',
            -- ['cycles'] = 'Bicycles',
            ['super'] = 'Super',
            ['sports'] = 'Sports'
        },
        ['TestDriveTimeLimit'] = 2.0, -- Time in minutes until the vehicle gets deleted
        ['Location'] = vector3(-45.67, -1098.34, 26.42), -- Blip Location
        ['allowedFinance'] = true,
        ['ReturnLocation'] = vector3(-10.34, -1082.38, 26.7), -- Location to return vehicle, only enables if the vehicleshop has a job owned
        ['VehicleSpawn'] = vector4(-23.44, -1094.66, 26.96, 339.39), -- Spawn location when vehicle is bought
        ['ShowroomVehicles'] = {
            [1] = {
                coords = vector4(-41.83, -1101.45, 26.29, 112.05), -- where the vehicle will spawn on display
                defaultVehicle = 'adder', -- Default display vehicle
                chosenVehicle = 'adder', -- Same as default but is dynamically changed when swapping vehicles
            },
            [2] = {
                coords = vector4(-54.83, -1096.59, 26.29, 119.04),
                defaultVehicle = 'schafter2',
                chosenVehicle = 'schafter2',
            },
            [3] = {
                coords = vector4(-37.23, -1093.07, 26.29, 116.29),
                defaultVehicle = 'comet2',
                chosenVehicle = 'comet2',
            },
            [4] = {
                coords = vector4(-47.64, -1091.99, 26.30, 191.47),
                defaultVehicle = 'vigero',
                chosenVehicle = 'vigero',
            },
            [5] = {
                coords = vector4(-50.06, -1084.26, 26.29, 158.64),
                defaultVehicle = 't20',
                chosenVehicle = 't20',
            }
        },
    },
   ['edm'] = {
        ['Type'] = 'managed',  -- meaning a real player has to sell the car
        ['Type2'] = 'normal',
        ['Zone'] = {
            ['Shape'] = {
                vector2(-788.94, -249.76),
                vector2(-760.04, -239.08),
                vector2(-791.25, -183.47),
                vector2(-818.18, -199.41),
                -- vector2(-1270.5701904297, -368.6716003418),
                -- vector2(-1266.0561523438, -375.14080810547),
                -- vector2(-1244.3684082031, -362.70278930664),
                -- vector2(-1249.8704833984, -352.03326416016),
                -- vector2(-1252.9503173828, -345.85726928711)
            },
            ['minZ'] = 36.00,
            ['maxZ'] = 37.90
        },
        ['Job'] = 'edm', -- Name of job or none
        ['jobgrade'] = 0, -- Grades
        ['ShopLabel'] = 'Luxury Vehicle Shop',
        ['showBlip'] = true,  --- true or false
        ['Categories'] = {
            ['Tier 1 Unlimited'] = 'Tier 1 Unlimited',
            ['Tier 1 Limited'] = 'Tier 1 Limited',
            ['Tier 2 Unlimited'] = 'Tier 2 Unlimited',
            ['Tier 2 Limited'] = 'Tier 2 Limited',
            ['Tier 3 Unlimited'] = 'Tier 3 Unlimited',
            ['Tier 3 Limited'] = 'Tier 3 Limited',
            ['new'] = 'New Arrivals',
            ['indian'] = 'New Arrivals #2',
        },
        ['TestDriveTimeLimit'] = 2.0,
        ['Location'] = vector3(-790.48, -219.58, 37.41),
        ['allowedFinance'] = true,
        ['ReturnLocation'] = vector3(-767.43, -234.38, 36.74),
        ['VehicleSpawn'] = vector4(-775.78, -232.19, 36.69, 216.82),
        ['ShowroomVehicles'] = {
            [1] = {
                coords = vector4(-791.23, -217.3, 36.30, 119.55),
                defaultVehicle = '675ltsp',
                chosenVehicle = '675ltsp',
            },
            [2] = {
                coords = vector4(-779.69, -218.86, 36.15, 70.08),
                defaultVehicle = 'victor',
                chosenVehicle = 'victor',
            },
            [3] = {
                coords = vector4(-787.86, -207.22, 36.10, 118.65),
                defaultVehicle = 'gt63',
                chosenVehicle = 'gt63',
            },
            [4] = {
                coords = vector4(-804.43, -214.52, 36.15, 209.79),
                defaultVehicle = 'lfa',
                chosenVehicle = 'lfa',
            },
            [5] = {
                coords = vector4(-794.84, -229.75, 36.15, 345.83),
                defaultVehicle = 's11mg',
                chosenVehicle = 's11mg',
            },
            [6] = {
                coords = vector4(-789.82, -238.99, 36.15, 31.64),
                defaultVehicle = 'x700mg',
                chosenVehicle = 'x700mg',
            },
            [7] = {
                coords = vector4(-787.54, -243.61, 36.16, 33.45),
                defaultVehicle = 'foxharley1',
                chosenVehicle = 'foxharley1',
            },
            [8] = {
                coords = vector4(-791.83, -235.69, 36.15, 345.71),
                defaultVehicle = 'b350mg',
                chosenVehicle = 'b350mg',
            }
        }
    }, -- Add your next table under this comma
    -- ['boats'] = {
    --     ['Type'] = 'free-use',  -- meaning a real player has to sell the car
    --     ['Zone'] = {
    --         ['Shape'] = {
    --             vector2(-717.79, -1326.76),
    --             vector2(-729.19, -1318.6),
    --             vector2(-765.84, -1360.41),
    --             vector2(-753.9, -1370.33),
    --         },
    --         ['minZ'] = 1.00,
    --         ['maxZ'] = 3.00
    --     },
    --     ['Job'] = 'none', -- Name of job or none
    --     ['ShopLabel'] = 'Boat Shop',
    --     ['showBlip'] = true,  --- true or false
    --     ['Categories'] = {
    --         ['speed'] = 'Speed',
    --         ['sail'] = 'Snail',
    --         ['jetski'] = 'Jet Ski',
    --     },
    --     ['TestDriveTimeLimit'] = 2.0,
    --     ['Location'] = vector3(-746.41, -1351.76, 1.6),
    --     ['ReturnLocation'] = vector3(-725.57, -1354.96, -0.47),
    --     ['VehicleSpawn'] = vector4(-734.3, -1364.07, 0.68, 133.21),
    --     ['ShowroomVehicles'] = {
    --         [1] = {
    --             coords = vector4(-725.84, -1328.02, 0.3, 228.66),
    --             defaultVehicle = 'longfin',
    --             chosenVehicle = 'longfin',
    --         },
    --         [2] = {
    --             coords = vector4(-731.64, -1334.81, 0.35, 228.23),
    --             defaultVehicle = 'squalo',
    --             chosenVehicle = 'squalo',
    --         },
    --         [3] = {
    --             coords = vector4(-736.67, -1342.15, 0.38, 230.04),
    --             defaultVehicle = 'marquis',
    --             chosenVehicle = 'marquis',
    --         },
    --         [4] = {
    --             coords = vector4(-743.52, -1348.35, 0.3, 230.16),
    --             defaultVehicle = 'jetmax',
    --             chosenVehicle = 'jetmax',
    --         },
    --         [5] = {
    --             coords = vector4(-749.4, -1355.3, 0.29, 231.2),
    --             defaultVehicle = 'tropic2',
    --             chosenVehicle = 'tropic2',
    --         },
    --         [6] = {
    --             coords = vector4(-754.73, -1361.97, 0.41, 230.24),
    --             defaultVehicle = 'toro2',
    --             chosenVehicle = 'toro2',
    --         },
    --     }
    -- },
    ------Tunner
    ['tunner'] = {
        ['Type'] = 'managed',  -- meaning a real player has to sell the car
        ['Type2'] = 'normal',
        ['Zone'] = {
            ['Shape'] = {
                vector2(127.93, -3048.42),
                vector2(127.05, -3011.97),
                vector2(148.83, -3013.38),
                vector2(147.5, -3049.68),
            },
            ['minZ'] = -99.00,
            ['maxZ'] = -100.50
        },
        ['Job'] = 'tunner', -- Name of job or none
        ['jobgrade'] = 0, -- Grades
        ['ShopLabel'] = 'Tunner Vehicle Shop',
        ['showBlip'] = false,  --- true or false
        ['Categories'] = {
            ['tunner'] = 'Tunner',
            ['jobs'] = 'Jobs',
        },
        ['TestDriveTimeLimit'] = 2.0,
        ['Location'] = vector3(138.73, -3034.94, 7.06),
        ['allowedFinance'] = true,
        ['ReturnLocation'] = vector3(140.34, -3031.01, 6.35),
        ['VehicleSpawn'] = vector4(140.34, -3031.01, 6.35, 355.57),
        ['ShowroomVehicles'] = {
            [1] = {
                coords = vector4(144.84, -3045.51, 6.10, 359.26),
                defaultVehicle = 'futo3',
                chosenVehicle = 'futo3',
            },
            [2] = {
                coords = vector4(131.13, -3046.16, 6.10, 310.04),
                defaultVehicle = 'drafter',
                chosenVehicle = 'drafter',
            },
            [3] = {
                coords = vector4(137.91, -3018.21, 6.10, 177.83),
                defaultVehicle = 'club',
                chosenVehicle = 'club',
            }
        }
    },
    ['plane'] = {
        ['Type'] = 'managed',  -- meaning a real player has to sell the car
        ['Type2'] = 'plane',
        ['Zone'] = {
            ['Shape'] = {
                vector2(-1030.0, -3016.83),
                vector2(-953.21, -3061.08),
                vector2(-906.84, -2981.26),
                vector2(-955.9, -2952.75),
                vector2(-941.41, -2927.19),
                vector2(-970.35, -2911.25)
            },
            ['minZ'] = -99.00,
            ['maxZ'] = -100.50
        },
        ['Job'] = 'bigboss', -- Name of job or none
        ['jobgrade'] = 0, -- Grades
        ['ShopLabel'] = 'OX Plane Shop',
        ['showBlip'] = false,  --- true or false
        ['Categories'] = {
            ['plane'] = 'Planes',
        },
        ['TestDriveTimeLimit'] = 5.0,
        ['Location'] = vector3(-958.25, -2994.34, 13.95),
        ['allowedFinance'] = false,
        ['ReturnLocation'] = vector3(-1017.1, -3045.38, 13.94),
        ['VehicleSpawn'] = vector4(-1034.89, -2976.06, 14.59, 97.2),
        ['ShowroomVehicles'] = {
            [1] = {
                coords = vector4(-968.83, -3026.64, 14.55-1.5, 60.28),
                defaultVehicle = 'luxor',
                chosenVehicle = 'luxor',
            },
            [2] = {
                coords = vector4(-991.78, -3019.6, 14.13-1.45, 23.27),
                defaultVehicle = 'vestra',
                chosenVehicle = 'vestra',
            },
            [3] = {
                coords = vector4(-967.9, -2973.72, 14.75-1.5, 64.36),
                defaultVehicle = 'dodo',
                chosenVehicle = 'dodo',
            },
            [4] = {
                coords = vector4(-975.76, -2992.74, 14.55-1.5, 57.62),
                defaultVehicle = 'shamal',
                chosenVehicle = 'shamal',
            },
            [5] = {
                coords = vector4(-1008.0, -3011.34, 12.9, 14.17),
                defaultVehicle = 'alphaz1',
                chosenVehicle = 'alphaz1',
            },
            [6] = {
                coords = vector4(-944.38, -2989.6, 14.59-1.5, 103.94),
                defaultVehicle = 'cuban800',
                chosenVehicle = 'cuban800',
            },
            [7] = {
                coords = vector4(-963.72, -2933.79, 14.59-1.5, 149.96),
                defaultVehicle = 'nimbus',
                chosenVehicle = 'nimbus',
            },
            [8] = {
                coords = vector4(-981.12, -2964.01, 14.89-1.7, 109.78),
                defaultVehicle = 'velum',
                chosenVehicle = 'velum',
            },
            [9] = {
                coords = vector4(-999.01, -2998.14, 13.9-1, 41.76),
                defaultVehicle = 'seabreeze',
                chosenVehicle = 'seabreeze',
            }
        }
    },
    ['heli'] = {
        ['Type'] = 'managed',  -- meaning a real player has to sell the car
        ['Type2'] = 'heli',
        ['Zone'] = {
            ['Shape'] = {
                vector2(-1293.23, -3344.17),
                vector2(-1327.53, -3400.21),
                vector2(-1265.04, -3435.25),
                vector2(-1223.52, -3382.33),
            },
            ['minZ'] = -99.00,
            ['maxZ'] = -100.50
        },
        ['Job'] = 'bigboss', -- Name of job or none
        ['jobgrade'] = 0, -- Grades
        ['ShopLabel'] = 'OX Heli Shop',
        ['showBlip'] = false,  --- true or false
        ['Categories'] = {
            ['heli'] = 'Heli',
        },
        ['TestDriveTimeLimit'] = 5.0,
        ['Location'] = vector3(-1280.43, -3388.59, 13.94),
        ['allowedFinance'] = false,
        ['ReturnLocation'] = vector3(-1223.29, -3356.79, 13.95),
        ['VehicleSpawn'] = vector4(-1248.92, -3336.03, 13.95, 327.15),
        ['ShowroomVehicles'] = {
            [1] = {
                coords = vector4(-1264.21, -3401.62, 13.84, 347.07),
                defaultVehicle = 'swift',
                chosenVehicle = 'swift',
            },
            [2] = {
                coords = vector4(-1254.42, -3387.8, 14.53, 330.04),
                defaultVehicle = 'havok',
                chosenVehicle = 'havok',
            },
            [3] = {
                coords = vector4(-1287.13, -3389.77, 14.56, 341.9),
                defaultVehicle = 'SEASPARROW2',
                chosenVehicle = 'SEASPARROW2',
            },
            [4] = {
                coords = vector4(-1285.47, -3368.96, 14.95, 329.2),
                defaultVehicle = 'SEASPARROW',
                chosenVehicle = 'SEASPARROW',
            },
            [5] = {
                coords = vector4(-1273.76, -3385.62, 14.62, 328.04),
                defaultVehicle = 'SuperVolito',
                chosenVehicle = 'SuperVolito',
            },
            [6] = {
                coords = vector4(-1261.58, -3381.38, 14.6, 331.4),
                defaultVehicle = 'Volatus',
                chosenVehicle = 'Volatus',
            },
        }
    },
    ['police'] = {
        ['Type'] = 'managed',  -- meaning a real player has to sell the car
        ['Type2'] = 'police',
        ['Zone'] = {
            ['Shape'] = {
                vector2(479.54, -1083.35),
                vector2(480.14, -1089.16),
                vector2(464.5, -1089.61),
                vector2(464.32, -1083.79),
            },
            ['minZ'] = 28.23,
            ['maxZ'] = 30.23
        },
        ['Job'] = 'police', -- Name of job or none
        ['jobgrade'] = 9, -- Grades
        ['ShopLabel'] = 'Police Shop',
        ['showBlip'] = false,  --- true or false
        ['Categories'] = {
            ['police'] = 'Vehicles',
        },
        ['TestDriveTimeLimit'] = 5.0,
        ['Location'] = vector3(471.53, -1086.21, 29.2),
        ['allowedFinance'] = false,
        ['ReturnLocation'] = vector3(479.88, -1080.82, 29.2),
        ['VehicleSpawn'] = vector4(473.83, -1067.48, 29.21, 88.53),
        ['ShowroomVehicles'] = {
            [1] = {
                coords = vector4(471.67, -1085.83, 28.02, 269.17),
                defaultVehicle = 'npolvic',
                chosenVehicle = 'npolvic',
            },
        }
    },
}

Config.Dealers = {
    {
        ---- Akanksha Choudhary
        cid = 'ZGO66185', ---to put new
        license = 'license:9eba7a10f13a64fb41acfc432989e2a037c7ba3b'
    },
}
