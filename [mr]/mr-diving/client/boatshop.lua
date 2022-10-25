-- local ClosestBerth = 1
-- local BoatsSpawned = false
-- local SpawnedBoats = {}
-- local Buying = false

-- -- Berth's Boatshop Loop
-- CreateThread(function()
--     while true do
--         local pos = GetEntityCoords(PlayerPedId(), true)
--         local BerthDist = #(pos - vector3(MR-Boatshop.Locations["berths"][1]["coords"]["boat"]["x"], MR-Boatshop.Locations["berths"][1]["coords"]["boat"]["y"], MR-Boatshop.Locations["berths"][1]["coords"]["boat"]["z"]))

--         if BerthDist < 100 then
--             SetClosestBerthBoat()
--             if not BoatsSpawned then
--                 SpawnBerthBoats()
--             end
--         elseif BerthDist > 110 then
--             if BoatsSpawned then
--                 BoatsSpawned = false
--             end
--         end

--         Wait(1000)
--     end
-- end)

-- function SpawnBerthBoats()
--     for loc,_ in pairs(MR-Boatshop.Locations["berths"]) do
--         if SpawnedBoats[loc] ~= nil then
--             MRFW.Functions.DeleteVehicle(SpawnedBoats[loc])
--         end
-- 		local model = GetHashKey(MR-Boatshop.Locations["berths"][loc]["boatModel"])
-- 		RequestModel(model)
-- 		while not HasModelLoaded(model) do
-- 			Wait(0)
-- 		end

-- 		local veh = CreateVehicle(model, MR-Boatshop.Locations["berths"][loc]["coords"]["boat"]["x"], MR-Boatshop.Locations["berths"][loc]["coords"]["boat"]["y"], MR-Boatshop.Locations["berths"][loc]["coords"]["boat"]["z"], false, false)

--         SetModelAsNoLongerNeeded(model)
-- 		SetVehicleOnGroundProperly(veh)
-- 		SetEntityInvincible(veh,true)
--         SetEntityHeading(veh, MR-Boatshop.Locations["berths"][loc]["coords"]["boat"]["w"])
--         SetVehicleDoorsLocked(veh, 3)

-- 		FreezeEntityPosition(veh,true)     
--         SpawnedBoats[loc] = veh
--     end
--     BoatsSpawned = true
-- end

-- function SetClosestBerthBoat()
--     local pos = GetEntityCoords(PlayerPedId(), true)
--     local current = nil
--     local dist = nil

--     for id, veh in pairs(MR-Boatshop.Locations["berths"]) do
--         if current ~= nil then
--             if #(pos - vector3(MR-Boatshop.Locations["berths"][id]["coords"]["buy"]["x"], MR-Boatshop.Locations["berths"][id]["coords"]["buy"]["y"], MR-Boatshop.Locations["berths"][id]["coords"]["buy"]["z"])) < dist then
--                 current = id
--                 dist = #(pos - vector3(MR-Boatshop.Locations["berths"][id]["coords"]["buy"]["x"], MR-Boatshop.Locations["berths"][id]["coords"]["buy"]["y"], MR-Boatshop.Locations["berths"][id]["coords"]["buy"]["z"]))
--             end
--         else
--             dist = #(pos - vector3(MR-Boatshop.Locations["berths"][id]["coords"]["buy"]["x"], MR-Boatshop.Locations["berths"][id]["coords"]["buy"]["y"], MR-Boatshop.Locations["berths"][id]["coords"]["buy"]["z"]))
--             current = id
--         end
--     end
--     if current ~= ClosestBerth then
--         ClosestBerth = current
--     end
-- end

