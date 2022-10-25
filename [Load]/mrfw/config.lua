MRConfig = {}

MRConfig.MaxPlayers = GetConvarInt('sv_maxclients', 48) -- Gets max players from config file, default 32
MRConfig.DefaultSpawn = vector4(-1035.71, -2731.87, 12.86, 0.0)
MRConfig.UpdateInterval = 5 -- how often to update player data in minutes
MRConfig.StatusInterval = 5000 -- how often to check hunger/thirst status in ms

MRConfig.Perms = {
    'dev',
    'owner',
    'manager',
    'h-admin',
    'admin',
    'c-admin',
    's-mod',
    'mod',
}

MRConfig.Commands = {
    ['giveitem'] = 'manager', -- mod, s-mod, c-admin, admin, h-admin, manager, owner, dev
    ['givemoney'] = 'manager'
}

MRConfig.Money = {}
MRConfig.Money.MoneyTypes = { ['cash'] = 1000, ['bank'] = 5000, ['crypto'] = 0 } -- ['type']=startamount - Add or remove money types for your server (for ex. ['blackmoney']=0), remember once added it will not be removed from the database!
MRConfig.Money.DontAllowMinus = { 'cash', 'crypto' } -- Money that is not allowed going in minus
MRConfig.Money.PayCheckTimeOut = 0.5 -- The time in minutes that it will give the paycheck
MRConfig.Money.OnlyPayWhenDuty = true
MRConfig.Money.Percent = 30 -- value will be in %

MRConfig.Player = {}
MRConfig.Player.MaxWeight = 300000 -- Max weight a player can carry (currently 120kg, written in grams)
MRConfig.Player.MaxInvSlots = 41 -- Max inventory slots for a player
MRConfig.Player.HungerRate = 1.8 -- Rate at which hunger goes down.
MRConfig.Player.ThirstRate = 1.8 -- Rate at which thirst goes down.
MRConfig.Player.Bloodtypes = {
    "A+",
    "A-",
    "B+",
    "B-",
    "AB+",
    "AB-",
    "O+",
    "O-",
}

MRConfig.Server = {} -- General server config
MRConfig.Server.closed = false -- Set server closed (no one can join except people with ace permission 'ajadmin.join')
MRConfig.Server.closedReason = "Server Closed For Testing" -- Reason message to display when people can't join the server
MRConfig.Server.uptime = 0 -- Time the server has been up.
MRConfig.Server.whitelist = false -- Enable or disable whitelist on the server
MRConfig.Server.discord = "https://discord.gg/j3NvcCQB3p" -- Discord invite link
MRConfig.Server.PermissionList = {} -- permission list

MRConfig.Notify = {}

MRConfig.Notify.NotificationStyling = {
    group = false, -- Allow notifications to stack with a badge instead of repeating
    position = "left", -- top-left | top-right | bottom-left | bottom-right | top | bottom | left | right | center
    progress = false -- Display Progress Bar
}

-- These are how you define different notification variants
-- The "color" key is background of the notification
-- The "icon" key is the css-icon code, this project uses `Material Icons` & `Font Awesome`
MRConfig.Notify.VariantDefinitions = {
    success = {
        classes = 'success',
        icon = 'done'
    },
    primary = {
        classes = 'primary',
        icon = 'info'
    },
    error = {
        classes = 'error',
        icon = 'dangerous'
    },
    police = {
        classes = 'police',
        icon = 'local_police'
    },
    ambulance = {
        classes = 'ambulance',
        icon = 'fas fa-ambulance'
    },
    uwu = {
        classes = 'uwu',
        icon = 'fas fa-cat',
        position = 'bottom'
    },
}
