function Load(name)
	local resourceName = GetCurrentResourceName()
	local chunk = LoadResourceFile(resourceName, ('data/%s.lua'):format(name))
	if chunk then
		local err
		chunk, err = load(chunk, ('@@%s/data/%s.lua'):format(resourceName, name), 't')
		if err then
			error(('\n^1 %s'):format(err), 0)
		end
		return chunk()
	end
end

-------------------------------------------------------------------------------
-- Settings
-------------------------------------------------------------------------------

Config = {}

-- It's possible to interact with entities through walls so this should be low
Config.MaxDistance = 5.0

-- Enable debug options
Config.Debug = false

-- Supported values: true, false
Config.Standalone = false

-- Enable outlines around the entity you're looking at
Config.EnableOutline = false

-- Enable default options (Toggling vehicle doors)
Config.EnableDefaultOptions = true

-- Disable the target eye whilst being in a vehicle
Config.DisableInVehicle = false

-- Key to open the target
Config.OpenKey = 'LMENU' -- Left Alt
Config.OpenControlKey = 19 -- Control for keypress detection also Left Alt for the eye itself, controls are found here https://docs.fivem.net/docs/game-references/controls/

-- Key to open the menu
Config.MenuControlKey = 238 -- Control for keypress detection on the context menu, this is the Right Mouse Button, controls are found here https://docs.fivem.net/docs/game-references/controls/

-------------------------------------------------------------------------------
-- Target Configs
-------------------------------------------------------------------------------

-- These are all empty for you to fill in, refer to the .md files for help in filling these in

Config.CircleZones = {

	["appletree1"] = {
        name = "Apple Tree1",
        coords = vector3(282.14, 6506.5, 30.13),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-applejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Apple",
            },
        },
        distance = 2.0
    },

	["appletree2"] = {
        name = "Apple Tree2",
        coords = vector3(273.41, 6507.39, 30.42),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-applejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Apple",
            },
        },
        distance = 2.0
    },

	["appletree3"] = {
        name = "Apple Tree3",
        coords = vector3(264.04, 6505.85, 30.67),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-applejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Apple",
            },
        },
        distance = 2.0
    },

	["appletree4"] = {
        name = "Apple Tree4",
        coords = vector3(256.14, 6503.79, 30.86),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-applejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Apple",
            },
        },
        distance = 2.0
    },

	["appletree5"] = {
        name = "Apple Tree5",
        coords = vector3(246.66, 6502.98, 31.05),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-applejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Apple",
            },
        },
        distance = 2.0
    },

	["appletree6"] = {
        name = "Apple Tree6",
        coords = vector3(236.75, 6501.72, 31.21),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-applejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Apple",
            },
        },
        distance = 2.0
    },

	["appletree7"] = {
        name = "Apple Tree7",
        coords = vector3(227.85, 6501.38, 31.31),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-applejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Apple",
            },
        },
        distance = 2.0
    },

	["appletree8"] = {
        name = "Apple Tree8",
        coords = vector3(219.92, 6499.35, 31.39),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-applejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Apple",
            },
        },
        distance = 2.0
    },

	["appletree9"] = {
        name = "Apple Tree9",
        coords = vector3(209.94, 6498.25, 31.45),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-applejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Apple",
            },
        },
        distance = 2.0
    },

	["appletree10"] = {
        name = "Apple Tree10",
        coords = vector3(201.54, 6497.24, 31.47),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-applejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Apple",
            },
        },
        distance = 2.0
    },

	["appletree11"] = {
        name = "Apple Tree11",
        coords = vector3(194.06, 6497.31, 31.52),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-applejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Apple",
            },
        },
        distance = 2.0
    },

	["appletree12"] = {
        name = "Apple Tree12",
        coords = vector3(185.25, 6498.15, 31.54),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-applejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Apple",
            },
        },
        distance = 2.0
    },

	["appletree13"] = {
        name = "Apple Tree13",
        coords = vector3(199.71, 6508.74, 31.51),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-applejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Apple",
            },
        },
        distance = 2.0
    },

	["appletree14"] = {
        name = "Apple Tree14",
        coords = vector3(208.58, 6509.93, 31.47),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-applejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Apple",
            },
        },
        distance = 2.0
    },

	["appletree15"] = {
        name = "Apple Tree15",
        coords = vector3(218.0, 6510.1, 31.4),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-applejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Apple",
            },
        },
        distance = 2.0
    },

	["appletree16"] = {
        name = "Apple Tree16",
        coords = vector3(225.81, 6511.62, 31.33),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-applejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Apple",
            },
        },
        distance = 2.0
    },

	["appletree17"] = {
        name = "Apple Tree17",
        coords = vector3(234.28, 6512.59, 31.24),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-applejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Apple",
            },
        },
        distance = 2.0
    },

	["appletree18"] = {
        name = "Apple Tree18",
        coords = vector3(244.68, 6515.33, 31.09),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-applejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Apple",
            },
        },
        distance = 2.0
    },

	["appletree19"] = {
        name = "Apple Tree19",
        coords = vector3(253.53, 6514.22, 30.92),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-applejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Apple",
            },
        },
        distance = 2.0
    },

	["appletree20"] = {
        name = "Apple Tree20",
        coords = vector3(262.4, 6516.34, 30.71),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-applejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Apple",
            },
        },
        distance = 2.0
    },

	["appletree21"] = {
        name = "Apple Tree21",
        coords = vector3(272.54, 6519.08, 30.44),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-applejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Apple",
            },
        },
        distance = 2.0
    },

	["appletree22"] = {
        name = "Apple Tree22",
        coords = vector3(281.24, 6518.74, 30.16),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-applejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Apple",
            },
        },
        distance = 2.0
    },

	["appletree23"] = {
        name = "Apple Tree23",
        coords = vector3(280.51, 6530.91, 30.19),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-applejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Apple",
            },
        },
        distance = 2.0
    },

	["appletree24"] = {
        name = "Apple Tree24",
        coords = vector3(270.47, 6530.5, 30.5),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-applejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Apple",
            },
        },
        distance = 2.0
    },

	["appletree25"] = {
        name = "Apple Tree25",
        coords = vector3(261.51, 6527.54, 30.74),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-applejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Apple",
            },
        },
        distance = 2.0
    },

	["appletree26"] = {
        name = "Apple Tree26",
        coords = vector3(251.99, 6527.29, 30.96),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-applejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Apple",
            },
        },
        distance = 2.0
    },

	["appletree27"] = {
        name = "Apple Tree27",
        coords = vector3(242.88, 6526.34, 31.1),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-applejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Apple",
            },
        },
        distance = 2.0
    },

	["appletree28"] = {
        name = "Apple Tree28",
        coords = vector3(233.25, 6524.92, 31.24),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-applejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Apple",
            },
        },
        distance = 2.0
    },

	["appletree29"] = {
        name = "Apple Tree29",
        coords = vector3(223.92, 6523.94, 31.35),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-applejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Apple",
            },
        },
        distance = 2.0
    },


	----------------Orange---------------------
	["orangetree1"] = {
        name = "Orange Tree1",
        coords = vector3(378.05, 6505.72, 27.94),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-orangejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Orange",
            },
        },
        distance = 2.0
    },

	["orangetree2"] = {
        name = "Orange Tree2",
        coords = vector3(370.19, 6505.86, 28.42),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-orangejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Orange",
            },
        },
        distance = 2.0
    },

	["orangetree3"] = {
        name = "Orange Tree3",
        coords = vector3(363.18, 6505.72, 28.54),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-orangejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Orange",
            },
        },
        distance = 2.0
    },

	["orangetree4"] = {
        name = "Orange Tree4",
        coords = vector3(355.17, 6505.11, 28.47),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-orangejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Orange",
            },
        },
        distance = 2.0
    },

	["orangetree5"] = {
        name = "Orange Tree5",
        coords = vector3(347.79, 6505.46, 28.81),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-orangejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Orange",
            },
        },
        distance = 2.0
    },

	["orangetree6"] = {
        name = "Orange Tree6",
        coords = vector3(339.79, 6505.74, 28.68),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-orangejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Orange",
            },
        },
        distance = 2.0
    },

	["orangetree7"] = {
        name = "Orange Tree7",
        coords = vector3(330.84, 6505.74, 28.56),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-orangejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Orange",
            },
        },
        distance = 2.0
    },

	["orangetree8"] = {
        name = "Orange Tree8",
        coords = vector3(321.79, 6505.51, 29.21),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-orangejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Orange",
            },
        },
        distance = 2.0
    },

	["orangetree9"] = {
        name = "Orange Tree9",
        coords = vector3(321.74, 6517.45, 29.13),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-orangejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Orange",
            },
        },
        distance = 2.0
    },

	["orangetree10"] = {
        name = "Orange Tree10",
        coords = vector3(330.28, 6517.63, 28.97),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-orangejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Orange",
            },
        },
        distance = 2.0
    },

	["orangetree11"] = {
        name = "Orange Tree11",
        coords = vector3(338.72, 6517.08, 28.94),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-orangejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Orange",
            },
        },
        distance = 2.0
    },

	["orangetree12"] = {
        name = "Orange Tree12",
        coords = vector3(347.53, 6517.44, 28.79),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-orangejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Orange",
            },
        },
        distance = 2.0
    },

	["orangetree13"] = {
        name = "Orange Tree13",
        coords = vector3(355.27, 6517.5, 28.2),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-orangejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Orange",
            },
        },
        distance = 2.0
    },

	["orangetree14"] = {
        name = "Orange Tree14",
        coords = vector3(362.83, 6517.68, 28.27),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-orangejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Orange",
            },
        },
        distance = 2.0
    },

	["orangetree15"] = {
        name = "Orange Tree15",
        coords = vector3(370.07, 6517.87, 28.37),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-orangejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Orange",
            },
        },
        distance = 2.0
    },

	["orangetree16"] = {
        name = "Orange Tree16",
        coords = vector3(378.06, 6517.45, 28.36),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-orangejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Orange",
            },
        },
        distance = 2.0
    },

	["orangetree17"] = {
        name = "Orange Tree17",
        coords = vector3(369.4, 6531.81, 28.4),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-orangejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Orange",
            },
        },
        distance = 2.0
    },

	["orangetree18"] = {
        name = "Orange Tree18",
        coords = vector3(361.32, 6531.6, 28.36),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-orangejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Orange",
            },
        },
        distance = 2.0
    },

	["orangetree19"] = {
        name = "Orange Tree19",
        coords = vector3(353.84, 6530.75, 28.41),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-orangejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Orange",
            },
        },
        distance = 2.0
    },

	["orangetree20"] = {
        name = "Orange Tree20",
        coords = vector3(345.86, 6531.38, 28.72),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-orangejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Orange",
            },
        },
        distance = 2.0
    },

	["orangetree21"] = {
        name = "Orange Tree21",
        coords = vector3(338.6, 6531.19, 28.56),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-orangejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Orange",
            },
        },
        distance = 2.0
    },

	["orangetree22"] = {
        name = "Orange Tree22",
        coords = vector3(329.44, 6531.16, 28.62),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-orangejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Orange",
            },
        },
        distance = 2.0
    },

	["orangetree23"] = {
        name = "Orange Tree23",
        coords = vector3(321.75, 6531.22, 29.18),
        radius = 1.0,
        debugPoly = false,
        options = {
            {
                type = "client",
                event = "mr-orangejob:collect",
                icon = "fas fa-cogs",
                label = "Collect Orange",
            },
        },
        distance = 2.0
    },


}

