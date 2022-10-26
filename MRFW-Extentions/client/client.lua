local Telepoters = {}
local crafting  = nil
MRFW = exports['mrfw']:GetCoreObject()
PlayerData =  MRFW.Functions.GetPlayerData()

RegisterNetEvent('MRFW:Client:OnPlayerLoaded', function()
    PlayerData = MRFW.Functions.GetPlayerData()
    MRFW.Functions.TriggerCallback('jacob:get:it', function(a)
		Telepoters = a
	end)
    MRFW.Functions.TriggerCallback('jacob:get:c', function(a)
		crafting = a
	end)
end)

RegisterNetEvent('MRFW:Client:OnPlayerUnload', function()
    PlayerData = {}
end)

RegisterNetEvent('MRFW:Player:SetPlayerData', function(val)
    PlayerData = val
end)

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

AddEventHandler('onResourceStart', function(resource)
   if resource == GetCurrentResourceName() then
    MRFW.Functions.TriggerCallback('jacob:get:it', function(a)
		Telepoters = a
	end)
    MRFW.Functions.TriggerCallback('jacob:get:c', function(a)
		crafting = a
	end)
   end
end)

local JustTeleported = false

local function LoadAnimationDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(1)
    end
end

local function OpenDoorAnimation()
    local ped = PlayerPedId()

    LoadAnimationDict("anim@heists@keycard@") 
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.1)
    TaskPlayAnim(ped, "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0)
    Citizen.Wait(400)
    ClearPedTasks(ped)
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

local function ResetTeleport()
    SetTimeout(1000, function()
        JustTeleported = false
    end)
end

RegisterNetEvent('Custom:Teleport:me', function(data)
    local ped = PlayerPedId()
    OpenDoorAnimation()
    Citizen.Wait(500)
    DoScreenFadeOut(250)
    Citizen.Wait(250)
    SetEntityCoords(ped, data.x, data.y, data.z)
    SetEntityHeading(ped, data.w)
    Citizen.Wait(1000)
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_close", 0.1)
    DoScreenFadeIn(250)
end)

local showText = false

AddEventHandler('onResourceStop', function(resource)
   if resource == GetCurrentResourceName() then
    exports['mr-text']:HideText(1)
   end
end)

CreateThread(function()
    while true do
        local inRange = false
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        if Telepoters ~= nil then
            for loc,_ in pairs(Telepoters) do
                for k, v in pairs(Telepoters[loc]) do
                    local dist = #(pos - vector3(v.coords.x, v.coords.y, v.coords.z))
                    if dist < 2 then
                        if dist < 1 then
                            if v.show then
                                if not showText then
                                    showText = true
                                    exports['mr-text']:DrawText(
                                        v.drawText,
                                        175,0,0,0.7,
                                        1,
                                        50
                                    )
                                end
                            end
                            if v.show then
                                inRange = true
                                if IsControlJustReleased(0, 51) then
                                    showText = false
                                    exports['mr-text']:HideText(1)
                                    if v.anim then
                                        OpenDoorAnimation()
                                        Citizen.Wait(500)
                                        DoScreenFadeOut(250)
                                        Citizen.Wait(250)
                                        if k == 1 then
                                            if v.show then
                                                if v["AllowVehicle"] then
                                                    SetPedCoordsKeepVehicle(ped, Telepoters[loc][2].coords.x, Telepoters[loc][2].coords.y, Telepoters[loc][2].coords.z)
                                                else
                                                    SetEntityCoords(ped, Telepoters[loc][2].coords.x, Telepoters[loc][2].coords.y, Telepoters[loc][2].coords.z)
                                                end

                                                if type(Telepoters[loc][2].coords) == "vector4" then
                                                    SetEntityHeading(ped, Telepoters[loc][2].coords.w)
                                                end
                                            end
                                        elseif k == 2 then
                                            if v.show then
                                                if v["AllowVehicle"] then
                                                    SetPedCoordsKeepVehicle(ped, Telepoters[loc][1].coords.x, Telepoters[loc][1].coords.y, Telepoters[loc][1].coords.z)
                                                else
                                                    SetEntityCoords(ped, Telepoters[loc][1].coords.x, Telepoters[loc][1].coords.y, Telepoters[loc][1].coords.z)
                                                end

                                                if type(Telepoters[loc][1].coords) == "vector4" then
                                                    SetEntityHeading(ped, Telepoters[loc][1].coords.w)
                                                end
                                            end
                                        end
                                        Citizen.Wait(1000)
                                        TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_close", 0.1)
                                        DoScreenFadeIn(250)
                                        ResetTeleport()
                                    else
                                        if v.show then
                                            Citizen.Wait(500)
                                            DoScreenFadeOut(250)
                                            Citizen.Wait(250)
                                        end
                                        if k == 1 then
                                            if v.show then
                                                if v["AllowVehicle"] then
                                                    SetPedCoordsKeepVehicle(ped, Telepoters[loc][2].coords.x, Telepoters[loc][2].coords.y, Telepoters[loc][2].coords.z)
                                                else
                                                    SetEntityCoords(ped, Telepoters[loc][2].coords.x, Telepoters[loc][2].coords.y, Telepoters[loc][2].coords.z)
                                                end

                                                if type(Telepoters[loc][2].coords) == "vector4" then
                                                    SetEntityHeading(ped, Telepoters[loc][2].coords.w)
                                                end
                                            end
                                        elseif k == 2 then
                                            if v.show then
                                                if v["AllowVehicle"] then
                                                    SetPedCoordsKeepVehicle(ped, Telepoters[loc][1].coords.x, Telepoters[loc][1].coords.y, Telepoters[loc][1].coords.z)
                                                else
                                                    SetEntityCoords(ped, Telepoters[loc][1].coords.x, Telepoters[loc][1].coords.y, Telepoters[loc][1].coords.z)
                                                end

                                                if type(Telepoters[loc][1].coords) == "vector4" then
                                                    SetEntityHeading(ped, Telepoters[loc][1].coords.w)
                                                end
                                            end
                                        end
                                        if v.show then
                                            Citizen.Wait(1000)
                                            DoScreenFadeIn(250)
                                        end
                                        ResetTeleport()
                                    end
                                end
                            end
                        else
                            if showText then
                                showText = false
                                exports['mr-text']:HideText(1)
                            end
                        end
                    end
                end
            end
        end

        if not inRange then
            Wait(2000)
        end

        Wait(5)
    end
end)

local doingLockHack = false
Citizen.CreateThread(function()
    while true do
        sleep = 2500
        if crafting ~= nil then
            sleep = 2000
            local ped = PlayerPedId()      
            if IsPedInAnyPlane(ped) then
                sleep = 5
                SetVehicleEngineOn(GetVehiclePedIsIn(ped, false), true, true, true)
            end
        end
        Citizen.Wait(sleep)
    end
end)

RegisterNetEvent('crafting:hack', function()
    local exitCoords = vector3(998.29, -2390.82, 30.14)
    if not doingLockHack then
        doingLockHack = true
        TriggerEvent('ultra-voltlab', math.random(10,60), function(result,reason)
            if result == 0 then
                doingLockHack = true
                MRFW.Functions.Notify('Failed because of wrong placement of wires', 'error', 3000)
            elseif result == 1 then
                doingLockHack = false
                OpenDoorAnimation()
                SetEntityCoords(PlayerPedId(), exitCoords)
            elseif result == 2 then
                doingLockHack = true
                MRFW.Functions.Notify('Failed because of timeout', 'error', 3000)
            elseif result == -1 then
                doingLockHack = true
                MRFW.Functions.Notify('Failed Because of an error contact Developer ASAP', 'error', 3000)
            end
        end)
    end
end)

RegisterNetEvent('crafting:return', function()
    DoScreenFadeOut(250)
    OpenDoorAnimation()
    SetEntityCoords(PlayerPedId(), crafting)
    Citizen.Wait(250)
    DoScreenFadeIn(250)
end)

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(500)
--         ped = PlayerPedId()
--         if not IsPedInAnyVehicle(ped, false) then
--             if IsPedUsingActionMode(ped) then
--                 SetPedUsingActionMode(ped, -1, -1, 1)
--             end
--         else
--             Citizen.Wait(3000)
--         end
--     end
-- end)
--------------------------lua injecter fix-----------------

