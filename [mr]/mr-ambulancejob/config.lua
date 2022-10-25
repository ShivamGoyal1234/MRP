Config = {}

Config.MinimalDoctors = 1
Config.WipeInventoryOnRespawn = false

Config.Locations = {
    ["checking"] = vector3(312.39, -592.93, 43.29),
    ["duty"] = {
        [1] = vector3(304.5, -600.64, 43.28),
        [2] = vector3(-254.88, 6324.5, 32.58),
    },
    ["duty2"] = {
        [1] = vector3(307.0, -601.73, 43.28)
    },
    ["vehicle"] = {
        [1] = vector4(332.16, -578.07, 28.8, 332.74),
        [2] = vector4(-234.28, 6329.16, 32.15, 222.5),
        [3] = vector4(325.38, -575.36, 28.8, 331.47),
        [4] = vector4(293.93, -576.3, 43.2, 20.07),
    },
    ["helicopter"] = {
        [1] = vector4(351.58, -587.45, 74.16, 160.5),
        [2] = vector4(-475.43, 5988.353, 31.716, 31.34),
    },
    ["armory"] = {
        [1] = vector3(310.02, -568.63, 43.28),
    },
    ["pstash"] = {
        [1] = vector3(307.0, -601.73, 43.28)
    },
    ["beds"] = {
        [1] = {coords = vector4(309.23, -577.53, 43.3, 154.01), taken = false, model = 1631638868},
        [2] = {coords = vector4(311.14, -582.86, 43.3, 336.51), taken = false, model = 1631638868},
        [3] = {coords = vector4(313.76, -579.3, 43.3, 156.51), taken = false, model = 1631638868},
        [4] = {coords = vector4(314.55, -584.11, 43.3, 336.51), taken = false, model = 1631638868},
        [5] = {coords = vector4(317.8,  -585.3, 43.3, 336.51), taken = false, model = 1631638868}, 
        [6] = {coords = vector4(322.76, -587.05, 43.3, 334.01), taken = false, model = 1631638868},
        [7] = {coords = vector4(319.23, -581.26, 43.3, 154.01), taken = false, model = 1631638868}, 
    },
    ["jailbeds"] = {
        [1] = {coords = vector4(1761.96, 2597.74, 45.66, 270.14), taken = false, model = 2117668672},
        [2] = {coords = vector4(1761.96, 2591.51, 45.66, 269.8), taken = false, model = 2117668672},
        [3] = {coords = vector4(1771.8, 2598.02, 45.66, 89.05), taken = false, model = 2117668672},
        [4] = {coords = vector4(1771.85, 2591.85, 45.66, 91.51), taken = false, model = 2117668672},
    },
    ["stations"] = {
        [1] = {label = "Pillbox Hospital", coords = vector4(304.27, -600.33, 43.28, 272.249)}
    }
}

