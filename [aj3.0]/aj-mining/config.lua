Config = {}

Config = {
	Blips = true, -- Enable Blips?
	BlipNamer = false, -- Enable to Name Blips different things, disable if you already have too many blips as this will group them together
	PropSpawn = true, -- Enable Ore Props
	Pedspawn = true, -- Do you want to spawn peds for main locations?
	Invincible = true, --Do you want the peds to be invincible?
	Frozen = true, --Do you want the peds to be unable to move? It's probably a yes, so leave true in there.
	Stoic = true, --Do you want the peds to react to what is happening in their surroundings?
	Fade = true, -- Do you want the peds to fade into/out of existence? It looks better than just *POP* its there.
	Distance = 40.0, --The distance you want peds to spawn at
	EnableOpeningHours = true, -- Enable opening hours? If disabled you can always open the pawnshop.
	OpenHour = 11, -- From what hour should the pawnshop be open?
	CloseHour = 16, -- From what hour should the pawnshop be closed?
	OpenHour2 = 18, -- From what hour should the pawnshop be open?
	CloseHour2 = 2, -- From what hour should the pawnshop be closed?
}

--Blips and Locations
-- Each one has individual blip enablers
-- Mine and Mine Leave have headings for the player locations
Config.Locations =  {
	['Mine'] = { name = "Mine", location = vector3(-595.15,2091.23,131.46-1.03), heading = 61.59, blipTrue = true }, -- The location where you enter the mine 
	['Quarry'] = { name = "Quarry", location = vector3(2961.02, 2754.14, 43.71-1.03), heading = 200.0, blipTrue = true }, -- The location where you enter the mine 
	['Smelter'] = {	name = "Smelter", location = vector3(1112.29, -2009.9, 31.46), blipTrue = true }, -- The location of the smelter
	['Cracking'] = { name = "Stone Cracking", location = vector3(2945.98, 2746.88, 43.4-1.07), heading = 170, blipTrue = false }, -- The location of the smelter
	['Buyer'] = { name = "Ore Buyer", location = vector3(349.99, 329.85, 104.44-1.03), heading = 163.69, blipTrue = false }, -- The Location of the ore buyer
	['JewelCut'] = { name = "Jewel Cutting", location = vector3(244.0, 371.4, 105.74-0.97), heading = 290.0, blipTrue = false }, -- The Location of the jewel cutting bench. Couldn't decide so left in smeltery
	['Buyer2'] = { name = "Jewel Buyer", location = vector3(-716.12, -248.17, 36.99-1.03), heading = 348.72, blipTrue = false }, -- The Location of the jewel buyer, I left this as Vangelico, others will proabably change to pawn shops
}

------------------------------------------------------------
--Ores and Props

Config.OrePositions = {
	---MineShaft Locations
	{ coords = vector3(-587.05, 2059.08, 129.75), },
	{ coords = vector3(-588.49, 2048.05, 129.95-1.0), },
	{ coords = vector3(-580.10, 2037.82, 128.8-1.0), },
	{ coords = vector3(-572.28, 2022.37, 127.93-1.0), },
	{ coords = vector3(-562.8, 2011.85, 127.55-1.0), },
	--Quarry Locations
	{ coords = vector3(2980.37, 2748.4, 43.4-1.5), },
	{ coords = vector3(2985.77, 2751.19, 43.46-1.5), },
	{ coords = vector3(2990.38, 2750.4, 43.46-1.5), },
	{ coords = vector3(3000.77, 2754.15, 43.5-1.5), },
	{ coords = vector3(2977.74, 2741.16, 44.54-1.5), },
	{ coords = vector3(2945.13, 2727.80, 47.87-1.5), },
	{ coords = vector3(2941.85, 2733.35, 46.82-1.5), },
	{ coords = vector3(2934.92, 2740.98, 44.5-1.5), },
	{ coords = vector3(2935.03, 2753.06, 44.91-1.5), },
	{ coords = vector3(2929.11, 2758.54, 45.15-1.5), },
}

-----------------------------------------------------------

Config.RewardPool = {
	'carbon', 'carbon', 'carbon', 'carbon', --4x
	'copperore', 'copperore', 'copperore', 'copperore', 'copperore', 'copperore', -- 6x
	'goldore', 'goldore', 'goldore', --'goldore', -- 3x
	'ironore', 'ironore', 'ironore', 'ironore', -- 'ironore', 'ironore', -- 6x
    'metalscrap',
	'uncut_ruby',
	'uncut_emerald',
	'uncut_diamond',
	'uncut_sapphire',
}

