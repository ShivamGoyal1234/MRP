Config = {}

Config.payMin = 150
Config.payMax = 200

Config.RunMin = 8
Config.RunMax = 15

Config.DropMin = 1
Config.DropMax = 4

Config.JobRequired = false

Config.Locations = {
    ['start'] = vector3(892.42, -2171.81, 32.29),
    ['spawn'] = vector4(877.52, -2193.07, 30.23, 84.22),
    ['submit'] = vector3(878.9, -2176.62, 30.23),
}

Config.BlipSetting = {
    ['hq'] = {
        sprite  = 318,
        display = 4,
        scale   = 0.9,
        color   = 25,
        text    = 'Garbage HQ'
    },
    ['mission'] = {
        routeColor = 25,
        color = 25
    },
    ['dump'] = {
        sprite  = 420,
        scale   = 0.9,
        routeColor = 25,
        color = 25
    },
    ['submit'] = {
        routeColor = 25,
        color = 25
    }
}

Config.Areas = {
    [1] = vector3(114.83280181885, -1462.3127441406, 29.295083999634),
    [2] = vector3(-6.0481648445129, -1566.2338867188, 29.209197998047),
    [3] = vector3(-1.8858588933945, -1729.5538330078, 29.300233840942),
    [4] = vector3(159.09, -1816.69, 27.9),
    [5] = vector3(358.94696044922, -1805.0723876953, 28.966590881348),
    [6] = vector3(481.36560058594, -1274.8297119141, 29.64475440979),
    [7] = vector3(254.70010375977, -985.32482910156, 29.196590423584),
    [8] = vector3(240.08079528809, -826.91204833984, 30.018426895142),
    [9] = vector3(342.78308105469, -1036.4720458984, 29.194206237793),
    [10] = vector3(462.17517089844, -949.51434326172, 27.959424972534),
    [11] = vector3(317.53698730469, -737.95416259766, 29.278547286987),
    [12] = vector3(410.22503662109, -795.30517578125, 29.20943069458),
    [13] = vector3(398.36038208008, -716.35577392578, 29.282489776611),
    [14] = vector3(443.96984863281, -574.33978271484, 28.494501113892),
    [15] = vector3(-1332.53, -1198.49, 4.62),
    [16] = vector3(-45.443946838379, -191.32261657715, 52.161594390869),
    [17] = vector3(-31.948055267334, -93.437454223633, 57.249073028564),
    [18] = vector3(283.10873413086, -164.81878662109, 60.060565948486),
    [19] = vector3(441.89678955078, 125.97653198242, 99.887702941895),
}

Config.Dumpsters = {
    [1] = `prop_cs_dumpster_01a`,
    [2] = `prop_dumpster_01a`,
    [3] = `prop_dumpster_02a`,
    [4] = `prop_dumpster_02b`,
    [5] = `prop_dumpster_3a`,
    [6] = `prop_dumpster_4a`,
    [7] = `prop_dumpster_4b`,
    [8] = `prop_snow_dumpster_01`,
    [9] = `prop_bin_01a`,
    [10] = `prop_bin_02a`,
    [11] = `prop_bin_03a`,
    [12] = `prop_bin_04a`,
    [13] = `prop_bin_05a`,
    [14] = `prop_bin_06a`,
    [15] = `prop_bin_07a`,
    [16] = `prop_bin_07b`,
    [17] = `prop_bin_07c`,
    [18] = `prop_bin_07d`,
    [19] = `prop_bin_08a`,
    [20] = `prop_bin_08open`,
    [21] = `prop_bin_09a`,
    [22] = `prop_bin_10a`,
    [23] = `prop_bin_10b`,
    [24] = `prop_bin_11a`,
    [25] = `prop_bin_11b`,
    [26] = `prop_bin_12a`,
    [27] = `prop_cs_bin_03`,
    [28] = `prop_recyclebin_01a`,
    [29] = `prop_recyclebin_02_c`,
    [30] = `prop_recyclebin_02_d`,
    [31] = `prop_recyclebin_02a`,
    [32] = `prop_recyclebin_02b`,
    [33] = `prop_recyclebin_03_a`,
    [34] = `prop_recyclebin_04_a`,
    [35] = `prop_recyclebin_04_b`,
    [36] = `prop_bin_01a_old`,
}

Config.Truck = `trash`
Config.Bag = `hei_prop_heist_binbag`