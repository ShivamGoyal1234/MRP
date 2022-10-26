local MRFW = exports['mrfw']:GetCoreObject()
function CreateBlips()
	for k, v in pairs(Config.Locations) do
		if Config.Locations[k].blipTrue then
			local blip = AddBlipForCoord(v.location)
			SetBlipAsShortRange(blip, true)
			SetBlipSprite(blip, 527)
			SetBlipColour(blip, 81)
			SetBlipScale(blip, 0.7)
			SetBlipDisplay(blip, 6)

			BeginTextCommandSetBlipName('STRING')
			if Config.BlipNamer then
				AddTextComponentString(Config.Locations[k].name)
			else
				AddTextComponentString("Mining")
			end
			EndTextCommandSetBlipName(blip)
		end
	end
end

local PlayerData = {}

RegisterNetEvent('MRFW:Client:OnPlayerLoaded', function()
	PlayerData = MRFW.Functions.GetPlayerData()
end)

RegisterNetEvent('MRFW:Client:OnPlayerUnload', function()
	PlayerData = {}
end)

RegisterNetEvent('MRFW:Client:OnJobUpdate', function(JobInfo)
	PlayerData.job = JobInfo
end)

Citizen.CreateThread(function()
	--Hide the mineshaft doors
	CreateModelHide(vector3(-596.04, 2089.01, 131.41), 10.5, -1241212535, true)

    if Config.Blips == true then
		CreateBlips()
	end
end)
Citizen.CreateThread(function()
	if Config.PropSpawn == true then
		CreateProps()
	end
end)
Citizen.CreateThread(function()
	if Config.Pedspawn == true then
		CreatePeds()
	end
end)
-----------------------------------------------------------

local peds = {}
local shopPeds = {}
function CreatePeds()
	while true do
		Citizen.Wait(500)
		for k = 1, #Config.PedList, 1 do
			v = Config.PedList[k]
			local playerCoords = GetEntityCoords(PlayerPedId())
			local dist = #(playerCoords - v.coords)
			if dist < Config.Distance and not peds[k] then
				local ped = nearPed(v.model, v.coords, v.heading, v.gender, v.animDict, v.animName, v.scenario)
				peds[k] = {ped = ped}
			end
			if dist >= Config.Distance and peds[k] then
				if Config.Fade then
					for i = 255, 0, -51 do
						Citizen.Wait(50)
						SetEntityAlpha(peds[k].ped, i, false)
					end
				end
				DeletePed(peds[k].ped)
				peds[k] = nil
			end
		end
	end
end

function nearPed(model, coords, heading, gender, animDict, animName, scenario)
	RequestModel(GetHashKey(model))
	while not HasModelLoaded(GetHashKey(model)) do
		Citizen.Wait(1)
	end
	if gender == 'male' then
		genderNum = 4
	elseif gender == 'female' then 
		genderNum = 5
	else
		print("No gender provided! Check your configuration!")
	end
	if Config.MinusOne then 
		local x, y, z = table.unpack(coords)
		ped = CreatePed(genderNum, GetHashKey(model), x, y, z - 1, heading, false, true)
		table.insert(shopPeds, ped)
	else
		ped = CreatePed(genderNum, GetHashKey(v.model), coords, heading, false, true)
		table.insert(shopPeds, ped)
	end
	SetEntityAlpha(ped, 0, false)
	if Config.Frozen then
		FreezeEntityPosition(ped, true) --Don't let the ped move.
	end
	if Config.Invincible then
		SetEntityInvincible(ped, true) --Don't let the ped die.
	end
	if Config.Stoic then
		SetBlockingOfNonTemporaryEvents(ped, true) --Don't let the ped react to his surroundings.
	end
	--Add an animation to the ped, if one exists.
	if animDict and animName then
		RequestAnimDict(animDict)
		while not HasAnimDictLoaded(animDict) do
			Citizen.Wait(1)
		end
		TaskPlayAnim(ped, animDict, animName, 8.0, 0, -1, 1, 0, 0, 0)
	end
	if scenario then
		TaskStartScenarioInPlace(ped, scenario, 0, true) -- begins peds animation
	end
	if Config.Fade then
		for i = 0, 255, 51 do
			Citizen.Wait(50)
			SetEntityAlpha(ped, i, false)
		end
	end
	return ped
end

-----------------------------------------------------------

