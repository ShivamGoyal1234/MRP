
--[[
	["vehicleshots"] -> dispatchcodename that you pass with the event of AlertGunShot
	displayCode -> Code to be displayed on the blip message
	description -> Description of the blip message
	radius -> to draw a circle with radius around blip
	recipientList -> list of job names that can see the blip
	blipSprite -> blip sprite
	blipColour -> blip colour
	blipScale -> blip scale
	blipLength -> time in seconds at which the blip will fade down, lower the time, faster it will fade. Cannot be 0
]]--

dispatchCodes = {

    ["vehicleshots"] =  {displayCode = '10-13', description = "Shots Fired from Vehicle", radius = 0, recipientList = {'police'}, blipSprite = 119, blipColour = 1, blipScale = 1.0, blipLength = 1, sound = "Lose_1st", sound2 = "GTAO_FM_Events_Soundset"},
	["shooting"] =  {displayCode = '10-13', description ="Shots Fired", radius = 0, recipientList = {'police'}, blipSprite = 110, blipColour = 1, blipScale = 1.0, blipLength = 1, sound = "Lose_1st", sound2 = "GTAO_FM_Events_Soundset"},
	-- ["shooting2"] =  {displayCode = '10-13', description ="Friendly Shots Fired", radius = 0, recipientList = {'police'}, blipSprite = 110, blipColour = 1, blipScale = 1.0, blipLength = 1, sound = "Lose_1st", sound2 = "GTAO_FM_Events_Soundset"},
	["speeding"] =  {displayCode = '10-56', description = "Speeding", radius = 0, recipientList = {'police'}, blipSprite = 326, blipColour = 84, blipScale = 1.0, blipLength = 1, sound = "Lose_1st", sound2 = "GTAO_FM_Events_Soundset"},
    ["fight"] =  {displayCode = '10-10', description = "Fight In Progress", radius = 0, recipientList = {'police'}, blipSprite = 685, blipColour = 69, blipScale = 1.0, blipLength = 1, sound = "Lose_1st", sound2 = "GTAO_FM_Events_Soundset"},
	["civdown"] =  {displayCode = '10-69', description = "Civilan Down", radius = 0, recipientList = {'doctor'}, blipSprite = 126, blipColour = 3, blipScale = 1.0, blipLength = 1, sound = "dispatch"},
	["911call"] =  {displayCode = '911', description = "911 Call", radius = 0, recipientList = {'police', 'doctor'}, blipSprite = 480, blipColour = 1, blipScale = 1.0, blipLength = 1, sound = "Lose_1st", sound2 = "GTAO_FM_Events_Soundset"},
	["311call"] =  {displayCode = '911', description = "311 Call", radius = 0, recipientList = {'police', 'doctor'}, blipSprite = 480, blipColour = 3, blipScale = 1.0, blipLength = 1, sound = "Lose_1st", sound2 = "GTAO_FM_Events_Soundset"},
	["officerdown"] =  {displayCode = '10-99', description = "Officer Down", radius = 15, recipientList = {'police'}, blipSprite = 526, blipColour = 29, blipScale = 1.0, blipLength = 1.5, sound = "panicbutton"},
	["emsdown"] =  {displayCode = '10-99', description = "EMS Down", radius = 15, recipientList = {'police', 'doctor'}, blipSprite = 526, blipColour = 1, blipScale = 1.0, blipLength = 1.5, sound = "panicbutton"},
    ["storerobbery"] =  {displayCode = '10-90C', description = "Store Robbery In Progress", radius = 0, recipientList = {'police'}, blipSprite = 52, blipColour = 1, blipScale = 1.0, blipLength = 1, sound = "Lose_1st", sound2 = "GTAO_FM_Events_Soundset"},
	["bankrobbery"] =  {displayCode = '10-90A', description = "Fleeca Bank Robbery In Progress", radius = 0, recipientList = {'police'}, blipSprite = 487, blipColour = 1, blipScale = 1.5, blipLength = 1, sound = "robberysound"},
	["paletobankrobbery"] =  {displayCode = '10-90A', description = "Paleto Bank Robbery In Progress", radius = 0, recipientList = {'police'}, blipSprite = 487, blipColour = 12, blipScale = 1.5, blipLength = 1, sound = "robberysound"},
	["pacificbankrobbery"] =  {displayCode = '10-90A', description = "Pacific Bank Robbery In Progress", radius = 0, recipientList = {'police'}, blipSprite = 487, blipColour = 5, blipScale = 1.5, blipLength = 1, sound = "robberysound"},
	["prisonbreak"] =  {displayCode = '10-90', description = "Prison Break In Progress", radius = 0, recipientList = {'police'}, blipSprite = 189, blipColour = 59, blipScale = 1.0, blipLength = 1, sound = "robberysound"},
	["vangelicorobbery"] =  {displayCode = '10-90B', description = "Vangelico Robbery In Progress", radius = 0, recipientList = {'police'}, blipSprite = 434, blipColour = 5, blipScale = 1.0, blipLength = 1, sound = "robberysound"},
	["houserobbery"] =  {displayCode = '10-90D', description = "House Robbery In Progress", radius = 0, recipientList = {'police'}, blipSprite = 40, blipColour = 5, blipScale = 1.0, blipLength = 1, sound = "Lose_1st", sound2 = "GTAO_FM_Events_Soundset"},
	["suspicioushandoff"] =  {displayCode = '10-60', description = "Suspicious Hand off", radius = 0, recipientList = {'police'}, blipSprite = 469, blipColour = 52, blipScale = 1.0, blipLength = 1, sound = "Lose_1st", sound2 = "GTAO_FM_Events_Soundset"},
	-- ["cargoshipment"] =  {displayCode = '911', description = "Suspicious Shipment", radius = 100, recipientList = {'police'}, blipSprite = 0, blipColour = 5, blipScale = 1.0, blipLength = 1, sound = "Lose_1st", sound2 = "GTAO_FM_Events_Soundset"},
	["vehicletheft"] =  {displayCode = '10-60', description = "Vehicle Theft", radius = 0, recipientList = {'police'}, blipSprite = 326, blipColour = 1, blipScale = 0.8, blipLength = 0.5, sound = "Lose_1st", sound2 = "GTAO_FM_Events_Soundset"},
	-- Rainmad Heists
	["artgalleryrobbery"] =  {displayCode = '10-90', description = "Art Gallery Robbery In Progress", radius = 0, recipientList = {'police'}, blipSprite = 169, blipColour = 59, blipScale = 1.0, blipLength = 1, sound = "robberysound"},
	["humanelabsrobbery"] =  {displayCode = '10-90', description = "Humane Labs Robbery In Progress", radius = 0, recipientList = {'police'}, blipSprite = 499, blipColour = 1, blipScale = 1.0, blipLength = 1, sound = "robberysound"},
	["trainrobbery"] =  {displayCode = '10-90', description = "Train Robbery In Progress", radius = 0, recipientList = {'police'}, blipSprite = 667, blipColour = 78, blipScale = 1.0, blipLength = 1, sound = "robberysound"},
	["vanrobbery"] =  {displayCode = '10-90', description = "Security Van Robbery In Progress", radius = 0, recipientList = {'police'}, blipSprite = 67, blipColour = 59, blipScale = 1.0, blipLength = 1, sound = "robberysound"},
	["undergroundrobbery"] =  {displayCode = '10-90', description = "Underground Tunnels Robbery In Progress", radius = 0, recipientList = {'police'}, blipSprite = 486, blipColour = 59, blipScale = 1.0, blipLength = 1, sound = "robberysound"},
	["drugboatrobbery"] =  {displayCode = '10-31', description = "Suspicious Activity On Boat", radius = 0, recipientList = {'police'}, blipSprite = 427, blipColour = 16, blipScale = 1.0, blipLength = 1, sound = "robberysound"},
	["unionrobbery"] =  {displayCode = '10-90', description = "Union Depository Robbery In Progress", radius = 0, recipientList = {'police'}, blipSprite = 500, blipColour = 60, blipScale = 1.0, blipLength = 1, sound = "robberysound"},
	["carboosting"] =  {displayCode = '10-60', description = "Car Boosting In Progress", radius = 0, recipientList = {'police'}, blipSprite = 595, blipColour = 60, blipScale = 1.0, blipLength = 1, sound = "Lose_1st", sound2 = "GTAO_FM_Events_Soundset"},
}
