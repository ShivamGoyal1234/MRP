Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
Config = {}
-----------------------------------------government----------------------------------------
Config.Locationsgov = {
    ["exit"] = {x = -515.81, y = -255.14, z = 35.62, h = 295.63, r = 1.0},
    ["stash"] = {x = -534.35, y = -192.17, z = 47.42, h = 295.51, r = 1.0},
    ["uwustash"] = {x = -588.58, y = -1068.38, z = 22.34, h = 282.1, r = 1.0},  --vector4(-588.58, -1068.38, 22.34, 282.1)
    ["mwstash"] = {x = -2354.78, y = 3258.81, z =  92.9, h = 142.35, r = 1.0},  --vector4(-2354.78, 3258.81, 92.9, 142.35)
    ["vehiclemw"] = {x = -2185.81, y = 3172.28, z =  32.81, h = 130.5, r = 1.0},  --vector4(-2185.81, 3172.28, 32.81, 130.5)
    ["vehiclepdm"] = {x = -13.24, y = -1080.84, z = 27.05, h = 63.56, r = 1.0},  --vector4(-13.24, -1080.84, 27.05, 63.56)
    ["duty"] = {x = -1293.73, y = -570.85, z = 30.57, h = 348.98, r = 1.0},
    ["vehicle"] = {x = -1313.89, y = -562.33, z = 20.8, h = 215.27, r = 1.0},
    ["vehicle"] = {x = -460.71, y = -272.82, z = 35.78, h = 34.57, r = 1.0},  --vector4(-460.71, -272.82, 35.78, 34.57)
    ["vehicleuwu"] = {x = -604.4, y = -1089.81, z = 22.18, h = 224.45, r = 1.0},  --vector4(-604.4, -1089.81, 22.18, 224.45)
    ["pstash"] = {x = -1301.70, y = -568.60, z = 41.19, h = 44.83, r = 1.0}, 
    ["armory"] = {x = -1306.19, y = -565.25, z = 41.19, h = 299.8, r = 1.0}, 
    ["armory1"] = {x = -1301.06, y = -555.56, z = 30.57, h = 40.53, r = 1.0}, 
    ["armory2"] = {x = -1828.82, y = 4530.87, z =  5.39, h = 359.75, r = 1.0},  --vector4(-1828.82, 4530.87, 5.39, 359.75)
    ["ptstash"] = {x = -1290.27, y = -585.8, z = 37.37, h = 212.39, r = 1.0},
    ["psstash"] = {x = -1285.16, y = -590.76, z = 37.38, h = 221.1, r = 1.0},
    ["psmtash"] = {x = -1285.74, y = -590.83, z = 41.19, h = 215.83, r = 1.0},
    ["psetash"] = {x = -1285.41, y = -590.83, z = 34.37, h = 213.17, r = 1.0},
    ["psutash"] = {x = -1302.62, y = -557.01, z = 30.57, h = 36.73, r = 1.0},
    ["govtash"] = {x = -1294.61, y = -582.07, z = 34.37, h = 124.28, r = 1.0},
    ["mwstash"] = {x = -1825.13, y = 4530.31, z = 5.33, h = 359.12, r = 1.0}, --vector4(-1825.13, 4530.31, 5.33, 359.12)
}

Config.Vehiclesgov = {
    ["onebeast"] = "Mayor Car",
    ["bmwm5"] = "Security Chief Car",
    ["secrsub"] = "Security SUV",
    ["gmcyd"] = "Employee SUV",
    ["rs7"] = "Secretery Car",
    ["745le"] = "Advocate Car",
    ["s11mg"] = "Scorpio",
}

Config.Vehiclesuwu = {
    ["landstalker2"] = "Land Stalker",
    ["tailgater"] = "Tail Gator",
    -- ["secrsub"] = "Security SUV",
    -- ["gmcyd"] = "Employee SUV",
    -- ["rs7"] = "Secretery Car",
    -- ["745le"] = "Advocate Car",
    -- ["s11mg"] = "Scorpio",
}