------------------------------------------------------------
Config.SellItems = { -- Selling Prices
	['copperore'] = 80,
	['goldore'] = 80,
	['ironore'] = 80,
	['carbon'] = 80,
	
	['goldbar2'] = 280,
	
	['uncut_emerald'] = 250,
	['uncut_ruby'] = 250,
	['uncut_diamond'] = 250,
	['uncut_sapphire'] = 250,

	['emerald'] = 280,
	['ruby'] = 280,
	['diamond'] = 280,
	['sapphire'] = 280,

	['diamond_ring'] = 550,
	['emerald_ring'] = 550,
	['ruby_ring'] = 550,
	['sapphire_ring'] = 550,

	['diamond_necklace'] = 480,
	['emerald_necklace'] = 480,
	['ruby_necklace'] = 480,
	['sapphire_necklace'] = 480,

	['gold_ring'] = 100,
	['goldchain'] = 125,
	['10kgoldchain2'] = 200,

}

------------------------------------------------------------

Config.PedList = { -- APPARENTLY You can call config locations IN the config, learn't that one today
	{ model = "S_M_Y_Construct_01", coords = Config.Locations['Mine'].location, heading = Config.Locations['Mine'].heading, gender = "male", scenario = "WORLD_HUMAN_CLIPBOARD", }, -- Outside Mine
	{ model = "S_M_Y_Construct_01", coords = Config.Locations['Quarry'].location, heading = Config.Locations['Quarry'].heading, gender = "male", scenario = "WORLD_HUMAN_CLIPBOARD", }, -- Outside Mine
	{ model = "S_M_Y_Construct_01", coords = Config.Locations['Buyer'].location, heading = Config.Locations['Buyer'].heading, gender = "male", scenario = "WORLD_HUMAN_CLIPBOARD", }, -- Ore Buyer
	{ model = "S_M_M_HighSec_03", coords = Config.Locations['Buyer2'].location, heading = Config.Locations['Buyer2'].heading, gender = "male", scenario = "WORLD_HUMAN_CLIPBOARD", }, -- Jewel Buyer
}

------------------------------------------------------------
--Added mine lighting for my first world NVE problems
--Light Up at Night..or sometimes not at all :(
Config.MineLights = {
	{ coords = vector3(-595.52, 2086.38, 131.38+0.45), },
	{ coords = vector3(-594.30, 2082.89, 131.40+0.65), },
	{ coords = vector3(-591.85, 2073.95, 131.35+0.65), },
	{ coords = vector3(-589.98, 2066.16, 131.02+0.55), },
	{ coords = vector3(-588.92, 2059.21, 130.67+0.45), },
	{ coords = vector3(-588.69, 2054.36, 130.33+0.25), },
	{ coords = vector3(-587.11, 2048.25, 129.79+0.25), },
	{ coords = vector3(-584.51, 2041.63, 129.26+0.0), },
	{ coords = vector3(-580.87, 2035.56, 128.72+0.0), },
	{ coords = vector3(-576.07, 2028.91, 128.16+0.0), },
	{ coords = vector3(-571.74, 2023.9, 127.81+0.0), },
	{ coords = vector3(-565.44, 2017.63, 127.47+0.0), },
	{ coords = vector3(-561.39, 2012.64, 127.28+0.0), },
	{ coords = vector3(-558.24, 2008.18, 127.16+0.0), },
}

------------------------------------------------------------
--Mining Store Items
Config.Items = {
    label = "Mining Store",  slots = 6,
    items = {
	[1] = { name = "water_bottle", price = 50, amount = 100, info = {}, type = "item", slot = 1, },
	[2] = { name = "sandwich", price = 70, amount = 250, info = {}, type = "item", slot = 2, },
	[3] = { name = "bandage", price = 100, amount = 100, info = {}, type = "item", slot = 3, },
	[4] = { name = "miningdrill",	price = 1000, amount = 100, info = {}, type = "item", slot = 4, }, 
	[5] = { name = "handdrill",	price = 1000, amount = 100, info = {}, type = "item",	slot = 5, },
	[6] = { name = "cuttingdrillbit", price = 20, amount = 100,	info = {}, type = "item", slot = 6, }, }		
}