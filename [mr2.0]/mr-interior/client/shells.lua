function CreateHotel(spawn)
    local objects = {}

    local POIOffsets = {}
    POIOffsets.exit = json.decode('{"z":2.5,"y":-15.901171875,"x":4.251012802124,"h":2.2633972168}')
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    RequestModel(`playerhouse_hotel`)
	while not HasModelLoaded(`playerhouse_hotel`) do
	    Citizen.Wait(1000)
	end
    local shell = CreateObject(`playerhouse_hotel`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(shell, true)
    table.insert(objects, shell)

    local curtains = CreateObject(`V_49_MotelMP_Curtains`, spawn.x + 1.55156000, spawn.y + (-3.83100100), spawn.z + 2.23457500)
    table.insert(objects, curtains)
    local window = CreateObject(`V_49_MotelMP_Curtains`, spawn.x + 1.43190000, spawn.y + (-3.92315100), spawn.z + 2.29329600)
    table.insert(objects, window)

    TeleportToInterior(spawn.x + POIOffsets.exit.x, spawn.y + POIOffsets.exit.y, spawn.z + 1.5, POIOffsets.exit.h)

    return { objects, POIOffsets }
end

function CreateTier1House(spawn, isBackdoor)
    local objects = {}

    local POIOffsets = {}
    POIOffsets.exit = json.decode('{"z":2.5,"y":-15.901171875,"x":4.251012802124,"h":2.2633972168}')
	POIOffsets.clothes = json.decode('{"z":2.5,"y":-3.9233189,"x":-7.84363671,"h":2.2633972168}')
	POIOffsets.stash = json.decode('{"z":2.5,"y":1.33868212,"x":-9.084908691,"h":2.2633972168}')
	POIOffsets.logout = json.decode('{"z":2.0,"y":-1.1463337,"x":-6.69117089,"h":2.2633972168}')
    POIOffsets.backdoor = json.decode('{"z":2.5,"y":4.3798828125,"x":0.88999176025391,"h":182.2633972168}')
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    RequestModel(`playerhouse_tier1`)
	while not HasModelLoaded(`playerhouse_tier1`) do
	    Citizen.Wait(1000)
	end
    local shell = CreateObject(`playerhouse_tier1`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(shell, true)
    table.insert(objects, shell)

    local dt = CreateObject(`V_16_DT`, spawn.x-1.21854400, spawn.y-1.04389600, spawn.z + 1.39068600, false, false, false)
    table.insert(objects, dt)

    if not isBackdoor then
        TeleportToInterior(spawn.x + POIOffsets.exit.x, spawn.y + POIOffsets.exit.y, spawn.z + 1.5, POIOffsets.exit.h)
        Citizen.Wait(100)
        TeleportToInterior(spawn.x + POIOffsets.exit.x, spawn.y + POIOffsets.exit.y, spawn.z + 1.5, POIOffsets.exit.h)
        Citizen.Wait(100)
        TeleportToInterior(spawn.x + POIOffsets.exit.x, spawn.y + POIOffsets.exit.y, spawn.z + 1.5, POIOffsets.exit.h)
    else
        TeleportToInterior(spawn.x + POIOffsets.backdoor.x, spawn.y + POIOffsets.backdoor.y, spawn.z + 1.5, POIOffsets.backdoor.h + 180)
    end

    return { objects, POIOffsets }
end

function CreateTier2House(spawn, isBackdoor)
    local objects = {}

    local POIOffsets = {}
    POIOffsets.exit = json.decode('{"z":2.5,"y":-15.901171875,"x":4.251012802124}')
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    RequestModel(`playerhouse_tier1`)
	while not HasModelLoaded(`playerhouse_tier1`) do
	    Citizen.Wait(1000)
	end
    local shell = CreateObject(`playerhouse_tier1`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(shell, true)

    table.insert(objects, shell)

    local dt = CreateObject(`V_16_DT`, spawn.x-1.21854400, spawn.y-1.04389600, spawn.z + 1.39068600, false, false, false)
    table.insert(objects, dt)


    if not isBackdoor then
        TeleportToInterior(spawn.x + 3.69693000, spawn.y - 15.080020100, spawn.z + 1.5, spawn.h)
    else
        TeleportToInterior(spawn.x + 0.88999176025391, spawn.y + 4.3798828125, spawn.z + 1.5, spawn.h)
    end

    return { objects, POIOffsets }
end

function CreateTier3House(spawn, isBackdoor)
    local objects = {}

    local POIOffsets = {}
    POIOffsets.exit = json.decode('{"y":7.7457427978516,"z":7.2074546813965,"x":-17.097534179688}')
    POIOffsets.backdoor = json.decode('{"z":5.8048210144043,"y":12.009414672852,"x":12.690063476563}')
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    RequestModel(`playerhouse_tier3`)
	while not HasModelLoaded(`playerhouse_tier3`) do
	    Citizen.Wait(1000)
	end
    local shell = CreateObject(`playerhouse_tier3`, spawn.x, spawn.y, spawn.z, false, false, false)
    table.insert(objects, shell)
    RequestModel(`v_16_high_lng_over_shadow`)
	while not HasModelLoaded(`v_16_high_lng_over_shadow`) do
	    Citizen.Wait(1000)
	end
    local windows1 = CreateObject(`v_16_high_lng_over_shadow`, spawn.x + 10.16043000, spawn.y + -4.83294600, spawn.z + 4.99192700, false, false, false)
    table.insert(objects, windows1)

    FreezeEntityPosition(shell, true)
    FreezeEntityPosition(windows1, true)

    if not isBackdoor then
        TeleportToInterior(spawn.x + POIOffsets.exit.x, spawn.y + POIOffsets.exit.y, spawn.z + POIOffsets.exit.z, spawn.h)
    else
        TeleportToInterior(spawn.x + POIOffsets.backdoor.x, spawn.y + POIOffsets.backdoor.y, spawn.z + POIOffsets.backdoor.z, spawn.h)
    end

    return { objects, POIOffsets }
end

function CreateFuryShell01(spawn, isBackdoor)
    local objects = {}

    local POIOffsets = {}
    POIOffsets.exit = json.decode('{"z":1.2,"y":-4.2,"x":0.41658}')
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    RequestModel(`fury_shell01`)
	while not HasModelLoaded(`fury_shell01`) do
	    Citizen.Wait(1000)
	end
    local shell = CreateObject(`fury_shell01`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(shell, true)

    table.insert(objects, shell)

    --local dt = CreateObject(`V_16_DT`, spawn.x-1.21854400, spawn.y-1.04389600, spawn.z + 1.39068600, false, false, false)
    --table.insert(objects, dt)


    if not isBackdoor then
        TeleportToInterior(spawn.x + 0.41658, spawn.y - 4.2, spawn.z + 0.0, spawn.h)
    else
        TeleportToInterior(spawn.x + 0.88999176025391, spawn.y + 4.3798828125, spawn.z + 1.5, spawn.h)
    end

    return { objects, POIOffsets }
end

function CreateFuryShell02(spawn, isBackdoor)
    local objects = {}

    local POIOffsets = {}
    POIOffsets.exit = json.decode('{"z":2.5,"y":-9.895818,"x":-14.54207}')
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    RequestModel(`fury_shell02`)
	while not HasModelLoaded(`fury_shell02`) do
	    Citizen.Wait(1000)
	end
    local shell = CreateObject(`fury_shell02`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(shell, true)

    table.insert(objects, shell)

    --local dt = CreateObject(`V_16_DT`, spawn.x-1.21854400, spawn.y-1.04389600, spawn.z + 1.39068600, false, false, false)
    --table.insert(objects, dt)


    if not isBackdoor then
        TeleportToInterior(spawn.x - 14.54207, spawn.y - 9.895818, spawn.z + 2.0, spawn.h)
    else
        TeleportToInterior(spawn.x + 0.88999176025391, spawn.y + 4.3798828125, spawn.z + 1.5, spawn.h)
    end

    return { objects, POIOffsets }
end

function CreateFuryShell03(spawn)
    local objects = {}

    local POIOffsets = {}
    POIOffsets.exit = json.decode('{"z":9.0,"y":3.307809,"x":-3.741532}')
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    RequestModel(`fury_shell03`)
	while not HasModelLoaded(`fury_shell03`) do
	    Citizen.Wait(1000)
	end
    local shell = CreateObject(`fury_shell03`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(shell, true)

    table.insert(objects, shell)

        TeleportToInterior(spawn.x - 3.8, spawn.y + 3.307809, spawn.z + 9.0, spawn.h)

    return { objects, POIOffsets }
end

function CreateFuryShell05(spawn)
    local objects = {}

    local POIOffsets = {}
    POIOffsets.exit = json.decode('{"z":1.4,"y":-6.240536,"x":-1.59413}')
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    RequestModel(`fury_shell05`)
	while not HasModelLoaded(`fury_shell05`) do
	    Citizen.Wait(1000)
	end
    local shell = CreateObject(`fury_shell05`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(shell, true)

    table.insert(objects, shell)

        TeleportToInterior(spawn.x - 1.59413, spawn.y - 6.240536, spawn.z + 1.3, spawn.h)

    return { objects, POIOffsets }
end

function CreateWarehouse(spawn, isBackdoor)
    local objects = {}

    local POIOffsets = {}
    POIOffsets.exit = json.decode('{"z":1.5,"y":0.01,"x":-8.5}')
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    RequestModel(`warehouse_shell`)
    while not HasModelLoaded(`warehouse_shell`) do
        Citizen.Wait(1000)
    end
    local shell = CreateObject(`warehouse_shell`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(shell, true)

    table.insert(objects, shell)

    local dt = CreateObject(V_16_DT, spawn.x-1.21854400, spawn.y-1.04389600, spawn.z + 1.39068600, false, false, false)
    table.insert(objects, dt)


    if not isBackdoor then
        TeleportToInterior(spawn.x + POIOffsets.exit.x, spawn.y + POIOffsets.exit.y, spawn.z + POIOffsets.exit.z, spawn.h)
    else
        TeleportToInterior(spawn.x + POIOffsets.exit.x, spawn.y + POIOffsets.exit.y, spawn.z + POIOffsets.exit.z, spawn.h)
    end

    return { objects, POIOffsets }
end

function CreateFuryShell04(spawn)
    local objects = {}

    local POIOffsets = {}
    POIOffsets.exit = json.decode('{"z":3.1,"y":-5.987,"x":-17.407}')
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    RequestModel(`fury_shell04`)
	while not HasModelLoaded(`fury_shell04`) do
	    Citizen.Wait(1000)
	end
    local shell = CreateObject(`fury_shell04`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(shell, true)

    table.insert(objects, shell)

    TeleportToInterior(spawn.x - 16.899, spawn.y - 5.987, spawn.z + 1.95, spawn.h)

    return { objects, POIOffsets }
end


function CreateFuryShell06(spawn)
    local objects = {}

    local POIOffsets = {}
    POIOffsets.exit = json.decode('{"z":1.95,"y":-5.987,"x":-17.407}')
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    RequestModel(`fury_shell06`)
	while not HasModelLoaded(`fury_shell06`) do
	    Citizen.Wait(1000)
	end
    local shell = CreateObject(`fury_shell06`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(shell, true)

    local detail = CreateObject(fury_shell06_detail, spawn.x, spawn.y, spawn.z, false, false, false)

    table.insert(objects, shell)
    table.insert(objects, detail)

    TeleportToInterior(spawn.x - 16.899, spawn.y - 5.987, spawn.z + 1.95, spawn.h)

    return { objects, POIOffsets }
end

function Createluxaryapt(spawn)
    local objects = {}

    local POIOffsets = {}
    POIOffsets.exit = json.decode('{"z":2.5,"y":7,"x":2.5,"h":1.2633972168}')
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    RequestModel(`small_house1`)
	while not HasModelLoaded(`small_house1`) do
	    Citizen.Wait(1000)
	end
    local shell = CreateObject(`small_house1`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(shell, true)


    table.insert(objects, shell)

    -- TeleportToInterior(spawn.x - 16.899, spawn.y - 5.987, spawn.z + 1.95, spawn.h)
    if not isBackdoor then
        TeleportToInterior(spawn.x + POIOffsets.exit.x, spawn.y + POIOffsets.exit.y, spawn.z + POIOffsets.exit.z, spawn.h)
    else
        TeleportToInterior(spawn.x + POIOffsets.backdoor.x, spawn.y + POIOffsets.backdoor.y, spawn.z + POIOffsets.backdoor.z, spawn.h)
    end

    return { objects, POIOffsets }
end

function Createluxarymanson(spawn)
    local objects = {}

    local POIOffsets = {}
    POIOffsets.exit = json.decode('{"z":2.5,"y":-11.901171875,"x":4.251012802124,"h":2.2633972168}')
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    RequestModel(`max_villa2`)
	while not HasModelLoaded(`max_villa2`) do
	    Citizen.Wait(1000)
	end
    local shell = CreateObject(`max_villa2`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(shell, true)


    table.insert(objects, shell)

    -- TeleportToInterior(spawn.x - 16.899, spawn.y - 5.987, spawn.z + 1.95, spawn.h)

    if not isBackdoor then
        TeleportToInterior(spawn.x + POIOffsets.exit.x, spawn.y + POIOffsets.exit.y, spawn.z + POIOffsets.exit.z, spawn.h)
    else
        TeleportToInterior(spawn.x + POIOffsets.backdoor.x, spawn.y + POIOffsets.backdoor.y, spawn.z + POIOffsets.backdoor.z, spawn.h)
    end

    return { objects, POIOffsets }
end

function Createsmallapt(spawn)
    local objects = {}

    local POIOffsets = {}
    POIOffsets.exit = json.decode('{"z":1.5,"y":3,"x":2.5,"h":1.2633972168}')
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    RequestModel(`maxcreations_small`)
	while not HasModelLoaded(`maxcreations_small`) do
	    Citizen.Wait(1000)
	end
    local shell = CreateObject(`maxcreations_small`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(shell, true)


    table.insert(objects, shell)

    -- TeleportToInterior(spawn.x - 16.899, spawn.y - 5.987, spawn.z + 1.95, spawn.h)
    if not isBackdoor then
        TeleportToInterior(spawn.x + POIOffsets.exit.x, spawn.y + POIOffsets.exit.y, spawn.z + POIOffsets.exit.z, spawn.h)
    else
        TeleportToInterior(spawn.x + POIOffsets.backdoor.x, spawn.y + POIOffsets.backdoor.y, spawn.z + POIOffsets.backdoor.z, spawn.h)
    end

    return { objects, POIOffsets }
end

