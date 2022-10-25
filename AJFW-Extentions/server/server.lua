AJFW = exports['ajfw']:GetCoreObject()
local illegel_teleports = {
    [1] = { -- Coke
        [1] = {
            coords = vector4(2461.21, 1574.9, 33.11, 94.52),
            ["AllowVehicle"] = false, 
            drawText = '[E]',
            show = false,
            anim = false
        },
        [2] = {
            coords = vector4(-408.93, 6372.75, -39.56, 205.37),
            ["AllowVehicle"] = false,
            drawText = '[E]',
            show = true,
            anim = true
        },
    },
    [2] = { -- Weed Process
        [1] = {
            coords = vector4(1066.4, -3183.42, -39.16, 97.77),
            ["AllowVehicle"] = false, 
            drawText = '[E]',
            show = true,
            anim = true
        },
        [2] = {
            coords = vector4(1122.74, -1304.67, 34.72, 178.67),
            ["AllowVehicle"] = false,
            drawText = '[E]',
            show = false,
            anim = false
        },
    },
    [3] = { -- Weapon Repair
        [1] = {
            coords = vector4(904.7, -1686.49, 47.35, 3.31),
            ["AllowVehicle"] = false, 
            drawText = '[E]',
            show = false,
            anim = true
        },
        [2] = {
            coords = vector4(207.21, -1018.33, -99.0, 269.99),
            ["AllowVehicle"] = false,
            drawText = '[E]',
            show = true,
            anim = true
        },
    },
    [4] = { -- Attachment Crafting
        [1] = {
            coords = vector4(3525.28, 3682.16, 20.99, 269.62),
            ["AllowVehicle"] = false, 
            drawText = '[E] To enter',
            show = false,
            anim = true
        },
        [2] = {
            coords = vector4(-182.24, 6539.38, 2.99, 330.87),
            ["AllowVehicle"] = false,
            drawText = '[E]',
            show = true,
            anim = true
        },
    },
    
    [5] = { -- tunner shop
        [1] = {
            coords = vector4(-1357.33, 164.81, -99.44, 179.63),
            ["AllowVehicle"] = true, 
            drawText = '[E] To Exit',
            show = true,
            anim = true
        },
        [2] = {
            coords = vector4(-402.31, -72.0, 43.27, 252.73),
            ["AllowVehicle"] = true,
            drawText = '[E] To Enter',
            show = true,
            anim = true
        },
    },
    [6] = { -- lom bank
        [1] = {
            coords = vector4(-1581.17, -558.37, 34.95, 59.77),
            ["AllowVehicle"] = false, 
            drawText = '[E] To enter',
            show = true,
            anim = true
        },
        [2] = {
            coords = vector4(-1583.73, -559.56, 108.52, 311.67),
            ["AllowVehicle"] = false,
            drawText = '[E] To Outside',
            show = true,
            anim = true
        },
    },
}

-- vector3(-3549.69, 651.05, -54.07) --- underwater mine

local crafting = vector3(200.69, -2411.23, 6.04)

AJFW.Functions.CreateUseableItem('labkey2' , function(source, item)
    local src = source
    local Player  = AJFW.Functions.GetPlayer(src)
    local ped = GetPlayerPed(src)
    local pCoords  = GetEntityCoords(ped)
    local tCoords  = vector3(2461.21, 1574.9, 33.11)
    local tp = vector4(-408.93, 6372.75, -39.56, 205.37)
    local dist = #(pCoords - tCoords)
    local HasDrive = Player.Functions.GetItemByName("secretdrive2")
    if dist <= 1 then
        -- if HasDrive then
            TriggerClientEvent('Custom:Teleport:me', src, tp)
        -- else
        --     TriggerClientEvent('AJFW:Notify', src, 'You are missing something', 'error')
        -- end
    end
end)

AJFW.Functions.CreateUseableItem('labkey3' , function(source, item)
    local src = source
    local Player  = AJFW.Functions.GetPlayer(src)
    local ped = GetPlayerPed(src)
    local pCoords  = GetEntityCoords(ped)
    local tCoords  = vector3(1122.74, -1304.67, 34.72)
    local tp = vector4(1066.4, -3183.42, -39.16, 97.77)
    local dist = #(pCoords - tCoords)
    local HasDrive = Player.Functions.GetItemByName("secretdrive3")
    if dist <= 1 then
        -- if HasDrive then
            TriggerClientEvent('Custom:Teleport:me', src, tp)
        -- else
        --     TriggerClientEvent('AJFW:Notify', src, 'You are missing something', 'error')
        -- end
    end
end)

AJFW.Functions.CreateUseableItem('labkey5' , function(source, item)
    local src = source
    local Player  = AJFW.Functions.GetPlayer(src)
    local ped = GetPlayerPed(src)
    local pCoords  = GetEntityCoords(ped)
    local tCoords  = vector3(904.7, -1686.49, 47.35)
    local tp = vector4(207.21, -1018.33, -99.0, 269.99)
    local dist = #(pCoords - tCoords)
    local HasDrive = Player.Functions.GetItemByName("secretdrive4")
    if dist <= 1 then
        -- if HasDrive then
            TriggerClientEvent('Custom:Teleport:me', src, tp)
        -- else
        --     TriggerClientEvent('AJFW:Notify', src, 'You are missing something', 'error')
        -- end
    end
end)