Config.BoxZones = {

    ["MDT"] = {
        name = "MDT",
        coords = vector3(484.78, -999.94, 30.69),
        length = 3.4,
        width = 1.6,
        heading = 263,
        debugPoly = false,
        minZ = 29.49,
        maxZ = 31.09,
        options = {
        {
        type = "client",
        event = "mdt:client:open",
        icon = "fas fa-shield-alt",
        label = "MDT",
        job = "police"
        }
        },
        distance = 1.5
        },

	["boxzone1"] = {
        name = "MissionRowDutyClipboard",
		coords = vector3(441.7989, -982.0529, 30.67834),
        length = 0.45,
        width = 0.35,
        heading = 11.0,
        debugPoly = false,
        minZ = 30.77834,
        maxZ = 30.87834,
        options = {
            {
                type = "client",
                event = "mr-policejob:ToggleDuty",
                icon = "fas fa-sign-in-alt",
                label = "Sign In/Out",
                job = "police",
            },
        },
        distance = 3.5
    },

	["boxzone2"] = {
        name = "PD Armory",
        coords = vector3(482.48, -995.00, 30.69),
        length = 0.55,
        width = 0.55,
        heading = 90.0,
        debugPoly = false,
        minZ = 30.30,
        maxZ = 31.30,
        options = {
            {
                type = "client",
                event = "mr-policejob:armory",
                icon = "fas fa-store",
                label = "Armory",
                job = "police",
            },
        },
        distance = 2.5
    },

	["boxzone3"] = {
        name = "Doctor Duty",
        coords = vector3(309.00, -593.10, 42.54),
        length = 1.0,
        width = 2.5,
        heading = 30.0,
        debugPoly = false,
        minZ = 43.00,
        maxZ = 44.00,
        options = {
            {
                type = "client",
                event = "hospital:ToggleDuty",
                icon = "fas fa-sign-in-alt",
                label = "Sign In/Out",
                job = "doctor",
            },
			{
                type = "client",
                event = "hospital:ToggleDuty2",
                icon = "fas fa-sign-in-alt",
                label = "Sign In/Out as Doctor",
                job = "doctor",
            },
        },
        distance = 5.0
    },

	["boxzone4"] = {
        name = "Saftey Deposit",
        coords = vector3(436.40, -974.57, 30.72),
        length = 1.0,
        width = 2.5,
        heading = 90.0,
        debugPoly = false,
        minZ = 30.00,
        maxZ = 31.50,
        options = {
            {
                type = "client",
                event = "police:outsidestash",
                icon = "fas fa-box",
                label = "Safety Box",
            },
        },
        distance = 3.0
    },

	["boxzone5"] = {
        name = "Normal Crafting",
        coords = vector3(1021.30, -2404.8, 30.14),
        length = 1.0,
        width = 1.0,
        heading = 262.33,
        debugPoly = false,
        minZ = 29.90,
        maxZ = 30.30,
        options = {
            {
                type = "client",
                event = "crafting:normal",
                icon = "fas fa-cogs",
                label = "Crafting",
            },
        },
        distance = 3.0
    },

	["boxzone6a"] = {
        name = "Attachment Crafting",
        coords = vector3(-180.33, 6550.96, 3.89),
        length = 1.0,
        width = 1.0,
        heading = 312.88,
        debugPoly = false,
        minZ = 2.75,
        maxZ = 3.05,
        options = {
            {
                type = "client",
                event = "crafting:attachement",
                icon = "fas fa-cogs",
                label = "Attachment Crafting",
            },
        },
        distance = 3.0
    },

	["boxzone6b"] = {
        name = "Attachment Crafting 2",
        coords = vector3(-176.71, 6547.46, 3.89),
        length = 1.0,
        width = 1.0,
        heading = 312.88,
        debugPoly = false,
        minZ = 2.75,
        maxZ = 3.05,
        options = {
            {
                type = "client",
                event = "crafting:attachement",
                icon = "fas fa-cogs",
                label = "Attachment Crafting",
            },
        },
        distance = 3.0
    },

	["boxzone7"] = {
        name = "MCD Cooking",
        coords = vector3(95.70, 294.79, 109.65),
        length = 1.0,
        width = 1.5,
        heading = 340.97,
        debugPoly = false,
        minZ = 110.00,
        maxZ = 110.50,
        options = {
            {
                type = "client",
                event = "crafting:mcd",
                icon = "fas fa-cogs",
                label = "MCD Cooking",
				job = "mcd",
            },
        },
        distance = 3.0
    },

	-- ["boxzone8"] = {
    --     name = "Coffee House",
    --     coords = vector3(-629.55, 223.00, 81.88),
    --     length = 1.0,
    --     width = 1.0,
    --     heading = 184.08,
    --     debugPoly = false,
    --     minZ = 81.50,
    --     maxZ = 82.00,
    --     options = {
    --         {
    --             type = "client",
    --             event = "crafting:pasta",
    --             icon = "fas fa-cogs",
    --             label = "Pasta Making",
	-- 			job = "beanmachine",
    --         },
    --     },
    --     distance = 3.0
    -- },

	-- ["boxzone9"] = {
    --     name = "Coffee House2",
    --     coords = vector3(-627.75, 223.00, 81.88),
    --     length = 0.5,
    --     width = 0.5,
    --     heading = 184.08,
    --     debugPoly = false,
    --     minZ = 82.10,
    --     maxZ = 82.50,
    --     options = {
	-- 		{
    --             type = "client",
    --             event = "crafting:tea",
    --             icon = "fas fa-cogs",
    --             label = "Tea Making",
	-- 			job ="beanmachine",
    --         },
    --     },
    --     distance = 3.0
    -- },

	["boxzone10"] = {
        name = "Mechanic Crafting",
        coords = vector3(-346.20, -110.9, 39.02),
        length = 1.0,
        width = 3.0,
        heading = 71.0,
        debugPoly = false,
        minZ = 38.80,
        maxZ = 39.30,
        options = {
            {
                type = "client",
                event = "crafting:mech",
                icon = "fas fa-cogs",
                label = "Mechanic Crafting",
				job = {
					["mechanic"] = 4,
				}
            },
        },
        distance = 3.0
    },

	["boxzone11"] = {
        name = "Dhaba",
        coords = vector3(-384.90, 265.2, 86.43),
        length = 1.0,
        width = 1.0,
        heading = 88.68,
        debugPoly = false,
        minZ = 86.30,
        maxZ = 86.70,
        options = {
            {
                type = "client",
                event = "crafting:dhaba",
                icon = "fas fa-cogs",
                label = "Dhaba",
				job = "dhaba"
            },
        },
        distance = 3.0
    },

	["boxzone12"] = {
        name = "Juice Making",
        coords = vector3(2740.90, 4412.50, 49.66),
        length = 0.5,
        width = 0.5,
        heading = 13.83,
        debugPoly = false,
        minZ = 48.50,
        maxZ = 49.00,
        options = {
            {
                type = "server",
                event = "mr-vineyard:server:grapeJuice",
                icon = "fas fa-cogs",
                label = "Grapes Juice",
            },
			{
                type = "client",
                event = "mr-applejob:applejuice",
                icon = "fas fa-cogs",
                label = "Apple Juice",
            },
			{
                type = "client",
                event = "mr-orangejob:orangejuice",
                icon = "fas fa-cogs",
                label = "Orange Juice",
            },
        },
        distance = 3.0
    },

	["boxzone13"] = {
        name = "mechanic duty",
        coords = vector3(-339.96, -156.64, 44.49),
        length = 0.55,
        width = 0.55,
        heading = 50.0,
        debugPoly = false,
        minZ = 44.3,
        maxZ = 44.5,
        options = {
            {
                type = "client",
                event = "mr-mechanicjob:ToggleDuty",
                icon = "fas fa-sign-in-alt",
                label = "Sign In/Out",
                job = "mechanic",
            },

            {
                type = "client",
                event = "bossmenu:open",
                icon = "fa-solid fa-book-journal-whills",
                label = "Job Management",
                job = {
					["mechanic"] = 5,
				}
            },
        },
        distance = 3.5
    },

    ["boxzone14"] = {
        name = "Goverment Duty",
		coords = vector3(-1293.71, -569.9, 31.51),
        length = 0.5,
        width = 0.5,
        heading = 357.49,
        debugPoly = false,
        minZ = 30.30,
        maxZ = 31.00,
        options = {
            {
                type = "client",
                event = "government:ToggleDuty",
                icon = "fas fa-sign-in-alt",
                label = "Sign In/Out",
                job = "government",
            },
        },
        distance = 3.5
    },

    ["boxzone15"] = {
        name = "Public Record",
		coords = vector3(-551.89, -192.34, 38.22),
        length = 6.0,
        width = 1.0,
        heading = 300,
        debugPoly = false,
        minZ = 37.70,
        maxZ = 38.50,
        options = {
            {
                type = "client",
                event = "mdt:publicrecord",
                icon = "fas fa-sign-in-alt",
                label = "Public Record",
                job = "doj",
            },
            {
                type = "client",
                event = "DOJ:ToggleDuty",
                icon = "fas fa-sign-in-alt",
                label = "Sign In/Out",
                job = "doj",
            },
        },
        distance = 2
    },

    ["boxzone16"] = {
        name = "PDM Duty",
		coords = vector3(-27.53, -1107.19, 27.27),
        length = 1,
        width = 1,
        heading = 340,
        debugPoly = false,
        minZ = 27.00,
        maxZ = 28.00,
        options = {
            {
                type = "client",
                event = "PDM:ToggleDuty",
                icon = "fas fa-sign-in-alt",
                label = "Sign In/Out",
                job = "pdm",
            },
        },
        distance = 3.0
    },

    ["boxzone17"] = {
        name = "EDM Duty",
		coords = vector3(-809.29, -207.54, 37.13),
        length = 0.7,
        width = 0.5,
        heading = 5,
        debugPoly = false,
        minZ = 37.00,
        maxZ = 37.70,
        options = {
            {
                type = "client",
                event = "EDM:ToggleDuty",
                icon = "fas fa-sign-in-alt",
                label = "Sign In/Out",
                job = "edm",
            },

            {
                type = "client",
                event = "bossmenu:open",
                icon = "fa-solid fa-book-journal-whills",
                label = "Job Management",
                job = {
					["edm"] = 5,
				}
            },
        },
        distance = 3.0
    },


    ----------------MCD------------------
    ["boxzone18"] = {
        name = "MCD Duty",
		coords = vector3(83.49, 294.86, 110.21),
        length = 1.0,
        width = 0.5,
        heading = 70,
        debugPoly = false,
        minZ = 110.00,
        maxZ = 110.60,
        options = {
            {
                type = "client",
                event = "mcd:ToggleDuty",
                icon = "fas fa-sign-in-alt",
                label = "Sign In/Out",
                job = "mcd",
            },

            {
                type = "client",
                event = "bossmenu:open",
                icon = "fa-solid fa-book-journal-whills",
                label = "Job Management",
                job = {
					["mcd"] = 2,
				}
            },
        },
        distance = 3.0
    },

    ["boxzone19"] = {
        name = "MCD shop",
		coords = vector3(89.43, 296.83, 110.21),
        length = 1.5,
        width = 0.5,
        heading = 340,
        debugPoly = false,
        minZ = 109.00,
        maxZ = 111.00,
        options = {
            {
                type = "client",
                event = "mcd:shop",
                icon = "fas fa-store",
                label = "Store",
                job = "mcd",
            },
        },
        distance = 3.0
    },

    ["boxzone20"] = {
        name = "MCD Storage",
		coords = vector3(92.17, 292.57, 110.21),
        length = 4.6,
        width = 1.0,
        heading = 250,
        debugPoly = false,
        minZ = 109.00,
        maxZ = 110.80,
        options = {
            {
                type = "client",
                event = "mcd:Storage",
                icon = "fas fa-box",
                label = "Storage",
                job = "mcd",
            },
        },
        distance = 3.0
    },

    ["boxzone21"] = {
        name = "MCD Shake Fill",
		coords = vector3(91.89, 281.73, 110.21),
        length = 0.5,
        width = 0.5,
        heading = 340,
        debugPoly = false,
        minZ = 110.30,
        maxZ = 111.00,
        options = {
            {
                type = "client",
                event = "mcd:icetea",
                icon = "fas fa-fill",
                label = "Ice Tea",
            },
            {
                type = "client",
                event = "mcd:icedlatte",
                icon = "fas fa-fill",
                label = "Ice Latte",
            },
            {
                type = "client",
                event = "mcd:Strawberry",
                icon = "fas fa-fill",
                label = "Strawberry Shake",
            },
            {
                type = "client",
                event = "mcd:Mango",
                icon = "fas fa-fill",
                label = "Mango Shake",
            },
        },
        distance = 3.0
    },

    ["boxzone22"] = {
        name = "MCD Shake Fill2",
		coords = vector3(91.32, 280.29, 110.21),
        length = 0.7,
        width = 0.5,
        heading = 340,
        debugPoly = false,
        minZ = 110.30,
        maxZ = 110.80,
        options = {
            {
                type = "client",
                event = "mcd:caramel",
                icon = "fas fa-fill",
                label = "Caramel",
            },
            {
                type = "client",
                event = "mcd:Chocolate",
                icon = "fas fa-fill",
                label = "Chocolate",
            },
            {
                type = "client",
                event = "mcd:cappuccino",
                icon = "fas fa-fill",
                label = "Cappuccino",
            },
        },
        distance = 3.0
    },

    ["boxzone23"] = {
        name = "MCD Tray1",
		coords = vector3(88.77, 290.49, 110.21),
        length = 1.0,
        width = 1.0,
        heading = 340,
        debugPoly = false,
        minZ = 110.30,
        maxZ = 110.50,
        options = {
            {
                type = "client",
                event = "mcd:pickorder1",
                icon = "fas fa-box",
                label = "Pick Order",
            },
        },
        distance = 3.0
    },

    ["boxzone24"] = {
        name = "MCD Tray2",
		coords = vector3(90.61, 289.96, 110.21),
        length = 1.0,
        width = 1.0,
        heading = 340,
        debugPoly = false,
        minZ = 110.30,
        maxZ = 110.50,
        options = {
            {
                type = "client",
                event = "mcd:pickorder2",
                icon = "fas fa-box",
                label = "Pick Order",
            },
        },
        distance = 3.0
    },

    ["boxzone25"] = {
        name = "MCD Tray3",
		coords = vector3(92.32, 289.2, 110.21),
        length = 1.0,
        width = 1.0,
        heading = 340,
        debugPoly = false,
        minZ = 110.30,
        maxZ = 110.50,
        options = {
            {
                type = "client",
                event = "mcd:pickorder3",
                icon = "fas fa-box",
                label = "Pick Order",
            },
        },
        distance = 3.0
    },

    ["boxzone26"] = {
        name = "Pdm Personal Stash",
		coords = vector3(-31.12, -1105.78, 27.27),
        length = 2.4,
        width = 0.5,
        heading = 340,
        debugPoly = false,
        minZ = 26.30,
        maxZ = 27.20,
        options = {
            {
                type = "client",
                event = "PDM:PersonalStash",
                icon = "fas fa-box",
                label = "Personal Stash",
            },
        },
        distance = 2.0
    },

    ["boxzone27"] = {
        name = "Mcd Charge Customer",
		coords = vector3(89.59, 290.14, 110.21),
        length = 0.4,
        width = 0.4,
        heading = 340,
        debugPoly = false,
        minZ = 110.20,
        maxZ = 110.70,
        options = {
            {
                type = "client",
                event = "jim-payments:client:Charge",
                icon = "fas fa-credit-card",
                label = "Charge Customer",
                job = "mcd",
            },
        },
        distance = 2.0
    },

    ["boxzone28"] = {
        name = "Mcd Charge Customer2",
		coords = vector3(91.52, 289.48, 110.21),
        length = 0.4,
        width = 0.4,
        heading = 340,
        debugPoly = false,
        minZ = 110.20,
        maxZ = 110.70,
        options = {
            {
                type = "client",
                event = "jim-payments:client:Charge",
                icon = "fas fa-credit-card",
                label = "Charge Customer",
                job = "mcd",
            },
        },
        distance = 2.0
    },

    ["boxzone29"] = {
        name = "Mcd Charge Customer3",
		coords = vector3(93.4, 288.78, 110.21),
        length = 0.4,
        width = 0.4,
        heading = 340,
        debugPoly = false,
        minZ = 110.20,
        maxZ = 110.70,
        options = {
            {
                type = "client",
                event = "jim-payments:client:Charge",
                icon = "fas fa-credit-card",
                label = "Charge Customer",
                job = "mcd",
            },
        },
        distance = 2.0
    },

    ["boxzone30"] = {
        name = "Mcd Charge Customer4",
		coords = vector3(87.85, 290.79, 110.21),
        length = 0.4,
        width = 0.4,
        heading = 340,
        debugPoly = false,
        minZ = 110.20,
        maxZ = 110.70,
        options = {
            {
                type = "client",
                event = "jim-payments:client:Charge",
                icon = "fas fa-credit-card",
                label = "Charge Customer",
                job = "mcd",
            },
        },
        distance = 2.0
    },

    ----MCD Table
    ["boxzone31"] = {
        name = "Mcd Table 1",
		coords = vector3(75.7, 282.19, 110.21),
        length = 1.0,
        width = 1.6,
        heading = 340,
        debugPoly = false,
        minZ = 109.90,
        maxZ = 110.20,
        options = {
            {
                type = "client",
                event = "mcd-table:Stash",
                icon = "fas fa-box-open",
                label = "Table 1",
                stash = "Table_1",
            },
        },
        distance = 2.0
    },

    ["boxzone32"] = {
        name = "Mcd Table 2",
		coords = vector3(75.75, 278.77, 110.21),
        length = 1.0,
        width = 1.6,
        heading = 250,
        debugPoly = false,
        minZ = 109.90,
        maxZ = 110.20,
        options = {
            {
                type = "client",
                event = "mcd-table:Stash",
                icon = "fas fa-box-open",
                label = "Table 2",
                stash = "Table_2",
            },
        },
        distance = 2.0
    },

    ["boxzone33"] = {
        name = "Mcd Table 3",
		coords = vector3(78.78, 277.67, 110.21),
        length = 1.0,
        width = 1.6,
        heading = 250,
        debugPoly = false,
        minZ = 109.90,
        maxZ = 110.20,
        options = {
            {
                type = "client",
                event = "mcd-table:Stash",
                icon = "fas fa-box-open",
                label = "Table 3",
                stash = "Table_3",
            },
        },
        distance = 2.0
    },

    ["boxzone34"] = {
        name = "Mcd Table 4",
		coords = vector3(85.81, 275.11, 110.21),
        length = 1.0,
        width = 1.6,
        heading = 250,
        debugPoly = false,
        minZ = 109.90,
        maxZ = 110.20,
        options = {
            {
                type = "client",
                event = "mcd-table:Stash",
                icon = "fas fa-box-open",
                label = "Table 4",
                stash = "Table_4",
            },
        },
        distance = 2.0
    },

    ["boxzone35"] = {
        name = "Mcd Table 5",
		coords = vector3(88.84, 273.93, 110.21),
        length = 1.0,
        width = 1.6,
        heading = 250,
        debugPoly = false,
        minZ = 109.90,
        maxZ = 110.20,
        options = {
            {
                type = "client",
                event = "mcd-table:Stash",
                icon = "fas fa-box-open",
                label = "Table 5",
                stash = "Table_5",
            },
        },
        distance = 2.0
    },

    ["boxzone36"] = {
        name = "Mcd Table 6",
		coords = vector3(90.39, 276.82, 110.21),
        length = 1.6,
        width = 1.0,
        heading = 250,
        debugPoly = false,
        minZ = 109.90,
        maxZ = 110.20,
        options = {
            {
                type = "client",
                event = "mcd-table:Stash",
                icon = "fas fa-box-open",
                label = "Table 6",
                stash = "Table_6",
            },
        },
        distance = 2.0
    },

    ["boxzone37"] = {
        name = "Mcd Table 7",
		coords = vector3(85.83, 289.84, 110.21),
        length = 1.0,
        width = 1.6,
        heading = 250,
        debugPoly = false,
        minZ = 109.90,
        maxZ = 110.20,
        options = {
            {
                type = "client",
                event = "mcd-table:Stash",
                icon = "fas fa-box-open",
                label = "Table 7",
                stash = "Table_7",
            },
        },
        distance = 2.0
    },

    ["boxzone38"] = {
        name = "Mcd Table 8",
		coords = vector3(82.79, 290.92, 110.21),
        length = 1.0,
        width = 1.6,
        heading = 250,
        debugPoly = false,
        minZ = 109.90,
        maxZ = 110.20,
        options = {
            {
                type = "client",
                event = "mcd-table:Stash",
                icon = "fas fa-box-open",
                label = "Table 8",
                stash = "Table_8",
            },
        },
        distance = 2.0
    },

    ["boxzone39"] = {
        name = "Mcd Table 9",
		coords =vector3(80.44, 282.27, 110.21),
        length = 1.0,
        width = 1.0,
        heading = 335,
        debugPoly = false,
        minZ = 109.90,
        maxZ = 110.20,
        options = {
            {
                type = "client",
                event = "mcd-table:Stash",
                icon = "fas fa-box-open",
                label = "Table 9",
                stash = "Table_9",
            },
        },
        distance = 2.0
    },

    ["boxzone40"] = {
        name = "Mcd Table 10",
		coords = vector3(84.48, 284.56, 110.21),
        length = 1.0,
        width = 1.0,
        heading = 350,
        debugPoly = false,
        minZ = 109.90,
        maxZ = 110.20,
        options = {
            {
                type = "client",
                event = "mcd-table:Stash",
                icon = "fas fa-box-open",
                label = "Table 10",
                stash = "Table_10",
            },
        },
        distance = 2.0
    },

    ["boxzone41"] = {
        name = "Mcd Table 11",
		coords = vector3(85.56, 279.81, 110.21),
        length = 1.0,
        width = 1.0,
        heading = 0,
        debugPoly = false,
        minZ = 109.90,
        maxZ = 110.20,
        options = {
            {
                type = "client",
                event = "mcd-table:Stash",
                icon = "fas fa-box-open",
                label = "Table 11",
                stash = "Table_11",
            },
        },
        distance = 2.0
    },

    ["boxzone42"] = {
        name = "Mcd Table Office",
		coords = vector3(82.77, 297.72, 110.21),
        length = 1.2,
        width = 1.4,
        heading = 340,
        debugPoly = false,
        minZ = 109.20,
        maxZ = 109.65,
        options = {
            {
                type = "client",
                event = "mcd-table:Stash",
                icon = "fas fa-box-open",
                label = "Table Office",
                stash = "Table_Office",
            },
        },
        distance = 2.0
    },

    ["boxzone43"] = {
        name = "Tunner Duty",
		coords = vector3(-1360.54, 140.1, -95.12),
        length = 1.5,
        width = 0.2,
        heading = 0,
        debugPoly = false,
        minZ = -95.00,
        maxZ = -94.00,
        options = {
            {
                type = "client",
                event = "Tunner:ToggleDuty",
                icon = "fas fa-sign-in-alt",
                label = "Sign In/Out",
                job = "tunner",
            },

            {
                type = "client",
                event = "bossmenu:open",
                icon = "fa-solid fa-book-journal-whills",
                label = "Job Management",
                job = {
					["tunner"] = 5,
				}
            },
        },
        distance = 2.0
    },

    ["boxzone44"] = {
        name = "Police Bossmenu",
		coords = vector3(461.43, -986.22, 30.73),
        length = 0.5,
        width = 0.5,
        heading = 0,
        debugPoly = false,
        minZ = 30.5,
        maxZ = 31.0,
        options = {
            {
                type = "client",
                event = "bossmenu:open",
                icon = "fa-solid fa-book-journal-whills",
                label = "Job Management",
                job = {
					["police"] = 11,
				}
            },
        },
        distance = 2.0
    },

    ["boxzone45"] = {
        name = "Doctor Bossmenu",
		coords = vector3(335.58, -594.56, 43.28),
        length = 0.5,
        width = 1.2,
        heading = 250,
        debugPoly = false,
        minZ = 43.00,
        maxZ = 44.00,
        options = {
            {
                type = "client",
                event = "bossmenu:open",
                icon = "fa-solid fa-book-journal-whills",
                label = "Job Management",
                job = {
					["doctor"] = 9,
				}
            },
        },
        distance = 2.0
    },

    ["boxzone46"] = {
        name = "PDM Bossmenu",
		coords = vector3(-26.62, -1104.6, 27.27),
        length = 0.5,
        width = 1.2,
        heading = 250,
        debugPoly = false,
        minZ = 27.00,
        maxZ = 28.00,
        options = {
            {
                type = "client",
                event = "bossmenu:open",
                icon = "fa-solid fa-book-journal-whills",
                label = "Job Management",
                job = {
					["pdm"] = 5,
				}
            },
        },
        distance = 2.0
    },

    ["boxzone47"] = {
        name = "Gov Bossmenu",
		coords = vector3(-1303.77, -572.54, 41.19),
        length = 0.5,
        width = 0.5,
        heading = 310,
        debugPoly = false,
        minZ = 41.00,
        maxZ = 41.80,
        options = {
            {
                type = "client",
                event = "bossmenu:open",
                icon = "fa-solid fa-book-journal-whills",
                label = "Job Management",
                job = {
					["government"] = 7,
				}
            },
        },
        distance = 2.0
    },

    ["boxzone48"] = {
        name = "Casino Bossmenu",
		coords = vector3(957.34, 56.25, 75.44),
        length = 0.9,
        width = 0.5,
        heading = 212,
        debugPoly = false,
        minZ = 75.30,
        maxZ = 76.00,
        options = {
            {
                type = "client",
                event = "bossmenu:open",
                icon = "fa-solid fa-book-journal-whills",
                label = "Job Management",
                job = {
					["casino"] = 3,
				}
            },
        },
        distance = 2.0
    },

    ["boxzone49"] = {
        name = "ShopOne",
		coords = vector3(296.63, -1252.83, 29.42),
        length = 0.5,
        width = 0.5,
        heading = 0,
        debugPoly = false,
        minZ = 29.00,
        maxZ = 30.00,
        options = {
            {
                type = "client",
                event = "bossmenu:open",
                icon = "fa-solid fa-book-journal-whills",
                label = "Job Management",
                job = {
					["shopone"] = 2,
				}
            },

            {
                type = "client",
                event = "ShopOne:ToggleDuty",
                icon = "fas fa-sign-in-alt",
                label = "Sign In/Out",
                job = "shopone",
            },
        },
        distance = 2.0
    },

    ["boxzone50"] = {
        name = "Cat Cafe",
		coords = vector3(-578.28, -1066.88, 26.61),
        length = 0.5,
        width = 0.5,
        heading = 0,
        debugPoly = false,
        minZ = 26.50,
        maxZ = 27.00,
        options = {
            {
                type = "client",
                event = "bossmenu:open",
                icon = "fa-solid fa-book-journal-whills",
                label = "Job Management",
                job = {
					["uwu"] = 4,
				}
            },
        },
        distance = 2.0
    },

    ["boxzone51"] = {
        name = "Beanmachine",
		coords = vector3(-634.65, 228.53, 81.88),
        length = 0.4,
        width = 1.2,
        heading = 359,
        debugPoly = false,
        minZ = 81.50,
        maxZ = 82.00,
        options = {
            {
                type = "client",
                event = "bossmenu:open",
                icon = "fa-solid fa-book-journal-whills",
                label = "Job Management",
                job = {
					["beanmachine"] = 4,
				}
            },
        },
        distance = 2.0
    },

    ["boxzone52"] = {
        name = "Banker",
		coords = vector3(-1556.68, -575.84, 108.53),
        length = 0.6,
        width = 1.0,
        heading = 305,
        debugPoly = false,
        minZ = 108.40,
        maxZ = 109.00,
        options = {
            {
                type = "client",
                event = "bossmenu:open",
                icon = "fa-solid fa-book-journal-whills",
                label = "Job Management",
                job = {
					["banker"] = 3,
				}
            },
        },
        distance = 2.0
    },

    ["boxzone53"] = {
        name = "crafting",
		coords = vector3(200.75, -2411.55, 6.04),
        length = 0.2,
        width = 0.8,
        heading = 179.67,
        debugPoly = false,
        minZ = 5.25,
        maxZ = 6.40,
        options = {
            {
                type = "client",
                event = "crafting:hack",
                icon = "fa-solid fa-book-journal-whills",
                label = "Interact",
            },
        },
        distance = 2.0
    },

    ["boxzone54"] = {
        name = "craftingReturn",
		coords = vector3(997.96, -2390.68, 30.14),
        length = 0.2,
        width = 1.3,
        heading = 85.67,
        debugPoly = false,
        minZ = 29.20,
        maxZ = 31.55,
        options = {
            {
                type = "client",
                event = "crafting:return",
                icon = "fa-solid fa-book-journal-whills",
                label = "Interact",
            },
        },
        distance = 2.0
    },

    ["boxzone55"] = {
        name = "checkin",
		coords = vector3(312.06, -593.59, 44.43),
        length = 0.9,
        width = 2.1,
        heading = 159.67,
        debugPoly = false,
        minZ = 42.30,
        maxZ = 43.55,
        options = {
            {
                type = "client",
                event = "hospital:checkin",
                icon = "fa-solid fa-book-journal-whills",
                label = "Checkin",
            },
        },
        distance = 2.0
    },

    ["boxzone56"] = {
        name = "dmv school",
		coords = vector3(214.89, -1399.24, 31.58),
        length = 0.3,
        width = 4.1,
        heading = 139.67,
        debugPoly = false,
        minZ = 28.30,
        maxZ = 30.81,
        options = {
            {
                type = "client",
                event = "driving:test",
                icon = "fa-solid fa-book-journal-whills",
                label = "Give Driving Test",
            },
        },
        distance = 2.0
    },

    ["boxzone57"] = {
        name = "Benny duty",
        coords = vector3(-205.91, -1327.62, 30.89),
        length = 1.35,
        width = 0.75,
        heading = 90.0,
        debugPoly = false,
        minZ = 29.8,
        maxZ = 32.15,
        options = {
            {
                type = "client",
                event = "bossmenu:open",
                icon = "fa-solid fa-book-journal-whills",
                label = "Job Management",
                job = {
					["bennys"] = 5,
				}
            },
        },
        distance = 1.5
    },

    ["boxzone58"] = {
        name = "Reporter Bossmenu",
		coords = vector3(-576.12, -938.38, 28.82),
        length = 0.5,
        width = 1.2,
        heading = 250,
        debugPoly = false,
        minZ = 27.00,
        maxZ = 28.00,
        options = {
            {
                type = "client",
                event = "bossmenu:open",
                icon = "fa-solid fa-book-journal-whills",
                label = "Job Management",
                job = {
					["reporter"] = 5,
				}
            },
        },
        distance = 2.0
    },
    ["boxzone59"] = {
        name = "MW Bossmenu",
		coords = vector3(-2354.01, 3253.92, 93.9),
        length = 0.5,
        width = 0.5,
        heading = 0,
        debugPoly = false,
        minZ = 26.50,
        maxZ = 27.00,
        options = {
            {
                type = "client",
                event = "bossmenu:open",
                icon = "fa-solid fa-book-journal-whills",
                label = "Job Management",
                job = {
					["ammunation"] = 3,
				}
            },
        },
        distance = 2.0
    },
}



