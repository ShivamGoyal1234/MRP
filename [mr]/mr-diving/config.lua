MRBoatshop = MRBoatshop or {}
MRDiving = MRDiving or {}

MRBoatshop.PoliceBoat = vector3(-800.67, -1494.54, 1.59)

MRBoatshop.PoliceBoatSpawn = vector4(-793.58, -1501.4, 0.12, 111.5)

MRBoatshop.PoliceBoat2 = vector3(-279.41, 6635.09, 7.51)


MRBoatshop.PoliceBoatSpawn2 = vector4(-293.10, 6642.69, 0.15, 65.5)
MRBoatshop.TimingMin = 600.00
MRBoatshop.TimingMax = 900.00
MRBoatshop.Docks = {
    ["lsymc"] = {
        label = "LSYMC Boathouse",
        coords = {
            take = vector3(-794.66, -1510.83, 1.59),
            put = vector4(-793.58, -1501.4, 0.12, 111.5)
        }
    },
    ["paletto"] = {
        label = "Paleto Boathouse",
        coords = {
            take = vector3(-277.46, 6637.2, 7.48),
            put = vector4(-289.2, 6637.96, 1.01, 45.5)
        }
    },
    ["millars"] = {
        label = "Millars Boathouse",
        coords = {
            take = vector3(1299.24, 4216.69, 33.9),
            put = vector4(1297.82, 4209.61, 30.12, 253.5),
        }
    },
}

MRBoatshop.Depots = {
    [1] = {
        label = "LSYMC Impound",
        coords = {
            take = vector3(-772.98, -1430.76, 1.59),
            put = vector4(-729.77, -1355.49, 1.19, 142.5)
        }
    },
}

