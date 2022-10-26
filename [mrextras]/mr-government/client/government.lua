isLoggedIn = true
PlayerJob = {}

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


RegisterNetEvent('MRFW:Client:OnPlayerLoaded')
AddEventHandler('MRFW:Client:OnPlayerLoaded', function()
    MRFW.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerJob
        if PlayerJob.onduty then
            if PlayerJob.name == "government" then
                TriggerServerEvent("MRFW:ToggleDuty")
            end
        end
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

Citizen.CreateThread(function()
    local c = Config.Locationsgov["exit"]
    local Blip = AddBlipForCoord(c.x, c.y, c.z)

    SetBlipSprite (Blip, 0)
    SetBlipDisplay(Blip, 0)
    SetBlipScale  (Blip, 0)
    SetBlipAsShortRange(Blip, true)
    SetBlipColour(Blip, 0)
    SetBlipAlpha(Blip, 0)
end)

Citizen.CreateThread(function()
    while true do
        local inRange = false

        if isLoggedIn then
            if PlayerJob.name == "government" or PlayerJob.name == "doj" then
                local pos = GetEntityCoords(PlayerPedId())
                local StashDistance = GetDistanceBetweenCoords(pos, Config.Locationsgov["stash"].x, Config.Locationsgov["stash"].y, Config.Locationsgov["stash"].z, true)
                local OnDutyDistance = GetDistanceBetweenCoords(pos, Config.Locationsgov["duty"].x, Config.Locationsgov["duty"].y, Config.Locationsgov["duty"].z, true)
                local VehicleDistance = GetDistanceBetweenCoords(pos, Config.Locationsgov["vehicle"].x, Config.Locationsgov["vehicle"].y, Config.Locationsgov["vehicle"].z, true)

                if onDuty then
                    if StashDistance < 20 then
                        inRange = true
                        DrawMarker(2, Config.Locationsgov["stash"].x, Config.Locationsgov["stash"].y, Config.Locationsgov["stash"].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 210, 50, 9, 255, false, false, false, true, false, false, false)

                        if StashDistance < 1 then
                            DrawText3Ds(Config.Locationsgov["stash"].x, Config.Locationsgov["stash"].y, Config.Locationsgov["stash"].z, "[E] Open Stash")
                            if IsControlJustReleased(0, Keys["E"]) then
                                TriggerEvent("inventory:client:SetCurrentStash", "governmentstash")
                                TriggerServerEvent("inventory:server:OpenInventory", "stash", "governmentstash", {
                                    maxweight = 4000000,
                                    slots = 500,
                                })
                            end
                        end
                    end
                end

                if (PlayerJob ~= nil) and PlayerJob.name == "government" and PlayerJob.grade.name == "Employee" then
                    inRange = true
                    if (GetDistanceBetweenCoords(pos, Config.Locationsgov["govtash"].x, Config.Locationsgov["govtash"].y, Config.Locationsgov["govtash"].z, true) < 1.5) then
                        DrawText3Ds(Config.Locationsgov["govtash"].x, Config.Locationsgov["govtash"].y, Config.Locationsgov["govtash"].z, "[E] Government Employee Personal Stash")
                        --exports['mr-textUI']:Open('<span id="e-optionred">[E]</span> Stash <img id="imgx" src="https://cdn.discordapp.com/attachments/699953862706200577/882294060981821490/stash.png">', 'joyzz', 'right')
                        if IsControlJustReleased(0, Keys["E"]) then
                            TriggerServerEvent("inventory:server:OpenInventory", "stash", "Employee"..MRFW.Functions.GetPlayerData().citizenid)
                            TriggerEvent("inventory:client:SetCurrentStash", "Employee"..MRFW.Functions.GetPlayerData().citizenid)
                        end
                    end
                end

                if (PlayerJob ~= nil) and PlayerJob.name == "government" and PlayerJob.grade.name == "State Security" then
                    inRange = true
                    if (GetDistanceBetweenCoords(pos, Config.Locationsgov["psetash"].x, Config.Locationsgov["psetash"].y, Config.Locationsgov["psetash"].z, true) < 1.5) then
                        DrawText3Ds(Config.Locationsgov["psetash"].x, Config.Locationsgov["psetash"].y, Config.Locationsgov["psetash"].z, "[E] Security Head Personal Stash")
                        if IsControlJustReleased(0, Keys["E"]) then
                            TriggerServerEvent("inventory:server:OpenInventory", "stash", "Security"..MRFW.Functions.GetPlayerData().citizenid)
                            TriggerEvent("inventory:client:SetCurrentStash", "Security"..MRFW.Functions.GetPlayerData().citizenid)
                        end
                    end
                end

                if (PlayerJob ~= nil) and PlayerJob.name == "government" and PlayerJob.grade.name == "Security Chief" then
                    inRange = true
                    if (GetDistanceBetweenCoords(pos, Config.Locationsgov["psetash"].x, Config.Locationsgov["psetash"].y, Config.Locationsgov["psetash"].z, true) < 1.5) then
                        DrawText3Ds(Config.Locationsgov["psetash"].x, Config.Locationsgov["psetash"].y, Config.Locationsgov["psetash"].z, "[E] Security Head Personal Stash")
                        if IsControlJustReleased(0, Keys["E"]) then
                            TriggerServerEvent("inventory:server:OpenInventory", "stash", "Security"..MRFW.Functions.GetPlayerData().citizenid)
                            TriggerEvent("inventory:client:SetCurrentStash", "Security"..MRFW.Functions.GetPlayerData().citizenid)
                        end
                    end
                end

                if (PlayerJob ~= nil) and PlayerJob.name == "government" and PlayerJob.grade.name == "Mayor" then
                    inRange = true
                    if (GetDistanceBetweenCoords(pos, Config.Locationsgov["psmtash"].x, Config.Locationsgov["psmtash"].y, Config.Locationsgov["psmtash"].z, true) < 1.5) then
                        DrawText3Ds(Config.Locationsgov["psmtash"].x, Config.Locationsgov["psmtash"].y, Config.Locationsgov["psmtash"].z, "[E] Mayor Personal Stash")
                        if IsControlJustReleased(0, Keys["E"]) then
                            TriggerServerEvent("inventory:server:OpenInventory", "stash", "Mayor"..MRFW.Functions.GetPlayerData().citizenid)
                            TriggerEvent("inventory:client:SetCurrentStash", "Mayor"..MRFW.Functions.GetPlayerData().citizenid)
                        end
                    end
                end

                if (PlayerJob ~= nil) and PlayerJob.name == "government" and PlayerJob.grade.name == "Secretery" then
                    inRange = true
                    if (GetDistanceBetweenCoords(pos, Config.Locationsgov["psstash"].x, Config.Locationsgov["psstash"].y, Config.Locationsgov["psstash"].z, true) < 1.5) then
                        DrawText3Ds(Config.Locationsgov["psstash"].x, Config.Locationsgov["psstash"].y, Config.Locationsgov["psstash"].z, "[E] Secretery Personal Stash")

                        if IsControlJustReleased(0, Keys["E"]) then
                            TriggerServerEvent("inventory:server:OpenInventory", "stash", "Secretery"..MRFW.Functions.GetPlayerData().citizenid)
                            TriggerEvent("inventory:client:SetCurrentStash", "Secretery"..MRFW.Functions.GetPlayerData().citizenid)
                        end
                    end
                end

                if (PlayerJob ~= nil) and PlayerJob.name == "government" and PlayerJob.grade.name == "State Treasure" then
                    inRange = true
                    if (GetDistanceBetweenCoords(pos, Config.Locationsgov["ptstash"].x, Config.Locationsgov["ptstash"].y, Config.Locationsgov["ptstash"].z, true) < 1.5) then
                        DrawText3Ds(Config.Locationsgov["ptstash"].x, Config.Locationsgov["ptstash"].y, Config.Locationsgov["ptstash"].z, "[E] Treasure Personal Stash")
                        if IsControlJustReleased(0, Keys["E"]) then
                            TriggerServerEvent("inventory:server:OpenInventory", "stash", "Treasure"..MRFW.Functions.GetPlayerData().citizenid)
                            TriggerEvent("inventory:client:SetCurrentStash", "Treasure"..MRFW.Functions.GetPlayerData().citizenid)
                        end
                    end
                end

                if (PlayerJob ~= nil) and PlayerJob.name == "government" and PlayerJob.grade.name == "Governor" then
                    inRange = true
                    if (GetDistanceBetweenCoords(pos, Config.Locationsgov["pstash"].x, Config.Locationsgov["pstash"].y, Config.Locationsgov["pstash"].z, true) < 1.5) then
                        DrawText3Ds(Config.Locationsgov["pstash"].x, Config.Locationsgov["pstash"].y, Config.Locationsgov["pstash"].z, "[E] Governor Personal Stash")

                        if IsControlJustReleased(0, Keys["E"]) then
                            TriggerServerEvent("inventory:server:OpenInventory", "stash", "governor_"..MRFW.Functions.GetPlayerData().citizenid)
                            TriggerEvent("inventory:client:SetCurrentStash", "governor_"..MRFW.Functions.GetPlayerData().citizenid)
                        end
                    end
                end

                if (PlayerJob ~= nil) and PlayerJob.name == "government" and PlayerJob.grade.name == "Governor" or PlayerJob.grade.name == "Secretery" or PlayerJob.grade.name == "Mayor" then
                    if onDuty then
                        inRange = true
                        if (GetDistanceBetweenCoords(pos, Config.Locationsgov["armory"].x, Config.Locationsgov["armory"].y, Config.Locationsgov["armory"].z, true) < 1.5) then
                            DrawText3Ds(Config.Locationsgov["armory"].x, Config.Locationsgov["armory"].y, Config.Locationsgov["armory"].z, "[E] Armory")
                            if IsControlJustReleased(0, Keys["E"]) then
                                    -- SetWeaponSeries()
                                TriggerServerEvent("inventory:server:OpenInventory", "shop", 'police', Config.Itemsgov)
                            end
                        end
                    end
                end

                if(PlayerJob ~= nil) and PlayerJob.name == "government" and PlayerJob.grade.name == "Security Chief" or PlayerJob.grade.name == "Security" then
                    if onDuty then
                        inRange = true
                        if (GetDistanceBetweenCoords(pos, Config.Locationsgov["armory1"].x, Config.Locationsgov["armory1"].y, Config.Locationsgov["armory1"].z, true) < 1.5) then
                            DrawText3Ds(Config.Locationsgov["armory1"].x, Config.Locationsgov["armory1"].y, Config.Locationsgov["armory1"].z, "[E] Armory")
                            if IsControlJustReleased(0, Keys["E"]) then
                                    -- SetWeaponSeries()
                                TriggerServerEvent("inventory:server:OpenInventory", "shop", 'police', Config.Items1gov)
                            end
                        end
                    end
                end

                if onDuty then
                    if VehicleDistance < 20 then
                        inRange = true
                        DrawMarker(2, Config.Locationsgov["vehicle"].x, Config.Locationsgov["vehicle"].y, Config.Locationsgov["vehicle"].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 210, 50, 9, 255, false, false, false, true, false, false, false)
                        if VehicleDistance < 1 then
                            local InVehicle = IsPedInAnyVehicle(PlayerPedId())

                            if InVehicle then
                                DrawText3Ds(Config.Locationsgov["vehicle"].x, Config.Locationsgov["vehicle"].y, Config.Locationsgov["vehicle"].z, '[E]Park vehicle')
                                if IsControlJustPressed(0, Keys["E"]) then
                                    DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
                                end
                            else
                                DrawText3Ds(Config.Locationsgov["vehicle"].x, Config.Locationsgov["vehicle"].y, Config.Locationsgov["vehicle"].z, '[E] Grab vehicle')
                                if IsControlJustPressed(0, Keys["E"]) then
                                    if IsControlJustPressed(0, Keys["E"]) then
                                        VehicleList()
                                        Menu.hidden = not Menu.hidden
                                    end
                                end
                                Menu.renderGUI()
                            end
                        end
                    end
                end

                -- if OnDutyDistance < 20 then
                --     inRange = true
                --     DrawMarker(2, Config.Locationsgov["duty"].x, Config.Locationsgov["duty"].y, Config.Locationsgov["duty"].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 210, 50, 9, 255, false, false, false, true, false, false, false)

                --     if OnDutyDistance < 1 then
                --         if not onDuty then
                --             DrawText3Ds(Config.Locationsgov["duty"].x, Config.Locationsgov["duty"].y, Config.Locationsgov["duty"].z, "[E] On Duty")
                --         else
                --             DrawText3Ds(Config.Locationsgov["duty"].x, Config.Locationsgov["duty"].y, Config.Locationsgov["duty"].z, "[E] Off Duty")
                --         end
                --         if IsControlJustReleased(0, Keys["E"]) then
                --             TriggerServerEvent("MRFW:ToggleDuty")
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

RegisterNetEvent('government:ToggleDuty', function()
    onDuty = not onDuty
    TriggerServerEvent("MRFW:ToggleDuty")
end)

function niks()
    -- print('niks')
end

function OpenMenu()
    ClearMenu()
    Menu.addButton("Options", "VehicleOptions", nil)
    Menu.addButton("Close Menu", "CloseMenu", nil) 
end

function VehicleList()
    ClearMenu()
    for k, v in pairs(Config.Vehiclesgov) do
        Menu.addButton(v, "SpawnListVehicle", k) 
    end
    Menu.addButton("Close Menu", "CloseMenu", nil) 
end

function SpawnListVehicle(model)
    local coords = {
        x = Config.Locationsgov["vehicle"].x,
        y = Config.Locationsgov["vehicle"].y,
        z = Config.Locationsgov["vehicle"].z,
        h = Config.Locationsgov["vehicle"].h,
    }
    local plate = "GOV"..math.random(1111, 9999)
    MRFW.Functions.SpawnVehicle(model, function(veh)
        SetVehicleNumberPlateText(veh, "GOV"..tostring(math.random(1000, 9999)))
        exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'body', 1000.0)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'engine', 1000.0)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'fuel', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'clutch', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'brakes', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'axle', 100)
		    exports['mr-mechanicjob']:SetVehicleStatus(MRFW.Functions.GetPlate(veh), 'radiator', 100)
        SetEntityHeading(veh, coords.h)
        exports['mr-fuel']:SetFuel(veh, 100.0)
        Menu.hidden = true
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", MRFW.Functions.GetPlate(veh))
        SetVehicleCustomPrimaryColour(veh, 0, 0, 0)
        SetVehicleEngineOn(veh, true, true)
        SetVehicleDirtLevel(veh)
        SetVehicleUndriveable(veh, false)
        WashDecalsFromVehicle(veh, 1.0)
    end, coords, true)
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