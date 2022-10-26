local MRFW = exports['mrfw']:GetCoreObject()
local PlayerJob = {}
local patt = "[?!@#]"
local CallVolume = 0.2
PhoneData = {
    MetaData = {},
    isOpen = false,
    PlayerData = nil,
    Contacts = {},
    Tweets = {},
    MentionedTweets = {},
    Hashtags = {},
    Anons = {},
    MentionedAnons = {},
    Hashtags_dark = {},
    Chats = {},
    Invoices = {},
    CallData = {},
    RecentCalls = {},
    Garage = {},
    Mails = {},
    Adverts = {},
    GarageVehicles = {},
    AnimationData = {
        lib = nil,
        anim = nil,
    },
    SuggestedContacts = {},
    CryptoTransactions = {},
    Images = {},
}

local VPNopen = false

local attempts = 1

local function KI(TE, IT, ML)
    AddTextEntry('FMMC_KEY_TIP1', TE)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", IT, "", "", "", ML)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        return result
    else
        Wait(500)
        return nil
    end
end

RegisterNetEvent("9d:ShowPasswordPrompt", function()
    local password = KI("Enter VPN password ", "", 30)
    attempts = attempts - 1
    TriggerServerEvent("9d:CheckPassword", password, attempts)
end)

RegisterNetEvent('9d:PassedPassword', function()
    VPNopen = true
    MRFW.Functions.Notify('VPN: Login', 'success', 5000)
end)

RegisterNetEvent('9d:FailedPassword', function(wrong)
    if wrong then
        attempts = 1
        MRFW.Functions.Notify('VPN: Wrong Password', 'error', 5000)
    else
        attempts = 1
    end
end)

RegisterNUICallback('toggelVPN', function()
    if not VPNopen then
        Wait(1000)
        TriggerServerEvent("9d:Initialize")
    else
        VPNopen = false
        attempts = 1
        MRFW.Functions.Notify('VPN: Logout', 'error', 5000)
    end
end)

RegisterNUICallback('checkforvpn', function(data, cb)
    cb(VPNopen)
end)

RegisterNUICallback('vpnerror', function()
    MRFW.Functions.Notify('VPN is off', 'error', 3000)
end)

-- Functions

function string:split(delimiter)
    local result = { }
    local from  = 1
    local delim_from, delim_to = string.find( self, delimiter, from  )
    while delim_from do
      table.insert( result, string.sub( self, from , delim_from-1 ) )
      from  = delim_to + 1
      delim_from, delim_to = string.find( self, delimiter, from  )
    end
    table.insert( result, string.sub( self, from  ) )
    return result
end

local function escape_str(s)
	return s
end

local function GenerateTweetId()
    local tweetId = "TWEET-"..math.random(11111111, 99999999)
    return tweetId
end

local function GenerateAnonId()
    local tweetId = "ANON-"..math.random(11111111, 99999999)
    return tweetId
end

local function IsNumberInContacts(num)
    local retval = num
    for _, v in pairs(PhoneData.Contacts) do
        if num == v.number then
            retval = v.name
        end
    end
    return retval
end

local function CalculateTimeToDisplay()
	hour = GetClockHours()
    minute = GetClockMinutes()

    local obj = {}

	if minute <= 9 then
		minute = "0" .. minute
    end

    obj.hour = hour
    obj.minute = minute

    return obj
end

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

local function GetKeyByDate(Number, Date)
    local retval = nil
    if PhoneData.Chats[Number] ~= nil then
        if PhoneData.Chats[Number].messages ~= nil then
            for key, chat in pairs(PhoneData.Chats[Number].messages) do
                if chat.date == Date then
                    retval = key
                    break
                end
            end
        end
    end
    return retval
end

local function GetKeyByNumber(Number)
    local retval = nil
    if PhoneData.Chats then
        for k, v in pairs(PhoneData.Chats) do
            if v.number == Number then
                retval = k
            end
        end
    end
    return retval
end

local function ReorganizeChats(key)
    local ReorganizedChats = {}
    ReorganizedChats[1] = PhoneData.Chats[key]
    for k, chat in pairs(PhoneData.Chats) do
        if k ~= key then
            ReorganizedChats[#ReorganizedChats+1] = chat
        end
    end
    PhoneData.Chats = ReorganizedChats
end

local function findVehFromPlateAndLocate(plate)
    local gameVehicles = MRFW.Functions.GetVehicles()
    for i = 1, #gameVehicles do
        local vehicle = gameVehicles[i]
        if DoesEntityExist(vehicle) then
            if MRFW.Functions.GetPlate(vehicle) == plate then
                local vehCoords = GetEntityCoords(vehicle)
                SetNewWaypoint(vehCoords.x, vehCoords.y)
                return true
            end
        end
    end
end

local function PublicPhone()
    local PublicPhoneobject = {
        -2103798695,1158960338,
        1281992692,1511539537,
        295857659,-78626473,
        -1559354806
    }
        exports["mr-eye"]:AddTargetModel(PublicPhoneobject, {
            options = {
                {
                    type = "client",
                    event = "stx-phone:client:publocphoneopen",
                    icon = "fas fa-phone-alt",
                    label = "Public Phone",
                    job = false,
                },
            },
            distance = 1.0
        })
end

local function DisableDisplayControlActions()
    DisableControlAction(0, 1, true)
    DisableControlAction(0, 2, true)
    DisableControlAction(0, 3, true)
    DisableControlAction(0, 4, true)
    DisableControlAction(0, 5, true)
    DisableControlAction(0, 6, true)
    DisableControlAction(0, 263, true)
    DisableControlAction(0, 264, true)
    DisableControlAction(0, 257, true)
    DisableControlAction(0, 140, true)
    DisableControlAction(0, 141, true)
    DisableControlAction(0, 142, true)
    DisableControlAction(0, 143, true)
    DisableControlAction(0, 177, true)
    DisableControlAction(0, 200, true)
    DisableControlAction(0, 202, true)
    DisableControlAction(0, 322, true)
    DisableControlAction(0, 245, true)
end

local function LoadPhone()
    Wait(100)
    MRFW.Functions.TriggerCallback('mr-phone:server:GetPhoneData', function(pData)
        PlayerJob = MRFW.Functions.GetPlayerData().job
        PhoneData.PlayerData = MRFW.Functions.GetPlayerData()
        local PhoneMeta = PhoneData.PlayerData.metadata["phone"]
        PhoneData.MetaData = PhoneMeta

        if pData.InstalledApps ~= nil and next(pData.InstalledApps) ~= nil then
            for k, v in pairs(pData.InstalledApps) do
                local AppData = Config.StoreApps[v.app]
                Config.PhoneApplications[v.app] = {
                    app = v.app,
                    color = AppData.color,
                    icon = AppData.icon,
                    tooltipText = AppData.title,
                    tooltipPos = "right",
                    job = AppData.job,
                    blockedjobs = AppData.blockedjobs,
                    slot = AppData.slot,
                    Alerts = 0,
                }
            end
        end

        if PhoneMeta.profilepicture == nil then
            PhoneData.MetaData.profilepicture = "default"
        else
            PhoneData.MetaData.profilepicture = PhoneMeta.profilepicture
        end

        if pData.Applications ~= nil and next(pData.Applications) ~= nil then
            for k, v in pairs(pData.Applications) do
                Config.PhoneApplications[k].Alerts = v
            end
        end

        if pData.MentionedTweets ~= nil and next(pData.MentionedTweets) ~= nil then
            PhoneData.MentionedTweets = pData.MentionedTweets
        end

        if pData.MentionedAnons ~= nil and next(pData.MentionedAnons) ~= nil then
            PhoneData.MentionedAnons = pData.MentionedAnons
        end

        if pData.PlayerContacts ~= nil and next(pData.PlayerContacts) ~= nil then
            PhoneData.Contacts = pData.PlayerContacts
        end

        if pData.Chats ~= nil and next(pData.Chats) ~= nil then
            local Chats = {}
            for k, v in pairs(pData.Chats) do
                Chats[v.number] = {
                    name = IsNumberInContacts(v.number),
                    number = v.number,
                    messages = json.decode(v.messages)
                }
            end

            PhoneData.Chats = Chats
        end

        if pData.Invoices ~= nil and next(pData.Invoices) ~= nil then
            for _, invoice in pairs(pData.Invoices) do
                invoice.name = IsNumberInContacts(invoice.number)
            end
            PhoneData.Invoices = pData.Invoices
        end

        if pData.Hashtags ~= nil and next(pData.Hashtags) ~= nil then
            PhoneData.Hashtags = pData.Hashtags
        end

        if pData.Hashtags_dark ~= nil and next(pData.Hashtags_dark) ~= nil then
            PhoneData.Hashtags_dark = pData.Hashtags_dark
        end

        if pData.Tweets ~= nil and next(pData.Tweets) ~= nil then
            PhoneData.Tweets = pData.Tweets
        end

        if pData.Anons ~= nil and next(pData.Anons) ~= nil then
            PhoneData.Anons = pData.Anons
        end

        if pData.Mails ~= nil and next(pData.Mails) ~= nil then
            PhoneData.Mails = pData.Mails
        end

        if pData.Adverts ~= nil and next(pData.Adverts) ~= nil then
            PhoneData.Adverts = pData.Adverts
        end

        if pData.CryptoTransactions ~= nil and next(pData.CryptoTransactions) ~= nil then
            PhoneData.CryptoTransactions = pData.CryptoTransactions
        end
        if pData.Images ~= nil and next(pData.Images) ~= nil then
            PhoneData.Images = pData.Images
        end

        SendNUIMessage({
            action = "LoadPhoneData",
            PhoneData = PhoneData,
            PlayerData = PhoneData.PlayerData,
            PlayerJob = PhoneData.PlayerData.job,
            applications = Config.PhoneApplications,
            PlayerId = GetPlayerServerId(PlayerId())
        })
    end)
end

local function OpenPhone()
    MRFW.Functions.TriggerCallback('mr-phone:server:HasPhone', function(HasPhone)
        if HasPhone then
            PhoneData.PlayerData = MRFW.Functions.GetPlayerData()
    	    SetNuiFocus(true, true)
            SendNUIMessage({
                action = "open",
                Tweets = PhoneData.Tweets,
                Anons = PhoneData.Anons,
                AppData = Config.PhoneApplications,
                CallData = PhoneData.CallData,
                PlayerData = PhoneData.PlayerData,
            })
            PhoneData.isOpen = true

            CreateThread(function()
                while PhoneData.isOpen do
                    DisableDisplayControlActions()
                    Wait(1)
                end
            end)

            if not PhoneData.CallData.InCall then
                DoPhoneAnimation('cellphone_text_in')
            else
                DoPhoneAnimation('cellphone_call_to_text')
            end

            SetTimeout(250, function()
                newPhoneProp()
            end)

            MRFW.Functions.TriggerCallback('mr-phone:server:GetGarageVehicles', function(vehicles)
                PhoneData.GarageVehicles = vehicles
            end)
        else
            MRFW.Functions.Notify("You don't have a phone?", "error")
        end
    end)
end

local function GenerateCallId(caller, target)
    local CallId = math.ceil(((tonumber(caller) + tonumber(target)) / 100 * 1))
    return CallId
end

local function CallContact(CallData, AnonymousCall)
    local RepeatCount = 0
    PhoneData.CallData.CallType = "outgoing"
    PhoneData.CallData.InCall = true
    PhoneData.CallData.TargetData = CallData
    PhoneData.CallData.AnsweredCall = false
    PhoneData.CallData.CallId = GenerateCallId(PhoneData.PlayerData.charinfo.phone, CallData.number)

    TriggerServerEvent('mr-phone:server:CallContact', PhoneData.CallData.TargetData, PhoneData.CallData.CallId, AnonymousCall)
    TriggerServerEvent('mr-phone:server:SetCallState', true)

    for i = 1, Config.CallRepeats + 1, 1 do
        if not PhoneData.CallData.AnsweredCall then
            if RepeatCount + 1 ~= Config.CallRepeats + 1 then
                if PhoneData.CallData.InCall then
                    RepeatCount = RepeatCount + 1
                    TriggerServerEvent("InteractSound_SV:PlayOnSource", "demo", 0.1)
                else
                    break
                end
                Wait(Config.RepeatTimeout)
            else
                CancelCall()
                break
            end
        else
            break
        end
    end
end

local function CancelCall()
    TriggerServerEvent('mr-phone:server:CancelCall', PhoneData.CallData)
    if PhoneData.CallData.CallType == "ongoing" then
        exports['pma-voice']:removePlayerFromCall(PhoneData.CallData.CallId)
    end
    PhoneData.CallData.CallType = nil
    PhoneData.CallData.InCall = false
    PhoneData.CallData.AnsweredCall = false
    PhoneData.CallData.TargetData = {}
    PhoneData.CallData.CallId = nil

    if not PhoneData.isOpen then
        StopAnimTask(PlayerPedId(), PhoneData.AnimationData.lib, PhoneData.AnimationData.anim, 2.5)
        deletePhone()
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
    else
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
    end

    TriggerServerEvent('mr-phone:server:SetCallState', false)
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "demo", 0.0)

    if not PhoneData.isOpen then
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Phone",
                text = "Call ended",
                icon = "fas fa-phone",
                color = "#e84118",
            },
        })
    else
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Phone",
                text = "Call ended",
                icon = "fas fa-phone",
                color = "#e84118",
            },
        })

        SendNUIMessage({
            action = "SetupHomeCall",
            CallData = PhoneData.CallData,
        })

        SendNUIMessage({
            action = "CancelOutgoingCall",
        })
    end