Config.AuthorizedVehicles = {
	-- Grade 0
	[0] = {
		["ambulance"] = "Ambulance",
        -- ["emsf250"] = "EMS F250",
        -- ["emscap"] = "EMS Cap",
        ["iak_wheelchair"] = "EMS Wheelchair",
        -- ["emsdurango"] = "EMS Durango",
        -- ["ems18charg"] = "EMS Charger",
	},
    [1] = {
		["ambulance"] = "Ambulance",
        -- ["emsf250"] = "EMS F250",
        -- ["emscap"] = "EMS Cap",
        ["iak_wheelchair"] = "EMS Wheelchair",
        -- ["emsdurango"] = "EMS Durango",
        -- ["ems18charg"] = "EMS Charger",
	},
    [2] = {
		["ambulance"] = "Ambulance",
        --["emsf250"] = "EMS F250",
        ["emscap"] = "EMS Cap",
        ["iak_wheelchair"] = "EMS Wheelchair",
        --["emsdurango"] = "EMS Durango",
        -- ["ems18charg"] = "EMS Charger",
	},
    [3] = {
		["ambulance"] = "Ambulance",
        --["emsf250"] = "EMS F250",
        ["emscap"] = "EMS Cap",
        ["iak_wheelchair"] = "EMS Wheelchair",
        --["emsdurango"] = "EMS Durango",
        -- ["ems18charg"] = "EMS Charger",
	},
    [4] = {
		["ambulance"] = "Ambulance",
        --["emsf250"] = "EMS F250",
        ["emscap"] = "EMS Cap",
        ["iak_wheelchair"] = "EMS Wheelchair",
        --["emsdurango"] = "EMS Durango",
        ["ems18charg"] = "EMS Charger",
	},
    [5] = {
		["ambulance"] = "Ambulance",
        -- ["emsf250"] = "EMS F250",
        ["emscap"] = "EMS Cap",
        ["iak_wheelchair"] = "EMS Wheelchair",
        --["emsdurango"] = "EMS Durango",
        ["ems18charg"] = "EMS Charger",
	},
    [6] = {
		["ambulance"] = "Ambulance",
        --["emsf250"] = "EMS F250",
        ["emscap"] = "EMS Cap",
        -- ["iak_wheelchair"] = "EMS Wheelchair",
        ["emsdurango"] = "EMS Durango",
        ["ems18charg"] = "EMS Charger",
	},
    [7] = {
		["ambulance"] = "Ambulance",
        ["emsf250"] = "EMS F250",
        ["emscap"] = "EMS Cap",
        ["iak_wheelchair"] = "EMS Wheelchair",
        ["emsdurango"] = "EMS Durango",
        ["ems18charg"] = "EMS Charger",
	},
    [8] = {
		["ambulance"] = "Ambulance",
        ["emsf250"] = "EMS F250",
        ["emscap"] = "EMS Cap",
        ["iak_wheelchair"] = "EMS Wheelchair",
        ["emsdurango"] = "EMS Durango",
        ["ems18charg"] = "EMS Charger",
	},
    [9] = {
		["ambulance"] = "Ambulance",
        ["emsf250"] = "EMS F250",
        ["emscap"] = "EMS Cap",
        ["iak_wheelchair"] = "EMS Wheelchair",
        ["emsdurango"] = "EMS Durango",
        ["ems18charg"] = "EMS Charger",
	},
}

Config.Helicopter = "polmav"

Config.Items = {
    label = "Hospital safe",
    slots = 30,
    items = {
        [1] = {
            name = "radio",
            price = 800,
            amount = 50,
            info = {},
            type = "item",
            slot = 1,
        },
        [2] = {
            name = "bandage",
            price = 50,
            amount = 50,
            info = {},
            type = "item",
            slot = 2,
        },
        [3] = {
            name = "painkillers",
            price = 150,
            amount = 50,
            info = {},
            type = "item",
            slot = 3,
        },
        [4] = {
            name = "weapon_flashlight",
            price = 500,
            amount = 50,
            info = {},
            type = "item",
            slot = 4,
        },
        [5] = {
            name = "weapon_fireextinguisher",
            price = 500,
            amount = 50,
            info = {},
            type = "item",
            slot = 5,
        },
        [6] = {
            name = "empty_evidence_bag",
            price = 10,
            amount = 50,
            info = {},
            type = "item",
            slot = 6,
        },
        [7] = {
            name = "walkstick",
            price = 100,
            amount = 50,
            info = {},
            type = "item",
            slot = 7,
        },
        [8] = {
            name = "paracetamol",
            price = 150,
            amount = 50,
            info = {},
            type = "item",
            slot = 8,
        },
        [9] = {
            name = "aspirine",
            price = 150,
            amount = 50,
            info = {},
            type = "item",
            slot = 9,
        },
        [10] = {
            name = "disprin",
            price = 150,
            amount = 50,
            info = {},
            type = "item",
            slot = 10,
        },
        [11] = {
            name = "heparin",
            price = 150,
            amount = 50,
            info = {},
            type = "item",
            slot = 11,
        },
        [12] = {
            name = "ibuprofen",
            price = 150,
            amount = 50,
            info = {},
            type = "item",
            slot = 12,
        },
        [13] = {
            name = "gbottle",
            price = 150,
            amount = 50,
            info = {},
            type = "item",
            slot = 13,
        },
        [14] = {
            name = "firstaid",
            price = 300,
            amount = 50,
            info = {},
            type = "item",
            slot = 14,
        },
        [15] = {
            name = "tracker",
            price = 100,
            amount = 1,
            info = {},
            type = "item",
            slot = 15,
        },
        [16] = {
            name = "cprkit",
            price = 250,
            amount = 50,
            info = {},
            type = "item",
            slot = 16,
        },
    }
}

