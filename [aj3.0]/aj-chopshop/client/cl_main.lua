-- New Core and Old Core stuff
if Config.Version == "new" then

    AJFW = exports['ajfw']:GetCoreObject()

end

local PlayerJob = {}
local secondwave = false
local vehicle
local start = false
local removedpart = false

local dropoffx = nil
local dropoffy = nil
local dropoffz = nil
local dropoffm = nil

local LicensePlate = nil
local randomLoc = nil
local vehicle = nil
local copsCalled = false
local cooldown = false
local scrapblip = false

-- Job Update and checks
RegisterNetEvent('AJFW:Client:OnJobUpdate')
AddEventHandler('AJFW:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    onDuty = true
end)

RegisterNetEvent("AJFW:Client:OnPlayerLoaded")
AddEventHandler("AJFW:Client:OnPlayerLoaded", function()
    PlayerJob = AJFW.Functions.GetPlayerData().job
    onDuty = true
end)

Citizen.CreateThread(function()
    Wait(500)
    if AJFW.Functions.GetPlayerData() ~= nil then
        PlayerJob = AJFW.Functions.GetPlayerData().job
        onDuty = true
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(200)
        while dropoffx or dropoffy or dropoffz ~= nil do
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local dis = #(pos - vector3(dropoffx, dropoffy, dropoffz))
                if dis <= 8 then
                    if dis <= 8 and IsPedInAnyVehicle(ped) and start == false then
                        DrawText3Ds(dropoffx, dropoffy, dropoffz, Config.Locale["chop"])
                        if IsControlJustPressed(0, 38) then
							ScrapVehicle()
						end
                    end
                end
            Citizen.Wait(5)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(200)
        if scrapblip then
            Citizen.Wait(1000)
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local dist = #(pos - vector3(Config.VehicleCoords[randomCoords]['coords'].x, Config.VehicleCoords[randomCoords]['coords'].y, Config.VehicleCoords[randomCoords]['coords'].z))
            Citizen.Wait(5)
            if dist <= 3 then
				-- if not copsCalled then
                --     local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
                --     local street1 = GetStreetNameFromHashKey(s1)
                --     local street2 = GetStreetNameFromHashKey(s2)
                --     local streetLabel = street1
                --     if street2 ~= nil then 
                --         streetLabel = streetLabel .. " " .. street2
                --     end
                --     TriggerServerEvent("aj-chopshop:server:callCops", "Chopshop", 0, streetLabel, pos)
                --     copsCalled = true
                -- end
                Citizen.Wait(5000)
				AJFW.Functions.Notify(Config.Locale["FoundVeh"], 'success')
				Citizen.Wait(10000)
				AJFW.Functions.Notify(Config.Locale["ScrapBlip"], 'primary')
				CreateBlip2()
				SetNewWaypoint(dropoffx, dropoffy)
				scrapblip = false
            end
        end
    end
end)

RegisterNetEvent('aj-chopshop:jobaccept')
AddEventHandler('aj-chopshop:jobaccept', function()
    if cooldown == false then
        if LicensePlate ~= nil then
            AJFW.Functions.Notify(Config.Locale["JobActive"], 'error')
        else
            randomVeh = math.random(1, 47)
            randomCoords = math.random(1, 60)
            randomLoc = math.random(1,4)
            SpawnVehicle(Config.VehicleList[randomVeh].vehicle, Config.VehicleCoords[randomCoords]['coords'].x, Config.VehicleCoords[randomCoords]['coords'].y, Config.VehicleCoords[randomCoords]['coords'].z, Config.VehicleCoords[randomCoords]['coords'].w)
        end
    else
        AJFW.Functions.Notify(Config.Locale["CoolDown"], 'error')
    end
end)

function SpawnVehicle(vehicle, x ,y, z, w)
    local coords = vector4(x, y, z, w)
    AJFW.Functions.SpawnVehicle(vehicle, function(veh)
        SetEntityHeading(veh, coords.w)
        SetVehicleEngineOn(veh, false, false)
        SetVehicleOnGroundProperly(veh)
        SetVehicleDoorsLocked(veh, 2)
        SetVehicleNeedsToBeHotwired(veh, true)
		SetVehicleColours(veh, 0, 0)
        exports['aj-fuel']:SetFuel(veh, 100.0)
        for i = 0, 5 do
            SetVehicleDoorShut(veh, i, true)
        end
        LicensePlate = GetVehicleNumberPlateText(veh)
		dropoffx, dropoffy, dropoffz, dropoffm = Config.DeliveryCoords[randomLoc]['coords'].x, Config.DeliveryCoords[randomLoc]['coords'].y, Config.DeliveryCoords[randomLoc]['coords'].z, Config.DeliveryCoords[randomLoc]['coords'].w
    	AJFW.Functions.Notify(Config.Locale["Email"], 'success')
        Citizen.Wait(math.random(10000,25000))
        TriggerServerEvent('aj-phone:server:sendNewMail', {
            sender = "Chop Shop",
            subject = "Vehicle Located",
            message = "Hello,<br><br> The vehicle you need to collect is a<br><b>" .. vehicle .. " </b> <br><br>The license plate is - <br><b>" .. LicensePlate .."</b>.<br><br>The approximate position of the <b>vehicle</b> and the <b>scrapyard</b> you <b>need</b> to bring it to are marked on your GPS.",
        })
        CreateBlip(coords.x, coords.y)
		scrapblip = true
        cooldown = true
        Citizen.Wait(Config.CoolDown * 60000)
        cooldown = false
    end, coords, true)
