local ModdedVehicles = {}
local VehicleStatus = {}
local ClosestPlate = nil
local PlayerJob = {}
local onDuty = false

function DrawText3Ds(x, y, z, text)
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

Citizen.CreateThread(function()
    while true do
        if LocalPlayer.state['isLoggedIn'] then
            SetClosestPlate()
        end
        Citizen.Wait(1000)
    end
end)

function SetClosestPlate()
    local pos = GetEntityCoords(PlayerPedId(), true)
    local current = nil
    local dist = nil
    for id,_ in pairs(Config.Plates) do
        if current ~= nil then
            if #(pos - vector3(Config.Plates[id].coords.x, Config.Plates[id].coords.y, Config.Plates[id].coords.z)) < dist then
                current = id
                dist = #(pos - vector3(Config.Plates[id].coords.x, Config.Plates[id].coords.y, Config.Plates[id].coords.z))
            end
        else
            dist = #(pos - vector3(Config.Plates[id].coords.x, Config.Plates[id].coords.y, Config.Plates[id].coords.z))
            current = id
        end
    end
    ClosestPlate = current
end

RegisterNetEvent('MRFW:Client:OnPlayerLoaded')
AddEventHandler('MRFW:Client:OnPlayerLoaded', function()
    MRFW.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
        if PlayerData.job.onduty then
            if PlayerData.job.name == "mechanic" then
                TriggerServerEvent("MRFW:ToggleDuty")
            end
        end
    end)
    MRFW.Functions.TriggerCallback('mr-vehicletuning:server:GetAttachedVehicle', function(plates)
        for k, v in pairs(plates) do
            Config.Plates[k].AttachedVehicle = v.AttachedVehicle
        end
    end)

    MRFW.Functions.TriggerCallback('mr-vehicletuning:server:GetDrivingDistances', function(retval)
        DrivingDistance = retval
    end)
end)

RegisterNetEvent('MRFW:Client:OnJobUpdate')
AddEventHandler('MRFW:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    onDuty = PlayerJob.onduty
end)

RegisterNetEvent('MRFW:Client:SetDuty')
AddEventHandler('MRFW:Client:SetDuty', function(duty)
    onDuty = duty
end)

-- Citizen.CreateThread(function()
--     local c = Config.Locations["exit"]
--     local Blip = AddBlipForCoord(c.x, c.y, c.z)

--     SetBlipSprite (Blip, 446)
--     SetBlipDisplay(Blip, 4)
--     SetBlipScale  (Blip, 0.7)
--     SetBlipAsShortRange(Blip, true)
--     SetBlipColour(Blip, 0)
--     SetBlipAlpha(Blip, 0.7)

--     BeginTextCommandSetBlipName("STRING")
--     AddTextComponentSubstringPlayerName("Autocare Mechanic")
--     EndTextCommandSetBlipName(Blip)
-- end)
local showText = false
local showText2 = false

RegisterNetEvent('mr-mechanicjob:ToggleDuty', function()
    TriggerServerEvent("MRFW:ToggleDuty")
end)

Citizen.CreateThread(function()
    while true do
        local inRange = false

        if LocalPlayer.state['isLoggedIn'] then
            if PlayerJob.name == "mechanic" then
                local pos = GetEntityCoords(PlayerPedId())
                local StashDistance = #(pos - Config.Locations["stash"])
                local OnDutyDistance = #(pos - Config.Locations["duty"])
                local pStashDistance = #(pos - Config.Locations["pstash"])
                local VehicleDistance = #(pos - vector3(Config.Locations["vehicle"].x, Config.Locations["vehicle"].y, Config.Locations["vehicle"].z))

                if onDuty then
                    if StashDistance < 5 then
                        inRange = true
                        DrawMarker(2, Config.Locations["stash"].x, Config.Locations["stash"].y, Config.Locations["stash"].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 210, 50, 9, 255, false, false, false, true, false, false, false)

                        if StashDistance < 1 then
                            if not showText then
                                exports['mr-text']:DrawText(
                                    '[E] Open Stash',
                                    0, 94, 255,0.7,
                                    1,
                                    50
                                )
                                showText = true
                            end
                            -- DrawText3Ds(Config.Locations["stash"].x, Config.Locations["stash"].y, Config.Locations["stash"].z, "[E] Open Stash")
                            if IsControlJustReleased(0, 38) then
                                TriggerEvent("inventory:client:SetCurrentStash", "mechanicstash")
                                TriggerServerEvent("inventory:server:OpenInventory", "stash", "mechanicstash", {
                                    maxweight = 4000000,
                                    slots = 500,
                                })
                            end
                        else
                            if showText then
                                exports['mr-text']:HideText(1)
                                showText = false
                            end
                        end
                    end
                end

                if onDuty then
                    if pStashDistance < 5 then
                        inRange = true
                        DrawMarker(2, Config.Locations["pstash"].x, Config.Locations["pstash"].y, Config.Locations["pstash"].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 210, 50, 9, 255, false, false, false, true, false, false, false)
                        if pStashDistance < 1 then
                            if not showText then
                                exports['mr-text']:DrawText(
                                    '[E] Personal Stash',
                                    0, 94, 255,0.7,
                                    1,
                                    50
                                )
                                showText = true
                            end
                            -- DrawText3Ds(Config.Locations["pstash"].x, Config.Locations["pstash"].y, Config.Locations["pstash"].z, "[E] Personal Stash")
                            if IsControlJustReleased(0, 38) then
                                TriggerEvent("inventory:client:SetCurrentStash", "personalmecstash_"..MRFW.Functions.GetPlayerData().citizenid)
                                TriggerServerEvent("inventory:server:OpenInventory", "stash", "personalmecstash_"..MRFW.Functions.GetPlayerData().citizenid,{
                                    maxweight = 4000000,
                                    slots = 500,
                                })
                            end
                        else
                            if showText then
                                exports['mr-text']:HideText(1)
                                showText = false
                            end
                        end
                    end
                end

                if onDuty then
                    if VehicleDistance < 5 then
                        inRange = true
                        DrawMarker(2, Config.Locations["vehicle"].x, Config.Locations["vehicle"].y, Config.Locations["vehicle"].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 210, 50, 9, 255, false, false, false, true, false, false, false)
                        if VehicleDistance < 1 then
                            local InVehicle = IsPedInAnyVehicle(PlayerPedId())

                            if InVehicle then
                                if not showText then
                                    exports['mr-text']:DrawText(
                                        '[E] Hide the vehicle',
                                        0, 94, 255,0.7,
                                        1,
                                        50
                                    )
                                    showText = true
                                end
                                -- DrawText3Ds(Config.Locations["vehicle"].x, Config.Locations["vehicle"].y, Config.Locations["vehicle"].z, '[E] Hide Vehicle')
                                if IsControlJustPressed(0, 38) then
                                    CheckPlayers(GetVehiclePedIsIn(PlayerPedId()))
                                end
                            else
                                if not showText then
                                    exports['mr-text']:DrawText(
                                        '[E] Grab vehicle',
                                        0, 94, 255,0.7,
                                        1,
                                        50
                                    )
                                    showText = true
                                end
                                -- DrawText3Ds(Config.Locations["vehicle"].x, Config.Locations["vehicle"].y, Config.Locations["vehicle"].z, '[E] Get Vehicle')
                                if IsControlJustPressed(0, 38) then
                                    if IsControlJustPressed(0, 38) then
                                        -- VehicleList()
                                        custom_vehicleList()
                                        -- Menu.hidden = not Menu.hidden
                                    end
                                end
                                -- Menu.renderGUI()
                            end
                        else
                            if showText then
                                exports['mr-text']:HideText(1)
                                showText = false
                            end
                        end
                    end
                end

                -- if OnDutyDistance < 5 then
                --     inRange = true
                --     DrawMarker(2, Config.Locations["duty"].x, Config.Locations["duty"].y, Config.Locations["duty"].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 210, 50, 9, 255, false, false, false, true, false, false, false)

                --     if OnDutyDistance < 1 then
                --         if onDuty then
                --             if not showText then
                --                 exports['mr-text']:DrawText(
                --                     '[E] to Go Off Duty ',
                --                     112, 0, 0,0.7,
                --                     1,
                --                     50
                --                 )
                --                 showText = true
                --             end
                --         else
                --             if not showText then
                --                 exports['mr-text']:DrawText(
                --                     '[E] to Go On Duty ',
                --                     4, 112, 0,0.7,
                --                     1,
                --                     50
                --                 )
                --                 showText = true
                --             end
                --         end
                --         -- if onDuty then
                --         --     DrawText3Ds(Config.Locations["duty"].x, Config.Locations["duty"].y, Config.Locations["duty"].z, "[E] Off Duty")
                --         -- else
                --         --     DrawText3Ds(Config.Locations["duty"].x, Config.Locations["duty"].y, Config.Locations["duty"].z, "[E] On Duty")
                --         -- end
                --         if IsControlJustReleased(0, 38) then
                --             if onDuty then
                --                 exports['mr-text']:ChangeText(
                --                     '[E] to Go On Duty ',
                --                     4, 112, 0, 0.7,
                --                     1,
                --                     50
                --                 )
                --             else
                --                 exports['mr-text']:ChangeText(
                --                     '[E] to Go Off Duty ',
                --                     112, 0, 0,0.7,
                --                     1,
                --                     50
                --                 )
                --             end
                --             TriggerServerEvent("MRFW:ToggleDuty")
                --         end
                --     else
                --         if showText then
                --             exports['mr-text']:HideText(1)
                --             showText = false
                --         end
                --     end
                -- end

                -- if onDuty then
                --     for k, v in pairs(Config.Plates) do
                --         if k ~= 4 and k ~= 5 then
                --             if v.AttachedVehicle == nil then
                --                 local PlateDistance = #(pos - vector3(v.coords.x, v.coords.y, v.coords.z))
                --                 if PlateDistance < 5 then
                --                     inRange = true
                --                     DrawMarker(2, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 255, 255, 255, 255, 0, 0, 0, 1, 0, 0, 0)
                --                     if PlateDistance < 2 then
                --                         local veh = GetVehiclePedIsIn(PlayerPedId())
                --                         if IsPedInAnyVehicle(PlayerPedId()) then
                --                             if not IsThisModelABicycle(GetEntityModel(veh)) then
                --                                 if not showText then
                --                                     exports['mr-text']:DrawText(
                --                                         '[E] Place The Vehicle On The Platform ',
                --                                         0, 94, 255,0.7,
                --                                         1,
                --                                         50
                --                                     )
                --                                     showText = true
                --                                 end
                --                                 -- DrawText3Ds(v.coords.x, v.coords.y, v.coords.z + 0.3, "[E] Place The Vehicle On The Platform")
                --                                 if IsControlJustPressed(0, 38) then
                --                                     DoScreenFadeOut(150)
                --                                     Wait(150)
                --                                     Config.Plates[ClosestPlate].AttachedVehicle = veh
                --                                     SetEntityCoords(veh, v.coords)
                --                                     SetEntityHeading(veh, v.coords.w)
                --                                     FreezeEntityPosition(veh, true)
                --                                     Wait(500)
                --                                     DoScreenFadeIn(250)
                --                                     TriggerServerEvent('mr-vehicletuning:server:SetAttachedVehicle', veh, k)
                --                                     if showText then
                --                                         exports['mr-text']:HideText(1)
                --                                         showText = false
                --                                     end
                --                                 end
                --                             else
                --                                 MRFW.Functions.Notify("You Cannot Put Bicycles On The Platform!", "error")
                --                             end
                --                         end
                --                     else
                --                         if showText then
                --                             exports['mr-text']:HideText(1)
                --                             showText = false
                --                         end
                --                     end
                --                 end
                --             else
                --                 local PlateDistance = #(pos - vector3(v.coords.x, v.coords.y, v.coords.z))
                --                 if PlateDistance < 2 then
                --                     inRange = true
                --                     if not showText2 then
                --                         exports['mr-text']:DrawText(
                --                             '[E] Open Menu ',
                --                             0, 94, 255,0.7,
                --                             2,
                --                             50
                --                         )
                --                         showText2 = true
                --                     end
                --                     -- DrawText3Ds(v.coords.x, v.coords.y, v.coords.z, "[E] Open Menu")
                --                     if IsControlJustPressed(0, 38) then
                --                         -- if IsPedInAnyVehicle(PlayerPedId(), false) then
                --                             -- MRFW.Functions.Notify('Chalo Gadi se neeche uttar ke repiar karo', 'error', 3000)
                --                         -- else
                --                             -- OpenMenu()
                --                             Custom_menu()
                --                             -- Menu.hidden = not Menu.hidden
                --                         -- end
                --                     end
                --                     -- Menu.renderGUI()
                --                 else
                --                     if showText2 then
                --                         exports['mr-text']:HideText(2)
                --                         showText2 = false
                --                     end
                --                 end
                --             end
                --         end
                --     end
                -- end

                if not inRange then
                    Citizen.Wait(1500)
                end
            else
                Citizen.Wait(1500)
            end
        else
            Citizen.Wait(1500)
        end

        Citizen.Wait(5)
    end
end)

