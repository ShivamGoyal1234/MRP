-------------------------DEVELOPED BY aj-----------------------------------------

--------------------
-- AJFW Core Stuff --
--------------------

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
  }
  

-------------------------
--Written by aj
-------------------------
------------------CONFIG----------------------
local startX = 2388.37  --starting
local startY = 5045.8
local startZ = 46.37
---------------------------------------------
local portionX = -95.72   --Portion
local portionY = 6207.15
local portionZ = 31.03
---
local portionX2 = -100.52   --Portion
local portionY2 = 6202.48
local portionZ2 = 31.03
---
---
local portionX3 = -99.72   --Portion
local portionY3 = 6206.09
local portionZ3 = 31.03
---
local packingX = -106.44    --Pack
local packingY = 6204.29
local packingZ = 31.02
---
local packingX2 = -104.20   --Pack
local packingY2 = 6206.45
local packingZ2 = 31.02
---
local packingX3 = -101.84   --Pack
local packingY3 = 6208.93
local packingZ3 = 31.03
---
local packingX4 = -99.91  --Pack
local packingY4 = 6210.9
local packingZ4 = 31.03
---
local sellX = -181.03    --Sell
local sellY = -1429.19
local sellZ = 31.31

local chicken1
local chicken2
local chicken3
local chicken4
local chicken5
local Caught1 = 0
local Caught2 = 0
local Caught3 = 0
local Caught4 = 0
local Caught5 = 0
local andsplashed = 0
local share = false
local prop
local zapakowaneDoauta = false
local karton
local mieso
local packs = 0




---------------------
-- Location --
---------------------

Citizen.CreateThread(function()
	-- local lapaniek = AddBlipForCoord(startX, startY, startZ)
	-- 	SetBlipSprite (lapaniek, 463)
	-- 	SetBlipDisplay(lapaniek, 4)
	-- 	SetBlipScale  (lapaniek, 0.8)
	-- 	SetBlipColour (lapaniek, 46)
	-- 	SetBlipAsShortRange(lapaniek, true)
	-- 	BeginTextCommandSetBlipName("STRING")
	-- 	AddTextComponentString('Chicken Farm')
	-- 	EndTextCommandSetBlipName(lapaniek)
	-- local rzeznia = AddBlipForCoord(portionX, portionY, portionZ)
	-- 	SetBlipSprite (rzeznia, 463)
	-- 	SetBlipDisplay(rzeznia, 4)
	-- 	SetBlipScale  (rzeznia, 0.8)
	-- 	SetBlipColour (rzeznia, 46)
	-- 	SetBlipAsShortRange(rzeznia, true)
	-- 	BeginTextCommandSetBlipName("STRING")
	-- 	AddTextComponentString('Slaughterhouse')
	-- 	EndTextCommandSetBlipName(rzeznia)
	-- local skupk = AddBlipForCoord(sellX, sellY, sellZ)
	-- 	SetBlipSprite (skupk, 431)
	-- 	SetBlipDisplay(skupk, 4)
	-- 	SetBlipScale  (skupk, 0.8)
	-- 	SetBlipColour (skupk, 46)
	-- 	SetBlipAsShortRange(skupk, true)
	-- 	BeginTextCommandSetBlipName("STRING")
	-- 	AddTextComponentString('Chicken Dealer')
	-- 	EndTextCommandSetBlipName(skupk)
end)



------------------DEVELOPED BY aj-----------------------------------------
---------------------
-- Citizen --
---------------------

Citizen.CreateThread(function()
    while true do
	Citizen.Wait(5)
		local plyCoords = GetEntityCoords(PlayerPedId(), false)
		local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, startX, startY, startZ)
---
		if dist <= 20.0 then
		DrawMarker(27, startX, startY, startZ-0.97, 0, 0, 0, 0, 0, 0, 0.90, 0.90, 0.90, 255, 255, 255, 200, 0, 0, 0, 0)
		else
		Citizen.Wait(1500)
		end
		
		if dist <= 2.5 then
		DrawText3D(startX, startY, startZ, "~g~[E]~w~ To Catch chickens")
		end
