Config = {}

Config.VendingObjects = {
    "prop_vend_soda_01",
    "prop_vend_soda_02",
    "prop_vend_water_01"
}

Config.BinObjects = {
    "prop_bin_05a",
}

Config.VendingItem = {
    [1] = {
        name = "kurkakola",
        price = 45,
        amount = 50,
        info = {},
        type = "item",
        slot = 1,
    },
    [2] = {
        name = "water_bottle",
        price = 45,
        amount = 50,
        info = {},
        type = "item",
        slot = 2,
    },
}

Config.CraftingItems = {
    
    [1] = {
        name = "handcuffs",
        amount = 2,
        info = {},
        costs = {
            ["metalscrap"] = 10,
            ["aluminum"] = 10,
            ["steel"] = 10,
        },
        type = "item",
        slot = 1,
        threshold = 0,
        points = 1,
    },

    [2] = {
        name = "bolt_cutter",
        amount = 1,
        info = {
            uses = 20
        },
        costs = {
            ["rubber"] = 4,
            ["metalscrap"] = 40,
            ["aluminum"] = 10,
            ["steel"] = 10,
        },
        type = "item",
        slot = 2,
        threshold = 15,
        points = 1,
    },

    [3] = {
        name = "electronickit",
        amount = 1,
        info = {
            uses = 10
        },
        costs = {
            ["metalscrap"] = 20,
            ["plastic"] = 18,
            ["aluminum"] = 12,
            ["wire"] = 8,
            ["copper"] = 12,
        },
        type = "item",
        slot = 3,
        threshold = 25,
        points = 1,
    },

    [4] = {
        name = "trojan_usb",
        amount = 1,
        info = {
            uses = 10
        },
        costs = {
            ["metalscrap"] = 25,
            ["plastic"] = 25,
            ["aluminum"] = 29,
            ["electronickit"] = 1,
        },
        type = "item",
        slot = 4,
        threshold = 35,
        points = 1,
    },

    [5] = {
        name = "plasma",
        amount = 1,
        info = {
            uses = 10
        },
        costs = {
            ["rubber"] = 4,
            ["metalscrap"] = 25,
            ["aluminum"] = 10,
            ["steel"] = 10,
            ["plastic"] = 5,
            ["ironoxide"] = 2,
            ["aluminumoxide"] = 3,
        },
        type = "item",
        slot = 5,
        threshold = 45,
        points = 1,
    },

    [6] = {
        name = "drill",
        amount = 1,
        info = {
            uses = 20
        },
        costs = {
            ["metalscrap"] = 30,
            ["plastic"] = 15,
            ["steel"] = 28,
            ["clutch"] = 25,
            ["iron"] = 28,
            ["wire"] = 20,
            ["rubber"] = 10, 
            ["screwdriverset"] = 1,
        },
        type = "item",
        slot = 6,
        threshold = 60,
        points = 1,
    },

    [7] = {
        name = "drillbit",
        amount = 1,
        info = {
            uses = 5
        },
        costs = {
            ["metalscrap"] = 10,
            ["aluminum"] = 10,
            ["steel"] = 10,
        },
        type = "item",
        slot = 7,
        threshold = 70,
        points = 1,
    },

    [8] = {
        name = "armorplate",
        amount = 1,
        info = {},
        costs = {
            ["iron"] = 20,
            ["aluminum"] = 15,
            ["steel"] = 15,
            ["rubber"] = 20, 
        },
        type = "item",
        slot = 8,
        threshold = 80,
        points = 1,
    },

    [9] = {
        name = "gatecrack",
        amount = 1,
        info = {
            uses = 10
        },
        costs = {
            ["screwdriverset"] = 10,
            ["drill"] = 1,
            ["wire"] = 10,
        },
        type = "item",
        slot = 9,
        threshold = 85,
        points = 1,
    },

    [10] = {
        name = "platecrack",
        amount = 1,
        info = {},
        costs = {
            ["screwdriverset"] = 10,
            ["drill"] = 1,
            ["wire"] = 10,
        },
        type = "item",
        slot = 10,
        threshold = 95,
        points = 1,
    },

    [11] = {
        name = "pikit",
        amount = 1,
        info = {},
        costs = {
            ["electronickit"] = 1,
            ["trojan_usb"] = 1,
            ["screwdriverset"] = 1,
        },
        type = "item",
        slot = 11,
        threshold = 100,
        points = 1,
    },

    [12] = {
        name = "tablet2",
        amount = 1,
        info = {},
        costs = {
            ["pinger"] = 1,
            ["trojan_usb"] = 1,
            ["screwdriverset"] = 1,
            ["pikit"] = 1,
            ["tablet"] = 1,
        },
        type = "item",
        slot = 12,
        threshold = 105,
        points = 1,
    },

    [13] = {
        name = "harddrive",
        amount = 1,
        info = {
            uses = 20
        },
        costs = {
            ["plastic"] = 15,
            ["wire"] = 15,
            ["pikit"] = 2,
            ["metalscrap"] = 15,
            ["aluminum"] = 15,
            ["steel"] = 15,
            ["rubber"] = 15,
            ["screwdriverset"] = 1, 
        },
        type = "item",
        slot = 13,
        threshold = 110,
        points = 1,
    },

    [14] = {
        name = "thermite2",
        amount = 2,
        info = {},
        costs = {
            ["metalscrap"] = 30,
            ["plastic"] = 45,
            ["aluminum"] = 28,
            ["steel"] = 25,
            ["glass"] = 25,
            ["thermite"] = 5,
        },
        type = "item",
        slot = 14,
        threshold = 130,
        points = 1,
    },
}