Config.PolyZones = {

}

Config.TargetBones = {

}

Config.TargetEntities = {

}

Config.TargetModels = {

    ["drinkVending"] = {
        models =     {
            "prop_vend_soda_01",
            "prop_vend_soda_02",
            "prop_vend_water_01",
        },
        options = {
            {
                type = "client",
                event = 'vendingDrink:buy',
                icon = "fas fa-shopping-basket",
                label = "Insert Coin",
            },
        },
        distance = 2.5
    },
    ["vendingSnack"] = {
        models =     {
            "prop_vend_snak_01",
            "prop_vend_snak_01_tu",
        },
        options = {
            {
                type = "client",
                event = 'vendingSnack:buy',
                icon = "fas fa-shopping-basket",
                label = "Insert Coin",
            },
        },
        distance = 2.5
    },
    
    ["vendingCoffee"] = {
        models =     {
            "prop_vend_coffe_01",
            "apa_mp_h_acc_coffeemachine_01",
        },
        options = {
            {
                type = "client",
                event = 'vendingCoffee:buy',
                icon = "fas fa-shopping-basket",
                label = "Insert Coin",
            },
        },
        distance = 2.5
    },


    ["uwu"] = {
		models = {
			"A_C_Cat_01"
		},
		options = {
			{
				type = "client",
				event = "mr-shops:marketshop",
				icon = "fas fa-shopping-basket",
				label = "Open Shop",
			},
		},
		distance = 4.0
	},

	["watertank"] = {
        models = {
			-742198632,
		},
        options = {
            {
                type = "client",
                event = "consumables:client:Drinktank",
                icon = "fas fa-tint",
                label = "Drink Water",
            },
        },
        distance = 3.0,
    },

    ["event"] = {
        models = {
			-591115459,
		},
        options = {
            {
                type = "client",
                event = "event:stash",
                icon = "fas fa-box",
                label = "Hot Drop",
            },
        },
        distance = 3.0,
    },

	["atm"] = {
        models = {
			-870868698,
			-1126237515,
			-1364697528,
			506770882,
		},
        options = {
            {
                type = "command",
                event = "atm",
                icon = "fas fa-money-check-alt",
                label = "Use ATM",
            },
        },
        distance = 3.0,
    },

	["lifeinvader"] = {
        models = {
            "csb_thornton",
        },
        options = {
            {
                type = "server",
                event = "take:job:salary",
                icon = "fas fa-file-invoice",
                label = "Collect Paycheck",
            },
			{
                type = "server",
                event = "mail:job:salary",
                icon = "fas fa-at",
                label = "Check Paycheck",
            },
        },
        distance = 4.0,
    },
    ["shopone"] = {
        models = {
            "a_m_y_stlat_01",
        },
        options = {
            {
                type = "client",
                event = "mr-sdt:client:openMenu",
                icon = "fas fa-file-invoice",
                label = "ShopOne Menu",
            },
        },
        distance = 4.0,
    },
  
    -- ["uwu"] = {
    --     models = {
    --         "a_m_y_stlat_01",
    --     },
    --     options = {
    --         {
    --             type = "client",
    --             event = "mr-sdt:client:openMenu",
    --             icon = "fas fa-file-invoice",
    --             label = "uwu Menu",
    --         },
    --     },
    --     distance = 4.0,
    -- },

	["24/7 shops"] = {
        models = {
            "mp_m_shopkeep_01",
        },
        options = {
            {
                type = "client",
                event = "mr-shops:marketshop",
                icon = "fas fa-store",
                label = "Buy Items",
            },
        },
        distance = 2.5,
    },
    ["ammunation shops"] = {
        models = {
            "s_m_y_ammucity_01",
        },
        options = {
            {
                type = "client",
                event = "mr-shops:marketshop",
                icon = "fas fa-shopping-cart",
                label = "Buy Weapons",
            },
        },
        distance = 2.5,
    },
    ["Hardware"] = {
        models = {
            "s_m_m_lathandy_01",
        },
        options = {
            {
                type = "client",
                event = "mr-shops:marketshop",
                icon = "fas fa-wrench",
                label = "Buy Tools",
            },
        },
        distance = 2.5,
    },
    ["sea world"] = {
        models = {
            "cs_dom",
        },
        options = {
            {
                type = "client",
                event = "mr-shops:marketshop",
                icon = "fas fa-circle",
                label = "Buy Gear",
            },
        },
        distance = 2.5,
    },
	["phoneshop"] = {
        models = {
            "a_m_y_vinewood_02",
        },
        options = {
            {
                type = "client",
                event = "mr-shops:marketshop",
                icon = "fas fa-circle",
                label = "Buy Electronics",
            },
        },
        distance = 2.5,
    },

    ["petshop"] = {
        models = {
            "s_m_m_strvend_01",
        },
        options = {
            {
                type = "client",
                event = "mr-shops:marketshop",
                icon = "fas fa-paw",
                label = "Open Pet Shop",
            },
        },
        distance = 2.5,
    },

	["leisureshop"] = {
        models = {
            "a_f_y_vinewood_02",
        },
        options = {
            {
                type = "client",
                event = "mr-shops:marketshop",
                icon = "fas fa-circle",
                label = "Buy Leisures",
            },
        },
        distance = 2.5,
    },
	["Superfly"] = {
        models = {
            "csb_hao",
        },
        options = {
            {
                type = "client",
                event = "mr-shops:marketshop",
                icon = "fas fa-circle",
                label = "Buy",
            },
        },
        distance = 2.5,
    },

	["casinohub"] = {
        models = {
            "s_m_m_highsec_02",
        },
        options = {
            {
                type = "client",
                event = "mr-shops:marketshop",
                icon = "fas fa-circle",
                label = "Buy",
            },
        },
        distance = 2.5,
    },

	["gov"] = {
        models = {
            "ig_molly",
        },
        options = {
            {
                type = "client",
                event = "mr-shops:marketshop",
                icon = "fas fa-circle",
                label = "Buy",
            },
        },
        distance = 2.5,
    },

	["clothing"] = {
        models = {
            "csb_anita",
            "ig_kaylee",
        },
        options = {
            {
                type = "client",
                event = "mr-clothing:clothing",
                icon = "fas fa-tshirt",
                label = "Buy Clothes",
            },
        },
        distance = 5.0,
    },

    ["clothing2"] = {
        models = {
            "ig_jackie",
        },
        options = {
            {
                type = "client",
                event = "mr-clothing:clothing",
                icon = "fas fa-tshirt",
                label = "Buy Clothes",
            },
            {
                type = "client",
                event = "mr-shops:marketshop",
                icon = "fas fa-bag-shopping",
                label = "Buy Bag",
            },
        },
        distance = 5.0,
    },

	["barber"] = {
        models = {
            "cs_dreyfuss",
        },
        options = {
            {
                type = "client",
                event = "mr-clothing:barber",
                icon = "fas fa-cut",
                label = "Barber Shop",
            },
        },
        distance = 5.0,
    },

	["tattoo"] = {
        models = {
            "csb_cletus",
        },
        options = {
            {
                type = "client",
                event = "mr-tattoo:client:tattooppen",
                icon = "fas fa-marker",
                label = "Tattoo Shop",
            },
        },
        distance = 3.0,
    },

	["juicesell"] = {
        models = {
            "ig_chef2",
        },
        options = {
            {
                type = "client",
                event = "mr-apple:sell",
                icon = "fas fa-store",
                label = "Apple Juice Sell",
            },
			{
                type = "client",
                event = "mr-orange:sell",
                icon = "fas fa-store",
                label = "Orange Juice Sell",
            },
            {
                type = "server",
                event = "mr-vineyard:sellgrapes",
                icon = "fas fa-store",
                label = "Grapes Juice Sell",
            },
            {
                type = "server",
                event = "mr-vineyard:sellWine",
                icon = "fas fa-store",
                label = "Wine Sell",
            },
        },
        distance = 3.0,
    },

    ["mcd"] = {
        models = {
			"csb_burgerdrug",
		},
        options = {
            {
                type = "client",
                event = "mr-dt:client:openMenu",
                icon = "fas fa-store",
                label = "Drive Through",
            },
        },
        distance = 3.0,
    },

}

