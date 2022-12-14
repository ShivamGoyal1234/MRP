local MRFW = exports['mrfw']:GetCoreObject()

local debugProps, sitting, lastPos, currentSitCoords, currentScenario, occupied = {}
local disableControls = false
local currentObj = nil

exports('sitting', function()
    return sitting
end)

local function displayNUIText()
    SendNUIMessage({type = "display", text = Config.GetUpText, color = 'rgb(100 100 100)'})
    Wait(0)
end

local function hideNUI()
    SendNUIMessage({type = "hide"})
    Wait(0)
end

Citizen.CreateThread(function()
	while true do
		sleep = 1000
		local playerPed = PlayerPedId()
		if sitting then
			sleep = 5
		end

		if sitting then
			displayNUIText() 
		else
			hideNUI() 
		end

		if sitting and not IsPedUsingScenario(playerPed, currentScenario) then
			wakeup()
		end

		if IsControlPressed(0, 23) and IsInputDisabled(0) and IsPedOnFoot(playerPed) then
			if sitting then
				wakeup()
			end			
		end
		Wait(sleep)
	end
end)

Citizen.CreateThread(function()
	local Sitables = {}

	for k,v in pairs(Config.Interactables) do
		local model = GetHashKey(v)
		table.insert(Sitables, model)
	end
	Citizen.Wait(100)
	exports['mr-eye']:AddTargetModel(Sitables, {
        options = {
            {
                event = "qb-Sit:Sit",
                icon = "fas fa-chair",
                label = "Use",
				entity = entity
            },
        },
        job = {"all"},
        distance = Config.MaxDistance
    })
end)

RegisterNetEvent("qb-Sit:Sit", function(data)
	local playerPed = PlayerPedId()

	if sitting and not IsPedUsingScenario(playerPed, currentScenario) then
		wakeup()
	end

	if disableControls then
		DisableControlAction(1, 37, true)
	end

	local object, distance = data.entity, #(GetEntityCoords(playerPed) - GetEntityCoords(data.entity))

	if distance and distance < 1.4 then
		local hash = GetEntityModel(object)

		for k,v in pairs(Config.Sitable) do
			if GetHashKey(k) == hash then
				sit(object, k, v)
				break
			end
		end
	end
end)


function wakeup()
	local playerPed = PlayerPedId()
	local pos = GetEntityCoords(PlayerPedId())

	TaskStartScenarioAtPosition(playerPed, currentScenario, 0.0, 0.0, 0.0, 180.0, 2, true, false)
	while IsPedUsingScenario(PlayerPedId(), currentScenario) do
		Citizen.Wait(100)
	end
	ClearPedTasks(playerPed)

	FreezeEntityPosition(playerPed, false)
	-- FreezeEntityPosition(currentObj, false)
	TriggerServerEvent('qb-sit:leavePlace', currentSitCoords)
	currentSitCoords, currentScenario = nil, nil
	sitting = false
	disableControls = false
end

function sit(object, modelName, data)
	if not HasEntityClearLosToEntity(PlayerPedId(), object, 17) then
		return
	end
	disableControls = true
	currentObj = object
	FreezeEntityPosition(object, true)

	PlaceObjectOnGroundProperly(object)
	local pos = GetEntityCoords(object)
	local playerPos = GetEntityCoords(PlayerPedId())
	local objectCoords = pos.x .. pos.y .. pos.z

	MRFW.Functions.TriggerCallback('qb-sit:getPlace', function(occupied)
		if occupied then
			MRFW.Functions.Notify('Chair is being used.', 'error')
		else
			local playerPed = PlayerPedId()
			lastPos, currentSitCoords = GetEntityCoords(playerPed), objectCoords

			TriggerServerEvent('qb-sit:takePlace', objectCoords)
			
			currentScenario = data.scenario
			TaskStartScenarioAtPosition(playerPed, currentScenario, pos.x, pos.y, pos.z + (playerPos.z - pos.z)/2, GetEntityHeading(object) + 180.0, 0, true, false)

			Citizen.Wait(2500)
			if GetEntitySpeed(PlayerPedId()) > 0 then
				ClearPedTasks(PlayerPedId())
				TaskStartScenarioAtPosition(playerPed, currentScenario, pos.x, pos.y, pos.z + (playerPos.z - pos.z)/2, GetEntityHeading(object) + 180.0, 0, true, true)
			end

			sitting = true
		end
	end, objectCoords)
end