end

RegisterNetEvent('decline:call', function()
    if PhoneData.CallData.CallType == "incoming" or PhoneData.CallData.CallType == "outgoing" or PhoneData.CallData.InCall then
        CancelCall()
    end
end)

local function AnswerCall()
    if (PhoneData.CallData.CallType == "incoming" or PhoneData.CallData.CallType == "outgoing") and PhoneData.CallData.InCall and not PhoneData.CallData.AnsweredCall then
        PhoneData.CallData.CallType = "ongoing"
        PhoneData.CallData.AnsweredCall = true
        PhoneData.CallData.CallTime = 0

        SendNUIMessage({ action = "AnswerCall", CallData = PhoneData.CallData})
        SendNUIMessage({ action = "SetupHomeCall", CallData = PhoneData.CallData})

        TriggerServerEvent('mr-phone:server:SetCallState', true)
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "demo", 0.0)

        if PhoneData.isOpen then
            DoPhoneAnimation('cellphone_text_to_call')
        else
            DoPhoneAnimation('cellphone_call_listen_base')
        end

        CreateThread(function()
            while true do
                if PhoneData.CallData.AnsweredCall then
                    PhoneData.CallData.CallTime = PhoneData.CallData.CallTime + 1
                    SendNUIMessage({
                        action = "UpdateCallTime",
                        Time = PhoneData.CallData.CallTime,
                        Name = PhoneData.CallData.TargetData.name,
                    })
                else
                    break
                end

                Wait(1000)
            end
        end)

        TriggerServerEvent('mr-phone:server:AnswerCall', PhoneData.CallData)
        exports['pma-voice']:addPlayerToCall(PhoneData.CallData.CallId)
    else
        PhoneData.CallData.InCall = false
        PhoneData.CallData.CallType = nil
        PhoneData.CallData.AnsweredCall = false
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "vtexts", 0.4)

        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Phone",
                text = "You don't have an incoming call...",
                icon = "fas fa-phone",
                color = "#e84118",
            },
        })
    end
end

RegisterNetEvent('accept:call', function()
    if PhoneData.CallData.CallType == "incoming" and PhoneData.CallData.InCall and not PhoneData.CallData.AnsweredCall then
        AnswerCall()
    end
end)

local function CellFrontCamActivate(activate)
	return Citizen.InvokeNative(0x2491A93618B7D838, activate)
end

-- Command

RegisterCommand('phone', function()
    PlayerData = MRFW.Functions.GetPlayerData()
    if not PhoneData.isOpen and LocalPlayer.state.isLoggedIn then
        if not PlayerData.metadata['ishandcuffed'] and not PlayerData.metadata['inlaststand'] and not PlayerData.metadata['isdead'] and not IsPauseMenuActive() then
            OpenPhone()
        else
            MRFW.Functions.Notify("Action not available at the moment..", "error")
        end
    end
end)

RegisterKeyMapping('phone', 'Open Phone', 'keyboard', 'M')

-- NUI Callbacks

RegisterNUICallback('CancelOutgoingCall', function()
    CancelCall()
end)

RegisterNUICallback('DenyIncomingCall', function()
    CancelCall()
end)

RegisterNUICallback('CancelOngoingCall', function()
    CancelCall()
end)

RegisterNUICallback('AnswerCall', function()
    AnswerCall()
end)

RegisterNUICallback('ClearRecentAlerts', function(data, cb)
    TriggerServerEvent('mr-phone:server:SetPhoneAlerts', "phone", 0)
    Config.PhoneApplications["phone"].Alerts = 0
    SendNUIMessage({ action = "RefreshAppAlerts", AppData = Config.PhoneApplications })
end)

RegisterNUICallback('SetBackground', function(data)
    local background = data.background
    PhoneData.MetaData.background = background
    TriggerServerEvent('mr-phone:server:SaveMetaData', PhoneData.MetaData)
end)

RegisterNUICallback('GetMissedCalls', function(data, cb)
    cb(PhoneData.RecentCalls)
end)

RegisterNUICallback('GetSuggestedContacts', function(data, cb)
    cb(PhoneData.SuggestedContacts)
end)

RegisterNUICallback('HasPhone', function(data, cb)
    MRFW.Functions.TriggerCallback('mr-phone:server:HasPhone', function(HasPhone)
        cb(HasPhone)
    end)
end)

RegisterNUICallback('SetupGarageVehicles', function(data, cb)
    cb(PhoneData.GarageVehicles)
end)

RegisterNUICallback('RemoveMail', function(data, cb)
    local MailId = data.mailId
    TriggerServerEvent('mr-phone:server:RemoveMail', MailId)
    cb('ok')
end)

RegisterNUICallback('Close', function()
    if not PhoneData.CallData.InCall then
        DoPhoneAnimation('cellphone_text_out')
        SetTimeout(400, function()
            StopAnimTask(PlayerPedId(), PhoneData.AnimationData.lib, PhoneData.AnimationData.anim, 2.5)
            deletePhone()
            PhoneData.AnimationData.lib = nil
            PhoneData.AnimationData.anim = nil
        end)
    else
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
        DoPhoneAnimation('cellphone_text_to_call')
    end
    SetTimeout(300, function()
        SetNuiFocus(false, false)
        PhoneData.isOpen = false
    end)
end)

RegisterNUICallback('AcceptMailButton', function(data)
    if data.buttonEvent ~= nil or  data.buttonData ~= nil then
        TriggerEvent(data.buttonEvent, data.buttonData)
    end
    TriggerServerEvent('mr-phone:server:ClearButtonData', data.mailId)
end)

RegisterNUICallback('AddNewContact', function(data, cb)
    PhoneData.Contacts[#PhoneData.Contacts+1] = {
        name = data.ContactName,
        number = data.ContactNumber,
        iban = data.ContactIban
    }
    Wait(100)
    cb(PhoneData.Contacts)
    if PhoneData.Chats[data.ContactNumber] ~= nil and next(PhoneData.Chats[data.ContactNumber]) ~= nil then
        PhoneData.Chats[data.ContactNumber].name = data.ContactName
    end
    TriggerServerEvent('mr-phone:server:AddNewContact', data.ContactName, data.ContactNumber, data.ContactIban)
end)

RegisterNUICallback('GetMails', function(data, cb)
    cb(PhoneData.Mails)
end)

RegisterNUICallback('GetWhatsappChat', function(data, cb)
    if PhoneData.Chats[data.phone] ~= nil then
        cb(PhoneData.Chats[data.phone])
    else
        cb(false)
    end
end)

RegisterNUICallback('GetProfilePicture', function(data, cb)
    local number = data.number
    MRFW.Functions.TriggerCallback('mr-phone:server:GetPicture', function(picture)
        cb(picture)
    end, number)
end)

RegisterNUICallback('GetBankContacts', function(data, cb)
    cb(PhoneData.Contacts)
end)

RegisterNUICallback('GetInvoices', function(data, cb)
    if PhoneData.Invoices ~= nil and next(PhoneData.Invoices) ~= nil then
        cb(PhoneData.Invoices)
    else
        cb(nil)
    end
end)

RegisterNUICallback('SharedLocation', function(data)
    local x = data.coords.x
    local y = data.coords.y

    SetNewWaypoint(x, y)
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "vtexts", 0.4)
    SendNUIMessage({
        action = "PhoneNotification",
        PhoneNotify = {
            title = "Messages",
            text = "Location set!",
            icon = "fas fa-comment",
            color = "#25D366",
            timeout = 1500,
        },
    })
end)

RegisterNUICallback('PostAdvert', function(data)
    TriggerServerEvent('mr-phone:server:AddAdvert', data.message, data.url)
end)

RegisterNUICallback("DeleteAdvert", function()
    TriggerServerEvent("mr-phone:server:DeleteAdvert")
end)

RegisterNUICallback('LoadAdverts', function()
    SendNUIMessage({
        action = "RefreshAdverts",
        Adverts = PhoneData.Adverts
    })
end)

RegisterNUICallback('ClearAlerts', function(data, cb)
    local chat = data.number
    local ChatKey = GetKeyByNumber(chat)

    if PhoneData.Chats[ChatKey].Unread ~= nil then
        local newAlerts = (Config.PhoneApplications['whatsapp'].Alerts - PhoneData.Chats[ChatKey].Unread)
        Config.PhoneApplications['whatsapp'].Alerts = newAlerts
        TriggerServerEvent('mr-phone:server:SetPhoneAlerts', "whatsapp", newAlerts)

        PhoneData.Chats[ChatKey].Unread = 0

        SendNUIMessage({
            action = "RefreshWhatsappAlerts",
            Chats = PhoneData.Chats,
        })
        SendNUIMessage({ action = "RefreshAppAlerts", AppData = Config.PhoneApplications })
    end
end)

local jobs = {
    'police',
    'doctor',
    'pdm',
    'edm',
    'mechanic',
    'mcd',
    'doj',
    'shopone',
    'catcafe',
    'realestate',
    'government',
    'bennys',
}
RegisterNUICallback('jacob_duty', function()
    for k,v in pairs(jobs) do
        if PhoneData.PlayerData.job.name == v then
            TriggerServerEvent("MRFW:ToggleDuty")
            return
        end
    end
    MRFW.Functions.Notify('No Access', 'error', 3000)
end)

