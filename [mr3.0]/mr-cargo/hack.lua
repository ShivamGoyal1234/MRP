local scaleform = nil
local ClickReturn 
local lives = 5 --7 Lives in GTA Online
local gamePassword = "MRPBMRFW" --You could make a table with passwords and assign them as passwords in random order.

local hacking = false
local weWON = false

function StartHacking()
	weWON = false

	local function Initialize(scaleform)
		local scaleform = RequestScaleformMovieInteractive(scaleform)
		while not HasScaleformMovieLoaded(scaleform) do
			Citizen.Wait(0)
		end

		-- BeginScaleformMovieMethod(scaleform, "SET_LABELS") --this allows us to label every item inside My Computer
		-- ScaleformMovieMethodAddParamTextureNameString("Local Disk (C:)")
		-- ScaleformMovieMethodAddParamTextureNameString("Network")
		-- ScaleformMovieMethodAddParamTextureNameString("External Device (J:)")
		-- ScaleformMovieMethodAddParamTextureNameString("HackConnect.exe")
		-- ScaleformMovieMethodAddParamTextureNameString("BruteForce.exe")
		-- EndScaleformMovieMethod()

		BeginScaleformMovieMethod(scaleform, "SET_LABELS") --this allows us to label every item inside My Computer
		ScaleformMovieMethodAddParamTextureNameString("Local Disk (C:)")
		ScaleformMovieMethodAddParamTextureNameString("Network")
		ScaleformMovieMethodAddParamTextureNameString("External Device (J:)")
		ScaleformMovieMethodAddParamTextureNameString("HackConnect.exe")
		ScaleformMovieMethodAddParamTextureNameString("BruteForce.exe")
		EndScaleformMovieMethod()

		BeginScaleformMovieMethod(scaleform, "SET_BACKGROUND") --We can set the background of the scaleform, so far 0-6 works.
		ScaleformMovieMethodAddParamInt(0)
		EndScaleformMovieMethod()

		BeginScaleformMovieMethod(scaleform, "ADD_PROGRAM") --We add My Computer application to the scaleform
		ScaleformMovieMethodAddParamFloat(1.0) -- Position in the scaleform most left corner
		ScaleformMovieMethodAddParamFloat(4.0)
		ScaleformMovieMethodAddParamTextureNameString("My Computer")
		EndScaleformMovieMethod()

		BeginScaleformMovieMethod(scaleform, "ADD_PROGRAM") --We Power off app so we can exit the scaleform
		ScaleformMovieMethodAddParamFloat(6.0) -- Position in the scaleform most right corner
		ScaleformMovieMethodAddParamFloat(6.0)
		ScaleformMovieMethodAddParamTextureNameString("Power Off")
		EndScaleformMovieMethod()

		BeginScaleformMovieMethod(scaleform, "SET_COLUMN_SPEED") --BruteForce.exe Column Speed, the higher the speed, harder it gets(kinda 255 seems to be max).
		ScaleformMovieMethodAddParamInt(0)
		ScaleformMovieMethodAddParamInt(math.random(150,255))
		EndScaleformMovieMethod()

		BeginScaleformMovieMethod(scaleform, "SET_COLUMN_SPEED")
		ScaleformMovieMethodAddParamInt(1)
		ScaleformMovieMethodAddParamInt(math.random(160,255))
		EndScaleformMovieMethod()

		BeginScaleformMovieMethod(scaleform, "SET_COLUMN_SPEED")
		ScaleformMovieMethodAddParamInt(2)
		ScaleformMovieMethodAddParamInt(math.random(170,255))
		EndScaleformMovieMethod()

		BeginScaleformMovieMethod(scaleform, "SET_COLUMN_SPEED")
		ScaleformMovieMethodAddParamInt(3)
		ScaleformMovieMethodAddParamInt(math.random(190,255))
		EndScaleformMovieMethod()

		BeginScaleformMovieMethod(scaleform, "SET_COLUMN_SPEED")
		ScaleformMovieMethodAddParamInt(4)
		ScaleformMovieMethodAddParamInt(math.random(200,255))
		EndScaleformMovieMethod()

		BeginScaleformMovieMethod(scaleform, "SET_COLUMN_SPEED")
		ScaleformMovieMethodAddParamInt(5)
		ScaleformMovieMethodAddParamInt(math.random(210,255))
		EndScaleformMovieMethod()

		BeginScaleformMovieMethod(scaleform, "SET_COLUMN_SPEED")
		ScaleformMovieMethodAddParamInt(6)
		ScaleformMovieMethodAddParamInt(math.random(220,255))
		EndScaleformMovieMethod()

		BeginScaleformMovieMethod(scaleform, "SET_COLUMN_SPEED")
		ScaleformMovieMethodAddParamInt(7)
		ScaleformMovieMethodAddParamInt(255)
		EndScaleformMovieMethod()

		return scaleform
	end

	lives = 5
	scaleform = Initialize("HACKING_PC") -- THE SCALEFORM WE ARE USING: https://scaleform.devtesting.pizza/#HACKING_PC

	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(0)
	end

	hacking = true

	TriggerEvent('mr-hud:displayHud', false)

	while hacking do
		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
		BeginScaleformMovieMethod(scaleform, "SET_CURSOR") --We use this scaleform function to define what input is going to move the cursor
		ScaleformMovieMethodAddParamFloat(GetControlNormal(0, 239)) 
		ScaleformMovieMethodAddParamFloat(GetControlNormal(0, 240))
		EndScaleformMovieMethod()
		if IsDisabledControlJustPressed(0,24) then -- IF LEFT CLICK IS PRESSED WE SELECT SOMETHING IN THE SCALEFORM
			BeginScaleformMovieMethod(scaleform, "SET_INPUT_EVENT_SELECT")
			ClickReturn = EndScaleformMovieMethodReturnValue()
			PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
		elseif IsDisabledControlJustPressed(0, 25) then -- IF RIGHT CLICK IS PRESSED WE GO BACK.
			BeginScaleformMovieMethod(scaleform, "SET_INPUT_EVENT_BACK")
			EndScaleformMovieMethod()
			PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
		end

		Citizen.Wait(0)
	end

	return weWON
