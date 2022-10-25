Config = {}

Config.ShowUnlockedText = true

Config.LockedColor = 'rgb(219 58 58)'
Config.UnlockedColor = 'rgb(27 195 63)' -- Old Color if you want it 'rgb(19, 28, 74)'

Config.AdminAccess = {
	enabled = true,
	permission = 'god' -- Needs to be admin or god
}
Config.CommandPermission = 'god' -- Needs to be admin or god, if you want no permission on it you'd have to remove some code

Config.Debug = false -- Prints the closest door data

Config.DoorList = {

}

-- door_1 created by Jacob

-- paleto_door_1 created by Jacob
Config.DoorList['paleto_door_1'] = {
    objHash = 1622278560,
    locked = true,
    authorizedJobs = { ['police']=0 },
    slides = false,
    maxDistance = 2.0,
    objCoords = vec3(-104.813637, 6473.646484, 31.954800),
    audioRemote = false,
    lockpick = false,
    fixText = false,
    garage = false,
    objHeading = 25.000019073486,
    --oldMethod = true,
    --audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    --audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
    --autoLock = 1000,
    --doorRate = 1.0,
    --showNUI = true
}

-- paleto_door_1 created by Jacob
Config.DoorList['paleto_door_2'] = {
    objHash = 1309269072,
    locked = true,
    authorizedJobs = { ['police']=0 },
    slides = false,
    maxDistance = 2.0,
    objCoords = vec3(-106.471306, 6476.157715, 31.954800),
    audioRemote = false,
    lockpick = false,
    fixText = false,
    garage = false,
    objHeading = 315.00006103516,
    --oldMethod = true,
    --audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    --audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
    --autoLock = 1000,
    --doorRate = 1.0,
    --showNUI = true
}

-- pacific_door_1 created by Jacob
Config.DoorList['pacific_door_1'] = {
    objHash = -1508355822,
    locked = true,
    authorizedJobs = { ['police']=0 },
    slides = false,
    maxDistance = 2.0,
    objCoords = vec3(251.857574, 221.065475, 101.832405),
    audioRemote = false,
    lockpick = false,
    fixText = false,
    garage = false,
    objHeading = 160.00001525879,
    --oldMethod = true,
    --audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    --audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
    --autoLock = 1000,
    --doorRate = 1.0,
    --showNUI = true
}

-- pacific_door_2 created by Jacob
Config.DoorList['pacific_door_2'] = {
    objHash = -1508355822,
    locked = true,
    authorizedJobs = { ['police']=0 },
    slides = false,
    maxDistance = 2.0,
    objCoords = vec3(261.300415, 214.505142, 101.832405),
    audioRemote = false,
    lockpick = false,
    fixText = false,
    garage = false,
    objHeading = 250.00003051758,
    --oldMethod = true,
    --audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    --audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
    --autoLock = 1000,
    --doorRate = 1.0,
    --showNUI = true
}

-- pacific_door_3 created by Jacob
Config.DoorList['pacific_door_3'] = {
    objHash = 746855201,
    locked = true,
    authorizedJobs = { ['police']=0 },
    slides = false,
    maxDistance = 2.0,
    objCoords = vec3(262.198090, 222.518799, 106.429558),
    audioRemote = false,
    lockpick = false,
    fixText = false,
    garage = false,
    objHeading = 250.00003051758,
    --oldMethod = true,
    --audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    --audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
    --autoLock = 1000,
    --doorRate = 1.0,
    --showNUI = true
}

-- hiest_lockpick_1 created by Jacob
Config.DoorList['hiest_lockpick_1'] = {
    objHash = -222270721,
    locked = true,
    authorizedJobs = { ['police']=0 },
    slides = false,
    maxDistance = 2.0,
    objCoords = vec3(256.311554, 220.657852, 106.429558),
    audioRemote = false,
    lockpick = true,
    fixText = false,
    garage = false,
    objHeading = 340.00003051758,
    --oldMethod = true,
    --audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    --audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
    --autoLock = 1000,
    --doorRate = 1.0,
    --showNUI = true
}

-- hiest_lockpick_2 created by Jacob
Config.DoorList['hiest_lockpick_2'] = {
    slides = false,
    garage = false,
    fixText = false,
    lockpick = true,
    audioRemote = false,
    objHeading = 340.00003051758,
    authorizedJobs = { ['police']=0 },
    objHash = 1956494919,
    objCoords = vec3(266.362366, 217.569748, 110.432823),
    maxDistance = 2.0,
    locked = true,
    --oldMethod = true,
    --audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    --audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
    --autoLock = 1000,
    --doorRate = 1.0,
    --showNUI = true
}