local rep
local rep2
local rep3
function Custom_menu()
    rep = MenuV:CreateMenu(false,"Repair Station", 'topright', 0, 94, 255, 'size-125', 'none', 'menuv')
    rep:AddButton({
        icon = '🔧',
        label = 'Disconnect Vehicle',
        select = function(btn)
        MenuV:CloseAll()
        UnattachVehicle()
        end
    })
    rep:AddButton({
        icon = '🔧',
        label = 'vehicle parts',
        select = function(btn)
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                MRFW.Functions.Notify('Chalo Gadi se neeche uttar ke repiar karo', 'error', 3000)
            else
                custom_parts()
            end
        end
    })
    MenuV:OpenMenu(rep)
end

function custom_parts()
    rep2 = MenuV:CreateMenu(false,"parts list", 'topright', 0, 94, 255, 'size-125', 'none', 'menuv')
    local plate = MRFW.Functions.GetPlate(Config.Plates[ClosestPlate].AttachedVehicle)
    if VehicleStatus[plate] ~= nil then
        for k, v in pairs(Config.ValuesLabels) do
            if math.ceil(VehicleStatus[plate][k]) ~= Config.MaxStatusValues[k] then
                local percentage = math.ceil(VehicleStatus[plate][k])
                if percentage > 100 then
                    percentage = math.ceil(VehicleStatus[plate][k]) / 10
                end
                rep2:AddButton({
                    icon = '🔧',
                    label = v..": "..percentage.."%",
                    select = function(btn)
                        MenuV:CloseAll()
                        custom_part(k)
                    end
                })
            else
                local percentage = math.ceil(Config.MaxStatusValues[k])
                if percentage > 100 then
                    percentage = math.ceil(Config.MaxStatusValues[k]) / 10
                end
                rep2:AddButton({
                    icon = '🔧',
                    label = v..": "..percentage.."%",
                    select = function(btn)
                        -- MenuV:CloseAll()
                        -- Custom_NoDamage(nil)
                        MRFW.Functions.Notify("There Is No Damage To This Part!", 'error', 3000)
                    end
                })
            end
        end
    else
        for k, v in pairs(Config.ValuesLabels) do
            local percentage = math.ceil(Config.MaxStatusValues[k])
            if percentage > 100 then
                percentage = math.ceil(Config.MaxStatusValues[k]) / 10
            end
            rep2:AddButton({
                icon = '🔧',
                label = v..": "..percentage.."%",
                select = function(btn)
                    -- MenuV:CloseAll()
                        MRFW.Functions.Notify("There Is No Damage To This Part!", 'error', 3000)
                        -- Custom_NoDamage(nil)
                end
            })
        end
    end
    MenuV:OpenMenu(rep2)
end

function custom_part(part)
    rep3 = MenuV:CreateMenu(false,"List", 'topright', 0, 94, 255, 'size-125', 'none', 'menuv')
    rep3:AddButton({
        icon = '🔧',
        label = "Repair ("..MRFW.Shared.Items[Config.RepairCostAmount[part].item]["label"].." "..Config.RepairCostAmount[part].costs.."x)",
        select = function(btn)
            MenuV:CloseAll()
            RepairPart(part)
        end
    })
    MenuV:OpenMenu(rep3)
end

function PartMenu(part)
    ClearMenu()
    Menu.addButton("Repair ("..MRFW.Shared.Items[Config.RepairCostAmount[part].item]["label"].." "..Config.RepairCostAmount[part].costs.."x)", "RepairPart", part)
    Menu.addButton("Back", "VehicleOptions", nil)
    Menu.addButton("Close Menu", "CloseMenu", nil) 
end