Config.AttachmentCrafting = {
    ["items"] = {
        [1] = {
            name = "gunpowder",
            amount = 50,
            info = {},
            costs = {
                ["ironoxide"] = 1,
                ["aluminumoxide"] = 1,
            },
            type = "item",
            slot = 1,
            threshold = 0,
            points = 1,
        },

        [2] = {
            name = "pistol_ammo",
            amount = 50,
            info = {},
            costs = {
                ["gunpowder"] = 2,
                ["copper"] = 4,
            },
            type = "item",
            slot = 2,
            threshold = 25,
            points = 1,
        },

        [3] = {
            name = "smg_ammo",
            amount = 50,
            info = {},
            costs = {
                ["gunpowder"] = 4,
                ["copper"] = 6,
                ["aluminum"] = 1,
                ["steel"] = 1,
            },
            type = "item",
            slot = 3,
            threshold = 85,
            points = 1,
        },


        [4] = {
            name = "shotgun_ammo",
            amount = 50,
            info = {},
            costs = {
                ["gunpowder"] = 4,
                ["copper"] = 10,
                ["plastic"] = 4,
                ["rubber"] = 2,
            },
            type = "item",
            slot = 4,
            threshold = 140,
            points = 1,
        },
        
        [5] = {
            name = "rifle_ammo",
            amount = 50,
            info = {},
            costs = {
                ["gunpowder"] = 5,
                ["copper"] = 12,
                ["aluminum"] = 1,
                ["steel"] = 1,
            },
            type = "item",
            slot = 5,
            threshold = 200,
            points = 1,
        },

        [6] = {
            name = "pistol_suppressor",
            amount = 1,
            info = {},
            costs = {
                ["iron"] = 30,
                ["rubber"] = 20,
                ["steel"] = 10,
                ["copper"] = 20,
                ["screwdriverset"] = 1,
            },
            type = "item",
            slot = 6,
            threshold = 250,
            points = 1,
        },

        [7] = {
            name = "pistol_extendedclip",
            amount = 1,
            info = {},
            costs = {
                ["iron"] = 30,
                ["rubber"] = 10,
                ["steel"] = 20,
                ["copper"] = 15,
                ["screwdriverset"] = 1,
            },
            type = "item",
            slot = 7,
            threshold = 300,
            points = 1,
        },

        [8] = {
            name = "combatpistol_extendedclip",
            amount = 1,
            info = {},
            costs = {
                ["iron"] = 30,
                ["rubber"] = 10,
                ["steel"] = 20,
                ["copper"] = 15,
                ["screwdriverset"] = 1,
            },
            type = "item",
            slot = 8,
            threshold = 300,
            points = 1,
        },

        [9] = {
            name = "appistol_extendedclip",
            amount = 1,
            info = {},
            costs = {
                ["iron"] = 30,
                ["rubber"] = 10,
                ["steel"] = 20,
                ["copper"] = 15,
                ["screwdriverset"] = 1,
            },
            type = "item",
            slot = 9,
            threshold = 300,
            points = 1,
        },

        [10] = {
            name = "pistol50_extendedclip",
            amount = 1,
            info = {},
            costs = {
                ["iron"] = 30,
                ["rubber"] = 10,
                ["steel"] = 20,
                ["copper"] = 15,
                ["screwdriverset"] = 1,
            },
            type = "item",
            slot = 10,
            threshold = 300,
            points = 1,
        },

        [11] = {
            name = "heavypistol_extendedclip",
            amount = 1,
            info = {},
            costs = {
                ["iron"] = 30,
                ["rubber"] = 10,
                ["steel"] = 20,
                ["copper"] = 15,
                ["screwdriverset"] = 1,
            },
            type = "item",
            slot = 11,
            threshold = 300,
            points = 1,
        },
        [12] = {
            name = "vintagepistol_extendedclip",
            amount = 1,
            info = {},
            costs = {
                ["iron"] = 30,
                ["rubber"] = 10,
                ["steel"] = 20,
                ["copper"] = 15,
                ["screwdriverset"] = 1,
            },
            type = "item",
            slot = 7,
            threshold = 300,
            points = 1,
        },
        
    }
}