RegisterNUICallback('PayInvoice', function(data, cb)
    local sender = data.sender
    local senderCitizenId = data.senderCitizenId
    local society = data.society
    local amount = data.amount
    local invoiceId = data.invoiceId

    MRFW.Functions.TriggerCallback('mr-phone:server:PayInvoice', function(CanPay, Invoices)
        if CanPay then PhoneData.Invoices = Invoices end
        cb(CanPay)
    end, society, amount, invoiceId, senderCitizenId)
    TriggerServerEvent('mr-phone:server:BillingEmail', data, true)
    TriggerServerEvent('jim-payments:Tickets:Give', amount, society)
end)

RegisterNUICallback('DeclineInvoice', function(data, cb)
    local sender = data.sender
    local society = data.society
    local amount = data.amount
    local invoiceId = data.invoiceId

    MRFW.Functions.TriggerCallback('mr-phone:server:DeclineInvoice', function(CanPay, Invoices)
        PhoneData.Invoices = Invoices
        cb('ok')
    end, society, amount, invoiceId)
    TriggerServerEvent('mr-phone:server:BillingEmail', data, false)
end)

RegisterNUICallback('EditContact', function(data, cb)
    local NewName = data.CurrentContactName
    local NewNumber = data.CurrentContactNumber
    local NewIban = data.CurrentContactIban
    local OldName = data.OldContactName
    local OldNumber = data.OldContactNumber
    local OldIban = data.OldContactIban

    for k, v in pairs(PhoneData.Contacts) do
        if v.name == OldName and v.number == OldNumber then
            v.name = NewName
            v.number = NewNumber
            v.iban = NewIban
        end
    end
    if PhoneData.Chats[NewNumber] ~= nil and next(PhoneData.Chats[NewNumber]) ~= nil then
        PhoneData.Chats[NewNumber].name = NewName
    end
    Wait(100)
    cb(PhoneData.Contacts)
    TriggerServerEvent('mr-phone:server:EditContact', NewName, NewNumber, NewIban, OldName, OldNumber, OldIban)
end)

RegisterNUICallback('GetHashtagMessages', function(data, cb)
    if PhoneData.Hashtags[data.hashtag] ~= nil and next(PhoneData.Hashtags[data.hashtag]) ~= nil then
        cb(PhoneData.Hashtags[data.hashtag])
    else
        cb(nil)
    end
end)

RegisterNUICallback('GetHashtagMessages-dark', function(data, cb)
    if PhoneData.Hashtags_dark[data.hashtag] ~= nil and next(PhoneData.Hashtags_dark[data.hashtag]) ~= nil then
        cb(PhoneData.Hashtags_dark[data.hashtag])
    else
        cb(nil)
    end
end)

RegisterNUICallback('GetTweets', function(data, cb)
    cb(PhoneData.Tweets)
end)

-- example how to trigger it



RegisterNUICallback('GetAnons', function(data, cb)
    cb(PhoneData.Anons)
end)

RegisterNUICallback('UpdateProfilePicture', function(data)
    local pf = data.profilepicture
    PhoneData.MetaData.profilepicture = pf
    TriggerServerEvent('mr-phone:server:SaveMetaData', PhoneData.MetaData)
end)

RegisterNUICallback('PostNewTweet', function(data, cb)
    local TweetMessage = {
        firstName = PhoneData.PlayerData.charinfo.firstname,
        lastName = PhoneData.PlayerData.charinfo.lastname,
        citizenid = PhoneData.PlayerData.citizenid,
        message = escape_str(data.Message),
        time = data.Date,
        tweetId = GenerateTweetId(),
        picture = data.Picture,
        url = data.url
    }

    local TwitterMessage = data.Message
    local MentionTag = TwitterMessage:split("@")
    local Hashtag = TwitterMessage:split("#")

    for i = 2, #Hashtag, 1 do
        local Handle = Hashtag[i]:split(" ")[1]
        if Handle ~= nil or Handle ~= "" then
            local InvalidSymbol = string.match(Handle, patt)
            if InvalidSymbol then
                Handle = Handle:gsub("%"..InvalidSymbol, "")
            end
            TriggerServerEvent('mr-phone:server:UpdateHashtags', Handle, TweetMessage)
        end
    end

    for i = 2, #MentionTag, 1 do
        local Handle = MentionTag[i]:split(" ")[1]
        if Handle ~= nil or Handle ~= "" then
            local Fullname = Handle:split("_")
            local Firstname = Fullname[1]
            table.remove(Fullname, 1)
            local Lastname = table.concat(Fullname, " ")

            if (Firstname ~= nil and Firstname ~= "") and (Lastname ~= nil and Lastname ~= "") then
                if Firstname ~= PhoneData.PlayerData.charinfo.firstname and Lastname ~= PhoneData.PlayerData.charinfo.lastname then
                    TriggerServerEvent('mr-phone:server:MentionedPlayer', Firstname, Lastname, TweetMessage)
                end
            end
        end
    end

    PhoneData.Tweets[#PhoneData.Tweets+1] = TweetMessage
    Wait(100)
    cb(PhoneData.Tweets)

    TriggerServerEvent('mr-phone:server:UpdateTweets', PhoneData.Tweets, TweetMessage)
end)

RegisterNUICallback('PostNewAnon', function(data, cb)
    -- local hasVPN = MRFW.Functions.HasItem(Config.VPN)
    if VPNopen then
        local AnonMessage = {
            firstName = PhoneData.PlayerData.charinfo.firstname,
            lastName = PhoneData.PlayerData.charinfo.lastname,
            citizenid = PhoneData.PlayerData.citizenid,
            anonym    = PhoneData.PlayerData.charinfo.Anonymous,
            -- anonym = 753468,
            message = escape_str(data.Message),
            time = data.Date,
            anonId = GenerateAnonId(),
            picture = data.Picture,
            url = data.url
        }
        TriggerServerEvent("mr-log:server:CreateLog", "darkweb", "Darkweb", "black", "**"..PhoneData.PlayerData.name.."**\n\n**Anon:"..PhoneData.PlayerData.charinfo.Anonymous.."**\n\n ```"..escape_str(data.Message).."```",nil, 'DarkWeb', 'https://cdn.discordapp.com/attachments/904668847859171339/904727275809943682/cso_black_hat_hacker_by_matiasenelmundo_gettyimages-823247618_blue_binary_matrix_binary_rain_by_bannosuke_gettyimages-687353118_2400x1600-100802503-large.png')
        local DarkwebMessage = data.Message
        local MentionTag = DarkwebMessage:split("@")
        local Hashtag = DarkwebMessage:split("#")

        for i = 2, #Hashtag, 1 do
            local Handle = Hashtag[i]:split(" ")[1]
            if Handle ~= nil or Handle ~= "" then
                local InvalidSymbol = string.match(Handle, patt)
                if InvalidSymbol then
                    Handle = Handle:gsub("%"..InvalidSymbol, "")
                end
                TriggerServerEvent('mr-phone:server:UpdateHashtags-dark', Handle, AnonMessage)
            end
        end

        for i = 2, #MentionTag, 1 do
            local Handle = MentionTag[i]:split(" ")[1]
            if Handle ~= nil or Handle ~= "" then
                local Fullname = Handle:split("_")
                local Firstname = Fullname[1]
                table.remove(Fullname, 1)
                local Lastname = table.concat(Fullname, " ")

                if (Firstname ~= nil and Firstname ~= "") and (Lastname ~= nil and Lastname ~= "") then
                    if Firstname ~= PhoneData.PlayerData.charinfo.firstname and Lastname ~= PhoneData.PlayerData.charinfo.lastname then
                        TriggerServerEvent('mr-phone:server:MentionedPlayer-dark', Firstname, Lastname, AnonMessage)
                    end
                end
            end
        end

        PhoneData.Anons[#PhoneData.Anons+1] = AnonMessage
        Wait(100)
        cb(PhoneData.Anons)

        TriggerServerEvent('mr-phone:server:UpdateAnons', PhoneData.Anons, AnonMessage)
    else
        cb(PhoneData.Anons)
        MRFW.Functions.Notify('Turn on vpn First', 'error', 5000)
    end
end)

RegisterNUICallback('DeleteTweet',function(data)
    TriggerServerEvent('mr-phone:server:DeleteTweet', data.id)
end)

RegisterNUICallback('DeleteAnon',function(data)
    TriggerServerEvent('mr-phone:server:DeleteAnon', data.id)
end)

RegisterNUICallback('GetMentionedTweets', function(data, cb)
    cb(PhoneData.MentionedTweets)
end)

RegisterNUICallback('GetMentionedAnons', function(data, cb)
    cb(PhoneData.MentionedAnons)
end)

-- RegisterNUICallback('checkforvpn', function(data, cb)
--     -- cb(MRFW.Functions.HasItem(Config.VPN))
--     cb(true)
-- end)

-- RegisterNUICallback('vpnerror', function(data, cb)
--     MRFW.Functions.Notify('You Don\'t have vpn', 'error', 3000)
-- end)

RegisterNUICallback('GetHashtags', function(data, cb)
    if PhoneData.Hashtags ~= nil and next(PhoneData.Hashtags) ~= nil then
        cb(PhoneData.Hashtags)
    else
        cb(nil)
    end
end)

RegisterNUICallback('GetHashtags-dark', function(data, cb)
    if PhoneData.Hashtags_dark ~= nil and next(PhoneData.Hashtags_dark) ~= nil then
        cb(PhoneData.Hashtags_dark)
    else
        cb(nil)
    end
end)

RegisterNUICallback('FetchSearchResults', function(data, cb)
    MRFW.Functions.TriggerCallback('mr-phone:server:FetchResult', function(result)
        cb(result)
    end, data.input)
end)

RegisterNUICallback('InstallApplication', function(data, cb)
    local ApplicationData = Config.StoreApps[data.app]
    -- local NewSlot = GetFirstAvailableSlot()
     local NewSlot = 28

    if not CanDownloadApps then
        return
    end

    if NewSlot <= Config.MaxSlots then
        TriggerServerEvent('mr-phone:server:InstallApplication', {
            app = data.app,
        })
        cb({
            app = data.app,
            data = ApplicationData
        })
    else
        cb(false)
    end
end)

RegisterNUICallback('RemoveApplication', function(data, cb)
    TriggerServerEvent('mr-phone:server:RemoveInstallation', data.app)
end)

RegisterNUICallback('GetTruckerData', function(data, cb)
    local TruckerMeta = MRFW.Functions.GetPlayerData().metadata["jobrep"]["trucker"]
    local TierData = exports['mr-trucker']:GetTier(TruckerMeta)
    cb(TierData)
end)

RegisterNUICallback('GetGalleryData', function(data, cb)
    local data = PhoneData.Images
    cb(data)
end)

RegisterNUICallback('DeleteImage', function(image,cb)
    TriggerServerEvent('mr-phone:server:RemoveImageFromGallery',image)
    Wait(400)
    TriggerServerEvent('mr-phone:server:getImageFromGallery')
    cb(true)
end)

RegisterNUICallback('gps-vehicle-garage', function(data, cb)
local veh = data.veh
if findVehFromPlateAndLocate(veh.plate) then
    MRFW.Functions.Notify("Your vehicle has been marked", "success")
else
    MRFW.Functions.Notify("This vehicle cannot be located", "error")
end
end)

RegisterNUICallback('DeleteContact', function(data, cb)
    local Name = data.CurrentContactName
    local Number = data.CurrentContactNumber
    local Account = data.CurrentContactIban

    for k, v in pairs(PhoneData.Contacts) do
        if v.name == Name and v.number == Number then
            table.remove(PhoneData.Contacts, k)
                TriggerServerEvent("InteractSound_SV:PlayOnSource", "vtexts", 0.4)
                SendNUIMessage({
                    action = "PhoneNotification",
                    PhoneNotify = {
                        title = "Phone",
                        text = "Contact deleted!",
                        icon = "fa fa-phone-alt",
                        color = "#04b543",
                        timeout = 1500,
                    },
                })
            break
        end
    end
    Wait(100)
    cb(PhoneData.Contacts)
    if PhoneData.Chats[Number] ~= nil and next(PhoneData.Chats[Number]) ~= nil then
        PhoneData.Chats[Number].name = Number
    end
    TriggerServerEvent('mr-phone:server:RemoveContact', Name, Number)
end)

RegisterNUICallback('GetCryptoData', function(data, cb)
    MRFW.Functions.TriggerCallback('mr-crypto:server:GetCryptoData', function(CryptoData)
        cb(CryptoData)
    end, data.crypto)
end)

RegisterNUICallback('BuyCrypto', function(data, cb)
    MRFW.Functions.TriggerCallback('mr-crypto:server:BuyCrypto', function(CryptoData)
        cb(CryptoData)
    end, data)
end)

RegisterNUICallback('SellCrypto', function(data, cb)
    MRFW.Functions.TriggerCallback('mr-crypto:server:SellCrypto', function(CryptoData)
        cb(CryptoData)
    end, data)
end)

RegisterNUICallback('TransferCrypto', function(data, cb)
    MRFW.Functions.TriggerCallback('mr-crypto:server:TransferCrypto', function(CryptoData)
        cb(CryptoData)
    end, data)
end)

RegisterNUICallback('GetCryptoTransactions', function(data, cb)
    local Data = {
        CryptoTransactions = PhoneData.CryptoTransactions
    }
    cb(Data)
end)

RegisterNUICallback('GetAvailableRaces', function(data, cb)
    MRFW.Functions.TriggerCallback('mr-lapraces:server:GetRaces', function(Races)
        cb(Races)
    end)
end)

RegisterNUICallback('JoinRace', function(data)
    TriggerServerEvent('mr-lapraces:server:JoinRace', data.RaceData)
end)

RegisterNUICallback('LeaveRace', function(data)
    TriggerServerEvent('mr-lapraces:server:LeaveRace', data.RaceData)
end)

RegisterNUICallback('StartRace', function(data)
    TriggerServerEvent('mr-lapraces:server:StartRace', data.RaceData.RaceId)
end)

RegisterNUICallback('SetAlertWaypoint', function(data)
    local coords = data.alert.coords
    MRFW.Functions.Notify('GPS set: '..data.alert.title)
    SetNewWaypoint(coords.x, coords.y)
end)

RegisterNUICallback('RemoveSuggestion', function(data, cb)
    local data = data.data
    if PhoneData.SuggestedContacts ~= nil and next(PhoneData.SuggestedContacts) ~= nil then
        for k, v in pairs(PhoneData.SuggestedContacts) do
            if (data.name[1] == v.name[1] and data.name[2] == v.name[2]) and data.number == v.number and data.bank == v.bank then
                table.remove(PhoneData.SuggestedContacts, k)
            end
        end
    end
end)

RegisterNUICallback('FetchVehicleResults', function(data, cb)
    MRFW.Functions.TriggerCallback('mr-phone:server:GetVehicleSearchResults', function(result)
        if result ~= nil then
            for k, v in pairs(result) do
                MRFW.Functions.TriggerCallback('police:IsPlateFlagged', function(flagged)
                    result[k].isFlagged = flagged
                end, result[k].plate)
                Wait(50)
            end
        end
        cb(result)
    end, data.input)
end)

RegisterNUICallback('FetchVehicleScan', function(data, cb)
    local vehicle = MRFW.Functions.GetClosestVehicle()
    local plate = MRFW.Functions.GetPlate(vehicle)
    local vehname = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)):lower()
    MRFW.Functions.TriggerCallback('mr-phone:server:ScanPlate', function(result)
        MRFW.Functions.TriggerCallback('police:IsPlateFlagged', function(flagged)
            result.isFlagged = flagged
	    if MRFW.Shared.Vehicles[vehname] ~= nil then
                result.label = MRFW.Shared.Vehicles[vehname]['name']
            else
                result.label = 'Unknown brand..'
            end
            cb(result)
        end, plate)
    end, plate)
end)

