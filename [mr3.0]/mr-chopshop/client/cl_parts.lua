RegisterNetEvent('mr-chopshop:StartMenu', function()
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
                    event = "mr-chopshop:chopdoor",
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
                    event = "mr-chopshop:chopwheel",
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
                    event = "mr-chopshop:chophood",
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
                    event = "mr-chopshop:choptrunk",
                    args = {
                        number = 1,
                        id = 5
                    }
                }
            },
        })
    elseif Config.Menu == "qb" then
        exports['mr-menu']:openMenu({
            {
                header = "Chop Vehicle Parts",
                isMenuHeader = true
            },
            {
                header = "",
                txt = "Door",
                params = {
                    event = "mr-chopshop:chopdoor"
                }
            },
            {
                header = "",
                txt = "Wheel",
                params = {
                    event = "mr-chopshop:chopwheel"
                }
            },
            {
                header = "",
                txt = "Hood",
                params = {
                    event = "mr-chopshop:chophood"
                }
            },
            {
                header = "",
                txt = "Trunk",
                params = {
                    event = "mr-chopshop:choptrunk"
                }
            },
            {
                header = "⬅ Close Menu",
                txt = "",
                params = {
                    event = "mr-menu:client:closeMenu"
                }
            },
        })
    end
end)

-- RegisterNetEvent('mr-chopshop:chopdoor')
-- AddEventHandler('mr-chopshop:chopdoor', function()
--     TriggerServerEvent("mr-chopshop:server:chopdoor")
-- end)

-- RegisterNetEvent('mr-chopshop:chopwheel')
-- AddEventHandler('mr-chopshop:chopwheel', function()
--     TriggerServerEvent("mr-chopshop:server:chopwheel")
-- end)

-- RegisterNetEvent('mr-chopshop:chophood')
-- AddEventHandler('mr-chopshop:chophood', function()
--     TriggerServerEvent("mr-chopshop:server:chophood")
-- end)

-- RegisterNetEvent('mr-chopshop:choptrunk')
-- AddEventHandler('mr-chopshop:choptrunk', function()
--     TriggerServerEvent("mr-chopshop:server:choptrunk")
-- end)

local cooldown = false

RegisterNetEvent('mr-chopshop:chopdoor')
AddEventHandler('mr-chopshop:chopdoor', function()
    if not cooldown then
        cooldown = true
        TriggerServerEvent("mr-chopshop:server:chopdoor")
        Wait(14000)
        cooldown = false
    else
        MRFW.Functions.Notify("You need to finish this one first", 'error')
    end
end)

RegisterNetEvent('mr-chopshop:chopwheel')
AddEventHandler('mr-chopshop:chopwheel', function()
    if not cooldown then
        cooldown = true
        TriggerServerEvent("mr-chopshop:server:chopwheel")
        Wait(14000)
        cooldown = false
    else
        MRFW.Functions.Notify("You need to finish this one first", 'error')
    end
end)

RegisterNetEvent('mr-chopshop:chophood')
AddEventHandler('mr-chopshop:chophood', function()
    if not cooldown then
        cooldown = true
        TriggerServerEvent("mr-chopshop:server:chophood")
        Wait(14000)
        cooldown = false
    else
        MRFW.Functions.Notify("You need to finish this one first", 'error')
    end
end)

RegisterNetEvent('mr-chopshop:choptrunk')
AddEventHandler('mr-chopshop:choptrunk', function()
    if not cooldown then
        cooldown = true
        TriggerServerEvent("mr-chopshop:server:choptrunk")
        Wait(14000)
        cooldown = false
    else
        MRFW.Functions.Notify("You need to finish this one first", 'error')
    end
end)