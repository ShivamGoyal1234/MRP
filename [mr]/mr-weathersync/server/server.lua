local CurrentWeather = Config.StartWeather
local baseTime = Config.BaseTime
local timeOffset = Config.TimeOffset
local freezeTime = Config.FreezeTime
local blackout = Config.Blackout
local newWeatherTimer = Config.NewWeatherTimer
local MRFW = exports['mrfw']:GetCoreObject()

local function isAllowedToChange(player)
    if MRFW.Functions.HasPermission(player, "owner") or MRFW.Functions.HasPermission(player, "dev") or IsPlayerAceAllowed(player, 'command') then
        return true
    else
        return false
    end
end

local function ShiftToMinute(minute)
    timeOffset = timeOffset - ( ( (baseTime+timeOffset) % 60 ) - minute )
end

local function ShiftToHour(hour)
    timeOffset = timeOffset - ( ( ((baseTime+timeOffset)/60) % 24 ) - hour ) * 60
end

local defineweathers = {
    ['CLEAR'] = "Climate has been Changed: Weather is clear now.",
    ['CLOUDS'] = "Climate has been Changed: Weather may get hot because of cloudy sky.",
    ['EXTRASUNNY'] = "Climate has been Changed: Weather is getting hot avoid going outside for no reason.",
    ['CLEARING'] = "Climate has been Changed: Outside wind is getting strong there are maybe chance of getting rain today.",
    ['OVERCAST'] = "Climate has been Changed: Weather is getting nice with clouds and there are chances of getting rain today.",
    ['FOGGY'] = "Climate has been Changed: Weather is getting bad drive safely.",
    ['RAIN'] = "Climate has been Changed: Outside Raining has been started, there are chances of getting thunderstorms, stay safe.",
    ['SMOG'] = "Climate has been Changed: Weather is getting bad outside because of air pollution outside, avoid using smoke producing machines.",
    ['THUNDER'] = "Attention citizens! Weather is getting bad avoid going outside for no reason, stay away from electricity poles."
}

local blt = false

local function NextWeatherStage()
    if CurrentWeather == "CLEAR" or CurrentWeather == "CLOUDS" or CurrentWeather == "EXTRASUNNY"  then
        local new = math.random(1,2)
        if new == 1 then
            CurrentWeather = "CLEARING"
        else
            CurrentWeather = "OVERCAST"
        end
    elseif CurrentWeather == "CLEARING" or CurrentWeather == "OVERCAST" then
        local new = math.random(1,6)
        if new == 1 then
            if CurrentWeather == "CLEARING" then CurrentWeather = "FOGGY" else CurrentWeather = "RAIN" end
        elseif new == 2 then
            CurrentWeather = "CLOUDS"
        elseif new == 3 then
            CurrentWeather = "CLEAR"
        elseif new == 4 then
            CurrentWeather = "EXTRASUNNY"
        elseif new == 5 then
            CurrentWeather = "SMOG"
        else
            CurrentWeather = "FOGGY"
        end
    elseif CurrentWeather == "RAIN" then
        local new = math.random(1,2)
        if new == 1 then
            CurrentWeather = "CLEARING"
        else
            CurrentWeather = "THUNDER"
            local blc = math.random(1,2)
            if blc == 1 then
                blt = true
                TriggerEvent('mr-weathersync:server:tsunami:blackout1')
            end
        end
    elseif CurrentWeather == "THUNDER" then
        CurrentWeather = "RAIN"
        if blt then
            blt = false
            TriggerEvent('mr-weathersync:server:tsunami:blackout2')
        end
    elseif CurrentWeather == "SMOG" or CurrentWeather == "FOGGY" then
        CurrentWeather = "CLEAR"
    end
    TriggerEvent("mr-weathersync:server:RequestStateSync")
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div class="restart"><i class="fa fa-bullhorn"></i> {0}<br>^0{1}</div>',
        args = { "Weather Announcement!", defineweathers[CurrentWeather]}
    })
end

