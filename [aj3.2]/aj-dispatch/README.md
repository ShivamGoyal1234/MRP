# aj-dispatch

WIP for cleaner and more easier to setup Dispatch compatible with QB-mdt

# Installation
* Download ZIP
* Drag and drop resource into your server files
* Start resource through server.cfg
* Drag and drop sounds folder into interact-sound\client\html\sounds
* Restart your server.


# Alert Exports
```lua
- exports['aj-dispatch']:VehicleShooting(vehicle)

- exports['aj-dispatch']:Shooting()

- exports['aj-dispatch']:SpeedingVehicle(vehicle)

- exports['aj-dispatch']:Fight()

- exports['aj-dispatch']:InjuriedPerson()

- exports['aj-dispatch']:StoreRobbery()

- exports['aj-dispatch']:FleecaBankRobbery()

- exports['aj-dispatch']:PaletoBankRobbery()

- exports['aj-dispatch']:PacificBankRobbery()

- exports['aj-dispatch']:PrisonBreak()

- exports['aj-dispatch']:VangelicoRobbery()

- exports['aj-dispatch']:HouseRobbery()

- exports['aj-dispatch']:PrisonBreak()

- exports['aj-dispatch']:DrugSale()

- exports['aj-dispatch']:ArtGalleryRobbery()

- exports['aj-dispatch']:HumaneRobery(

- exports['aj-dispatch']:TrainRobbery()

- exports['aj-dispatch']:VanRobbery()

- exports['aj-dispatch']:UndergroundRobbery()

- exports['aj-dispatch']:DrugBoatRobbery()

- exports['aj-dispatch']:UnionRobbery()

- exports['aj-dispatch']:CarBoosting()
```

# Steps to Create New Alert

1. Create a client event that will be triggered from whatever script you want

```lua
local function FleecaBankRobbery()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "bankrobbery", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-90",
        firstStreet = locationInfo,
        gender = gender,
        model = nil,
        plate = nil,
        priority = 2, -- priority
        firstColor = nil,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = "Fleeca Bank Robbery", -- message
        job = {"police"} -- jobs that will get the alerts
    })
end exports('FleecaBankRobbery', FleecaBankRobbery)
```

2. Add Dispatch Code in sv_dispatchcodes.lua for the particular robbery to display the blip

`["storerobbery"] is the dispatchcodename you passed with the TriggerServerEvent in step 1`
```lua
	["bankrobbery"] =  {displayCode = '10-90', description = "Fleeca Bank Robbery In Progress", radius = 0, recipientList = {'police'}, blipSprite = 500, blipColour = 2, blipScale = 1.5, blipLength = 2, sound = "robberysound"},
```

Information about each parameter is in the file.


# Work to be done

* Hunting Zones
* Locales for alerts
* Add onduty check for alerts
* Vehicle Theft Alert