RegisterNUICallback('GetRaces', function(data, cb)
    MRFW.Functions.TriggerCallback('mr-lapraces:server:GetListedRaces', function(Races)
        cb(Races)
    end)
end)

RegisterNUICallback('GetTrackData', function(data, cb)
    MRFW.Functions.TriggerCallback('mr-lapraces:server:GetTrackData', function(TrackData, CreatorData)
        TrackData.CreatorData = CreatorData
        cb(TrackData)
    end, data.RaceId)
end)

RegisterNUICallback('SetupRace', function(data, cb)
    TriggerServerEvent('mr-lapraces:server:SetupRace', data.RaceId, tonumber(data.AmountOfLaps))
end)

RegisterNUICallback('HasCreatedRace', function(data, cb)
    MRFW.Functions.TriggerCallback('mr-lapraces:server:HasCreatedRace', function(HasCreated)
        cb(HasCreated)
    end)
end)

RegisterNUICallback('IsInRace', function(data, cb)
    local InRace = exports['mr-lapraces']:IsInRace()
    cb(InRace)
end)

RegisterNUICallback('IsAuthorizedToCreateRaces', function(data, cb)
    MRFW.Functions.TriggerCallback('mr-lapraces:server:IsAuthorizedToCreateRaces', function(IsAuthorized, NameAvailable)
        local data = {
            IsAuthorized = IsAuthorized,
            IsBusy = exports['mr-lapraces']:IsInEditor(),
            IsNameAvailable = NameAvailable,
        }
        cb(data)
    end, data.TrackName)
end)

RegisterNUICallback('StartTrackEditor', function(data, cb)
    TriggerServerEvent('mr-lapraces:server:CreateLapRace', data.TrackName)
end)

RegisterNUICallback('GetRacingLeaderboards', function(data, cb)
    MRFW.Functions.TriggerCallback('mr-lapraces:server:GetRacingLeaderboards', function(Races)
        cb(Races)
    end)
end)

RegisterNUICallback('RaceDistanceCheck', function(data, cb)
    MRFW.Functions.TriggerCallback('mr-lapraces:server:GetRacingData', function(RaceData)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local checkpointcoords = RaceData.Checkpoints[1].coords
        local dist = #(coords - vector3(checkpointcoords.x, checkpointcoords.y, checkpointcoords.z))
        if dist <= 115.0 then
            if data.Joined then
                TriggerEvent('mr-lapraces:client:WaitingDistanceCheck')
            end
            cb(true)
        else
            MRFW.Functions.Notify('You\'re too far away from the race. GPS set.', 'error', 5000)
            SetNewWaypoint(checkpointcoords.x, checkpointcoords.y)
            cb(false)
        end
    end, data.RaceId)
end)

RegisterNUICallback('IsBusyCheck', function(data, cb)
    if data.check == "editor" then
        cb(exports['mr-lapraces']:IsInEditor())
    else
        cb(exports['mr-lapraces']:IsInRace())
    end
end)

RegisterNUICallback('CanRaceSetup', function(data, cb)
    MRFW.Functions.TriggerCallback('mr-lapraces:server:CanRaceSetup', function(CanSetup)
        cb(CanSetup)
    end)
end)

RegisterNUICallback('GetPlayerHouses', function(data, cb)
    MRFW.Functions.TriggerCallback('mr-phone:server:GetPlayerHouses', function(Houses)
        cb(Houses)
    end)
end)

RegisterNUICallback('GetPlayerKeys', function(data, cb)
    MRFW.Functions.TriggerCallback('mr-phone:server:GetHouseKeys', function(Keys)
        cb(Keys)
    end)
end)

RegisterNUICallback('SetHouseLocation', function(data, cb)
    SetNewWaypoint(data.HouseData.HouseData.coords.enter.x, data.HouseData.HouseData.coords.enter.y)
    MRFW.Functions.Notify("GPS set to " .. data.HouseData.HouseData.adress .. "!", "success")
end)

RegisterNUICallback('RemoveKeyholder', function(data)
    TriggerServerEvent('mr-houses:server:removeHouseKey', data.HouseData.name, {
        citizenid = data.HolderData.citizenid,
        firstname = data.HolderData.charinfo.firstname,
        lastname = data.HolderData.charinfo.lastname,
    })
end)

RegisterNUICallback('TransferCid', function(data, cb)
    local TransferedCid = data.newBsn

    MRFW.Functions.TriggerCallback('mr-phone:server:TransferCid', function(CanTransfer)
        cb(CanTransfer)
    end, TransferedCid, data.HouseData)
end)

RegisterNUICallback('FetchPlayerHouses', function(data, cb)
    MRFW.Functions.TriggerCallback('mr-phone:server:MeosGetPlayerHouses', function(result)
        cb(result)
    end, data.input)
end)

RegisterNUICallback('SetGPSLocation', function(data, cb)
    local ped = PlayerPedId()

    SetNewWaypoint(data.coords.x, data.coords.y)
    MRFW.Functions.Notify('GPS set!', 'success')
end)

RegisterNUICallback('SetApartmentLocation', function(data, cb)
    local ApartmentData = data.data.appartmentdata
    local TypeData = Apartments.Locations[ApartmentData.type]

    SetNewWaypoint(TypeData.coords.enter.x, TypeData.coords.enter.y)
    MRFW.Functions.Notify('GPS set!', 'success')
end)

RegisterNUICallback('GetCurrentLawyers', function(data, cb)
    MRFW.Functions.TriggerCallback('mr-phone:server:GetCurrentLawyers', function(lawyers)
        cb(lawyers)
    end)
end)

RegisterNUICallback('SetupStoreApps', function(data, cb)
    local PlayerData = MRFW.Functions.GetPlayerData()
    local data = {
        StoreApps = Config.StoreApps,
        PhoneData = PlayerData.metadata["phonedata"]
    }
    cb(data)
end)

RegisterNUICallback('ClearMentions', function()
    Config.PhoneApplications["twitter"].Alerts = 0
    SendNUIMessage({
        action = "RefreshAppAlerts",
        AppData = Config.PhoneApplications
    })
    TriggerServerEvent('mr-phone:server:SetPhoneAlerts', "twitter", 0)
    SendNUIMessage({ action = "RefreshAppAlerts", AppData = Config.PhoneApplications })
end)

RegisterNUICallback('ClearMentions-dark', function()
    Config.PhoneApplications["darkweb"].Alerts = 0
    SendNUIMessage({
        action = "RefreshAppAlerts",
        AppData = Config.PhoneApplications
    })
    TriggerServerEvent('mr-phone:server:SetPhoneAlerts', "darkweb", 0)
    SendNUIMessage({ action = "RefreshAppAlerts", AppData = Config.PhoneApplications })
end)

RegisterNUICallback('ClearGeneralAlerts', function(data)
    SetTimeout(400, function()
        Config.PhoneApplications[data.app].Alerts = 0
        SendNUIMessage({
            action = "RefreshAppAlerts",
            AppData = Config.PhoneApplications
        })
        TriggerServerEvent('mr-phone:server:SetPhoneAlerts', data.app, 0)
        SendNUIMessage({ action = "RefreshAppAlerts", AppData = Config.PhoneApplications })
    end)
end)

RegisterNUICallback('TransferMoney', function(data, cb)
    data.amount = tonumber(data.amount)
    if tonumber(PhoneData.PlayerData.money.bank) >= data.amount then
        local amaountata = PhoneData.PlayerData.money.bank - data.amount
        TriggerServerEvent('mr-phone:server:TransferMoney', data.iban, data.amount)
        local cbdata = {
            CanTransfer = true,
            NewAmount = amaountata
        }
        cb(cbdata)
    else
        local cbdata = {
            CanTransfer = false,
            NewAmount = nil,
        }
        cb(cbdata)
    end
end)