function NoDamage(part)
    ClearMenu()
    Menu.addButton("There Is No Damage To This Part!", "PartsMenu", part)
    Menu.addButton("Back", "VehicleOptions", nil)
    Menu.addButton("Close Menu", "CloseMenu", nil) 
end

function RepairPart(part)
    local plate = GetVehicleNumberPlateTextIndex(Config.Plates[ClosestPlate].AttachedVehicle)
    local PartData = Config.RepairCostAmount[part]
    local hasitem = false
    local indx = 0
    local countitem = 0
    if ClosestPlate == 1 or ClosestPlate == 2 or ClosestPlate == 3 then
        MRFW.Functions.TriggerCallback('mr-inventory:server:GetStashItems', function(StashItems)
            for k,v in pairs(StashItems) do
                if v.name == PartData.item then
                    hasitem = true
                    if v.amount >= PartData.costs then
                        countitem = v.amount
                        indx = k
                    end
                end
            end
            if hasitem and countitem >= PartData.costs then
                MRFW.Functions.Progressbar("repair_part", "Repairing " ..Config.ValuesLabels[part], math.random(15000, 20000), false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                    TriggerEvent('dpemote:custom:animation', {"mechanic"})
                }, {}, {}, {}, function() -- Done
                    TriggerEvent('dpemote:custom:animation', {"c"})
                    if (countitem - PartData.costs) <= 0 then
                        StashItems[indx] = nil
                    else
                        countitem = (countitem - PartData.costs)
                        StashItems[indx].amount = countitem
                    end
                    TriggerEvent('mr-vehicletuning:client:RepaireeePart', part)
                    TriggerServerEvent('mr-inventory:server:SaveStashItems', "mechanicstash", StashItems)
                    SetTimeout(250, function()
                        MenuV:OpenMenu(rep2)
                    end)
                end, function()
                    MRFW.Functions.Notify("Repair Cancelled", "error")
                end)
            else
                MRFW.Functions.Notify('There Are Not Enough Materials In The Safe', 'error')
                MenuV:OpenMenu(rep2)
            end
        end, "mechanicstash")
    elseif ClosestPlate == 4 or ClosestPlate == 5 then
        MRFW.Functions.TriggerCallback('mr-inventory:server:GetStashItems', function(StashItems)
            for k,v in pairs(StashItems) do
                if v.name == PartData.item then
                    hasitem = true
                    if v.amount >= PartData.costs then
                        countitem = v.amount
                        indx = k
                    end
                end
            end
            if hasitem and countitem >= PartData.costs then
                
                MRFW.Functions.Progressbar("repair_part", "Repairing " ..Config.ValuesLabels[part], math.random(15000, 20000), false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                    TriggerEvent('dpemote:custom:animation', {"mechanic"})
                }, {}, {}, {}, function() -- Done
                    TriggerEvent('dpemote:custom:animation', {"c"})
                    if (countitem - PartData.costs) <= 0 then
                        StashItems[indx] = nil
                    else
                        countitem = (countitem - PartData.costs)
                        StashItems[indx].amount = countitem
                    end
                    TriggerEvent('mr-vehicletuning:client:RepaireeePart', part)
                    TriggerServerEvent('mr-inventory:server:SaveStashItems', "bennys_shop_stashes", StashItems)
                    SetTimeout(250, function()
                        MenuV:OpenMenu(rep2)
                    end)
                end, function()
                    MRFW.Functions.Notify("Repair Cancelled", "error")
                end)
            else
                MRFW.Functions.Notify('There Are Not Enough Materials In The Safe', 'error')
            end
        end, "bennys_shop_stashes")
    end
end

function PartsMenu()
    ClearMenu()
    local plate = MRFW.Functions.GetPlate(Config.Plates[ClosestPlate].AttachedVehicle)
    if VehicleStatus[plate] ~= nil then
        for k, v in pairs(Config.ValuesLabels) do
            if math.ceil(VehicleStatus[plate][k]) ~= Config.MaxStatusValues[k] then
                local percentage = math.ceil(VehicleStatus[plate][k])
                if percentage > 100 then
                    percentage = math.ceil(VehicleStatus[plate][k]) / 10
                end
                Menu.addButton(v..": "..percentage.."%", "PartMenu", k) 
            else
                local percentage = math.ceil(Config.MaxStatusValues[k])
                if percentage > 100 then
                    percentage = math.ceil(Config.MaxStatusValues[k]) / 10
                end
                Menu.addButton(v..": "..percentage.."%", "NoDamage", nil) 
            end
        end
    else
        for k, v in pairs(Config.ValuesLabels) do
            local percentage = math.ceil(Config.MaxStatusValues[k])
            if percentage > 100 then
                percentage = math.ceil(Config.MaxStatusValues[k]) / 10
            end
            Menu.addButton(v..": "..percentage.."%", "NoDamage", nil) 
        end
    end
    Menu.addButton("Back", "VehicleOptions", nil) 
    Menu.addButton("Close Menu", "CloseMenu", nil) 
end
function OpenMenu()
    ClearMenu()
    Menu.addButton("Options", "VehicleOptions", nil)
    Menu.addButton("Close Menu", "CloseMenu", nil) 
end

local mec

function custom_vehicleList()
    mec = MenuV:CreateMenu(false,"Mechanic Garage", 'topright', 0, 94, 255, 'size-125', 'none', 'menuv')
    for k,v in pairs(Config.Vehicles) do
        mec:AddButton({
            icon = '🔧',
            label = v,
            select = function(btn)
            MenuV:CloseAll()
            SpawnListVehicle(k)
            end
        })
    end
    MenuV:OpenMenu(mec)
end

function VehicleList()
    ClearMenu()
    for k, v in pairs(Config.Vehicles) do
        Menu.addButton(v, "SpawnListVehicle", k) 
    end
    Menu.addButton("Close Menu", "CloseMenu", nil) 
end

function SpawnListVehicle(model)
    local coords = {
        x = Config.Locations["vehicle"].x,
        y = Config.Locations["vehicle"].y,
        z = Config.Locations["vehicle"].z,
        w = Config.Locations["vehicle"].w,
    }

    MRFW.Functions.SpawnVehicle(model, function(veh)
        SetVehicleNumberPlateText(veh, "MECH "..tostring(math.random(111, 999)))
        exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'body', 1000.0)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'engine', 1000.0)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'fuel', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'clutch', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'brakes', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'axle', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'radiator', 100)
        SetEntityHeading(veh, coords.w)
        exports['mr-fuel']:SetFuel(veh, 100.0)
        Menu.hidden = true
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", MRFW.Functions.GetPlate(veh))
        SetVehicleEngineOn(veh, true, true)
    end, coords, true)
    exports['mr-text']:ChangeText(
        '[E] Hide The Vehicle ',
        0, 94, 255,0.7,
        1,
        50
    )
end

function VehicleOptions()
    ClearMenu()
    Menu.addButton("Disconnect Vehicle", "UnattachVehicle", nil)
    -- Menu.addButton("Check Status", "CheckStatus", nil)
    Menu.addButton("Vehicle Parts", "PartsMenu", nil)
    Menu.addButton("Close Menu", "CloseMenu", nil)
end


function CheckStatus()
    local plate = MRFW.Functions.GetPlate(Config.Plates[ClosestPlate].AttachedVehicle)
    SendStatusMessage(VehicleStatus[plate])
end

function PartMenu(part)
    ClearMenu()
    Menu.addButton("Repair ("..MRFW.Shared.Items[Config.RepairCostAmount[part].item]["label"].." "..Config.RepairCostAmount[part].costs.."x)", "RepairPart", part)
    Menu.addButton("Back", "VehicleOptions", nil)
    Menu.addButton("Close Menu", "CloseMenu", nil) 
end

function NoDamage(part)
    ClearMenu()
    Menu.addButton("There Is No Damage To This Part!", "PartsMenu", part)
    Menu.addButton("Back", "VehicleOptions", nil)
    Menu.addButton("Close Menu", "CloseMenu", nil) 
end