-- hiest_lockpick_3 created by Jacob
Config.DoorList['hiest_lockpick_3'] = {
    slides = false,
    garage = false,
    fixText = false,
    lockpick = true,
    audioRemote = false,
    objHeading = 159.86595153809,
    authorizedJobs = { ['police']=0 },
    objHash = -1591004109,
    objCoords = vec3(314.623871, -285.994476, 54.463009),
    maxDistance = 2.0,
    locked = true,
    --oldMethod = true,
    --audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    --audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
    --autoLock = 1000,
    --doorRate = 1.0,
    --showNUI = true
}

-- hiest_lockpick_4 created by Jacob
Config.DoorList['hiest_lockpick_4'] = {
    slides = false,
    garage = false,
    fixText = false,
    lockpick = true,
    audioRemote = false,
    objHeading = 0.0,
    authorizedJobs = { ['police']=0 },
    objHash = -1591004109,
    objCoords = vec3(1172.291138, 2713.146240, 38.386253),
    maxDistance = 2.0,
    locked = true,
    --oldMethod = true,
    --audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    --audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
    --autoLock = 1000,
    --doorRate = 1.0,
    --showNUI = true
}

-- hiest_lockpick_5 created by Jacob
Config.DoorList['hiest_lockpick_5'] = {
    slides = false,
    garage = false,
    fixText = false,
    lockpick = true,
    audioRemote = false,
    objHeading = 159.84617614746,
    authorizedJobs = { ['police']=0 },
    objHash = -1591004109,
    objCoords = vec3(150.291321, -1047.629028, 29.666298),
    maxDistance = 2.0,
    locked = true,
    --oldMethod = true,
    --audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    --audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
    --autoLock = 1000,
    --doorRate = 1.0,
    --showNUI = true
}

-- hiest_lockpick_6 created by Jacob
Config.DoorList['hiest_lockpick_6'] = {
    slides = false,
    garage = false,
    fixText = false,
    lockpick = true,
    audioRemote = false,
    objHeading = 160.85981750488,
    authorizedJobs = { ['police']=0 },
    objHash = -1591004109,
    objCoords = vec3(-350.414368, -56.797054, 49.334797),
    maxDistance = 2.0,
    locked = true,
    --oldMethod = true,
    --audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    --audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
    --autoLock = 1000,
    --doorRate = 1.0,
    --showNUI = true
}

-- hiest_lockpick_7 created by Jacob
Config.DoorList['hiest_lockpick_7'] = {
    slides = false,
    garage = false,
    fixText = false,
    lockpick = true,
    audioRemote = false,
    objHeading = 206.86373901367,
    authorizedJobs = { ['police']=0 },
    objHash = -1591004109,
    objCoords = vec3(-1207.328247, -335.128937, 38.079254),
    maxDistance = 2.0,
    locked = true,
    --oldMethod = true,
    --audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    --audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
    --autoLock = 1000,
    --doorRate = 1.0,
    --showNUI = true
}

-- hiest_lockpick_8 created by Jacob
Config.DoorList['hiest_lockpick_8'] = {
    slides = false,
    garage = false,
    fixText = false,
    lockpick = true,
    audioRemote = false,
    objHeading = 267.54205322266,
    authorizedJobs = { ['police']=0 },
    objHash = -1591004109,
    objCoords = vec3(-2956.116211, 485.420593, 15.995309),
    maxDistance = 2.0,
    locked = true,
    --oldMethod = true,
    --audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    --audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
    --autoLock = 1000,
    --doorRate = 1.0,
    --showNUI = true
}

-- hiest_door_9 created by Jacob
Config.DoorList['hiest_door_9'] = {
    slides = false,
    lockpick = false,
    audioRemote = false,
    doors = {
        {objHash = 1425919976, objHeading = 306.00003051758, objCoords = vec3(-631.955383, -236.333267, 38.206532)},
        {objHash = 9467943, objHeading = 306.00003051758, objCoords = vec3(-630.426514, -238.437546, 38.206532)}
    },
    locked = true,
    authorizedJobs = { ['bigboss']=0 },
    maxDistance = 2.5,
    --oldMethod = true,
    --audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    --audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
    --autoLock = 1000,
    --doorRate = 1.0,
    --showNUI = true
}

-- pdm1 created by asd
-- Config.DoorList['pdm1'] = {
--     audioRemote = false,
--     slides = false,
--     locked = true,
--     objCoords = vec3(-33.809895, -1107.578735, 26.572254),
--     authorizedJobs = { ['pdm']=0 },
--     objHeading = 70.000030517578,
--     lockpick = false,
--     fixText = false,
--     garage = false,
--     maxDistance = 2.0,
--     objHash = -2051651622,
--     --oldMethod = true,
--     --audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
--     --audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
--     --autoLock = 1000,
--     --doorRate = 1.0,
--     --showNUI = true
-- }