Config.pastaItems = {
    [1] = {
        name = "tompasta",
        amount = 50,
        info = {},
        costs = {
            ["pasta"] = 1,
            ["veggies"] = 1,
            ["sauce"] = 1,
            ["water_bottle"] = 1,
            ["oil"] = 1,
            ["masala"] = 1,
            ["salt"] = 1,
        },
        type = "item",
        slot = 1,
        threshold = 0,
        points = 1,
    },
    [2] = {
        name = "cheesepasta",
        amount = 50,
        info = {},
        costs = {
            ["pasta"] = 1,
            ["veggies"] = 1,
            ["sauce"] = 1,
            ["cheese"] = 1,
            ["water_bottle"] = 1,
            ["butter"] = 1,
            ["masala"] = 1,
            ["salt"] = 1,

        },
        type = "item",
        slot = 2,
        threshold = 0,
        points = 1,
    },
    [3] = {
        name = "garlicbread",
        amount = 50,
        info = {},
        costs = {
            ["bread"] = 2,
            ["flour"] = 1,
            ["butter"] = 1,
            ["masala"] = 1,
        },
        type = "item",
        slot = 3,
        threshold = 0,
        points = 1,
    },
    -- [4] = {
    --     name = "donuts",
    --     amount = 50,
    --     info = {},
    --     costs = {
    --         ["flour"] = 2,
    --         ["bun"] = 1,
    --         ["sugar"] = 3,
    --         ["butter"] = 2,
    --     },
    --     type = "item",
    --     slot = 4,
    --     threshold = 0,
    --     points = 1,
    -- },
    [4] = {
        name = "icecream2",
        amount = 50,
        info = {},
        costs = {
            ["icecream"] = 2,
            ["milk"] = 1,
            ["sugar"] = 1,
        },
        type = "item",
        slot = 4,
        threshold = 0,
        points = 1,
    },
}