RegisterNUICallback('CanTransferMoney', function(data, cb)
    local amount = tonumber(data.amountOf)
    local iban = data.sendTo
    local PlayerData = MRFW.Functions.GetPlayerData()

    if (PlayerData.money.bank - amount) >= 0 then
        MRFW.Functions.TriggerCallback('mr-phone:server:CanTransferMoney', function(Transferd)
            if Transferd then
                cb({TransferedMoney = true, NewBalance = (PlayerData.money.bank - amount)})
            else
		SendNUIMessage({ action = "PhoneNotification", PhoneNotify = { timeout=3000, title = "Bank", text = "Account does not exist!", icon = "fas fa-university", color = "#ff0000", }, })
                cb({TransferedMoney = false})
            end
        end, amount, iban)
    else
        cb({TransferedMoney = false})
    end
end)

RegisterNUICallback('GetWhatsappChats', function(data, cb)
    MRFW.Functions.TriggerCallback('mr-phone:server:GetContactPictures', function(Chats)
        cb(Chats)
    end, PhoneData.Chats)
end)

RegisterNUICallback('CallContact', function(data, cb)
    MRFW.Functions.TriggerCallback('mr-phone:server:GetCallState', function(CanCall, IsOnline, contactData)
        local status = {
            CanCall = CanCall,
            IsOnline = IsOnline,
            InCall = PhoneData.CallData.InCall,
        }
        cb(status)
        if CanCall and not status.InCall and (data.ContactData.number ~= PhoneData.PlayerData.charinfo.phone) then
            CallContact(data.ContactData, data.Anonymous)
        end
    end, data.ContactData)
end)

RegisterNUICallback('SendMessage', function(data, cb)
    local ChatMessage = data.ChatMessage
    local ChatDate = data.ChatDate
    local ChatNumber = data.ChatNumber
    local ChatTime = data.ChatTime
    local ChatType = data.ChatType
    local Ped = PlayerPedId()
    local Pos = GetEntityCoords(Ped)
    local NumberKey = GetKeyByNumber(ChatNumber)
    local ChatKey = GetKeyByDate(NumberKey, ChatDate)
    if PhoneData.Chats[NumberKey] ~= nil then
        if(PhoneData.Chats[NumberKey].messages == nil) then
            PhoneData.Chats[NumberKey].messages = {}
        end
        if PhoneData.Chats[NumberKey].messages[ChatKey] ~= nil then
            if ChatType == "message" then
                PhoneData.Chats[NumberKey].messages[ChatKey].messages[#PhoneData.Chats[NumberKey].messages[ChatKey].messages+1] = {
                    message = ChatMessage,
                    time = ChatTime,
                    sender = PhoneData.PlayerData.citizenid,
                    type = ChatType,
                    data = {},
                }
            elseif ChatType == "location" then
                PhoneData.Chats[NumberKey].messages[ChatKey].messages[#PhoneData.Chats[NumberKey].messages[ChatKey].messages+1] = {
                    message = "Shared Location",
                    time = ChatTime,
                    sender = PhoneData.PlayerData.citizenid,
                    type = ChatType,
                    data = {
                        x = Pos.x,
                        y = Pos.y,
                    },
                }
            elseif ChatType == "picture" then
                PhoneData.Chats[NumberKey].messages[ChatKey].messages[#PhoneData.Chats[NumberKey].messages[ChatKey].messages+1] = {
                    message = "Photo",
                    time = ChatTime,
                    sender = PhoneData.PlayerData.citizenid,
                    type = ChatType,
                    data = {
                        url = data.url
                    },
                }
            end
            TriggerServerEvent('mr-phone:server:UpdateMessages', PhoneData.Chats[NumberKey].messages, ChatNumber, false)
            NumberKey = GetKeyByNumber(ChatNumber)
            ReorganizeChats(NumberKey)
        else
            PhoneData.Chats[NumberKey].messages[#PhoneData.Chats[NumberKey].messages+1] = {
                date = ChatDate,
                messages = {},
            }
            ChatKey = GetKeyByDate(NumberKey, ChatDate)
            if ChatType == "message" then
                PhoneData.Chats[NumberKey].messages[ChatKey].messages[#PhoneData.Chats[NumberKey].messages[ChatKey].messages+1] = {
                    message = ChatMessage,
                    time = ChatTime,
                    sender = PhoneData.PlayerData.citizenid,
                    type = ChatType,
                    data = {},
                }
            elseif ChatType == "location" then
                PhoneData.Chats[NumberKey].messages[ChatDate].messages[#PhoneData.Chats[NumberKey].messages[ChatDate].messages+1] = {
                    message = "Shared Location",
                    time = ChatTime,
                    sender = PhoneData.PlayerData.citizenid,
                    type = ChatType,
                    data = {
                        x = Pos.x,
                        y = Pos.y,
                    },
                }
            elseif ChatType == "picture" then
                PhoneData.Chats[NumberKey].messages[ChatKey].messages[#PhoneData.Chats[NumberKey].messages[ChatKey].messages+1] = {
                    message = "Photo",
                    time = ChatTime,
                    sender = PhoneData.PlayerData.citizenid,
                    type = ChatType,
                    data = {
                        url = data.url
                    },
                }
            end
            TriggerServerEvent('mr-phone:server:UpdateMessages', PhoneData.Chats[NumberKey].messages, ChatNumber, true)
            NumberKey = GetKeyByNumber(ChatNumber)
            ReorganizeChats(NumberKey)
        end
    else
        PhoneData.Chats[#PhoneData.Chats+1] = {
            name = IsNumberInContacts(ChatNumber),
            number = ChatNumber,
            messages = {},
        }
        NumberKey = GetKeyByNumber(ChatNumber)
        PhoneData.Chats[NumberKey].messages[#PhoneData.Chats[NumberKey].messages+1] = {
            date = ChatDate,
            messages = {},
        }
        ChatKey = GetKeyByDate(NumberKey, ChatDate)
        if ChatType == "message" then
            PhoneData.Chats[NumberKey].messages[ChatKey].messages[#PhoneData.Chats[NumberKey].messages[ChatKey].messages+1] = {
                message = ChatMessage,
                time = ChatTime,
                sender = PhoneData.PlayerData.citizenid,
                type = ChatType,
                data = {},
            }
        elseif ChatType == "location" then
            PhoneData.Chats[NumberKey].messages[ChatKey].messages[#PhoneData.Chats[NumberKey].messages[ChatKey].messages+1] = {
                message = "Shared Location",
                time = ChatTime,
                sender = PhoneData.PlayerData.citizenid,
                type = ChatType,
                data = {
                    x = Pos.x,
                    y = Pos.y,
                },
            }
        elseif ChatType == "picture" then
            PhoneData.Chats[NumberKey].messages[ChatKey].messages[#PhoneData.Chats[NumberKey].messages[ChatKey].messages+1] = {
                message = "Photo",
                time = ChatTime,
                sender = PhoneData.PlayerData.citizenid,
                type = ChatType,
                data = {
                    url = data.url
                },
            }
        end
        TriggerServerEvent('mr-phone:server:UpdateMessages', PhoneData.Chats[NumberKey].messages, ChatNumber, true)
        NumberKey = GetKeyByNumber(ChatNumber)
        ReorganizeChats(NumberKey)
    end

    MRFW.Functions.TriggerCallback('mr-phone:server:GetContactPicture', function(Chat)
        SendNUIMessage({
            action = "UpdateChat",
            chatData = Chat,
            chatNumber = ChatNumber,
        })
    end,  PhoneData.Chats[GetKeyByNumber(ChatNumber)])
end)

RegisterNUICallback("TakePhoto", function(data,cb)
    SetNuiFocus(false, false)
    CreateMobilePhone(1)
    CellCamActivate(true, true)
    TriggerEvent('hud:client:hide', true)
    takePhoto = true
    while takePhoto do
        if IsControlJustPressed(1, 27) then
            frontCam = not frontCam
            CellFrontCamActivate(frontCam)
        elseif IsControlJustPressed(1, 177) then
            DestroyMobilePhone()
            CellCamActivate(false, false)
            TriggerEvent('hud:client:hide', false)
            cb(json.encode({ url = nil }))
            OpenPhone()
            takePhoto = false
            break
        elseif IsControlJustPressed(1, 176) then
            MRFW.Functions.TriggerCallback("mr-phone:server:GetWebhook",function(hook)
                MRFW.Functions.Notify('Touching up photo...', 'primary')
                exports['screenshot-basic']:requestScreenshotUpload(tostring(hook), "files[]", function(data)
                    local image = json.decode(data)
                    DestroyMobilePhone()
                    CellCamActivate(false, false)
                    TriggerEvent('hud:client:hide', false)
                    TriggerServerEvent('mr-phone:server:addImageToGallery', image.attachments[1].proxy_url)
                    Wait(400)
                    TriggerServerEvent('mr-phone:server:getImageFromGallery')
                    cb(json.encode(image.attachments[1].proxy_url))
                    MRFW.Functions.Notify('Photo ssaved!', 'success')
                    OpenPhone()
                end)
            end)

            takePhoto = false
        end
          HideHudComponentThisFrame(7)
          HideHudComponentThisFrame(8)
          HideHudComponentThisFrame(9)
          HideHudComponentThisFrame(6)
          HideHudComponentThisFrame(19)
          HideHudAndRadarThisFrame()
          EnableAllControlActions(0)
          Wait(0)
    end
end)

-- Handler Events

RegisterNetEvent('MRFW:Client:OnPlayerLoaded', function()
    LoadPhone()
end)

RegisterNetEvent('MRFW:Client:OnPlayerUnload', function()
    PhoneData = {
        MetaData = {},
        isOpen = false,
        PlayerData = nil,
        Contacts = {},
        Tweets = {},
        MentionedTweets = {},
        Hashtags = {},
        Chats = {},
        Invoices = {},
        CallData = {},
        RecentCalls = {},
        Garage = {},
        Mails = {},
        Adverts = {},
        GarageVehicles = {},
        AnimationData = {
            lib = nil,
            anim = nil,
        },
        SuggestedContacts = {},
        CryptoTransactions = {},
    }
    if VPNopen then
        VPNopen = false
        attempts = 1
        MRFW.Functions.Notify('VPN: Logout', 'error', 5000)
    end
end)

RegisterNetEvent('MRFW:Client:OnJobUpdate', function(JobInfo)
    SendNUIMessage({
        action = "UpdateApplications",
        JobData = JobInfo,
        applications = Config.PhoneApplications
    })

    PlayerJob = JobInfo
end)

-- Events

RegisterNetEvent('mr-phone:client:TransferMoney', function(amount, newmoney)
    PhoneData.PlayerData.money.bank = newmoney
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "vtexts", 0.4)
    SendNUIMessage({ action = "PhoneNotification", PhoneNotify = { title = "Bank", text = "&#36;"..amount.." added to your account!", icon = "fas fa-university", color = "#8c7ae6", }, })
    SendNUIMessage({ action = "UpdateBank", NewBalance = PhoneData.PlayerData.money.bank })
end)