-- -- pdm2 created by asd
-- Config.DoorList['pdm2'] = {
--     audioRemote = false,
--     slides = false,
--     locked = true,
--     objCoords = vec3(-31.723530, -1101.846558, 26.572254),
--     authorizedJobs = { ['pdm']=0 },
--     objHeading = 70.000030517578,
--     lockpick = false,
--     fixText = false,
--     garage = false,
--     maxDistance = 2.0,
--     objHash = -2051651622,
--     --oldMethod = true,
--     --audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
--     --audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
--     --autoLock = 1000,
--     --doorRate = 1.0,
--     --showNUI = true
-- }


-- tunner1 created by notsocool
Config.DoorList['tunner1'] = {
    locked = true,
    garage = true,
    authorizedJobs = { ['tunner']=0 },
    lockpick = false,
    audioRemote = false,
    fixText = false,
    maxDistance = 6.0,
    objHash = -456733639,
    objCoords = vec3(154.809525, -3023.889160, 8.503336),
    slides = true,
    objHeading = 89.999961853027,
    --oldMethod = true,
    --audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    --audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
    --autoLock = 1000,
    --doorRate = 1.0,
    --showNUI = true
}

-- tunner2 created by notsocool
Config.DoorList['tunner2'] = {
    locked = true,
    garage = false,
    authorizedJobs = { ['tunner']=0 },
    lockpick = false,
    audioRemote = false,
    fixText = false,
    maxDistance = 2.0,
    objHash = -2023754432,
    objCoords = vec3(154.934464, -3017.322998, 7.190679),
    slides = false,
    objHeading = 270.07965087891,
    --oldMethod = true,
    --audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    --audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
    --autoLock = 1000,
    --doorRate = 1.0,
    --showNUI = true
}

-- tunner3 created by notsocool
Config.DoorList['tunner3'] = {
    locked = true,
    garage = true,
    authorizedJobs = { ['tunner']=0 },
    lockpick = false,
    audioRemote = false,
    fixText = false,
    maxDistance = 6.0,
    objHash = -456733639,
    objCoords = vec3(154.809525, -3034.051270, 8.503336),
    slides = true,
    objHeading = 89.999961853027,
    --oldMethod = true,
    --audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    --audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
    --autoLock = 1000,
    --doorRate = 1.0,
    --showNUI = true
}

Config.DoorList['bennyoutside'] = {
    garage = false,
    locked = true,
    lockpick = false,
    authorizedJobs = { ['bennys']=0 },
    objCoords = vec3(-245.339615, -1307.229004, 30.327175),
    fixText = false,
    slides = true,
    objHash = 741314661,
    maxDistance = 6.0,
    objHeading = 90.108093261719,
    audioRemote = false,
    --oldMethod = true,
    --audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    --audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
    --autoLock = 1000,
    --doorRate = 1.0,
    --showNUI = true
}

-- cayo1 created by 97156
Config.DoorList['cayo1'] = {
    slides = true,
    objHeading = 245.1969909668,
    lockpick = false,
    garage = false,
    locked = true,
    maxDistance = 6.0,
    authorizedJobs = { ['bigboss']=0 },
    fixText = false,
    audioRemote = false,
    objCoords = vec3(1277.677490, -3325.862061, 4.910134),
    objHash = 741314661,
    --oldMethod = true,
    --audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    --audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
    --autoLock = 1000,
    --doorRate = 1.0,
    --showNUI = true
}

-- cayo2 created by 97156
Config.DoorList['cayo2'] = {
    slides = true,
    objHeading = 54.942600250244,
    lockpick = false,
    garage = false,
    locked = true,
    maxDistance = 6.0,
    authorizedJobs = { ['bigboss']=0 },
    fixText = false,
    audioRemote = false,
    objCoords = vec3(1284.856323, -3311.550293, 4.910134),
    objHash = 741314661,
    --oldMethod = true,
    --audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    --audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
    --autoLock = 1000,
    --doorRate = 1.0,
    --showNUI = true
}

-- cayo3 created by 97156
Config.DoorList['cayo3'] = {
    slides = true,
    objHeading = 242.26736450195,
    lockpick = false,
    garage = false,
    locked = true,
    maxDistance = 6.0,
    authorizedJobs = { ['bigboss']=0 },
    fixText = false,
    audioRemote = false,
    objCoords = vec3(3945.837646, -4685.644531, 3.051880),
    objHash = 741314661,
    --oldMethod = true,
    --audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    --audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
    --autoLock = 1000,
    --doorRate = 1.0,
    --showNUI = true
}

-- cayo4 created by 97156
Config.DoorList['cayo4'] = {
    slides = true,
    objHeading = 59.916042327881,
    lockpick = false,
    garage = false,
    locked = true,
    maxDistance = 6.0,
    authorizedJobs = { ['bigboss']=0 },
    fixText = false,
    audioRemote = false,
    objCoords = vec3(3952.954102, -4671.451172, 3.051880),
    objHash = 741314661,
    --oldMethod = true,
    --audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    --audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
    --autoLock = 1000,
    --doorRate = 1.0,
    --showNUI = true
}