local AJFW = exports['ajfw']:GetCoreObject()
local Menu
local Options

local function open(value)
    exports['aj-menu']:openMenu(value)
end

RegisterNetEvent('aj-gps:OpenMenu', function()
    Menu = {
        {
            isMenuHeader = true,
            header = 'GPS'
        },
    }
    for i = 1 , #Config.Locations do
        Menu[#Menu + 1] = {
            header = Config.Locations[i].label,
            params = {
                event = 'aj-gps:ShowOptions',
                args = {
                    options = Config.Locations[i].locations
                }
            }
        }
    end
    open(Menu)
end)

RegisterNetEvent('aj-gps:ShowOptions', function(data)
    Options = {
        {
            header = '< GO BACK',
            params = {
                event = 'aj-gps:OpenMenu'
            }
        }
    }
    for i = 1, #data.options do
        Options[#Options + 1] = {
            header = data.options[i].label,
            params = {
                event = 'aj-gps:SetWaypoint',
                args = {
                    coords = data.options[i].coords,
                    label  = data.options[i].label
                }
            }
        }
    end
    open(Options)
end)

RegisterNetEvent('aj-gps:SetWaypoint',function(data)
    SetNewWaypoint(data.coords.x, data.coords.y)
    AJFW.Functions.Notify('GPS set to '..data.label, "success")
end)

RegisterCommand('+gps', function()
    TriggerEvent('aj-gps:OpenMenu')
end)

RegisterKeyMapping("+gps", "GPS", "keyboard", "f11")

exports['aj-eye']:AddBoxZone("benny-stash", vector3(-224.26, -1319.96, 30.89), 0.7, 3.2, {
    name="bennystash",
    heading=180.1992,
    debugPoly=false,
    minZ=30.07834,
    maxZ=32.27834,
    }, {
        options = {
            {
                type = "client",
                event = "mechanic:bennys:pstash",
                icon = "fas fa-hammer",
                label = "Personal stash",
                job = "bennys",
            },
            {
                type = "client",
                event = "mechanic:bennys:mstash",
                icon = "fas fa-hammer",
                label = "Benny stash",
                job = "bennys",
            },
        },
        distance = 1.5
    }
)