Config.teaItems = {
    [1] = {
        name = "coffee",
        amount = 50,
        info = {},
        costs = {
            ["coffeepouch"] = 1,
            ["milk"] = 1,
            ["sugar"] = 1,
        },
        type = "item",
        slot = 1,
        threshold = 0,
        points = 1,
    },
    [2] = {
        name = "tea",
        amount = 50,
        info = {},
        costs = {
            ["teapouch"] = 1,
            ["milk"] = 1,
            ["sugar"] = 1,
        },
        type = "item",
        slot = 2,
        threshold = 0,
        points = 1,
    },
    
    [3] = {
        name = "hi-tea",
        amount = 50,
        info = {},
        costs = {
            ["teapouch"] = 1,
            ["milk"] = 1,
            ["sugar"] = 1,
            ["cannabis"] = 2,
        },
        type = "item",
        slot = 3,
        threshold = 0,
        points = 1,
    },
    [4] = {
        name = "hotchocolate",
        amount = 50,
        info = {},
        costs = {
            ["milk"] = 1,
            ["chocochips"] = 2,
            ["sugar"] = 4,
        },
        type = "item",
        slot = 4,
        threshold = 0,
        points = 1,
    },
    [5] = {
        name = "coldcoffee",
        amount = 50,
        info = {},
        costs = {
            ["milk"] = 1,
            ["chocochips"] = 2,
            ["sugar"] = 4,
            ["icecream"] = 1,
        },
        type = "item",
        slot = 5,
        threshold = 0,
        points = 1,
    },
}

Config.mcdItems = {
    [1] = {
        name = "mcd-wrap",
        amount = 50,
        info = {},
        costs = {
            ["bread"] = 1,
            ["veggies"] = 1,
            ["sauce"] = 1,
        },
        type = "item",
        slot = 1,
        threshold = 0,
        points = 1,
    },
    [2] = {
        name = "mcd-wrap-c",
        amount = 50,
        info = {},
        costs = {
            ["bread"] = 1,
            ["veggies"] = 1,
            ["sauce"] = 1,
            ["chickenpatty"] = 1,
        },
        type = "item",
        slot = 2,
        threshold = 0,
        points = 1,
    },
    [3] = {
        name = "mcd-burger",
        amount = 50,
        info = {},
        costs = {
            ["bun"] = 1,
            ["veggies"] = 1,
            ["cheese"] = 1,
            ["sauce"] = 1,
            ["vegpatty"] = 1,
        },
        type = "item",
        slot = 3,
        threshold = 0,
        points = 1,
    },
    [4] = {
        name = "mcd-burger-c",
        amount = 50,
        info = {},
        costs = {
            ["bun"] = 1,
            ["veggies"] = 1,
            ["cheese"] = 1,
            ["sauce"] = 1,
            ["chickenpatty"] = 1,
        },
        type = "item",
        slot = 4,
        threshold = 0,
        points = 1,
    },
    [5] = {
        name = "mcd-fries",
        amount = 50,
        info = {},
        costs = {
            ["potato"] = 2,
            ["oil"] = 1,
            ["masala"] = 1,
            ["salt"] = 1,
          
        },
        type = "item",
        slot = 5,
        threshold = 0,
        points = 1,
    },
    
    [6] = {
        name = "mcd-nuggets",
        amount = 50,
        info = {},
        costs = {
            ["oil"] = 1,
            ["cheese"] = 1,
            ["bread"] = 2,
            ["salt"] = 1,
            ["veggies"] = 1,
        },
        type = "item",
        slot = 6,
        threshold = 0,
        points = 1,
    },
    
    [7] = {
        name = "mcd-maharaja",
        amount = 50,
        info = {},
        costs = {
            ["bun"] = 2,
            ["veggies"] = 2,
            ["cheese"] = 3,
            ["sauce"] = 2,
            ["vegpatty"] = 3,
        },
        type = "item",
        slot = 7,
        threshold = 0,
        points = 1,
    },

    [8] = {
        name = "mcd-chickenpop",
        amount = 50,
        info = {},
        costs = {
            ["cuttedchicken"] = 1,
            ["bread"] = 2,
            ["sauce"] = 2,
        },
        type = "item",
        slot = 8,
        threshold = 0,
        points = 1,
    },


    [9] = {
        name = "mcd-spicypaneer",
        amount = 50,
        info = {},
        costs = {
            ["paneer"] = 1,
            ["masala"] = 1,
            ["bun"] = 1,
            ["veggies"] = 1,
            ["cheese"] = 1,
            ["sauce"] = 1,

        },
        type = "item",
        slot = 9,
        threshold = 0,
        points = 1,
    },

    [10] = {
        name = "mcd-egg",
        amount = 50,
        info = {},
        costs = {
            ["egg"] = 1,
            ["masala"] = 1,
            ["bun"] = 1,
            ["cheese"] = 1,
            ["salt"] = 1,

        },
        type = "item",
        slot = 10,
        threshold = 0,
        points = 1,
    },

    [11] = {
        name = "mcd-meal",
        amount = 50,
        info = {},
        costs = {
            ["mcd-burger"] = 1,
            ["mcd-fries"] = 1,
            ["mcd-cola"] = 1,
        },
        type = "item",
        slot = 11,
        threshold = 0,
        points = 1,
    },

    [12] = {
        name = "chicken-meal",
        amount = 50,
        info = {},
        costs = {
            ["mcd-burger-c"] = 1,
            ["chicken-fries"] = 1,
            ["mcd-cola"] = 1,
        },
        type = "item",
        slot = 12,
        threshold = 0,
        points = 1,
    },

    [13] = {
        name = "chicken-fries",
        amount = 50,
        info = {},
        costs = {
            ["cuttedchicken"] = 1,
            ["oil"] = 1,
            ["masala"] = 1,
            ["salt"] = 1,
          
        },
        type = "item",
        slot = 13,
        threshold = 0,
        points = 1,
    },
}