RegisterNetEvent('mr-weathersync:server:RequestStateSync', function()
    TriggerClientEvent('mr-weathersync:client:SyncWeather', -1, CurrentWeather, blackout)
    TriggerClientEvent('mr-weathersync:client:SyncTime', -1, baseTime, timeOffset, freezeTime)
end)

RegisterNetEvent('mr-weathersync:server:RequestCommands', function()
    local src = source
    if isAllowedToChange(src) then
        TriggerClientEvent('mr-weathersync:client:RequestCommands', src, true)
    end
end)

RegisterNetEvent('mr-weathersync:server:setWeather', function(weather)
    local validWeatherType = false
    for i,wtype in ipairs(Config.AvailableWeatherTypes) do
        if wtype == string.upper(weather) then
            validWeatherType = true
        end
    end
    if validWeatherType then
        TriggerEvent("mr-log:server:CreateLog", 'weather', "Weather Changed", "red", GetPlayerName(source) .. " Changed Weather to " .. weather)
        print(_U('weather_updated'))
        CurrentWeather = string.upper(weather)
        newWeatherTimer = Config.NewWeatherTimer
        TriggerEvent('mr-weathersync:server:RequestStateSync')
    else
        print(_U('weather_invalid'))
    end
end)

RegisterNetEvent('mr-weathersync:server:setWeather2', function(weather)
    local validWeatherType = false
    for i,wtype in ipairs(Config.AvailableWeatherTypes) do
        if wtype == string.upper(weather) then
            validWeatherType = true
        end
    end
    if validWeatherType then
        print(_U('weather_updated'))
        CurrentWeather = string.upper(weather)
        newWeatherTimer = Config.NewWeatherTimer
        TriggerEvent('mr-weathersync:server:RequestStateSync')
    else
        print(_U('weather_invalid'))
    end
end)

RegisterNetEvent('mr-weathersync:server:setTime', function(hour, minute)
    if hour and minute then
        TriggerEvent("mr-log:server:CreateLog", 'weather', "Time Changed", "red", GetPlayerName(source) .. " Changed Time to " .. hour .. ":".. minute)
        local argh = tonumber(hour)
        local argm = tonumber(minute)
        if argh < 24 then
            ShiftToHour(argh)
        else
            ShiftToHour(0)
        end
        if argm < 60 then
            ShiftToMinute(argm)
        else
            ShiftToMinute(0)
        end
        print(_U('time_change', argh, argm))
        TriggerEvent('mr-weathersync:server:RequestStateSync')
    else
        print(_U('time_invalid'))
    end
end)

RegisterNetEvent('mr-weathersync:server:toggleBlackout', function()
    blackout = not blackout
    TriggerEvent('mr-weathersync:server:RequestStateSync')
end)

RegisterNetEvent('mr-weathersync:server:tsunami:blackout', function()
    blackout = true
    TriggerEvent('mr-weathersync:server:RequestStateSync')
end)

RegisterNetEvent('mr-weathersync:server:tsunami:blackout1', function()
    blackout = true
    TriggerEvent('mr-weathersync:server:RequestStateSync')
end)

RegisterNetEvent('mr-weathersync:server:tsunami:blackout2', function()
    blackout = false
    TriggerEvent('mr-weathersync:server:RequestStateSync')
end)
-- RegisterCommand('freezetime', function(source)
--     if source then
--         if isAllowedToChange(source) then
--             freezeTime = not freezeTime
--             if freezeTime then
--                 TriggerClientEvent('MRFW:Notify', source, _U('time_frozenc'))
--             else
--                 TriggerClientEvent('MRFW:Notify', source, _U('time_unfrozenc'))
--             end
--         else
--             TriggerClientEvent('MRFW:Notify', source, _U('not_allowed'), 'error')
--         end
--     else
--         freezeTime = not freezeTime
--         if freezeTime then
--             print(_U('time_now_frozen'))
--         else
--             print(_U('time_now_unfrozen'))
--         end
--     end
-- end)