end

function ScrapVehicle()
	local ped = PlayerPedId()
	vehicle = GetVehiclePedIsIn(ped, false)
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if GetVehicleNumberPlateText(veh) ~= LicensePlate then
        AJFW.Functions.Notify(Config.Locale["WrongVeh"], 'error')
	else 
		local netId = NetworkGetNetworkIdFromEntity(vehicle)
        AJFW.Functions.Notify(Config.Locale["Reminder"], 8000)
		StartChopping()
		DeleteBlip()
    end
end

-- Police alert function used to alert all active police on Duty
-- RegisterNetEvent('aj-chopshop:client:robberyCall')
-- AddEventHandler('aj-chopshop:client:robberyCall', function(type, key, streetLabel, coords)
--     if PlayerJob.name == "police" and onDuty then
--         local bank = "Vehicle Robbery"
--         if type == "Chopshop" then
--             PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
--             TriggerEvent('chatMessage', "ALARM", "warning", "Vehicle robbery")
--             TriggerEvent('aj-policealerts:client:AddPoliceAlert', {
--                 timeOut = 15000,
--                 alertTitle = "Possible Vehicle Robbery",
--                 coords = {
--                     x = coords.x,
--                     y = coords.y,
--                     z = coords.z,
--                 },
--                 details = {
--                     [1] = {
--                         icon = '<i class="fas fa-car"></i>',
--                         detail = bank,
--                     },
--                     [2] = {
--                         icon = '<i class="fas fa-globe-europe"></i>',
--                         detail = streetLabel,
--                     },
--                 },
--                 callSign = AJFW.Functions.GetPlayerData().metadata["callsign"],
--             })

--             local transG = 250
--             local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
--             SetBlipSprite(blip, 227)
--             SetBlipColour(blip, 4)
--             SetBlipDisplay(blip, 4)
--             SetBlipAlpha(blip, transG)
--             SetBlipScale(blip, 1.0)
--             SetBlipFlashes(blip, true)
--             SetBlipAsShortRange(blip, false)
--             BeginTextCommandSetBlipName('STRING')
--             AddTextComponentString("911: Vehicle Robbery")
--             EndTextCommandSetBlipName(blip)
            
--             while transG ~= 0 do
--                 Wait(180 * 4)
--                 transG = transG - 1
--                 SetBlipAlpha(blip, transG)
--                 if transG == 0 then
--                     SetBlipSprite(blip, 2)
--                     RemoveBlip(blip)
--                     return
--                 end
--             end
--         end
--     end
-- end)

Citizen.CreateThread(function()
	while true do
		sleep = 1000
		if start then
			sleep = 5
			FreezeEntityPosition(vehicle,true)
			  for k=1, #Config.CarTable, 1 do
				if Config.CarTable[k].chopped == "cando" and DoesEntityExist(vehicle) and not IsPedInAnyVehicle(PlayerPedId(-1))   then
					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Config.CarTable[k].coords.x, Config.CarTable[k].coords.y, Config.CarTable[k].coords.z, true ) < Config.CarTable[k].distance then
						DrawText3Ds(Config.CarTable[k].coords.x,Config.CarTable[k].coords.y,Config.CarTable[k].coords.z,Config.Locale["remove"]..Config.CarTable[k].name)
						if(IsControlJustPressed(1, 38))   then
							StartAnimation(k)
						end
						if removedpart == false then
							removedpart = true
						end
					end
				end
			end
			if Config.CarTable[7].chopped == true and Config.CarTable[8].chopped == true and Config.CarTable[9].chopped == true and Config.CarTable[10].chopped == true and secondwave == false then
				for i=1, 6, 1 do
					Config.CarTable[i].chopped = "cando"
				end
				secondwave = true
			end	
			if GetVehiclePedIsIn(GetPlayerPed(-1)) == vehicle and removedpart == true then
				local pos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "windscreen"))
				DrawText3Ds(pos.x,pos.y,pos.z,Config.Locale["destroy"])
					if(IsControlJustPressed(1, 38))   then
						AJFW.Functions.Progressbar("crushing", Config.Locale["crushing"], (6500), false, true, {
							disableMovement = true,
							disableCarMovement = true,
							disableMouse = false,
							disableCombat = true,
						}, {}, {}, {}, function()
						TaskLeaveVehicle(GetPlayerPed(-1), vehicle, 1)
						TriggerServerEvent("aj-chopshop:server:crush")
						Citizen.Wait(1500)
						NetworkFadeOutEntity(vehicle,false,false)
						Citizen.Wait(1000)
						DeleteEntity(vehicle)
						Reset()
                        LicensePlate, dropoffx, dropoffy, dropoffz, dropoffm, randomVeh, randomCoords = nil
					end)
				end
			end
			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId(-1)),dropoffx, dropoffy, dropoffz,true) > 50 and start == true  then
				VehicleToFar()
			end
		end
		Wait(sleep)
	end
