local AJFW = exports['ajfw']:GetCoreObject()
local chopping = false

RegisterNetEvent('aj-lumberjack:getLumberStage', function(stage, state, k)
    Config.TreeLocations[k][stage] = state
end)

local function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(3)
    end
end

local function axe()
    local ped = PlayerPedId()
    local pedWeapon = GetSelectedPedWeapon(ped)

    for k, v in pairs(Config.Axe) do
        if pedWeapon == k then
            return true
        end
    end
    AJFW.Functions.Notify(Config.Alerts["error_axe"], 'error')
end

local function ChopLumber(k)
    local animDict = "melee@hatchet@streamed_core"
    local animName = "plyr_rear_takedown_b"
    local trClassic = PlayerPedId()
    local choptime = LumberJob.ChoppingTreeTimer
    chopping = true
    AJFW.Functions.Progressbar("Chopping_Tree", Config.Alerts["chopping_tree"], choptime, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        TriggerServerEvent('aj-lumberjack:setLumberStage', "isChopped", true, k)
        TriggerServerEvent('aj-lumberjack:setLumberStage', "isOccupied", false, k)
        TriggerServerEvent('aj-lumberjack:recivelumber')
        TriggerServerEvent('aj-lumberjack:setChoppedTimer')
        chopping = false
        TaskPlayAnim(trClassic, animDict, "exit", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
    end, function()
        ClearPedTasks(trClassic)
        TriggerServerEvent('aj-lumberjack:setLumberStage', "isOccupied", false, k)
        chopping = false
        TaskPlayAnim(trClassic, animDict, "exit", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
    end)
    TriggerServerEvent('aj-lumberjack:setLumberStage', "isOccupied", true, k)
    CreateThread(function()
        while chopping do
            loadAnimDict(animDict)
            TaskPlayAnim(trClassic, animDict, animName, 3.0, 3.0, -1, 2, 0, 0, 0, 0 )
            Wait(3000)
        end
    end)
end

RegisterNetEvent('aj-lumberjack:StartChopping', function()
    for k, v in pairs(Config.TreeLocations) do
        if not Config.TreeLocations[k]["isChopped"] then
            if axe() then
                ChopLumber(k)
            end
        end
    end
end)

if Config.Job then
    CreateThread(function()
        for k, v in pairs(Config.TreeLocations) do
            exports["aj-eye"]:AddBoxZone("trees" .. k, v.coords, 1.5, 1.5, {
                name = "trees" .. k,
                heading = 40,
                minZ = v.coords["z"] - 2,
                maxZ = v.coords["z"] + 2,
                debugPoly = false
            }, {
                options = {
                    {
                        action = function()
                            if axe() then
                                ChopLumber(k)
                            end
                        end,
                        type = "client",
                        event = "aj-lumberjack:StartChopping",
                        icon = "fa fa-hand",
                        label = Config.Alerts["Tree_label"],
                        job = "lumberjack",
                        canInteract = function()
                            if v["isChopped"] or v["isOccupied"] then
                                return false
                            end
                            return true
                        end,
                    }
                },
                distance = 1.0
            })

        end
    end)
    exports['aj-eye']:AddBoxZone("lumberjackdepo", LumberDepo.targetZone, 1, 1, {
        name = "Lumberjackdepo",
        heading = LumberDepo.targetHeading,
        debugPoly = false,
        minZ = LumberDepo.minZ,
        maxZ = LumberDepo.maxZ,
    }, {
        options = {
        {
          type = "client",
          event = "aj-lumberjack:bossmenu",
          icon = "Fas Fa-hands",
          label = Config.Alerts["depo_label"],
          job = "lumberjack",
        },
        },
        distance = 1.0
    })
    exports['aj-eye']:AddBoxZone("LumberProcessor", LumberProcessor.targetZone, 1, 1, {
        name = "LumberProcessor",
        heading = LumberProcessor.targetHeading,
        debugPoly = false,
        minZ = LumberProcessor.minZ,
        maxZ = LumberProcessor.maxZ,
    }, {
        options = {
        {
          type = "client",
          event = "aj-lumberjack:processormenu",
          icon = "Fas Fa-hands",
          label = Config.Alerts["mill_label"],
          job = "lumberjack",
        },
        },
        distance = 1.0
    })
    exports['aj-eye']:AddBoxZone("LumberSeller", LumberSeller.targetZone, 1, 1, {
        name = "LumberProcessor",
        heading = LumberSeller.targetHeading,
        debugPoly = false,
        minZ = LumberSeller.minZ,
        maxZ = LumberSeller.maxZ,
    }, {
        options = {
        {
          type = "server",
          event = "aj-lumberjack:sellItems",
          icon = "fa fa-usd",
          label = Config.Alerts["Lumber_Seller"],
          job = "lumberjack",
        },
        },
        distance = 1.0
    })
else
    CreateThread(function()
        for k, v in pairs(Config.TreeLocations) do
            exports["aj-eye"]:AddBoxZone("trees" .. k, v.coords, 1.5, 1.5, {
                name = "trees" .. k,
                heading = 40,
                minZ = v.coords["z"] - 2,
                maxZ = v.coords["z"] + 2,
                debugPoly = false
            }, {
                options = {
                    {
                        action = function()
                            if axe() then
                                ChopLumber(k)
                            end
                        end,
                        type = "client",
                        event = "aj-lumberjack:StartChopping",
                        icon = "fa fa-hand",
                        label = Config.Alerts["Tree_label"],
                        canInteract = function()
                            if v["isChopped"] or v["isOccupied"] then
                                return false
                            end
                            return true
                        end,
                    }
                },
                distance = 1.0
            })

        end
    end)
    exports['aj-eye']:AddBoxZone("lumberjackdepo", LumberDepo.targetZone, 1, 1, {
        name = "Lumberjackdepo",
        heading = LumberDepo.targetHeading,
        debugPoly = false,
        minZ = LumberDepo.minZ,
        maxZ = LumberDepo.maxZ,
    }, {
        options = {
        {
          type = "client",
          event = "aj-lumberjack:bossmenu",
          icon = "Fas Fa-hands",
          label = Config.Alerts["depo_label"],
        },
        },
        distance = 1.0
    })
    exports['aj-eye']:AddBoxZone("LumberProcessor", LumberProcessor.targetZone, 1, 1, {
        name = "LumberProcessor",
        heading = LumberProcessor.targetHeading,
        debugPoly = false,
        minZ = LumberProcessor.minZ,
        maxZ = LumberProcessor.maxZ,
    }, {
        options = {
        {
          type = "client",
          event = "aj-lumberjack:processormenu",
          icon = "Fas Fa-hands",
          label = Config.Alerts["mill_label"],
        },
        },
        distance = 1.0
    })
    exports['aj-eye']:AddBoxZone("LumberSeller", LumberSeller.targetZone, 1, 1, {
        name = "LumberProcessor",
        heading = LumberSeller.targetHeading,
        debugPoly = false,
        minZ = LumberSeller.minZ,
        maxZ = LumberSeller.maxZ,
    }, {
        options = {
        {
          type = "server",
          event = "aj-lumberjack:sellItems",
          icon = "fa fa-usd",
          label = Config.Alerts["Lumber_Seller"],
        },
        },
        distance = 1.0
    })
end

RegisterNetEvent('aj-lumberjack:vehicle', function()
    local vehicle = LumberDepo.Vehicle
    local coords = LumberDepo.VehicleCoords
    local TR = PlayerPedId()
    RequestModel(vehicle)
    while not HasModelLoaded(vehicle) do
        Wait(0)
    end
    if not IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
        local JobVehicle = CreateVehicle(vehicle, coords, 45.0, true, false)
        SetVehicleHasBeenOwnedByPlayer(JobVehicle,  true)
        SetEntityAsMissionEntity(JobVehicle,  true,  true)
        exports['aj-fuel']:SetFuel(JobVehicle, 100.0)
        local id = NetworkGetNetworkIdFromEntity(JobVehicle)
        DoScreenFadeOut(1500)
        Wait(1500)
        SetNetworkIdCanMigrate(id, true)
        TaskWarpPedIntoVehicle(TR, JobVehicle, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", AJFW.Functions.GetPlate(JobVehicle))
        DoScreenFadeIn(1500)
        Wait(2000)
        TriggerServerEvent('aj-phone:server:sendNewMail', {
            sender = Config.Alerts["phone_sender"],
            subject = Config.Alerts["phone_subject"],
            message = Config.Alerts["phone_message"],
            })
    else
        AJFW.Functions.Notify(Config.Alerts["depo_blocked"], "error")
    end
end)

RegisterNetEvent('aj-lumberjack:location', function()
    TriggerServerEvent('aj-phone:server:sendNewMail', {
        sender = Config.Alerts["phone_sender"],
        subject = Config.Alerts["phone_subject"],
        message = Config.Alerts["phone_message"],
        })
end)

RegisterNetEvent('aj-lumberjack:removevehicle', function()
    local TR92 = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(TR92,true)
    DeleteVehicle(vehicle)
    AJFW.Functions.Notify(Config.Alerts["depo_stored"])
end)

RegisterNetEvent('aj-lumberjack:getaxe', function()
    TriggerServerEvent('aj-lumberjack:BuyAxe')
end)

RegisterNetEvent('aj-lumberjack:bossmenu', function()
    local vehicle = {
      {
        header = Config.Alerts["vehicle_header"],
        isMenuHeader = true,
      },
      {
          header = Config.Alerts["vehicle_get"],
          txt = Config.Alerts["vehicle_text"],
          params = {
              event = 'aj-lumberjack:location',
            }
      },
    --   {
    --       header = Config.Alerts["vehicle_remove"],
    --       txt = Config.Alerts["remove_text"],
    --       params = {
    --           event = 'aj-lumberjack:removevehicle',
    --         }
    --   },
      {
          header = Config.Alerts["battleaxe_label"],
          txt = Config.Alerts["battleaxe_text"],
          params = {
              event = 'aj-lumberjack:getaxe',
            }
      },
      {
        header = Config.Alerts["goback"],
      },
    }
exports['aj-menu']:openMenu(vehicle)
end)

RegisterNetEvent('aj-lumberjack:processormenu', function()
    local processor = {
      {
        header = Config.Alerts["lumber_mill"],
        isMenuHeader = true,
      },
      {
          header = Config.Alerts["lumber_header"],
          txt = Config.Alerts["lumber_text"],
          params = {
              event = 'aj-lumberjack:processor',
            }
      },
      {
        header = Config.Alerts["goback"],
      },
    }
exports['aj-menu']:openMenu(processor)
end)

RegisterNetEvent('aj-lumberjack:processor', function()
    AJFW.Functions.TriggerCallback('aj-lumberjack:lumber', function(lumber)
      if lumber then
        TriggerEvent('animations:client:EmoteCommandStart', {"Clipboard"})
        AJFW.Functions.Progressbar('lumber_trader', Config.Alerts['lumber_progressbar'], LumberJob.ProcessingTime , false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
        }, {}, {}, {}, function()    
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            TriggerServerEvent("aj-lumberjack:lumberprocessed")
        end, function() 
          AJFW.Functions.Notify(Config.Alerts['cancel'], "error")
        end)
      elseif not lumber then
        AJFW.Functions.Notify(Config.Alerts['error_lumber'], "error", 3000)
      end
    end)
  end)