-- RegisterCommand('freezeweather', function(source)
--     if source ~= 0 then
--         if isAllowedToChange(source) then
--             Config.DynamicWeather = not Config.DynamicWeather
--             if not Config.DynamicWeather then
--                 TriggerClientEvent('MRFW:Notify', source, _U('dynamic_weather_disabled'))
--             else
--                 TriggerClientEvent('MRFW:Notify', source, _U('dynamic_weather_enabled'))
--             end
--         else
--             TriggerClientEvent('MRFW:Notify', source, _U('not_allowed'), 'error')
--         end
--     else
--         Config.DynamicWeather = not Config.DynamicWeather
--         if not Config.DynamicWeather then
--             print(_U('weather_now_frozen'))
--         else
--             print(_U('weather_now_unfrozen'))
--         end
--     end
-- end)

-- RegisterCommand('weather', function(source, args)
--     if source == 0 then
--         local validWeatherType = false
--         if args[1] == nil then
--             print(_U('weather_invalid_syntax'))
--             return
--         else
--             for i,wtype in ipairs(Config.AvailableWeatherTypes) do
--                 if wtype == string.upper(args[1]) then
--                     validWeatherType = true
--                 end
--             end
--             if validWeatherType then
--                 print(_U('weather_updated'))
--                 CurrentWeather = string.upper(args[1])
--                 newWeatherTimer = Config.NewWeatherTimer
--                 TriggerEvent('mr-weathersync:server:RequestStateSync')
--             else
--                 print(_U('weather_invalid'))
--             end
--         end
--     else
--         if isAllowedToChange(source) then
--             local validWeatherType = false
--             if args[1] == nil then
--                 TriggerClientEvent('MRFW:Notify', source, _U('weather_invalid_syntaxc'), 'error')
--             else
--                 for i,wtype in ipairs(Config.AvailableWeatherTypes) do
--                     if wtype == string.upper(args[1]) then
--                         validWeatherType = true
--                     end
--                 end
--                 if validWeatherType then
--                     TriggerClientEvent('MRFW:Notify', source, _U('weather_willchangeto', string.lower(args[1])))
--                     CurrentWeather = string.upper(args[1])
--                     newWeatherTimer = Config.NewWeatherTimer
--                     TriggerEvent('mr-weathersync:server:RequestStateSync')
--                 else
--                     TriggerClientEvent('MRFW:Notify', source, _U('weather_invalidc'), 'error')
--                 end
--             end
--         else
--             TriggerClientEvent('MRFW:Notify', source, _U('not_access'), 'error')
--             print(_U('weather_accessdenied'))
--         end
--     end
-- end)

RegisterCommand('blackout', function(source)
    if source == 0 then
        blackout = not blackout
        if blackout then
            print(_U('blackout_enabled'))
        else
            print(_U('blackout_disabled'))
        end
    else
        if isAllowedToChange(source) then
            blackout = not blackout
            if blackout then
                TriggerClientEvent('MRFW:Notify', source, _U('blackout_enabledc'))
            else
                TriggerClientEvent('MRFW:Notify', source, _U('blackout_disabledc'))
            end
            TriggerEvent('mr-weathersync:server:RequestStateSync')
        end
    end
end)

-- RegisterCommand('morning', function(source)
--     if source == 0 then
--         print(_U('time_console'))
--         return
--     end
--     if isAllowedToChange(source) then
--         ShiftToMinute(0)
--         ShiftToHour(9)
--         TriggerClientEvent('MRFW:Notify', source, _U('time_morning'))
--         TriggerEvent('mr-weathersync:server:RequestStateSync')
--     end
-- end)

-- RegisterCommand('noon', function(source)
--     if source == 0 then
--         print(_U('time_console'))
--         return
--     end
--     if isAllowedToChange(source) then
--         ShiftToMinute(0)
--         ShiftToHour(12)
--         TriggerClientEvent('MRFW:Notify', source, _U('time_noon'))
--         TriggerEvent('mr-weathersync:server:RequestStateSync')
--     end
-- end)

