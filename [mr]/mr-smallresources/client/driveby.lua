-- CONFIG --

-- Allow passengers to shoot
local passengerDriveBy = true

-- CODE --

CreateThread(function()
	while true do
		sleep = 500

		local playerPed = PlayerPedId()
		local car = GetVehiclePedIsIn(playerPed, false)
		if car then
			sleep = 100
			if GetPedInVehicleSeat(car, -1) == playerPed then
				SetPlayerCanDoDriveBy(PlayerId(), false)
			elseif passengerDriveBy then
				SetPlayerCanDoDriveBy(PlayerId(), true)
			else
				SetPlayerCanDoDriveBy(PlayerId(), false)
			end
		end
		Wait(sleep)
	end
end)

RegisterNetEvent('MRFW:Client:OnGangUpdate', function(GangInfo)
    local PlayerGang = GangInfo
    local ped = PlayerPedId()
    if PlayerGang and PlayerGang.name ~= "none" then
        SetWeaponAnimationOverride(ped, `Gang1H`)
    elseif PlayerGang and PlayerGang.name == "none" then
        SetWeaponAnimationOverride(ped, `default`)
    end
end)