-- function RepairPart(part)
--     local plate = MRFW.Functions.GetPlate(Config.Plates[ClosestPlate].AttachedVehicle)
--     local PartData = Config.RepairCostAmount[part]
--     local hasitem = false
--     local indx = 0
--     local countitem = 0
--     if ClosestPlate == 1 or ClosestPlate == 2 or ClosestPlate == 3 then
--         MRFW.Functions.TriggerCallback('mr-inventory:server:GetStashItems', function(StashItems)
--             for k,v in pairs(StashItems) do
--                 if v.name == PartData.item then
--                     hasitem = true
--                     if v.amount >= PartData.costs then
--                         countitem = v.amount
--                         indx = k
--                     end
--                 end
--             end
--             if hasitem and countitem >= PartData.costs then
--                 MRFW.Functions.Progressbar("repair_part", "Repairing " ..Config.ValuesLabels[part], math.random(30000, 40000), false, true, {
--                     disableMovement = true,
--                     disableCarMovement = true,
--                     disableMouse = false,
--                     disableCombat = true,
--                     TriggerEvent('dpemote:custom:animation', {"mechanic"})
--                 }, {}, {}, {}, function() -- Done
--                     TriggerEvent('dpemote:custom:animation', {"c"})
--                     if (countitem - PartData.costs) <= 0 then
--                         StashItems[indx] = nil
--                     else
--                         countitem = (countitem - PartData.costs)
--                         StashItems[indx].amount = countitem
--                     end
--                     TriggerEvent('mr-vehicletuning:client:RepaireeePart', part)
--                     TriggerServerEvent('mr-inventory:server:SaveStashItems', "mechanicstash", StashItems)
--                     SetTimeout(250, function()
--                         PartsMenu()
--                     end)
--                 end, function()
--                     MRFW.Functions.Notify("Repair Cancelled", "error")
--                 end)
--             else
--                 MRFW.Functions.Notify('There Are Not Enough Materials In The Safe', 'error')
--             end
--         end, "mechanicstash")
--     else
--         MRFW.Functions.TriggerCallback('mr-inventory:server:GetStashItems', function(StashItems)
--             for k,v in pairs(StashItems) do
--                 if v.name == PartData.item then
--                     hasitem = true
--                     if v.amount >= PartData.costs then
--                         countitem = v.amount
--                         indx = k
--                     end
--                 end
--             end
--             if hasitem and countitem >= PartData.costs then
                
--                 MRFW.Functions.Progressbar("repair_part", "Repairing " ..Config.ValuesLabels[part], math.random(30000, 40000), false, true, {
--                     disableMovement = true,
--                     disableCarMovement = true,
--                     disableMouse = false,
--                     disableCombat = true,
--                     TriggerEvent('dpemote:custom:animation', {"mechanic"})
--                 }, {}, {}, {}, function() -- Done
--                     TriggerEvent('dpemote:custom:animation', {"c"})
--                     if (countitem - PartData.costs) <= 0 then
--                         StashItems[indx] = nil
--                     else
--                         countitem = (countitem - PartData.costs)
--                         StashItems[indx].amount = countitem
--                     end
--                     TriggerEvent('mr-vehicletuning:client:RepaireeePart', part)
--                     TriggerServerEvent('mr-inventory:server:SaveStashItems', "tuner_shop_stash", StashItems)
--                     SetTimeout(250, function()
--                         PartsMenu()
--                     end)
--                 end, function()
--                     MRFW.Functions.Notify("Repair Cancelled", "error")
--                 end)
--             else
--                 MRFW.Functions.Notify('There Are Not Enough Materials In The Safe', 'error')
--             end
--         end, "tuner_shop_stash")
--     end
-- end

--

RegisterNetEvent('mr-vehicletuning:client:RepaireeePart')
AddEventHandler('mr-vehicletuning:client:RepaireeePart', function(part)
    local veh = Config.Plates[ClosestPlate].AttachedVehicle
    local plate = MRFW.Functions.GetPlate(veh)
    local percent = math.ceil(exports['mr-mechanicjob']:GetVehicleStatus(plate, part)) / 10
    local cuDamage = exports['mr-mechanicjob']:GetVehicleStatus(plate, part)
    if part == "engine" then
        -- print(cuDamage, cuDamage + 20, cuDamage + 200 + 0.0)
        if percent <= 50 then
            SetVehicleEngineHealth(veh, cuDamage + 500 + 0.0)
            TriggerServerEvent("vehiclemod:server:updatePart", plate, "engine", cuDamage + 500 + 0.0)
        else
            SetVehicleEngineHealth(veh, Config.MaxStatusValues[part])
            TriggerServerEvent("vehiclemod:server:updatePart", plate, "engine", Config.MaxStatusValues[part])
        end
    elseif part == "body" then
        if percent <= 50 then
            local enhealth = GetVehicleEngineHealth(veh)
            SetVehicleBodyHealth(veh, cuDamage + 500 + 0.0)
            TriggerServerEvent("vehiclemod:server:updatePart", plate, "body", cuDamage + 500 + 0.0)
            SetVehicleEngineHealth(veh, enhealth)
        else
            local enhealth = GetVehicleEngineHealth(veh)
            SetVehicleBodyHealth(veh, Config.MaxStatusValues[part])
            TriggerServerEvent("vehiclemod:server:updatePart", plate, "body", Config.MaxStatusValues[part])
            SetVehicleFixed(veh)
            SetVehicleEngineHealth(veh, enhealth)
        end
    else
        if percent <= 50 then
            TriggerServerEvent("vehiclemod:server:updatePart", plate, part, cuDamage + 50)
        else
            TriggerServerEvent("vehiclemod:server:updatePart", plate, part, Config.MaxStatusValues[part])
        end
    end
    MRFW.Functions.Notify("The "..Config.ValuesLabels[part].." Is Repaired!")
end)

function UnattachVehicle()
    local coords = Config.Locations["exit"]
    DoScreenFadeOut(150)
    Wait(150)
    FreezeEntityPosition(Config.Plates[ClosestPlate].AttachedVehicle, false)
    SetEntityCoords(Config.Plates[ClosestPlate].AttachedVehicle, Config.Plates[ClosestPlate].coords.x, Config.Plates[ClosestPlate].coords.y, Config.Plates[ClosestPlate].coords.z)
    SetEntityHeading(Config.Plates[ClosestPlate].AttachedVehicle, Config.Plates[ClosestPlate].coords.w)
    Wait(500)
    DoScreenFadeIn(250)
    Config.Plates[ClosestPlate].AttachedVehicle = nil
    TriggerServerEvent('mr-vehicletuning:server:SetAttachedVehicle', false, ClosestPlate)
    if showText2 then
        exports['mr-text']:HideText(2)
        showText2 = false
    end
end

RegisterNetEvent('mr-vehicletuning:client:SetAttachedVehicle')
AddEventHandler('mr-vehicletuning:client:SetAttachedVehicle', function(veh, key)
    if veh ~= false then
        Config.Plates[key].AttachedVehicle = veh
    else
        Config.Plates[key].AttachedVehicle = nil
    end
end)