--
		if dist <= 0.5 then
			if IsControlJustPressed(0, Keys['E']) then -- "E"
				DisableControlAction(0, 20, true)
			TriggerServerEvent("aj-chickenjob:startChicken")
			LapChicken()
			end			
		end
	end
end)
------------------DEVELOPED BY aj-----------------------------------------
Citizen.CreateThread(function()
    while true do
	Citizen.Wait(5)
		local plyCoords = GetEntityCoords(PlayerPedId(), false)
		local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, portionX, portionY, portionZ)
		local dist2 = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, portionX2, portionY2, portionZ2)
		local dist3 = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, portionX3, portionY3, portionZ3)
		local distP = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, packingX, packingY, packingZ)
		local distP2 = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, packingX2, packingY2, packingZ2)
		local distP3 = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, packingX3, packingY3, packingZ3)
		local distP4 = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, packingX4, packingY4, packingZ4)

		if dist <= 25.0 then
		DrawMarker(27, portionX, portionY, portionZ-0.97, 0, 0, 0, 0, 0, 0, 0.90, 0.90, 0.90, 255, 255, 255, 200, 0, 0, 0, 0)
		DrawMarker(27, portionX2, portionY2, portionZ2-0.97, 0, 0, 0, 0, 0, 0, 0.90, 0.90, 0.90, 255, 255, 255, 200, 0, 0, 0, 0)
		DrawMarker(27, portionX3, portionY3, portionZ3-0.97, 0, 0, 0, 0, 0, 0, 0.90, 0.90, 0.90, 255, 255, 255, 200, 0, 0, 0, 0)
		DrawMarker(27, packingX, packingY, packingZ-0.97, 0, 0, 0, 0, 0, 0, 0.90, 0.90, 0.90, 255, 255, 255, 200, 0, 0, 0, 0)
		DrawMarker(27, packingX2, packingY2, packingZ2-0.97, 0, 0, 0, 0, 0, 0, 0.90, 0.90, 0.90, 255, 255, 255, 200, 0, 0, 0, 0)
		DrawMarker(27, packingX3, packingY3, packingZ3-0.97, 0, 0, 0, 0, 0, 0, 0.90, 0.90, 0.90, 255, 255, 255, 200, 0, 0, 0, 0)
		DrawMarker(27, packingX4, packingY4, packingZ4-0.97, 0, 0, 0, 0, 0, 0, 0.90, 0.90, 0.90, 255, 255, 255, 200, 0, 0, 0, 0)
		else
		Citizen.Wait(1500)
		end
		
		if dist <= 2.5 then
		DrawText3D(portionX, portionY, portionZ, "~g~[E]~w~ To portion the chicken")
		end

		if dist <= 0.5 then
			if IsControlJustPressed(0, Keys['E']) then -- "E"
				portioning(1)
			end			
		end
		
		if dist2 <= 2.5 then
		DrawText3D(portionX2, portionY2, portionZ2, "~g~[E]~w~ To portion the chicken")
		end

		if dist2 <= 0.5 then
			if IsControlJustPressed(0, Keys['E']) then -- "E"
				portioning(2)
			end			
		end

		if dist3 <= 2.5 then
			DrawText3D(portionX3, portionY3, portionZ3, "~g~[E]~w~ To portion the chicken")
		end

		if dist3 <= 0.5 then
			if IsControlJustPressed(0, Keys['E']) then -- "E"
				portioning(3)
			end			
		end
		--
		if distP <= 2.5 and packs == 0 then
		DrawText3D(packingX, packingY, packingZ, "~g~[E]~w~ To pack chicken")
		elseif distP <= 2.5 and packs == 1 then
		DrawText3D(packingX, packingY, packingZ, "~g~[G]~w~ To stop packing")
		DrawText3D(packingX, packingY, packingZ+0.1, "~g~[E]~w~ To keep packing")
		end

		if distP <= 0.5 then
			if IsControlJustPressed(0, Keys['E']) then 
			packingg(1)
			elseif IsControlJustPressed(0, Keys['G']) then
			packed(1)
			end			
		end
		
		if distP2 <= 2.5 and packs == 0 then
		DrawText3D(packingX2, packingY2, packingZ2, "~g~[E]~w~ To pack chicken")
		elseif distP2 <= 2.5 and packs == 1 then
		DrawText3D(packingX2, packingY2, packingZ2, "~g~[G]~w~ To stop packing")
		DrawText3D(packingX2, packingY2, packingZ2+0.1, "~g~[E]~w~ To keep packing")
		end

		if distP2 <= 0.5 then
			if IsControlJustPressed(0, Keys['E']) then -- "E"
			packingg(2)
			elseif IsControlJustPressed(0, Keys['G']) then
			packed(2)
			end		
		end	

		if distP3 <= 2.5 and packs == 0 then
			DrawText3D(packingX3, packingY3, packingZ3, "~g~[E]~w~ To pack chicken")
		elseif distP3 <= 2.5 and packs == 1 then
			DrawText3D(packingX3, packingY3, packingZ3, "~g~[G]~w~ To stop packing")
			DrawText3D(packingX3, packingY3, packingZ3+0.1, "~g~[E]~w~ To keep packing")
		end
	
		if distP3 <= 0.5 then
			if IsControlJustPressed(0, Keys['E']) then -- "E"
			packingg(3)
			elseif IsControlJustPressed(0, Keys['G']) then
			packed(3)
			end		
		end	

		if distP4 <= 2.5 and packs == 0 then
			DrawText3D(packingX4, packingY4, packingZ4, "~g~[E]~w~ To pack chicken")
		elseif distP4 <= 2.5 and packs == 1 then
			DrawText3D(packingX4, packingY4, packingZ4, "~g~[G]~w~ To stop packing")
			DrawText3D(packingX4, packingY4, packingZ4+0.1, "~g~[E]~w~ To keep packing")
		end
		
		if distP4 <= 0.5 then
			if IsControlJustPressed(0, Keys['E']) then -- "E"
				packingg(4)
			elseif IsControlJustPressed(0, Keys['G']) then
				packed(4)
			end		
		end	
		
	end