AJFW.Functions.CreateUseableItem('labkey6' , function(source, item)
    local src = source
    local Player  = AJFW.Functions.GetPlayer(src)
    local ped = GetPlayerPed(src)
    local pCoords  = GetEntityCoords(ped)
    local tCoords  = vector3(3525.28, 3682.16, 20.99)
    local tp = vector4(-182.24, 6539.38, 2.99, 330.87)
    local dist = #(pCoords - tCoords)
    local HasDrive = Player.Functions.GetItemByName("secretdrive5")
    if dist <= 1 then
        -- if HasDrive then
            TriggerClientEvent('Custom:Teleport:me', src, tp)
        -- else
        --     TriggerClientEvent('AJFW:Notify', src, 'You are missing something', 'error')
        -- end
    end
end)

AJFW.Functions.CreateUseableItem("lockpick", function(source, item)
    local Player = AJFW.Functions.GetPlayer(source)
    if item.info.uses > 0 then
        TriggerClientEvent("lockpicks:UseLockpick", source, false, item)
    else
        TriggerClientEvent("AJFW:Notify", source, "Broken Lockpick", "error", 3000)
    end
end)

AJFW.Functions.CreateUseableItem("advancedlockpick", function(source, item)
    local Player = AJFW.Functions.GetPlayer(source)
    if item.info.uses > 0 then
        TriggerClientEvent("lockpicks:UseLockpick", source, true, item)
    else
        TriggerClientEvent("AJFW:Notify", source, "Broken Lockpick", "error", 3000)
    end
end)

AJFW.Functions.CreateCallback('jacob:get:it', function(source, cb)
    -- print(illegel_teleports)
    cb(illegel_teleports)
end)

AJFW.Functions.CreateCallback('jacob:get:c', function(source, cb)
    -- print(illegel_teleports)
    cb(crafting)
end)

------------------------lua injector fix-----------------------
local validResourceList = {}
local function collectValidResourceList()
    validResourceList = {}
    for i=0,GetNumResources()-1 do
        validResourceList[GetResourceByFindIndex(i)] = true
    end
end
collectValidResourceList()

-- This makes sure that the resource list is always accurate
AddEventHandler("onResourceListRefresh", collectValidResourceList)

RegisterNetEvent("ac:server:checkMyResources", function(givenList)
    for _, resource in ipairs(givenList) do
        if not validResourceList[resource] then
            -- bad client!
            local src = source
            TriggerEvent("aj-log:server:CreateLog", "anticheat", "Player kicked!", "red", "** @everyone " ..GetPlayerName(src).. "** has more resources than server.")
            DropPlayer(src, "You Have Been Kicked For Cheating. Contact Staff (or dont): https://discord.gg/j3NvcCQB3p")
            break
        end
    end
end)

AJFW.Commands.Add('allowheat', 'Grant PD Officer Heat Level', {{name='id',help='ID of player'},{name='Allow',help='true or false'}}, false, function(source, args)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    if Player then
        if Player.PlayerData.job.name =='police' and Player.PlayerData.job.grade.level >=11 then
            local target = tonumber(args[1])
            local tPlayer = AJFW.Functions.GetPlayer(target)
            if tPlayer then
                if args[2] == 'true' then
                    tPlayer.Functions.SetMetaData('pursuit', true)
                elseif args[2] == 'false' then
                    tPlayer.Functions.SetMetaData('pursuit', false)
                else
                    TriggerClientEvent("AJFW:Notify", src, "only true or false", "error", 5000)
                end
            else
                TriggerClientEvent("AJFW:Notify", src, "Player is not online", "error", 5000)
            end
        else
            TriggerClientEvent("AJFW:Notify", src, "You Don't have enough perms", "error", 5000)
        end
    end
end, 'police')

AJFW.Commands.Add('allowairone', 'Grant PD Officer Airone', {{name='id',help='ID of player'},{name='Allow',help='true or false'}}, false, function(source, args)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    if Player then
        if Player.PlayerData.job.name =='police' and Player.PlayerData.job.grade.level >=11 then
            local target = tonumber(args[1])
            local tPlayer = AJFW.Functions.GetPlayer(target)
            if tPlayer then
                if args[2] == 'true' then
                    tPlayer.Functions.SetMetaData('airone', true)
                elseif args[2] == 'false' then
                    tPlayer.Functions.SetMetaData('airone', false)
                else
                    TriggerClientEvent("AJFW:Notify", src, "only true or false", "error", 5000)
                end
            else
                TriggerClientEvent("AJFW:Notify", src, "Player is not online", "error", 5000)
            end
        else
            TriggerClientEvent("AJFW:Notify", src, "You Don't have enough perms", "error", 5000)
        end
    end
end, 'police')