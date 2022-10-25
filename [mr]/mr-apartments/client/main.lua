local MRFW = exports['mrfw']:GetCoreObject()
local InApartment = false
local ClosestHouse = nil
local CurrentApartment = nil
local IsOwned = false
local CurrentDoorBell = 0
local CurrentOffset = 0
local houseObj = {}
local POIOffsets = nil
local rangDoorbell = nil

-- Handlers

RegisterNetEvent('MRFW:Client:OnPlayerUnload', function()
    CurrentApartment = nil
    InApartment = false
    CurrentOffset = 0
    exports['mr-eye']:RemoveZone("apartments")
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if houseObj ~= nil then
            exports['mr-interior']:DespawnInterior(houseObj, function()
                CurrentApartment = nil
                TriggerEvent('mr-weathersync:client:EnableSync')
                DoScreenFadeIn(500)
                while not IsScreenFadedOut() do
                    Wait(10)
                end
                SetEntityCoords(PlayerPedId(), Apartments.Locations[ClosestHouse].coords.enter.x, Apartments.Locations[ClosestHouse].coords.enter.y,Apartments.Locations[ClosestHouse].coords.enter.z)
                SetEntityHeading(PlayerPedId(), Apartments.Locations[ClosestHouse].coords.enter.w)
                Wait(1000)
                InApartment = false
                DoScreenFadeIn(1000)
            end)
        end
    end
end)

-- Functions

local function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

local function openHouseAnim()
    loadAnimDict("anim@heists@keycard@") 
    TaskPlayAnim( PlayerPedId(), "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0 )
    Wait(400)
    ClearPedTasks(PlayerPedId())
end

local function EnterApartment(house, apartmentId, new, guest, bucket)
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.1)
    openHouseAnim()
    if guest then
        TriggerServerEvent('mr-apartments:EnterBucketguest', bucket)
    else
        TriggerServerEvent('mr-apartments:EnterBucket')
    end
    Wait(250)
    MRFW.Functions.TriggerCallback('apartments:GetApartmentOffset', function(offset)
        if offset == nil or offset == 0 then
            MRFW.Functions.TriggerCallback('apartments:GetApartmentOffsetNewOffset', function(newoffset)
                if newoffset > 230 then
                    newoffset = 210
                end
                CurrentOffset = newoffset
                TriggerServerEvent("apartments:server:AddObject", apartmentId, house, CurrentOffset)
                local coords = { x = Apartments.Locations[house].coords.enter.x, y = Apartments.Locations[house].coords.enter.y, z = Apartments.Locations[house].coords.enter.z - CurrentOffset}
                data = exports['mr-interior']:CreateApartmentFurnished(coords)
                Wait(100)
                houseObj = data[1]
                POIOffsets = data[2]
                InApartment = true
                CurrentApartment = apartmentId
                ClosestHouse = house
                rangDoorbell = nil
                Wait(500)
                TriggerEvent('mr-weathersync:client:DisableSync', 18, 0, 0)
                Wait(100)
                TriggerServerEvent('mr-apartments:server:SetInsideMeta', house, apartmentId, true)
                TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_close", 0.1)
                TriggerServerEvent("MRFW:Server:SetMetaData", "currentapartment", CurrentApartment)
            end, house)
        else
            if offset > 230 then
                offset = 210
            end
            CurrentOffset = offset
            TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.1)
            TriggerServerEvent("apartments:server:AddObject", apartmentId, house, CurrentOffset)
            local coords = { x = Apartments.Locations[ClosestHouse].coords.enter.x, y = Apartments.Locations[ClosestHouse].coords.enter.y, z = Apartments.Locations[ClosestHouse].coords.enter.z - CurrentOffset}
            data = exports['mr-interior']:CreateApartmentFurnished(coords)
            Wait(100)
            houseObj = data[1]
            POIOffsets = data[2]
            InApartment = true
            CurrentApartment = apartmentId
            Wait(500)
            TriggerEvent('mr-weathersync:client:DisableSync' , 18, 0, 0)
            Wait(100)
            TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_close", 0.1)
            TriggerServerEvent("MRFW:Server:SetMetaData", "currentapartment", CurrentApartment)
        end
        if new ~= nil then
            if new then
                TriggerEvent('mr-interior:client:SetNewState', true)
            else
                TriggerEvent('mr-interior:client:SetNewState', false)
            end
        else
            TriggerEvent('mr-interior:client:SetNewState', false)
        end
    end, apartmentId)
