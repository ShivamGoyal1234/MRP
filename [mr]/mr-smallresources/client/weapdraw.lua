local weapons = {
	'WEAPON_KNIFE',
	'WEAPON_NIGHTSTICK',
	'WEAPON_BREAD',
	'WEAPON_FLASHLIGHT',
	'WEAPON_HAMMER',
	'WEAPON_BAT',
	'WEAPON_GOLFCLUB',
	'WEAPON_CROWBAR',
	'WEAPON_BOTTLE',
	'WEAPON_DAGGER',
	'WEAPON_HATCHET',
	'WEAPON_MACHETE',
	'WEAPON_SWITCHBLADE',
	'WEAPON_BATTLEAXE',
	'WEAPON_POOLCUE',
	'WEAPON_WRENCH',
	'WEAPON_PISTOL',
	'WEAPON_PISTOL_MK2',
	'WEAPON_COMBATPISTOL',
	'WEAPON_APPISTOL',
	'WEAPON_PISTOL50',
	'WEAPON_REVOLVER',
	'WEAPON_SNSPISTOL',
	'WEAPON_HEAVYPISTOL',
	'WEAPON_VINTAGEPISTOL',
	'WEAPON_MICROSMG',
	'WEAPON_SMG',
	'WEAPON_ASSAULTSMG',
	'WEAPON_MINISMG',
	'WEAPON_MACHINEPISTOL',
	'WEAPON_COMBATPDW',
	'WEAPON_PUMPSHOTGUN',
	'WEAPON_SAWNOFFSHOTGUN',
	'WEAPON_ASSAULTSHOTGUN',
	'WEAPON_BULLPUPSHOTGUN',
	'WEAPON_HEAVYSHOTGUN',
	'WEAPON_ASSAULTRIFLE',
	'WEAPON_CARBINERIFLE',
	'WEAPON_ADVANCEDRIFLE',
	'WEAPON_SPECIALCARBINE',
	'WEAPON_BULLPUPRIFLE',
	'WEAPON_COMPACTRIFLE',
	'WEAPON_MG',
	'WEAPON_COMBATMG',
	'WEAPON_GUSENBERG',
	'WEAPON_SNIPERRIFLE',
	'WEAPON_HEAVYSNIPER',
	'WEAPON_MARKSMANRIFLE',
	'WEAPON_GRENADELAUNCHER',
	'WEAPON_RPG',
	'WEAPON_STINGER',
	'WEAPON_MINIGUN',
	'WEAPON_GRENADE',
	'WEAPON_STICKYBOMB',
	'WEAPON_SMOKEGRENADE',
	'WEAPON_BZGAS',
	'WEAPON_MOLOTOV',
	'WEAPON_DIGISCANNER',
	'WEAPON_FIREWORK',
	'WEAPON_MUSKET',
	'WEAPON_STUNGUN',
	'WEAPON_HOMINGLAUNCHER',
	'WEAPON_PROXMINE',
	'WEAPON_FLAREGUN',
	'WEAPON_MARKSMANPISTOL',
	'WEAPON_RAILGUN',
	'WEAPON_DBSHOTGUN',
	'WEAPON_AUTOSHOTGUN',
	'WEAPON_COMPACTLAUNCHER',
	'WEAPON_PIPEBOMB',
	'WEAPON_DOUBLEACTION',
	'WEAPON_RAYCARBINE',
	'WEAPON_MUSKET',
	'WEAPON_DBSHOTGUN',
	'WEAPON_AUTOSHOTGUN',
	'WEAPON_PUMPSHOTGUN_MK2',
	'WEAPON_COMBATSHOTGUN',
	'WEAPON_ASSAULTRIFLE_MK2',
	'WEAPON_CARBINERIFLE_MK2',
	'WEAPON_SPECIALCARBINE_MK2',
	'WEAPON_BULLPUPRIFLE_MK2',
	'WEAPON_MILITARYRIFLE',
	'WEAPON_HEAVYRIFLE',
	'WEAPON_COMBATMG_MK2',
	'WEAPON_HEAVYSNIPER_MK2',
	'WEAPON_MARKSMANRIFLE_MK2',
	'WEAPON_THERMALKATANA',
	'WEAPON_KIBA',
	'WEAPON_SOGFASTHAWK',
	'WEAPON_BERSERKER',
	'WEAPON_M4A4',
	'WEAPON_NSR',
	'WEAPON_P90',
	'WEAPON_AWP',
	'WEAPON_REVOLVER_MK2',
	'WEAPON_SNSPISTOL_MK2',
	'WEAPON_CERAMICPISTOL',
	'WEAPON_NAVYREVOLVER',
	'WEAPON_GADGETPISTOL',
	'WEAPON_KARAMBIT',
	'WEAPON_DAGGER2',
	'WEAPON_HKE1',
	'WEAPON_GLOCK17'
}