function CreateProps()

	--Quickly add outside lighting
		if minelight1 == nil then
			RequestModel(GetHashKey("prop_worklight_03a"))
			Wait(100)
			local minelight1 = CreateObject(GetHashKey("prop_worklight_03a"),-593.29, 2093.22, 131.7-1.05,false,false,false)
			SetEntityHeading(minelight1,GetEntityHeading(minelight1)-80)
			FreezeEntityPosition(minelight1, true)
		end		
		if minelight2 == nil then
			RequestModel(GetHashKey("prop_worklight_03a"))
			Wait(100)
			local minelight2 = CreateObject(GetHashKey("prop_worklight_03a"),-604.55, 2089.74, 131.15-1.05,false,false,false)
			SetEntityHeading(minelight2,GetEntityHeading(minelight2)-260)
			FreezeEntityPosition(minelight2, true)
		end

	local prop = 0
	for k,v in pairs(Config.OrePositions) do
		prop = prop+1
		local prop = CreateObject(GetHashKey("cs_x_rubweec"),v.coords.x, v.coords.y, v.coords.z+1.03,false,false,false)
		SetEntityHeading(prop,GetEntityHeading(prop)-90)
		FreezeEntityPosition(prop, true)           
    end
	for k,v in pairs(Config.MineLights) do
		prop = prop+1
		local prop = CreateObject(GetHashKey("xs_prop_arena_lights_ceiling_l_c"),v.coords.x, v.coords.y, v.coords.z+1.03,false,false,false)
		--SetEntityHeading(prop,GetEntityHeading(prop)-90)
		FreezeEntityPosition(prop, true)           
    end
	--Jewel Cutting Bench
	local bench = CreateObject(GetHashKey("gr_prop_gr_bench_04b"),Config.Locations['JewelCut'].location,false,false,false)
	SetEntityHeading(bench,GetEntityHeading(bench)-Config.Locations['JewelCut'].heading)
	FreezeEntityPosition(bench, true)

	--Stone Cracking Bench
	local bench2 = CreateObject(GetHashKey("prop_tool_bench02"),Config.Locations['Cracking'].location,false,false,false)
	SetEntityHeading(bench2,GetEntityHeading(bench2)-Config.Locations['Cracking'].heading)
	FreezeEntityPosition(bench2, true)

	--Stone Prop for bench
	local bench2prop = CreateObject(GetHashKey("cs_x_rubweec"),Config.Locations['Cracking'].location.x, Config.Locations['Cracking'].location.y, Config.Locations['Cracking'].location.z+0.83,false,false,false)
	SetEntityHeading(bench2prop,GetEntityHeading(bench2prop)-Config.Locations['Cracking'].heading+90)
	FreezeEntityPosition(bench2prop, true)
	local bench2prop2 = CreateObject(GetHashKey("prop_worklight_03a"),Config.Locations['Cracking'].location.x-1.4, Config.Locations['Cracking'].location.y+1.08, Config.Locations['Cracking'].location.z,false,false,false)
	SetEntityHeading(bench2prop2,GetEntityHeading(bench2prop2)-Config.Locations['Cracking'].heading+180)
	FreezeEntityPosition(bench2prop2, true)
end

-----------------------------------------------------------

Citizen.CreateThread(function()
	exports['mr-eye']:AddCircleZone("MineShaft", Config.Locations['Mine'].location, 2.0, { name="MineShaft", debugPoly=false, useZ=true, }, 
	{ options = { { event = "mr-mining:openShop", icon = "fas fa-certificate", label = "Browse Store", }, },
		distance = 2.0
	})
	exports['mr-eye']:AddCircleZone("Quarry", Config.Locations['Quarry'].location, 2.0, { name="Quarry", debugPoly=false, useZ=true, }, 
	{ options = { { event = "mr-mining:openShop", icon = "fas fa-certificate", label = "Browse Store", }, },
		distance = 2.0
	})
	--Smelter to turn stone into ore
	exports['mr-eye']:AddCircleZone("Smelter", Config.Locations['Smelter'].location, 3.0, { name="Smelter", debugPoly=false, useZ=true, }, 
	{ options = { { event = "mr-mining:SmeltMenu", icon = "fas fa-certificate", label = "Use Smelter", }, },
		distance = 10.0
	})
	--Ore Buyer
	exports['mr-eye']:AddCircleZone("Buyer", Config.Locations['Buyer'].location, 2.0, { name="Buyer", debugPoly=false, useZ=true, }, 
	{ options = { { event = "mr-mining:SellOre", icon = "fas fa-certificate", label = "Sell Ores", },	},
		distance = 2.0
	})
	--Jewel Cutting Bench
	exports['mr-eye']:AddCircleZone("JewelCut", Config.Locations['JewelCut'].location, 2.0, { name="JewelCut", debugPoly=false, useZ=true, }, 
	{ options = { { event = "mr-mining:JewelCut", icon = "fas fa-certificate", label = "Use Jewel Cutting Bench", },	},
		distance = 2.0
	})
	--Jewel Buyer
	exports['mr-eye']:AddCircleZone("JewelBuyer", Config.Locations['Buyer2'].location, 2.0, { name="JewelBuyer", debugPoly=false, useZ=true, }, 
	{ options = { { event = "mr-mining:JewelSell", icon = "fas fa-certificate", label = "Talk To Jewel Buyer", },	},
		distance = 2.0
	})
	--Cracking Bench
	exports['mr-eye']:AddCircleZone("CrackingBench", Config.Locations['Cracking'].location, 2.0, { name="CrackingBench", debugPoly=false, useZ=true, }, 
	{ options = { { event = "mr-mining:CrackStart", icon = "fas fa-certificate", label = "Use Cracking Bench", },	},
		distance = 2.0
	})
	local ore = 0
	for k,v in pairs(Config.OrePositions) do
		ore = ore+1
		exports['mr-eye']:AddCircleZone(ore, v.coords, 2.0, { name=ore, debugPoly=false, useZ=true, }, 
		{ options = { { event = "mr-mining:MineOre", icon = "fas fa-certificate", label = "Mine ore", },	},
			distance = 2.5
		})
	end
end)

