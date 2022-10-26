-- Don't touch it unless you knnow what you're doing

Config = Config or {}

Config.QueueList = {}

Config.PlayerContract = {}

Config.BennysItems = {}

----------------------------------------------------------

Config.Alert = 'mr-dispatch' -- qb-dispatch / linden_outlawalert / notification, only use qb-dispatch when its on stable release

Config.Inventory = 'mr-inventory/html/images/' -- qb-inventory/html/images/

Config.MinimumPolice = 0 -- Minimum police

Config.WaitTime = 10 -- Time to wait to get first contract, (in minutes)

Config.MaxContract = 5 -- Max contract that you can handle

Config.MaxQueueContract = 2 -- Max contract per session / per WaitTime

Config.Expire = 6 -- Expire time it'll be random, from 1 to this config

Config.MinRep = 20 -- Minimum reputation that you can get after finish contract

Config.MaxRep = 25 -- Maximum reputation that you can get after finish contract

Config.Payment = 'crypto' -- crypto / bank

Config.VINChance = 0.1 -- chance police to find out the VIN is scratched or no

Config.Timeout = 288

Config.Tier = {
    --[[
        Don't touch the tier name, just configure the location and car
    --]]
    ['D'] = {
        location = {
            [1] = {
                car = vector4(-935.1176, -1080.552,1.683342, 120.1060),
                npc = {
                    vector3(-924.21, -1088.11, 2.17),
                }
            },
            [2] = {
                car = vector4(-1077.27, -1143.9, 2.16, 203.94),
                npc = {
                    vector3(-1077.77, -1128.86, 2.16),
                }
            },
            [3] = {
                car = vector4(215.31, 758.66, 204.65, 38.15),
                npc = {
                    vector3(228.68, 765.78, 204.98),
                }
            },
            [4] = {
                car = vector4(-1144.5, -737.39, 20.21, 290.27),
                npc = {
                    vector3(-1159.14, -740.26, 19.89),
                }
            },
            [5] = {
                car = vector4(-727.06, -1061.14, 12.35, 31.44),
                npc = {
                    vector3(-738.16, -1068.43, 12.42),
                }
            },
            [6] = {
                car = vector4(-524.4, -883.63, 25.16, 156.43),
                npc = {
                    vector3(-535.84, -886.55, 25.21),
                }
            },
            [7] = {
                car = vector4(-446.69, -767.76, 30.56, 265.37),
                npc = {
                    vector3(-447.65, -789.61, 32.94),
                }
            },
            [8] = {
                car = vector4(-174.92, -156.66, 43.62, 67.47),
                npc = {
                    vector3(-194.97, -134.63, 43.98),
                }
            },
        },
        car = {
            'blista2',
            'buffalo2',
            'casco',
            'cogcabrio',
            'emperor',
            'felon2',
            'pcj',
            'feltzer2',
            'gauntlet',
            'huntley',
            'warrener2',
            'baller7',
            'hustler',
        },
        priceminimum = 5,
        pricemaximum = 10,
        spawnnpc = false,
        attempt = 2,
        vinprice = 50
    },
    ['C'] = {
        location = {
            [1] = {
                car = vector4(2.42, -1525.01, 29.35, 326.29),
                npc = {
                    vector3(0.86, -1502.77, 30.0),
                    vector3(12.44, -1532.56, 29.28),
                }
            },
            [2] = {
                car = vector4(-1658.969, -205.1732, 54.8448, 71.138),
                npc = {
                    vector3(-1679.17, -201.26, 57.54),
                    vector3(-1666.61, -185.91, 57.6),
                }
            },
            [3] = {
                car = vector4(-60.09, -1842.84, 26.58, 317.62),
                npc = {
                    vector3(-37.36, -1835.39, 26.02),
                    vector3(-53.74, -1822.3, 26.78),
                }
            },
            [4] = {
                car = vector4(-1977.01, 259.98, 87.22, 287.74),
                npc = {
                    vector3(-1969.96, 247.87, 87.61),
                    vector3(-1981.06, 248.86, 87.61),
                }
            },
            [5] = {
                car = vector4(-1197.86, 349.32, 71.14, 101.93),
                npc = {
                    vector3(-1208.21, 354.13, 71.23),
                    vector3(-1211.41, 322.84, 71.03),
                }
            },
            [6] = {
                car = vector4(232.96, 385.49, 106.41, 75.35),
                npc = {
                    vector3(223.97, 381.21, 106.52),
                    vector3(255.24, 375.49, 105.53),
                }
            },
            [7] = {
                car = vector4(138.55, 317.62, 112.13, 111.85),
                npc = {
                    vector3(152.35, 304.96, 112.13),
                    vector3(134.62, 322.93, 116.63),
                }
            },
            [8] = {
                car = vector4(152.46, 163.21, 104.85, 73.96),
                npc = {
                    vector3(156.63, 153.34, 105.08),
                    vector3(141.94, 178.25, 105.43),
                }
            },
        },
        car = {
            'alpha',
            'blade',
            'issi2',
            'Khamelion',
            'bati',
            'jester',
            'gauntlet3',
            'neo',
            'vacca',
            'rebla',
            'vectre',
            'zr350',
            'futo3',
            'massacro',
        },
        priceminimum = 8,
        pricemaximum = 12,
        spawnnpc = true,
        attempt = 3,
        vinprice = 80
    },
    ['B'] = {
        location = {
           [1] = {
               car = vector4(-111.13, 1003.88, 235.77, 106.21),
               npc = {
                    vector3(-113.14, 986.3, 235.75),
                    vector3(-105.28, 975.78, 235.76),
                    vector3(-99.48, 1017.46, 235.83),
               }
            },
            [2] = {
                car = vector4(-1132.24, -1069.61, 1.64, 118.41),
                npc = {
                    vector3(-1114.45, -1068.73, 2.15),
                    vector3(-1114.96, -1069.57, 2.15),
                    vector3(-1128.14, -1080.51, 4.22),
                }
            },
            [3] = {
                car = vector4(-938.82, -1081.12, 1.64, 120.7),
                npc = {
                    vector3(-930.52, -1100.65, 2.17),
                    vector3(-930.75, -1101.16, 2.17),
                    vector3(-929.81, -1100.85, 2.17),
                }
            },
            [4] = {
                car = vector4(-1073.63, -1160.21, 1.45, 297.77),
                npc = {
                    vector3(-1082.55, -1139.55, 2.16),
                    vector3(-1079.0, -1130.79, 2.16),
                    vector3(-1083.01, -1139.51, 2.16),
                }
            },
            [5] = {
                car = vector4(-1612.85, -377.97, 43.29, 209.39),
                npc = {
                    vector3(-1627.4, -363.09, 46.41),
                    vector3(-1622.86, -379.79, 43.72),
                    vector3(-1627.62, -364.46, 46.41),
                }
            },
            [6] = {
                car = vector4(-1491.65, -202.23, 50.32, 40.97),
                npc = {
                    vector3(-1466.34, -186.89, 48.83),
                    vector3(-1500.13, -201.78, 50.89),
                    vector3(-1473.24, -192.71, 48.84),
                }
            },
        },
        car = {
            'furoregt',
            'premier',
            'baller3',
            'lynx',
            'kuruma',
            'seven70',
            'banshee2',
            'omnis',
            'cinquemila',
            'rt3000',
            'dominator7',
            'z2879',
            'subwrx',
            'xa21',
            '2020g900',
        },
        priceminimum = 10,
        pricemaximum = 14,
        spawnnpc = true,
        attempt = 4,
        vinprice = 120
    },
    ['A'] = {
        location = {
            [1] = {
                car = vector4(-1491.65, -202.23, 50.32, 40.97),
                npc = {
                    vector3(-1466.34, -186.89, 48.83),
                    vector3(-1500.13, -201.78, 50.89),
                    vector3(-1473.24, -192.71, 48.84),
                    vector3(-1508.92, -204.42, 52.48),
                    vector3(-1508.85, -204.0, 52.44),
                },
            },
            [2] = {
                car = vector4(743.21, -1956.28, 29.22, 260.03),
                npc = {
                    vector3(743.16, -1905.97, 29.3),
                    vector3(743.17, -1906.42, 29.29),
                    vector3(751.45, -1967.38, 29.19),
                    vector3(729.41, -1974.01, 29.29),
                    vector3(722.59, -2016.81, 29.29),
                }
            },
            [3] = {
                car = vector4(568.73, -1947.62, 24.69, 356.92),
                npc = {
                    vector3(524.24, -1966.12, 26.55),
                    vector3(523.87, -1966.87, 26.55),
                    vector3(511.31, -1952.0, 24.99),
                    vector3(510.55, -1950.54, 24.99),
                    vector3(539.19, -1907.17, 25.07),
                }
            },
            [4] = {
                car = vector4(-2313.5, 283.3, 169.39, 67.74),
                npc = {
                    vector3(-2312.63, 326.66, 169.61),
                    vector3(-2292.97, 282.09, 169.6),
                    vector3(-2292.65, 281.15, 169.6),
                    vector3(-2312.33, 326.3, 169.61),
                    vector3(-2313.2, 327.23, 169.6),

                }
            },
            [5] = {
                car = vector4(-1484.66, 528.35, 118.19, 120.1),
                npc = {
                    vector3(-1493.63, 541.34, 118.27),
                    vector3(-1500.58, 523.03, 118.27),
                    vector3(-1501.64, 522.4, 118.27),
                    vector3(-1470.07, 508.74, 117.6),
                    vector3(-1492.9, 541.67, 118.27),
                }
            },
            [6] = {
                car = vector4(-981.22, 516.85, 81.32, 143.56),
                npc = {
                    vector3(-981.22, 516.85, 81.32),
                    vector3(-968.33, 511.19, 82.07),
                    vector3(-966.87, 509.7, 82.07),
                    vector3(-971.22, 533.97, 81.67),
                    vector3(-954.9, 506.81, 81.07),
                }
            },
            [12] = {
                car = vector4(-612.63, 520.35, 107.27, 170.36),
                npc = {
                    vector3(-585.58, 541.31, 109.62),
                    vector3(-614.2, 490.57, 108.82),
                    vector3(-594.77, 530.36, 107.79),
                    vector3(-585.17, 540.04, 109.1),
                    vector3(-584.97, 539.89, 108.97),
                }
            },
        },
        car = {
            'oracle',
            'sentinel2',
            'superd',
            'tyrus',
            'bestiagts',
            'specter2',
            'torero',
            'jugular',
            'penumbra2',
            'filthynsx',
            'gt63',
            'por930',
            'windsor2',
            'champion',
            'jubilee',
        },
        priceminimum = 12,
        pricemaximum = 15,
        spawnnpc = true,
        attempt = 5,
        vinprice = 150
    },
    ['A+'] = {
        location = {
            [1] = {
                car = vector4(-1491.65, -202.23, 50.32, 40.97),
                npc = {
                    vector3(-1466.34, -186.89, 48.83),
                    vector3(-1500.13, -201.78, 50.89),
                    vector3(-1473.24, -192.71, 48.84),
                    vector3(-1508.92, -204.42, 52.48),
                    vector3(-1508.85, -204.0, 52.44),
                },
            },
            [2] = {
                car = vector4(743.21, -1956.28, 29.22, 260.03),
                npc = {
                    vector3(743.16, -1905.97, 29.3),
                    vector3(743.17, -1906.42, 29.29),
                    vector3(751.45, -1967.38, 29.19),
                    vector3(729.41, -1974.01, 29.29),
                    vector3(722.59, -2016.81, 29.29),
                }
            },
            [3] = {
                car = vector4(568.73, -1947.62, 24.69, 356.92),
                npc = {
                    vector3(524.24, -1966.12, 26.55),
                    vector3(523.87, -1966.87, 26.55),
                    vector3(511.31, -1952.0, 24.99),
                    vector3(510.55, -1950.54, 24.99),
                    vector3(539.19, -1907.17, 25.07),
                }
            },
            [4] = {
                car = vector4(-2313.5, 283.3, 169.39, 67.74),
                npc = {
                    vector3(-2312.63, 326.66, 169.61),
                    vector3(-2292.97, 282.09, 169.6),
                    vector3(-2292.65, 281.15, 169.6),
                    vector3(-2312.33, 326.3, 169.61),
                    vector3(-2313.2, 327.23, 169.6),

                }
            },
            [5] = {
                car = vector4(-1484.66, 528.35, 118.19, 120.1),
                npc = {
                    vector3(-1493.63, 541.34, 118.27),
                    vector3(-1500.58, 523.03, 118.27),
                    vector3(-1501.64, 522.4, 118.27),
                    vector3(-1470.07, 508.74, 117.6),
                    vector3(-1492.9, 541.67, 118.27),
                }
            },
            [6] = {
                car = vector4(-981.22, 516.85, 81.32, 143.56),
                npc = {
                    vector3(-981.22, 516.85, 81.32),
                    vector3(-968.33, 511.19, 82.07),
                    vector3(-966.87, 509.7, 82.07),
                    vector3(-971.22, 533.97, 81.67),
                    vector3(-954.9, 506.81, 81.07),
                }
            },
            [7] = {
                car = vector4(-612.63, 520.35, 107.27, 170.36),
                npc = {
                    vector3(-585.58, 541.31, 109.62),
                    vector3(-614.2, 490.57, 108.82),
                    vector3(-594.77, 530.36, 107.79),
                    vector3(-585.17, 540.04, 109.1),
                    vector3(-584.97, 539.89, 108.97),
                }
            },
        },
        car = {
            'sentinel3',
            'xls',
            'tampa',
            'yosemite',
            'sultanrs',
            'neon',
            'riata',
            'turismor',
            'tempesta',
            'tailgater',
            'drafter',
            '22g63',
            'na1',
            'a80',
            'euros',
        },
        priceminimum = 14,
        pricemaximum = 18,
        spawnnpc = true,
        attempt = 5,
        vinprice = 180
    },
    ['S'] = {
        location = {
            [1] = {
                car = vector4(-1801.37, 457.55, 128.3, 85.66),
                npc = {
                    vector3(-1806.3, 439.24, 128.71),
                    vector3(-1789.95, 443.4, 128.31),
                    vector3(-1836.22, 447.76, 126.51),
                    vector3(-1804.23, 437.16, 128.71),
                    vector3(-1822.01, 437.24, 127.91),
                }
            },
            [2] = {
                car = vector4(-466.06, 645.17, 144.11, 47.52),
                npc = {
                    vector3(-477.41, 648.74, 144.39),
                    vector3(-465.78, 678.14, 148.47),
                    vector3(-457.93, 640.08, 144.19),
                    vector3(-477.31, 647.9, 144.39),
                    vector3(-468.61, 630.0, 144.38),                    
                }
            },
            [3] = {
                car = vector4(743.21, -1956.28, 29.22, 260.03),
                npc = {
                    vector3(743.16, -1905.97, 29.3),
                    vector3(751.45, -1967.38, 29.19),
                    vector3(729.41, -1974.01, 29.29),
                    vector3(722.59, -2016.81, 29.29),
                    vector3(722.06, -2016.08, 29.29),
                    }
            },
            [4] = {
                car = vector4(-851.49, 796.91, 192.58, 3.07),
                npc = {
                    vector3(-867.35, 785.1, 191.93),
                    vector3(-911.99, 778.03, 187.01),
                    vector3(-912.87, 778.25, 187.02),
                    vector3(-868.01, 784.85, 191.93),
                    vector3(-866.79, 784.91, 191.93),
                }
            },
            [5] = {
                car = vector4(987.67, -2546.25, 28.23, 356.63),
                npc = {
                    vector3(1017.45, -2529.25, 28.3),
                    vector3(1016.56, -2528.12, 28.3),
                    vector3(1009.14, -2531.1, 28.3),
                    vector3(946.55, -2527.7, 28.31),
                    vector3(949.38, -2527.94, 28.31),
                }
            },
            [6] = {
                car = vector4(854.93, -2306.03, 30.27, 174.44),
                npc = {
                    vector3(839.74, -2315.19, 30.48),
                    vector3(868.07, -2329.45, 30.35),
                    vector3(870.28, -2328.36, 30.35),
                    vector3(859.3, -2365.96, 30.35),
                    vector3(844.44, -2364.67, 30.35)
                }
            },
            [7] = {
                car = vector4(1086.7, -2319.49, 30.11, 265.55),
                npc = {
                    vector3(1084.08, -2301.5, 30.23),
                    vector3(1084.25, -2299.66, 30.23),
                    vector3(1084.58, -2299.14, 30.23),
                    vector3(1075.81, -2330.64, 30.29),
                    vector3(1077.92, -2334.28, 30.27),
                }
            },    
        },
        car = {
            'infernus2',
            'gauntlet5',
            'buffalo4',
            'gp1',
            'zentorno',
            'fmj',
            'italigtb2',
            'visione',
            'm3e46',
            'lc500',
            'lp700',
            'victor',
            'sheava',
            'issi7',
            'zeno',
        },
        priceminimum = 15,
        pricemaximum = 20,
        spawnnpc = true,
        attempt = 6,
        vinprice = 230
    },
    ['S+'] = {
        location = {
            [1] = {
                car = vector4(-1801.37, 457.55, 128.3, 85.66),
                npc = {
                    vector3(-1806.3, 439.24, 128.71),
                    vector3(-1789.95, 443.4, 128.31),
                    vector3(-1836.22, 447.76, 126.51),
                    vector3(-1804.23, 437.16, 128.71),
                    vector3(-1822.01, 437.24, 127.91),
                }
            },
            [2] = {
                car = vector4(-466.06, 645.17, 144.11, 47.52),
                npc = {
                    vector3(-477.41, 648.74, 144.39),
                    vector3(-465.78, 678.14, 148.47),
                    vector3(-457.93, 640.08, 144.19),
                    vector3(-477.31, 647.9, 144.39),
                    vector3(-468.61, 630.0, 144.38),                    
                }
            },
            [3] = {
                car = vector4(743.21, -1956.28, 29.22, 260.03),
                npc = {
                    vector3(743.16, -1905.97, 29.3),
                    vector3(751.45, -1967.38, 29.19),
                    vector3(729.41, -1974.01, 29.29),
                    vector3(722.59, -2016.81, 29.29),
                    vector3(722.06, -2016.08, 29.29),
                }
            },
            [4] = {
                car = vector4(-851.49, 796.91, 192.58, 3.07),
                npc = {
                    vector3(-867.35, 785.1, 191.93),
                    vector3(-911.99, 778.03, 187.01),
                    vector3(-912.87, 778.25, 187.02),
                    vector3(-868.01, 784.85, 191.93),
                    vector3(-866.79, 784.91, 191.93),
                }
            },
            [5] = {
                car = vector4(987.67, -2546.25, 28.23, 356.63),
                npc = {
                    vector3(1017.45, -2529.25, 28.3),
                    vector3(1016.56, -2528.12, 28.3),
                    vector3(1009.14, -2531.1, 28.3),
                    vector3(946.55, -2527.7, 28.31),
                    vector3(949.38, -2527.94, 28.31),
                }
            },
            [6] = {
                car = vector4(854.93, -2306.03, 30.27, 174.44),
                npc = {
                    vector3(839.74, -2315.19, 30.48),
                    vector3(868.07, -2329.45, 30.35),
                    vector3(870.28, -2328.36, 30.35),
                    vector3(859.3, -2365.96, 30.35),
                    vector3(844.44, -2364.67, 30.35)
                }
            },
            [7] = {
                car = vector4(1086.7, -2319.49, 30.11, 265.55),
                npc = {
                    vector3(1084.08, -2301.5, 30.23),
                    vector3(1084.25, -2299.66, 30.23),
                    vector3(1084.58, -2299.14, 30.23),
                    vector3(1075.81, -2330.64, 30.29),
                    vector3(1077.92, -2334.28, 30.27),
                }
            },
        },
        car = {
            'r8h',
            'e36prb',
            'r32',
            '488misha',
            's15rb',
            'sultan3',
            'remus',
            'zorrusso',
            'yosemite3',
            'nero',
            'growler',
            'coquette4',
            'sentinelsg4',
            'tezeract',
        },
        priceminimum = 16,
        pricemaximum = 22,
        spawnnpc = true,
        attempt = 6,
        vinprice = 260,
    },
    ['X'] = {
        location = {
            [1] = {
                car = vector4(1121.37, -784.87, 57.63, 356.84),
                npc = {
                    vector3(1134.51, -789.17, 57.6),
                    vector3(1135.14, -789.23, 57.6),
                    vector3(1142.36, -791.63, 57.6),
                    vector3(1142.6, -793.25, 57.6),
                    vector3(1130.2, -776.97, 57.61),
                    vector3(1130.67, -776.73, 57.61),
                    vector3(1142.71, -793.27, 57.6),
                }
            },
            [2] = {
                car = vector4(-93.43, -2549.05, 5.93, 51.89),
                npc = {
                    vector3(-120.87, -2523.97, 11.16),
                    vector3(-116.71, -2516.11, 6.1),
                    vector3(-126.84, -2530.58, 6.1),
                    vector3(-117.07, -2516.32, 6.1),
                    vector3(-145.53, -2524.54, 6.0),
                    vector3(-144.25, -2522.24, 6.0),
                    vector3(-144.75, -2522.88, 6.0),
                }
            },
            [3] = {
                car = vector4(-311.48, -2718.64, 5.92, 317.54),
                npc = {
                    vector3(-315.06, -2699.03, 7.55),
                    vector3(-315.96, -2698.19, 7.55),
                    vector3(-315.32, -2697.87, 7.55),
                    vector3(-318.44, -2718.22, 7.55),
                    vector3(-317.96, -2717.85, 7.55),
                    vector3(-292.99, -2689.79, 6.37),
                    vector3(-271.4, -2690.47, 6.36),
                }
            },
            [4] = {
                car = vector4(1095.79, -472.4, 66.85, 77.64),
                npc = {
                    vector3(1110.52, -465.21, 67.32),
                    vector3(1110.5, -464.7, 67.32),
                    vector3(1110.62, -464.03, 67.32),
                    vector3(1051.61, -470.91, 63.9),
                    vector3(1051.46, -470.29, 64.1),
                    vector3(1098.42, -464.49, 67.32),
                    vector3(1110.4, -464.76, 67.32),
                }
            },
            [5] = {
                car = vector4(954.73, -598.48, 59.3, 26.89),
                npc = {
                    vector3(966.22, -608.35, 59.59),
                    vector3(966.52, -608.2, 59.49),
                    vector3(965.52, -608.54, 59.71),
                    vector3(965.34, -608.42, 59.9),
                    vector3(919.96, -570.0, 58.37),
                    vector3(956.79, -547.08, 59.36),
                    vector3(956.69, -547.61, 59.36),
                }
            },
            [6] = {
                car = vector4(-837.38, -39.15, 39.12, 300.03),
                npc = {
                    vector3(-882.63, -51.07, 38.05),
                    vector3(-882.9, -49.83, 38.05),
                    vector3(-883.39, -48.75, 38.05),
                    vector3(-888.04, -50.67, 38.05),
                    vector3(-888.66, -51.08, 38.05),
                    vector3(-861.21, -31.46, 40.56),
                    vector3(-862.46, -33.28, 40.56),
                }
            },
            [7] = {
                car = vector4(-955.04, 188.25, 66.51, 83.31),
                npc = {
                    vector3(-923.77, 213.33, 67.47),
                    vector3(-924.76, 213.51, 67.46),
                    vector3(-923.01, 212.59, 67.46),
                    vector3(-940.19, 202.27, 67.86),
                    vector3(-939.91, 202.75, 67.86),
                    vector3(-939.92, 202.45, 67.86),
                    vector3(-926.79, 213.46, 67.46),                    
                }
            },
        },
        car = {
            'm5e60',
            'deluxo6str',
            'r35',
            'fnf4r34',
            'cyclone2',
            'nero2',
            'furia',
            'schwarzer2',
            'ignus',
            'penetrator',
            'comet7',
            'jester4',
            'calico',
            'prototipo',
        },
        priceminimum = 18,
        pricemaximum = 25,
        spawnnpc = true,
        attempt = 8,
        vinprice = 300,
    }
}

