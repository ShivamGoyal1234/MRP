-- MRFW = nil
-- TriggerEvent('MRFW:GetObject', function(obj) MRFW = obj end)
gsrData = {}

MRFW.Commands.Add("gsr", "Check GSR status", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = MRFW.Functions.GetPlayer(tonumber(args[1]))
    local Myself = MRFW.Functions.GetPlayer(source)
    local number = tonumber(args[1])

    if Player ~= nil and Myself ~= nil and Myself.PlayerData.job.name == "police" and type(number) == "number" then 
        --CancelEvent()
        gsrcheck(number, source)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "This command is for emergency services only!")
    end
end)

--[[TriggerEvent('es:addCommand', 'gsr', function(source, args, user)
    local Source = source
    local xPlayer = ESX.GetPlayerFromId(Source)
    local number = tonumber(args[1])
    if args[1] ~= nil then 
		if xPlayer.job.name == 'police' and type(number) == "number" then
        	CancelEvent()
        	local identifier = GetPlayerIdentifiers(number)[1]
        	if identifier ~= nil then
            	gsrcheck(source, identifier)
        	end
    	else
			TriggerClientEvent('mythic_notify:client:SendAlert', Source, { type = 'error', text = 'You must be a cop to use the GSR test' })
    	end
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', Source, { type = 'error', text = 'Correct Usage Is: /gsr (player id)' })
	end
end)--]]

AddEventHandler('playerDropped', function(reason) 
    local Source = source
    local identifier = GetPlayerIdentifiers(Source)[1]
    if gsrData[identifier] ~= nil then
        gsrData[identifier] = nil
    end
end)

RegisterNetEvent("GSR:Remove")
AddEventHandler("GSR:Remove", function()
    local Source = source
    local identifier = GetPlayerIdentifiers(Source)[1]
    if gsrData[identifier] ~= nil then
        gsrData[identifier] = nil
    end
end)

RegisterServerEvent('GSR:SetGSR')
AddEventHandler('GSR:SetGSR', function()
    local Source = source
    local identifier = GetPlayerIdentifiers(Source)[1]
    gsrData[identifier] = os.time(os.date("!*t")) + 30 * 60
end)

function getIdentity(source)
	local Target = MRFW.Functions.GetPlayer(source)

	-- print(Target.PlayerData.charinfo.firstname, Target.PlayerData.charinfo.lastname)
    if Target ~= nil then
        return {
            firstname   = Target.PlayerData.charinfo.firstname,
            lastname  = Target.PlayerData.charinfo.lastname
        }
    else
        return {
            firstname   = '',
            lastname  = ''
        }
    end
end

--[[function getIdentity(identifier)
    local identifier = identifier
    local result = MySQL.Sync.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", {
        ['@identifier'] = identifier
    })
  if result[1] ~= nil then
    local identity = result[1]

    return {
      firstname   = identity['firstname'],
      lastname  = identity['lastname']
    }
  else
    return {
      firstname   = '',
      lastname  = ''
    }
    end
end--]]

MRFW.Commands.Add("gsrgod", "", {}, false, function(source, args)
    TriggerClientEvent('MRFW:checkGSRgod', source, source)
end, "owner")

function gsrcheck(source, police)
    local Source = source
    local nameData = getIdentity(Source)
    local identifier = GetPlayerIdentifiers(Source)[1]
    Wait(100)
    local fullName = string.format("%s %s", nameData.firstname, nameData.lastname)

    if gsrData[identifier] ~= nil then
        TriggerClientEvent('MRFW:Notify', police, 'GSR Test returned <b>POSITIVE</b> for : Player'..Source..' (Has Shot)')
        --TriggerClientEvent('chatMessage', police, "SYSTEM", "error", 'Test for '..fullName..' comes back POSITIVE (Has Shot)')
    else
        TriggerClientEvent('MRFW:Notify', police, 'GSR Test returned <b>NEGATIVE</b> for : Player'..Source..'', 'error')
    end
end

RegisterServerEvent('GSR:Status2')
AddEventHandler('GSR:Status2', function(playerid)
    local Source = source
    local nameData = getIdentity(playerid)
    local identifier = GetPlayerIdentifiers(playerid)[1]
    Wait(100)
    local fullName = string.format("%s %s", nameData.firstname, nameData.lastname)
    
    if gsrData[identifier] ~= nil then
        TriggerClientEvent('chatMessage', Source, "SYSTEM", "error", 'Test for Player:'..playerid..' comes back POSITIVE (Has Shot)')
    else
        -- print(playerid)
        TriggerClientEvent('chatMessage', Source, "SYSTEM", "error", 'Test for Player:'..playerid..' comes back NEGATIVE (Has Not Shot)')
    end
end)

MRFW.Functions.CreateCallback('GSR:Status', function(source, cb)
    local Source = source
    local identifier = GetPlayerIdentifiers(Source)[1]
    if gsrData[identifier] ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

function removeGSR()
    for k, v in pairs(gsrData) do
        if v <= os.time(os.date("!*t")) then
            gsrData[k] = nil
        end
    end
end

function gsrTimer()
    removeGSR()
    SetTimeout(Config.gsrAutoRemove, gsrTimer)
end

gsrTimer()