Config.BillCost = 1000
Config.DeathTime = 300
Config.CheckTime = 10

Config.PainkillerInterval = 60 -- seconds

--[[
    GENERAL SETTINGS | THESE WILL AFFECT YOUR ENTIRE SERVER SO BE SURE TO SET THESE CORRECTLY
    MaxHp : Maximum HP Allowed, set to -1 if you want to disable mythic_hospital from setting this
        NOTE: Anything under 100 and you are dead
    RegenRate : 
]]
Config.MaxHp = 200
Config.RegenRate = 0.0

--[[
    HealthDamage : How Much Damage To Direct HP Must Be Applied Before Checks For Damage Happens
    ArmorDamage : How Much Damage To Armor Must Be Applied Before Checks For Damage Happens | NOTE: This will in turn make stagger effect with armor happen only after that damage occurs
]]
Config.HealthDamage = 5
Config.ArmorDamage = 5

--[[
    MaxInjuryChanceMulti : How many times the HealthDamage value above can divide into damage taken before damage is forced to be applied
    ForceInjury : Maximum amount of damage a player can take before limb damage & effects are forced to occur
]]
Config.MaxInjuryChanceMulti = 3
Config.ForceInjury = 35
Config.AlwaysBleedChance = 70

--[[
    Message Timer : How long it will take to display limb/bleed message
]]
Config.MessageTimer = 12

--[[
    AIHealTimer : How long it will take to be healed after checking in, in seconds
]]
Config.AIHealTimer = 20

--[[ 
    BleedTickRate : How much time, in seconds, between bleed ticks
]]
Config.BleedTickRate = 30

--[[
    BleedMovementTick : How many seconds is taken away from the bleed tick rate if the player is walking, jogging, or sprinting
    BleedMovementAdvance : How Much Time Moving While Bleeding Adds (This Adds This Value To The Tick Count, Meaing The Above BleedTickRate Will Be Reached Faster)
]]
Config.BleedMovementTick = 10
Config.BleedMovementAdvance = 3

--[[
    The Base Damage That Is Multiplied By Bleed Level Every Time A Bleed Tick Occurs
]]
Config.BleedTickDamage = 8

--[[
    FadeOutTimer : How many bleed ticks occur before fadeout happens
    BlackoutTimer : How many bleed ticks occur before blacking out
    AdvanceBleedTimer : How many bleed ticks occur before bleed level increases
]]
Config.FadeOutTimer = 2
Config.BlackoutTimer = 1
Config.AdvanceBleedTimer = 10

--[[
    HeadInjuryTimer : How much time, in seconds, do head injury effects chance occur
    ArmInjuryTimer : How much time, in seconds, do arm injury effects chance occur
    LegInjuryTimer : How much time, in seconds, do leg injury effects chance occur
]]
Config.HeadInjuryTimer = 10
Config.ArmInjuryTimer = 30
Config.LegInjuryTimer = 15

--[[
    The Chance, In Percent, That Certain Injury Side-Effects Get Applied
]]
Config.HeadInjuryChance = 30
Config.ArmInjuryChance = 25
Config.LegInjuryChance = {
    Running = 50,
    Walking = 15
}

--[[
    MajorArmoredBleedChance : The % Chance Someone Gets A Bleed Effect Applied When Taking Major Damage With Armor
    MajorDoubleBleed : % Chance You Have To Receive Double Bleed Effect From Major Damage, This % is halved if the player has armor
]]
Config.MajorArmoredBleedChance = 45

