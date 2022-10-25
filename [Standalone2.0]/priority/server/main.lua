local MRFW = exports['mrfw']:GetCoreObject()
local cooldown = 0
local inprogress = false
local activeUser = nil
local resetpcd = false
local inprogressStatus = nil

AddEventHandler('playerDropped', function(reason)
    if tonumber(activeUser) == tonumber(source) then
        if inprogress and not resetpcd then
            activeUser = nil
            cooldown = Config.CooldownTime
            inprogress = false
            Citizen.CreateThread(function()
                if Config.DisplaySeconds then
                    cooldown = cooldown * 60
                end
                while cooldown > 0 and not resetpcd do
                    if Config.DisplaySeconds then
                        local seconds = cooldown
                        local mins = string.format("%02.f", math.floor(seconds/60));
                        local secs = string.format("%02.f", math.floor(seconds - mins *60));
                        local timer = mins..":"..secs
                        TriggerClientEvent("Priority:updateStatus", -1, "~b~Cooldown "..Config.Color.."(~w~"..timer..""..Config.Color..")")
                        cooldown = cooldown - 1
                        Citizen.Wait(1000)
                    else
                        TriggerClientEvent("Priority:updateStatus", -1, "~b~Cooldown "..Config.Color.."(~w~"..cooldown..""..Config.Color..")")
                        cooldown = cooldown - 1
                        Citizen.Wait(1000 * 60)
                    end
                end
                if cooldown == 0 then
                    TriggerClientEvent("Priority:updateStatus", -1, newStatus)
                end
            end)
            if Config.JD_logs then
                exports.ayushlogs:discord('`'..GetPlayerName(source)..' Disconnected: Priority Cooldown Started`', source, 0, Config.JD_logsColor, Config.JD_logChannel)
            end
        end
    end
end)
MRFW.Commands.Add('resetpcd', 'Crime Status InActive', {}, false, function(source, args)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player ~= nil then
        if Player.PlayerData.job.name == 'police' then
            if Player.PlayerData.job.onduty then
                if inprogress or cooldown ~= 0 then
                    resetpcd = true
                    inprogress = false
                    cooldown = 0
                    activeUser = nil
                    inprogressStatus = nil
                    newStatus = "~g~Inactive"
                    TriggerClientEvent("Priority:updateStatus", -1, newStatus)
                    TriggerClientEvent('chatMessage', -1, 'Alert:The Priority got reset by Police')
                    if Config.JD_logs then
                        exports.ayushlogs:discord('`'..GetPlayerName(source)..' reset the priority cooldown`', source, 0, Config.JD_logsColor, Config.JD_logsChannel)
                    end
                else
                    TriggerClientEvent('chatMessage', source, 'Alert:nNo priority active.')
                end
            else
                TriggerClientEvent("MRFW:Notify", src, "Not Authorized", "error", 4000)
            end
        else
            TriggerClientEvent("MRFW:Notify", src, "Not Authorized", "error", 4000)
        end
    end
end, 'police')
MRFW.Commands.Add('inprogress', 'Crime Status Active', {}, false, function(source, args)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player ~= nil then
        if Player.PlayerData.job.name == 'police' then
            if Player.PlayerData.job.onduty then
                if inprogress ~= nil and cooldown == 0 then
                    if not inprogress then
                        inprogress = true
                        activeUser = source
                        resetpcd = false
                        newStatus = "~r~Active ~m~"
                        inprogressStatus = newStatus
                        Citizen.CreateThread(function()
                            while inprogress do
                                TriggerClientEvent("Priority:updateStatus", -1, newStatus)
                                Citizen.Wait(1000)
                            end
                        end)
                        TriggerClientEvent('chatMessage', -1, 'Alert:The Priority got reset by Police')
                        if Config.JD_logs then
                            exports.ayushlogs:discord('`Priority started by '..GetPlayerName(source)..'`', source, 0, Config.JD_logsColor, Config.JD_logsChannel)
                        end
                    else
                        TriggerClientEvent('chatMessage', source, 'Alert:A Priority is already in progress!')
                    end
                end
            else
                TriggerClientEvent("MRFW:Notify", src, "Not Authorized", "error", 4000)
            end
        else
            TriggerClientEvent("MRFW:Notify", src, "Not Authorized", "error", 4000)
        end
    end
end, 'police')
MRFW.Commands.Add('cooldown', 'Crime Status Cooldown', {}, false, function(source, args)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player ~= nil then
        if Player.PlayerData.job.name == 'police' then
            if Player.PlayerData.job.onduty then
                if activeUser == source then
                    if (inprogress and not resetpcd) then
                        activeUser = nil
                        cooldown = Config.CooldownTime
                        if args[1] ~= nil then
                            cooldown = tonumber(args[1])
                        end
                        inprogress = false
                        newStatus = "~g~Inactive"
                        inprogressStatus = nil
                        Citizen.CreateThread(function()
                            if Config.DisplaySeconds then
                                cooldown = cooldown * 60
                            end
                            while cooldown > 0 and not resetpcd do
                                if Config.DisplaySeconds then
                                    local seconds = cooldown
                                    local mins = string.format("%02.f", math.floor(seconds/60));
                                    local secs = string.format("%02.f", math.floor(seconds - mins *60));
                                    local timer = mins..":"..secs
                                    TriggerClientEvent("Priority:updateStatus", -1, "~b~Cooldown "..Config.Color.."(~w~"..timer..""..Config.Color..")")
                                    cooldown = cooldown - 1
                                    Citizen.Wait(1000)
                                else
                                    TriggerClientEvent("Priority:updateStatus", -1, "~b~Cooldown "..Config.Color.."(~w~"..cooldown..""..Config.Color..")")
                                    cooldown = cooldown - 1
                                    Citizen.Wait(1000 * 60)
                                end
                            end
                            if cooldown == 0 then
                                TriggerClientEvent("Priority:updateStatus", -1, newStatus)
                                resetpcd = true
                            end
                        end)
                        TriggerClientEvent('chatMessage', -1, 'Alert:The Priority got reset by Police')
                        if Config.JD_logs then
                            exports.ayushlogs:discord('`Priority cooldown started by '..GetPlayerName(source)..'`', source, 0, Config.JD_logsColor, Config.JD_logsChannel)
                        end
                    else
                        TriggerClientEvent('chatMessage', source, 'Alert:You can not trigger a cooldown.Only the person who activates the priority can start the cooldown.')
                    end
                else
                    TriggerClientEvent('chatMessage', source, 'Alert:You don\'t have a priority in progress.')
                end
            else
                TriggerClientEvent("MRFW:Notify", src, "Not Authorized", "error", 4000)
            end
        else
            TriggerClientEvent("MRFW:Notify", src, "Not Authorized", "error", 4000)
        end
    end
end, 'police')

AddEventHandler('PlayerConnected', function()
    Citizen.Wait(1000)
    if cooldown ~= 0 then
        while cooldown > 0 do
            local seconds = cooldown
            local mins = string.format("%02.f", math.floor(seconds/60));
            local secs = string.format("%02.f", math.floor(seconds - mins *60));
            local timer = mins..":"..secs
            TriggerClientEvent("Priority:updateStatus", -1, "~b~Cooldown "..Config.Color.."(~w~"..timer..""..Config.Color..")")
            cooldown = cooldown - 1
            Citizen.Wait(1000 * 60)
        end
    end
    if inprogressStatus ~= nil then
        TriggerClientEvent("Priority:updateStatus", source, inprogressStatus)
    end
    if inprogressStatus == nil and cooldown == 0 then
        newStatus = "~g~Inactive"
        TriggerClientEvent("Priority:updateStatus", source, newStatus)
    end
end)