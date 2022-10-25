Config = Config or {}

Config.RosterLink = {
    ['police'] = 'https://docs.google.com/spreadsheets/d/1EH17UnaJGIJ2tzGbdtllJSwbP6Tz4fUbM3D9mkXVAZU/edit#gid=0',
    ['doctor'] = '',
    ['bcso'] = '',
    ['doj'] = '',
}

Config.Fuel = "aj-fuel" 

Config.PenalCodeTitles = {
    [1] = 'OFFENSES AGAINST PERSONS',
    [2] = 'OFFENSES INVOLVING THEFT',
    [3] = 'OFFENSES INVOLVING FRAUD',
    [4] = 'OFFENSES INVOLVING DAMAGE TO PROPERTY',
    [5] = 'OFFENSES AGAINST PUBLIC ADMINISTRATION',
    [6] = 'OFFENSES AGAINST PUBLIC ORDER',
    [7] = 'OFFENSES AGAINST HEALTH AND MORALS',
    [8] = 'OFFENSES AGAINST PUBLIC SAFETY',
    [9] = 'OFFENSES INVOLVING THE OPERATION OF A VEHICLE',
    [10] = 'OFFENSES INVOLVING THE WELL-BEING OF WILDLIFE',
}

Config.PenalCode = {
    [1] = {
        [1] = { title = 'Assault', class = 'Misdemeanor', id = 'P.C. 1002', months = 9, fine = 950, color = 'orange' },
        [2] = { title = 'Assault with a deadly weapon', class = 'Felony', id = 'P.C. 1004', months = 9, fine = 1000, color = 'red' },
        [3] = { title = 'Involuntary Manslaughter', class = 'Felony', id = 'P.C. 1005', months = 7, fine = 900, color = 'red' },
        [4] = { title = 'Voluntary Manslaughter', class = 'Felony', id = 'P.C. 1006', months = 7, fine = 900, color = 'red' },
        [5] = { title = 'Vehicular Manslaughter', class = 'Felony', id = 'P.C. 1007', months = 10, fine = 1300, color = 'red' },
        [6] = { title = 'Attempted Murder of a civilian', class = 'Felony', id = 'P.C. 1008', months = 9, fine = 1000, color = 'red' },
        [7] = { title = 'Murder of a Public Servant or Peace Officer', class = 'Felony', id = 'P.C. 1013', months = 15, fine = 3000, color = 'red' },
        [8] = { title = 'Attempted Murder of a Public Servant or Peace Officer', class = 'Felony', id = 'P.C. 1014', months = 11, fine = 1350, color = 'red' },
        [9] = { title = 'Unlawful Imprisonment', class = 'Misdemeanor', id = 'P.C. 1016', months = 6, fine = 600, color = 'green' },
        [10] = { title = 'Kidnapping', class = 'Felony', id = 'P.C. 1017', months = 8, fine = 900, color = 'orange' },
        [11] = { title = 'Kidnapping of a Public Servent and Peace Officer', class = 'Felony', id = 'P.C. 1017', months = 8, fine = 1100, color = 'orange' },
        [12] = { title = 'Criminal Threats', class = 'Misdemeanor', id = 'P.C. 1019', months = 5, fine = 900, color = 'orange' },
        [13] = { title = 'Reckless Endagerment', class = 'Misdemeanor', id = 'P.C. 1020', months = 5, fine = 800, color = 'orange' },
        [14] = { title = 'Gang Related Shooting', class = 'Felony', id = 'P.C. 1021', months = 10, fine = 1150, color = 'red' },
        [15] = { title = 'Torture', class = 'Felony', id = 'P.C. 1024', months = 8, fine = 1150, color = 'red' },
        [16] = { title = 'Assault on Leo', class = 'Felony', id = 'P.C. 1024', months = 8, fine = 1150, color = 'red' },
	},
	[2] = {
        [1] = { title = 'Petty Theft', class = 'infraction', id = 'P.C. 2001', months = 0, fine = 500, color = 'green' }, 
        [2] = { title = 'Grand Theft Auto', class = 'Felony', id = 'P.C. 2003', months = 7, fine = 900, color = 'green' },
        [3] = { title = 'Burglary', class = 'Misdemeanor', id = 'P.C. 2005', months = 7, fine = 900, color = 'green' },
        [4] = { title = 'Robbery of a Store ', class = 'Felony', id = 'P.C. 2006', months = 8, fine = 1350, color = 'green' },
        [5] = { title = 'Attempted Robbery of a Store', class = 'Felony', id = 'P.C. 2007', months = 8, fine = 1200, color = 'green' },
        [6] = { title = 'Robbery of a Jewellery Store', class = 'Felony', id = 'P.C. 2012', months = 9, fine = 1450, color = 'green' },
        [7] = { title = 'Attempted Robbery of a Jewellery Store', class = 'Felony', id = 'P.C. 2013', months = 9, fine = 1200, color = 'green' },
        [8] = { title = 'Robbery of a Bank', class = 'Felony', id = 'P.C. 2018', months = 10, fine = 1500, color = 'green' },
        [9] = { title = 'Attempted Robbery of a Bank', class = 'Felony', id = 'P.C. 2019', months = 10, fine = 1300, color = 'green' },
        [10] = { title = 'Accessory to Robbery of a Bank', class = 'Felony', id = 'P.C. 2020', months = 5, fine = 900, color = 'green' },
        [11] = { title = 'Leaving Without Paying', class = 'Misdemeanor', id = 'P.C. 2025', months = 3, fine = 900, color = 'green' },
        [12] = { title = 'Possession of Black Money', class = 'Infraction', id = 'P.C. 2026', months = 7, fine = 1050, color = 'green' },
	},
	[3] = {
        [1] = { title = 'Impersonating', class = 'Misdemeanor', id = 'P.C. 3001', months = 4, fine = 800, color = 'green' }, 
        [2] = { title = 'Impersonating a Peace Officer', class = 'Felony', id = 'P.C. 3002', months = 5, fine =800, color = 'green' },
        [3] = { title = 'Possession of Stolen Identification', class = 'Misdemeanor', id = 'P.C. 3004', months = 6, fine = 900, color = 'green' },
        [4] = { title = 'Extortion', class = 'Felony', id = 'P.C. 3005', months = 6, fine = 900, color = 'orange' },
        [5] = { title = 'Fraud', class = 'Misdemeanor', id = 'P.C. 3006', months = 8, fine = 1350, color = 'green' },
        [6] = { title = 'Forgery', class = 'Misdemeanor', id = 'P.C. 3007', months = 10, fine = 1250, color = 'green' },
        [7] = { title = 'Money Laundering', class = 'Felony', id = 'P.C. 3008', months = 14, fine = 1250, color = 'red' },
	},
	[4] = { 
        [1] = { title = 'Trespassing', class = 'Misdemeanor', id = 'P.C. 4001', months = 5, fine = 500, color = 'green' },
        [2] = { title = 'Felony Trespassing', class = 'Felony', id = 'P.C. 4002', months = 5, fine = 800, color = 'green' },
        [3] = { title = 'Arson', class = 'Felony', id = 'P.C. 4003', months = 8, fine = 1350, color = 'orange' },
        [4] = { title = 'Vandalism', class = 'infraction', id = 'P.C. 4004', months = 0, fine = 1000, color = 'green' },
        [5] = { title = 'Vandalism of Government Property', class = 'Felony', id = 'P.C. 4005', months = 4, fine = 1150, color = 'green' },
	},
	[5] = { 
        [1] = { title = 'Bribery of a Government Official', class = 'Felony', id = 'P.C. 5001', months = 7, fine = 1300, color = 'green' },
        [2] = { title = 'Anti-Mask Law', class = 'Misdemeanor', id = 'P.C. 5002', months = 3, fine = 500, color = 'green' },
        [3] = { title = 'Possession of Contraband in a Government Facility', class = 'Felony', id = 'P.C. 5003', months = 4, fine = 600, color = 'green' },
        [4] = { title = 'Criminal Possession of Stolen Property', class = 'Misdemeanor', id = 'P.C. 5004', months = 3, fine = 850, color = 'green' },
        [5] = { title = 'Escaping', class = 'Felony', id = 'P.C. 5005', months = 5, fine = 600, color = 'green' },
        [6] = { title = 'Jailbreak', class = 'Felony', id = 'P.C. 5006', months = 10, fine = 1000, color = 'orange' },
        [7] = { title = 'Accessory to Jailbreak', class = 'Felony', id = 'P.C. 5007', months = 9, fine = 1050, color = 'orange' },
        [8] = { title = 'Attempted Jailbreak', class = 'Felony', id = 'P.C. 5008', months = 9, fine = 1050, color = 'orange' },
        [9] = { title = 'Violation of a Restraining Order', class = 'Felony', id = 'P.C. 5010', months = 5, fine = 500, color = 'green' },
        [10] = { title = 'Unlawful Practice', class = 'Felony', id = 'P.C. 5012', months = 5, fine = 800, color = 'orange' },
        [11] = { title = 'Violating a Court Order', class = 'Misdemeanor', id = 'P.C. 5015', months = 0, fine = 850, color = 'orange' },
        [12] = { title = 'Failure to Appear', class = 'Misdemeanor', id = 'P.C. 5016', months = 0, fine = 500, color = 'orange' },
        [13] = { title = 'Contempt of Court', class = 'Felony', id = 'P.C. 5017', months = 7, fine = 750, color = 'orange' },
	},
	[6] = { 
        [1] = { title = 'Disobeying a Peace Officer', class = 'infraction', id = 'P.C. 6001', months = 0, fine = 500, color = 'green' },
        [2] = { title = 'Disturbing the Peace', class = 'infraction', id = 'P.C. 6003', months = 0, fine = 500, color = 'green' },
        [3] = { title = 'False Reporting', class = 'Misdemeanor', id = 'P.C. 6004', months = 5, fine = 1200, color = 'green' },
        [4] = { title = 'Harassment', class = 'Misdemeanor', id = 'P.C. 6005', months = 5, fine = 900, color = 'orange' },
        [5] = { title = 'Obstruction of Justice', class = 'Felony', id = 'P.C. 6006', months = 6, fine = 600, color = 'green' },
        [6] = { title = 'Inciting a Riot', class = 'Felony', id = 'P.C. 6007', months = 7, fine = 750, color = 'orange' },
        [7] = { title = 'Loitering on Government Properties', class = 'infraction', id = 'P.C. 6008', months = 0, fine = 350, color = 'green' },
        [8] = { title = 'Tampering', class = 'Felony', id = 'P.C. 6009', months = 7, fine = 800, color = 'green' },
        [9] = { title = 'Failure to provide Identification', class = 'Misdemeanor', id = 'P.C. 6010', months = 8, fine = 1050, color = 'green' },
        [10] = { title = 'Unlawful Assembly', class = 'Misdemeanor', id = 'P.C. 6012', months = 5, fine = 500, color = 'orange' },
        [11] = { title = 'Government Corruption', class = 'Felony', id = 'P.C. 6013', months = 5, fine = 1150, color = 'red' },
        [12] = { title = 'Stalking', class = 'Felony', id = 'P.C. 6014', months = 7, fine = 850, color = 'orange' },
        [13] = { title = 'Intense Disrespect of A Leo', class = 'Felony', id = 'P.C. 6015', months = 2, fine = 850, color = 'orange' },
	},
	[7] = { 
        [1] = { title = 'Possession of Illegal Substance', class = 'Felony', id = 'P.C. 7001', months = 8, fine = 1150, color = 'green' },
        [2] = { title = 'Possession of Illegal Substance with intent to distribute', class = 'Felony', id = 'P.C. 7005', months = 8, fine = 1150, color = 'orange' },
        [3] = { title = 'Sale of a controlled substance', class = 'Misdemeanor', id = 'P.C. 7021', months = 8, fine = 1150, color = 'green' },
        [4] = { title = 'Drug Trafficking', class = 'Felony', id = 'P.C. 7022', months = 9, fine = 1150, color = 'red' },
        [5] = { title = 'Public Intoxication', class = 'infraction', id = 'P.C. 7024', months = 3, fine = 700, color = 'green' },
        [6] = { title = 'Public Indecency', class = 'Misdemeanor', id = 'P.C. 7025', months = 5, fine = 700, color = 'green' },
	},
	[8] = { 
        [1] = { title = 'Criminal Possession of Weapon Class 1', class = 'Felony', id = 'P.C. 8001', months = 6, fine = 1150, color = 'green' },
        [2] = { title = 'Criminal Possession of weapon class 2', class = 'Felony', id = 'P.C. 8002', months = 6, fine = 1150, color = 'green' },
        [3] = { title = 'Criminal Possession of Weapon/Item Class 3', class = 'Felony', id = 'P.C. 8003', months = 12, fine = 1550, color = 'green' },
        [4] = { title = 'Criminal Sale of Illegal Weapon', class = 'Felony', id = 'P.C. 8005', months = 12, fine = 500, color = 'orange' },
        [5] = { title = 'Criminal Use of Weapon', class = 'Misdemeanor', id = 'P.C. 8009', months = 10, fine = 600, color = 'orange' },
        [6] = { title = 'Weapon Trafficking', class = 'Felony', id = 'P.C. 8011', months = 0, fine = 0, color = 'red' },
        [7] = { title = 'Brandishing', class = 'Misdemeanor', id = 'P.C. 8012', months = 5, fine = 100, color = 'orange' },
        [8] = { title = 'Jaywalking', class = 'infraction', id = 'P.C. 8015', months = 0, fine = 100, color = 'green' },
	},
	[9] = {
        [1] = { title = 'Driving While Intoxicated', class = 'Misdemeanor', id = 'P.C. 9001', months = 7, fine = 800, color = 'green' },
        [2] = { title = ' Fleeing and Evading', class = 'Misdemeanor', id = 'P.C. 9002', months = 5, fine = 850, color = 'green' },
        [3] = { title = 'Reckless Evading', class = 'Felony', id = 'P.C. 9003', months = 6, fine = 750, color = 'orange' },
        [4] = { title = 'Failure to Yield to Emergency Vehicle', class = 'infraction', id = 'P.C. 9004', months = 0, fine = 900, color = 'green' },
        [5] = { title = 'Failure to Obey Traffic Control Device', class = 'infraction', id = 'P.C. 9005', months = 0, fine = 700, color = 'green' },
        [6] = { title = 'Reckless Driving', class = 'Felony', id = 'P.C. 9008', months = 7, fine = 650, color = 'orange' },
        [7] = { title = 'Illegal U-Turn', class = 'infraction', id = 'P.C. 9013', months = 0, fine = 350, color = 'green' },
        [8] = { title = 'Illegal Passing', class = 'infraction', id = 'P.C. 9014', months = 0, fine = 300, color = 'green' },
        [9] = { title = 'Failure to Maintain Lane', class = 'infraction', id = 'P.C. 9015', months = 0, fine = 300, color = 'green' },
        [10] = { title = 'Illegal Turn', class = 'infraction', id = 'P.C. 9016', months = 0, fine = 300, color = 'green' },
        [11] = { title = 'Failure to Stop', class = 'infraction', id = 'P.C. 9017', months = 0, fine = 400, color = 'green' },
        [12] = { title = 'Unauthorized Parking', class = 'infraction', id = 'P.C. 9018', months = 0, fine = 200, color = 'green' },
        [13] = { title = 'Hit and Run', class = 'Misdemeanor', id = 'P.C. 9019', months = 7, fine = 750, color = 'green' },
        [14] = { title = 'Driving without Headlights or Signals', class = 'infraction', id = 'P.C. 9020', months = 0, fine = 400, color = 'green' },
        [15] = { title = 'Street Racing', class = 'Misdemeanor', id = 'P.C. 9021', months = 11, fine = 1450, color = 'green' },
        [16] = { title = 'Piloting without Proper Licensing', class = 'Felony', id = 'P.C. 9022', months = 11, fine = 1350, color = 'orange' },
        [17] = { title = 'No Plate Displayed', class = 'Infraction', id = 'P.C. 9023', months = 0, fine = 750, color = 'red' },
        [18] = { title = 'Noise Pollution', class = 'Infraction', id = 'P.C. 9024', months = 7, fine = 750, color = 'red' },
        [19] = { title = 'Illegal Use of Hydraulics', class = 'Infraction', id = 'P.C. 9025', months = 7, fine = 750, color = 'orange' },
        [20] = { title = 'Road Rage', class = 'Infraction', id = 'P.C. 9026', months = 7, fine = 750, color = 'red' },
        [21] = {title = 'Speeding(0-10 over limit)', class = 'Infraction', id = 'P.C. 9027', months = 7, fine = 750, color = 'orange' },
        [22] = {title = 'Speeding(10-25 over limit)', class = 'Infraction', id = 'P.C. 9028', months = 7, fine = 750, color = 'orange' },
        [23] = {title = 'Speeding(25-50 over limit)', class = 'Infraction', id = 'P.C. 9029', months = 7, fine = 750, color = 'orange' },
        [24] = {title = 'Driving Without Licence', class = 'Infraction', id = 'P.C. 9030', months = 7, fine = 750, color = 'orange' },
	},
	[10] = {
        [1] = { title = 'Hunting in Restricted Areas', class = 'infraction', id = 'P.C. 10001', months = 5, fine = 750, color = 'green' },
        [2] = { title = 'Unlicensed Hunting', class = 'infraction', id = 'P.C. 10002', months = 5, fine = 700, color = 'green' },
        [3] = { title = 'Animal Cruelty', class = 'Misdemeanor', id = 'P.C. 10003', months = 6, fine = 500, color = 'green' },
        [4] = { title = 'Hunting with a Non-Hunting Weapon', class = 'Misdemeanor', id = 'P.C. 10004', months = 12, fine = 950, color = 'green' },
        [5] = { title = 'Hunting outside of hunting hours', class = 'Infraction', id = 'P.C. 10005', months = 0, fine = 500, color = 'green' },	
        [6] = { title = 'Poaching', class = 'Felony', id = 'P.C. 10006', months = 7, fine = 750, color = 'red' },
	}
}