end)

------------------DEVELOPED BY aj-----------------------------------------
Citizen.CreateThread(function()
    while true do
    Citizen.Wait(5)
	local plyCoords = GetEntityCoords(PlayerPedId(), false)
    local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, sellX, sellY, sellZ)
	
	if dist <= 20.0 then
	--DrawMarker(0, sellX, sellY, sellZ-0.96, 0, 0, 0, 0, 0, 0, 2.20, 2.20, 2.20, 255, 255, 255, 200, 0, 0, 0, 0)
	else
	Citizen.Wait(1000)
	end
	
	if dist <= 2.0 then
	DrawText3D(sellX, sellY, sellZ+0.1, "[E] Sell Packed Chickens")
		if IsControlJustPressed(0, Keys['E']) then 
		packedsell()
		end	
	end
	
end
end)

------------------DEVELOPED BY aj-----------------------------------------
-- Code

DrawText3D = function(x, y, z, text)
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

------------------DEVELOPED BY aj-----------------------------------------

function LapChicken()
	DoScreenFadeOut(500)
	Citizen.Wait(500)
	SetEntityCoordsNoOffset(PlayerPedId(), 2385.963, 5047.333, 46.400, 0, 0, 1)
	RequestModel(GetHashKey('a_c_hen'))
	while not HasModelLoaded(GetHashKey('a_c_hen')) do
	Wait(1)
	end
	chicken1 = CreatePed(26, "a_c_hen", 2370.262, 5052.913, 46.437, 276.351, true, false)
	
	chicken2 = CreatePed(26, "a_c_hen", 2372.040, 5059.604, 46.444, 223.595, true, false)
	chicken3 = CreatePed(26, "a_c_hen", 2379.192, 5062.992, 46.444, 195.477, true, false)
	chicken4 = CreatePed(26, "a_c_hen", 2379.192, 5062.992, 46.444, 195.477, true, false)
	chicken5 = CreatePed(26, "a_c_hen", 2372.040, 5059.604, 46.444, 223.595, true, false)

	TaskReactAndFleePed(chicken1, PlayerPedId())
	TaskReactAndFleePed(chicken2, PlayerPedId())
	TaskReactAndFleePed(chicken3, PlayerPedId())
	TaskReactAndFleePed(chicken4, PlayerPedId())
	TaskReactAndFleePed(chicken5, PlayerPedId())
	Citizen.Wait(500)
	DoScreenFadeIn(500)
	share = true