local holsterableWeapons = {
	[`weapon_pistol`] = true,
	[`weapon_cartel1911`] = true,
	[`weapon_pistol_mk2`] = true,
	[`weapon_dutypistol`] = true,
	[`weapon_combatpistol`] = true,
	[`weapon_appistol`] = true,
	[`weapon_stungun`] = true,
	[`weapon_pistol50`] = true,
	[`weapon_snspistol`] = true,
	[`weapon_heavypistol`] = true,
	[`weapon_vintagepistol`] = true,
	[`weapon_flaregun`] = true,
	[`weapon_marksmanpistol`] = true,
	[`weapon_revolver`] = true,
	[`weapon_revolver_mk2`] = true,
	[`weapon_doubleaction`] = true,
	[`weapon_snspistol_mk2`] = true,
	[`weapon_raypistol`] = true,
	[`weapon_ceramicpistol`] = true,
	[`weapon_navyrevolver`] = true,
	[`weapon_gadgetpistol`] = true,
	[`weapon_m45a1`] = true,
	[`weapon_gardone`] = true,
	[`weapon_cutlass`] = true,
	[`WEAPON_KARAMBIT`] = true,
	[`WEAPON_DAGGER2`] = true,
	[`WEAPON_MARKSMANPISTOL`] = true,
	[`WEAPON_GLOCK17`] = true,
}

local ignoreWeapons = {
	[`weapon_unarmed`] = true,
	[`weapon_briefcase`] = true,
	[`weapon_briefcase02`] = true,	
	[`weapon_garbagebag`] = true,	
	[`weapon_flashlight`] = true,	
}

Holsters = {
	[1] = 3,
	[8] = 2,
	[9] = 2,
	[6] = 5,
	[56] = 57,
	[58] = 59,
	[60] = 61,
	[62] = 63,
	[64] = 65,
	[66] = 67,
	[71] = 72,
	[119] = 120,
}



local holstered = true
local canFire = true
local currWeapon = `WEAPON_UNARMED`
local currentHolster = nil
local currentHolsterTexture = nil
local WearingHolster = nil
local currentDrawable = nil
local prevHolsterTexture

RegisterNetEvent('weapons:ResetHolster', function()
	holstered = true
	canFire = true
	currWeapon = `WEAPON_UNARMED`
	currentHolster = nil
	currentHolsterTexture = nil
	WearingHolster = nil
end)

-------------- threads ---------------------------------------


-- CreateThread(function()
-- 	while true do
-- 		Wait(0)
--         if LocalPlayer.state.isLoggedIn then
-- 	        ped = PlayerPedId()
-- 	        Wait(1000)
--         end
-- 	end
-- end)

CreateThread(function()
	while true do
		if not canFire then
			DisableControlAction(0, 25, true)
			DisablePlayerFiring(PlayerPedId(), true)
		else
			Wait(100)
		end

		Wait(5)
	end
end)