-- CreateThread(function()
--     while true do
--         local ped = PlayerPedId()
--         local pos = GetEntityCoords(ped)

--         local inRange = false
--         sleep = 1500
--         local distance = #(pos - vector3(MR-Boatshop.Locations["berths"][ClosestBerth]["coords"]["boat"]["x"], MR-Boatshop.Locations["berths"][ClosestBerth]["coords"]["boat"]["y"], MR-Boatshop.Locations["berths"][ClosestBerth]["coords"]["boat"]["z"]))

--         if distance < 15 then
--             sleep = 5
--             local BuyLocation = {
--                 x = MR-Boatshop.Locations["berths"][ClosestBerth]["coords"]["buy"]["x"],
--                 y = MR-Boatshop.Locations["berths"][ClosestBerth]["coords"]["buy"]["y"],
--                 z = MR-Boatshop.Locations["berths"][ClosestBerth]["coords"]["buy"]["z"]
--             }

--             DrawMarker(2, BuyLocation.x, BuyLocation.y, BuyLocation.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.5, 0.15, 255, 55, 15, 255, false, false, false, true, false, false, false)
--             local BuyDistance = #(pos - vector3(BuyLocation.x, BuyLocation.y, BuyLocation.z))

--             if BuyDistance < 2 then                
--                 local currentBoat = MR-Boatshop.Locations["berths"][ClosestBerth]["boatModel"]

--                 DrawMarker(2, MR-Boatshop.Locations["berths"][ClosestBerth]["coords"]["boat"]["x"], MR-Boatshop.Locations["berths"][ClosestBerth]["coords"]["boat"]["y"], MR-Boatshop.Locations["berths"][ClosestBerth]["coords"]["boat"]["z"] + 1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.5, -0.30, 15, 255, 55, 255, false, false, false, true, false, false, false)

--                 if not Buying then
--                     DrawText3D(BuyLocation.x, BuyLocation.y, BuyLocation.z + 0.3, '~g~E~w~ - '..MR-Boatshop.ShopBoats[currentBoat]["label"]..' buy for ~b~$'..MR-Boatshop.ShopBoats[currentBoat]["price"])
--                     if IsControlJustPressed(0, 38) then
--                         Buying = true
--                     end
--                 else
--                     DrawText3D(BuyLocation.x, BuyLocation.y, BuyLocation.z + 0.3, 'Are you sure ~g~7~w~ Yes / ~r~8~w~ No ~b~($'..MR-Boatshop.ShopBoats[currentBoat]["price"]..',-)')
--                     if IsControlJustPressed(0, 161) or IsDisabledControlJustReleased(0, 161) then
--                         TriggerServerEvent('mr-diving:server:BuyBoat', MR-Boatshop.Locations["berths"][ClosestBerth]["boatModel"], ClosestBerth)
--                         Buying = false
--                     elseif IsControlJustPressed(0, 162) or IsDisabledControlJustReleased(0, 162) then
--                         Buying = false
--                     end
--                 end
--             elseif BuyDistance > 2.5 then
--                 if Buying then
--                     Buying = false
--                 end
--             end
--         end

--         Wait(sleep)
--     end
-- end)

-- RegisterNetEvent('mr-diving:client:BuyBoat', function(boatModel, plate)
--     DoScreenFadeOut(250)
--     Wait(250)
--     MRFW.Functions.SpawnVehicle(boatModel, function(veh)
--         TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
--         exports['mr-fuel']:SetFuel(veh, 100)
--         SetVehicleNumberPlateText(veh, plate)
--         SetEntityHeading(veh, MR-Boatshop.SpawnVehicle.w)
--         TriggerEvent("vehiclekeys:client:SetOwner", MRFW.Functions.GetPlate(veh))
--     end, MR-Boatshop.SpawnVehicle, false)
--     SetTimeout(1000, function()
--         DoScreenFadeIn(250)
--     end)
-- end)

-- CreateThread(function()
--     BoatShop = AddBlipForCoord(MR-Boatshop.Locations["berths"][1]["coords"]["boat"]["x"], MR-Boatshop.Locations["berths"][1]["coords"]["boat"]["y"], MR-Boatshop.Locations["berths"][1]["coords"]["boat"]["z"])

--     SetBlipSprite (BoatShop, 410)
--     SetBlipDisplay(BoatShop, 4)
--     SetBlipScale  (BoatShop, 0.8)
--     SetBlipAsShortRange(BoatShop, true)
--     SetBlipColour(BoatShop, 3)

--     BeginTextCommandSetBlipName("STRING")
--     AddTextComponentSubstringPlayerName("LSYMC Haven")
--     EndTextCommandSetBlipName(BoatShop)
-- end)
