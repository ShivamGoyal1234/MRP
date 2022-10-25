Config = {

    Healthcheck = false, -- Charges money when vehicle comes back with health below damage.

    Repaircost = 450, -- If enable is true sets repair cost for vehicles with health below damage amount.
    Damage = 500, -- If enable is true this sets acceptable vehicle damage level on return.

    Repair2 = false, -- If enabled you can set a secondary repair cost should be based on a higher health.
    -- Ex. based on currrent config. IF vehicle health is 700 or lower you pay a $450 repair cost, elseif vehicle health is 900 to 700 pay only $250 for repairs.
    Damage2 = 900, -- Health of secondary repair fee.
    Repaircost2 = 250, -- Repair cost for secondary damage check.

    Depositenabled = true, -- Turns on a deposit allowing player to make a portion of their money back for returning the vehicle.
    Deposit = 700, -- Deposit given back to player when returning the vehicle **Offers incentive to return vehicle.

    --Ped Spawning info
    PedCoords = vector3(109.9739, -1088.61, 28.302), -- Ped and Polyzone location, if not using polyzone go to client main lua and comment out top part.
    PedHeading = 345.64, -- Ped heading

    PedCoords2 = vector3(-282.13, -998.50, 23.33), -- Ped and Polyzone location, if not using polyzone go to client main lua and comment out top part.
    PedHeading2 = 286.06, -- Ped heading

    PedCoords3 = vector3(1852.13, 2581.85, 44.67), -- Ped and Polyzone location, if not using polyzone go to client main lua and comment out top part.
    PedHeading3 = 287.83, -- Ped heading


    --Vehicale spawning info
    VehCoords = vector4(111.4223, -1081.24, 29.192, 340.0), -- Vehicle spawn location

    VehCoords2 = vector4(-278.6, -996.66, 24.76, 250.38), -- Vehicle spawn location

    VehCoords3 = vector4(1855.37, 2578.5, 45.67, 283.94), -- Vehicle spawn location





    Vehicle1 = 'Blista',
    Vehicle1cost = 800,
    Vehicle1Spawncode = 'Blista',

    Vehicle2 = 'Asea',
    Vehicle2cost = 800,
    Vehicle2Spawncode = 'Asea',

    Vehicle3 = 'GUARDIAN',
    Vehicle3cost = 800,
    Vehicle3Spawncode = 'GUARDIAN',

    Vehicle4 = 'Vespa', ------------- Jail
    Vehicle4cost = 800,
    Vehicle4Spawncode = 'faggio',

    Vehicle5 = 'Esskey',
    Vehicle5cost = 800,
    Vehicle5Spawncode = 'esskey',

    Vehicle6 = 'Gresley',
    Vehicle6cost = 800,
    Vehicle6Spawncode = 'Gresley',
}
