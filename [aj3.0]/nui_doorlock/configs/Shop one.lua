

-- front 1 created by Ayush Abhinav
Config.DoorList['front 1'] = {
    lockpick = false,
    slides = true,
    maxDistance = 6.0,
    audioRemote = false,
    locked = false,
    authorizedJobs = { ['shopone']=0 },
    doors = {
        {objHash = 161378502, objHeading = 270.04553222656, objCoords = vec3(289.925232, -1268.208618, 28.485363)},
        {objHash = -1572101598, objHeading = 270.2080078125, objCoords = vec3(289.914886, -1265.604370, 28.481382)}
    },
    --oldMethod = true,
    --audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    --audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
    --autoLock = 1000,
    --doorRate = 1.0,
    --showNUI = true
}

-- inside created by Ayush Abhinav
Config.DoorList['inside'] = {
    objHeading = 90.379890441895,
    maxDistance = 6.0,
    objCoords = vec3(302.678314, -1257.267944, 28.308897),
    authorizedJobs = { ['shopone']=0 },
    garage = false,
    slides = true,
    objHash = 161378502,
    lockpick = false,
    locked = true,
    fixText = false,
    audioRemote = false,
    --oldMethod = true,
    --audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
    --audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
    --autoLock = 1000,
    --doorRate = 1.0,
    --showNUI = true
}