end


function LoadDict(dict)
    RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
	  	Citizen.Wait(10)
    end
end

------------------DEVELOPED BY aj-----------------------------------------
Citizen.CreateThread(function()
    while true do
    Citizen.Wait(5)
	
if share == true then
	local chicken1Coords = GetEntityCoords(chicken1)
	local chicken2Coords = GetEntityCoords(chicken2)
	local chicken3Coords = GetEntityCoords(chicken3)
	local chicken4Coords = GetEntityCoords(chicken4)
	local chicken5Coords = GetEntityCoords(chicken5)
	local plyCoords = GetEntityCoords(PlayerPedId(), false)
    local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, chicken1Coords.x, chicken1Coords.y, chicken1Coords.z)
	local dist2 = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, chicken2Coords.x, chicken2Coords.y, chicken2Coords.z)
	local dist3 = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, chicken3Coords.x, chicken3Coords.y, chicken3Coords.z)
	local dist4 = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, chicken4Coords.x, chicken4Coords.y, chicken4Coords.z)
	local dist5 = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, chicken5Coords.x, chicken5Coords.y, chicken5Coords.z)
	
	if andsplashed == 5 then
	Caught1 = 0
	Caught2 = 0
	Caught3 = 0
	Caught4 = 0
	Caught5 = 0
	andsplashed = 0
	share = false
	DisableControlAction(0, 20, false)
	AJFW.Functions.Notify("Take Alived Chiken To Process Area ..", "primary")
	TriggerServerEvent("aj-chickenjob:getNewChicken")
	end
	
	if dist <= 1.0 then
	DrawText3D(chicken1Coords.x, chicken1Coords.y, chicken1Coords.z+0.5, "~o~[E]~b~ Catch the chicken")
		if IsControlJustPressed(0, Keys['E']) then 
		Caught1 = 1
		hewassplashed()
		end	
	elseif dist2 <= 1.0 then
		DrawText3D(chicken2Coords.x, chicken2Coords.y, chicken2Coords.z+0.5, "~o~[E]~b~ Catch the chicken")
		if IsControlJustPressed(0, Keys['E']) then 
		Caught2 = 1
		hewassplashed()
		end	
	elseif dist3 <= 1.0 then
		DrawText3D(chicken3Coords.x, chicken3Coords.y, chicken3Coords.z+0.5, "~o~[E]~b~ Catch the chicken")
		if IsControlJustPressed(0, Keys['E']) then 
		Caught3 = 1
		hewassplashed()
		end	
	elseif dist4 <= 1.0 then
		DrawText3D(chicken4Coords.x, chicken4Coords.y, chicken4Coords.z+0.5, "~o~[E]~b~ Catch the chicken")
		if IsControlJustPressed(0, Keys['E']) then 
		Caught4 = 1
		hewassplashed()
		end	
	elseif dist5 <= 1.0 then
		DrawText3D(chicken5Coords.x, chicken5Coords.y, chicken5Coords.z+0.5, "~o~[E]~b~ Catch the chicken")
		if IsControlJustPressed(0, Keys['E']) then 
		Caught5 = 1
		hewassplashed()
		end	
	end
else
Citizen.Wait(500)
end	
end
end)