Config.GlobalPedOptions = {

}

Config.GlobalVehicleOptions = {

}

Config.GlobalObjectOptions = {

}

Config.GlobalPlayerOptions = {

}

Config.Peds = {
	{  -------juice sell------
		model = `ig_chef2`,
		coords = vector4(-1187.41, -1536.62, 3.38, 61.56),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},

    {  -------mcd drivethrough------
		model = `csb_burgerdrug`,
		coords = vector4(94.28, 285.66, 109.22, 252.04),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},

	{  -------lifeinavder------
		model = `csb_thornton`,
		coords = vector4(-1083.08, -245.84, 36.76, 210.47),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},
    {  -------shopone------
		model = `a_m_y_stlat_01`,
		coords = vector4(295.33, -1253.8, 28.42, 178.86),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},
	{  -------Youtool Shop------
		model = `s_m_m_lathandy_01`,
		coords = vector4(45.48, -1748.85, 28.55, 55.1),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},
	{  -------Youtool Shop------
		model = `s_m_m_lathandy_01`,
		coords = vector4(2748.07, 3472.72, 54.70, 238.96),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},

	{  -------Youtool Shop------
		model = `s_m_m_lathandy_01`,
		coords = vector4(-422.35, 6135.81, 30.88, 194.63),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},

	{
		model = 'mp_m_shopkeep_01',
		coords = vector4(-3242.23, 999.97, 11.85, 351.66),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},
	{
		model = 'mp_m_shopkeep_01',
		coords = vector4(24.5, -1346.63, 28.60, 273.18),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},
	{
		model = 'mp_m_shopkeep_01',
		coords = vector4(-47.18, -1758.46, 28.45, 39.64),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},
	{
		model = 'mp_m_shopkeep_01',
		coords = vector4(-706.02, -913.9, 18.35, 86.17),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},
	{
		model = 'mp_m_shopkeep_01',
		coords = vector4(-1486.75, -377.57, 39.20, 132.60),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},
		-- San Andreas Ave Robs Liquor
	{
		model = 'mp_m_shopkeep_01',
		coords = vector4(-1221.30, -907.82, 11.40, 34.60),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},
	-- Carrson Ave
	{
		model = 'mp_m_shopkeep_01',
		coords = vector4(372.6, 327.06, 102.55, 258.49),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},
	-- North Rockford
	{
		model = 'mp_m_shopkeep_01',
		coords = vector4(-1819.96, 794.04, 137.10, 126.36),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},
	-- Great Ocean South
	{
		model = 'mp_m_shopkeep_01',
		coords = vector4(-3039.89, 584.21, 6.90, 16.15),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},
	-- Great Ocean Robs Liquor
	{
		model = 'mp_m_shopkeep_01',
		coords = vector4(-2966.41, 391.62, 14.05, 84.40),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},
	-- Mirror Park
	{
		model = 'mp_m_shopkeep_01',
		coords = vector4(1164.72, -323.04, 68.25, 93.92),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},
	-- Vespucci Boulevard Robs Liquor
	{
		model = 'mp_m_shopkeep_01',
		coords = vector4(1134.32, -983.25, 45.45, 278.23),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},
	-- Route 68
	{
		model = 'mp_m_shopkeep_01',
		coords = vector4(549.24, 2670.37, 41.25, 94.15),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},
	-- Sandy
	{
		model = 'mp_m_shopkeep_01',
		coords = vector4(1959.72, 3740.68, 31.40, 297.43),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},
	-- Sandy Shores Robs Liquor
	{
		model = 'mp_m_shopkeep_01',
		coords = vector4(1165.25, 2710.80, 37.16, 183.01),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},
	-- Grape Seed
	{
		model = 'mp_m_shopkeep_01',
		coords = vector4(1697.8, 4923.14, 41.10, 321.33),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},
	-- Great Ocean North
	{
		model = 'mp_m_shopkeep_01',
		coords = vector4(1728.33, 6416.21, 34.05, 241.78),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},
	-- LS Freeway
	{
		model = 'mp_m_shopkeep_01',
		coords = vector4(2677.32, 3279.69, 54.30, 323.82),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},
	{---by youtool
		model = 'mp_m_shopkeep_01',
		coords = vector4(2557.28, 380.78, 107.65, 359.83),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},
    {---polito
		model = 'mp_m_shopkeep_01',
		coords = vector4(160.61, 6641.7, 31.7, 238.09),
		gender = 'male',
		freeze = true,
        minusOne = true,
		invincible = true,
		blockevents = true,
	},
	-- Ammunations
	{
        model = `s_m_y_ammucity_01`,
        coords = vector4(18.05897, -1108.00, 29.797, 152.1),   --apple boulevard
        gender = 'male',
        freeze = true,
        minusOne = true,
        invincible = true,
        blockevents = true
    },
    {
        model = `s_m_y_ammucity_01`,
        coords = vector4(841.1876, -1029.19, 28.194, 264.4),   --vespucci boulevard
        gender = 'male',
        freeze = true,
        minusOne = true,
        invincible = true,
        blockevents = true
    },
    {
        model = `s_m_y_ammucity_01`,
        coords = vector4(-659.161, -939.413, 21.829, 89.59),  --little seol
        gender = 'male',
        freeze = true,
        minusOne = true,
        invincible = true,
        blockevents = true
    },
    -- Little Seoul
    {
        model = `s_m_y_ammucity_01`,
        coords = vector4(813.8847, -2155.21, 29.619, 0.529), --populer street
        gender = 'male',
        freeze = true,
        minusOne = true,
        invincible = true,
        blockevents = true
    },
    -- Vinewood Hills
    {
        model = `s_m_y_ammucity_01`,
        coords = vector4(2564.805, 298.1589, 108.73, 273.3), --palomino freeway
        gender = 'male',
        freeze = true,
        minusOne = true,
        invincible = true,
        blockevents = true
    },
    -- Palomino Freeway
    {
        model = `s_m_y_ammucity_01`,
        coords = vector4(-1112.71, 2697.694, 18.554, 134.1), --near approach Road
        gender = 'male',
        freeze = true,
        minusOne = true,
        invincible = true,
        blockevents = true
    },
    {
        model = `s_m_y_ammucity_01`,
        coords = vector4(1697.854, 3757.910, 34.705, 140.0), --sandy
        gender = 'male',
        freeze = true,
        minusOne = true,
        invincible = true,
        blockevents = true
    },
    {
        model = `s_m_y_ammucity_01`,
        coords = vector4(-326.304, 6081.389, 31.454, 134.1), --paleto
        gender = 'male',
        freeze = true,
        minusOne = true,
        invincible = true,
        blockevents = true
    },
    {
        model = `s_m_y_ammucity_01`,
        coords = vector4(247.1978, -51.4238, 69.941, 338.2), --vinewood
        gender = 'male',
        freeze = true,
        minusOne = true,
        invincible = true,
        blockevents = true
    },
    {
        model = `s_m_y_ammucity_01`,
        coords = vector4(-1310.29, -394.439, 36.695, 350.1), --del perro
        gender = 'male',
        freeze = true,
        minusOne = true,
        invincible = true,
        blockevents = true
    },
    {
        model = `s_m_y_ammucity_01`,
        coords = vector4(-3167.15, 1087.141, 20.838, 141.9), --barbareno
        gender = 'male',
        freeze = true,
        minusOne = true,
        invincible = true,
        blockevents = true
    },
	{ --sea world
		model = 'cs_dom',
		coords = vector4(-1686.39, -1072.48, 12.15, 50.1),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},
	{ --phone
		model = 'a_m_y_vinewood_02',
		coords = vector4(-656.55, -858.77, 23.49, 357.03),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},
    { --petshop
		model = 's_m_m_strvend_01',
		coords = vector4(561.18, 2741.51, 42.87, 199.08),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},
	{ --leisureshop
		model = 'a_f_y_vinewood_02',
		coords = vector4(-1508.4, 1508.81, 114.29, 114.22),
		gender = 'female',
		freeze = true,
		invincible = true,
		blockevents = true,
	},
	{ --superfly
		model = 'csb_hao',
		coords = vector4(-1171.18, -1571.06, 3.66, 125.74),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},
	{ --casino
		model = 's_m_m_highsec_02',
		coords = vector4(951.14, 29.68, 70.84, 26.96),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},
	{ --gov
		model = 'ig_molly',
		coords = vector4(-1304.55, -567.48, 40.19, 184.54),
		gender = 'female',
		freeze = true,
		invincible = true,
		blockevents = true,
	},

	{ --clothing
		model = 'csb_anita',
		coords = vector4(422.9, -810.25, 29.49, 1.21),
		gender = 'female',
		freeze = true,
        minusOne = true,
		invincible = true,
		blockevents = true,
	},

	{ --clothing
		model = 'csb_anita',
		coords = vector4(1691.57, 4818.38, 42.07, 349.98),
		gender = 'female',
		freeze = true,
        minusOne = true,
		invincible = true,
		blockevents = true,
	},

	{ --clothing
		model = 'ig_jackie',
		coords = vector4(-708.85, -151.89, 36.42, 124.51),
		gender = 'female',
		freeze = true,
		invincible = true,
		blockevents = true,
	},

	{ --clothing
		model = 'ig_kaylee',
		coords =vector4(-1193.58, -771.08, 16.32, 135.66),
		gender = 'female',
		freeze = true,
		invincible = true,
		blockevents = true,
	},

	{ --clothing
		model = 'ig_jackie',
		coords = vector4(-164.84, -302.62, 38.73, 245.26),
		gender = 'female',
		freeze = true,
		invincible = true,
		blockevents = true,
	},

	{ --clothing
		model = 'csb_anita',
		coords = vector4(78.2, -1388.88, 29.38, 183.73),
		gender = 'female',
		freeze = true,
        minusOne = true,
		invincible = true,
		blockevents = true,
	},

	{ --clothing
		model = 'csb_anita',
		coords = vector4(-817.42, -1074.17, 11.33, 125.89),
		gender = 'female',
		freeze = true,
        minusOne = true,
		invincible = true,
		blockevents = true,
	},

	{ --clothing
		model = 'ig_jackie',
		coords = vector4(-1449.18, -238.31, 48.81, 59.21),
		gender = 'female',
		freeze = true,
		invincible = true,
		blockevents = true,
	},

	{ --clothing
		model = 'csb_anita',
		coords = vector4(-0.39, 6512.1, 31.88, 307.49),
		gender = 'female',
		freeze = true,
        minusOne = true,
		invincible = true,
		blockevents = true,
	},
	
	{ --clothing
		model = 'ig_kaylee',
		coords = vector4(616.7, 2760.52, 41.09, 197.97),
		gender = 'female',
		freeze = true,
		invincible = true,
		blockevents = true,
	},

	{ --clothing
		model = 'csb_anita',
		coords = vector4(1200.77, 2706.87, 38.22, 104.76),
		gender = 'female',
		freeze = true,
        minusOne = true,
		invincible = true,
		blockevents = true,
	},

	{ --clothing
		model = 'ig_kaylee',
		coords = vector4(-3171.98, 1046.65, 19.86, 348.13),
		gender = 'female',
		freeze = true,
		invincible = true,
		blockevents = true,
	},

	{ --clothing
		model = 'csb_anita',
		coords = vector4(-1096.5, 2711.24, 19.11, 144.26),
		gender = 'female',
		freeze = true,
        minusOne = true,
		invincible = true,
		blockevents = true,
	},

	{ --clothing
		model = 'csb_anita',
		coords = vector4(-1206.06, -1458.45, 3.35, 19.78),
		gender = 'female',
		freeze = true,
        minusOne = true,
		invincible = true,
		blockevents = true,
	},

	{ --clothing
		model = 'ig_kaylee',
		coords = vector4(124.41, -220.89, 53.56, 346.58),
		gender = 'female',
		freeze = true,
		invincible = true,
		blockevents = true,
	},

	{ --clothing
		model = 'csb_anita',
		coords = vector4(1097.33, 201.96, -50.44, 150.88),
		gender = 'female',
		freeze = true,
        minusOne = true,
		invincible = true,
		blockevents = true,
	},

	{ --barber
		model = 'cs_dreyfuss',
		coords = vector4(-30.73, -151.71, 56.08, 344.08),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},

	{ --barber
		model = 'cs_dreyfuss',
		coords = vector4(-815.49, -182.19, 36.57, 215.03),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},

	{ --barber
		model = 'cs_dreyfuss',
		coords = vector4(134.57, -1707.88, 28.29, 145.1),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},

	{ --barber
		model = 'cs_dreyfuss',
		coords = vector4(-1284.27, -1115.17, 5.99, 90.85),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},

	{ --barber
		model = 'cs_dreyfuss',
		coords = vector4(1930.77, 3728.08, 31.84, 212.84),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},

	{ --barber
		model = 'cs_dreyfuss',
		coords = vector4(1211.5, -470.73, 65.21, 87.75),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},

	{ --barber
		model = 'cs_dreyfuss',
		coords = vector4(-277.92, 6230.56, 30.7, 41.5),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},

	{ --tattoo
		model = 'csb_cletus',
		coords = vector4(1324.34, -1650.04, 51.27, 138.47),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},

	{ --tattoo
		model = 'csb_cletus',
		coords = vector4(-1152.41, -1423.54, 3.95, 131.11),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},

	{ --tattoo
		model = 'csb_cletus',
		coords = vector4(319.76, 180.73, 102.59, 253.24),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},

	{ --tattoo
		model = 'csb_cletus',
		coords = vector4(-3170.36, 1072.96, 19.83, 336.51),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},

	{ --tattoo
		model = 'csb_cletus',
		coords = vector4(1864.9, 3746.64, 32.03, 21.28),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},

	{ --tattoo
		model = 'csb_cletus',
		coords = vector4(-294.75, 6201.26, 30.49, 245.13),
		gender = 'male',
		freeze = true,
		invincible = true,
		blockevents = true,
	},

}