CreateThread(function()
	while true do
		Wait(0)
        if LocalPlayer.state.isLoggedIn then
			local ped = PlayerPedId()
			if DoesEntityExist(ped) and not IsEntityDead(ped) and not IsPedInParachuteFreeFall(ped) and not IsPedFalling(ped) and (GetPedParachuteState(ped) == -1 or GetPedParachuteState(ped) == 0) then
				if currWeapon ~= GetSelectedPedWeapon(ped) then
					pos = GetEntityCoords(ped, true)
					rot = GetEntityHeading(ped)

					local newWeap = GetSelectedPedWeapon(ped)
					SetCurrentPedWeapon(ped, currWeapon, true)
					loadAnimDict("reaction@intimidation@1h")
					loadAnimDict("reaction@intimidation@cop@unarmed")
					loadAnimDict("rcmjosh4")
					loadAnimDict("weapons@pistol@")

					local currentComponent = GetPedDrawableVariation(ped, 7)
					if currentDrawable == 8 then currentComponent = GetPedDrawableVariation(ped, 8) end

					if currentComponent ~= currentHolster and currentComponent ~= currentEmpty then
						if Holsters[currentComponent] then
							WearingHolster = true
							currentHolster = currentComponent
							currentEmpty = Holsters[currentComponent]
							currentDrawable = 7
							currentHolsterTexture = GetPedTextureVariation(ped, 7)
						elseif GetPedDrawableVariation(ped, 8) == 230 then
							WearingHolster = true
							currentHolster = 230
							currentEmpty = 247
							currentDrawable = 8
							currentHolsterTexture = GetPedTextureVariation(ped, 8)
						else
							WearingHolster = false
						end
					end

					if currentDrawable == 8 then
						if holstered then 
							prevHolsterTexture = currentHolsterTexture
							currentHolsterTexture = 0
						else
							currentHolsterTexture = prevHolsterTexture
						end
					end

					-- print(currentDrawable, currentHolster, currentHolsterTexture)

					if newWeap == `weapon_unarmed` then
						if WearingHolster and holsterableWeapons[currWeapon] then
							-- print('putting away holsterable weapon')					    
							canFire = false
							TaskPlayAnimAdvanced(ped, "reaction@intimidation@cop@unarmed", "intro", GetEntityCoords(ped, true), 0, 0, rot, 3.0, 3.0, -1, 50, 0, 0, 0)
							Wait(300)
							
							SetPedComponentVariation(ped, currentDrawable, currentHolster, currentHolsterTexture, 2)

							ClearPedTasks(ped)
							SetCurrentPedWeapon(ped, newWeap, true)

							holstered = true
							canFire = true
							currWeapon = newWeap
						else 
							-- print('putting away weapon without holster')
							canFire = false
							TaskPlayAnimAdvanced(ped, "reaction@intimidation@1h", "outro", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0, 0, 0)
							Wait(1400)
							--SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
							ClearPedTasks(ped)
							SetCurrentPedWeapon(ped, newWeap, true)
							holstered = true
							canFire = true
							currWeapon = newWeap
						end
					else
						if currWeapon == `weapon_unarmed` then
							if WearingHolster and holsterableWeapons[newWeap] then
								-- print('draw from holster, unarmed')
								canFire = false

								TaskPlayAnimAdvanced(ped, "reaction@intimidation@cop@unarmed", "intro", GetEntityCoords(ped, true), 0, 0, rot, 3.0, 3.0, -1, 50, 0, 0, 0)
								Wait(300)
								SetCurrentPedWeapon(ped, newWeap, true)
								SetPedComponentVariation(ped, currentDrawable, currentEmpty, currentHolsterTexture, 2)
								currWeapon = newWeap
								Wait(300)
								ClearPedTasks(ped)
								holstered = false
								canFire = true
							else
								-- print('draw from back, unarmed')
								canFire = false
								TaskPlayAnimAdvanced(ped, "reaction@intimidation@1h", "outro", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0, 0, 0)
								Wait(1600)
								SetCurrentPedWeapon(ped, newWeap, true)
								currWeapon = newWeap
								--Wait(1400)
								ClearPedTasks(ped)
								holstered = false
								canFire = true

							end
						else
							if WearingHolster and holsterableWeapons[newWeap] then

								if currentDrawable == 8 then 
									prevHolsterTexture = currentHolsterTexture
									currentHolsterTexture = 0
								else
									currentHolsterTexture = prevHolsterTexture
								end

								if holsterableWeapons[currWeapon] then
									-- print('drawing from holster, prev gun holsterable')
									canFire = false

									TaskPlayAnimAdvanced(ped, "reaction@intimidation@cop@unarmed", "intro", GetEntityCoords(ped, true), 0, 0, rot, 3.0, 3.0, -1, 50, 0, 0, 0)
									Wait(300)
									SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
									SetPedComponentVariation(ped, currentDrawable, currentHolster, currentHolsterTexture, 2)

									TaskPlayAnimAdvanced(ped, "rcmjosh4", "josh_leadout_cop2", GetEntityCoords(ped, true), 0, 0, rot, 3.0, 3.0, -1, 50, 0, 0, 0)
									Wait(300)
									SetCurrentPedWeapon(ped, newWeap, true)
									SetPedComponentVariation(ped, currentDrawable, currentEmpty, currentHolsterTexture, 2)
									currWeapon = newWeap
									Wait(300)
									ClearPedTasks(ped)
									holstered = false
									canFire = true
								else
									-- print('drawing from holster, prev gun not holsterable')
									canFire = false
									TaskPlayAnimAdvanced(ped, "reaction@intimidation@1h", "outro", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0, 0, 0)
									Wait(1600)
									SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)

									TaskPlayAnimAdvanced(ped, "rcmjosh4", "josh_leadout_cop2", GetEntityCoords(ped, true), 0, 0, rot, 3.0, 3.0, -1, 50, 0, 0, 0)
									Wait(300)
									SetCurrentPedWeapon(ped, newWeap, true)
									SetPedComponentVariation(ped, currentDrawable, currentEmpty, currentHolsterTexture, 2)
									currWeapon = newWeap
									Wait(300)
									ClearPedTasks(ped)
									holstered = false
									canFire = true
								end
							else
								if holsterableWeapons[currWeapon] then
									canFire = false
									TaskPlayAnimAdvanced(ped, "reaction@intimidation@cop@unarmed", "intro", GetEntityCoords(ped, true), 0, 0, rot, 3.0, 3.0, -1, 50, 0, 0, 0)
									Wait(300)
									SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
									SetPedComponentVariation(ped, currentDrawable, currentHolster, currentHolsterTexture, 2)

									TaskPlayAnimAdvanced(ped, "reaction@intimidation@1h", "intro", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0, 0, 0)
									Wait(1000)
									SetCurrentPedWeapon(ped, newWeap, true)

									currWeapon = newWeap
									Wait(300)
									ClearPedTasks(ped)
									holstered = false
									canFire = true								
								else
									-- print('drawing new gun from back, prev gun not holsterable')
									canFire = false
									TaskPlayAnimAdvanced(ped, "reaction@intimidation@1h", "outro", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0, 0, 0)
									Wait(1600)
									SetCurrentPedWeapon(ped, newWeap, true)
									currWeapon = newWeap
									--Wait(1400)
									ClearPedTasks(ped)
									holstered = false
									canFire = true
								end
							end
						end
					end
				end
			else
				Wait(50)
			end

			Wait(5)
		else
			Wait(2500)
		end
	end
end)