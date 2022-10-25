RegisterNetEvent('aj-chopshop:StartMenu', function()
    if Config.Menu == "nh" then
        TriggerEvent('nh-context:sendMenu', {
            {
                id = 1,
                header = "Chop Parts",
                txt = ""
            },
            {
                id = 2,
                header = "Door",
                txt = "",
                params = {
                    event = "aj-chopshop:chopdoor",
                    args = {
                        number = 1,
                        id = 2
                    }
                }
            },
            {
                id = 3,
                header = "Wheel",
                txt = "",
                params = {
                    event = "aj-chopshop:chopwheel",
                    args = {
                        number = 1,
                        id = 3
                    }
                }
            },
            {
                id = 4,
                header = "Hood",
                txt = "",
                params = {
                    event = "aj-chopshop:chophood",
                    args = {
                        number = 1,
                        id = 4
                    }
                }
            },
            {
                id = 5,
                header = "Trunk",
                txt = "",
                params = {
                    event = "aj-chopshop:choptrunk",
                    args = {
                        number = 1,
                        id = 5
                    }
                }
            },
        })
    elseif Config.Menu == "qb" then
        exports['aj-menu']:openMenu({
            {
                header = "Chop Vehicle Parts",
                isMenuHeader = true
            },
            {
                header = "",
                txt = "Door",
                params = {
                    event = "aj-chopshop:chopdoor"
                }
            },
            {
                header = "",
                txt = "Wheel",
                params = {
                    event = "aj-chopshop:chopwheel"
                }
            },
            {
                header = "",
                txt = "Hood",
                params = {
                    event = "aj-chopshop:chophood"
                }
            },
            {
                header = "",
                txt = "Trunk",
                params = {
                    event = "aj-chopshop:choptrunk"
                }
            },
            {
                header = "⬅ Close Menu",
                txt = "",
                params = {
                    event = "aj-menu:client:closeMenu"
                }
            },
        })
    end
end)

-- RegisterNetEvent('aj-chopshop:chopdoor')
-- AddEventHandler('aj-chopshop:chopdoor', function()
--     TriggerServerEvent("aj-chopshop:server:chopdoor")
-- end)

-- RegisterNetEvent('aj-chopshop:chopwheel')
-- AddEventHandler('aj-chopshop:chopwheel', function()
--     TriggerServerEvent("aj-chopshop:server:chopwheel")
-- end)

-- RegisterNetEvent('aj-chopshop:chophood')
-- AddEventHandler('aj-chopshop:chophood', function()
--     TriggerServerEvent("aj-chopshop:server:chophood")
-- end)

-- RegisterNetEvent('aj-chopshop:choptrunk')
-- AddEventHandler('aj-chopshop:choptrunk', function()
--     TriggerServerEvent("aj-chopshop:server:choptrunk")
-- end)

local cooldown = false

RegisterNetEvent('aj-chopshop:chopdoor')
AddEventHandler('aj-chopshop:chopdoor', function()
    if not cooldown then
        cooldown = true
        TriggerServerEvent("aj-chopshop:server:chopdoor")
        Wait(14000)
        cooldown = false
    else
        AJFW.Functions.Notify("You need to finish this one first", 'error')
    end
end)

RegisterNetEvent('aj-chopshop:chopwheel')
AddEventHandler('aj-chopshop:chopwheel', function()
    if not cooldown then
        cooldown = true
        TriggerServerEvent("aj-chopshop:server:chopwheel")
        Wait(14000)
        cooldown = false
    else
        AJFW.Functions.Notify("You need to finish this one first", 'error')
    end
end)

RegisterNetEvent('aj-chopshop:chophood')
AddEventHandler('aj-chopshop:chophood', function()
    if not cooldown then
        cooldown = true
        TriggerServerEvent("aj-chopshop:server:chophood")
        Wait(14000)
        cooldown = false
    else
        AJFW.Functions.Notify("You need to finish this one first", 'error')
    end
end)

RegisterNetEvent('aj-chopshop:choptrunk')
AddEventHandler('aj-chopshop:choptrunk', function()
    if not cooldown then
        cooldown = true
        TriggerServerEvent("aj-chopshop:server:choptrunk")
        Wait(14000)
        cooldown = false
    else
        AJFW.Functions.Notify("You need to finish this one first", 'error')
    end
end)