RegisterNetEvent('mr-phone:client:UpdateTweets', function(src, Tweets, NewTweetData, delete)
    PhoneData.Tweets = Tweets
    local MyPlayerId = PhoneData.PlayerData.source
    if not delete then 
        if src ~= MyPlayerId then
            TriggerServerEvent("InteractSound_SV:PlayOnSource", "vtexts", 0.4)
            SendNUIMessage({
                action = "PhoneNotification",
                PhoneNotify = {
                    title = "New Tweet: (@"..NewTweetData.firstName.." "..NewTweetData.lastName..")",
                    text = NewTweetData.message,
                    icon = "fab fa-twitter",
                    color = "#1DA1F2",
                },
            })
            SendNUIMessage({
                action = "UpdateTweets",
                Tweets = PhoneData.Tweets
            })
        else
            TriggerServerEvent("InteractSound_SV:PlayOnSource", "vtexts", 0.4)
            SendNUIMessage({
                action = "PhoneNotification",
                PhoneNotify = {
                    title = "Twitter",
                    text = "Tweet posted!",
                    icon = "fab fa-twitter",
                    color = "#1DA1F2",
                    timeout = 1000,
                },
            })
        end
    else
        if src == MyPlayerId then
            SendNUIMessage({
                action = "PhoneNotification",
                PhoneNotify = {
                    title = "Twitter",
                    text = "Tweet deleted!",
                    icon = "fab fa-twitter",
                    color = "#1DA1F2",
                    timeout = 1000,
                },
            })
        end
        SendNUIMessage({
            action = "UpdateTweets",
            Tweets = PhoneData.Tweets
        })
    end
end)

RegisterNetEvent('mr-phone:client:UpdateAnons', function(src, Anons, NewAnonData, delete)
    PhoneData.Anons = Anons
    local MyPlayerId = PhoneData.PlayerData.source
    -- local hasVPN = MRFW.Functions.HasItem(Config.VPN)
    local hasVPN = true
    if PhoneData.PlayerData.job.name ~= 'police' and PhoneData.PlayerData.job.name ~= 'doctor' and PhoneData.PlayerData.job.name ~= 'government' and PhoneData.PlayerData.job.name ~= 'doj' then
        if not delete then -- New Tweet
            if src ~= MyPlayerId then
                if VPNopen then
                    TriggerServerEvent("InteractSound_SV:PlayOnSource", "vtexts", 0.4)
                    SendNUIMessage({
                        action = "PhoneNotification",
                        PhoneNotify = {
                            title = "New Anon (@Anon"..NewAnonData.anonym..")",
                            text = NewAnonData.message,
                            icon = "fas fa-hat-cowboy",
                            color = "#1DA1F2",
                        },
                    })
                    TriggerServerEvent("InteractSound_SV:PlayOnSource", "vtexts", 0.4)
                end
                SendNUIMessage({
                    action = "UpdateAnons",
                    Anons = PhoneData.Anons
                })
            else
                if VPNopen then
                    SendNUIMessage({
                        action = "PhoneNotification",
                        PhoneNotify = {
                            title = "Darkweb",
                            text = "The Anon has been posted!",
                            icon = "fas fa-hat-cowboy",
                            color = "#1DA1F2",
                            timeout = 1000,
                        },
                    })
                end
            end
        else -- Deleting a tweet
            if src == MyPlayerId then
                if VPNopen then
                    SendNUIMessage({
                        action = "PhoneNotification",
                        PhoneNotify = {
                            title = "Darkweb",
                            text = "The Anon has been deleted!",
                            icon = "fas fa-hat-cowboy",
                            color = "#1DA1F2",
                            timeout = 1000,
                        },
                    })
                end
            end
            SendNUIMessage({
                action = "UpdateAnons",
                Anons = PhoneData.Anons
            })
        end
    end
end)

RegisterNetEvent('mr-phone:client:RaceNotify', function(message)
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "vtexts", 0.4)
    SendNUIMessage({
        action = "PhoneNotification",
        PhoneNotify = {
            title = "Racing",
            text = message,
            icon = "fas fa-flag-checkered",
            color = "#353b48",
            timeout = 3500,
        },
    })
end)

RegisterNetEvent('mr-phone:client:AddRecentCall', function(data, time, type)
    PhoneData.RecentCalls[#PhoneData.RecentCalls+1] = {
        name = IsNumberInContacts(data.number),
        time = time,
        type = type,
        number = data.number,
        anonymous = data.anonymous
    }
    TriggerServerEvent('mr-phone:server:SetPhoneAlerts', "phone")
    Config.PhoneApplications["phone"].Alerts = Config.PhoneApplications["phone"].Alerts + 1
    SendNUIMessage({
        action = "RefreshAppAlerts",
        AppData = Config.PhoneApplications
    })
end)

RegisterNetEvent("mr-phone-new:client:BankNotify", function(text)
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "vtexts", 0.4)
    SendNUIMessage({
        action = "PhoneNotification",
        NotifyData = {
            title = "Bank",
            content = text,
            icon = "fas fa-university",
            timeout = 3500,
            color = "#ff002f",
        },
    })
end)

RegisterNetEvent('mr-phone:client:NewMailNotify', function(MailData)
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "vtexts", 0.4)
    SendNUIMessage({
        action = "PhoneNotification",
        PhoneNotify = {
            title = "Mail",
            text = "New E-Mail from: "..MailData.sender,
            icon = "fas fa-envelope",
            color = "#ff002f",
            timeout = 1500,
        },
    })
    Config.PhoneApplications['mail'].Alerts = Config.PhoneApplications['mail'].Alerts + 1
    TriggerServerEvent('mr-phone:server:SetPhoneAlerts', "mail")
end)

RegisterNetEvent('mr-phone:client:UpdateMails', function(NewMails)
    SendNUIMessage({
        action = "UpdateMails",
        Mails = NewMails
    })
    PhoneData.Mails = NewMails
end)
RegisterNetEvent('mr-phone:client:sendNewMail',function(data)TriggerServerEvent('mr-phone:server:sendNewMail',data)end)
RegisterNetEvent('mr-phone:client:UpdateAdvertsDel', function(Adverts)
    PhoneData.Adverts = Adverts
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "vtexts", 0.4)
    SendNUIMessage({
        action = "RefreshAdverts",
        Adverts = PhoneData.Adverts
    })
end)

RegisterNetEvent('mr-phone:client:UpdateAdverts', function(Adverts, LastAd)
    PhoneData.Adverts = Adverts
    SendNUIMessage({
        action = "PhoneNotification",
        PhoneNotify = {
            title = "Advertisement",
            text = "New ad posted: "..LastAd,
            icon = "fas fa-ad",
            color = "#ff8f1a",
            timeout = 2500,
        },
    })
    SendNUIMessage({
        action = "RefreshAdverts",
        Adverts = PhoneData.Adverts
    })
end)

RegisterNetEvent('mr-phone:client:BillingEmail', function(data, paid, name)
    if paid then
        TriggerServerEvent('mr-phone:server:sendNewMail', {
            sender = 'Billing Department',
            subject = 'Invoice Paid',
            message = 'Invoice Has Been Paid From '..name..' In The Amount Of $'..data.amount,
        })
    else
        TriggerServerEvent('mr-phone:server:sendNewMail', {
            sender = 'Billing Department',
            subject = 'Invoice Declined',
            message = 'Invoice Has Been Declined From '..name..' In The Amount Of $'..data.amount,
        })
    end
end)

RegisterNetEvent('mr-phone:client:CancelCall', function()
    if PhoneData.CallData.CallType == "ongoing" then
        SendNUIMessage({
            action = "CancelOngoingCall"
        })
        exports['pma-voice']:removePlayerFromCall(PhoneData.CallData.CallId)
    end
    PhoneData.CallData.CallType = nil
    PhoneData.CallData.InCall = false
    PhoneData.CallData.AnsweredCall = false
    PhoneData.CallData.TargetData = {}

    if not PhoneData.isOpen then
        StopAnimTask(PlayerPedId(), PhoneData.AnimationData.lib, PhoneData.AnimationData.anim, 2.5)
        deletePhone()
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
    else
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
    end

    TriggerServerEvent('mr-phone:server:SetCallState', false)
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "demo", 0.0)

    if not PhoneData.isOpen then
        SendNUIMessage({
            action = "PhoneNotification",
            NotifyData = {
                title = "Phone",
                content = "Call ended",
                icon = "fas fa-phone",
                timeout = 3500,
                color = "#e84118",
            },
        })
    else
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Phone",
                text = "Call ended",
                icon = "fas fa-phone",
                color = "#e84118",
            },
        })

        SendNUIMessage({
            action = "SetupHomeCall",
            CallData = PhoneData.CallData,
        })

        SendNUIMessage({
            action = "CancelOutgoingCall",
        })
    end
end)

RegisterNUICallback('phone-silent-button', function(data,cb)
    if CallVolume == tonumber("0.2") then
        CallVolume = 0
        MRFW.Functions.Notify("Silent Mode On", "success")
        cb(true)
    else
        CallVolume = 0.2
        MRFW.Functions.Notify("Silent Mode Off", "error")
        cb(false)
    end
end)

RegisterNetEvent('mr-phone:client:GetCalled', function(CallerNumber, CallId, AnonymousCall)
    local RepeatCount = 0
    local CallData = {
        number = CallerNumber,
        name = IsNumberInContacts(CallerNumber),
        anonymous = AnonymousCall
    }

    if AnonymousCall then
        CallData.name = "Anonymous"
    end

    PhoneData.CallData.CallType = "incoming"
    PhoneData.CallData.InCall = true
    PhoneData.CallData.AnsweredCall = false
    PhoneData.CallData.TargetData = CallData
    PhoneData.CallData.CallId = CallId

    TriggerServerEvent('mr-phone:server:SetCallState', true)

    SendNUIMessage({
        action = "SetupHomeCall",
        CallData = PhoneData.CallData,
    })

    for i = 1, Config.CallRepeats + 1, 1 do
        if not PhoneData.CallData.AnsweredCall then
            if RepeatCount + 1 ~= Config.CallRepeats + 1 then
                if PhoneData.CallData.InCall then
                    MRFW.Functions.TriggerCallback('mr-phone:server:HasPhone', function(HasPhone)
                        if HasPhone then
                            RepeatCount = RepeatCount + 1
                            TriggerServerEvent("InteractSound_SV:PlayOnSource", "ringing", CallVolume)

                            if not PhoneData.isOpen then
                                SendNUIMessage({
                                    action = "IncomingCallAlert",
                                    CallData = PhoneData.CallData.TargetData,
                                    Canceled = false,
                                    AnonymousCall = AnonymousCall,
                                })
                            end
                        end
                    end)
                else
                    SendNUIMessage({
                        action = "IncomingCallAlert",
                        CallData = PhoneData.CallData.TargetData,
                        Canceled = true,
                        AnonymousCall = AnonymousCall,
                    })
                    TriggerServerEvent('mr-phone:server:AddRecentCall', "missed", CallData)
                    break
                end
                Wait(Config.RepeatTimeout)
            else
                SendNUIMessage({
                    action = "IncomingCallAlert",
                    CallData = PhoneData.CallData.TargetData,
                    Canceled = true,
                    AnonymousCall = AnonymousCall,
                })
                TriggerServerEvent('mr-phone:server:AddRecentCall', "missed", CallData)
                break
            end
        else
            TriggerServerEvent('mr-phone:server:AddRecentCall', "missed", CallData)
            break
        end
    end
end)

