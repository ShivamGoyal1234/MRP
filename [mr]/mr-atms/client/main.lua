local MRFW = exports['mrfw']:GetCoreObject()

-- Functions

local function PlayATMAnimation(animation)
    local playerPed = PlayerPedId()
    if animation == 'enter' then
        RequestAnimDict('amb@prop_human_atm@male@enter')
        while not HasAnimDictLoaded('amb@prop_human_atm@male@enter') do
            Wait(0)
        end
        TaskPlayAnim(playerPed, 'amb@prop_human_atm@male@enter', "enter", 1.0,-1.0, 3000, 1, 1, true, true, true)
    end

    if animation == 'exit' then
        RequestAnimDict('amb@prop_human_atm@male@exit')
        while not HasAnimDictLoaded('amb@prop_human_atm@male@exit') do
            Wait(0)
        end
        TaskPlayAnim(playerPed, 'amb@prop_human_atm@male@exit', "exit", 1.0,-1.0, 3000, 1, 1, true, true, true)
    end
end

-- Events

RegisterNetEvent("hidemenu", function()
    SetNuiFocus(false, false)
    SendNUIMessage({
        status = "closeATM"
    })
end)

RegisterNetEvent('mr-atms:client:updateBankInformation', function(banking)
    SendNUIMessage({
        status = "loadBankAccount",
        information = banking
    })
end)

-- mr-target
if Config.UseTarget then
    CreateThread(function()
        exports['mr-eye']:AddTargetModel(Config.ATMModels, {
            options = {
                {
                    event = 'mr-atms:server:enteratm',
                    type = 'server',
                    icon = "fas fa-credit-card",
                    label = "Use ATM",
                },
            },
            distance = 2.0,
        })
    end)
end

RegisterNetEvent('mr-atms:client:loadATM', function(cards)
    if cards and cards[1] then
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed, true)
        for _, v in pairs(Config.ATMModels) do
            local hash = joaat(v)
            local atm = IsObjectNearPoint(hash, playerCoords.x, playerCoords.y, playerCoords.z, 2.0)
            if atm then
                PlayATMAnimation('enter')
                MRFW.Functions.Progressbar("accessing_atm", "Accessing ATM", 1500, false, true, {
                    disableMovement = false,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = false,
                }, {}, {}, {}, function() -- Done
                    SetNuiFocus(true, true)
                    SendNUIMessage({
                        status = "openATMFrontScreen",
                        cards = cards,
                    })
                end, function()
                    MRFW.Functions.Notify("Failed!", "error")
                end)
            end
        end
    else
        MRFW.Functions.Notify("Please visit a branch to order a card", "error")
    end
end)

-- Callbacks

RegisterNUICallback("NUIFocusOff", function()
    SetNuiFocus(false, false)
    SendNUIMessage({
        status = "closeATM"
    })
    PlayATMAnimation('exit')
end)

RegisterNUICallback("playATMAnim", function()
    local anim = 'amb@prop_human_atm@male@idle_a'
    RequestAnimDict(anim)
    while not HasAnimDictLoaded(anim) do
        Wait(0)
    end
    TaskPlayAnim(PlayerPedId(), anim, "idle_a", 1.0,-1.0, 3000, 1, 1, true, true, true)
end)

RegisterNUICallback("doATMWithdraw", function(data)
    if data then
        TriggerServerEvent('mr-atms:server:doAccountWithdraw', data)
    end
end)

RegisterNUICallback("loadBankingAccount", function(data)
    MRFW.Functions.TriggerCallback('mr-atms:server:loadBankAccount', function(banking)
        if banking and type(banking) == "table" then
            SendNUIMessage({
                status = "loadBankAccount",
                information = banking
            })
        else
            SetNuiFocus(false, false)
            SendNUIMessage({
                status = "closeATM"
            })
        end
    end, data.cid, data.cardnumber)
end)

RegisterNUICallback("removeCard", function(data)
    MRFW.Functions.TriggerCallback('mr-debitcard:server:deleteCard', function(hasDeleted)
        if hasDeleted then
            SetNuiFocus(false, false)
            SendNUIMessage({
                status = "closeATM"
            })
            MRFW.Functions.Notify('Card has been deleted.', 'success')
        else
            MRFW.Functions.Notify('Failed to delete card.', 'error')
        end
    end, data)
end)
