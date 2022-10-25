AJFW = exports['ajfw']:GetCoreObject()

local isLoggedIn = false
local AlertActive = false
PlayerData = {}
PlayerJob = {}

-- Code

Citizen.CreateThread(function()
    Wait(100)
    if AJFW.Functions.GetPlayerData() ~= nil then
        PlayerData = AJFW.Functions.GetPlayerData()
        PlayerJob = PlayerData.job
    end
end)

RegisterNetEvent('AJFW:Client:OnJobUpdate')
AddEventHandler('AJFW:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    if JobInfo.name == "police" then
        if PlayerJob.onduty then
            PlayerJob.onduty = false
        end
    end
    PlayerJob.onduty = true
end)

RegisterNetEvent('AJFW:Client:OnPlayerLoaded')
AddEventHandler('AJFW:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerData =  AJFW.Functions.GetPlayerData()
    PlayerJob = AJFW.Functions.GetPlayerData().job
end)

RegisterNetEvent('aj-policealerts:ToggleDuty')
AddEventHandler('aj-policealerts:ToggleDuty', function(Duty)
    PlayerJob.onduty = Duty
end)

RegisterNetEvent('aj-policealerts:client:AddPoliceAlert')
AddEventHandler('aj-policealerts:client:AddPoliceAlert', function(data, forBoth)
    if forBoth then
        if (PlayerJob.name == "police" or PlayerJob.name == "doctor" ) and PlayerJob.onduty then
            if data.alertTitle == "Assistance colleague" or data.alertTitle == "Ambulance assistance" or data.alertTitle == "Doctor assistance" then
                TriggerServerEvent("InteractSound_SV:PlayOnSource", "emergency", 0.7)
            else
                PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
            end
            data.callSign = data.callSign ~= nil and data.callSign or PlayerData.metadata["callsign"]
            data.alertId = math.random(11111, 99999)
            SendNUIMessage({
                action = "add",
                data = data,
            })
        end
    else
        if (PlayerJob.name == "police" and PlayerJob.onduty) then
            if data.alertTitle == "Assistance colleague" or data.alertTitle == "Ambulance assistance" or data.alertTitle == "Doctor assistance" then
                TriggerServerEvent("InteractSound_SV:PlayOnSource", "emergency", 0.7)
            else
                PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
            end
            data.callSign = data.callSign ~= nil and data.callSign or PlayerData.metadata["callsign"]
            data.alertId = math.random(11111, 99999)
            SendNUIMessage({
                action = "add",
                data = data,
            })
        end 
    end

    AlertActive = true
    SetTimeout(data.timeOut, function()
        AlertActive = false
    end)
end)

-- local alertdata = {
--     timeOut = 10000,
--     alertTitle = "iFruitStore robbery attempt",
--     coords = GetEntityCoords(PlayerPedId()),
--     details = {
--         [1] = {
--             icon = '<i class="fas fa-university"></i>',
--             detail = bank,
--         },
--         [2] = {
--             icon = '<i class="fas fa-video"></i>',
--             detail = cameraId,
--         },
--         [3] = {
--             icon = '<i class="fas fa-globe-europe"></i>',
--             detail = streetLabel,
--         },
--     },
--     callSign = AJFW.Functions.GetPlayerData().metadata["callsign"],
-- }

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(5)
--         if IsControlJustPressed(0, 38) then
--             TriggerEvent('aj-policealerts:client:AddPoliceAlert', alertdata)
--         end
--     end
-- end)

-- Citizen.CreateThread(function()
--     while true do
--         if AlertActive then
--             if IsControlJustPressed(0, Keys["LEFTALT"] ) then
--                 SetNuiFocus(true, true)
--                 SetNuiFocusKeepInput(true, false)
--                 SetCursorLocation(0.965, 0.12)
--                 MouseActive = true
--             end
--         end

--         if MouseActive then
--             if IsControlJustReleased(0, Keys["LEFTALT"] ) then
--                 SetNuiFocus(false, false)
--                 SetNuiFocusKeepInput(false, false)
--                 MouseActive = false
--             end
--         end

--         Citizen.Wait(6)
--     end
-- end)

RegisterNUICallback('SetWaypoint', function(data)
    local coords = data.coords

    SetNewWaypoint(coords.x, coords.y)
    AJFW.Functions.Notify('GPS set!')
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false, false)
    MouseActive = false
end)

-- Citizen.CreateThread(function()
--     Wait(500)
--     local ped = PlayerPedId()
--     local veh = GetVehiclePedIsIn(ped)

--     exports["vstancer"]:SetVstancerPreset(veh, -0.8, 0.0, -0.8, 0.0)
-- end)


-- #The max value you can increase or decrease the front Track Width
-- frontMaxOffset=0.25

-- #The max value you can increase or decrease the front Camber
-- frontMaxCamber=0.20

-- #The max value you can increase or decrease the rear Track Width
-- rearMaxOffset=0.25

-- #The max value you can increase or decrease the rear Camber
-- rearMaxCamber=0.20