end

local function LeaveApartment(house)
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.1)
    openHouseAnim()
    TriggerServerEvent("mr-apartments:returnBucket")
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do Wait(10) end
    exports['mr-interior']:DespawnInterior(houseObj, function()
        TriggerEvent('mr-weathersync:client:EnableSync')
        SetEntityCoords(PlayerPedId(), Apartments.Locations[house].coords.enter.x, Apartments.Locations[house].coords.enter.y,Apartments.Locations[house].coords.enter.z)
        SetEntityHeading(PlayerPedId(), Apartments.Locations[house].coords.enter.w)
        Wait(1000)
        TriggerServerEvent("apartments:server:RemoveObject", CurrentApartment, house)
        TriggerServerEvent('mr-apartments:server:SetInsideMeta', CurrentApartment, false)
        CurrentApartment = nil
        InApartment = false
        CurrentOffset = 0
        DoScreenFadeIn(1000)
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_close", 0.1)
        TriggerServerEvent("MRFW:Server:SetMetaData", "currentapartment", nil)
        ExecuteCommand('refreshskin')
    end)
end

local function SetClosestApartment()
    local pos = GetEntityCoords(PlayerPedId())
    local current = nil
    local dist = nil
    for id, house in pairs(Apartments.Locations) do
        local distcheck = #(pos - vector3(Apartments.Locations[id].coords.enter.x, Apartments.Locations[id].coords.enter.y, Apartments.Locations[id].coords.enter.z))
        if current ~= nil then
            if distcheck < dist then
                current = id
                dist = distcheck
            end
        else
            dist = distcheck
            current = id
        end
    end
    if current ~= ClosestHouse and LocalPlayer.state['isLoggedIn'] and not InApartment then
        ClosestHouse = current
        MRFW.Functions.TriggerCallback('apartments:IsOwner', function(result)
            IsOwned = result
        end, ClosestHouse)
    end
end

-- function MenuOwners()
--     ped = PlayerPedId();
--     MenuTitle = "Owners"
--     ClearMenu()
--     Menu.addButton("Ring the doorbell", "OwnerList", nil)
--     Menu.addButton("Close Menu", "closeMenuFull", nil) 
-- end

-- function OwnerList()
--     MRFW.Functions.TriggerCallback('apartments:GetAvailableApartments', function(apartments)
--         ped = PlayerPedId();
--         MenuTitle = "Rang the door at: "
--         ClearMenu()

--         if next(apartments) == nil then
--             MRFW.Functions.Notify("There is nobody home..", "error", 3500)
--             closeMenuFull()
--         else
--             for k, v in pairs(apartments) do
--                 Menu.addButton(v, "RingDoor", k) 
--             end
--         end
--         Menu.addButton("Back", "MenuOwners",nil)
--     end, ClosestHouse)
-- end

function RingDoor(apartmentId)
    rangDoorbell = ClosestHouse
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "doorbell", 0.1)
    TriggerServerEvent("apartments:server:RingDoor", apartmentId, ClosestHouse)
end

function closeMenuFull()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
end

function ClearMenu()
	Menu.GUI = {}
	Menu.buttonCount = 0
	Menu.selection = 0
end

local function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

-- Events

RegisterNetEvent('apartments:client:setupSpawnUI', function(cData)
    MRFW.Functions.TriggerCallback('apartments:GetOwnedApartment', function(result)
        if result then
            IsOwned = true
            TriggerEvent('mr-spawn:client:setupSpawns', cData, false, nil)
            TriggerEvent('mr-spawn:client:openUI', true)
            -- TriggerEvent('aj:selector:show')
            TriggerEvent("apartments:client:SetHomeBlip", result.type)
        else
            if Apartments.Starting then
                TriggerEvent('mr-spawn:client:setupSpawns', cData, true, Apartments.Locations)
                TriggerEvent('mr-spawn:client:openUI', true)
            else
                IsOwned = false
                TriggerEvent('mr-spawn:client:setupSpawns', cData, false, nil)
                TriggerEvent('mr-spawn:client:openUI', true)
            end
        end
    end, cData.citizenid)
end)

