local inWatch = false
local PlayerData = MRFW.Functions.GetPlayerData()
-- local isLoggedIn = LocalPlayer.state.isLoggedIn
local hasFitbit = false

RegisterNetEvent('MRFW:Client:OnPlayerLoaded', function()
    PlayerData = MRFW.Functions.GetPlayerData()
    hasFitbit = MRFW.Functions.HasItem('fitbit')
end)

RegisterNetEvent('MRFW:Client:OnPlayerUnload', function()
    hasFitbit = false
    PlayerData = {}
end)

RegisterNetEvent('MRFW:Client:SetPlayerData', function(val)
    PlayerData = val
    hasFitbit = MRFW.Functions.HasItem('fitbit')
end)

function openWatch()
    SendNUIMessage({
        action = "openWatch",
        watchData = {}
    })
    SetNuiFocus(true, true)
    inWatch = true
end

function closeWatch()
    SetNuiFocus(false, false)
end

RegisterNUICallback('close', function()
    closeWatch()
end)

RegisterNetEvent('mr-fitbit:use')
AddEventHandler('mr-fitbit:use', function()
  openWatch(true)
end)

RegisterNUICallback('setFoodWarning', function(data)
    local foodValue = tonumber(data.value)

    TriggerServerEvent('mr-fitbit:server:setValue', 'food', foodValue)

    MRFW.Functions.Notify('Fitbit: Hunger warning set to '..foodValue..'%')
end)

RegisterNUICallback('setThirstWarning', function(data)
    local thirstValue = tonumber(data.value)

    TriggerServerEvent('mr-fitbit:server:setValue', 'thirst', thirstValue)

    MRFW.Functions.Notify('Fitbit: Thirst warning set to '..thirstValue..'%')
end)

Citizen.CreateThread(function()
    while true do

        Citizen.Wait(5 * 60 * 1000)
        
        if LocalPlayer.state['isLoggedIn'] then
            if hasFitbit then
                if PlayerData.metadata["fitbit"].food ~= nil then
                    if PlayerData.metadata["hunger"] < PlayerData.metadata["fitbit"].food then
                        TriggerEvent("chatMessage", "FITBIT ", "warning", "Your hunger is "..round(PlayerData.metadata["hunger"], 2).."%")
                        PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
                    end
                end
    
                if PlayerData.metadata["fitbit"].thirst ~= nil then
                    if PlayerData.metadata["thirst"] < PlayerData.metadata["fitbit"].thirst  then
                        TriggerEvent("chatMessage", "FITBIT ", "warning", "Your thirst is "..round(PlayerData.metadata["thirst"], 2).."%")
                        PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
                    end
                end
            end
        end
    end
end)

function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end