Config.PoliceJobs = {
    ['police'] = true,
    ['lspd'] = false,
    ['bcso'] = false,
    ['sast'] = false,
    ['sasp'] = false,
    ['doc'] = false,
    ['sapr'] = false,
    ['pa'] = false -- yucky
}

Config.DoctorJobs = {
    ['doctor'] = true
}

Config.DojJobs = {
    ['doj'] = true,
    ['government'] = true,
}

-- Leave my hacky code alone ya goblins
Config.AllowedJobs = {}
for index, value in pairs(Config.PoliceJobs) do
    Config.AllowedJobs[index] = value
end
for index, value in pairs(Config.DoctorJobs) do
    Config.AllowedJobs[index] = value
end
for index, value in pairs(Config.DojJobs) do
    Config.AllowedJobs[index] = value
end
-- Leave my hacky code alone ya goblins

Config.LogPerms = {
	['doctor'] = {
		[7] = true,
		[8] = true,
        [9] = true,
	},
	['police'] = {
		[10] = true,
		[11] = true,
		[12] = true,
	},
}

Config.ColorNames = {
    [0] = "Metallic Black",
    [1] = "Metallic Graphite Black",
    [2] = "Metallic Black Steel",
    [3] = "Metallic Dark Silver",
    [4] = "Metallic Silver",
    [5] = "Metallic Blue Silver",
    [6] = "Metallic Steel Gray",
    [7] = "Metallic Shadow Silver",
    [8] = "Metallic Stone Silver",
    [9] = "Metallic Midnight Silver",
    [10] = "Metallic Gun Metal",
    [11] = "Metallic Anthracite Grey",
    [12] = "Matte Black",
    [13] = "Matte Gray",
    [14] = "Matte Light Grey",
    [15] = "Util Black",
    [16] = "Util Black Poly",
    [17] = "Util Dark silver",
    [18] = "Util Silver",
    [19] = "Util Gun Metal",
    [20] = "Util Shadow Silver",
    [21] = "Worn Black",
    [22] = "Worn Graphite",
    [23] = "Worn Silver Grey",
    [24] = "Worn Silver",
    [25] = "Worn Blue Silver",
    [26] = "Worn Shadow Silver",
    [27] = "Metallic Red",
    [28] = "Metallic Torino Red",
    [29] = "Metallic Formula Red",
    [30] = "Metallic Blaze Red",
    [31] = "Metallic Graceful Red",
    [32] = "Metallic Garnet Red",
    [33] = "Metallic Desert Red",
    [34] = "Metallic Cabernet Red",
    [35] = "Metallic Candy Red",
    [36] = "Metallic Sunrise Orange",
    [37] = "Metallic Classic Gold",
    [38] = "Metallic Orange",
    [39] = "Matte Red",
    [40] = "Matte Dark Red",
    [41] = "Matte Orange",
    [42] = "Matte Yellow",
    [43] = "Util Red",
    [44] = "Util Bright Red",
    [45] = "Util Garnet Red",
    [46] = "Worn Red",
    [47] = "Worn Golden Red",
    [48] = "Worn Dark Red",
    [49] = "Metallic Dark Green",
    [50] = "Metallic Racing Green",
    [51] = "Metallic Sea Green",
    [52] = "Metallic Olive Green",
    [53] = "Metallic Green",
    [54] = "Metallic Gasoline Blue Green",
    [55] = "Matte Lime Green",
    [56] = "Util Dark Green",
    [57] = "Util Green",
    [58] = "Worn Dark Green",
    [59] = "Worn Green",
    [60] = "Worn Sea Wash",
    [61] = "Metallic Midnight Blue",
    [62] = "Metallic Dark Blue",
    [63] = "Metallic Saxony Blue",
    [64] = "Metallic Blue",
    [65] = "Metallic Mariner Blue",
    [66] = "Metallic Harbor Blue",
    [67] = "Metallic Diamond Blue",
    [68] = "Metallic Surf Blue",
    [69] = "Metallic Nautical Blue",
    [70] = "Metallic Bright Blue",
    [71] = "Metallic Purple Blue",
    [72] = "Metallic Spinnaker Blue",
    [73] = "Metallic Ultra Blue",
    [74] = "Metallic Bright Blue",
    [75] = "Util Dark Blue",
    [76] = "Util Midnight Blue",
    [77] = "Util Blue",
    [78] = "Util Sea Foam Blue",
    [79] = "Uil Lightning blue",
    [80] = "Util Maui Blue Poly",
    [81] = "Util Bright Blue",
    [82] = "Matte Dark Blue",
    [83] = "Matte Blue",
    [84] = "Matte Midnight Blue",
    [85] = "Worn Dark blue",
    [86] = "Worn Blue",
    [87] = "Worn Light blue",
    [88] = "Metallic Taxi Yellow",
    [89] = "Metallic Race Yellow",
    [90] = "Metallic Bronze",
    [91] = "Metallic Yellow Bird",
    [92] = "Metallic Lime",
    [93] = "Metallic Champagne",
    [94] = "Metallic Pueblo Beige",
    [95] = "Metallic Dark Ivory",
    [96] = "Metallic Choco Brown",
    [97] = "Metallic Golden Brown",
    [98] = "Metallic Light Brown",
    [99] = "Metallic Straw Beige",
    [100] = "Metallic Moss Brown",
    [101] = "Metallic Biston Brown",
    [102] = "Metallic Beechwood",
    [103] = "Metallic Dark Beechwood",
    [104] = "Metallic Choco Orange",
    [105] = "Metallic Beach Sand",
    [106] = "Metallic Sun Bleeched Sand",
    [107] = "Metallic Cream",
    [108] = "Util Brown",
    [109] = "Util Medium Brown",
    [110] = "Util Light Brown",
    [111] = "Metallic White",
    [112] = "Metallic Frost White",
    [113] = "Worn Honey Beige",
    [114] = "Worn Brown",
    [115] = "Worn Dark Brown",
    [116] = "Worn straw beige",
    [117] = "Brushed Steel",
    [118] = "Brushed Black steel",
    [119] = "Brushed Aluminium",
    [120] = "Chrome",
    [121] = "Worn Off White",
    [122] = "Util Off White",
    [123] = "Worn Orange",
    [124] = "Worn Light Orange",
    [125] = "Metallic Securicor Green",
    [126] = "Worn Taxi Yellow",
    [127] = "police car blue",
    [128] = "Matte Green",
    [129] = "Matte Brown",
    [130] = "Worn Orange",
    [131] = "Matte White",
    [132] = "Worn White",
    [133] = "Worn Olive Army Green",
    [134] = "Pure White",
    [135] = "Hot Pink",
    [136] = "Salmon pink",
    [137] = "Metallic Vermillion Pink",
    [138] = "Orange",
    [139] = "Green",
    [140] = "Blue",
    [141] = "Mettalic Black Blue",
    [142] = "Metallic Black Purple",
    [143] = "Metallic Black Red",
    [144] = "Hunter Green",
    [145] = "Metallic Purple",
    [146] = "Metaillic V Dark Blue",
    [147] = "MODSHOP BLACK1",
    [148] = "Matte Purple",
    [149] = "Matte Dark Purple",
    [150] = "Metallic Lava Red",
    [151] = "Matte Forest Green",
    [152] = "Matte Olive Drab",
    [153] = "Matte Desert Brown",
    [154] = "Matte Desert Tan",
    [155] = "Matte Foilage Green",
    [156] = "DEFAULT ALLOY COLOR",
    [157] = "Epsilon Blue",
    [158] = "Unknown",
}