Config.dhabaItems = {
    [1] = {
        name = "tsoup",
        amount = 50,
        info = {},
        costs = {
            ["knor"] = 1,
            ["water_bottle"] = 1,
        },
        type = "item",
        slot = 1,
        threshold = 0,
        points = 1,
    },
    [2] = {
        name = "msoup",
        amount = 50,
        info = {},
        costs = {
            ["manchow"] = 1,
            ["water_bottle"] = 1,
        },
        type = "item",
        slot = 2,
        threshold = 0,
        points = 1,
    },
    [3] = {
        name = "cookedchicken",
        amount = 50,
        info = {},
        costs = {
            ["cuttedchicken"] = 1,
            ["oil"] = 1,
            ["masala"] = 1,
            ["veggies"] = 1,
            ["salt"] = 1,
        },
        type = "item",
        slot = 3,
        threshold = 0,
        points = 1,
    },
    [4] = {
        name = "pannermasala",
        amount = 50,
        info = {},
        costs = {
            ["paneer"] = 2,
            ["oil"] = 1,
            ["masala"] = 1,
            ["veggies"] = 1,
            ["water_bottle"] = 1,
            ["salt"] = 1,

        },
        type = "item",
        slot = 4,
        threshold = 0,
        points = 1,
    },
    [5] = {
        name = "chickenmasala",
        amount = 50,
        info = {},
        costs = {
            ["cookedchicken"] = 1,
            ["butter"] = 1,
            ["masala"] = 1,
            ["veggies"] = 1,
            ["water_bottle"] = 1,
            ["salt"] = 1,
        },
        type = "item",
        slot = 5,
        threshold = 0,
        points = 1,
    },
    [6] = {
        name = "ngol",
        amount = 50,
        info = {},
        costs = {
            ["golgappa"] = 1,
            ["oil"] = 1,
            ["masala"] = 1,
        },
        type = "item",
        slot = 6,
        threshold = 0,
        points = 1,
    },
    [7] = {
        name = "sodiumchloride",
        amount = 50,
        info = {},
        costs = {
            ["salt"] = 1,
            ["water_bottle"] = 1,
        },
        type = "item",
        slot = 7,
        threshold = 0,
        points = 1,
    },
    [8] = {
        name = "brownbread",
        amount = 50,
        info = {},
        costs = {
            ["flour"] = 1,
            ["water_bottle"] = 1,
        },
        type = "item",
        slot = 8,
        threshold = 0,
        points = 1,
    },
    [9] = {
        name = "naan",
        amount = 50,
        info = {},
        costs = {
            ["flour"] = 1,
            ["water_bottle"] = 1,
            ["butter"] = 1,
        },
        type = "item",
        slot = 9,
        threshold = 0,
        points = 1,    
    },
     [10] = {
        name = "lassi",
        amount = 50,
        info = {},
        costs = {
            ["milk"] = 2,
            ["sugar"] = 4,
            ["water_bottle"] = 2,
        },
        type = "item",
        slot = 10,
        threshold = 0,
        points = 1,
    },
    [11] = {
        name = "nimbupani",
        amount = 50,
        info = {},
        costs = {
            ["salt"] = 2,
            ["sugar"] = 2,
            ["veggies"] = 1,
            ["water_bottle"] = 2,
        },
        type = "item",
        slot = 11,
        threshold = 0,
        points = 1,
    },
}

