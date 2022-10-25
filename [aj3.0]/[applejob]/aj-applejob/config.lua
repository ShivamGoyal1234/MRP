Config = {}

Config = {
    ChanceToGetItem = 20, -- if math.random(0, 100) <= ChanceToGetItem then give item
    Items = {'apple','apple','apple','apple','apple'},
    Process = vector3(421.21, 6467.73, 28.81),
    Objects = {
        ['pickaxe'] = 'w_me_hatchet',
    },
    ApplePosition = {
        {coords = vector3(282.05, 6505.74, 30.13-0.97), heading = 351.79},
        {coords = vector3(273.68, 6506.5, 30.41-0.97), heading =  351.79},
        {coords = vector3(264.22, 6505.65, 30.67-0.97), heading = 351.79},
        {coords = vector3(255.97, 6503.49, 30.87-0.97), heading =  351.79},
        {coords = vector3(246.87, 6502.5, 31.05-0.97), heading =  351.79},
        {coords = vector3(281.2, 6518.4, 30.16-0.97), heading =  351.79},
        {coords = vector3(272.56, 6518.74, 30.44-0.97), heading =  351.79},
        {coords = vector3(262.11, 6516.08, 30.72-0.97), heading =  351.79},
        {coords = vector3(253.24, 6513.75, 30.93-0.97), heading =  351.79},
        {coords = vector3(280.22, 6530.18, 30.2-0.97), heading =  351.79},
        {coords = vector3(270.88, 6530.14, 30.49-0.97), heading =  351.79},
        {coords = vector3(261.53, 6527.12, 30.74-0.97), heading =  351.79},
        {coords = vector3(251.77, 6526.82, 30.96-0.97), heading =  351.79},
    },
    
}

Config.textDel = 'Press (~g~[E]~w~) Pick Apples'

Strings = {
   
    ['someone_close'] = 'There is a player too close to you!',
    ['apple'] = 'Pick Apple',
    ['process'] = 'Juice Apple',
    ['sell_applejuice'] = 'Sell Apple Juice',
}