Config.ColorInformation = {
    [0] = "black",
    [1] = "black",
    [2] = "black",
    [3] = "darksilver",
    [4] = "silver",
    [5] = "bluesilver",
    [6] = "silver",
    [7] = "darksilver",
    [8] = "silver",
    [9] = "bluesilver",
    [10] = "darksilver",
    [11] = "darksilver",
    [12] = "matteblack",
    [13] = "gray",
    [14] = "lightgray",
    [15] = "black",
    [16] = "black",
    [17] = "darksilver",
    [18] = "silver",
    [19] = "utilgunmetal",
    [20] = "silver",
    [21] = "black",
    [22] = "black",
    [23] = "darksilver",
    [24] = "silver",
    [25] = "bluesilver",
    [26] = "darksilver",
    [27] = "red",
    [28] = "torinored",
    [29] = "formulared",
    [30] = "blazered",
    [31] = "gracefulred",
    [32] = "garnetred",
    [33] = "desertred",
    [34] = "cabernetred",
    [35] = "candyred",
    [36] = "orange",
    [37] = "gold",
    [38] = "orange",
    [39] = "red",
    [40] = "mattedarkred",
    [41] = "orange",
    [42] = "matteyellow",
    [43] = "red",
    [44] = "brightred",
    [45] = "garnetred",
    [46] = "red",
    [47] = "red",
    [48] = "darkred",
    [49] = "darkgreen",
    [50] = "racingreen",
    [51] = "seagreen",
    [52] = "olivegreen",
    [53] = "green",
    [54] = "gasolinebluegreen",
    [55] = "mattelimegreen",
    [56] = "darkgreen",
    [57] = "green",
    [58] = "darkgreen",
    [59] = "green",
    [60] = "seawash",
    [61] = "midnightblue",
    [62] = "darkblue",
    [63] = "saxonyblue",
    [64] = "blue",
    [65] = "blue",
    [66] = "blue",
    [67] = "diamondblue",
    [68] = "blue",
    [69] = "blue",
    [70] = "brightblue",
    [71] = "purpleblue",
    [72] = "blue",
    [73] = "ultrablue",
    [74] = "brightblue",
    [75] = "darkblue",
    [76] = "midnightblue",
    [77] = "blue",
    [78] = "blue",
    [79] = "lightningblue",
    [80] = "blue",
    [81] = "brightblue",
    [82] = "mattedarkblue",
    [83] = "matteblue",
    [84] = "matteblue",
    [85] = "darkblue",
    [86] = "blue",
    [87] = "lightningblue",
    [88] = "yellow",
    [89] = "yellow",
    [90] = "bronze",
    [91] = "yellow",
    [92] = "lime",
    [93] = "champagne",
    [94] = "beige",
    [95] = "darkivory",
    [96] = "brown",
    [97] = "brown",
    [98] = "lightbrown",
    [99] = "beige",
    [100] = "brown",
    [101] = "brown",
    [102] = "beechwood",
    [103] = "beechwood",
    [104] = "chocoorange",
    [105] = "yellow",
    [106] = "yellow",
    [107] = "cream",
    [108] = "brown",
    [109] = "brown",
    [110] = "brown",
    [111] = "white",
    [112] = "white",
    [113] = "beige",
    [114] = "brown",
    [115] = "brown",
    [116] = "beige",
    [117] = "steel",
    [118] = "blacksteel",
    [119] = "aluminium",
    [120] = "chrome",
    [121] = "wornwhite",
    [122] = "offwhite",
    [123] = "orange",
    [124] = "lightorange",
    [125] = "green",
    [126] = "yellow",
    [127] = "blue",
    [128] = "green",
    [129] = "brown",
    [130] = "orange",
    [131] = "white",
    [132] = "white",
    [133] = "darkgreen",
    [134] = "white",
    [135] = "pink",
    [136] = "pink",
    [137] = "pink",
    [138] = "orange",
    [139] = "green",
    [140] = "blue",
    [141] = "blackblue",
    [142] = "blackpurple",
    [143] = "blackred",
    [144] = "darkgreen",
    [145] = "purple",
    [146] = "darkblue",
    [147] = "black",
    [148] = "purple",
    [149] = "darkpurple",
    [150] = "red",
    [151] = "darkgreen",
    [152] = "olivedrab",
    [153] = "brown",
    [154] = "tan",
    [155] = "green",
    [156] = "silver",
    [157] = "blue",
    [158] = "black",
}

Config.ClassList = {
    [0] = "Compact",
    [1] = "Sedan",
    [2] = "SUV",
    [3] = "Coupe",
    [4] = "Muscle",
    [5] = "Sport Classic",
    [6] = "Sport",
    [7] = "Super",
    [8] = "Motorbike",
    [9] = "Off-Road",
    [10] = "Industrial",
    [11] = "Utility",
    [12] = "Van",
    [13] = "Bike",
    [14] = "Boat",
    [15] = "Helicopter",
    [16] = "Plane",
    [17] = "Service",
    [18] = "Emergency",
    [19] = "Military",
    [20] = "Commercial",
    [21] = "Train"
}

function GetJobType(job)
	if Config.PoliceJobs[job] then
		return 'police'
	elseif Config.DoctorJobs[job] then
		return 'doctor'
	elseif Config.DojJobs[job] then
		return 'doj'
	else
		return nil
	end
end

-- this is a hack, because the aj-menu in aj-policejob populates an impound location and passed it through to the event.
-- if this impound locations are changed in aj-policejob, they must also be changed here.
Config.ImpoundLocations = { 
    [1] = vector4(454.94, -1017.88, 28.42, 101.84),
    [2] = vector4(-461.36, 6039.79, 31.34, 126.38),
}