-- Citizen.CreateThread(function()
--     while true do 
--         Citizen.Wait(1)
--         if (IsPedInAnyVehicle(PlayerPedId(), false)) then
--             local veh = GetVehiclePedIsIn(PlayerPedId(),false)
--             if ModdedVehicles[tostring(veh)] == nil and not IsThisModelABicycle(GetEntityModel(veh)) then
--                 --[[local fSteeringLock = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fSteeringLock')
--                 fSteeringLock = math.ceil((fSteeringLock * 0.6)) + 0.1

--                 SetVehicleHandlingFloat(veh, 'CHandlingData', 'fSteeringLock', fSteeringLock)
--                 SetVehicleHandlingField(veh, 'CHandlingData', 'fSteeringLock', fSteeringLock)]]--

--                 local fInitialDriveMaxFlatVel = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveMaxFlatVel')

--                 if IsThisModelABike(GetEntityModel(veh)) then
--                     local fTractionCurveMin = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fTractionCurveMin')

--                     fTractionCurveMin = fTractionCurveMin * 0.6
--                     SetVehicleHandlingFloat(veh, 'CHandlingData', 'fTractionCurveMin', fTractionCurveMin)
--                     SetVehicleHandlingField(veh, 'CHandlingData', 'fTractionCurveMin', fTractionCurveMin)   

--                     -- local fTractionCurveMax = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fTractionCurveMax')
--                     -- fTractionCurveMax = fTractionCurveMax * 0.6
--                     -- SetVehicleHandlingFloat(veh, 'CHandlingData', 'fTractionCurveMax', fTractionCurveMax)
--                     -- SetVehicleHandlingField(veh, 'CHandlingData', 'fTractionCurveMax', fTractionCurveMax)

--                     local fInitialDriveForce = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce')
--                     fInitialDriveForce = fInitialDriveForce * 2.4
--                     SetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce', fInitialDriveForce)

--                     local fBrakeForce = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fBrakeForce')
--                     fBrakeForce = fBrakeForce * 1.4
--                     SetVehicleHandlingFloat(veh, 'CHandlingData', 'fBrakeForce', fBrakeForce)
                    
--                     SetVehicleHandlingFloat(veh, 'CHandlingData', 'fSuspensionReboundDamp', 5.000000)
--                     SetVehicleHandlingField(veh, 'CHandlingData', 'fSuspensionReboundDamp', 5.000000)

--                     SetVehicleHandlingFloat(veh, 'CHandlingData', 'fSuspensionCompDamp', 5.000000)
--                     SetVehicleHandlingField(veh, 'CHandlingData', 'fSuspensionCompDamp', 5.000000)

--                     SetVehicleHandlingFloat(veh, 'CHandlingData', 'fSuspensionForce', 22.000000)
--                     SetVehicleHandlingField(veh, 'CHandlingData', 'fSuspensionForce', 22.000000)

--                     SetVehicleHandlingFloat(veh, 'CHandlingData', 'fCollisionDamageMult', 2.500000)
--                     SetVehicleHandlingFloat(veh, 'CHandlingData', 'fEngineDamageMult', 0.120000)
--                 else
--                     local fBrakeForce = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fBrakeForce')
--                     fBrakeForce = fBrakeForce * 0.5
--                     SetVehicleHandlingFloat(veh, 'CHandlingData', 'fBrakeForce', fBrakeForce)

--                     local fInitialDriveForce = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce')
--                     if fInitialDriveForce < 0.289 then
--                         fInitialDriveForce = fInitialDriveForce * 1.2
--                         SetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce', fInitialDriveForce)
--                     else
--                         fInitialDriveForce = fInitialDriveForce * 0.9
--                         SetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce', fInitialDriveForce)
--                     end
                                
--                     local fInitialDragCoeff = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDragCoeff')
--                     fInitialDragCoeff = fInitialDragCoeff * 0.3
--                     SetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDragCoeff', fInitialDragCoeff)

--                     SetVehicleHandlingFloat(veh, 'CHandlingData', 'fEngineDamageMult', 0.100000)
--                     SetVehicleHandlingFloat(veh, 'CHandlingData', 'fCollisionDamageMult', 2.900000)

--                 end
--                 SetVehicleHandlingFloat(veh, 'CHandlingData', 'fDeformationDamageMult', 1.000000)
--                 SetVehicleHasBeenOwnedByPlayer(veh,true)
--                 ModdedVehicles[tostring(veh)] = { 
--                     ["fInitialDriveMaxFlatVel"] = fInitialDriveMaxFlatVel, 
--                     ["fSteeringLock"] = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fSteeringLock'), 
--                     ["fTractionLossMult"] = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fTractionLossMult'), 
--                     ["fLowSpeedTractionLossMult"] = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fLowSpeedTractionLossMult') 
--                 }
--             else
--                 Citizen.Wait(1000)
--             end
--         else
--             Citizen.Wait(2000)
--         end
--     end
-- end)
local effectTimer = 0
Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1000)
        if (IsPedInAnyVehicle(PlayerPedId(), false)) then
            local veh = GetVehiclePedIsIn(PlayerPedId(),false)
            if not IsThisModelABicycle(GetEntityModel(veh)) and GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
                local engineHealth = GetVehicleEngineHealth(veh)
                local bodyHealth = GetVehicleBodyHealth(veh)
                local plate = MRFW.Functions.GetPlate(veh)
                if VehicleStatus[plate] == nil then 
                    TriggerServerEvent("vehiclemod:server:setupVehicleStatus", plate, engineHealth, bodyHealth)
                else
                    TriggerServerEvent("vehiclemod:server:updatePart", plate, "engine", engineHealth)
                    TriggerServerEvent("vehiclemod:server:updatePart", plate, "body", bodyHealth)
                    effectTimer = effectTimer + 1
                    if effectTimer >= math.random(10, 15) then
                        ApplyEffects(veh)
                        effectTimer = 0
                    end
                end
            else
                effectTimer = 0
                Citizen.Wait(1000)
            end
        else
            effectTimer = 0
            Citizen.Wait(2000)
        end
    end
end)

RegisterNetEvent('vehiclemod:client:setVehicleStatus')
AddEventHandler('vehiclemod:client:setVehicleStatus', function(plate, status)
    VehicleStatus[plate] = status
end)

RegisterNetEvent('vehiclemod:client:getVehicleStatus')
AddEventHandler('vehiclemod:client:getVehicleStatus', function(plate, status)
    if not (IsPedInAnyVehicle(PlayerPedId(), false)) then
        local veh = GetVehiclePedIsIn(PlayerPedId(), true)
        if veh ~= nil and veh ~= 0 then
            local vehpos = GetEntityCoords(veh)
            local pos = GetEntityCoords(PlayerPedId())
            if #(pos - vehpos) < 5.0 then
                if not IsThisModelABicycle(GetEntityModel(veh)) then
                    local plate = MRFW.Functions.GetPlate(veh)
                    if VehicleStatus[plate] ~= nil then 
                        SendStatusMessage(VehicleStatus[plate])
                    else
                        MRFW.Functions.Notify("Status Unknown", "error")
                    end
                else
                    MRFW.Functions.Notify("Not A Valid Vehicle", "error")
                end
            else
                MRFW.Functions.Notify("You Are Not Close Enough To The Vehicle", "error")
            end
        else
            MRFW.Functions.Notify("You Must Be In The Vehicle First", "error")
        end
    else
        MRFW.Functions.Notify("You Must Be Outside The Vehicle", "error")
    end
end)

RegisterNetEvent('vehiclemod:client:fixEverything')
AddEventHandler('vehiclemod:client:fixEverything', function()
    if (IsPedInAnyVehicle(PlayerPedId(), false)) then
        local veh = GetVehiclePedIsIn(PlayerPedId(),false)
        if not IsThisModelABicycle(GetEntityModel(veh)) and GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
            local plate = MRFW.Functions.GetPlate(veh)
            TriggerServerEvent("vehiclemod:server:fixEverything", plate)
        else
            MRFW.Functions.Notify("You Are Not The Driver Or On A Bicycle", "error")
        end
    else
        MRFW.Functions.Notify("You Are Not In A Vehicle", "error")
    end
end)

RegisterNetEvent('vehiclemod:client:setPartLevel')
AddEventHandler('vehiclemod:client:setPartLevel', function(part, level)
    if (IsPedInAnyVehicle(PlayerPedId(), false)) then
        local veh = GetVehiclePedIsIn(PlayerPedId(),false)
        if not IsThisModelABicycle(GetEntityModel(veh)) and GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
            local plate = MRFW.Functions.GetPlate(veh)
            if part == "engine" then
                SetVehicleEngineHealth(veh, level)
                TriggerServerEvent("vehiclemod:server:updatePart", plate, "engine", GetVehicleEngineHealth(veh))
            elseif part == "body" then
                SetVehicleBodyHealth(veh, level)
                TriggerServerEvent("vehiclemod:server:updatePart", plate, "body", GetVehicleBodyHealth(veh))
            else
                TriggerServerEvent("vehiclemod:server:updatePart", plate, part, level)
            end
        else
            MRFW.Functions.Notify("You Are Not The Driver Or On A Bicycle", "error")
        end
    else
        MRFW.Functions.Notify("You Are Not The Driver Or On A Bicycle", "error")
    end
end)
local openingDoor = false

