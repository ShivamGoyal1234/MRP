Config = {}

Config = {
    ChanceToGetItem = 20, -- if math.random(0, 100) <= ChanceToGetItem then give item
    Items = {'orange','orange','orange','orange','orange'},
    Process = vector3(421.21, 6467.73, 28.81),
    Objects = {
        ['pickaxe'] = 'w_me_hatchet',
    },
    OrangePosition = {
        {coords = vector3(378.0, 6505.09, 27.95-0.97), heading = 359.88},
        {coords = vector3(378.13, 6517.0, 28.36-0.97), heading =  8.6},
        {coords = vector3(370.03, 6517.21, 28.37-0.97), heading = 354.03},
        {coords = vector3(370.22, 6505.38, 28.41-0.97), heading =  351.79},
        {coords = vector3(362.95, 6504.92, 28.53-0.97), heading =  351.79},
        {coords = vector3(362.61, 6516.88, 28.26-0.97), heading =  351.79},
        {coords = vector3(355.24, 6504.4, 28.47-0.97), heading =  351.79},
        {coords = vector3(347.98, 6504.9, 28.8-0.97), heading =  351.79},
        {coords = vector3(340.0, 6505.09, 28.68-0.97), heading =  351.79},
        {coords = vector3(330.7, 6505.24, 28.58-0.97), heading =  351.79},
        {coords = vector3(321.78, 6504.91, 29.22-0.97), heading =  351.79},
        {coords = vector3(354.9, 6517.07, 28.22-0.97), heading =  351.79},
        {coords = vector3(347.67, 6517.13, 28.77-0.97), heading =  351.79},
        {coords = vector3(338.48, 6516.81, 28.95-0.97), heading =  351.79},
        {coords = vector3(330.63, 6517.26, 28.97-0.97), heading =  351.79},
        {coords = vector3(321.48, 6516.91, 29.13-0.97), heading =  351.79},
        {coords = vector3(321.77, 6530.72, 29.18-0.97), heading =  351.79},
        {coords = vector3(329.28, 6530.59, 28.64-0.97), heading =  351.79},
        {coords = vector3(338.1, 6530.56, 28.55-0.97), heading =  351.79},
        {coords = vector3(345.78, 6530.65, 28.74-0.97), heading =  351.79},
        {coords = vector3(353.6, 6530.37, 28.41-0.97), heading =  351.79},
        {coords = vector3(361.63, 6530.92, 28.36-0.97), heading =  351.79},
        {coords = vector3(369.46, 6531.24, 28.4-0.97), heading =  351.79},
    },
    Garden = vector3(350.95, 6515.83, 28.54)
    
}

Config.textDel = 'Press (~g~[E]~w~) Pick Oranges. Press (~g~[Backspace]~w~) to quit Picking Orange. '

Strings = {
   
    ['someone_close'] = 'There is a player too close to you!',
    ['orange'] = 'Pick Orange',
    ['process'] = 'Juice Orange',
    ['sell_orangejuice'] = 'Sell Orange Juice',
}
