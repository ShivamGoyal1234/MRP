local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["T"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
  }

AJFW = nil
local AJFW = exports['ajfw']:GetCoreObject()

local mining = false
local textDel = Config.textDel
local canve = Config.canve
local textgar = Config.textgar
local ClosestBerth = 1
local sellX4 = 1205.84  
local sellY4 = -1271.42
local sellZ4 = 35.23
local model1 = Config.ModelCar --model
local delX = 1187.84  --del auto 
local delY = -1286.76
local delZ = 34.95
local HasVehicle = true


RegisterNetEvent('aj-applejob:collect', function()
    -- local player, distance = AJFW.Functions.GetClosestPlayer()
    -- if distance == -1 or distance >= 4.0 then
    --     mining = true
        FreezeEntityPosition(PlayerPedId(), true)
        TriggerEvent('close:inventory:bug')
        SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'))
        TriggerEvent('dpemote:custom:animation', {"mechanic5"})
        AJFW.Functions.Progressbar('drillling stone', 'Picking Apple...', 3000, false, true, { -- Name | Label | Time | useWhileDead | canCancel
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Play When Done
            TriggerEvent('dpemote:custom:animation', {"c"})
            TriggerServerEvent('apple:getItem')
            FreezeEntityPosition(PlayerPedId(), false)
        end, function()
            TriggerEvent('dpemote:custom:animation', {"c"})
            FreezeEntityPosition(PlayerPedId(), false)
        end)
    -- end
end)


-- Citizen.CreateThread(function()
--      while AJFW == nil do
--         TriggerEvent('AJFW:GetObject', function(obj) AJFW = obj end)
--         Citizen.Wait(200)
--     end
--    while AJFW.Functions.GetPlayerData().job == nil do
-- 		Citizen.Wait(10)
--     end
        
-- 	PlayerData = AJFW.Functions.GetPlayerData()
    
--     while true do
--         local closeTo = 0
--         local xp 
--         local yp
--         local zp
--         for k, v in pairs(Config.ApplePosition) do
--             if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.coords, true) <= 2.5 then
--                 closeTo = v
--                 xp = v.coords.x
--                 yp = v.coords.y
--                 zp = v.coords.z
--                 break
--             end
--         end
--         if type(closeTo) == 'table' then
--             while GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), closeTo.coords, true) <= 2.5 do
--                 Wait(0)
               
--                 DrawText3D2(xp, yp, zp+0.97, ''..textDel..'')
               
--                 if IsControlJustReleased(0, 38) then
--                     local player, distance = AJFW.Functions.GetClosestPlayer()
--                     if distance == -1 or distance >= 4.0 then
--                         mining = true
--                         SetEntityCoords(PlayerPedId(), closeTo.coords)
--                         SetEntityHeading(PlayerPedId(), closeTo.heading)
--                         FreezeEntityPosition(PlayerPedId(), true)
-- 						-- local model = loadModel(GetHashKey(Config.Objects['pickaxe']))
--                         -- local axe = CreateObject(model, GetEntityCoords(PlayerPedId()), true, false, false)
--                         -- AttachEntityToEntity(axe, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.09, 0.03, -0.02, -78.0, 13.0, 28.0, false, true, true, true, 0, true)
--                         TriggerEvent('close:inventory:bug')
--                         SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'))
--                         TriggerEvent('dpemote:custom:animation', {"mechanic5"})
--                         AJFW.Functions.Progressbar('drillling stone', 'Picking Apple...', 10000, false, true, { -- Name | Label | Time | useWhileDead | canCancel
--                             disableMovement = true,
--                             disableCarMovement = true,
--                             disableMouse = false,
--                             disableCombat = true,
--                         }, {}, {}, {}, function() -- Play When Done
--                             TriggerEvent('dpemote:custom:animation', {"c"})
--                             TriggerServerEvent('apple:getItem')
--                             FreezeEntityPosition(PlayerPedId(), false)
--                         end, function()
--                             TriggerEvent('dpemote:custom:animation', {"c"})
--                             FreezeEntityPosition(PlayerPedId(), false)
--                         end)
--                     end
--                 end
--             end
--         end
--         Wait(250)
--     end
-- end)