RegisterNetEvent('vehiclemod:client:repairPart')
AddEventHandler('vehiclemod:client:repairPart', function(part, level, needAmount)
    -- if CanReapair() then
        if not IsPedInAnyVehicle(PlayerPedId(), false) then
            local veh = GetVehiclePedIsIn(PlayerPedId(), true)
            if veh ~= nil and veh ~= 0 then
                local vehpos = GetEntityCoords(veh)
                local pos = GetEntityCoords(PlayerPedId())
                if #(pos - vehpos) < 5.0 then
                    if not IsThisModelABicycle(GetEntityModel(veh)) then
                        local plate = MRFW.Functions.GetPlate(veh)
                        if VehicleStatus[plate] ~= nil and VehicleStatus[plate][part] ~= nil then
                            local lockpickTime = (1000 * level)
                            if part == "body" then
                                lockpickTime = lockpickTime / 10
                            end
                            ScrapAnim(lockpickTime)
                            MRFW.Functions.Progressbar("repair_advanced", "Repair Vehicle", lockpickTime, false, true, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {
                                animDict = "mp_car_bomb",
                                anim = "car_bomb_mechanic",
                                flags = 16,
                            }, {}, {}, function() -- Done
                                openingDoor = false
                                ClearPedTasks(PlayerPedId())
                                if part == "body" then
                                    local enhealth = GetVehicleEngineHealth(veh)
                                    SetVehicleBodyHealth(veh, GetVehicleBodyHealth(veh) + level)
                                    SetVehicleFixed(veh)
                                    SetVehicleEngineHealth(veh, enhealth)
                                    TriggerServerEvent("vehiclemod:server:updatePart", plate, part, GetVehicleBodyHealth(veh))
                                    TriggerServerEvent("MRFW:Server:RemoveItem", Config.RepairCost[part], needAmount)
                                    TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[Config.RepairCost[part]], "remove")
                                elseif part ~= "engine" then
                                    TriggerServerEvent("vehiclemod:server:updatePart", plate, part, GetVehicleStatus(plate, part) + level)
                                    TriggerServerEvent("MRFW:Server:RemoveItem", Config.RepairCost[part], level)
                                    TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items[Config.RepairCost[part]], "remove")
                                end
                            end, function() -- Cancel
                                openingDoor = false
                                ClearPedTasks(PlayerPedId())
                                MRFW.Functions.Notify("Process Canceled", "error")
                            end)
                        else
                            MRFW.Functions.Notify("Not A Valid Part", "error")
                        end
                    else
                        MRFW.Functions.Notify("Not A Valid Vehicle", "error")
                    end
                else
                    MRFW.Functions.Notify("You Are Not Close Enough To The Vehicle", "error")
                end
            else
                MRFW.Functions.Notify("You Must Be In The Vehicle First", "error")
            end
        else
            MRFW.Functions.Notify("Youre Not In a Vehicle", "error")
        end
    -- end
end)

function ScrapAnim(time)
    local time = time / 1000
    loadAnimDict("mp_car_bomb")
    TaskPlayAnim(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic" ,3.0, 3.0, -1, 16, 0, false, false, false)
    openingDoor = true
    Citizen.CreateThread(function()
        while openingDoor do
            TaskPlayAnim(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
            Citizen.Wait(2000)
            time = time - 2
            if time <= 0 then
                openingDoor = false
                StopAnimTask(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 1.0)
            end
        end
    end)
end

function CanReapair()
    local retval = false
    for k, v in pairs(Config.Businesses) do
        retval = exports['mr-companies']:IsEmployee(v)
    end
    return retval
end

function ApplyEffects(vehicle)
    local plate = MRFW.Functions.GetPlate(vehicle)
    if GetVehicleClass(vehicle) ~= 13 and GetVehicleClass(vehicle) ~= 21 and GetVehicleClass(vehicle) ~= 16 and GetVehicleClass(vehicle) ~= 15 and GetVehicleClass(vehicle) ~= 14 then
        if VehicleStatus[plate] ~= nil then 
            local chance = math.random(1, 100)
            if VehicleStatus[plate]["radiator"] <= 80 and (chance >= 1 and chance <= 20) then
                local engineHealth = GetVehicleEngineHealth(vehicle)
                if VehicleStatus[plate]["radiator"] <= 80 and VehicleStatus[plate]["radiator"] >= 60 then
                    SetVehicleEngineHealth(vehicle, engineHealth - math.random(10, 15))
                elseif VehicleStatus[plate]["radiator"] <= 59 and VehicleStatus[plate]["radiator"] >= 40 then
                    SetVehicleEngineHealth(vehicle, engineHealth - math.random(15, 20))
                elseif VehicleStatus[plate]["radiator"] <= 39 and VehicleStatus[plate]["radiator"] >= 20 then
                    SetVehicleEngineHealth(vehicle, engineHealth - math.random(20, 30))
                elseif VehicleStatus[plate]["radiator"] <= 19 and VehicleStatus[plate]["radiator"] >= 6 then
                    SetVehicleEngineHealth(vehicle, engineHealth - math.random(30, 40))
                else
                    SetVehicleEngineHealth(vehicle, engineHealth - math.random(40, 50))
                end
            end

            if VehicleStatus[plate]["axle"] <= 80 and (chance >= 21 and chance <= 40) then
                if VehicleStatus[plate]["axle"] <= 80 and VehicleStatus[plate]["axle"] >= 60 then
                    for i=0,360 do					
                        SetVehicleSteeringScale(vehicle,i)
                        Citizen.Wait(5)
                    end
                elseif VehicleStatus[plate]["axle"] <= 59 and VehicleStatus[plate]["axle"] >= 40 then
                    for i=0,360 do	
                        Citizen.Wait(10)
                        SetVehicleSteeringScale(vehicle,i)
                    end
                elseif VehicleStatus[plate]["axle"] <= 39 and VehicleStatus[plate]["axle"] >= 20 then
                    for i=0,360 do
                        Citizen.Wait(15)
                        SetVehicleSteeringScale(vehicle,i)
                    end
                elseif VehicleStatus[plate]["axle"] <= 19 and VehicleStatus[plate]["axle"] >= 6 then
                    for i=0,360 do
                        Citizen.Wait(20)
                        SetVehicleSteeringScale(vehicle,i)
                    end
                else
                    for i=0,360 do
                        Citizen.Wait(25)
                        SetVehicleSteeringScale(vehicle,i)
                    end
                end
            end

            if VehicleStatus[plate]["brakes"] <= 80 and (chance >= 41 and chance <= 60) then
                if VehicleStatus[plate]["brakes"] <= 80 and VehicleStatus[plate]["brakes"] >= 60 then
                    SetVehicleHandbrake(vehicle, true)
                    Citizen.Wait(1000)
                    SetVehicleHandbrake(vehicle, false)
                elseif VehicleStatus[plate]["brakes"] <= 59 and VehicleStatus[plate]["brakes"] >= 40 then
                    SetVehicleHandbrake(vehicle, true)
                    Citizen.Wait(3000)
                    SetVehicleHandbrake(vehicle, false)
                elseif VehicleStatus[plate]["brakes"] <= 39 and VehicleStatus[plate]["brakes"] >= 20 then
                    SetVehicleHandbrake(vehicle, true)
                    Citizen.Wait(5000)
                    SetVehicleHandbrake(vehicle, false)
                elseif VehicleStatus[plate]["brakes"] <= 19 and VehicleStatus[plate]["brakes"] >= 6 then
                    SetVehicleHandbrake(vehicle, true)
                    Citizen.Wait(7000)
                    SetVehicleHandbrake(vehicle, false)
                else
                    SetVehicleHandbrake(vehicle, true)
                    Citizen.Wait(9000)
                    SetVehicleHandbrake(vehicle, false)
                end
            end

            if VehicleStatus[plate]["clutch"] <= 80 and (chance >= 61 and chance <= 80) then
                if VehicleStatus[plate]["clutch"] <= 80 and VehicleStatus[plate]["clutch"] >= 60 then
                    SetVehicleHandbrake(vehicle, true)
                    SetVehicleEngineOn(vehicle,0,0,1)
                    SetVehicleUndriveable(vehicle,true)
                    Citizen.Wait(50)
                    SetVehicleEngineOn(vehicle,1,0,1)
                    SetVehicleUndriveable(vehicle,false)
                    Citizen.Wait(500)
                    SetVehicleHandbrake(vehicle, false)
                    for i=1,360 do
                        SetVehicleSteeringScale(vehicle, i)
                        Citizen.Wait(5)
                    end
                elseif VehicleStatus[plate]["clutch"] <= 59 and VehicleStatus[plate]["clutch"] >= 40 then
                    SetVehicleHandbrake(vehicle, true)
                    SetVehicleEngineOn(vehicle,0,0,1)
                    SetVehicleUndriveable(vehicle,true)
                    Citizen.Wait(100)
                    SetVehicleEngineOn(vehicle,1,0,1)
                    SetVehicleUndriveable(vehicle,false)
                    Citizen.Wait(750)
                    SetVehicleHandbrake(vehicle, false)
                    for i=1,360 do
                        SetVehicleSteeringScale(vehicle, i)
                        Citizen.Wait(5)
                    end
                elseif VehicleStatus[plate]["clutch"] <= 39 and VehicleStatus[plate]["clutch"] >= 20 then
                    SetVehicleHandbrake(vehicle, true)
                    SetVehicleEngineOn(vehicle,0,0,1)
                    SetVehicleUndriveable(vehicle,true)
                    Citizen.Wait(150)
                    SetVehicleEngineOn(vehicle,1,0,1)
                    SetVehicleUndriveable(vehicle,false)
                    Citizen.Wait(1000)
                    SetVehicleHandbrake(vehicle, false)
                    for i=1,360 do
                        SetVehicleSteeringScale(vehicle, i)
                        Citizen.Wait(5)
                    end
                elseif VehicleStatus[plate]["clutch"] <= 19 and VehicleStatus[plate]["clutch"] >= 6 then
                    SetVehicleHandbrake(vehicle, true)
                    SetVehicleEngineOn(vehicle,0,0,1)
                    SetVehicleUndriveable(vehicle,true)
                    Citizen.Wait(200)
                    SetVehicleEngineOn(vehicle,1,0,1)
                    SetVehicleUndriveable(vehicle,false)
                    Citizen.Wait(1250)
                    SetVehicleHandbrake(vehicle, false)
                    for i=1,360 do
                        SetVehicleSteeringScale(vehicle, i)
                        Citizen.Wait(5)
                    end
                else
                    SetVehicleHandbrake(vehicle, true)
                    SetVehicleEngineOn(vehicle,0,0,1)
                    SetVehicleUndriveable(vehicle,true)
                    Citizen.Wait(250)
                    SetVehicleEngineOn(vehicle,1,0,1)
                    SetVehicleUndriveable(vehicle,false)
                    Citizen.Wait(1500)
                    SetVehicleHandbrake(vehicle, false)
                    for i=1,360 do
                        SetVehicleSteeringScale(vehicle, i)
                        Citizen.Wait(5)
                    end
                end
            end

            if VehicleStatus[plate]["fuel"] <= 80 and (chance >= 81 and chance <= 100) then
                local fuel = exports['mr-fuel']:GetFuel(vehicle)
                if VehicleStatus[plate]["fuel"] <= 80 and VehicleStatus[plate]["fuel"] >= 60 then
                    exports['mr-fuel']:SetFuel(vehicle, fuel - 2.0)
                elseif VehicleStatus[plate]["fuel"] <= 59 and VehicleStatus[plate]["fuel"] >= 40 then
                    exports['mr-fuel']:SetFuel(vehicle, fuel - 4.0)
                elseif VehicleStatus[plate]["fuel"] <= 39 and VehicleStatus[plate]["fuel"] >= 20 then
                    exports['mr-fuel']:SetFuel(vehicle, fuel - 6.0)
                elseif VehicleStatus[plate]["fuel"] <= 19 and VehicleStatus[plate]["fuel"] >= 6 then
                    exports['mr-fuel']:SetFuel(vehicle, fuel - 8.0)
                else
                    exports['mr-fuel']:SetFuel(vehicle, fuel - 10.0)
                end
            end
        end
    end
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

function GetVehicleStatusList(plate)
    local retval = nil
    if VehicleStatus[plate] ~= nil then 
        retval = VehicleStatus[plate]
    end
    return retval
end

function GetVehicleStatus(plate, part)
    local retval = nil
    if VehicleStatus[plate] ~= nil then 
        retval = VehicleStatus[plate][part]
    end
    return retval
end

function SetVehicleStatus(plate, part, level)
    TriggerServerEvent("vehiclemod:server:updatePart", plate, part, level)
end

function SendStatusMessage(statusList)
    if statusList ~= nil then 
        TriggerEvent('chat:addMessage', {
            template = '<div class="chat-message normal"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>'.. Config.ValuesLabels["engine"] ..' (engine):</strong> {1} <br><strong>'.. Config.ValuesLabels["body"] ..' (body):</strong> {2} <br><strong>'.. Config.ValuesLabels["radiator"] ..' (radiator):</strong> {3} <br><strong>'.. Config.ValuesLabels["axle"] ..' (axle):</strong> {4}<br><strong>'.. Config.ValuesLabels["brakes"] ..' (brakes):</strong> {5}<br><strong>'.. Config.ValuesLabels["clutch"] ..' (clutch):</strong> {6}<br><strong>'.. Config.ValuesLabels["fuel"] ..' (fuel):</strong> {7}</div></div>',
            args = {'Vehicle Status', round(statusList["engine"]) .. "/" .. Config.MaxStatusValues["engine"] .. " ("..MRFW.Shared.Items["advancedrepairkit"]["label"]..")", round(statusList["body"]) .. "/" .. Config.MaxStatusValues["body"] .. " ("..MRFW.Shared.Items[Config.RepairCost["body"]]["label"]..")", round(statusList["radiator"]) .. "/" .. Config.MaxStatusValues["radiator"] .. ".0 ("..MRFW.Shared.Items[Config.RepairCost["radiator"]]["label"]..")", round(statusList["axle"]) .. "/" .. Config.MaxStatusValues["axle"] .. ".0 ("..MRFW.Shared.Items[Config.RepairCost["axle"]]["label"]..")", round(statusList["brakes"]) .. "/" .. Config.MaxStatusValues["brakes"] .. ".0 ("..MRFW.Shared.Items[Config.RepairCost["brakes"]]["label"]..")", round(statusList["clutch"]) .. "/" .. Config.MaxStatusValues["clutch"] .. ".0 ("..MRFW.Shared.Items[Config.RepairCost["clutch"]]["label"]..")", round(statusList["fuel"]) .. "/" .. Config.MaxStatusValues["fuel"] .. ".0 ("..MRFW.Shared.Items[Config.RepairCost["fuel"]]["label"]..")"}
        })
    end
end

function round(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 1) .. "f", num))
end

