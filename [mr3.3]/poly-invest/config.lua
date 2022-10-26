Config = {}

-- Language
Config.Locale = 'en'

-- Blips
Config.BlipCoords = {
    {x=-1306.59, y=-823.69, z=17.15}
}
Config.BlipName = "Stock Exchange"
Config.BlipID = 374
Config.BlipActive = true

-- Open & close key
Config.Keys = {
    Open = "E",
    Close = "ESC"
}


-- Stock settings
-- min/max is in %
-- time is in minutes
-- limit is in $ (0 = no limit)
-- lost is in % (0 = no lost of money)

Config.Stock = {
    Minimum = -5,
    Maximum = 5,
    Time = 45,
    Limit = 150000,
    Lost = 50
}

-- Documentation:
-- Min/Max is the min/max all the stocks can go
-- Time is the time the new rates will be given
-- Limit is the maximum amount that can be invest into a company
-- Lost is the % that will be lost when a stock is at a negative %

-- Debug mode
Config.Debug = false