RegisterNetEvent('apartments:client:SpawnInApartment', function(apartmentId, apartment, bucket)
    local pos = GetEntityCoords(PlayerPedId())
    if rangDoorbell ~= nil then
        local doorbelldist = #(pos - vector3(Apartments.Locations[rangDoorbell].coords.doorbell.x, Apartments.Locations[rangDoorbell].coords.doorbell.y,Apartments.Locations[rangDoorbell].coords.doorbell.z))
        if doorbelldist > 5 then
            MRFW.Functions.Notify("You are to far away from the Doorbell")
            return
        end
    end
    ClosestHouse = apartment
    EnterApartment(apartment, apartmentId, false, true, bucket)
    IsOwned = true
end)

RegisterNetEvent('mr-apartments:client:LastLocationHouse', function(apartmentType, apartmentId)
    ClosestHouse = apartmentType
    EnterApartment(apartmentType, apartmentId, false, false)
end)

RegisterNetEvent('apartments:client:SetHomeBlip', function(home)
    CreateThread(function()
        SetClosestApartment()
        for name, apartment in pairs(Apartments.Locations) do
            RemoveBlip(Apartments.Locations[name].blip)

            Apartments.Locations[name].blip = AddBlipForCoord(Apartments.Locations[name].coords.enter.x, Apartments.Locations[name].coords.enter.y, Apartments.Locations[name].coords.enter.z)
            if (name == home) then
                SetBlipSprite(Apartments.Locations[name].blip, 475)
            else
                SetBlipSprite(Apartments.Locations[name].blip, 476)
            end
            SetBlipDisplay(Apartments.Locations[name].blip, 4)
            SetBlipScale(Apartments.Locations[name].blip, 0.65)
            SetBlipAsShortRange(Apartments.Locations[name].blip, true)
            SetBlipColour(Apartments.Locations[name].blip, 3)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(Apartments.Locations[name].label)
            EndTextCommandSetBlipName(Apartments.Locations[name].blip)
        end
    end)
end)

RegisterNetEvent('apartments:client:RingDoor', function(player, house)
    CurrentDoorBell = player
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "doorbell", 0.1)
    MRFW.Functions.Notify("Someone Is At The Door!")
end)

-- Threads

CreateThread(function()
    while true do
        if LocalPlayer.state['isLoggedIn'] and not InApartment then
            SetClosestApartment()
        end
        Wait(10000)
    end
end)

AddEventHandler('onResourceStop', function(resource)
   if resource == GetCurrentResourceName() then
    exports['mr-eye']:RemoveZone("apartments")
    exports['mr-eye']:RemoveZone("apartments-outfits")
    exports['mr-eye']:RemoveZone("apartments-door")
    exports['mr-eye']:RemoveZone("apartments-stash")
    exports['mr-eye']:RemoveZone("apartments-sleep")
   end
end)

function createZone()
    local zoneTypo = false
    local goAhead = false
    Wait(1000)
    MRFW.Functions.TriggerCallback('apartments:IsOwner', function(result)
        zoneTypo = result
        goAhead = true
    end, "apartment1")
    while not goAhead do Wait(500) print('getting apartments data') end
    if zoneTypo then
        exports['mr-eye']:AddBoxZone("apartments", vector3(-269.29, -962.49, 31.22), 0.4, 2.0, {
            name="Apartments",
            heading=117.1992,
            debugPoly=false,
            minZ=30.27834,
            maxZ=32.87834,
            }, {
                options = {
                    {
                        type = "client",
                        event = "apartments:e:e",
                        icon = "fas fa-hammer",
                        label = "Enter Apartment",
                        job = all,
                    },
                    {
                        type = "client",
                        event = "apartments:e:ring",
                        icon = "fas fa-hammer",
                        label = "Ring Door",
                        job = all,
                    },
                },
                distance = 1.0
            }
        )
    else
        exports['mr-eye']:AddBoxZone("apartments", vector3(-269.29, -962.49, 31.22), 0.4, 2.0, {
            name="Apartments",
            heading=117.1992,
            debugPoly=false,
            minZ=30.27834,
            maxZ=32.87834,
            }, {
                options = {
                    {
                        type = "client",
                        event = "apartments:e:b",
                        icon = "fas fa-hammer",
                        label = "Buy Apartment",
                        job = all,
                    },
                    {
                        type = "client",
                        event = "apartments:e:ring",
                        icon = "fas fa-hammer",
                        label = "Ring Door",
                        job = all,
                    },
                },
                distance = 1.0
            }
        )
    end