Config.mechItems = {
    [1] = {
        name = "tunerlaptop",
        amount = 50,
        info = {
            uses = 20
        },
        costs = {
            ["pikit"] = 2,
            ["clutch"] = 20,
            ["wire"] = 20,
            ["plastic"] = 20,
            ["glass"] = 10,
        },
        type = "item",
        slot = 1,
        threshold = 0,
        points = 1,
    },

    [2] = {
        name = "nitrous",
        amount = 50,
        info = {},
        costs = {
            ["rubber"] = 10,
            ["weapon_petrolcan"] = 1,
            ["metalscrap"] = 10,
            ["aluminum"] = 7,
            ["steel"] = 10,
            ["wire"] = 5,
            ["ironoxide"] = 5,
            ["aluminumoxide"] = 5,
        },
        type = "item",
        slot = 2,
        threshold = 0,
        points = 1,
    },
    [3] = {
        name = "advancedrepairkit",
        amount = 50,
        info = {},
        costs = {
            ["metalscrap"] = 15,
            ["steel"] = 17,
            ["iron"] = 9,
            ["rubber"] = 15,
            ["screwdriverset"] = 1,            
        },
        type = "item",
        slot = 3,
        threshold = 0,
        points = 1,
    },
    [4] = {
        name = "lockpick",
        amount = 50,
        info = {
            uses = 20
        },
        costs = {
            ["metalscrap"] = 10,
            ["steel"] = 8,
            ["iron"] = 8,
            
        },
        type = "item",
        slot = 4,
        threshold = 0,
        points = 1,
    },
    [5] = {
        name = "advancedlockpick",
        amount = 5,
        info = {
            uses = 50
        },
        costs = {
            ["metalscrap"] = 20,
            ["steel"] = 17,
            ["iron"] = 12,
            ["plastic"] = 15,
        },
        type = "item",
        slot = 5,
        threshold = 0,
        points = 1,
    },
    
}  

MaxInventorySlots = 40

BackEngineVehicles = {
    [`ninef`] = true,
    [`adder`] = true,
    [`vagner`] = true,
    [`t20`] = true,
    [`infernus`] = true,
    [`zentorno`] = true,
    [`reaper`] = true,
    [`comet2`] = true,
    [`comet3`] = true,
    [`jester`] = true,
    [`jester2`] = true,
    [`cheetah`] = true,
    [`cheetah2`] = true,
    [`prototipo`] = true,
    [`turismor`] = true,
    [`pfister811`] = true,
    [`ardent`] = true,
    [`nero`] = true,
    [`nero2`] = true,
    [`tempesta`] = true,
    [`vacca`] = true,
    [`bullet`] = true,
    [`osiris`] = true,
    [`entityxf`] = true,
    [`turismo2`] = true,
    [`fmj`] = true,
    [`re7b`] = true,
    [`tyrus`] = true,
    [`italigtb`] = true,
    [`penetrator`] = true,
    [`monroe`] = true,
    [`ninef2`] = true,
    [`stingergt`] = true,
    [`surfer`] = true,
    [`surfer2`] = true,
    [`gp1`] = true,
    [`autarch`] = true,
    [`tyrant`] = true
}

Config.MaximumAmmoValues = {
    ["pistol"] = 250,
    ["smg"] = 250,
    ["shotgun"] = 200,
    ["rifle"] = 250,
}