--[[
    DamgeMinorToMajor : How much damage would have to be applied for a minor weapon to be considered a major damage event. Put this at 100 if you want to disable it
]]
Config.DamageMinorToMajor = 35

--[[
    AlertShowInfo : 
]]
Config.AlertShowInfo = 2

--[[
    These following lists uses tables defined in definitions.lua, you can technically use the hardcoded values but for sake
    of ensuring future updates doesn't break it I'd highly suggest you check that file for the index you're wanting to use.

    MinorInjurWeapons : Damage From These Weapons Will Apply Only Minor Injuries
    MajorInjurWeapons : Damage From These Weapons Will Apply Only Major Injuries
    AlwaysBleedChanceWeapons : Weapons that're in the included weapon classes will roll for a chance to apply a bleed effect if the damage wasn't enough to trigger an injury chance
    CriticalAreas : 
    StaggerAreas : These are the body areas that would cause a stagger is hit by firearms,
        Table Values: Armored = Can This Cause Stagger If Wearing Armor, Major = % Chance You Get Staggered By Major Damage, Minor = % Chance You Get Staggered By Minor Damage
]]

Config.WeaponClasses = {
    ['SMALL_CALIBER'] = 1,
    ['MEDIUM_CALIBER'] = 2,
    ['HIGH_CALIBER'] = 3,
    ['SHOTGUN'] = 4,
    ['CUTTING'] = 5,
    ['LIGHT_IMPACT'] = 6,
    ['HEAVY_IMPACT'] = 7,
    ['EXPLOSIVE'] = 8,
    ['FIRE'] = 9,
    ['SUFFOCATING'] = 10,
    ['OTHER'] = 11,
    ['WILDLIFE'] = 12,
    ['NOTHING'] = 13
}

Config.MinorInjurWeapons = {
    [Config.WeaponClasses['SMALL_CALIBER']] = true,
    [Config.WeaponClasses['MEDIUM_CALIBER']] = true,
    [Config.WeaponClasses['CUTTING']] = true,
    [Config.WeaponClasses['WILDLIFE']] = true,
    [Config.WeaponClasses['OTHER']] = true,
    [Config.WeaponClasses['LIGHT_IMPACT']] = true,
}

Config.MajorInjurWeapons = {
    [Config.WeaponClasses['HIGH_CALIBER']] = true,
    [Config.WeaponClasses['HEAVY_IMPACT']] = true,
    [Config.WeaponClasses['SHOTGUN']] = true,
    [Config.WeaponClasses['EXPLOSIVE']] = true,
}

Config.AlwaysBleedChanceWeapons = {
    [Config.WeaponClasses['SMALL_CALIBER']] = true,
    [Config.WeaponClasses['MEDIUM_CALIBER']] = true,
    [Config.WeaponClasses['CUTTING']] = true,
    [Config.WeaponClasses['WILDLIFE']] = false,
}

Config.ForceInjuryWeapons = {
    [Config.WeaponClasses['HIGH_CALIBER']] = true,
    [Config.WeaponClasses['HEAVY_IMPACT']] = true,
    [Config.WeaponClasses['EXPLOSIVE']] = true,
}

Config.CriticalAreas = {
    ['UPPER_BODY'] = { armored = false },
    ['LOWER_BODY'] = { armored = true },
    ['SPINE'] = { armored = true },
}

Config.StaggerAreas = {
    ['SPINE'] = { armored = true, major = 60, minor = 30 },
    ['UPPER_BODY'] = { armored = false, major = 60, minor = 30 },
    ['LLEG'] = { armored = true, major = 100, minor = 85 },
    ['RLEG'] = { armored = true, major = 100, minor = 85 },
    ['LFOOT'] = { armored = true, major = 100, minor = 100 },
    ['RFOOT'] = { armored = true, major = 100, minor = 100 },
}

