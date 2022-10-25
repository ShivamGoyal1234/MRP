local MRFW = exports['mrfw']:GetCoreObject()
local PlayerData = {}
local loop = false
local function DrawText3Ds(x, y, z, text)
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
local function job()
    loop = true
    while loop do
        sleep = 2000
        if LocalPlayer.state.isLoggedIn then
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local stash = Config.Locations["stash"]
            local duty = Config.Locations["duty"]
            local storage = Config.Locations["storage"]
            local dist_stash = #(pos - stash)
            local dist_duty  = #(pos - duty)
            local dist_Storage = #(pos - storage)
            if PlayerData.job.onduty then
                if dist_stash <= 5 then
                    sleep = 5
                    DrawMarker(2, stash, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 210, 50, 9, 255, false, false, false, true, false, false, false)
                    if dist_stash <= 1 then
                        DrawText3Ds(stash.x,stash.y,stash.z, "[E] Open Stash")
                        if IsControlJustPressed(0, 38) then
                            TriggerEvent("inventory:client:SetCurrentStash", "bahamasstash")
                            TriggerServerEvent("inventory:server:OpenInventory", "stash", "bahamasstash", {
                                maxweight = 4000000,
                                slots = 500,
                            })
                        end
                    end
                end
                if dist_Storage <= 5 then
                    sleep = 5
                    DrawMarker(2, storage, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 210, 50, 9, 255, false, false, false, true, false, false, false)
                    if dist_Storage <= 1 then
                        DrawText3Ds(storage.x,storage.y,storage.z, "[E] Storage")
                        if IsControlJustPressed(0, 38) then
                            TriggerEvent('dpemote:custom:animation', {"leanbar"})
                            TriggerServerEvent("inventory:server:OpenInventory", "shop", 'bahamas', Config.bahamas)
                            Citizen.Wait(3000)
                            TriggerEvent('dpemote:custom:animation', {"c"})
                        end
                    end
                end
            end
            if dist_duty <= 5 then
                sleep = 5
                DrawMarker(2, duty, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 210, 50, 9, 255, false, false, false, true, false, false, false)
                if dist_duty <= 1 then
                    if not PlayerData.job.onduty then
                        DrawText3Ds(duty.x,duty.y,duty.z, "[E] Go Onduty")
                    else
                        DrawText3Ds(duty.x,duty.y,duty.z, "[E] Go Offduty")
                    end
                    if IsControlJustPressed(0, 38) then
                        TriggerServerEvent("MRFW:ToggleDuty")
                    end
                end
            end
        end
        Wait(sleep)
    end
end
RegisterNetEvent('MRFW:Client:OnPlayerLoaded', function()
    PlayerData = MRFW.Functions.GetPlayerData()
    if PlayerData.job.name == 'bahamas' then
        if not loop then
            job()
        end
    end
end)
RegisterNetEvent('MRFW:Client:OnPlayerUnload', function()
    loop = false
    PlayerData = {}
end)
RegisterNetEvent('MRFW:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
    if PlayerData.job.name == 'bahamas' then
        if not loop then
            job()
        end
    else
        if loop then
            loop = false
        end
    end
end)
RegisterNetEvent('MRFW:Player:SetPlayerData', function(val)
    PlayerData = val
end)
CreateThread(function()
    while true do
        sleep = 2000
        if LocalPlayer.state.isLoggedIn then
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local tray = Config.Locations['openstash']
            local dist = #(pos - tray)
            if dist <= 2 then
                sleep = 5
                DrawText3Ds(tray.x,tray.y,tray.z, "[E] Picking Order")
                if IsControlJustReleased(0, 38) then
                    TriggerEvent("inventory:client:SetCurrentStash", "open_bahamasstash")
                    TriggerServerEvent("inventory:server:OpenInventory", "stash", "open_bahamasstash", {
                        maxweight = 4000000,
                        slots = 500,
                    })
                end
            end
        end
        Wait(sleep)
    end
end)