------------------DEVELOPED BY aj-----------------------------------------
function hewassplashed()
	LoadDict('move_jump')
	TaskPlayAnim(PlayerPedId(), 'move_jump', 'dive_start_run', 8.0, -8.0, -1, 0, 0.0, 0, 0, 0)
	Citizen.Wait(600)
	SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
	Citizen.Wait(1000)
	ragdoll = true
	local chanceofsplashes = math.random(1,100)
	if chanceofsplashes <= 60 then
			AJFW.Functions.Notify("You managed to catch 1 chicken!", "success")
			if Caught1 == 1 then
				DeleteEntity(chicken1)
				Caught1 = 0
				andsplashed = andsplashed +1
			elseif Caught2 == 1 then
				DeleteEntity(chicken2)
				Caught2 = 0
				andsplashed = andsplashed +1
			elseif Caught3 == 1 then
				DeleteEntity(chicken3)
				Caught3 = 0
				andsplashed = andsplashed +1
			elseif Caught4 == 1 then
				DeleteEntity(chicken4)
				Caught4 = 0
				andsplashed = andsplashed +1
			elseif Caught5 == 1 then
				DeleteEntity(chicken5)
				Caught5 = 0
				andsplashed = andsplashed +1
			end
		else
		AJFW.Functions.Notify("The chicken escaped your arms!", "error")
	end
end
------------------DEVELOPED BY aj-----------------------------------------

function packingg(stanowisko)
	local inventory =  AJFW.Functions.GetPlayerData()
	
	AJFW.Functions.TriggerCallback('AJFW:HasItem', function(result)
		if result then
			SetEntityHeading(PlayerPedId(), 40.0)
			local PedCoords = GetEntityCoords(PlayerPedId())
			mieso = CreateObject(GetHashKey('prop_cs_steak'),PedCoords.x, PedCoords.y,PedCoords.z, true, true, true)
			AttachEntityToEntity(mieso, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0x49D9), 0.15, 0.0, 0.01, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
			karton = CreateObject(GetHashKey('prop_cs_clothes_box'),PedCoords.x, PedCoords.y,PedCoords.z, true, true, true)
			AttachEntityToEntity(karton, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.13, 0.0, -0.16, 250.0, -30.0, 0.0, false, false, false, false, 2, true)
			packs = 1
			LoadDict("anim@heists@ornate_bank@grab_cash_heels")
			TaskPlayAnim(PlayerPedId(), "anim@heists@ornate_bank@grab_cash_heels", "grab", 8.0, -8.0, -1, 1, 0, false, false, false)
			FreezeEntityPosition(PlayerPedId(), true)
			AJFW.Functions.Progressbar("wash-", "Packing..", 20000, false, true, {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			}, {}, {}, {}, function()

			AJFW.Functions.TriggerCallback('AJFW:HasItem', function(result4)
				if result4 then
					TriggerServerEvent("aj-chickenjob:getpackedChicken",2)
					AJFW.Functions.Notify("Keep packing the chicken or go to the vehicle and store it.", "primary")
				else
					-- print("badhe teej bannre the na xD")
					AJFW.Functions.Notify("You have nothing to pack!", "error")
					FreezeEntityPosition(PlayerPedId(),false)
				end
			end, 'slaughteredchicken')
			ClearPedTasks(PlayerPedId())
			DeleteEntity(karton)
			DeleteEntity(mieso)
			end, function() -- Cancel
				--isWashing = false
				ClearPedTasksImmediately(player)
				FreezeEntityPosition(player, false)
			end)
		else
		
		AJFW.Functions.Notify("You have nothing to pack!", "error")
		end
	end, 'slaughteredchicken')
end
------------------DEVELOPED BY aj-----------------------------------------

