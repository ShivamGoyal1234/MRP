local MRFW = exports['mrfw']:GetCoreObject()
local PlayerData = MRFW.Functions.GetPlayerData() -- Just for resource restart (same as event handler)
local radioMenu = false
local onRadio = false
local RadioChannel = 0
local RadioVolume = 50

--Function
local function LoadAnimDic(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(0)
        end
    end
end

local function SplitStr(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        t[#t+1] = str
    end
    return t
end

local function connecttoradio(channel)
    RadioChannel = channel
    if onRadio then
        exports["pma-voice"]:setRadioChannel(0)
    else
        onRadio = true
        exports["pma-voice"]:setVoiceProperty("radioEnabled", true)
    end
    exports["pma-voice"]:setRadioChannel(channel)
    if SplitStr(tostring(channel), ".")[2] ~= nil and SplitStr(tostring(channel), ".")[2] ~= "" then
        MRFW.Functions.Notify(Config.messages['joined_to_radio'] ..channel.. ' MHz', 'success')
    else
        MRFW.Functions.Notify(Config.messages['joined_to_radio'] ..channel.. '.00 MHz', 'success')
    end
end

local function closeEvent()
	TriggerEvent("InteractSound_CL:PlayOnOne","click",0.6)
end

local function leaveradio()
    closeEvent()
    local playerName = GetPlayerName(PlayerId())
    TriggerServerEvent("mr-log:server:CreateLog", "radio", "Leave Radio", "red", "**"..playerName.."** Just Leave This Radio Channel **(**`"..tonumber(RadioChannel).."`**)**")
    RadioChannel = 0
    onRadio = false
    exports["pma-voice"]:setRadioChannel(0)
    exports["pma-voice"]:setVoiceProperty("radioEnabled", false)
    MRFW.Functions.Notify(Config.messages['you_leave'] , 'error')
end

local radioProp = 0

local function toggleRadioAnimation(pState)
	LoadAnimDic("cellphone@")
	if pState then
        attachModelRadio = `prop_cs_hand_radio`
        RequestModel(attachModelRadio)
        while not HasModelLoaded(attachModelRadio) do
            Citizen.Wait(1)
        end
		TaskPlayAnim(PlayerPedId(), "cellphone@", "cellphone_text_read_base", 2.0, 3.0, -1, 49, 0, 0, 0, 0)
		radioProp = CreateObject(attachModelRadio, 1.0, 1.0, 1.0, 1, 1, 0)
        local bone = GetPedBoneIndex(PlayerPedId(), 57005)
	    AttachEntityToEntity(radioProp, PlayerPedId(), bone, 0.1, 0.01, -0.02, 110.0, 120.0, -15.0, 1, 0, 0, 0, 2, 1)
	else
		StopAnimTask(PlayerPedId(), "cellphone@", "cellphone_text_read_base", 1.0)
		ClearPedTasks(PlayerPedId())
		if radioProp ~= 0 then
			DeleteObject(radioProp)
			radioProp = 0
		end
	end
end

local function toggleRadio(toggle)
    radioMenu = toggle
    SetNuiFocus(radioMenu, radioMenu)
    if radioMenu then
        toggleRadioAnimation(true)
        SendNUIMessage({type = "open"})
    else
        toggleRadioAnimation(false)
        SendNUIMessage({type = "close"})
    end
end

local function IsRadioOn()
    return onRadio
end

--Exports
exports("IsRadioOn", IsRadioOn)

--Events
AddEventHandler('MRFW:Client:OnPlayerLoaded', function()
    PlayerData = MRFW.Functions.GetPlayerData()
end)

RegisterNetEvent('MRFW:Client:OnPlayerUnload', function()
    PlayerData = {}
    leaveradio()
end)

RegisterNetEvent('MRFW:Player:SetPlayerData', function(val)
    PlayerData = val
end)

RegisterNetEvent('mr-radio:use', function()
    toggleRadio(not radioMenu)
end)

RegisterNetEvent('mr-radio:onRadioDrop', function()
    if RadioChannel ~= 0 then
        leaveradio()
    end
end)

-- NUI
RegisterNUICallback('joinRadio', function(data, cb)
    local rchannel = tonumber(data.channel)
    local playerName = GetPlayerName(PlayerId())
    if rchannel ~= nil then
        if rchannel <= Config.MaxFrequency and rchannel ~= 0 then
            if rchannel ~= RadioChannel then
                if rchannel < 12 then
                    if (PlayerData.job.name == 'police' or PlayerData.job.name == 'doctor' or PlayerData.job.name == 'government') and PlayerData.job.onduty then
                        TriggerServerEvent("mr-log:server:CreateLog", "radio", "Joined Radio", "green", "**"..playerName.."** Just Joined This Radio Channel **(**`"..tonumber(data.channel).."`**)**")
                        connecttoradio(rchannel)
                    else
                        MRFW.Functions.Notify(Config.messages['restricted_channel_error'], 'error')
                    end
                else
                    TriggerServerEvent("mr-log:server:CreateLog", "radio", "Joined Radio", "green", "**"..playerName.."** Just Joined This Radio Channel **(**`"..tonumber(data.channel).."`**)**")
                    connecttoradio(rchannel)
                end
            else
                MRFW.Functions.Notify(Config.messages['you_on_radio'] , 'error')
            end
        else
            MRFW.Functions.Notify(Config.messages['invalid_radio'] , 'error')
        end
    else
        MRFW.Functions.Notify(Config.messages['invalid_radio'] , 'error')
    end
end)

RegisterNUICallback('leaveRadio', function(data, cb)
    if RadioChannel == 0 then
        MRFW.Functions.Notify(Config.messages['not_on_radio'], 'error')
    else
        leaveradio()
    end
end)

RegisterNUICallback("volumeUp", function()
	if RadioVolume <= 95 then
		RadioVolume = RadioVolume + 5
		MRFW.Functions.Notify(Config.messages["volume_radio"] .. RadioVolume, "success")
		exports["pma-voice"]:setRadioVolume(RadioVolume)
	else
		MRFW.Functions.Notify(Config.messages["decrease_radio_volume"], "error")
	end
end)

RegisterNUICallback("volumeDown", function()
	if RadioVolume >= 10 then
		RadioVolume = RadioVolume - 5
		MRFW.Functions.Notify(Config.messages["volume_radio"] .. RadioVolume, "success")
		exports["pma-voice"]:setRadioVolume(RadioVolume)
	else
		MRFW.Functions.Notify(Config.messages["increase_radio_volume"], "error")
	end
end)

RegisterNUICallback("increaseradiochannel", function(data, cb)
    if onRadio then
        exports["pma-voice"]:setRadioChannel(0)
    else
        onRadio = true
        exports["pma-voice"]:setVoiceProperty("radioEnabled", true)
    end
    local newChannel = RadioChannel + 1
    if newChannel < 11 then
        if PlayerData.job.name == 'police' or PlayerData.job.name == 'doctor' or PlayerData.job.name == 'government' then
            if PlayerData.job.onduty then
                exports["pma-voice"]:setRadioChannel(newChannel)
                RadioChannel = newChannel
                SendNUIMessage({
                    type = "up",
                    radio = newChannel
                })
                MRFW.Functions.Notify(Config.messages["increase_decrease_radio_channel"] .. newChannel, "success")
            else
                MRFW.Functions.Notify(Config.messages['restricted_channel_error_duty'], 'error')
            end
        else
            MRFW.Functions.Notify(Config.messages['restricted_channel_error'], 'error')
        end
    else
        exports["pma-voice"]:setRadioChannel(newChannel)
        RadioChannel = newChannel
        SendNUIMessage({
            type = "up",
            radio = newChannel
        })
        MRFW.Functions.Notify(Config.messages["increase_decrease_radio_channel"] .. newChannel, "success")
    end
end)

RegisterNUICallback("decreaseradiochannel", function(data, cb)
    if onRadio then
        exports["pma-voice"]:setRadioChannel(0)
    else
        onRadio = true
        exports["pma-voice"]:setVoiceProperty("radioEnabled", true)
    end
    local newChannel = RadioChannel - 1
    if newChannel >= 1 then
        if newChannel < 11 then
            if PlayerData.job.name == 'police' or PlayerData.job.name == 'doctor' or PlayerData.job.name == 'government' then
                if PlayerData.job.onduty then
                    exports["pma-voice"]:setRadioChannel(newChannel)
                    RadioChannel = newChannel
                    SendNUIMessage({
                        type = "up",
                        radio = newChannel
                    })
                    MRFW.Functions.Notify(Config.messages["increase_decrease_radio_channel"] .. newChannel, "success")
                else
                    MRFW.Functions.Notify(Config.messages['restricted_channel_error_duty'], 'error')
                end
            else
                MRFW.Functions.Notify(Config.messages['restricted_channel_error'], 'error')
            end
        else
            exports["pma-voice"]:setRadioChannel(newChannel)
            RadioChannel = newChannel
            SendNUIMessage({
                type = "up",
                radio = newChannel
            })
            MRFW.Functions.Notify(Config.messages["increase_decrease_radio_channel"] .. newChannel, "success")
        end
    end
end)

RegisterNUICallback('poweredOff', function(data, cb)
    leaveradio()
end)

RegisterNUICallback('escape', function(data, cb)
    toggleRadio(false)
end)

--Main Thread
CreateThread(function()
    while true do
        Wait(1000)
        if LocalPlayer.state.isLoggedIn and onRadio then
            MRFW.Functions.TriggerCallback('mr-radio:server:GetItem', function(hasItem)
                if not hasItem then
                    if RadioChannel ~= 0 then
                        leaveradio()
                    end
                end
            end, "radio")
        end
    end
end)

RegisterCommand('+o', function()
    NetworkSetVoiceActive(false)
    Wait(500)
    NetworkSetVoiceActive(true)
    TriggerEvent("MRFW:Notify", "Voice Reconnected", "success", 3000)
end)
RegisterKeyMapping("+o", "Mumble Reconnect", "keyboard", "")