Config = {}

Config.Webhook = 'https://discord.com/api/webhooks/994048785447653477/OflNuTxXJjA8gzX7o1zQbS7qcch92coWveVzuy1AWnuFzzbOKCZR6iDn_0D2G5IOLy6J' -- Images will be uploaded here
Config.TestCommand = true -- Use this when testing /testmugshot

Config.CustomMLO = true -- If you use a MLO use the options below to change the camera location. Otherwise it will use the default IPL for the mugshot location
Config.MugshotLocation = vector3(472.94, -1011.18, 25.27) -- Location of the Suspect
Config.MugshotSuspectHeading = 183.84 -- Direction Suspsect is facing
Config.MugShotCamera = {
    x = 473.0060,
    y = -1012.57,
    z = 26.91628,
    r = {x = 0.0, y = 0.0, z = 0.0} -- To change the rotation use the z. Others are if you want rotation on other axis
}

Config.BoardHeader = "Los Santos Police Department" -- Header that appears on the board
Config.WaitTime = 2000 -- Time before and after the photo is taken. Decreasing this value might result in some angles being skiped.
Config.Photos = 1 -- Front, Back Side. Use 4 for both sides
Config.CQCMDT = false -- If you use CQC MDT this will automatically send them to a players profile