end
local TargetLoaded = false
function loadTargets()
    if not TargetLoaded then
        TargetLoaded = true
        exports['mr-eye']:AddBoxZone("apartments-outfits", vector3(-272.99, -962.53, 2.28), 4.0, 4.1, {
            name="apartmentsOutfits",
            heading=90.1992,
            debugPoly=false,
            minZ=1.27834,
            maxZ=4.47834,
            }, {
                options = {
                    {
                        type = "client",
                        event = "apartments:e:outfits",
                        icon = "fas fa-hammer",
                        label = "Change Outfits",
                        job = all,
                    },
                },
                distance = 2.0
            }
        )
        exports['mr-eye']:AddBoxZone("apartments-door", vector3(-268.97, -967.06, 2.28), 0.7, 1.4, {
            name="apartmentsDoor",
            heading=180.1992,
            debugPoly=false,
            minZ=1.27834,
            maxZ=3.77834,
            }, {
                options = {
                    {
                        type = "client",
                        event = "apartments:e:exit",
                        icon = "fas fa-hammer",
                        label = "Exit Apartments",
                        job = all,
                    },
                    {
                        type = "client",
                        event = "apartments:e:invite",
                        icon = "fas fa-hammer",
                        label = "Open Door",
                        job = all,
                    },
                },
                distance = 1.5
            }
        )
        exports['mr-eye']:AddBoxZone("apartments-stash", vector3(-265.88, -966.58, 2.28), 0.7, 3.3, {
            name="apartmentsstash",
            heading=180.1992,
            debugPoly=false,
            minZ=1.27834,
            maxZ=2.47834,
            }, {
                options = {
                    {
                        type = "client",
                        event = "apartments:e:stash",
                        icon = "fas fa-hammer",
                        label = "Stash",
                        job = all,
                    },
                },
                distance = 1.5
            }
        )
        exports['mr-eye']:AddBoxZone("apartments-sleep", vector3(-265.94, -962.2, 2.95), 2.9, 2.6, {
            name="apartmentssleep",
            heading=180.1992,
            debugPoly=false,
            minZ=1.27834,
            maxZ=2.37834,
            }, {
                options = {
                    {
                        type = "client",
                        event = "apartments:e:sleep",
                        icon = "fas fa-hammer",
                        label = "Sleep",
                        job = all,
                    },
                },
                distance = 1.5
            }
        )
    end
end

-- CreateThread(function()
--     exports['mr-eye']:AddBoxZone("apartments-outfits", vector3(-272.99, -962.53, 2.28), 4.0, 4.1, {
--         name="apartmentsOutfits",
--         heading=90.1992,
--         debugPoly=false,
--         minZ=1.27834,
--         maxZ=4.47834,
--         }, {
--             options = {
--                 {
--                     type = "client",
--                     event = "apartments:e:outfits",
--                     icon = "fas fa-hammer",
--                     label = "Change Outfits",
--                     job = all,
--                 },
--             },
--             distance = 2.0
--         }
--     )
--     exports['mr-eye']:AddBoxZone("apartments-door", vector3(-268.97, -967.06, 2.28), 0.7, 1.4, {
--         name="apartmentsDoor",
--         heading=180.1992,
--         debugPoly=false,
--         minZ=1.27834,
--         maxZ=3.77834,
--         }, {
--             options = {
--                 {
--                     type = "client",
--                     event = "apartments:e:exit",
--                     icon = "fas fa-hammer",
--                     label = "Exit Apartments",
--                     job = all,
--                 },
--                 {
--                     type = "client",
--                     event = "apartments:e:invite",
--                     icon = "fas fa-hammer",
--                     label = "Open Door",
--                     job = all,
--                 },
--             },
--             distance = 1.5
--         }
--     )
--     exports['mr-eye']:AddBoxZone("apartments-stash", vector3(-265.88, -966.58, 2.28), 0.7, 3.3, {
--         name="apartmentsstash",
--         heading=180.1992,
--         debugPoly=false,
--         minZ=1.27834,
--         maxZ=2.47834,
--         }, {
--             options = {
--                 {
--                     type = "client",
--                     event = "apartments:e:stash",
--                     icon = "fas fa-hammer",
--                     label = "Stash",
--                     job = all,
--                 },
--             },
--             distance = 1.5
--         }
--     )
--     exports['mr-eye']:AddBoxZone("apartments-sleep", vector3(-265.94, -962.2, 2.95), 2.9, 2.6, {
--         name="apartmentssleep",
--         heading=180.1992,
--         debugPoly=false,
--         minZ=1.27834,
--         maxZ=2.37834,
--         }, {
--             options = {
--                 {
--                     type = "client",
--                     event = "apartments:e:sleep",
--                     icon = "fas fa-hammer",
--                     label = "Sleep",
--                     job = all,
--                 },
--             },
--             distance = 1.5
--         }
--     )
-- end)

