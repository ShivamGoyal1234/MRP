MRFW = exports['mrfw']:GetCoreObject()
local isSentenced = false
local communityServiceFinished = false
local actionsRemaining = 0
local availableActions = {}
local disable_actions = false

-- Events

RegisterNetEvent('MRFW:Client:OnPlayerLoaded')
AddEventHandler('MRFW:Client:OnPlayerLoaded', function()
	TriggerServerEvent('mr-communityservice:server:checkIfSentenced')
end)

RegisterNetEvent('mr-communityservice:client:finishCommunityService')
AddEventHandler('mr-communityservice:client:finishCommunityService', function(source)
	communityServiceFinished = true
	isSentenced = false
	actionsRemaining = 0
end)

RegisterNetEvent('mr-communityservice:client:inCommunityService')
AddEventHandler('mr-communityservice:client:inCommunityService', function(actions_remaining)
    if isSentenced then return end
    actionsRemaining = actions_remaining
    FillActionTable()
    ChangeOutfit()
    TriggerServerEvent('prison:server:SaveJailItems')
    SetEntityCoords(PlayerPedId(), Config.ServiceLocation.x, Config.ServiceLocation.y, Config.ServiceLocation.z)
    isSentenced = true
    communityServiceFinished = false
    while actionsRemaining > 0 and communityServiceFinished ~= true do
        local playerPed = PlayerPedId()
        local pCoords = GetEntityCoords(playerPed)
        if IsPedInAnyVehicle(playerPed, false) then
            ClearPedTasksImmediately(playerPed)
        end
        Wait(20000)
        if #(pCoords - Config.ServiceLocation) > 45 then
            SetEntityCoords(playerPed, Config.ServiceLocation.x, Config.ServiceLocation.y, Config.ServiceLocation.z)
            TriggerServerEvent('mr-communityservice:server:extendService')
            actionsRemaining = actionsRemaining + Config.ServiceExtensionOnEscape
            MRFW.Functions.Notify('Escape Attempted! '..Config.ServiceExtensionOnEscape..' More Months Added!')
        end
    end
    TriggerServerEvent('prison:server:GiveJailItems')
    SetEntityCoords(playerPed, Config.ReleaseLocation.x, Config.ReleaseLocation.y, Config.ReleaseLocation.z)
    TriggerServerEvent('mr-communityservice:server:finishCommunityService')
    isSentenced = false
    TriggerServerEvent('mr-clothes:loadPlayerSkin')
end)

-- Main Thread

local vassoumodel = "prop_tool_broom"
local vassour_net = nil

Citizen.CreateThread(function()
    while true do
        ::start_over::
        Wait(1)
        if actionsRemaining > 0 and isSentenced then
            Draw2DText('Actions Remaining: '..actionsRemaining, {0.175, 0.955})
            DrawAvailableActions()
            local ped = PlayerPedId()
            local pCoords = GetEntityCoords(ped)
            for i = 1, #availableActions do
                local distance = #(pCoords - availableActions[i].coords)
                if distance < 1.5 then
                    DisplayHelpText("Press ~INPUT_CONTEXT~ to start cleaning.")
                    if (IsControlJustReleased(1, 38)) then
                        tmp_action = availableActions[i]
                        RemoveAction(tmp_action)
                        FillActionTable(tmp_action)
                        disable_actions = true
                        TriggerServerEvent('mr-communityservice:server:completeService')
                        actionsRemaining = actionsRemaining - 1
                        if (tmp_action.type == "cleaning") then
                            TriggerEvent('dpemote:custom:animation', {"broom"})
                            -- TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_GARDENER_PLANT', 0, false)
                        else
                            TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_GARDENER_PLANT', 0, false)
                        end
                        MRFW.Functions.Progressbar('Com_Serv', 'Doing Community Service', 20000, false, false, { -- Name | Label | Time | useWhileDead | canCancel
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        }, {}, {}, {}, function() -- Play When Done
                            
                        end)
                        Wait(20000)
                        TriggerEvent('dpemote:custom:animation', {"c"})
                        ClearPedTasks(ped)
                        goto start_over
                    end
                end
            end
        else
            Wait(1000)
        end
    end
end)

-- Functions

function FillActionTable(last_action)
    while #availableActions < 5 do
		local service_does_not_exist = true
		local random_selection = Config.ServiceLocations[math.random(1,#Config.ServiceLocations)]
		for i = 1, #availableActions do
			if random_selection.coords.x == availableActions[i].coords.x and random_selection.coords.y == availableActions[i].coords.y and random_selection.coords.z == availableActions[i].coords.z then
				service_does_not_exist = false
			end
		end
		if last_action ~= nil and random_selection.coords.x == last_action.coords.x and random_selection.coords.y == last_action.coords.y and random_selection.coords.z == last_action.coords.z then
			service_does_not_exist = false
		end
		if service_does_not_exist then
			table.insert(availableActions, random_selection)
		end
	end
end

function RemoveAction(action)
    local action_pos = -1
    for i=1, #availableActions do
		if action.coords.x == availableActions[i].coords.x and action.coords.y == availableActions[i].coords.y and action.coords.z == availableActions[i].coords.z then
			action_pos = i
		end
	end
    if action_pos ~= -1 then
		table.remove(availableActions, action_pos)
	else 
		print("User tried to remove an unavailable action")
	end
end

function ChangeOutfit()
    local ped = PlayerPedId()
    local gender = MRFW.Functions.GetPlayerData().charinfo.gender
    if gender == 0 then
        TriggerEvent('mr-clothing:client:loadOutfit', Config.Uniforms.male)
    else
        TriggerEvent('mr-clothing:client:loadOutfit', Config.Uniforms.female)
    end
end

function DrawAvailableActions()
	for i = 1, #availableActions do
		DrawMarker(21, availableActions[i].coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 50, 50, 204, 100, false, true, 2, true, false, false, false)
	end
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function Draw2DText(text, pos)
	SetTextFont(1)
	SetTextProportional(1)
	SetTextScale(0.45, 0.45)
	SetTextColour(255, 255, 255, 255)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(table.unpack(pos))
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end