MRBoatshop.Locations = {
    ["berths"] = {
        [1] = {
            ["boatModel"] = "marquis",
            ["coords"] = {
                ["boat"] = {
                    ["x"] = -727.05,
                    ["y"] = -1326.59,
                    ["z"] = 1.06,
                    ["h"] = 229.5
                },
                ["buy"] = {
                    ["x"] = -723.3,
                    ["y"] = -1323.61,
                    ["z"] = 1.59,
                }
            },
            ["inUse"] = false
        },
        [2] = {
            ["boatModel"] = "speeder",
            ["coords"] = {
                ["boat"] = {
                    ["x"] = -732.84, 
                    ["y"] = -1333.5, 
                    ["z"] = 1.59, 
                    ["h"] = 229.5
                },
                ["buy"] = {
                    ["x"] = -729.19, 
                    ["y"] = -1330.58, 
                    ["z"] = 1.67, 
                },
            },
            ["inUse"] = false
        },
        [3] = {
            ["boatModel"] = "dinghy",
            ["coords"] = {
                ["boat"] = {
                    ["x"] = -737.84, 
                    ["y"] = -1340.83, 
                    ["z"] = 0.79, 
                    ["h"] = 229.5
                },
                ["buy"] = {
                    ["x"] = -734.98, 
                    ["y"] = -1337.42, 
                    ["z"] = 1.67, 
                },
            },
            ["inUse"] = false
        },
        [4] = {
            ["boatModel"] = "seashark3",
            ["coords"] = {
                ["boat"] = {
                    ["x"] = -743.53, 
                    ["y"] = -1347.7, 
                    ["z"] = 0.79, 
                    ["h"] = 229.5
                },
                ["buy"] = {
                    ["x"] = -740.62, 
                    ["y"] = -1344.28, 
                    ["z"] = 1.67, 
                },
            },
            ["inUse"] = false
        },
        [5] = {
            ["boatModel"] = "toro",
            ["coords"] = {
                ["boat"] = {
                    ["x"] = -749.59, 
                    ["y"] = -1354.88, 
                    ["z"] = 0.79, 
                    ["h"] = 229.5
                },
                ["buy"] = {
                    ["x"] = -746.6, 
                    ["y"] = -1351.36, 
                    ["z"] = 1.59, 
                },
            },
            ["inUse"] = false
        },
        [6] = {
            ["boatModel"] = "tropic",
            ["coords"] = {
                ["boat"] = {
                    ["x"] = -755.39, 
                    ["y"] = -1361.76, 
                    ["z"] = 0.79, 
                    ["h"] = 229.5
                },
                ["buy"] = {
                    ["x"] = -752.49,
                    ["y"] = -1358.28,
                    ["z"] = 1.59,
                },
            },
            ["inUse"] = false
        },
        -- [7] = {
        --     ["boatModel"] = "dinghy",
        --     ["coords"] = {
        --         ["boat"] = {
        --             ["x"] = -769.06, 
        --             ["y"] = -1377.97, 
        --             ["z"] = 0.79, 
        --             ["h"] = 229.5
        --         },
        --         ["buy"] = {
        --             ["x"] = -723.3,
        --             ["y"] = -1323.61,
        --             ["z"] = 1.59,
        --         }
        --     },
        --     ["inUse"] = false
        -- },
        -- [8] = {
        --     ["boatModel"] = "dinghy",
        --     ["coords"] = {
        --         ["boat"] = {
        --             ["x"] = -774.99, 
        --             ["y"] = -1385.0, 
        --             ["z"] = 0.79, 
        --             ["h"] = 229.5
        --         },
        --         ["buy"] = {
        --             ["x"] = -723.3,
        --             ["y"] = -1323.61,
        --             ["z"] = 1.59,
        --         }
        --     },
        --     ["inUse"] = false
        -- },
        -- [9] = {
        --     ["boatModel"] = "dinghy",
        --     ["coords"] = {
        --         ["boat"] = {
        --             ["x"] = -780.66, 
        --             ["y"] = -1391.73, 
        --             ["z"] = 0.79, 
        --             ["h"] = 229.5
        --         },
        --         ["buy"] = {
        --             ["x"] = -723.3,
        --             ["y"] = -1323.61,
        --             ["z"] = 1.59,
        --         }
        --     },
        --     ["inUse"] = false
        -- },
        -- [10] = {
        --     ["boatModel"] = "dinghy",
        --     ["coords"] = {
        --         ["boat"] = {
        --             ["x"] = -786.47, 
        --             ["y"] = -1398.6, 
        --             ["z"] = 0.79, 
        --             ["h"] = 229.5
        --         },
        --         ["buy"] = {
        --             ["x"] = -723.3,
        --             ["y"] = -1323.61,
        --             ["z"] = 1.59,
        --         }
        --     },
        --     ["inUse"] = false
        -- },
        -- [11] = {
        --     ["boatModel"] = "dinghy",
        --     ["coords"] = {
        --         ["boat"] = {
        --             ["x"] = -792.27, 
        --             ["y"] = -1405.48, 
        --             ["z"] = 0.79, 
        --             ["h"] = 229.5
        --         },
        --         ["buy"] = {
        --             ["x"] = -723.3,
        --             ["y"] = -1323.61,
        --             ["z"] = 1.59,
        --         }
        --     },
        --     ["inUse"] = false
        -- },
        -- [12] = {
        --     ["boatModel"] = "dinghy",
        --     ["coords"] = {
        --         ["boat"] = {
        --             ["x"] = -798.33, 
        --             ["y"] = -1412.67, 
        --             ["z"] = 0.79, 
        --             ["h"] = 229.5
        --         },
        --         ["buy"] = {
        --             ["x"] = -723.3,
        --             ["y"] = -1323.61,
        --             ["z"] = 1.59,
        --         }
        --     },
        --     ["inUse"] = false
        -- },
    }
}

MRBoatshop.ShopBoats = {
    ["dinghy"] = {
        ["model"] = "dinghy",
        ["label"] = "Dinghy",
        ["price"] = 80000
    },
    ["speeder"] = {
        ["model"] = "speeder",
        ["label"] = "Speeder",
        ["price"] = 150000
    },
    ["marquis"] = {
        ["model"] = "marquis",
        ["label"] = "Marquis",
        ["price"] = 250000
    },
    ["seashark3"] = {
        ["model"] = "seashark3",
        ["label"] = "Seashark3",
        ["price"] = 150000
    },
    ["toro"] = {
        ["model"] = "toro",
        ["label"] = "Toro",
        ["price"] = 120000
    },
    ["tropic"] = {
        ["model"] = "tropic",
        ["label"] = "Tropic",
        ["price"] = 120000
    }, 
}

MRBoatshop.SpawnVehicle = vector4(-729.77, -1355.49, 1.19, 142.5)