local function collectAndSendResourceList()
    local resourceList = {}
    for i=0,GetNumResources()-1 do
        resourceList[i+1] = GetResourceByFindIndex(i)
    end
    TriggerServerEvent("ac:server:checkMyResources", resourceList)
end

CreateThread(function()
    while true do
        collectAndSendResourceList()
        Citizen.Wait(15000)
    end
end)

-- local loc ={
--     [1] = vector3(106.55, -1305.67, 28.79),
--     [2] = vector3(921.89, 28.66, 71.83),
-- } 

-- local locations = {
--     ['vu'] = {
--         coords = vector3(106.55, -1305.67, 28.79),
--         type = false
--     },
--     -- ['cityhall'] = {
--     --     coords = vector3(-1309.53, -548.92, 30.57),
--     --     type = false
--     -- },
--     ['casino'] = {
--         coords = vector3(921.89, 28.66, 71.83),
--         type = true
--     }
-- }

-- CreateThread(function()
--     while true do
--         sleep = 2500
--         if LocalPlayer.state['isLoggedIn'] then
--             sleep = 1500
--             local pos = GetEntityCoords(PlayerPedId())
--             for k,v in pairs(locations) do
--                 if v.type then
--                     local dist = #(pos - v.coords)
--                     if dist < 5 then
--                         sleep = 5
--                         DrawMarker(2, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.4, 0.2, 255, 255, 255, 255, 0, 0, 0, 1, 0, 0, 0)
--                         if dist < 2 then
--                             DrawText3D(v.coords.x, v.coords.y, v.coords.z, '~g~E~w~ - Outfits')
--                             if IsControlJustPressed(0, 38) then -- E
--                                 TriggerEvent('mr-clothing:client:openClothingMenu')
--                             end
--                         end
--                     end
--                 else
--                     local dist = #(pos - v.coords)
--                     if dist < 5 then
--                         sleep = 5
--                         DrawMarker(2, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.4, 0.2, 255, 255, 255, 255, 0, 0, 0, 1, 0, 0, 0)
--                         if dist < 2 then
--                             DrawText3D(v.coords.x, v.coords.y, v.coords.z, '~g~E~w~ - Outfits')
--                             if IsControlJustPressed(0, 38) then -- E
--                                 TriggerEvent('mr-clothing:client:openOutfitMenu')
--                             end
--                         end
--                     end
--                 end
--             end
--         end
--         Wait(sleep)
--     end
-- end)