Config.DropPoint = {
    -- pz
    -- [1] = {
    --     coords = vector3(496.87, -2190.75, 5.92),
    --     length = 11.6,
    --     width = 5,
    --     name = "droppoint",
    --     heading = 331,
    --     minZ=4.67,
    --     maxZ=8.67
    -- },
    -- [2] = {
    --     coords = vector3(1216.25, -2947.09, 5.87),
    --     length = 12.05,
    --     width = 10,
    --     name = "droppoint2",
    --     heading = 0,
    --     minZ=4.87,
    --     maxZ=8.47
    -- }

    [1] = {
        coords = vector3(1630.75, 3790.14, 34.2),
        length = 7.0,
        width = 10.0,
        name = "droppoint",
        heading = 35,
        minZ= 33.0,
        maxZ= 35.5
    },
    [2] = {
        coords = vector3(1725.1, 4805.75, 41.12),
        length = 14.0,
        width = 9.6,
        name = "droppoint2",
        heading =355,
        minZ=40.0,
        maxZ=43.0
    },
    [3] = {
        coords = vector3(-199.87, 6226.01, 30.93),
        length = 10.2,
        width = 9.8,
        name = "droppoint3",
        heading =135,
        minZ=29.0,
        maxZ=33.0
    },
    [4] = {
        coords = vector3(-2527.33, 2343.15, 32.5),
        length = 10.6,
        width = 9.6,
        name = "droppoint4",
        heading =34,
        minZ=30.0,
        maxZ=35.0
    },
    [5] = {
        coords = vector3(-2195.28, 4266.34, 47.94),
        length = 9.8,
        width = 9.4,
        name = "droppoint5",
        heading =330,
        minZ=45.0,
        maxZ=49.0
    },
    [6] = {
        coords = vector3(2503.66, 4213.61, 39.35),
        length = 9.2,
        width = 10,
        name = "droppoint6",
        heading =60,
        minZ=37.0,
        maxZ=41.0
    },
    [7] = {
        coords = vector3(1692.54, 3285.58, 40.58),
        length = 10.6,
        width = 10,
        name = "droppoint7",
        heading =30,
        minZ=39.0,
        maxZ=43.0
    },
    [8] = {
        coords = vector3(1736.19, 3691.22, 33.95),
        length = 10.0,
        width = 10,
        name = "droppoint8",
        heading =25,
        minZ=31.0,
        maxZ=35.0
    }
}