MRDiving.Locations = {
    [1] = {
        label = "This is Location 1",
        coords = {
            Area = vector3(-2838.8, -376.1, 3.55),
            Coral = {
                [1] = {
                    coords = vector3(-2849.25, -377.58, -40.23),
                    PickedUp = false
                },
                [2] = {
                    coords = vector3(-2838.43, -363.63, -39.45),
                    PickedUp = false
                },
                [3] = {
                    coords = vector3(-2887.04, -394.87, -40.91),
                    PickedUp = false
                },
                [4] = {
                    coords = vector3(-2808.99, -385.56, -39.32),
                    PickedUp = false
                },
            }
        },
        DefaultCoral = 4,
        TotalCoral = 4,
    },
    [2] = {
        label = "Location 2",
        coords = {
            Area = vector3(-3288.2, -67.58, 2.79),
            Coral = {
                [1] = {
                    coords = vector3(-3275.03, -38.58, -19.21),
                    PickedUp = false
                },
                [2] = {
                    coords = vector3(-3273.73, -76.0, -26.81),
                    PickedUp = false
                },
                [3] = {
                    coords = vector3(-3346.53, -50.4, -35.84),
                    PickedUp = false
                },
            }
        },
        DefaultCoral = 3,
        TotalCoral = 3,
    },
    [3] = {
        label = "Location 3",
        coords = {
            Area = vector3(-3367.24, 1617.89, 1.39),
            Coral = {
                [1] = {
                    coords = vector3(-3388.01, 1635.88, -39.41),
                    PickedUp = false
                },
                [2] = {
                    coords = vector3(-3354.19, 1549.3, -38.21),
                    PickedUp = false
                },
                [3] = {
                    coords = vector3(-3326.04, 1636.43, -40.98),
                    PickedUp = false
                },
            }
        },
        DefaultCoral = 3,
        TotalCoral = 3,
    },
    [4] = {
        label = "Location 4",
        coords = {
            Area = vector3(3002.5, -1538.28, -27.36),
            Coral = {
                [1] = {
                    coords = vector3(2978.05, -1509.07, -24.96),
                    PickedUp = false
                },
                [2] = {
                    coords = vector3(3004.42, -1576.95, -29.36),
                    PickedUp = false
                },
                [3] = {
                    coords = vector3(2951.65, -1560.69, -28.36),
                    PickedUp = false
                },
            }
        },
        DefaultCoral = 3,
        TotalCoral = 3,
    },
    [5] = {
        label = "Location 5",
        coords = {
            Area = vector3(3421.58, 1975.68, 0.86),
            Coral = {
                [1] = {
                    coords = vector3(3421.69, 1976.54, -50.64),
                    PickedUp = false
                },
                [2] = {
                    coords = vector3(3424.07, 1957.46, -53.04),
                    PickedUp = false
                },
                [3] = {
                    coords = vector3(3434.65, 1993.73, -49.84),
                    PickedUp = false
                },
                [4] = {
                    coords = vector3(3415.42, 1965.25, -52.04),
                    PickedUp = false
                },
            }
        },
        DefaultCoral = 4,
        TotalCoral = 4,
    },
    [6] = {
        label = "Location 6",
        coords = {
            Area = vector3(2720.14, -2136.28, 0.74),
            Coral = {
                [1] = {
                    coords = vector3(2724.0, -2134.95, -19.33),
                    PickedUp = false
                },
                [2] = {
                    coords = vector3(2710.68, -2156.06, -18.63),
                    PickedUp = false
                },
                [3] = {
                    coords = vector3(2702.84, -2139.29, -18.51),
                    PickedUp = false
                },
                [4] = {
                    coords = vector3(2736.27, -2153.91, -20.88),
                    PickedUp = false
                },
            }
        },
        DefaultCoral = 4,
        TotalCoral = 4,
    },
    [7] = {
        label = "Location 7",
        coords = {
            Area = vector3(536.69, 7253.75, 1.69),
            Coral = {
                [1] = {
                    coords = vector3(542.31, 7245.37, -30.01),
                    PickedUp = false
                },
                [2] = {
                    coords = vector3(528.21, 7223.26, -29.51),
                    PickedUp = false
                },
                [3] = {
                    coords = vector3(510.36, 7254.97, -32.11),
                    PickedUp = false
                },
                [4] = {
                    coords = vector3(525.37, 7259.12, -30.51),
                    PickedUp = false
                },
            }
        },
        DefaultCoral = 4,
        TotalCoral = 4,
    },
}

--ALSO CHANGE VALUES IN SERVER/MAIN.LUA
MRDiving.CoralTypes = {
    [1] = {
        item = "dendrogyra_coral",
        maxAmount = math.random(1, 5),
        price = math.random(70, 100),
    },
    [2] = {
        item = "antipatharia_coral",
        maxAmount = math.random(2, 7),
        price = math.random(50, 70),
    }
}

MRDiving.SellLocations = {
    [1] = {
    ["coords"] = vector3(-1684.13, -1068.91, 13.15)
        -- ["x"] = -1684.13,
        -- ["y"] = -1068.91,
        -- ["z"] = 13.15
}
}

MRDiving.SellCoral = false