RegisterNetEvent('apartments:e:b',function()
    TriggerServerEvent('apartments:server:CreateApartment')
end)
RegisterNetEvent('apartments:e:e',function()
    MRFW.Functions.TriggerCallback('apartments:GetOwnedApartment', function(result)
        if result ~= nil then
            EnterApartment("apartment1", result.name, false, false)
        end
    end)
end)
RegisterNetEvent('apartments:e:ring',function()
    MenuOwners()
end)
RegisterNetEvent('apartments:e:outfits',function()
    TriggerEvent('mr-clothing:client:openOutfitMenu')
end)
RegisterNetEvent('apartments:e:stash',function()
    TriggerServerEvent("inventory:server:OpenInventory", "stash", CurrentApartment, {
        maxweight = 500000,
        slots = 100,
    })
    TriggerEvent("inventory:client:SetCurrentStash", CurrentApartment)
end)
RegisterNetEvent('apartments:e:sleep',function()
    TriggerServerEvent('mr-houses:server:LogoutLocation')
    TriggerServerEvent("mr-apartments:returnBucket")
end)
RegisterNetEvent('apartments:e:exit',function()
    LeaveApartment(ClosestHouse)
end)
RegisterNetEvent('apartments:e:invite',function()
    if CurrentDoorBell ~= 0 then
        TriggerServerEvent("apartments:server:OpenDoor", CurrentDoorBell, CurrentApartment, ClosestHouse)
        CurrentDoorBell = 0
    else
        MRFW.Functions.Notify('No one outside', 'error', 3000)
    end
end)


RegisterNetEvent('MRFW:Client:OnPlayerLoaded', function()
    createZone()
    -- loadTargets()
end)

AddEventHandler('onResourceStart', function(resource)
   if resource == GetCurrentResourceName() then
    createZone()
    -- loadTargets()
   end
end)

RegisterNetEvent('apartments:client:CreateApartment', function()
    local apartmentType = ClosestHouse
    local apartmentLabel = Apartments.Locations[ClosestHouse].label
    TriggerServerEvent('apartments:server:CreateApartmentConfirm', 'apartment1', 'alta Street')
    IsOwned = true
    exports['mr-eye']:RemoveZone("apartments")
    Wait(500)
    exports['mr-eye']:AddBoxZone("apartments", vector3(-269.29, -962.49, 31.22), 0.4, 2.0, {
        name="Apartments",
        heading=117.1992,
        debugPoly=false,
        minZ=30.27834,
        maxZ=32.87834,
        }, {
            options = {
                {
                    type = "client",
                    event = "apartments:e:e",
                    icon = "fas fa-hammer",
                    label = "Enter Apartment",
                    job = all,
                },
                {
                    type = "client",
                    event = "apartments:e:ring",
                    icon = "fas fa-hammer",
                    label = "Ring Door",
                    job = all,
                },
            },
            distance = 1.0
        }
    )
end)

local jacob
function MenuOwners()
    jacob = MenuV:CreateMenu(false, 'Ring the doorbell', 'topright', 0, 100, 0, 'size-125', 'none', 'menuv')
    OwnerList()
    -- ped = PlayerPedId();
    -- MenuTitle = "Owners"
    -- ClearMenu()
    -- Menu.addButton("Ring the doorbell", "OwnerList", nil)
    -- Menu.addButton("Close Menu", "closeMenuFull", nil) 
end

function OwnerList()
    MRFW.Functions.TriggerCallback('apartments:GetAvailableApartments', function(apartments)
        -- ped = PlayerPedId();
        -- MenuTitle = "Rang the door at: "
        -- ClearMenu()

        if apartments == nil then
            MRFW.Functions.Notify("There is nobody home..", "error", 3500)
            -- closeMenuFull()
        else
            for k, v in pairs(apartments) do
                local jacob_button = jacob:AddButton({
                    icon = '🏘️',
                    label = v,
                    select = function(btn)
                        MenuV:CloseAll()
                        RingDoor(k)
                    end
                })
                -- Menu.addButton(v, "RingDoor", k) 
            end

        end
        MenuV:OpenMenu(jacob)
        -- Menu.addButton("Back", "MenuOwners",nil)
    end, ClosestHouse)
end