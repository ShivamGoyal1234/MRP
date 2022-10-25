Laststand = Laststand or {}
Laststand.ReviveInterval = 360
Laststand.MinimumRevive = 300
InLaststand = false
LaststandTime = 0
lastStandDict = "missarmenian2"
lastStandAnim = "corpse_search_exit_ped"
isEscorted = false
local isEscorting = false
local CanBePickuped = false

-- Functions

local function GetClosestPlayer()
    local closestPlayers = MRFW.Functions.GetPlayersFromCoords()
    local closestDistance = -1
    local closestPlayer = -1
    local coords = GetEntityCoords(PlayerPedId())

    for i=1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = #(pos - coords)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = closestPlayers[i]
                closestDistance = distance
            end
        end
	end

	return closestPlayer, closestDistance
end

local function LoadAnimation(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(100)
    end
end

function SetLaststand(bool, spawn)
    local ped = PlayerPedId()
    if bool then
        Wait(1000)
        local pos = GetEntityCoords(ped)
        local heading = GetEntityHeading(ped)

        while GetEntitySpeed(ped) > 0.5 or IsPedRagdoll(ped) do
            Wait(10)
        end

        TriggerServerEvent("InteractSound_SV:PlayOnSource", "demo", 0.1)

        LaststandTime = Laststand.ReviveInterval

        -- NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z + 0.5, heading, true, false)
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped) then

            local veh = GetVehiclePedIsIn(ped)
            local vehseats = GetVehicleModelNumberOfSeats(GetHashKey(GetEntityModel(veh)))
            for i = -1, vehseats do
                local occupant = GetPedInVehicleSeat(veh, i)
                if occupant == ped then
                    NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z + 0.5, heading, true, false)
                    SetPedIntoVehicle(ped, veh, i)
                end
            end
        else
            NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z + 0.5, heading, true, false)
        end		

        SetEntityHealth(ped, 150)

        if IsPedInAnyVehicle(ped, false) then
            LoadAnimation("veh@low@front_ps@idle_duck")
            TaskPlayAnim(ped, "veh@low@front_ps@idle_duck", "sit", 1.0, 8.0, -1, 1, -1, false, false, false)
        else
            LoadAnimation(lastStandDict)
            TaskPlayAnim(ped, lastStandDict, lastStandAnim, 1.0, 8.0, -1, 1, -1, false, false, false)
        end

        InLaststand = true

        TriggerEvent("hospital:client:AiCall")
        
        CreateThread(function()
            while InLaststand do
                if LaststandTime - 1 > Laststand.MinimumRevive then
                    LaststandTime = LaststandTime - 1
                    Config.DeathTime = LaststandTime
                elseif LaststandTime - 1 <= Laststand.MinimumRevive and LaststandTime - 1 ~= 0 then
                    LaststandTime = LaststandTime - 1
                    CanBePickuped = true
                    Config.DeathTime = LaststandTime
                elseif LaststandTime - 1 <= 0 then
                    MRFW.Functions.Notify("You have bled out..", "error")
                    SetLaststand(false)
                    local killer_2, killerWeapon = NetworkGetEntityKillerOfPlayer(player)
                    local killer = GetPedSourceOfDeath(playerPed)

                    if killer_2 ~= 0 and killer_2 ~= -1 then
                        killer = killer_2
                    end

                    local killerId = NetworkGetPlayerIndexFromPed(killer)
                    local killerName = killerId ~= -1 and GetPlayerName(killerId) .. " " .. "("..GetPlayerServerId(killerId)..")" or "Himself or a NPC"
                    local weaponLabel = MRFW.Shared.Weapons?[killerWeapon]?["label"] or "Unknown"
                    local weaponName = MRFW.Shared.Weapons?[killerWeapon]?["name"] or "Unknown_Weapon"
                    TriggerServerEvent("mr-log:server:CreateLog", "death", GetPlayerName(player) .. " ("..GetPlayerServerId(player)..") is dead", "red", "**".. killerName .. "** has killed  ".. GetPlayerName(player) .." with a **".. weaponLabel .. "** (" .. weaponName .. ")")
                    deathTime = 0
                    OnDeath()
                    DeathTimer()
                end
                Wait(1000)
            end
        end)
    else
        TaskPlayAnim(ped, lastStandDict, "exit", 1.0, 8.0, -1, 1, -1, false, false, false)
        InLaststand = false
        CanBePickuped = false
        LaststandTime = 0
    end
    TriggerServerEvent("hospital:server:SetLaststandStatus", bool)
end

-- Events

RegisterNetEvent('hospital:client:SetEscortingState', function(bool)
    isEscorting = bool
end)

RegisterNetEvent('hospital:client:isEscorted', function(bool)
    isEscorted = bool
end)

RegisterNetEvent('hospital:client:UseFirstAid', function()
    if not isEscorting then
        local player, distance = GetClosestPlayer()
        if player ~= -1 and distance < 1.5 then
            local playerId = GetPlayerServerId(player)
            TriggerServerEvent('hospital:server:UseFirstAid', playerId)
        end
    else
        MRFW.Functions.Notify('Action impossible!', 'error')
    end
end)

RegisterNetEvent('hospital:client:CanHelp', function(helperId)
    if InLaststand then
        if LaststandTime <= 300 then
            TriggerServerEvent('hospital:server:CanHelp', helperId, true)
        else
            TriggerServerEvent('hospital:server:CanHelp', helperId, false)
        end
    else
        TriggerServerEvent('hospital:server:CanHelp', helperId, false)
    end
end)

RegisterNetEvent('hospital:client:HelpPerson', function(targetId)
    local ped = PlayerPedId()
    isHealingPerson = true
    MRFW.Functions.Progressbar("hospital_revive", "Reviving person..", math.random(30000, 60000), false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = healAnimDict,
        anim = healAnim,
        flags = 1,
    }, {}, {}, function() -- Done
        isHealingPerson = false
        ClearPedTasks(ped)
        MRFW.Functions.Notify("You revived a person.")
        TriggerServerEvent("hospital:server:RevivePlayer", targetId)
    end, function() -- Cancel
        isHealingPerson = false
        ClearPedTasks(ped)
        MRFW.Functions.Notify("Canceled!", "error")
    end)
end)