Config.Vehiclesmw = {
    ["cog55"] = "Cognoscenti 55",
    ["gresley"] = "Grasely",
    ["swift"] = "swift",
    ["baller4"] = "Baller LE",
    ["policeinsurgent"] = "Insurent"
    -- ["rs7"] = "Secretery Car",
    -- ["745le"] = "Advocate Car",
    -- ["s11mg"] = "Scorpio",
}

Config.Vehiclespdm = {
    ["baller3"] = "Baller ",
    ["tailgater2"] = "Tailgater",
    -- ["swift"] = "swift",
    -- ["baller4"] = "Baller LE",
    -- ["rs7"] = "Secretery Car",
    -- ["745le"] = "Advocate Car",
    -- ["s11mg"] = "Scorpio",
}

Config.Itemsgov = {
    label = "Governor Armory",
    slots = 30,
    items = {
        [1] = {
            name = "bandage",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 1,
        },
        [2] = {
            name = "weapon_assaultsmg",
            price = 0,
            amount = 50,
            info = {
                serie = "",
            },
            type = "weapon",
            slot = 2,
        },
        [3] = {
            name = "ifak",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 3,
        },
        [4] = {
            name = "radio",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 4,
        },
        [5] = {
            name = "bodycam",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 5,
        },
        [6] = {
            name = "weapon_heavypistol",
            price = 0,
            amount = 50,
            info = {},
            type = "weapon",
            slot = 6,
        },
        [7] = {
            name = "pistol_ammo",
            price = 20,
            amount = 50,
            info = {},
            type = "item",
            slot = 7,
        },
        [8] = {
            name = "smg_ammo",
            price = 20,
            amount = 50,
            info = {},
            type = "item",
            slot = 8,
        },
        [9] = {
            name = "shotgun_ammo",
            price = 20,
            amount = 50,
            info = {},
            type = "item",
            slot = 9,
        },
        [10] = {
            name = "rifle_ammo",
            price = 20,
            amount = 50,
            info = {},
            type = "item",
            slot = 10,
        },
        [11] = {
            name = "weapon_bullpupshotgun",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 11,
        },
        [12] = {
            name = "weapon_mg",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 12,
        },
        [13] = {
            name = "weapon_heavysniper",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 13,
        },
        [14] = {
            name = "weapon_specialcarbine",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 14,
        },
        [15] = {
            name = "heavyarmor",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 15,
        },
        [16] = {
            name = "weapon_stungun",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 16,
        },
        [17] = {
            name = "handcuffs",
            price = 50,
            amount = 10,
            info = {},
            type = "item",
            slot = 17,
        },
    }
}

Config.Items1gov = {
    label = "Security Armory",
    slots = 30,
    items = {
        [1] = {
            name = "bandage",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 1,
        },
        [2] = {
            name = "weapon_assaultsmg",
            price = 0,
            amount = 50,
            info = {
                serie = "",
            },
            type = "weapon",
            slot = 2,
        },
        [3] = {
            name = "ifak",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 3,
        },
        [4] = {
            name = "radio",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 4,
        },
        [5] = {
            name = "bodycam",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 5,
        },
        [6] = {
            name = "weapon_heavypistol",
            price = 0,
            amount = 50,
            info = {},
            type = "weapon",
            slot = 6,
        },
        [7] = {
            name = "pistol_ammo",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 7,
        },
        [8] = {
            name = "smg_ammo",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 8,
        },
        [9] = {
            name = "shotgun_ammo",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 9,
        },
        [10] = {
            name = "rifle_ammo",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 10,
        },
        [11] = {
            name = "weapon_bullpupshotgun",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 11,
        },
        [12] = {
            name = "weapon_specialcarbine",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 12,
        },
        [13] = {
            name = "weapon_stungun",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 13,
        },
        [14] = {
            name = "heavyarmor",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 14,
        },
    }
}
Config.Itemsmw = {
    label = "MW Armory",
    slots = 30,
    items = {
        [1] = {
            name = "armor",
            price = 50,
            amount = 20,
            info = {},
            type = "item",
            slot = 1,
        },
        [2] = {
            name = "handcuffs",
            price = 50,
            amount = 20,
            info = {
                serie = "",
            },
            type = "item",
            slot = 2,
        },
    }
}