local procesX = 429.14
local procesY = 6476.06
local procesZ = 28.79
------------------------------------

local cooldown = false

RegisterNetEvent('aj-applejob:applejuice', function()
    if not cooldown then
        cooldown = true
        AJFW.Functions.TriggerCallback('apple:ingredient', function(result, cb)
            hasBagd7 = result
            s1d7 = true
        end)
        while(not s1d7) do
            Citizen.Wait(100)
        end
        if (hasBagd7) then
            Processapple()
        else
            AJFW.Functions.Notify('You are missing empty bottle or apples..', 'error')
        end
        Wait(3000)
        cooldown = false
    else
        AJFW.Functions.Notify("You need to finish this one first", 'error')
    end
end)

-- Citizen.CreateThread(function()
--     while true do
--     Wait(3)
-- 	local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
--     local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, procesX, procesY, procesZ)
	
-- 	if dist <= 20.0 then
-- 	DrawMarker(27, procesX, procesY, procesZ-0.96, 0, 0, 0, 0, 0, 0, 2.20, 2.20, 2.20, 255, 255, 255, 200, 0, 0, 0, 0)
-- 	else
-- 	Wait(5)
-- 	end
-- 	local hasBagd7 = false
-- 	local s1d7 = false
-- 	if dist <= 2.0 then
-- 	DrawText3D2(procesX, procesY, procesZ+0.1, "[E] Make Apple Juice")
-- 		if IsControlJustPressed(0, Keys['E']) then 
-- 		AJFW.Functions.TriggerCallback('apple:ingredient', function(result, cb)
-- 					hasBagd7 = result
-- 					s1d7 = true
-- 			end)
-- 			while(not s1d7) do
-- 					Citizen.Wait(100)
-- 				end
-- 			if (hasBagd7) then
-- 		Processapple()
-- 		else
-- 		    AJFW.Functions.Notify('You are missing empty bottle or apples..', 'error')
-- 		end
-- 		end	
-- 	end
	
-- end
-- end)
function Processapple()
    -- local
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local inventory = AJFW.Functions.GetPlayerData().inventory
    local count = 0
    ----
    
    if(count == 0) then
    AJFW.Functions.Progressbar("search_register", "Process..", 5000, false, true, {disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                        disableInventory = true,
                    }, {}, {}, {}, function()end, function()
                        
                    end)
    local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.9, -0.98))
    prop = CreateObject(GetHashKey('hei_prop_heist_box'), x, y, z,  true,  true, true)
    SetEntityHeading(prop, GetEntityHeading(GetPlayerPed(-1)))
    LoadDict('amb@medic@standing@tendtodead@idle_a')
    TaskPlayAnim(GetPlayerPed(-1), 'amb@medic@standing@tendtodead@idle_a', 'idle_a', 8.0, -8.0, -1, 1, 0.0, 0, 0, 0)
    Citizen.Wait(5000)
    LoadDict('amb@medic@standing@tendtodead@exit')
    TaskPlayAnim(GetPlayerPed(-1), 'amb@medic@standing@tendtodead@exit', 'exit', 8.0, -8.0, -1, 1, 0.0, 0, 0, 0)
    ClearPedTasks(GetPlayerPed(-1))
    DeleteEntity(prop)
    TriggerServerEvent('apple:process')
        
    else
    
    
    end
end

function LoadDict(dict)
    RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
	  	Citizen.Wait(10)
    end
end

---load dict and model
loadModel = function(model)
    while not HasModelLoaded(model) do Wait(0) RequestModel(model) end
    return model
end

loadDict = function(dict, anim)
    while not HasAnimDictLoaded(dict) do Wait(0) RequestAnimDict(dict) end
    return dict
end

helpText = function(msg)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

addBlip = function(coords, sprite, size, colour, text)
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, sprite)
    SetBlipScale  (blip, size)
    SetBlipColour (blip, colour)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
end


----TEXT 3D
function DrawText3D2(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 90)
end