end

Citizen.CreateThread(function()
	while true do
		if HasScaleformMovieLoaded(scaleform) then
			DisableControlAction(0, 24, true) --LEFT CLICK disabled while in scaleform
			DisableControlAction(0, 25, true) --RIGHT CLICK disabled while in scaleform
		else
			Citizen.Wait(250)
		end

		Citizen.Wait(5)
	end
end)

-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(1500)
-- 		print(GetScaleformMovieMethodReturnValueInt(ClickReturn))
-- 	end
-- end)

Citizen.CreateThread(function()
	while true do
		if HasScaleformMovieLoaded(scaleform) then
			FreezeEntityPosition(PlayerPedId(), true) --If the user is in scaleform we should freeze him to prevent movement.

			-- if GetScaleformMovieMethodReturnValueBool(ClickReturn) then -- old native?
				ProgramID = GetScaleformMovieMethodReturnValueInt(ClickReturn)

				if ProgramID == 82 then --HACKCONNECT.EXE (ITS SCALEFORM FUNCTIONS DOESNT SEEM TO WORK SO WE KEEP IT DISABLED)
					PlaySoundFrontend(-1, "HACKING_CLICK_BAD", "", false)

				elseif ProgramID == 83 then  --BRUTEFORCE.EXE
					BeginScaleformMovieMethod(scaleform, "RUN_PROGRAM")
					ScaleformMovieMethodAddParamFloat(83.0)
					EndScaleformMovieMethod()

					BeginScaleformMovieMethod(scaleform, "SET_ROULETTE_WORD")
					ScaleformMovieMethodAddParamTextureNameString(gamePassword)
					EndScaleformMovieMethod()

				elseif ProgramID == 87 then --IF YOU CLICK THE WRONG LETTER IN BRUTEFORCE APP
					lives = lives - 1

					BeginScaleformMovieMethod(scaleform, "SET_ROULETTE_WORD")
					ScaleformMovieMethodAddParamTextureNameString(gamePassword)
					EndScaleformMovieMethod()

					PlaySoundFrontend(-1, "HACKING_CLICK_BAD", "", false)
					BeginScaleformMovieMethod(scaleform, "SET_LIVES")
					ScaleformMovieMethodAddParamInt(lives) --We set how many lives our user has before he fails the bruteforce.
					ScaleformMovieMethodAddParamInt(5)
					EndScaleformMovieMethod()

				elseif ProgramID == 92 then --IF YOU CLICK THE RIGHT LETTER IN BRUTEFORCE APP, you could add more lives here.
					PlaySoundFrontend(-1, "HACKING_CLICK_GOOD", "", false)

				elseif ProgramID == 86 then --IF YOU SUCCESSFULY GET ALL LETTERS RIGHT IN BRUTEFORCE APP
					weWON = true

					PlaySoundFrontend(-1, "HACKING_SUCCESS", "", true)
					
					BeginScaleformMovieMethod(scaleform, "SET_ROULETTE_OUTCOME")
					ScaleformMovieMethodAddParamBool(true)
					ScaleformMovieMethodAddParamTextureNameString("BRUTEFORCE SUCCESSFUL!")
					EndScaleformMovieMethod()
					
					Wait(2800) --We wait 2.8 to let the bruteforce message sink in before we continue
					BeginScaleformMovieMethod(scaleform, "CLOSE_APP")
					EndScaleformMovieMethod()
					
					BeginScaleformMovieMethod(scaleform, "OPEN_LOADING_PROGRESS")
					ScaleformMovieMethodAddParamBool(true)
					EndScaleformMovieMethod()
					
					BeginScaleformMovieMethod(scaleform, "SET_LOADING_PROGRESS")
					ScaleformMovieMethodAddParamInt(35)
					EndScaleformMovieMethod()
					
					BeginScaleformMovieMethod(scaleform, "SET_LOADING_TIME")
					ScaleformMovieMethodAddParamInt(35)
					EndScaleformMovieMethod()
					
					BeginScaleformMovieMethod(scaleform, "SET_LOADING_MESSAGE")
					ScaleformMovieMethodAddParamTextureNameString("Writing data to buffer..")
					ScaleformMovieMethodAddParamFloat(2.0)
					EndScaleformMovieMethod()
					Wait(1500)
					
					BeginScaleformMovieMethod(scaleform, "SET_LOADING_MESSAGE")
					ScaleformMovieMethodAddParamTextureNameString("Executing malicious code..")
					ScaleformMovieMethodAddParamFloat(2.0)
					EndScaleformMovieMethod()
					
					BeginScaleformMovieMethod(scaleform, "SET_LOADING_TIME")
					ScaleformMovieMethodAddParamInt(15)
					EndScaleformMovieMethod()
					
					BeginScaleformMovieMethod(scaleform, "SET_LOADING_PROGRESS")
					ScaleformMovieMethodAddParamInt(75)
					EndScaleformMovieMethod()
					
					Wait(1500)
					BeginScaleformMovieMethod(scaleform, "OPEN_LOADING_PROGRESS")
					ScaleformMovieMethodAddParamBool(false)
					EndScaleformMovieMethod()
					
					BeginScaleformMovieMethod(scaleform, "OPEN_ERROR_POPUP")
					ScaleformMovieMethodAddParamBool(true)
					ScaleformMovieMethodAddParamTextureNameString("MEMORY LEAK DETECTED, DEVICE SHUTTING DOWN")
					EndScaleformMovieMethod()
					
					Wait(3500)
					SetScaleformMovieAsNoLongerNeeded(scaleform) --EXIT SCALEFORM
					EndScaleformMovieMethod()
					FreezeEntityPosition(PlayerPedId(), false) --unfreeze our character
				elseif ProgramID == 6 then
					Wait(500) -- WE WAIT 0.5 SECONDS TO EXIT SCALEFORM, JUST TO SIMULATE A SHUTDOWN, OTHERWISE IT CLOSES INSTANTLY
					SetScaleformMovieAsNoLongerNeeded(scaleform) --EXIT SCALEFORM
					FreezeEntityPosition(PlayerPedId(), false) --unfreeze our character
					DisableControlAction(0, 24, false) --LEFT CLICK enabled again
					DisableControlAction(0, 25, false) --RIGHT CLICK enabled again
				end

				if lives == 0 then
					PlaySoundFrontend(-1, "HACKING_FAILURE", "", true)
					BeginScaleformMovieMethod(scaleform, "SET_ROULETTE_OUTCOME")
					ScaleformMovieMethodAddParamBool(false)
					ScaleformMovieMethodAddParamTextureNameString("BRUTEFORCE FAILED!")
					EndScaleformMovieMethod()
					
					Wait(3500) --WE WAIT 3.5 seconds here aswell to let the bruteforce message sink in before exiting.
					BeginScaleformMovieMethod(scaleform, "CLOSE_APP")
					EndScaleformMovieMethod()
					
					BeginScaleformMovieMethod(scaleform, "OPEN_ERROR_POPUP")
					ScaleformMovieMethodAddParamBool(true)
					ScaleformMovieMethodAddParamTextureNameString("MEMORY LEAK DETECTED, DEVICE SHUTTING DOWN")
					EndScaleformMovieMethod()
					
					Wait(2500)
					SetScaleformMovieAsNoLongerNeeded(scaleform)
					EndScaleformMovieMethod()
					FreezeEntityPosition(PlayerPedId(), false) --unfreeze our character
					DisableControlAction(0, 24, false) --LEFT CLICK enabled again
					DisableControlAction(0, 25, false) --RIGHT CLICK enabled again
				end
			-- end
		else
			if hacking then
				hacking = false
				TriggerEvent('mr-hud:displayHud', true)
				SetScaleformMovieAsNoLongerNeeded(scaleform)
			end

			Citizen.Wait(250)
		end

		Citizen.Wait(5)
	end
end)