RegisterNetEvent('mr-phone:client:UpdateMessages', function(ChatMessages, SenderNumber, New)
    local NumberKey = GetKeyByNumber(SenderNumber)

    if New then
	    PhoneData.Chats[#PhoneData.Chats+1] = {
            name = IsNumberInContacts(SenderNumber),
            number = SenderNumber,
            messages = {},
        }

        NumberKey = GetKeyByNumber(SenderNumber)

        PhoneData.Chats[NumberKey] = {
            name = IsNumberInContacts(SenderNumber),
            number = SenderNumber,
            messages = ChatMessages
        }

        if PhoneData.Chats[NumberKey].Unread ~= nil then
            PhoneData.Chats[NumberKey].Unread = PhoneData.Chats[NumberKey].Unread + 1
        else
            PhoneData.Chats[NumberKey].Unread = 1
        end

        if PhoneData.isOpen then
            if SenderNumber ~= PhoneData.PlayerData.charinfo.phone then
                TriggerServerEvent("InteractSound_SV:PlayOnSource", "vtexts", 0.4)
                SendNUIMessage({
                    action = "PhoneNotification",
                    PhoneNotify = {
                        title = "Messages",
                        text = "New message: "..IsNumberInContacts(SenderNumber),
                        icon = "fas fa-comment",
                        color = "#25D366",
                        timeout = 1500,
                    },
                })
            else
                TriggerServerEvent("InteractSound_SV:PlayOnSource", "vtexts", 0.4)
                SendNUIMessage({
                    action = "PhoneNotification",
                    PhoneNotify = {
                        title = "Messages",
                        text = "Messaged yourself?",
                        icon = "fas fa-comment",
                        color = "#25D366",
                        timeout = 4000,
                    },
                })
            end

            NumberKey = GetKeyByNumber(SenderNumber)
            ReorganizeChats(NumberKey)

            Wait(100)
            MRFW.Functions.TriggerCallback('mr-phone:server:GetContactPictures', function(Chats)
                SendNUIMessage({
                    action = "UpdateChat",
                    chatData = Chats[GetKeyByNumber(SenderNumber)],
                    chatNumber = SenderNumber,
                    Chats = Chats,
                })
            end,  PhoneData.Chats)
        else
            TriggerServerEvent("InteractSound_SV:PlayOnSource", "vtexts", 0.4)
            SendNUIMessage({
	        action = "PhoneNotification",
	        PhoneNotify = {
		    title = "Messages",
		    text = "New message: "..IsNumberInContacts(SenderNumber),
		    icon = "fas fa-comment",
		    color = "#25D366",
		    timeout = 3500,
	        },
	    })
            Config.PhoneApplications['whatsapp'].Alerts = Config.PhoneApplications['whatsapp'].Alerts + 1
            TriggerServerEvent('mr-phone:server:SetPhoneAlerts', "whatsapp")
        end
    else
        PhoneData.Chats[NumberKey].messages = ChatMessages

        if PhoneData.Chats[NumberKey].Unread ~= nil then
            PhoneData.Chats[NumberKey].Unread = PhoneData.Chats[NumberKey].Unread + 1
        else
            PhoneData.Chats[NumberKey].Unread = 1
        end

        if PhoneData.isOpen then
            if SenderNumber ~= PhoneData.PlayerData.charinfo.phone then
                TriggerServerEvent("InteractSound_SV:PlayOnSource", "vtexts", 0.4)
                SendNUIMessage({
                    action = "PhoneNotification",
                    PhoneNotify = {
                        title = "Messages",
                        text = "New message: "..IsNumberInContacts(SenderNumber),
                        icon = "fas fa-comment",
                        color = "#25D366",
                        timeout = 1500,
                    },
                })
            else
                TriggerServerEvent("InteractSound_SV:PlayOnSource", "vtexts", 0.4)
                SendNUIMessage({
                    action = "PhoneNotification",
                    PhoneNotify = {
                        title = "Messages",
                        text = "Messaged yourself?",
                        icon = "fas fa-comment",
                        color = "#25D366",
                        timeout = 4000,
                    },
                })
            end

            NumberKey = GetKeyByNumber(SenderNumber)
            ReorganizeChats(NumberKey)

            Wait(100)
            MRFW.Functions.TriggerCallback('mr-phone:server:GetContactPictures', function(Chats)
                SendNUIMessage({
                    action = "UpdateChat",
                    chatData = Chats[GetKeyByNumber(SenderNumber)],
                    chatNumber = SenderNumber,
                    Chats = Chats,
                })
            end,  PhoneData.Chats)
        else
            TriggerServerEvent("InteractSound_SV:PlayOnSource", "vtexts", 0.4)
            SendNUIMessage({
                action = "PhoneNotification",
                PhoneNotify = {
                    title = "Messages",
                    text = "New message: "..IsNumberInContacts(SenderNumber),
                    icon = "fas fa-comment",
                    color = "#25D366",
                    timeout = 3500,
                },
            })

            NumberKey = GetKeyByNumber(SenderNumber)
            ReorganizeChats(NumberKey)

            Config.PhoneApplications['whatsapp'].Alerts = Config.PhoneApplications['whatsapp'].Alerts + 1
            TriggerServerEvent('mr-phone:server:SetPhoneAlerts', "whatsapp")
        end
    end
end)

RegisterNetEvent('mr-phone:client:RemoveBankMoney', function(amount)
    if amount > 0 then
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "vtexts", 0.4)
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Bank",
                text = "$"..amount.." removed from your balance!",
                icon = "fas fa-university",
                color = "#ff002f",
                timeout = 3500,
            },
        })
    end
end)

RegisterNetEvent('mr-phone:RefreshPhone', function()
    LoadPhone()
    SetTimeout(250, function()
        SendNUIMessage({
            action = "RefreshAlerts",
            AppData = Config.PhoneApplications,
        })
    end)
end)

RegisterNetEvent('mr-phone:client:AddTransaction', function(SenderData, TransactionData, Message, Title)
    local Data = {
        TransactionTitle = Title,
        TransactionMessage = Message,
    }
    PhoneData.CryptoTransactions[#PhoneData.CryptoTransactions+1] = Data
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Crypto",
                text = Message,
                icon = "fab fa-bitcoin",
                color = "#04b543",
                timeout = 1500,
            },
        })
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "vtexts", 0.4)
        SendNUIMessage({
        action = "UpdateTransactions",
        CryptoTransactions = PhoneData.CryptoTransactions
    })

    TriggerServerEvent('mr-phone:server:AddTransaction', Data)
end)

RegisterNetEvent('mr-phone:client:AddNewSuggestion', function(SuggestionData)
    PhoneData.SuggestedContacts[#PhoneData.SuggestedContacts+1] = SuggestionData
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "vtexts", 0.4)
    SendNUIMessage({
        action = "PhoneNotification",
        PhoneNotify = {
            title = "Phone",
            text = "New suggested contact!",
            icon = "fa fa-phone-alt",
            color = "#04b543",
            timeout = 1500,
        },
    })
    Config.PhoneApplications["phone"].Alerts = Config.PhoneApplications["phone"].Alerts + 1
    TriggerServerEvent('mr-phone:server:SetPhoneAlerts', "phone", Config.PhoneApplications["phone"].Alerts)
end)

RegisterNetEvent('mr-phone:client:UpdateHashtags', function(Handle, msgData)
    if PhoneData.Hashtags[Handle] ~= nil then
        PhoneData.Hashtags[Handle].messages[#PhoneData.Hashtags[Handle].messages+1] = msgData
    else
        PhoneData.Hashtags[Handle] = {
            hashtag = Handle,
            messages = {}
        }
        PhoneData.Hashtags[Handle].messages[#PhoneData.Hashtags[Handle].messages+1] = msgData
    end

    SendNUIMessage({
        action = "UpdateHashtags",
        Hashtags = PhoneData.Hashtags,
    })
end)

RegisterNetEvent('mr-phone:client:UpdateHashtags-dark', function(Handle, msgData)
    if PhoneData.Hashtags_dark[Handle] ~= nil then
        PhoneData.Hashtags_dark[Handle].messages[#PhoneData.Hashtags_dark[Handle].messages+1] = msgData
    else
        PhoneData.Hashtags_dark[Handle] = {
            hashtag = Handle,
            messages = {}
        }
        PhoneData.Hashtags_dark[Handle].messages[#PhoneData.Hashtags_dark[Handle].messages+1] = msgData
    end

    SendNUIMessage({
        action = "UpdateHashtags-dark",
        Hashtags = PhoneData.Hashtags_dark,
    })
end)

RegisterNetEvent('mr-phone:client:AnswerCall', function()
    if (PhoneData.CallData.CallType == "incoming" or PhoneData.CallData.CallType == "outgoing") and PhoneData.CallData.InCall and not PhoneData.CallData.AnsweredCall then
        PhoneData.CallData.CallType = "ongoing"
        PhoneData.CallData.AnsweredCall = true
        PhoneData.CallData.CallTime = 0

        SendNUIMessage({ action = "AnswerCall", CallData = PhoneData.CallData})
        SendNUIMessage({ action = "SetupHomeCall", CallData = PhoneData.CallData})

        TriggerServerEvent('mr-phone:server:SetCallState', true)

        if PhoneData.isOpen then
            DoPhoneAnimation('cellphone_text_to_call')
        else
            DoPhoneAnimation('cellphone_call_listen_base')
        end

        CreateThread(function()
            while true do
                if PhoneData.CallData.AnsweredCall then
                    PhoneData.CallData.CallTime = PhoneData.CallData.CallTime + 1
                    SendNUIMessage({
                        action = "UpdateCallTime",
                        Time = PhoneData.CallData.CallTime,
                        Name = PhoneData.CallData.TargetData.name,
                    })
                else
                    break
                end

                Wait(1000)
            end
        end)
        exports['pma-voice']:addPlayerToCall(PhoneData.CallData.CallId)
    else
        PhoneData.CallData.InCall = false
        PhoneData.CallData.CallType = nil
        PhoneData.CallData.AnsweredCall = false

        TriggerServerEvent("InteractSound_SV:PlayOnSource", "vtexts", 0.4)
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Phone",
                text = "You don't have an incoming call...",
                icon = "fas fa-phone",
                color = "#e84118",
            },
        })
    end
end)

RegisterNetEvent('mr-phone:client:addPoliceAlert', function(alertData)
    PlayerJob = MRFW.Functions.GetPlayerData().job
    if LocalPlayer.state['isLoggedIn'] then
        if PlayerJob.name == 'police' and PlayerJob.onduty then
            SendNUIMessage({
                action = "AddPoliceAlert",
                alert = alertData,
            })
        end
    end
end)

RegisterNetEvent('mr-phone:client:GiveContactDetails', function()
    local player, distance = GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local PlayerId = GetPlayerServerId(player)
        TriggerServerEvent('mr-phone:server:GiveContactDetails', PlayerId)
    else
        MRFW.Functions.Notify("No one nearby!", "error")
    end
end)

RegisterNetEvent('mr-phone:client:UpdateLapraces', function()
    SendNUIMessage({
        action = "UpdateRacingApp",
    })
end)

RegisterNetEvent('mr-phone:client:GetMentioned', function(TweetMessage, AppAlerts)
    Config.PhoneApplications["twitter"].Alerts = AppAlerts
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "vtexts", 0.4)
    SendNUIMessage({ action = "PhoneNotification", PhoneNotify = { title = "New mention!", text = TweetMessage.message, icon = "fab fa-twitter", color = "#1DA1F2", }, })
    local TweetMessage = {firstName = TweetMessage.firstName, lastName = TweetMessage.lastName, message = escape_str(TweetMessage.message), time = TweetMessage.time, picture = TweetMessage.picture}
    PhoneData.MentionedTweets[#PhoneData.MentionedTweets+1] = TweetMessage
    SendNUIMessage({ action = "RefreshAppAlerts", AppData = Config.PhoneApplications })
    SendNUIMessage({ action = "UpdateMentionedTweets", Tweets = PhoneData.MentionedTweets })
end)

RegisterNetEvent('mr-phone:client:GetMentioned-dark', function(AnonMessage, AppAlerts)
    Config.PhoneApplications["darkweb"].Alerts = AppAlerts
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "vtexts", 0.4)
    SendNUIMessage({ action = "PhoneNotification", PhoneNotify = { title = "You have been mentioned in a Anon!", text = AnonMessage.message, icon = "fas fa-hat-cowboy", color = "#1DA1F2", }, })
    local AnonMessage = {firstName = AnonMessage.firstName, lastName = AnonMessage.lastName, message = escape_str(AnonMessage.message), time = AnonMessage.time, picture = AnonMessage.picture}
    PhoneData.MentionedAnons[#PhoneData.MentionedAnons+1] = TweetMessage
    SendNUIMessage({ action = "RefreshAppAlerts", AppData = Config.PhoneApplications })
    SendNUIMessage({ action = "UpdateMentionedAnons", Anons = PhoneData.MentionedAnons })
end)

RegisterNetEvent('mr-phone:refreshImages', function(images)
    PhoneData.Images = images
end)


-- Threads

CreateThread(function()
    Wait(500)
    LoadPhone()
    PublicPhone()
end)

CreateThread(function()
    while true do
        if PhoneData.isOpen then
            SendNUIMessage({
                action = "UpdateTime",
                InGameTime = CalculateTimeToDisplay(),
            })
        end
        Wait(1000)
    end
end)

CreateThread(function()
    while true do
        Wait(60000)
        if LocalPlayer.state.isLoggedIn then
            MRFW.Functions.TriggerCallback('mr-phone:server:GetPhoneData', function(pData)
                if pData.PlayerContacts ~= nil and next(pData.PlayerContacts) ~= nil then
                    PhoneData.Contacts = pData.PlayerContacts
                end
                SendNUIMessage({
                    action = "RefreshContacts",
                    Contacts = PhoneData.Contacts
                })
            end)
        end
    end
end)


-- ping

RegisterNUICallback('AcceptPingPlayer', function()
    TriggerServerEvent('mr-pings:server:acceptping')
    TriggerEvent("mr-phone:ping:client:UiUppers", false)
end)

RegisterNUICallback('rejectPingPlayer', function()
    TriggerServerEvent('mr-pings:server:denyping')
    TriggerEvent("mr-phone:ping:client:UiUppers", false)
end)

RegisterNUICallback('SendPingPlayer', function(data)
    TriggerServerEvent('mr-pings:server:SendPing2', data.id)
    
end)

local CurrentPings = {}

RegisterNetEvent('mr-pings:client:DoPing', function(id)
    -- local player = GetPlayerFromServerId(id)
    -- local ped = GetPlayerPed(player)
    -- local pos = GetEntityCoords(ped)
    -- local coords = {
    --     x = pos.x,
    --     y = pos.y,
    --     z = pos.z,
    -- }
    --     TriggerServerEvent('mr-pings:server:SendPing', id, coords)
    TriggerServerEvent('mr-pings:server:SendPing', id)
end)

RegisterNetEvent('mr-pings:client:AcceptPing', function(PingData, SenderData)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)

        TriggerServerEvent('mr-pings:server:SendLocation', PingData, SenderData)
end)