Config.ScratchingPoint = {
    -- pz 
    -- [1] = {
    --     coords = vector3(1430.56, 6332.89, 23.99),
    --     length = 10.6,
    --     width = 11.8,
    --     name = "scratchingpoint",
    --     heading = 0,
    --     minZ= 21.29,
    --     maxZ = 24.99
    -- },
    -- [2] = {
    --     coords = vector3(1637.43, 4850.97, 42.02),
    --     length = 9.95,
    --     width = 7.8,
    --     name = "scratchingpoint2",
    --     heading = 10,
    --     minZ= 39.42,
    --     maxZ = 43.42
    -- }
    [1] = {
        coords = vector3(1181.61, 2640.35, 37.19),
        length = 10.2,
        width = 6.8,
        name = "scratchingpoint",
        heading = 0,
        minZ= 36.0,
        maxZ = 38.0
    },
    [2] = {
        coords = vector3(731.44, -1070.78, 21.61),
        length = 12.0,
        width = 14.2,
        name = "scratchingpoint2",
        heading = 0,
        minZ= 20.0,
        maxZ = 23.0
    },
    [3] = {
        coords = vector3(1204.41, -3117.41, 4.98),
        length = 10.4,
        width = 9.8,
        name = "scratchingpoint3",
        heading = 0,
        minZ= 3.0,
        maxZ = 6.0
    }
}