end)

function StartAnimation(k)
	if Config.CarTable[k].anim == "wheel1" or Config.CarTable[k].anim == "wheel2" or Config.CarTable[k].anim == "wheel3" or Config.CarTable[k].anim == "wheel4" then
		TriggerEvent('aj-chopshop:wheelanimation')
		Citizen.Wait(7400)
		if Config.CarTable[k].anim == "wheel1" then
			SetVehicleWheelXOffset(vehicle, 0, -2000)
		elseif Config.CarTable[k].anim == "wheel2" then
			SetVehicleWheelXOffset(vehicle, 2, -2000)
		elseif Config.CarTable[k].anim == "wheel3" then
			SetVehicleWheelXOffset(vehicle, 1, -2000)
		elseif Config.CarTable[k].anim == "wheel4" then 
			SetVehicleWheelXOffset(vehicle, 3, -2000)
		end
		Config.CarTable[k].chopped = true
		TriggerServerEvent('aj-chopshop:server:rewardplayer', Config.CarTable[k].anim)	
	elseif Config.CarTable[k].anim == "door" then
		TaskOpenVehicleDoor(GetPlayerPed(-1),vehicle,3000,Config.CarTable[k].getin,10)
		Citizen.Wait(2500)  
		TriggerEvent('aj-chopshop:dooranimation')
		Citizen.Wait(9000)
		SetVehicleDoorBroken(vehicle,Config.CarTable[k].destroy,true)
		Config.CarTable[k].chopped = true
		TriggerServerEvent('aj-chopshop:server:rewardplayer', Config.CarTable[k].anim)
	elseif Config.CarTable[k].anim == "trunk" then
		SetVehicleDoorOpen(vehicle, Config.CarTable[k].destroy, false, true)
		Citizen.Wait(2500)  
		TriggerEvent('aj-chopshop:trunkanimation')
		Citizen.Wait(4000)
		Config.CarTable[k].chopped = true
		TriggerServerEvent('aj-chopshop:server:rewardplayer', Config.CarTable[k].anim)
		Citizen.Wait(9500)
		SetVehicleDoorBroken(vehicle,Config.CarTable[k].destroy,true)
	elseif Config.CarTable[k].anim == "hood" then
		SetVehicleDoorOpen(vehicle, Config.CarTable[k].destroy, false, true)
		Citizen.Wait(2500)  
		TriggerEvent('aj-chopshop:hoodanimation')
		Citizen.Wait(9000)
		SetVehicleDoorBroken(vehicle,Config.CarTable[k].destroy,true)
		Config.CarTable[k].chopped = true
		TriggerServerEvent('aj-chopshop:server:rewardplayer', Config.CarTable[k].anim)
	end
end

function VehicleToFar() 
	DeleteEntity(vehicle)
	Reset()
	AJFW.Functions.Notify(Config.Locale["FarAway"], 'error')
end

function CreateBlip(x, y)
    DeleteBlip()
    x = x + math.random(-75.0, 75.0)
    y = y + math.random(-75.0, 75.0)
    
    blip = AddBlipForRadius(x, y, 0.0, 100.0)
    SetBlipSprite(blip, 9)
    SetBlipColour(blip, 38)
    SetBlipAlpha(blip, 80)
end

function CreateBlip2()
	DeleteBlip()
	blip2 = AddBlipForCoord(dropoffx, dropoffy, dropoffz)
    SetBlipSprite(blip2, 380)
    SetBlipColour(blip2, 33)
    SetBlipAlpha(blip2, 200)
    SetBlipDisplay(blip2, 4)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Scrap Yard")
    EndTextCommandSetBlipName(blip2)
end

function DrawText3Ds(x, y, z, text)
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

function DeleteBlip()
    if DoesBlipExist(blip) then
        RemoveBlip(blip)
    end
    if DoesBlipExist(blip2) then
        RemoveBlip(blip2)
    end
end

function StartChopping()
	for i=1, #Config.CarTable, 1 
	   do
		   local pos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, Config.CarTable[i].vehBone))
		   Config.CarTable[i].coords=pos
	   end
	   start = true
	   for k=-1, 2, 1
		   do
			local pedseat = GetPedInVehicleSeat(vehicle,k)
			TaskLeaveVehicle(pedseat, vehicle, 1)
	end
end

function Reset()
	for i=1, #Config.CarTable, 1 
		do
		if i <=6 then
			Config.CarTable[i].chopped=false
		else
			Config.CarTable[i].chopped="cando"
		end
	end
	secondwave = false
	vehicle = nil
	start = false
	removedpart = false
end
