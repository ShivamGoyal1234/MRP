MRShared = MRShared or {}
MRShared.ForceJobDefaultDutyAtLogin = false -- true: Force duty state to jobdefaultDuty | false: set duty state from database last saved
MRShared.Jobs = {
	['unemployed'] = {
		label = 'Civilian',
		defaultDuty = true,
		grades = {
            ['0'] = {
                name = 'Freelancer',
                payment = 40
            },
        },
	},

	['merryweather'] = {
		label = 'Merry Weather',
		defaultDuty = true,
		grades = {
            ['0'] = {
                name = 'Intern',
                payment = 200
            },
			['1'] = {
                name = 'Employee',
                payment = 400
            },
			['2'] = {
                name = 'Manager',
                payment = 600
            },
			['3'] = {
                name = 'CEO',
                payment = 800
            },
			['4'] = {
                name = 'Owner',
                payment = 1000
            },
        },
	},

	['police'] = {
		label = 'Law Enforcement',
		defaultDuty = true,
		grades = {
            ['0'] = {
                name = "Recruit",
                payment = 300
            },
            ['1'] = {
                name = "Cadet",
                payment = 400
            },
            ['2'] = {
                name = "Trooper",
                payment = 500
            },
			['3'] = {
                name = "Trooper First Class",
                payment = 550
            },
            ['4'] = {
                name = "Senior Trooper",
                payment = 600
            },
            ['5'] = {
                name = "Corporal",
                payment = 700
            },
            ['6'] = {
                name = "Sergeant",
                payment = 800
            },
            ['7'] = {
                name = "Lieutenant",
                payment = 900
            },
            ['8'] = {
                name = "Captain",
                payment = 1000
            },
            ['9'] = {
                name = "Assistant Commissioner",
                payment = 1150
            },
            ['10'] = {
                name = "Deputy Commissioner",
                payment = 1250
            },
            ['11'] = {
                name = "Commissioner",
				isboss = true,
                payment = 1350
            },
            ['12'] = {
                name = "Chief",
				isboss = true,
                payment = 1450
            },
        },
	},

	['bcso'] = {
		label = 'Law Enforcement BCSO',
		defaultDuty = true,
		grades = {
            ['0'] = {
                name = "Recruit",
                payment = 300
            },
        },
	},

	['sast'] = {
		label = 'Law Enforcement SAST',
		defaultDuty = true,
		grades = {
            ['0'] = {
                name = "Recruit",
                payment = 300
            },
        },
	},


	['doctor'] = {
		label = 'EMS',
		defaultDuty = true,
		grades = {
            ['0'] = {
                name = "Trainee",
                payment = 400
            },
            ['1'] = {
                name = "EMT",
                payment = 500
            },
            ['2'] = {
                name = "EMT ADVANCE",
                payment = 600
            },
            ['3'] = {
                name = "PARAMEDIC",
                payment = 700
            },
            ['4'] = {
                name = "SERGEANT",
                payment = 800
            },
            ['5'] = {
                name = "Specialist Doctor",
                payment = 900
            },
            ['6'] = {
                name = "Lieutenant",
                payment = 1000
            },
            ['7'] = {
                name = "Captain",
                payment = 1100
            },
            ['8'] = {
                name = "Deputy EMS Chief",
                payment = 1200
            },
            ['9'] = {
                name = "EMS Chief",
				isboss = true,
                payment = 1700
			},
        },
	},

	["government"] = {
		label = "Government",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "State Security",
				payment = 600
			},
			['1'] = {
				name = "Employee",
				payment = 800
			},
			['2'] = {
				name = "State Accountant",
				payment = 1000
			},
			['3'] = {
				name = "State Treasure",
				payment = 1000
			},
			['4'] = {
				name = "Security Chief",
				payment = 1200
			},
			['5'] = {
				name = "Secretery",
				payment = 1000
			},
			['6'] = {
				name = "Mayor",
				payment = 2000
			},
			['7'] = {
				name = "Governor",
				isboss = true,
				payment = 50
			},
		},
	},

	["realestate"] = {
		label = "Realestate",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Company Owner",
				payment = 300
			},
			['1'] = {
				name = "Builder",
				payment = 600
			},
			['2'] = {
                name = 'Manager',
				isboss = true,
                payment = 150
            },
		}
	},


	--PDM 

	["pdm"] = {
		label = "PDM",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Salesman",
				payment = 200
			},
			['1'] = {
				name = "Senior Salesman",
				payment = 400
			},
			['2'] = {
				name = "Executive",
				payment = 600
			},
			['3'] = {
				name = "Manager",
				payment = 800
			},
			['4'] = {
				name = "CEO",
				payment = 900
			},
			['5'] = {
				name = "Owner",
				isboss = true,
				payment = 1000
			},
		},
	},


	--EDM 

	["edm"] = {
		label = "EDM",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Salesman",
				payment = 200
			},
			['1'] = {
				name = "Senior Salesman",
				payment = 400
			},
			['2'] = {
				name = "Executive",
				payment = 600
			},
			['3'] = {
				name = "Manager",
				payment = 800
			},
			['4'] = {
				name = "CEO",
				payment = 1000
			},
			['5'] = {
				name = "Owner",
				isboss = true,
				payment = 50
			},
		},
	},

	["tunner"] = {
		label = "Tunner",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Mechanic",
				payment = 200
			},
			['1'] = {
				name = "Salesman",
				payment = 400
			},
			['2'] = {
				name = "Experienced",
				payment = 600
			},
			['3'] = {
				name = "Manager",
				payment = 800
			},
			['4'] = {
				name = "CEO",
				payment = 1000
			},
			['5'] = {
				name = "Owner",
				isboss = true,
				payment = 50
			},
		},
	},

	['uwu'] = {
		label = 'Cat Cafe - uWu',
		defaultDuty = true,
		grades = {
            ['0'] = { name = 'Recruit Chef', payment = 350 },
			['1'] = { name = 'Expert Chef', payment = 550 },
			['2'] = { name = 'Master Chef', payment = 750 },
			['3'] = { name = 'Manager', payment = 950 },
			['4'] = { name = 'Owner', isboss = true, payment = 1000 },
        },
	},

	['mechanic'] = {
		label = 'Mechanic',
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Trainee",
				payment = 250
			},
            ['1'] = {
				name = "Recuit",
				payment = 300
			},
			['2'] = {
				name = "Veteran",
				payment = 400
			},
			['3'] = {
				name = "Expert",
				payment = 600
			},
			['4'] = {
				name = "MANAGER",
				payment = 800
			},
			['5'] = {
				name = "Boss",
				isboss = true,
				payment = 1500
			},
        },
	},

	['bennys'] = {
		label = 'Bennys',
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Trainee",
				payment = 250
			},
            ['1'] = {
				name = "Recuit",
				payment = 300
			},
			['2'] = {
				name = "Veteran",
				payment = 400
			},
			['3'] = {
				name = "Expert",
				payment = 600
			},
			['4'] = {
				name = "MANAGER",
				payment = 800
			},
			['5'] = {
				name = "Boss",
				isboss = true,
				payment = 1500
			},
        },
	},

	-- ['tunnermechanic'] = {
	-- 	label = 'Tunner Mechanic',
	-- 	defaultDuty = true,
	-- 	grades = {
    --         ['0'] = {
	-- 			name = "Recuit",
	-- 			payment = 300
	-- 		},
	-- 		['1'] = {
	-- 			name = "Veteran",
	-- 			payment = 400
	-- 		},
	-- 		['2'] = {
	-- 			name = "Expert",
	-- 			payment = 600
	-- 		},
	-- 		['3'] = {
	-- 			name = "MANAGER",
	-- 			payment = 800
	-- 		},
	-- 		['4'] = {
	-- 			name = "CEO",
	-- 			payment = 900
	-- 		},
	-- 		['5'] = {
	-- 			name = "Boss",
	-- 			payment = 1000
	-- 		},
    --     },
	-- },

	["doj"] = {
		label = "DOJ",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Attorney",
				payment = 600
			},
			['1'] = {
				name = "State Attorney",
				payment = 800
			},
			['2'] = {
				name = "Attorney General",
				payment = 1000
			},
			['3'] = {
				name = "Judge",
				payment = 1200
			},
			['4'] = {
				name = "Chief Justice",
				isboss = true,
				payment = 1000
			},
		}
	},

	['reporter'] = {
		label = 'Weazel News',
		defaultDuty = true,
		grades = {
            ['0'] = {
				name = "RJ",
				payment = 400
			},
			['1'] = {
				name = "Reporter",
				payment = 600
			},
			['2'] = {
				name = "Senior Reporter",
				payment = 800
			},
			['3'] = {
				name = "Editor",
				payment = 1000
			},
			['4'] = {
				name = "CEO",
				payment = 1250
			},
			['5'] = {
				name = "Owner",
				isboss = true,
				payment = 1000
			},
        },
	},

	--Business 	

	-- Bahamas
	["bahamas"] = {
		label = "Bahamas",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Employee",
				payment = 250
			},
			['1'] = {
				name = "CEO",
				payment = 450
			},
			['2'] = {
				name = "Owner",
				isboss = true,
				payment = 700
			},
		},
	},

	
	-- Comedy Club
	["comclub"] = {
		label = "Comedy Club",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Employee",
				payment = 250
			},
			['1'] = {
				name = "CEO",
				payment = 450
			},
			['2'] = {
				name = "Owner",
				isboss = true,
				payment = 700
			},
		},
	},


	-- Cinema
	-- ["Cinema"] = {
	-- 	label = "Cinema",
	-- 	defaultDuty = true,
	-- 	grades = {
	-- 		['0'] = {
	-- 			name = "Employee",
	-- 			payment = 250
	-- 		},
	-- 		['1'] = {
	-- 			name = "CEO",
	-- 			payment = 450
	-- 		},
	-- 		['2'] = {
	-- 			name = "Owner",
	-- 			isboss = true,
	-- 			payment = 700
	-- 		},
	-- 	},
	-- },


	-- MCD
	["mcd"] = {
		label = "MCD",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Employee",
				payment = 250
			},
			['1'] = {
				name = "CEO",
				payment = 450
			},
			['2'] = {
				name = "Owner",
				isboss = true,
				payment = 700
			},
		},
	},

	['beanmachine'] = {
		label = 'Bean Machine',
		defaultDuty = true,
		grades = {
            ['0'] = { name = 'Recruit', payment = 50 },
			['1'] = { name = 'Novice', payment = 75 },
			['2'] = { name = 'Experienced', payment = 100 },
			['3'] = { name = 'Advanced', payment = 125 },
			['4'] = { name = 'Manager', isboss = true, payment = 150 },
        },
	},


	-- Recycle
	["recycle"] = {
		label = "Recycle",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Employee",
				payment = 250
			},
			['1'] = {
				name = "CEO",
				payment = 450
			},
			['2'] = {
				name = "Owner",
				isboss = true,
				payment = 700
			},
		},
	},


	-- Dhaba
	["dhaba"] = {
		label = "Dhaba",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "रामू काका",
				payment = 150
			},
			['1'] = {
				name = "करिया कर्ता",
				payment = 300
			},
			['2'] = {
				name = "बावर जी",
				payment = 300
			},
			['3'] = {
				name = "मुंशी जी",
				payment = 500
			},
			['4'] = {
				name = "मलिक",
				isboss = true,
				payment = 700
			},
		},
	},

	-- Taquilla
	["taq"] = {
		label = "Taquilla",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Employee",
				payment = 250
			},
			['1'] = {
				name = "CEO",
				payment = 450
			},
			['2'] = {
				name = "Owner",
				isboss = true,
				payment = 700
			},
		},
	},

	--- Shop One
	["shopone"] = {
		label = "Shop One",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Employee",
				payment = 250
			},
			['1'] = {
				name = "CEO",
				payment = 500
			},
			['2'] = {
				name = "Owner",
				isboss = true,
				payment = 1000
			},
		},
	},

	["littleteapot"] = {
		label = "The Little Teapot",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Employee",
				payment = 250
			},
			['1'] = {
				name = "Manager",
				payment = 500
			},
			['2'] = {
				name = "Owner",
				isboss = true,
				payment = 1000
			},
		},
	},

	["casino"] = {
		label = "Casino",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Staff",
				payment = 250
			},
			['1'] = {
				name = "Manager",
				payment = 500
			},
			['2'] = {
				name = "Ceo",
				payment = 750
			},
			['3'] = {
				name = "Owner",
				isboss = true,
				payment = 1000
			},
		},
	},

	["banker"] = {
		label = "Banker",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Staff",
				payment = 200
			},
			['1'] = {
				name = "Manager",
				payment = 400
			},
			['2'] = {
				name = "Ceo",
				payment = 600
			},
			['3'] = {
				name = "Owner",
				isboss = true,
				payment = 800
			},
		},
	},

	--BL JOBS

	['taxi'] = {
		label = 'Taxi',
		defaultDuty = true,
		grades = {
            ['0'] = {
                name = 'Recruit',
                payment = 50
            },
			['1'] = {
                name = 'Driver',
                payment = 75
            },
			['2'] = {
                name = 'Event Driver',
                payment = 100
            },
			['3'] = {
                name = 'Sales',
                payment = 125
            },
			['4'] = {
                name = 'Manager',
				isboss = true,
                payment = 150
            },
        },
	},

	["trucker"] = {
		label = "Amazon Delivery Job",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Driver",
				payment = 100
			},
		},
	},

	["tow"] = {
		label = "Tow",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Tow Worker",
				payment = 200
			},
		},
	},

	["postal"] = {
		label = "Postal OP",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Delivery",
				payment = 150
			},
		},
	},


	["garbage"] = {
		label = "Garbage Man",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Garbage Man",
				payment = 80
			},
		},
	},

	["hotdog"] = {
		label = "Hotdog",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Vendor",
				payment = 80
			},
		},
	},

	["financer"] = {
		label = "Financer",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Employee",
				payment = 250
			},
		},
	},

	["bigboss"] = {
		label = "Overwatch",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Employee",
				payment = 1000
			},
		},
	},

	["contractor"] = {
		label = "Contractor",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Boss",
				payment = 250
			},
		},
	},

	["ammunation"] = {
		label = "M.W.",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Gun Man",
				payment = 200
			},
			['1'] = {
				name = "Task Executer",
				payment = 400
			},
			['2'] = {
				name = "Red Eye",
				payment = 600
			},
			['3'] = {
				name = "Manager",
				isboss = true,
				payment = 800
			},
		},
	},
}