-- RegisterCommand('evening', function(source)
--     if source == 0 then
--         print(_U('time_console'))
--         return
--     end
--     if isAllowedToChange(source) then
--         ShiftToMinute(0)
--         ShiftToHour(18)
--         TriggerClientEvent('MRFW:Notify', source, _U('time_evening'))
--         TriggerEvent('mr-weathersync:server:RequestStateSync')
--     end
-- end)

-- RegisterCommand('night', function(source)
--     if source == 0 then
--         print(_U('time_console'))
--         return
--     end
--     if isAllowedToChange(source) then
--         ShiftToMinute(0)
--         ShiftToHour(23)
--         TriggerClientEvent('MRFW:Notify', source, _U('time_night'))
--         TriggerEvent('mr-weathersync:server:RequestStateSync')
--     end
-- end)

-- RegisterCommand('time', function(source, args)
--     if source == 0 then
--         if tonumber(args[1]) and tonumber(args[2]) then
--             local argh = tonumber(args[1])
--             local argm = tonumber(args[2])
--             if argh < 24 then
--                 ShiftToHour(argh)
--             else
--                 ShiftToHour(0)
--             end
--             if argm < 60 then
--                 ShiftToMinute(argm)
--             else
--                 ShiftToMinute(0)
--             end
--             print(_U('time_change', argh, argm))
--             TriggerEvent('mr-weathersync:server:RequestStateSync')
--         else
--             print(_U('time_invalid'))
--         end
--     elseif source ~= 0 then
--         if isAllowedToChange(source) then
--             if tonumber(args[1]) and tonumber(args[2]) then
--                 local argh = tonumber(args[1])
--                 local argm = tonumber(args[2])
--                 if argh < 24 then
--                     ShiftToHour(argh)
--                 else
--                     ShiftToHour(0)
--                 end
--                 if argm < 60 then
--                     ShiftToMinute(argm)
--                 else
--                     ShiftToMinute(0)
--                 end
--                 local newtime = math.floor(((baseTime+timeOffset)/60)%24) .. ":"
-- 				local minute = math.floor((baseTime+timeOffset)%60)
--                 if minute < 10 then
--                     newtime = newtime .. "0" .. minute
--                 else
--                     newtime = newtime .. minute
--                 end
--                 TriggerClientEvent('MRFW:Notify', source, _U('time_changec', newtime))
--                 TriggerEvent('mr-weathersync:server:RequestStateSync')
--             else
--                 TriggerClientEvent('MRFW:Notify', source, _U('time_invalid'), 'error')
--             end
--         else
--             TriggerClientEvent('MRFW:Notify', source, _U('not_access'), 'error')
--             print(_U('time_access'))
--         end
--     end
-- end)

Citizen.CreateThread(function()
    local previous = 0
    while true do
        Citizen.Wait(0)
        local newBaseTime = os.time(os.date("!*t"))/2 + 360         --Set the server time depending of OS time
        if (newBaseTime % 60) ~= previous then                      --Check if a new minute is passed
            previous = newBaseTime % 60                             --Only update time with plain minutes, seconds are handled in the client
            if freezeTime then
                timeOffset = timeOffset + baseTime - newBaseTime			
            end
            baseTime = newBaseTime
        end 
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)                                          --Change to send every minute in game sync
        TriggerClientEvent('mr-weathersync:client:SyncTime', -1, baseTime, timeOffset, freezeTime)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300000)
        TriggerClientEvent('mr-weathersync:client:SyncWeather', -1, CurrentWeather, blackout)
    end
end)

Citizen.CreateThread(function()
    while true do
        newWeatherTimer = newWeatherTimer - 1
        Citizen.Wait((1000 * 60) * Config.NewWeatherTimer)
        if newWeatherTimer == 0 then
            if Config.DynamicWeather then
                NextWeatherStage()
            end
            newWeatherTimer = Config.NewWeatherTimer / 2
        end
    end
end)