-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------
local function JobCheck() return true end
local function GangCheck() return true end
local function ItemCount() return true end
local function CitizenCheck() return true end

CreateThread(function()
	if not Config.Standalone then

        while true do
            Wait(1000)
            if GetResourceState('mrfw') == 'started' then
                break
            end
        end

		local MRFW = exports['mrfw']:GetCoreObject()
		local PlayerData = MRFW.Functions.GetPlayerData()

		ItemCount = function(item)
			for _, v in pairs(PlayerData.items) do
				if v.name == item then
					return true
				end
			end
			return false
		end

		JobCheck = function(job)
			if type(job) == 'table' then
				job = job[PlayerData.job.name]
				if job and PlayerData.job.grade.level >= job then
					return true
				end
			elseif job == 'all' or job == PlayerData.job.name then
				return true
			end
			return false
		end

		GangCheck = function(gang)
			if type(gang) == 'table' then
				gang = gang[PlayerData.gang.name]
				if gang and PlayerData.gang.grade.level >= gang then
					return true
				end
			elseif gang == 'all' or gang == PlayerData.gang.name then
				return true
			end
			return false
		end

		CitizenCheck = function(citizenid)
			return citizenid == PlayerData.citizenid or citizenid[PlayerData.citizenid]
		end

		RegisterNetEvent('MRFW:Client:OnPlayerLoaded', function()
			PlayerData = MRFW.Functions.GetPlayerData()
			SpawnPeds()
		end)

		RegisterNetEvent('MRFW:Client:OnPlayerUnload', function()
			PlayerData = {}
			DeletePeds()
		end)

		RegisterNetEvent('MRFW:Client:OnJobUpdate', function(JobInfo)
			PlayerData.job = JobInfo
		end)

		RegisterNetEvent('MRFW:Client:OnGangUpdate', function(GangInfo)
			PlayerData.gang = GangInfo
		end)

		RegisterNetEvent('MRFW:Player:SetPlayerData', function(val)
			PlayerData = val
		end)
	else
		local firstSpawn = false
		AddEventHandler('playerSpawned', function()
			if not firstSpawn then
				SpawnPeds()
				firstSpawn = true
			end
		end)
	end
end)

function CheckOptions(data, entity, distance)
	if distance and data.distance and distance > data.distance then return false end
	if data.job and not JobCheck(data.job) then return false end
	if data.gang and not GangCheck(data.gang) then return false end
	if data.item and not ItemCount(data.item) then return false end
	if data.citizenid and not CitizenCheck(data.citizenid) then return false end
	if data.canInteract and not data.canInteract(entity, distance, data) then return false end
	return true
end