Config.WoundStates = {
    'irritated',
    'quite painful',
    'painful',
    'really painful',
}

Config.BleedingStates = {
    [1] = {label = 'bleeding a little bit..', damage = 10, chance = 50},
    [2] = {label = 'bleeding..', damage = 15, chance = 65},
    [3] = {label = 'bleeding a lot..', damage = 20, chance = 65},
    [4] = {label = 'bleeding very much..', damage = 25, chance = 75},
}

Config.MovementRate = {
    0.98,
    0.96,
    0.94,
    0.92,
}

Config.Bones = {
    [0]     = 'NONE',
    [31085] = 'HEAD',
    [31086] = 'HEAD',
    [39317] = 'NECK',
    [57597] = 'SPINE',
    [23553] = 'SPINE',
    [24816] = 'SPINE',
    [24817] = 'SPINE',
    [24818] = 'SPINE',
    [10706] = 'UPPER_BODY',
    [64729] = 'UPPER_BODY',
    [11816] = 'LOWER_BODY',
    [45509] = 'LARM',
    [61163] = 'LARM',
    [18905] = 'LHAND',
    [4089] = 'LFINGER',
    [4090] = 'LFINGER',
    [4137] = 'LFINGER',
    [4138] = 'LFINGER',
    [4153] = 'LFINGER',
    [4154] = 'LFINGER',
    [4169] = 'LFINGER',
    [4170] = 'LFINGER',
    [4185] = 'LFINGER',
    [4186] = 'LFINGER',
    [26610] = 'LFINGER',
    [26611] = 'LFINGER',
    [26612] = 'LFINGER',
    [26613] = 'LFINGER',
    [26614] = 'LFINGER',
    [58271] = 'LLEG',
    [63931] = 'LLEG',
    [2108] = 'LFOOT',
    [14201] = 'LFOOT',
    [40269] = 'RARM',
    [28252] = 'RARM',
    [57005] = 'RHAND',
    [58866] = 'RFINGER',
    [58867] = 'RFINGER',
    [58868] = 'RFINGER',
    [58869] = 'RFINGER',
    [58870] = 'RFINGER',
    [64016] = 'RFINGER',
    [64017] = 'RFINGER',
    [64064] = 'RFINGER',
    [64065] = 'RFINGER',
    [64080] = 'RFINGER',
    [64081] = 'RFINGER',
    [64096] = 'RFINGER',
    [64097] = 'RFINGER',
    [64112] = 'RFINGER',
    [64113] = 'RFINGER',
    [36864] = 'RLEG',
    [51826] = 'RLEG',
    [20781] = 'RFOOT',
    [52301] = 'RFOOT',
}

Config.BoneIndexes = {
    ['NONE'] = 0,
    ['HEAD'] = 31085,
    ['HEAD'] = 31086,
    ['NECK'] = 39317,
    ['SPINE'] = 57597,
    ['SPINE'] = 23553,
    ['SPINE'] = 24816,
    ['SPINE'] = 24817,
    ['SPINE'] = 24818,
    ['UPPER_BODY'] = 10706,
    ['UPPER_BODY'] = 64729,
    ['LOWER_BODY'] = 11816,
    ['LARM'] = 45509,
    ['LARM'] = 61163,
    ['LHAND'] = 18905,
    ['LFINGER'] = 4089,
    ['LFINGER'] = 4090,
    ['LFINGER'] = 4137,
    ['LFINGER'] = 4138,
    ['LFINGER'] = 4153,
    ['LFINGER'] = 4154,
    ['LFINGER'] = 4169,
    ['LFINGER'] = 4170,
    ['LFINGER'] = 4185,
    ['LFINGER'] = 4186,
    ['LFINGER'] = 26610,
    ['LFINGER'] = 26611,
    ['LFINGER'] = 26612,
    ['LFINGER'] = 26613,
    ['LFINGER'] = 26614,
    ['LLEG'] = 58271,
    ['LLEG'] = 63931,
    ['LFOOT'] = 2108,
    ['LFOOT'] = 14201,
    ['RARM'] = 40269,
    ['RARM'] = 28252,
    ['RHAND'] = 57005,
    ['RFINGER'] = 58866,
    ['RFINGER'] = 58867,
    ['RFINGER'] = 58868,
    ['RFINGER'] = 58869,
    ['RFINGER'] = 58870,
    ['RFINGER'] = 64016,
    ['RFINGER'] = 64017,
    ['RFINGER'] = 64064,
    ['RFINGER'] = 64065,
    ['RFINGER'] = 64080,
    ['RFINGER'] = 64081,
    ['RFINGER'] = 64096,
    ['RFINGER'] = 64097,
    ['RFINGER'] = 64112,
    ['RFINGER'] = 64113,
    ['RLEG'] = 36864,
    ['RLEG'] = 51826,
    ['RFOOT'] = 20781,
    ['RFOOT'] = 52301,
}