-- Menu Functions

CloseMenu = function()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
end

ClearMenu = function()
	--Menu = {}
	Menu.GUI = {}
	Menu.buttonCount = 0
	Menu.selection = 0
end

function noSpace(str)
    local normalisedString = string.gsub(str, "%s+", "")
    return normalisedString
end

function CheckPlayers(vehicle)
    for i = -1, 5,1 do                
        seat = GetPedInVehicleSeat(vehicle,i)
        if seat ~= 0 then
            TaskLeaveVehicle(seat,vehicle,4)
            SetVehicleDoorsLocked(vehicle)
            Wait(1500)
            MRFW.Functions.DeleteVehicle(vehicle)
            
        end
   end
   if showText then
    exports['mr-text']:HideText(1)
    showText = false
end
end
-- Citizen.CreateThread(function()
--     while true do
--         local inRange = false

--         if LocalPlayer.state['isLoggedIn'] then
--             if PlayerJob.name == "tunnermechanic" then
--                 -- if onDuty then
                
--                     for k, v in pairs(Config.Plates) do
--                         if k ~= 1 and k ~= 2 and k ~= 3 then
--                             if PlayerJob.name == v.job then
--                                 if v.AttachedVehicle == nil then
--                                     local PlateDistance = #(pos - vector3(v.coords.x, v.coords.y, v.coords.z))
--                                     if PlateDistance < 5 then
--                                         inRange = true
--                                         DrawMarker(2, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 255, 255, 255, 255, 0, 0, 0, 1, 0, 0, 0)
--                                         if PlateDistance < 2 then
--                                             local veh = GetVehiclePedIsIn(PlayerPedId())
--                                             if IsPedInAnyVehicle(PlayerPedId()) then
--                                                 if not IsThisModelABicycle(GetEntityModel(veh)) then
--                                                     if not showText then
--                                                         exports['mr-text']:DrawText(
--                                                             '[E] Place The Vehicle On The Platform ',
--                                                             0, 94, 255,0.7,
--                                                             1,
--                                                             50
--                                                         )
--                                                         showText = true
--                                                     end
--                                                     -- DrawText3Ds(v.coords.x, v.coords.y, v.coords.z + 0.3, "[E] Place The Vehicle On The Platform")
--                                                     if IsControlJustPressed(0, 38) then
--                                                         DoScreenFadeOut(150)
--                                                         Wait(150)
--                                                         Config.Plates[ClosestPlate].AttachedVehicle = veh
--                                                         SetEntityCoords(veh, v.coords)
--                                                         SetEntityHeading(veh, v.coords.w)
--                                                         FreezeEntityPosition(veh, true)
--                                                         Wait(500)
--                                                         DoScreenFadeIn(250)
--                                                         TriggerServerEvent('mr-vehicletuning:server:SetAttachedVehicle', veh, k)
--                                                         if showText then
--                                                             exports['mr-text']:HideText(1)
--                                                             showText = false
--                                                         end
--                                                     end
--                                                 else
--                                                     MRFW.Functions.Notify("You Cannot Put Bicycles On The Platform!", "error")
--                                                 end
--                                             end
--                                         else
--                                             if showText then
--                                                 exports['mr-text']:HideText(1)
--                                                 showText = false
--                                             end
--                                         end
--                                     end
--                                 else
--                                     local PlateDistance = #(pos - vector3(v.coords.x, v.coords.y, v.coords.z))
--                                     if PlateDistance < 2 then
--                                         inRange = true
--                                         if not showText2 then
--                                             exports['mr-text']:DrawText(
--                                                 '[E] Open Menu ',
--                                                 0, 94, 255,0.7,
--                                                 2,
--                                                 50
--                                             )
--                                             showText2 = true
--                                         end
--                                         -- DrawText3Ds(v.coords.x, v.coords.y, v.coords.z, "[E] Open Menu")
--                                         if IsControlJustPressed(0, 38) then
--                                             -- if IsPedInAnyVehicle(PlayerPedId(), false) then
--                                                 -- MRFW.Functions.Notify('Chalo Gadi se neeche uttar ke repiar karo', 'error', 3000)
--                                             -- else
--                                                 -- OpenMenu()
--                                                 Custom_menu()
--                                                 -- Menu.hidden = not Menu.hidden
--                                             -- end
--                                         end
--                                         -- Menu.renderGUI()
--                                     else
--                                         if showText2 then
--                                             exports['mr-text']:HideText(2)
--                                             showText2 = false
--                                         end
--                                     end
--                                 end
--                             end
--                         end
--                     end
--                 -- end

--                 if not inRange then
--                     Citizen.Wait(1500)
--                 end
--             else
--                 Citizen.Wait(1500)
--             end
--         else
--             Citizen.Wait(1500)
--         end

--         Citizen.Wait(3)
--     end
-- end)

