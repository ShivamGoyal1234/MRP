local tiempo = 4000 -- 1000 ms = 1s
local isTaz = false
CreateThread(function()
	while true do
		Wait(5)
		
		if IsPedBeingStunned(PlayerPedId()) then
			
			SetPedToRagdoll(PlayerPedId(), 5000, 5000, 0, 0, 0, 0)
			
		end
		
		if IsPedBeingStunned(PlayerPedId()) and not isTaz then
			
			isTaz = true
			SetTimecycleModifier("REDMIST_blend")
			ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE", 1.0)
			
		elseif not IsPedBeingStunned(PlayerPedId()) and isTaz then
			isTaz = false
			Wait(5000)
			
			SetTimecycleModifier("hud_def_desat_Trevor")
			
			Wait(10000)
			
      		SetTimecycleModifier("")
			SetTransitionTimecycleModifier("")
			StopGameplayCamShaking()
		end
	end
end)