Config.Weapons = {
    [`WEAPON_STUNGUN`] = Config.WeaponClasses['NONE'],
    --[[ Small Caliber ]]--
    [`WEAPON_PISTOL`] = Config.WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_COMBATPISTOL`] = Config.WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_APPISTOL`] = Config.WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_COMBATPDW`] = Config.WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_MACHINEPISTOL`] = Config.WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_MICROSMG`] = Config.WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_MINISMG`] = Config.WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_PISTOL_MK2`] = Config.WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_SNSPISTOL`] = Config.WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_SNSPISTOL_MK2`] = Config.WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_VINTAGEPISTOL`] = Config.WeaponClasses['SMALL_CALIBER'],

    --[[ Medium Caliber ]]--
    [`WEAPON_ADVANCEDRIFLE`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_ASSAULTSMG`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_BULLPUPRIFLE`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_BULLPUPRIFLE_MK2`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_CARBINERIFLE`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_CARBINERIFLE_MK2`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_COMPACTRIFLE`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_DOUBLEACTION`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_GUSENBERG`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_HEAVYPISTOL`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_MARKSMANPISTOL`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_PISTOL50`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_REVOLVER`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_REVOLVER_MK2`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_SMG`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_SMG_MK2`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_SPECIALCARBINE`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_SPECIALCARBINE_MK2`] = Config.WeaponClasses['MEDIUM_CALIBER'],

    --[[ High Caliber ]]--
    [`WEAPON_ASSAULTRIFLE`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_ASSAULTRIFLE_MK2`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_COMBATMG`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_COMBATMG_MK2`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_HEAVYSNIPER`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_HEAVYSNIPER_MK2`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_MARKSMANRIFLE`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_MARKSMANRIFLE_MK2`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_MG`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_MINIGUN`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_MUSKET`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_RAILGUN`] = Config.WeaponClasses['HIGH_CALIBER'],

    --[[ Shotguns ]]--
    [`WEAPON_ASSAULTSHOTGUN`] = Config.WeaponClasses['SHOTGUN'],
    [`WEAPON_BULLUPSHOTGUN`] = Config.WeaponClasses['SHOTGUN'],
    [`WEAPON_DBSHOTGUN`] = Config.WeaponClasses['SHOTGUN'],
    [`WEAPON_HEAVYSHOTGUN`] = Config.WeaponClasses['SHOTGUN'],
    [`WEAPON_PUMPSHOTGUN`] = Config.WeaponClasses['SHOTGUN'],
    [`WEAPON_PUMPSHOTGUN_MK2`] = Config.WeaponClasses['SHOTGUN'],
    [`WEAPON_SAWNOFFSHOTGUN`] = Config.WeaponClasses['SHOTGUN'],
    [`WEAPON_SWEEPERSHOTGUN`] = Config.WeaponClasses['SHOTGUN'],

    --[[ Animals ]]--
    [`WEAPON_ANIMAL`] = Config.WeaponClasses['WILDLIFE'], -- Animal
    [`WEAPON_COUGAR`] = Config.WeaponClasses['WILDLIFE'], -- Cougar
    [`WEAPON_BARBED_WIRE`] = Config.WeaponClasses['WILDLIFE'], -- Barbed Wire

    --[[ Cutting Weapons ]]--
    [`WEAPON_BATTLEAXE`] = Config.WeaponClasses['CUTTING'],
    [`WEAPON_BOTTLE`] = Config.WeaponClasses['CUTTING'],
    [`WEAPON_DAGGER`] = Config.WeaponClasses['CUTTING'],
    [`WEAPON_HATCHET`] = Config.WeaponClasses['CUTTING'],
    [`WEAPON_KNIFE`] = Config.WeaponClasses['CUTTING'],
    [`WEAPON_MACHETE`] = Config.WeaponClasses['CUTTING'],
    [`WEAPON_SWITCHBLADE`] = Config.WeaponClasses['CUTTING'],

    --[[ Light Impact ]]--
    [`WEAPON_KNUCKLE`] = Config.WeaponClasses['LIGHT_IMPACT'],

    --[[ Heavy Impact ]]--
    [`WEAPON_BAT`] = Config.WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_CROWBAR`] = Config.WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_FIREEXTINGUISHER`] = Config.WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_FIRWORK`] = Config.WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_GOLFLCUB`] = Config.WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_HAMMER`] = Config.WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_PETROLCAN`] = Config.WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_POOLCUE`] = Config.WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_WRENCH`] = Config.WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_RAMMED_BY_CAR`] = Config.WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_RUN_OVER_BY_CAR`] = Config.WeaponClasses['HEAVY_IMPACT'],

    --[[ Explosives ]]--
    [`WEAPON_EXPLOSION`] = Config.WeaponClasses['EXPLOSIVE'],
    [`WEAPON_GRENADE`] = Config.WeaponClasses['EXPLOSIVE'],
    [`WEAPON_COMPACTLAUNCHER`] = Config.WeaponClasses['EXPLOSIVE'],
    [`WEAPON_HOMINGLAUNCHER`] = Config.WeaponClasses['EXPLOSIVE'],
    [`WEAPON_PIPEBOMB`] = Config.WeaponClasses['EXPLOSIVE'],
    [`WEAPON_PROXMINE`] = Config.WeaponClasses['EXPLOSIVE'],
    [`WEAPON_RPG`] = Config.WeaponClasses['EXPLOSIVE'],
    [`WEAPON_STICKYBOMB`] = Config.WeaponClasses['EXPLOSIVE'],
    [`WEAPON_HELI_CRASH`] = Config.WeaponClasses['EXPLOSIVE'],

    --[[ Other ]]--
    [`WEAPON_FALL`] = Config.WeaponClasses['OTHER'], -- Fall
    [`WEAPON_HIT_BY_WATER_CANNON`] = Config.WeaponClasses['OTHER'], -- Water Cannon

    --[[ Fire ]]--
    [`WEAPON_ELECTRIC_FENCE`] = Config.WeaponClasses['FIRE'],
    [`WEAPON_FIRE`] = Config.WeaponClasses['FIRE'],
    [`WEAPON_MOLOTOV`] = Config.WeaponClasses['FIRE'],
    [`WEAPON_FLARE`] = Config.WeaponClasses['FIRE'],
    [`WEAPON_FLAREGUN`] = Config.WeaponClasses['FIRE'],

    --[[ Suffocate ]]--
    [`WEAPON_DROWNING`] = Config.WeaponClasses['SUFFOCATING'], -- Drowning
    [`WEAPON_DROWNING_IN_VEHICLE`] = Config.WeaponClasses['SUFFOCATING'], -- Drowning Veh
    [`WEAPON_EXHAUSTION`] = Config.WeaponClasses['SUFFOCATING'], -- Exhaust
    [`WEAPON_BZGAS`] = Config.WeaponClasses['SUFFOCATING'],
    [`WEAPON_SMOKEGRENADE`] = Config.WeaponClasses['SUFFOCATING'],
}