RegisterNetEvent('mr-pings:client:SendLocation', function(PingData, SenderData)
    MRFW.Functions.Notify('Their location has been blipped on your map', 'success')

    CurrentPings[PingData.sender] = AddBlipForCoord(PingData.coords.x, PingData.coords.y, PingData.coords.z)
    SetBlipSprite(CurrentPings[PingData.sender], 280)
    SetBlipDisplay(CurrentPings[PingData.sender], 4)
    SetBlipScale(CurrentPings[PingData.sender], 1.1)
    SetBlipAsShortRange(CurrentPings[PingData.sender], false)
    SetBlipColour(CurrentPings[PingData.sender], 0)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Friend")
    EndTextCommandSetBlipName(CurrentPings[PingData.sender])

    SetTimeout(5 * (60 * 1000), function()
        MRFW.Functions.Notify('Ping '..PingData.sender..' has expired...', 'error')
        RemoveBlip(CurrentPings[PingData.sender])
        CurrentPings[PingData.sender] = nil
        TriggerEvent("mr-phone:ping:client:UiUppers", false)
    end)
end)

RegisterNetEvent('mr-phone:ping:client:UiUppers', function(toggle)
    if toggle then
        SendNUIMessage({
            action = "acceptrejectBlock",
        })
        TriggerEvent("mr-hud:ping:client:ShowIcon", true)
    else
        SendNUIMessage({
            action = "acceptrejectNone",
        })
        TriggerEvent("mr-hud:ping:client:ShowIcon", false)
    end
end)


RegisterNetEvent('mr-phone:client-annphonenumber', function(number, copy)
    TriggerEvent('chat:addMessage', {
        template = '<div class="chat-message" style="background-color: rgba(234, 135, 23, 0.50);">Number : <b>{0}</b></div>',
        args = {" "..number}
    })
    if copy then
        exports['mr-adminmenu']:CopyToClipboard2(tostring(number))
    end
end)


RegisterNUICallback('CasinoAddBet', function(data)
    TriggerServerEvent('mr-phone:server:CasinoAddBet', data)
end)

RegisterNetEvent('mr-phone:client:addbetForAll', function(data)
    SendNUIMessage({
        action = "BetAddToApp",
        datas = data,
    })
end)

RegisterNUICallback('BettingAddToTable', function(data)
    TriggerServerEvent('mr-phone:server:BettingAddToTable', data)
end)

RegisterNUICallback('CasinoDeleteTable', function(data)
    TriggerServerEvent('mr-phone:server:DeleteAndClearTable')
end)

RegisterNUICallback('CheckHasBetTable', function(data, cb)
    MRFW.Functions.TriggerCallback('mr-phone:server:CheckHasBetTable', function(HasTable)
        cb(HasTable)
    end)
end)

RegisterNUICallback('casino_status', function(data)
    TriggerServerEvent('mr-phone:server:casino_status')
end)

RegisterNUICallback('CheckHasBetStatus', function(data, cb)
    MRFW.Functions.TriggerCallback('mr-phone:server:CheckHasBetStatus', function(HasStatus)
        cb(HasStatus)
    end)
end)

RegisterNUICallback('WineridCasino', function(data)
    TriggerServerEvent('mr-phone:server:WineridCasino', data)
end)

RegisterNUICallback('GetJobCentersJobs', function(data, cb)
    cb(Config.JobCenter)
end)

RegisterNUICallback('CasinoPhoneJobCenter', function(data)
    if data.action == 1 then
        TriggerServerEvent('mr-phone:server:SetJobJobCenter', data)
    elseif data.action == 2 then
        SetNewWaypoint(data.x, data.y)
        MRFW.Functions.Notify('GPS set', "success")
    end
end)

RegisterNUICallback('employment_CreateJobGroup', function(data)
    TriggerServerEvent('mr-phone:server:employment_CreateJobGroup', data)
end)

RegisterNetEvent('mr-phone:client:EveryoneGrupAddsForAll', function(data)
    SendNUIMessage({
        action = "GroupAddDIV",
        datas = data,
    })
end)

RegisterNUICallback('employment_DeleteGroup', function(data)
    TriggerServerEvent('mr-phone:server:employment_DeleteGroup', data)
end)

RegisterNUICallback('GetGroupsApp', function(data, cb)
    MRFW.Functions.TriggerCallback('mr-phone:server:GetGroupsApp', function(HasGroups)
        cb(HasGroups)
    end)
end)

RegisterNUICallback('employment_JoinTheGroup', function(data)
    TriggerServerEvent('mr-phone:server:employment_JoinTheGroup', data)
end)

RegisterNUICallback('employment_leave_grouped', function(data)
    TriggerServerEvent('mr-phone:server:employment_leave_grouped', data)
end)

RegisterNUICallback('employment_CheckPlayerNames', function(data, cb)
    MRFW.Functions.TriggerCallback('mr-phone:server:employment_CheckPlayerNames', function(HasName)
        cb(HasName)
    end, data.id)
end)

RegisterNUICallback('SendBillForPlayer_debt', function(data)
    for k,v in pairs(Config.dept) do
        if PhoneData.PlayerData.job.name == v then
            TriggerServerEvent('mr-phone:server:SendBillForPlayer_debt', data)
            return
        end
    end
    MRFW.Functions.Notify('You Don\'t have enough perms', 'error', 3000)
end)

RegisterNUICallback('GetHasBills_debt', function(data, cb)
    MRFW.Functions.TriggerCallback('mr-phone:server:GetHasBills_debt', function(Has)
        cb(Has)
    end)
end)

RegisterNUICallback('debit_AcceptBillForPay', function(data)
    TriggerServerEvent('mr-phone:server:debit_AcceptBillForPay', data)
end)

RegisterNetEvent('mr-phone:RefreshPhoneForDebt', function()
    SendNUIMessage({
        action = "DebtRefresh",
    })
end)

RegisterNUICallback('wenmo_givemoney_toID', function(data)
    TriggerServerEvent('mr-phone:server:wenmo_givemoney_toID', data)
end)

RegisterNetEvent('hud:client:OnMoneyChange', function(type, amount, isMinus, reason)
    if type == "bank" then
        if isMinus then
            SendNUIMessage({
                action = "ChangeMoney_Wenmo",
                Color = "#f5a15b",
                Amount = "-$"..amount,
                Reason = reason,
            })
        else
            SendNUIMessage({
                action = "ChangeMoney_Wenmo",
                Color = "#8ee074",
                Amount = "+$"..amount,
                Reason = reason,
            })
        end
    end
end)

RegisterNUICallback('documents_Save_Note_As', function(data)
    TriggerServerEvent('mr-phone:server:documents_Save_Note_As', data)
end)

RegisterNUICallback('GetNote_for_Documents_app', function(data, cb)
    MRFW.Functions.TriggerCallback('mr-phone:server:GetNote_for_Documents_app', function(Has)
        cb(Has)
    end)
end)

RegisterNetEvent('mr-phone:RefReshNotes_Free_Documents', function()
    SendNUIMessage({
        action = "DocumentRefresh",
    })
end)


RegisterNUICallback('Send_lsbn_ToChat', function(data)
    TriggerServerEvent('mr-phone:server:Send_lsbn_ToChat', data)
end)

RegisterNetEvent('mr-phone:LSBN-reafy-for-add', function(data, toggle, text)
    if toggle then
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "LSBN",
                text = text,
                icon = "fas fa-bullhorn",
                color = "#d8e212",
                timeout = 1000,
            },
        })
    end

    SendNUIMessage({
        action = "AddNews",
        data = data,
    })
end)

RegisterNUICallback('GetLSBNchats', function(data)
    TriggerServerEvent('mr-phone:server:GetLSBNchats', data)
end)







RegisterNetEvent('stx-phone:client:publocphoneopen',function()
    SetNuiFocus(true, true)
    SendNUIMessage({type = 'publicphoneopen'})
end)

RegisterNUICallback('publicphoneclose', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback('openHelp', function()  
    TriggerEvent('mr-help')
end)

local function GetGroupCSNs(Data)
    local gData = {}
    MRFW.Functions.TriggerCallback('mr-phone:server:GetGroupCSNs', function(HasGroup)
        gData = HasGroup
    end, Data)
    Wait(100)
    return gData
end

exports('GetGroupCSNs', GetGroupCSNs)