-----------------------------------------------------------
--Mining Store Opening
RegisterNetEvent('mr-mining:openShop')
AddEventHandler('mr-mining:openShop', function ()
	TriggerServerEvent("inventory:server:OpenInventory", "shop", "mine", Config.Items)
end)
------------------------------------------------------------
-- Mine Ore Command / Animations

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 

RegisterNetEvent('mr-mining:MineOre')
AddEventHandler('mr-mining:MineOre', function ()
MRFW.Functions.TriggerCallback("MRFW:HasItem", function(item) 
	if Config.EnableOpeningHours then
		-- local ClockTime = GetClockHours()
		-- if ClockTime >= Config.OpenHour and ClockTime <= Config.CloseHour - 1 then
			-- if (ClockTime >= Config.OpenHour and ClockTime < 24) or (ClockTime <= Config.CloseHour -1 and ClockTime > 0) then
				if item then 
					local pos = GetEntityCoords(GetPlayerPed(-1))
					loadAnimDict("anim@heists@fleeca_bank@drilling")
					TaskPlayAnim(GetPlayerPed(-1), 'anim@heists@fleeca_bank@drilling', 'drill_straight_idle' , 3.0, 3.0, -1, 1, 0, false, false, false)
					local pos = GetEntityCoords(GetPlayerPed(-1), true)
					local DrillObject = CreateObject(GetHashKey("hei_prop_heist_drill"), pos.x, pos.y, pos.z, true, true, true)
					AttachEntityToEntity(DrillObject, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.14, 0, -0.01, 90.0, -90.0, 180.0, true, true, false, true, 1, true)
					MRFW.Functions.Progressbar("open_locker_drill", "Drilling Ore..", math.random(10000,15000), false, true, {
						disableMovement = true,	disableCarMovement = true, disableMouse = false, disableCombat = true, }, {}, {}, {}, function() -- Done
							if PlayerData.job.name == "police" or PlayerData.job.name == "doctor" or PlayerData.job.name == "government" then
								if not PlayerData.job.onduty then
									StopAnimTask(GetPlayerPed(-1), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
									DetachEntity(DrillObject, true, true)
									DeleteObject(DrillObject)
										TriggerServerEvent('mr-mining:MineReward')
										IsDrilling = false
								else
									MRFW.Functions.Notify('pehle duty phir mining', 'error', 3000)
								end
							else
								StopAnimTask(GetPlayerPed(-1), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
								DetachEntity(DrillObject, true, true)
								DeleteObject(DrillObject)
								TriggerServerEvent('mr-mining:MineReward')
								IsDrilling = false
							end
					end, function() -- Cancel
						StopAnimTask(GetPlayerPed(-1), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
						DetachEntity(DrillObject, true, true)
						DeleteObject(DrillObject)
						IsDrilling = false
					end)
				else
					TriggerEvent('MRFW:Notify', "You dont have a drill", 'error')
				end 
		-- 	else
		-- 		TriggerEvent("MRFW:Notify", "You can work "..Config.OpenHour..":00am till "..Config.CloseHour..":00pm", "error")
		-- 	end
		-- else
		-- 	TriggerEvent("MRFW:Notify", "You can't work now. Please wait till 11:00am", "error")
		-- end
	end
	end, "miningdrill")
end)

------------------------------------------------------------

-- Cracking Command / Animations
-- Command Starts here where it calls to being the stone inv checking


RegisterNetEvent('mr-mining:CrackStart')
AddEventHandler('mr-mining:CrackStart', function ()
	MRFW.Functions.TriggerCallback("MRFW:HasItem", function(item) 
			-- local ClockTime = GetClockHours()
			-- if ClockTime >= Config.OpenHour2 or ClockTime <= Config.CloseHour2 then
					if item then 
						local pos = GetEntityCoords(GetPlayerPed(-1))
						loadAnimDict('amb@prop_human_parking_meter@male@idle_a')
						TaskPlayAnim(GetPlayerPed(-1), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a' , 3.0, 3.0, -1, 1, 0, false, false, false)
						MRFW.Functions.Progressbar("open_locker_drill", "Cracking Stone..", math.random(10000,15000), false, true, {
							
							disableMovement = true,	disableCarMovement = true, disableMouse = false, disableCombat = true, }, {}, {}, {}, function() -- Done
								if PlayerData.job.name == "police" or PlayerData.job.name == "doctor" or PlayerData.job.name == "government" then
									if not PlayerData.job.onduty then
										StopAnimTask(GetPlayerPed(-1), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a', 1.0)
										TriggerServerEvent('mr-mining:CrackReward')
										IsDrilling = false
									else
										MRFW.Functions.Notify('pehle duty phir mining', 'error', 3000)
									end
								else
									StopAnimTask(GetPlayerPed(-1), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a', 1.0)
									TriggerServerEvent('mr-mining:CrackReward')
									IsDrilling = false
								end
						end, function() -- Cancel
							StopAnimTask(GetPlayerPed(-1), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a', 1.0)
							IsDrilling = false
						end)
					else 
						TriggerEvent('MRFW:Notify', "You don't have any Stone", 'error')
					end 
			-- else
			-- 	TriggerEvent("MRFW:Notify", "You can't work now. Please wait till 18:00(6:00pm)", "error")
			-- end
	end, "stone")
end)

-- Cut Command / Animations
-- Requires a drill
RegisterNetEvent('mr-mining:Cutting:Begin')
AddEventHandler('mr-mining:Cutting:Begin', function (data)
	MRFW.Functions.TriggerCallback("mr-mining:Cutting:Check:Tools",function(hasTools)
		if hasTools then
			MRFW.Functions.TriggerCallback("mr-mining:Cutting:Check:"..data,function(hasReq) 
				if hasReq then 
					local pos = GetEntityCoords(GetPlayerPed(-1))
					loadAnimDict('amb@prop_human_parking_meter@male@idle_a')
					TaskPlayAnim(GetPlayerPed(-1), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a' , 3.0, 3.0, -1, 1, 0, false, false, false)
					MRFW.Functions.Progressbar("open_locker_drill", "Cutting..", math.random(10000,15000), false, true, {
						disableMovement = true, disableCarMovement = true,disableMouse = false,	disableCombat = true, }, {}, {}, {}, function() -- Done
						StopAnimTask(GetPlayerPed(-1), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a', 1.0)
							TriggerServerEvent('mr-mining:Cutting:Reward', data)
							IsDrilling = false
							if data >= 1 and data <= 4 then TriggerEvent('mr-mining:JewelCut:Gem')
							elseif data >= 5 and data <= 9 then TriggerEvent('mr-mining:JewelCut:Ring')
							elseif data >= 10 and data <= 15 then TriggerEvent('mr-mining:JewelCut:Necklace') end
					end, function() -- Cancel
						StopAnimTask(GetPlayerPed(-1), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a', 1.0)
						IsDrilling = false
						if data >= 1 and data <= 4 then TriggerEvent('mr-mining:JewelCut:Gem')
						elseif data >= 5 and data <= 9 then TriggerEvent('mr-mining:JewelCut:Ring')
						elseif data >= 10 and data <= 15 then TriggerEvent('mr-mining:JewelCut:Necklace') end
					end)
				else
					TriggerEvent('MRFW:Notify', "You don't have all ingredients!", 'error')
					if data >= 1 and data <= 4 then TriggerEvent('mr-mining:JewelCut:Gem')
					elseif data >= 5 and data <= 9 then TriggerEvent('mr-mining:JewelCut:Ring')
					elseif data >= 10 and data <= 15 then TriggerEvent('mr-mining:JewelCut:Necklace') end
				end
			end)
		else
			TriggerEvent('MRFW:Notify', "You don\'t have a Hand Drill or Drill Bit", 'error')
			if data >= 1 and data <= 4 then TriggerEvent('mr-mining:JewelCut:Gem')
			elseif data >= 5 and data <= 9 then TriggerEvent('mr-mining:JewelCut:Ring')
			elseif data >= 10 and data <= 15 then TriggerEvent('mr-mining:JewelCut:Necklace') end
		end
	end)
end)

-- I'm proud of this whole trigger command here
-- I was worried I'd have to do loads of call backs, back and forths in the this command
-- I had a theory that (like with notifications) I'd be able to add in a dynamic variable with the trigger being called
-- IT WORKED, and here we have it calling a item check callback via the ID it recieves from the menu buttons

-- Smelt Command / Animations
RegisterNetEvent('mr-mining:Smelting:Begin')
AddEventHandler('mr-mining:Smelting:Begin', function (data)
	MRFW.Functions.TriggerCallback("mr-mining:Smelting:Check:"..data,function(hasReq) 
		if hasReq then 
			local pos = GetEntityCoords(GetPlayerPed(-1))
			loadAnimDict('amb@prop_human_parking_meter@male@idle_a')
			TaskPlayAnim(GetPlayerPed(-1), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a' , 3.0, 3.0, -1, 1, 0, false, false, false)
			MRFW.Functions.Progressbar("open_locker_drill", "Smelting..", math.random(5000,8000), false, true, {
				disableMovement = true, disableCarMovement = true,disableMouse = false,	disableCombat = true, }, {}, {}, {}, function() -- Done
				StopAnimTask(GetPlayerPed(-1), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a', 1.0)
	
					TriggerServerEvent('mr-mining:Smelting:Reward', data) -- When animations finished this is called and does the correct reward command via the ID it received from the menu
					TriggerEvent('mr-mining:SmeltMenu')
					IsDrilling = false
			end, function() -- Cancel
				StopAnimTask(GetPlayerPed(-1), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a', 1.0)
				IsDrilling = false
			end)
		else
			TriggerEvent('mr-mining:SmeltMenu')
			TriggerEvent('MRFW:Notify', "You don't have all ingredients!", 'error')
		end
	end)
end)


------------------------------------------------------------
--These also lead to the actual selling commands

--Selling animations are simply a pass item to seller animation
--Sell Ore Animation
--Sell Anim small Test
RegisterNetEvent('mr-mining:SellAnim')
AddEventHandler('mr-mining:SellAnim', function(data)
	if data == -2 then
		exports['mr-menu']:closeMenu()
		return
	end
	local pid = PlayerPedId()
	loadAnimDict("mp_common")
	TriggerServerEvent('mr-mining:Selling', data) -- Had to slip in the sell command during the animation command
	for k,v in pairs (shopPeds) do
        pCoords = GetEntityCoords(PlayerPedId())
        ppCoords = GetEntityCoords(v)
		ppRot = GetEntityRotation(v)
        dist = #(pCoords - ppCoords)
        if dist < 2 then 
			TaskPlayAnim(pid, "mp_common", "givetake2_a", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
            TaskPlayAnim(v, "mp_common", "givetake2_a", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
            Wait(1500)
            StopAnimTask(pid, "mp_common", "givetake2_a", 1.0)
            StopAnimTask(v, "mp_common", "givetake2_a", 1.0)
            RemoveAnimDict("mp_common")
			SetEntityRotation(v, 0,0,ppRot.z,0,0,false)		
			break
		end
	end
	TriggerEvent('mr-mining:SellOre')
end)


--Sell Anim small Test
RegisterNetEvent('mr-mining:SellAnim:Jewel')
AddEventHandler('mr-mining:SellAnim:Jewel', function(data)
	if data == -2 then
		exports['mr-menu']:closeMenu()
		return
	end	
	local pid = PlayerPedId()
	loadAnimDict("mp_common")
	TriggerServerEvent('mr-mining:SellJewel', data) -- Had to slip in the sell command during the animation command
	for k,v in pairs (shopPeds) do
        pCoords = GetEntityCoords(PlayerPedId())
        ppCoords = GetEntityCoords(v)
		ppRot = GetEntityRotation(v)
        dist = #(pCoords - ppCoords)
        if dist < 2 then 
			TaskPlayAnim(pid, "mp_common", "givetake2_a", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
            TaskPlayAnim(v, "mp_common", "givetake2_a", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
            Wait(1500)
            StopAnimTask(pid, "mp_common", "givetake2_a", 1.0)
            StopAnimTask(v, "mp_common", "givetake2_a", 1.0)
            RemoveAnimDict("mp_common")
			SetEntityRotation(v, 0,0,ppRot.z,0,0,false)
			break
		end
	end	
	if string.find(data, "ring") then TriggerEvent('mr-mining:JewelSell:Rings')
	elseif string.find(data, "chain") or string.find(data, "necklace") then TriggerEvent('mr-mining:JewelSell:Necklace')
	elseif string.find(data, "emerald") then TriggerEvent('mr-mining:JewelSell:Emerald')
	elseif string.find(data, "ruby") then TriggerEvent('mr-mining:JewelSell:Ruby')
	elseif string.find(data, "diamond") then TriggerEvent('mr-mining:JewelSell:Diamond')
	elseif string.find(data, "sapphire") then TriggerEvent('mr-mining:JewelSell:Sapphire') end
end)


------------------------------------------------------------
--Context Menus
--Selling Ore
RegisterNetEvent('mr-mining:SellOre', function()
	exports['mr-menu']:openMenu({
		{ header = "Ore Selling", txt = "Sell Batches of Ore for cash", isMenuHeader = true },
		{ header = "", txt = "✘ Close", params = { event = "mr-mining:SellAnim", args = -2 } },
		{ header = "Copper Ore", txt = "Sell ALL at $"..Config.SellItems['copperore'].." each", params = { event = "mr-mining:SellAnim", args = 'copperore' } },
		{ header = "Iron Ore", txt = "Sell ALL at $"..Config.SellItems['ironore'].." each", params = { event = "mr-mining:SellAnim", args = 'ironore' } },
		{ header = "Gold Ore", txt = "Sell ALL at $"..Config.SellItems['goldore'].." each", params = { event = "mr-mining:SellAnim", args = 'goldore' } },
		{ header = "Carbon", txt = "Sell ALL at $"..Config.SellItems['carbon'].." each", params = { event = "mr-mining:SellAnim", args = 'carbon' } }, 
	})
end)
------------------------
--Jewel Selling Main Menu
RegisterNetEvent('mr-mining:JewelSell', function()
    exports['mr-menu']:openMenu({
		{ header = "Jewellery Buyer", txt = "Sell your jewellery here", isMenuHeader = true }, 
		{ header = "", txt = "✘ Close", params = { event = "mr-mining:SellAnim:Jewel", args = -2 } },
		{ header = "Emeralds", txt = "See all Emerald selling options", params = { event = "mr-mining:JewelSell:Emerald", } },
		{ header = "Rubys", txt = "See all Ruby selling options", params = { event = "mr-mining:JewelSell:Ruby", } },
		{ header = "Diamonds", txt = "See all Diamond selling options", params = { event = "mr-mining:JewelSell:Diamond", } },
		{ header = "Sapphires", txt = "See all Sapphire selling options", params = { event = "mr-mining:JewelSell:Sapphire", } },
		{ header = "Rings", txt = "See all Ring Options", params = { event = "mr-mining:JewelSell:Rings", } },
		{ header = "Necklaces", txt = "See all Necklace Options", params = { event = "mr-mining:JewelSell:Necklace", } },
	})
end)
--Jewel Selling - Emerald Menu
RegisterNetEvent('mr-mining:JewelSell:Emerald', function()
    exports['mr-menu']:openMenu({
		{ header = "Jewellery Buyer", txt = "Sell your jewellery here", isMenuHeader = true }, 
		{ header = "", txt = "⬅ Return", params = { event = "mr-mining:JewelSell", } },
		{ header = "Emeralds", txt = "Sell ALL at $"..Config.SellItems['emerald'].." each", params = { event = "mr-mining:SellAnim:Jewel", args = 'emerald' } },
		{ header = "Uncut Emeralds", txt = "Sell ALL at $"..Config.SellItems['uncut_emerald'].." each", params = { event = "mr-mining:SellAnim:Jewel", args = 'uncut_emerald' } }, 
	})
end)
--Jewel Selling - Ruby Menu
RegisterNetEvent('mr-mining:JewelSell:Ruby', function()
    exports['mr-menu']:openMenu({
		{ header = "Jewellery Buyer", txt = "Sell your jewellery here", isMenuHeader = true }, 
		{ header = "", txt = "⬅ Return", params = { event = "mr-mining:JewelSell", } },
		{ header = "Rubys", txt = "Sell ALL at $"..Config.SellItems['ruby'].." each", params = { event = "mr-mining:SellAnim:Jewel", args = 'ruby' } },
		{ header = "Uncut Rubys", txt = "Sell ALL at $"..Config.SellItems['uncut_ruby'].." each", params = { event = "mr-mining:SellAnim:Jewel", args = 'uncut_ruby' } },
	})
end)
--Jewel Selling - Diamonds Menu
RegisterNetEvent('mr-mining:JewelSell:Diamond', function()
    exports['mr-menu']:openMenu({
		{ header = "Jewellery Buyer", txt = "Sell your jewellery here", isMenuHeader = true }, 
		{ header = "", txt = "⬅ Return", params = { event = "mr-mining:JewelSell", } },
		{ header = "Diamonds", txt = "Sell ALL at $"..Config.SellItems['diamond'].." each", params = { event = "mr-mining:SellAnim:Jewel", args = 'diamond' } },
		{ header = "Uncut Diamonds", txt = "Sell ALL at $"..Config.SellItems['uncut_diamond'].." each", params = { event = "mr-mining:SellAnim:Jewel", args = 'uncut_diamond' } },
	})
end)
--Jewel Selling - Sapphire Menu
RegisterNetEvent('mr-mining:JewelSell:Sapphire', function()
    exports['mr-menu']:openMenu({
		{ header = "Jewellery Buyer", txt = "Sell your jewellery here", isMenuHeader = true }, 
		{ header = "", txt = "⬅ Return", params = { event = "mr-mining:JewelSell", } },
		{ header = "Sapphires", txt = "Sell ALL at $"..Config.SellItems['sapphire'].." each", params = { event = "mr-mining:SellAnim:Jewel", args = 'sapphire' } },
		{ header = "Uncut Sapphires", txt = "Sell ALL at $"..Config.SellItems['uncut_sapphire'].." each", params = { event = "mr-mining:SellAnim:Jewel", args = 'uncut_sapphire' } },
	})
end)

--Jewel Selling - Jewellry Menu
RegisterNetEvent('mr-mining:JewelSell:Rings', function()
    exports['mr-menu']:openMenu({
		{ header = "Jewellery Buyer", txt = "Sell your jewellery here", isMenuHeader = true }, 
		{ header = "", txt = "⬅ Return", params = { event = "mr-mining:JewelSell", } },
		{ header = "Gold Rings", txt = "Sell ALL at $"..Config.SellItems['gold_ring'].." each", params = { event = "mr-mining:SellAnim:Jewel", args = 'gold_ring' } },
		{ header = "Diamond Rings", txt = "Sell ALL at $"..Config.SellItems['diamond_ring'].." each", params = { event = "mr-mining:SellAnim:Jewel", args = 'diamond_ring'} },
		{ header = "Emerald Rings", txt = "Sell ALL at $"..Config.SellItems['emerald_ring'].." each", params = { event = "mr-mining:SellAnim:Jewel", args = 'emerald_ring' } },
		{ header = "Ruby Rings", txt = "Sell ALL at $"..Config.SellItems['ruby_ring'].." each", params = { event = "mr-mining:SellAnim:Jewel", args = 'ruby_ring' } },	
		{ header = "Sapphire Rings", txt = "Sell ALL at $"..Config.SellItems['sapphire_ring'].." each", params = { event = "mr-mining:SellAnim:Jewel", args = 'sapphire_ring' } },
	})
end)
--Jewel Selling - Jewellery Menu
RegisterNetEvent('mr-mining:JewelSell:Necklace', function()
    exports['mr-menu']:openMenu({
		{ header = "Jewellery Buyer", txt = "Sell your jewellery here", isMenuHeader = true }, 
		{ header = "", txt = "⬅ Return", params = { event = "mr-mining:JewelSell", } },
		{ header = "Gold Chains",	txt = "Sell ALL at $"..Config.SellItems['goldchain'].." each", params = { event = "mr-mining:SellAnim:Jewel", args = 'goldchain' } },
		{ header = "Gold Chains", txt = "Sell ALL at $"..Config.SellItems['10kgoldchain2'].." each", params = { event = "mr-mining:SellAnim:Jewel", args = '10kgoldchain2' } },
		{ header = "Diamond Necklace", txt = "Sell ALL at $"..Config.SellItems['diamond_necklace'].." each", params = { event = "mr-mining:SellAnim:Jewel", args = 'diamond_necklace' } },
		{ header = "Emerald Necklace", txt = "Sell ALL at $"..Config.SellItems['emerald_necklace'].." each", params = { event = "mr-mining:SellAnim:Jewel", args = 'emerald_necklace' } },
		{ header = "Ruby Necklace", txt = "Sell ALL at $"..Config.SellItems['ruby_necklace'].." each", params = { event = "mr-mining:SellAnim:Jewel", args = 'ruby_necklace' } },	
		{ header = "Sapphire Necklace", txt = "Sell ALL at $"..Config.SellItems['sapphire_necklace'].." each", params = { event = "mr-mining:SellAnim:Jewel", args = 'sapphire_necklace' } },
	})
end)
------------------------

--Smelting
RegisterNetEvent('mr-mining:SmeltMenu', function()
    exports['mr-menu']:openMenu({
	{ header = "Smelter", txt = "Smelt ores down into usable materials", isMenuHeader = true }, 
	{ header = "", txt = "✘ Close", params = { event = "mr-mining:SellAnim", args = -2 } },
	{ header = MRFW.Shared.Items["copper"].label, txt = "1x "..MRFW.Shared.Items["copperore"].label, params = { event = "mr-mining:Smelting:Begin", args = 1 } },
	{ header = MRFW.Shared.Items["goldbar2"].label, txt = "4x "..MRFW.Shared.Items["goldore"].label, params = { event = "mr-mining:Smelting:Begin", args = 2 } },
	{ header = MRFW.Shared.Items["iron"].label, txt = "1x "..MRFW.Shared.Items["ironore"].label, params = { event = "mr-mining:Smelting:Begin", args = 3 } },
	{ header = MRFW.Shared.Items["steel"].label, txt = "1x "..MRFW.Shared.Items["ironore"].label.."<br>1x "..MRFW.Shared.Items["carbon"].label, params = { event = "mr-mining:Smelting:Begin", args = 4 } },
	--{ header = "Melt Bottle", txt = "Melt down a glass bottle", params = { event = "mr-mining:Smelting:Begin", args = 5 } },
	--{ header = "Melt Can", txt = "Melt down an empty can", params = { event = "mr-mining:Smelting:Begin", args = 6 } },
	})
end)


------------------------

--Cutting Jewels
RegisterNetEvent('mr-mining:JewelCut', function()
    exports['mr-menu']:openMenu({
	{ header = "Jewellery Crafting Bench", txt = "Requires Hand Drill & Drill Bit", isMenuHeader = true },
	{ header = "", txt = "✘ Close", params = { event = "mr-mining:SellAnim", args = -2 } },
	{ header = "Gem Cutting",	txt = "Go to Gem Cutting Section", params = { event = "mr-mining:JewelCut:Gem", } },
	{ header = "Make Rings", txt = "Go to Ring Crafting Section", params = { event = "mr-mining:JewelCut:Ring", } },
	{ header = "Make Necklaces", txt = "Go to Necklace Crafting Section", params = { event = "mr-mining:JewelCut:Necklace", } },
	})
end)
--Gem Section
RegisterNetEvent('mr-mining:JewelCut:Gem', function()
    exports['mr-menu']:openMenu({
	{ header = "Jewellery Crafting Bench", txt = "Requires Hand Drill & Drill Bit", isMenuHeader = true },
	{ header = "", txt = "⬅ Return", params = { event = "mr-mining:JewelCut", } },
	{ header = "Emerald", txt = "Carefully cut to increase value", params = { event = "mr-mining:Cutting:Begin", args = 1 } },
	{ header = "Ruby", txt = "Carefully cut to increase value", params = { event = "mr-mining:Cutting:Begin", args = 2 } },
	{ header = "Diamond", txt = "Carefully cut to increase value", params = { event = "mr-mining:Cutting:Begin", args = 3 } },
	{ header = "Sapphire", txt = "Carefully cut to increase value", params = { event = "mr-mining:Cutting:Begin", args = 4 } },
	})
end)
-- Ring Section
RegisterNetEvent('mr-mining:JewelCut:Ring', function()
    exports['mr-menu']:openMenu({
	{ header = "Jewellery Crafting Bench", txt = "Requires Hand Drill & Drill Bit", isMenuHeader = true },
	{ header = "", txt = "⬅ Return", params = { event = "mr-mining:JewelCut", } },
	{ header = "Gold Ring x3", txt = "Requires 1 Gold Bar", params = { event = "mr-mining:Cutting:Begin", args = 5 } },
	{ header = "Diamond Ring", txt = "Requires 1 Gold Ring & 1 Diamond", params = { event = "mr-mining:Cutting:Begin", args = 6 } },
	{ header = "Emerald Ring", txt = "Requires 1 Gold Ring & 1 Emerald", params = { event = "mr-mining:Cutting:Begin", args = 7 } },
	{ header = "Ruby Ring", txt = "Requires 1 Gold Ring & 1 Ruby", params = { event = "mr-mining:Cutting:Begin", args = 8 } },
	{ header = "Sapphire Ring", txt = "Requires 1 Gold Ring & 1 Sapphire", params = { event = "mr-mining:Cutting:Begin", args = 9 } },
	})
end)
--Necklace Section
RegisterNetEvent('mr-mining:JewelCut:Necklace', function()
    exports['mr-menu']:openMenu({
	{ header = "Jewellery Crafting Bench", txt = "Requires Hand Drill & Drill Bit", isMenuHeader = true },
	{ header = "", txt = "⬅ Return", params = { event = "mr-mining:JewelCut", } },
	{ header = "Gold Chain x3", txt = "Requires 1 Gold Bar", params = { event = "mr-mining:Cutting:Begin", args = 10 } },
	{ header = "10k Gold Chain x2", txt = "Requires 1 Gold Bar", params = { event = "mr-mining:Cutting:Begin", args = 11 } },
	{ header = "Diamond Necklace", txt = "Requires 1 Gold Chain & 1 Diamond", params = { event = "mr-mining:Cutting:Begin", args = 12 } },
	{ header = "Emerald Necklace", txt = "Requires 1 Gold Chain & 1 Emerald", params = { event = "mr-mining:Cutting:Begin", args = 13 } },
	{ header = "Ruby Necklace", txt = "Requires 1 Gold Chain & 1 Ruby", params = { event = "mr-mining:Cutting:Begin", args = 14 } },
	{ header = "Sapphire Necklace", txt = "Requires 1 Gold Chain & 1 Sapphire", params = { event = "mr-mining:Cutting:Begin", args = 15 } }, 
	})
end)