Config.BennysSell = {
    -- ["brake1"] = {
    --     item = 'brake1',
    --     price = 1000,
    --     stock = 50
    -- },
    -- ["brake2"] = {
    --     item = 'brake2',
    --     price = 1000,
    --     stock = 50,
    -- },
    -- ["brake3"] = {
    --     item = 'brake3',
    --     price = 1000,
    --     stock = 50,
    -- },
    -- ["engine4"] = {
    --     item = 'engine4',
    --     price = 502000,
    --     stock = 50,
    -- },
    -- ["engine0"] = {
    --     item = 'engine0',
    --     price = 130000,
    --     stock = 50,
    -- },
    -- ["engine1"] = {
    --     item = 'engine1',
    --     price = 120000,
    --     stock = 50,
    -- },
    -- ["engine2"] = {
    --     item = 'engine2',
    --     price = 100000,
    --     stock = 50,
    -- },
    -- ["engine3"] = {
    --     item = 'engine3',
    --     price = 100000,
    --     stock = 50,
    -- },
    ["advancedrepairkit"] = {
        item = 'advancedrepairkit', --Item name on your shared/items.lua
        image = 'np_repair-toolkit.png', --Item image
        price = 300, --Item price
        stock = 50 -- Item stock
    },
    ["fake_plate"] = {
        item = "fake_plate",
        price = 150,
        stock = 50,
    }

}

Config.RandomName = {
    'Alfred',
    'Barry',
    'Carl',
    'Dennis',
    'Edgar',
    'Frederick',
    'George',
    'Herbert',
    'Irving',
    'John',
    'Kevin',
    'Larry',
    'Michael',
    'Norman',
    'Oscar',
    'Patricia',
    'Quinn',
    'Robert',
    'Steven',
    'Thomas',
}