function packed(stanowisko)
	FreezeEntityPosition(PlayerPedId(), false)
	zapakowaneDoauta = true
	local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
	prop = CreateObject(GetHashKey('hei_prop_heist_box'), x, y, z+0.2,  true,  true, true)
	AttachEntityToEntity(prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 60309), 0.025, 0.08, 0.255, -145.0, 290.0, 0.0, true, true, false, true, 1, true)
	packs = 0
	while zapakowaneDoauta do
	Citizen.Wait(250)
	
	local coords    = GetEntityCoords(PlayerPedId())
	LoadDict('anim@heists@box_carry@')
	
		if not IsEntityPlayingAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 3 ) and zapakowaneDoauta == true then
		TaskPlayAnim(PlayerPedId(), 'anim@heists@box_carry@', "idle", 3.0, -8, -1, 63, 0, 0, 0, 0 )
		end
		
		zapakowaneDoauta = false
		AJFW.Functions.Notify("You stopped packing!", "error")
		LoadDict('anim@heists@narcotics@trash')
		TaskPlayAnim(PlayerPedId(), 'anim@heists@narcotics@trash', "throw_a", 3.0, -8, -1, 63, 0, 0, 0, 0 )
		Citizen.Wait(900)
		ClearPedTasks(PlayerPedId())
		DeleteEntity(prop)
	
	end
end


------------------DEVELOPED BY aj-----------------------------------------

function portioning(position)
	local inventory =  AJFW.Functions.GetPlayerData()
	
	AJFW.Functions.TriggerCallback('AJFW:HasItem', function(result)
		if result then
			local dict = 'anim@amb@business@coc@coc_unpack_cut_left@'
			LoadDict(dict)
			FreezeEntityPosition(PlayerPedId(),true)
			TaskPlayAnim(PlayerPedId(), dict, "coke_cut_v1_coccutter", 3.0, -8, -1, 63, 0, 0, 0, 0 )
			local PedCoords = GetEntityCoords(PlayerPedId())
			nozyk = CreateObject(GetHashKey('prop_knife'),PedCoords.x, PedCoords.y,PedCoords.z, true, true, true)
			AttachEntityToEntity(nozyk, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0xDEAD), 0.13, 0.14, 0.09, 40.0, 0.0, 0.0, false, false, false, false, 2, true)
			if position == 1 then
			SetEntityHeading(PlayerPedId(), 311.0)
			kurczak = CreateObject(GetHashKey('prop_int_cf_chick_01'),-94.87, 6207.008, 30.08, true, true, true)
			SetEntityRotation(kurczak,90.0, 0.0, 45.0, 1,true)
			AJFW.Functions.Progressbar("Cut-", "Slaughtering..", 15000, false, true, {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			}, {}, {}, {}, function()

			AJFW.Functions.TriggerCallback('AJFW:HasItem', function(result1)
				if result1 then	
					AJFW.Functions.Notify("Now Pack slaughtered chicken!", "primary")
					TriggerServerEvent("aj-chickenjob:getcutChicken", 1)
				else
					-- print("badhe teej bannre the na xD")
					AJFW.Functions.Notify("You dont have any chickens!", "error")
					FreezeEntityPosition(PlayerPedId(),false)
				end
			end, 'alivechicken')
			FreezeEntityPosition(PlayerPedId(),false)
			DeleteEntity(kurczak)
			DeleteEntity(nozyk)
			end, function() -- Cancel
				FreezeEntityPosition(PlayerPedId(),false)
				DeleteEntity(kurczak)
				DeleteEntity(nozyk)
				ClearPedTasks(PlayerPedId())
			end)
			elseif position == 2 then
			SetEntityHeading(PlayerPedId(), 222.0)
			kurczak = CreateObject(GetHashKey('prop_int_cf_chick_01'),-100.39, 6201.56, 29.99, true, true, true)
			SetEntityRotation(kurczak,90.0, 0.0, -45.0, 1,true)

			AJFW.Functions.Progressbar("Cut-", "Slaughtering..", 15000, false, true, {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			}, {}, {}, {}, function()

			AJFW.Functions.TriggerCallback('AJFW:HasItem', function(result1)
				if result1 then	
					AJFW.Functions.Notify("Now Pack slaughtered chicken!", "primary")
					TriggerServerEvent("aj-chickenjob:getcutChicken", 1)
				else
					-- print("badhe teej bannre the na xD")
					AJFW.Functions.Notify("You dont have any chickens!", "error")
					FreezeEntityPosition(PlayerPedId(),false)
				end
			end, 'alivechicken')
			FreezeEntityPosition(PlayerPedId(),false)
			DeleteEntity(kurczak)
			DeleteEntity(nozyk)
			end, function() -- Cancel
				FreezeEntityPosition(PlayerPedId(),false)
				DeleteEntity(kurczak)
				DeleteEntity(nozyk)
				ClearPedTasks(PlayerPedId())
			end)
			elseif position == 3 then
				SetEntityHeading(PlayerPedId(), 226.07)
				kurczak = CreateObject(GetHashKey('prop_int_cf_chick_01'),-99.90, 6205.48, 30.1, true, true, true)
				SetEntityRotation(kurczak,90.0, 0.0, -45.0, 1,true)

				AJFW.Functions.Progressbar("Cut-", "Slaughtering..", 15000, false, true, {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				}, {}, {}, {}, function()

				AJFW.Functions.TriggerCallback('AJFW:HasItem', function(result1)
					if result1 then	
						AJFW.Functions.Notify("Now Pack slaughtered chicken!", "primary")
						TriggerServerEvent("aj-chickenjob:getcutChicken", 1)
					else
						-- print("badhe teej bannre the na xD")
						AJFW.Functions.Notify("You dont have any chickens!", "error")
						FreezeEntityPosition(PlayerPedId(),false)
					end
				end, 'alivechicken')
				FreezeEntityPosition(PlayerPedId(),false)
				DeleteEntity(kurczak)
				DeleteEntity(nozyk)
				end, function() -- Cancel
					FreezeEntityPosition(PlayerPedId(),false)
					DeleteEntity(kurczak)
					DeleteEntity(nozyk)
					ClearPedTasks(PlayerPedId())
				end)
			end		
		else
			AJFW.Functions.Notify("You dont have any chickens!", "error")
		end
	end, 'alivechicken')
