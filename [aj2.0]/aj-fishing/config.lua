Config = {}

Config.Debug = false
Config.JobBusy = false

Config.MarkerData = {
    ["type"] = 6,
    ["size"] = vector3(2.0, 2.0, 2.0),
    ["color"] = vector3(0, 255, 150)
}

Config.FishingRestaurant = {
    ["name"] = "Fish Restaurant",
    ["blip"] = {
        ["sprite"] = 628,
        ["color"] = 3
    },
    ["ped"] = {
        ["model"] = 0xED0CE4C6,
        ["position"] = vector3(-2193.36, 4289.83, 49.17),
        ["heading"] = 59.89
    }
}

Config.FishingItems = {
    ["rod"] = {
        ["name"] = "fishingrod",
        ["label"] = "Fishing Rod"
    },
    ["bait"] = {
        ["name"] = "fishingbait",
        ["label"] = "Fishing Bait"
    },
    ["fish"] = {
        ["price"] = 30 
    },
    ["stripedbass"] = {
        ["price"] = 50
    },
    ["bluefish"] = {
        ["price"] = 80
    },
    ["redfish"] = {
        ["price"] = 100 
    },
    ["pacifichalibut"] = {
        ["price"] = 130
    },
    ["goldfish"] = {
        ["price"] = 150
    },
    ["largemouthbass"] = {
        ["price"] = 180
    },
    ["salmon"] = {
        ["price"] = 200
    },
    ["catfish"] = {
        ["price"] = 230
    },
    ["tigersharkmeat"] = {
        ["price"] = 250
    },
    ["stingraymeat"] = {
        ["price"] = 270
    },
    ["killerwhalemeat"] = {
        ["price"] = 300
    },
}

Config.FishingZones = {
    {
        ["name"] = "Catfish View",
        ["coords"] = vector3(3870.14, 4463.57, -0.47),
        ["radius"] = 100.0,
    },
    {
        ["name"] = "Chumash Fishing",
        ["coords"] = vector3(-3428.34, 968.53, 8.35),
        ["radius"] = 50.0,
    },
    {
        ["name"] = "Chiliad Fishing",
        ["coords"] = vector3(-1612.23, 5262.75, 3.97),
        ["radius"] = 50.0,
    },
    {
        ["name"] = "Beach Fishing",
        ["coords"] = vector3(-1851.72, -1249.2, 8.62),
        ["radius"] = 50.0,
    },
    
}