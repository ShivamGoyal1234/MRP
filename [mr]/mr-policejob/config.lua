Config = {}

MaxSpikes = 5

local StringCharset = {}
local NumberCharset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(StringCharset, string.char(i)) end
for i = 97, 122 do table.insert(StringCharset, string.char(i)) end

Config.RandomStr = function(length)
	if length > 0 then
		return Config.RandomStr(length-1) .. StringCharset[math.random(1, #StringCharset)]
	else
		return ''
	end
end

Config.RandomInt = function(length)
	if length > 0 then
		return Config.RandomInt(length-1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

Config.Allowedfix = {
    `ambulance`,
    `emsf250`,
    `emscap`,
    `iak_wheelchair`,
    `emsdurango`,
    `ems18charg`,
    `code3bmw`,
    `camaroRB`,
    `code3cvpi`,
    `code3gator`,
    `code3mustang`,
    `code3silverado`,
    `code318charg`,
    `code318tahoe`,
    `code320exp`,
    `pbike`,
    `pbus`,
    `amggtrleo`,
    `911turboleo`,
    `modelsleo`,
    `viperleo`,
    `riot`,
    `18raptor`,
    `swat`,
    `d`,
    `npolmm`,
    `as350`,
    `polmav`,
    `bcat`,
	`npolblazer`,
	`npolchal`,
	`npolchar`,
	`npolcoach`,
	`npolexp`,
	`npolmm`,
	`npolretinue`,
	`npolstang`,
	`npolvette`,
	`npolvic`
}

Config.AllowedEMS = {
    `ambulance`,
    `emsf250`,
    `emscap`,
    `iak_wheelchair`,
    `emsdurango`,
    `ems18charg`,
    `polmav`,
}

Config.AllowedPD = {
    `code3bmw`,
    `camaroRB`,
    `code3cvpi`,
    `code3gator`,
    `code3mustang`,
    `code3silverado`,
    `code318charg`,
    `code318tahoe`,
    `code320exp`,
    `pbike`,
    `pbus`,
    `amggtrleo`,
    `911turboleo`,
    `modelsleo`,
    `viperleo`,
    `riot`,
    `18raptor`,
    `swat`,
    `d`,
    `npolmm`,
    `as350`,
    `bcat`,
	`npolblazer`,
	`npolchal`,
	`npolchar`,
	`npolcoach`,
	`npolexp`,
	`npolmm`,
	`npolretinue`,
	`npolstang`,
	`npolvette`,
	`npolvic`
}

Config.Objects = {
    ["cone"] = {model = `prop_roadcone02a`, freeze = false},
    ["barier"] = {model = `prop_barrier_work06a`, freeze = true},
    ["schotten"] = {model = `prop_snow_sign_road_06g`, freeze = true},
    ["tent"] = {model = `prop_gazebo_03`, freeze = true},
    ["light"] = {model = `prop_worklight_03b`, freeze = true},
    ["boombox"] = {model = `prop_boombox_01`, freeze = true},
    ["boombox2"] = {model = `prop_portable_hifi_01`, freeze = true},
    ["tv"] = {model = `ba_prop_battle_crates_rifles_03a`, freeze = true},
}

Config.Locations = {
   ["duty"] = {
       [1] = vector3(443.0, -982.98, 30.69),
       [2] = vector3(-448.35, 6014.07, 32.29),
   },
   ["vehicle"] = {
       [1] = vector4(451.69, -991.23, 25.7, 183.68),
       [2] = vector4(476.66, -1024.43, 28.08, 127.9),
       [3] = vector4(-477.0, 6026.39, 31.34, 230.74)
   },
   ["stash"] = {
       [1] = vector3(461.91, -995.92, 30.69),
       [2] = vector3(-439.44, 6011.3, 37.0),
   },
   ["impound"] = {
       [1] = vector4(454.94, -1017.88, 28.42, 101.84),
       [2] = vector4(-461.36, 6039.79, 31.34, 126.38),
   },
   ["helicopter"] = {
       [1] = vector4(449.168, -981.325, 43.691, 87.234),
       [2] = vector4(-475.34, 5988.78, 31.34, 316.65),
   },
   ["armory"] = {
       [1] = vector3(482.38, -995.26, 30.69),
       [2] = vector3(-445.86, 6018.63, 37.0),
       [3] = vector3(485.47, -995.25, 30.69),
   },
   ["snacks"] = {
        [1] = vector3(462.23, -981.12, 30.68),
   },
   ["trash"] = {
       [1] = vector3(472.69, -996.01, 26.27),
   },
   ["fingerprint"] = {
       [1] = vector3(473.9, -1013.3, 26.27),
       [2] = vector3(1839.98, 2595.54, 46.01),
       [3] = vector3(-452.21, 5997.65, 27.58),
   },
   ["evidence"] = {
       [1] = vector3(446.91, -996.99, 30.69),
       [2] = vector3(-452.71, 5999.67, 37.01),
   },
   ["evidence2"] = {
       [1] = vector3(474.5, -993.87, 26.27),
   },
   ["evidence3"] = {
       [1] = vector3(475.07, -996.68, 26.27),
   },
   ["stations"] = {
       [1] = {label = "Police Station", coords = vector4(428.23, -984.28, 29.76, 3.5)},
       [2] = {label = "Prison", coords = vector4(1845.903, 2585.873, 45.672, 272.249)},
   },
}

Config.ArmoryWhitelist = {}

Config.Helicopter = "as350"

Config.SecurityCameras = {
    hideradar = false,
    cameras = {
        [1] = {label = "Pacific Bank CAM#1", coords = vector3(257.45, 210.07, 109.08), r = {x = -25.0, y = 0.0, z = 28.05}, canRotate = false, isOnline = true},
        [2] = {label = "Pacific Bank CAM#2", coords = vector3(232.86, 221.46, 107.83), r = {x = -25.0, y = 0.0, z = -140.91}, canRotate = false, isOnline = true},
        [3] = {label = "Pacific Bank CAM#3", coords = vector3(252.27, 225.52, 103.99), r = {x = -35.0, y = 0.0, z = -74.87}, canRotate = false, isOnline = true},
        [4] = {label = "Limited Ltd Grove St. CAM#1", coords = vector3(-53.1433, -1746.714, 31.546), r = {x = -35.0, y = 0.0, z = -168.9182}, canRotate = false, isOnline = true},
        [5] = {label = "Rob's Liqour Prosperity St. CAM#1", coords = vector3(-1482.9, -380.463, 42.363), r = {x = -35.0, y = 0.0, z = 79.53281}, canRotate = false, isOnline = true},
        [6] = {label = "Rob's Liqour San Andreas Ave. CAM#1", coords = vector3(-1224.874, -911.094, 14.401), r = {x = -35.0, y = 0.0, z = -6.778894}, canRotate = false, isOnline = true},
        [7] = {label = "Limited Ltd Ginger St. CAM#1", coords = vector3(-718.153, -909.211, 21.49), r = {x = -35.0, y = 0.0, z = -137.1431}, canRotate = false, isOnline = true},
        [8] = {label = "24/7 Supermarkt Innocence Blvd. CAM#1", coords = vector3(23.885, -1342.441, 31.672), r = {x = -35.0, y = 0.0, z = -142.9191}, canRotate = false, isOnline = true},
        [9] = {label = "Rob's Liqour El Rancho Blvd. CAM#1", coords = vector3(1133.024, -978.712, 48.515), r = {x = -35.0, y = 0.0, z = -137.302}, canRotate = false, isOnline = true},
        [10] = {label = "Limited Ltd West Mirror Drive CAM#1", coords = vector3(1151.93, -320.389, 71.33), r = {x = -35.0, y = 0.0, z = -119.4468}, canRotate = false, isOnline = true},
        [11] = {label = "24/7 Supermarkt Clinton Ave CAM#1", coords = vector3(383.402, 328.915, 105.541), r = {x = -35.0, y = 0.0, z = 118.585}, canRotate = false, isOnline = true},
        [12] = {label = "Limited Ltd Banham Canyon Dr CAM#1", coords = vector3(-1832.057, 789.389, 140.436), r = {x = -35.0, y = 0.0, z = -91.481}, canRotate = false, isOnline = true},
        [13] = {label = "Rob's Liqour Great Ocean Hwy CAM#1", coords = vector3(-2966.15, 387.067, 17.393), r = {x = -35.0, y = 0.0, z = 32.92229}, canRotate = false, isOnline = true},
        [14] = {label = "24/7 Supermarkt Ineseno Road CAM#1", coords = vector3(-3046.749, 592.491, 9.808), r = {x = -35.0, y = 0.0, z = -116.673}, canRotate = false, isOnline = true},
        [15] = {label = "24/7 Supermarkt Barbareno Rd. CAM#1", coords = vector3(-3246.489, 1010.408, 14.705), r = {x = -35.0, y = 0.0, z = -135.2151}, canRotate = false, isOnline = true},
        [16] = {label = "24/7 Supermarkt Route 68 CAM#1", coords = vector3(539.773, 2664.904, 44.056), r = {x = -35.0, y = 0.0, z = -42.947}, canRotate = false, isOnline = true},
        [17] = {label = "Rob's Liqour Route 68 CAM#1", coords = vector3(1169.855, 2711.493, 40.432), r = {x = -35.0, y = 0.0, z = 127.17}, canRotate = false, isOnline = true},
        [18] = {label = "24/7 Supermarkt Senora Fwy CAM#1", coords = vector3(2673.579, 3281.265, 57.541), r = {x = -35.0, y = 0.0, z = -80.242}, canRotate = false, isOnline = true},
        [19] = {label = "24/7 Supermarkt Alhambra Dr. CAM#1", coords = vector3(1966.24, 3749.545, 34.143), r = {x = -35.0, y = 0.0, z = 163.065}, canRotate = false, isOnline = true},
        [20] = {label = "24/7 Supermarkt Senora Fwy CAM#2", coords = vector3(1729.522, 6419.87, 37.262), r = {x = -35.0, y = 0.0, z = -160.089}, canRotate = false, isOnline = true},
        [21] = {label = "Fleeca Bank Hawick Ave CAM#1", coords = vector3(309.341, -281.439, 55.88), r = {x = -35.0, y = 0.0, z = -146.1595}, canRotate = false, isOnline = true},
        [22] = {label = "Fleeca Bank Legion Square CAM#1", coords = vector3(144.871, -1043.044, 31.017), r = {x = -35.0, y = 0.0, z = -143.9796}, canRotate = false, isOnline = true},
        [23] = {label = "Fleeca Bank Hawick Ave CAM#2", coords = vector3(-355.7643, -52.506, 50.746), r = {x = -35.0, y = 0.0, z = -143.8711}, canRotate = false, isOnline = true},
        [24] = {label = "Fleeca Bank Del Perro Blvd CAM#1", coords = vector3(-1214.226, -335.86, 39.515), r = {x = -35.0, y = 0.0, z = -97.862}, canRotate = false, isOnline = true},
        [25] = {label = "Fleeca Bank Great Ocean Hwy CAM#1", coords = vector3(-2958.885, 478.983, 17.406), r = {x = -35.0, y = 0.0, z = -34.69595}, canRotate = false, isOnline = true},
        [26] = {label = "Paleto Bank CAM#1", coords = vector3(-102.939, 6467.668, 33.424), r = {x = -35.0, y = 0.0, z = 24.66}, canRotate = false, isOnline = true},
        [27] = {label = "Del Vecchio Liquor Paleto Bay", coords = vector3(-163.75, 6323.45, 33.424), r = {x = -35.0, y = 0.0, z = 260.00}, canRotate = false, isOnline = true},
        [28] = {label = "Don's Country Store Paleto Bay CAM#1", coords = vector3(166.42, 6634.4, 33.69), r = {x = -35.0, y = 0.0, z = 32.00}, canRotate = false, isOnline = true},
        [29] = {label = "Don's Country Store Paleto Bay CAM#2", coords = vector3(163.74, 6644.34, 33.69), r = {x = -35.0, y = 0.0, z = 168.00}, canRotate = false, isOnline = true},
        [30] = {label = "Don's Country Store Paleto Bay CAM#3", coords = vector3(169.54, 6640.89, 33.69), r = {x = -35.0, y = 0.0, z = 5.78}, canRotate = false, isOnline = true},
        [31] = {label = "Vangelico Jewelery CAM#1", coords = vector3(-627.54, -239.74, 40.33), r = {x = -35.0, y = 0.0, z = 5.78}, canRotate = true, isOnline = true},
        [32] = {label = "Vangelico Jewelery CAM#2", coords = vector3(-627.51, -229.51, 40.24), r = {x = -35.0, y = 0.0, z = -95.78}, canRotate = true, isOnline = true},
        [33] = {label = "Vangelico Jewelery CAM#3", coords = vector3(-620.3, -224.31, 40.23), r = {x = -35.0, y = 0.0, z = 165.78}, canRotate = true, isOnline = true},
        [34] = {label = "Vangelico Jewelery CAM#4", coords = vector3(-622.57, -236.3, 40.31), r = {x = -35.0, y = 0.0, z = 5.78}, canRotate = true, isOnline = true},
    },
}

Config.AuthorizedVehicles = {
	[0] = { --Recruit
        ["code3gator"] = "09 John Deere Gator",
        ["pbike"] = "Police Bicycle",
    },

    [1] = { --cadet
        -- ["code3bmw"] = "2014 BMW R-1200RT",
        -- ["camaroRB"] = "2018 Chevrolet Camaro SS",
        -- ["code3cvpi"] = "2011  Ford Crown Victoria",
        ["code3gator"] = "09 John Deere Gator",
        -- ["code3mustang"] = "2018 Police Mustang GT",
        -- ["code3silverado"] = "Silverado",
        -- ["code318charg"] = "2018 Dodge Charger Enforcer",
        -- ["code318tahoe"] = "2014 Chevrolet Tahoe",
        -- ["code320exp"] = "2020 Ford Explorer",
        ["pbike"] = "Police Bicycle",
        -- ["pbus"] = "Prison Bus",
        -- ["amggtrleo"] = "AMG GTR",
        -- ["911turboleo"] = "911 Porshe",
        -- ["modelsleo"] = "Tesla Model S",
        -- ["viperleo"] = "Viper",
        -- ["riot"] = "Riot Van",
        -- ["18raptor"] = "Police Raptor",
        -- ["swat"] = "Special Swat",
        -- ["d"] = "Chief Car",
        -- ["npolmm"] = "PD Bike",
    },

    [2] = { --Trooper
   -- ["code3bmw"] = "2014 BMW R-1200RT",
        -- ["camaroRB"] = "2018 Chevrolet Camaro SS",
        -- ["code3cvpi"] = "2011  Ford Crown Victoria",
        ["code3gator"] = "09 John Deere Gator",
        -- ["code3mustang"] = "2018 Police Mustang GT",
        -- ["code3silverado"] = "Silverado",
        -- ["code318charg"] = "2018 Dodge Charger Enforcer",
        -- ["code318tahoe"] = "2014 Chevrolet Tahoe",
        -- ["code320exp"] = "2020 Ford Explorer",
        ["pbike"] = "Police Bicycle",
        -- ["pbus"] = "Prison Bus",
        -- ["amggtrleo"] = "AMG GTR",
        -- ["911turboleo"] = "911 Porshe",
        -- ["modelsleo"] = "Tesla Model S",
        -- ["viperleo"] = "Viper",
        -- ["riot"] = "Riot Van",
        -- ["18raptor"] = "Police Raptor",
        -- ["swat"] = "Special Swat",
        -- ["d"] = "Chief Car",
        -- ["npolmm"] = "PD Bike",
    },

    [3] = { --Trooper First Class
     -- ["code3bmw"] = "2014 BMW R-1200RT",
        -- ["camaroRB"] = "2018 Chevrolet Camaro SS",
        -- ["code3cvpi"] = "2011  Ford Crown Victoria",
        ["code3gator"] = "09 John Deere Gator",
        -- ["code3mustang"] = "2018 Police Mustang GT",
        -- ["code3silverado"] = "Silverado",
        -- ["code318charg"] = "2018 Dodge Charger Enforcer",
        -- ["code318tahoe"] = "2014 Chevrolet Tahoe",
        -- ["code320exp"] = "2020 Ford Explorer",
        ["pbike"] = "Police Bicycle",
        -- ["pbus"] = "Prison Bus",
        -- ["amggtrleo"] = "AMG GTR",
        -- ["911turboleo"] = "911 Porshe",
        -- ["modelsleo"] = "Tesla Model S",
        -- ["viperleo"] = "Viper",
        -- ["riot"] = "Riot Van",
        -- ["18raptor"] = "Police Raptor",
        -- ["swat"] = "Special Swat",
        -- ["d"] = "Chief Car",
        -- ["npolmm"] = "PD Bike",
    },

    [4] = { ---Senior Trooper
       -- ["code3bmw"] = "2014 BMW R-1200RT",
        -- ["camaroRB"] = "2018 Chevrolet Camaro SS",
        -- ["code3cvpi"] = "2011  Ford Crown Victoria",
        ["code3gator"] = "09 John Deere Gator",
        -- ["code3mustang"] = "2018 Police Mustang GT",
        -- ["code3silverado"] = "Silverado",
        -- ["code318charg"] = "2018 Dodge Charger Enforcer",
        -- ["code318tahoe"] = "2014 Chevrolet Tahoe",
        -- ["code320exp"] = "2020 Ford Explorer",
        ["pbike"] = "Police Bicycle",
        -- ["pbus"] = "Prison Bus",
        -- ["amggtrleo"] = "AMG GTR",
        -- ["911turboleo"] = "911 Porshe",
        -- ["modelsleo"] = "Tesla Model S",
        -- ["viperleo"] = "Viper",
        -- ["riot"] = "Riot Van",
        -- ["18raptor"] = "Police Raptor",
        -- ["swat"] = "Special Swat",
        -- ["d"] = "Chief Car",
        -- ["npolmm"] = "PD Bike",
    },

    [5] = { --Corporal
        -- ["code3bmw"] = "2014 BMW R-1200RT",
        -- ["camaroRB"] = "2018 Chevrolet Camaro SS",
        -- ["code3cvpi"] = "2011  Ford Crown Victoria",
        ["code3gator"] = "09 John Deere Gator",
        -- ["code3mustang"] = "2018 Police Mustang GT",
        -- ["code3silverado"] = "Silverado",
        -- ["code318charg"] = "2018 Dodge Charger Enforcer",
        -- ["code318tahoe"] = "2014 Chevrolet Tahoe",
        -- ["code320exp"] = "2020 Ford Explorer",
        ["pbike"] = "Police Bicycle",
        -- ["pbus"] = "Prison Bus",
        -- ["amggtrleo"] = "AMG GTR",
        -- ["911turboleo"] = "911 Porshe",
        -- ["modelsleo"] = "Tesla Model S",
        -- ["viperleo"] = "Viper",
        -- ["riot"] = "Riot Van",
        -- ["18raptor"] = "Police Raptor",
        -- ["swat"] = "Special Swat",
        -- ["d"] = "Chief Car",
        -- ["npolmm"] = "PD Bike",
    },

    [6] = { ---Sergeant
    -- ["code3bmw"] = "2014 BMW R-1200RT",
        -- ["camaroRB"] = "2018 Chevrolet Camaro SS",
        -- ["code3cvpi"] = "2011  Ford Crown Victoria",
        ["code3gator"] = "09 John Deere Gator",
        -- ["code3mustang"] = "2018 Police Mustang GT",
        -- ["code3silverado"] = "Silverado",
        -- ["code318charg"] = "2018 Dodge Charger Enforcer",
        -- ["code318tahoe"] = "2014 Chevrolet Tahoe",
        -- ["code320exp"] = "2020 Ford Explorer",
        ["pbike"] = "Police Bicycle",
        -- ["pbus"] = "Prison Bus",
        -- ["amggtrleo"] = "AMG GTR",
        -- ["911turboleo"] = "911 Porshe",
        -- ["modelsleo"] = "Tesla Model S",
        -- ["viperleo"] = "Viper",
        -- ["riot"] = "Riot Van",
        -- ["18raptor"] = "Police Raptor",
        -- ["swat"] = "Special Swat",
        -- ["d"] = "Chief Car",
        -- ["npolmm"] = "PD Bike",
    },

    [7] = { --Lieutenant
      -- ["code3bmw"] = "2014 BMW R-1200RT",
        -- ["camaroRB"] = "2018 Chevrolet Camaro SS",
        -- ["code3cvpi"] = "2011  Ford Crown Victoria",
        ["code3gator"] = "09 John Deere Gator",
        -- ["code3mustang"] = "2018 Police Mustang GT",
        -- ["code3silverado"] = "Silverado",
        -- ["code318charg"] = "2018 Dodge Charger Enforcer",
        -- ["code318tahoe"] = "2014 Chevrolet Tahoe",
        -- ["code320exp"] = "2020 Ford Explorer",
        ["pbike"] = "Police Bicycle",
        -- ["pbus"] = "Prison Bus",
        -- ["amggtrleo"] = "AMG GTR",
        -- ["911turboleo"] = "911 Porshe",
        -- ["modelsleo"] = "Tesla Model S",
        -- ["viperleo"] = "Viper",
        -- ["riot"] = "Riot Van",
        -- ["18raptor"] = "Police Raptor",
        -- ["swat"] = "Special Swat",
        -- ["d"] = "Chief Car",
        -- ["npolmm"] = "PD Bike",
    },

    [8] = { ---Captain
      -- ["code3bmw"] = "2014 BMW R-1200RT",
        -- ["camaroRB"] = "2018 Chevrolet Camaro SS",
        -- ["code3cvpi"] = "2011  Ford Crown Victoria",
        ["code3gator"] = "09 John Deere Gator",
        -- ["code3mustang"] = "2018 Police Mustang GT",
        -- ["code3silverado"] = "Silverado",
        -- ["code318charg"] = "2018 Dodge Charger Enforcer",
        -- ["code318tahoe"] = "2014 Chevrolet Tahoe",
        -- ["code320exp"] = "2020 Ford Explorer",
        ["pbike"] = "Police Bicycle",
        -- ["pbus"] = "Prison Bus",
        -- ["amggtrleo"] = "AMG GTR",
        -- ["911turboleo"] = "911 Porshe",
        -- ["modelsleo"] = "Tesla Model S",
        -- ["viperleo"] = "Viper",
        -- ["riot"] = "Riot Van",
        -- ["18raptor"] = "Police Raptor",
        -- ["swat"] = "Special Swat",
        -- ["d"] = "Chief Car",
        -- ["npolmm"] = "PD Bike",
    },

    [9] = { --Assistant Commissioner
        -- ["code3bmw"] = "2014 BMW R-1200RT",
        -- ["camaroRB"] = "2018 Chevrolet Camaro SS",
        -- ["code3cvpi"] = "2011  Ford Crown Victoria",
        ["code3gator"] = "09 John Deere Gator",
        -- ["code3mustang"] = "2018 Police Mustang GT",
        -- ["code3silverado"] = "Silverado",
        -- ["code318charg"] = "2018 Dodge Charger Enforcer",
        -- ["code318tahoe"] = "2014 Chevrolet Tahoe",
        -- ["code320exp"] = "2020 Ford Explorer",
        ["pbike"] = "Police Bicycle",
        -- ["pbus"] = "Prison Bus",
        -- ["amggtrleo"] = "AMG GTR",
        -- ["911turboleo"] = "911 Porshe",
        -- ["modelsleo"] = "Tesla Model S",
        -- ["viperleo"] = "Viper",
        -- ["riot"] = "Riot Van",
        -- ["18raptor"] = "Police Raptor",
        -- ["swat"] = "Special Swat",
        -- ["d"] = "Chief Car",
        -- ["npolmm"] = "PD Bike",
    },

    [10] = { ---Deputy Commissioner
       -- ["code3bmw"] = "2014 BMW R-1200RT",
        -- ["camaroRB"] = "2018 Chevrolet Camaro SS",
        -- ["code3cvpi"] = "2011  Ford Crown Victoria",
        ["code3gator"] = "09 John Deere Gator",
        -- ["code3mustang"] = "2018 Police Mustang GT",
        -- ["code3silverado"] = "Silverado",
        -- ["code318charg"] = "2018 Dodge Charger Enforcer",
        -- ["code318tahoe"] = "2014 Chevrolet Tahoe",
        -- ["code320exp"] = "2020 Ford Explorer",
        ["pbike"] = "Police Bicycle",
        -- ["pbus"] = "Prison Bus",
        -- ["amggtrleo"] = "AMG GTR",
        -- ["911turboleo"] = "911 Porshe",
        -- ["modelsleo"] = "Tesla Model S",
        -- ["viperleo"] = "Viper",
        -- ["riot"] = "Riot Van",
        -- ["18raptor"] = "Police Raptor",
        -- ["swat"] = "Special Swat",
        -- ["d"] = "Chief Car",
        -- ["npolmm"] = "PD Bike",
    },

    [11] = { ----Commissioner
       -- ["code3bmw"] = "2014 BMW R-1200RT",
        -- ["camaroRB"] = "2018 Chevrolet Camaro SS",
        -- ["code3cvpi"] = "2011  Ford Crown Victoria",
        ["code3gator"] = "09 John Deere Gator",
        -- ["code3mustang"] = "2018 Police Mustang GT",
        -- ["code3silverado"] = "Silverado",
        -- ["code318charg"] = "2018 Dodge Charger Enforcer",
        -- ["code318tahoe"] = "2014 Chevrolet Tahoe",
        -- ["code320exp"] = "2020 Ford Explorer",
        ["pbike"] = "Police Bicycle",
        -- ["pbus"] = "Prison Bus",
        -- ["amggtrleo"] = "AMG GTR",
        -- ["911turboleo"] = "911 Porshe",
        -- ["modelsleo"] = "Tesla Model S",
        -- ["viperleo"] = "Viper",
        -- ["riot"] = "Riot Van",
        -- ["18raptor"] = "Police Raptor",
        -- ["swat"] = "Special Swat",
        -- ["npolmm"] = "PD Bike",
    },

    [12] = { -- Chief
        -- ["code3bmw"] = "2014 BMW R-1200RT",
        -- ["camaroRB"] = "2018 Chevrolet Camaro SS",
        -- ["code3cvpi"] = "2011  Ford Crown Victoria",
        ["code3gator"] = "09 John Deere Gator",
        -- ["code3mustang"] = "2018 Police Mustang GT",
        -- ["code3silverado"] = "Silverado",
        -- ["code318charg"] = "2018 Dodge Charger Enforcer",
        -- ["code318tahoe"] = "2014 Chevrolet Tahoe",
        -- ["code320exp"] = "2020 Ford Explorer",
        ["pbike"] = "Police Bicycle",
        -- ["pbus"] = "Prison Bus",
        -- ["amggtrleo"] = "AMG GTR",
        -- ["911turboleo"] = "911 Porshe",
        -- ["modelsleo"] = "Tesla Model S",
        -- ["viperleo"] = "Viper",
        -- ["riot"] = "Riot Van",
        -- ["18raptor"] = "Police Raptor",
        -- ["swat"] = "Special Swat",
        -- ["d"] = "Chief Car",
        -- ["npolmm"] = "PD Bike",
    },
}

Config.WhitelistedVehicles = {}

Config.AmmoLabels = {
    ["AMMO_PISTOL"] = "9x19mm parabellum bullet",
    ["AMMO_SMG"] = "9x19mm parabellum bullet",
    ["AMMO_RIFLE"] = "7.62x39mm bullet",
    ["AMMO_MG"] = "7.92x57mm mauser bullet",
    ["AMMO_SHOTGUN"] = "12-gauge bullet",
    ["AMMO_SNIPER"] = "Large caliber bullet",
}

Config.Radars = {
	vector4(-623.44421386719, -823.08361816406, 25.25704574585, 145.0),
	vector4(-652.44421386719, -854.08361816406, 24.55704574585, 325.0),
	vector4(1623.0114746094, 1068.9924316406, 80.903594970703, 84.0),
	vector4(-2604.8994140625, 2996.3391113281, 27.528566360474, 175.0),
	vector4(2136.65234375, -591.81469726563, 94.272926330566, 318.0),
	vector4(2117.5764160156, -558.51013183594, 95.683128356934, 158.0),
	vector4(406.89505004883, -969.06286621094, 29.436267852783, 33.0),
	vector4(657.315, -218.819, 44.06, 320.0),
	vector4(2118.287, 6040.027, 50.928, 172.0),
	vector4(-106.304, -1127.5530, 30.778, 230.0),
	vector4(-823.3688, -1146.980, 8.0, 300.0),
}

Config.CarItems = {
    -- [1] = {
    --     name = "heavyarmor",
    --     amount = 2,
    --     info = {},
    --     type = "item",
    --     slot = 1,
    -- },
    [1] = {
        name = "empty_evidence_bag",
        amount = 10,
        info = {},
        type = "item",
        slot = 1,
    },
    -- [2] = {
    --     name = "police_stormram",
    --     amount = 1,
    --     info = {},
    --     type = "item",
    --     slot = 2,
    -- },
}

Config.Items = {
    label = "Police Armory",
    slots = 40,
    items = {
        [1] = {
            name = "water_bottle",
            price = 0,
            amount = 20,
            info = {},
            type = "item",
            slot = 1,
            authorizedJobGrades = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
        },
        [2] = {
            name = "weapon_stungun",
            price = 0,
            amount = 1,
            info = {
                serie = "",            
            },
            type = "weapon",
            slot = 2,
            authorizedJobGrades = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
        },
        [3] = {
            name = "weapon_pumpshotgun",
            price = 100,
            amount = 1,
            info = {
                serie = "",
                attachments = {
                    {component = "COMPONENT_AT_AR_FLSH", label = "Flashlight"},
                    {component = "COMPONENT_PUMPSHOTGUN_VARMOD_LOWRIDER", label = "Yusuf Amir Luxury Finish"},
                }
            },
            type = "weapon",
            slot = 3,
            -- authorizedJobGrades = {2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
            authorizedJobGrades = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
        },
        [4] = {
            name = "weapon_heavypistol",
            price = 150,
            amount = 1,
            info = {
                serie = "",
                attachments = {
                    {component = "COMPONENT_AT_PI_FLSH", label = "Flashlight"},
                    {component = "COMPONENT_HEAVYPISTOL_VARMOD_LUXE", label = "Etched Wood Grip Finish"},
                }
            },
            type = "weapon",
            slot = 4,
            authorizedJobGrades = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
        },
        [5] = {
            name = "weapon_nightstick",
            price = 0,
            amount = 1,
            info = {},
            type = "weapon",
            slot = 5,
            authorizedJobGrades = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
        },
        [6] = {
            name = "pistol_ammo",
            price = 0,
            amount = 20,
            info = {},
            type = "item",
            slot = 6,
            authorizedJobGrades = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
        },
        [7] = {
            name = "smg_ammo",
            price = 0,
            amount = 20,
            info = {},
            type = "item",
            slot = 7,
            authorizedJobGrades = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
        },
        [8] = {
            name = "shotgun_ammo",
            price = 0,
            amount = 20,
            info = {},
            type = "item",
            slot = 8,
            authorizedJobGrades = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
        },
        [9] = {
            name = "rifle_ammo",
            price = 0,
            amount = 20,
            info = {},
            type = "item",
            slot = 9,
            authorizedJobGrades = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
        },
        [10] = {
            name = "handcuffs",
            price = 0,
            amount = 5,
            info = {},
            type = "item",
            slot = 10,
            authorizedJobGrades = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
        },
        [11] = {
            name = "weapon_flashlight",
            price = 0,
            amount = 1,
            info = {},
            type = "weapon",
            slot = 11,
            authorizedJobGrades = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
        },
        [12] = {
            name = "empty_evidence_bag",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 12,
            authorizedJobGrades = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
        },
        [13] = {
            name = "police_stormram",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 13,
            authorizedJobGrades = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
        },
        [14] = {
            name = "armor",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 14,
            authorizedJobGrades = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
        },
        [15] = {
            name = "radio",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 15,
            authorizedJobGrades = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
        },
        [16] = {
            name = "heavyarmor",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 16,
            authorizedJobGrades = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
        },
        [17] = {
            name = "repairkit",
            price = 15,
            amount = 50,
            info = {},
            type = "item",
            slot = 17,
            authorizedJobGrades = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
        },
        [18] = {
            name = "ifak",
            price = 10,
            amount = 50,
            info = {},
            type = "item",
            slot = 18,
            authorizedJobGrades = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
        },
        [19] = {
            name = "bandage",
            price = 5,
            amount = 50,
            info = {},
            type = "item",
            slot = 19,
            authorizedJobGrades = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
        },
        [20] = {
            name = "bodycam",
            price = 50,
            amount = 50,
            info = {},
            type = "item",
            slot = 20,
            authorizedJobGrades = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
        },
        [21] = {
            name = "parachute",
            price = 200,
            amount = 50,
            info = {
                uses = 20
            },
            type = "item",
            slot = 21,
            authorizedJobGrades = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
        },
        [22] = {
            name = "diving_gear",
            price = 250,
            amount = 50,
            info = {},
            type = "item",
            slot = 22,
            authorizedJobGrades = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
        },
        [23] = {
            name = "tracker",
            price = 100,
            amount = 1,
            info = {},
            type = "item",
            slot = 23,
            authorizedJobGrades = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
        },
        [24] = {
            name = "weapon_m4a4",
            price = 150,
            amount = 1,
            info = {
                serie = "",
                attachments = {
                    {component = "COMPONENT_AT_AR_FLSH", label = "Flashlight"},
                }
            },
            type = "weapon",
            slot = 24,
            -- authorizedJobGrades = {8, 9, 10, 11, 12}
            authorizedJobGrades = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
        },
        [26] = {
            name = "weapon_smg",
            price = 200,
            amount = 1,
            info = {
                serie = "",
            },
            type = "weapon",
            slot = 26,
            -- authorizedJobGrades = {3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
            authorizedJobGrades = {6,7,8,9,10,11, 12}
        },
        [27] = {
            name = "nightvision",
            price = 500,
            amount = 1,
            info = {},
            type = "item",
            slot = 37,
            authorizedJobGrades = {0,1,2,3,4,5,6,7,8, 9, 10, 11, 12}
        },
        [28] = {
            name = "weapon_glock17",
            price = 200,
            amount = 1,
            info = {
                serie = "",
                attachments = {
                    {component = "COMPONENT_AT_PI_FLSH_02", label = "Flashlight"},
                }
            },
            type = "weapon",
            slot = 28,
            authorizedJobGrades = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
        },
        [29] = {
            name = "drone7",
            price = 15000,
            amount = 1,
            info = {},
            type = "item",
            slot = 29,
            authorizedJobGrades = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
        },
    }
}

Config.gsrUpdate                = 1 * 1000          -- Change first number only, how often a new shot is logged dont set this to low keep it above 1 min - raise if you experience performans issues (default: 1 min).
Config.waterClean               = true              -- Set to false if you dont want water to clean off GSR from people who shot
Config.waterCleanTime           = 30 * 1000         -- Change first number only, Set time in water needed to clean off GSR (default: 30 sec).
Config.gsrTime                  = 30 * 60           -- Change The first number only, if you want the GSR to be auto removed faster output is minutes (default: 30 min).
Config.gsrAutoRemove            = 10 * 60 * 1000    -- Change first number only, to set the auto clean up in minuets (default: 10 min).
Config.gsrUpdateStatus          = 5 * 60 * 1000     -- Change first number only, to change how often the client updates hasFired variable dont set it to high 5-10 min should be fine. (default: 5 min).
Config.UseCharName				= true				-- This will show the suspects name in the PASSED or FAILED notification.Allows cop to make sure they checked the right person.