end

------------------DEVELOPED BY aj-----------------------------------------

function packedsell()
	local inventory =  AJFW.Functions.GetPlayerData()
	AJFW.Functions.TriggerCallback('AJFW:HasItem', function(result)
		if result then
			local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.9, -0.98))
			prop = CreateObject(GetHashKey('hei_prop_heist_box'), x, y, z,  true,  true, true)
			SetEntityHeading(prop, GetEntityHeading(PlayerPedId()))
			LoadDict('amb@medic@standing@tendtodead@idle_a')
			TaskPlayAnim(PlayerPedId(), 'amb@medic@standing@tendtodead@idle_a', 'idle_a', 8.0, -8.0, -1, 1, 0.0, 0, 0, 0)
			AJFW.Functions.Progressbar("Cut-", "Selling..", 10000, false, true, {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			}, {}, {}, {}, function()
				AJFW.Functions.TriggerCallback('AJFW:HasItem', function(result1)
					if result1 then	
						TriggerServerEvent("aj-chickenjob:sell",3)
					else
						-- print("badhe teej bannre the na xD")
						AJFW.Functions.Notify("You have nothing to sell!", "error")
						FreezeEntityPosition(PlayerPedId(),false)
					end
				end, 'packagedchicken')
				
				ClearPedTasks(PlayerPedId())
				DeleteEntity(prop)
			end, function() -- Cancel
				LoadDict('amb@medic@standing@tendtodead@exit')
				TaskPlayAnim(PlayerPedId(), 'amb@medic@standing@tendtodead@exit', 'exit', 8.0, -8.0, -1, 1, 0.0, 0, 0, 0)
				ClearPedTasks(PlayerPedId())
				DeleteEntity(prop)
				FreezeEntityPosition(PlayerPedId(),false)
			end)
		else
			AJFW.Functions.Notify("You have nothing to sell!", "error")
		end
	
	end, 'packagedchicken')
end
------------------DEVELOPED BY aj-----------------------------------------