CreateThread(function()
    while true do
        sleep = 2000
        if LocalPlayer.state.isLoggedIn then
            if PlayerJob.name == "bennys" or PlayerJob.name == "mechanic" then
                if onDuty then
                    local ped = PlayerPedId()
                    local pos = GetEntityCoords(ped)
                    for k,v in pairs(Config.Plates) do
                        local variable = 0
                        for ignore = 1, #v.ignore do
                            if v.ignore[ignore] == k then
                                variable = v.variable
                            end
                        end
                        if variable == 1 then
                            if PlayerJob.name == v.job then
                                if v.AttachedVehicle == nil then
                                    local PlateDistance = #(pos - vector3(v.coords.x, v.coords.y, v.coords.z))
                                    if PlateDistance < 5 then
                                        sleep = 5
                                        DrawMarker(2, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 255, 255, 255, 255, 0, 0, 0, 1, 0, 0, 0)
                                        if PlateDistance < 2 then
                                            local veh = GetVehiclePedIsIn(PlayerPedId())
                                            if IsPedInAnyVehicle(PlayerPedId()) then
                                                if not IsThisModelABicycle(GetEntityModel(veh)) then
                                                    if not showText then
                                                        exports['mr-text']:DrawText(
                                                            '[E] Place The Vehicle On The Platform ',
                                                            0, 94, 255,0.7,
                                                            1,
                                                            50
                                                        )
                                                        showText = true
                                                    end
                                                    if IsControlJustPressed(0, 38) then
                                                        DoScreenFadeOut(150)
                                                        Wait(150)
                                                        Config.Plates[ClosestPlate].AttachedVehicle = veh
                                                        SetEntityCoords(veh, v.coords)
                                                        SetEntityHeading(veh, v.coords.w)
                                                        FreezeEntityPosition(veh, true)
                                                        Wait(500)
                                                        DoScreenFadeIn(250)
                                                        TriggerServerEvent('mr-vehicletuning:server:SetAttachedVehicle', veh, k)
                                                        if showText then
                                                            exports['mr-text']:HideText(1)
                                                            showText = false
                                                        end
                                                    end
                                                else
                                                    MRFW.Functions.Notify("You Cannot Put Bicycles On The Platform!", "error")
                                                end
                                            end
                                        else
                                            if showText then
                                                exports['mr-text']:HideText(1)
                                                showText = false
                                            end
                                        end
                                    end
                                else
                                    local PlateDistance = #(pos - vector3(v.coords.x, v.coords.y, v.coords.z))
                                    if PlateDistance < 2 then
                                        sleep = 5
                                        if not showText2 then
                                            exports['mr-text']:DrawText(
                                                '[E] Open Menu ',
                                                0, 94, 255,0.7,
                                                2,
                                                50
                                            )
                                            showText2 = true
                                        end
                                        if IsControlJustPressed(0, 38) then
                                            Custom_menu()
                                        end
                                    else
                                        if showText2 then
                                            exports['mr-text']:HideText(2)
                                            showText2 = false
                                        end
                                    end
                                end
                            end
                        elseif variable == 2 then
                            if PlayerJob.name == v.job then
                                if v.AttachedVehicle == nil then
                                    local PlateDistance = #(pos - vector3(v.coords.x, v.coords.y, v.coords.z))
                                    if PlateDistance < 5 then
                                        sleep = 5
                                        DrawMarker(2, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 255, 255, 255, 255, 0, 0, 0, 1, 0, 0, 0)
                                        if PlateDistance < 2 then
                                            local veh = GetVehiclePedIsIn(PlayerPedId())
                                            if IsPedInAnyVehicle(PlayerPedId()) then
                                                if not IsThisModelABicycle(GetEntityModel(veh)) then
                                                    if not showText then
                                                        exports['mr-text']:DrawText(
                                                            '[E] Place The Vehicle On The Platform ',
                                                            0, 94, 255,0.7,
                                                            1,
                                                            50
                                                        )
                                                        showText = true
                                                    end
                                                    if IsControlJustPressed(0, 38) then
                                                        DoScreenFadeOut(150)
                                                        Wait(150)
                                                        Config.Plates[ClosestPlate].AttachedVehicle = veh
                                                        SetEntityCoords(veh, v.coords)
                                                        SetEntityHeading(veh, v.coords.w)
                                                        FreezeEntityPosition(veh, true)
                                                        Wait(500)
                                                        DoScreenFadeIn(250)
                                                        TriggerServerEvent('mr-vehicletuning:server:SetAttachedVehicle', veh, k)
                                                        if showText then
                                                            exports['mr-text']:HideText(1)
                                                            showText = false
                                                        end
                                                    end
                                                else
                                                    MRFW.Functions.Notify("You Cannot Put Bicycles On The Platform!", "error")
                                                end
                                            end
                                        else
                                            if showText then
                                                exports['mr-text']:HideText(1)
                                                showText = false
                                            end
                                        end
                                    end
                                else
                                    local PlateDistance = #(pos - vector3(v.coords.x, v.coords.y, v.coords.z))
                                    if PlateDistance < 2 then
                                        sleep = 5
                                        if not showText2 then
                                            exports['mr-text']:DrawText(
                                                '[E] Open Menu ',
                                                0, 94, 255,0.7,
                                                2,
                                                50
                                            )
                                            showText2 = true
                                        end
                                        if IsControlJustPressed(0, 38) then
                                            Custom_menu()
                                        end
                                    else
                                        if showText2 then
                                            exports['mr-text']:HideText(2)
                                            showText2 = false
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        Wait(sleep)
    end
end)

AddEventHandler('onResourceStop', function(resource)
   if resource == GetCurrentResourceName() then
    exports['mr-eye']:RemoveZone("benny-stash")
   end
end)

RegisterNetEvent('mechanic:bennys:pstash', function()
    local Player = MRFW.Functions.GetPlayerData()
    TriggerEvent("inventory:client:SetCurrentStash", "personalmecstash_"..Player.citizenid)
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "personalmecstash_"..Player.citizenid,{
        maxweight = 4000000,
        slots = 500,
    })
end)

RegisterNetEvent('mechanic:bennys:mstash', function()
    TriggerEvent("inventory:client:SetCurrentStash", "bennys_shop_stashes")
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "bennys_shop_stashes",{
        maxweight = 4000000,
        slots = 500,
    })
end)