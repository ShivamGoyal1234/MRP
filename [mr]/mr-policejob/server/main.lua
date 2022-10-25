-- Variables

local Plates = {}
local PlayerStatus = {}
local Casings = {}
local BloodDrops = {}
local FingerDrops = {}
local Objects = {}
MRFW = exports['mrfw']:GetCoreObject()

-- Functions

local function UpdateBlips()
    local dutyPlayers = {}
    local players = MRFW.Functions.GetMRPlayers()
    for k, v in pairs(players) do
        if (v.PlayerData.job.name == "police" or v.PlayerData.job.name == "doctor") 
        and v.PlayerData.job.onduty 
        and v.PlayerData.metadata['ptracker'] 
        and v.Functions.GetItemByName("tracker") then
            local coords = GetEntityCoords(GetPlayerPed(v.PlayerData.source))
            local heading = GetEntityHeading(GetPlayerPed(v.PlayerData.source))
            dutyPlayers[#dutyPlayers+1] = {
                source = v.PlayerData.source,
                label = v.PlayerData.metadata["callsign"],
                job = v.PlayerData.job.name,
                location = {
                    x = coords.x,
                    y = coords.y,
                    z = coords.z,
                    w = heading
                }
            }
        end
        if (v.PlayerData.job.name == "police" or v.PlayerData.job.name == "doctor") 
        and v.PlayerData.job.onduty 
        and v.PlayerData.metadata['ptracker'] and not v.Functions.GetItemByName("tracker") then
            v.Functions.SetMetaData("ptracker", false)
        end
    end
    TriggerClientEvent("police:client:UpdateBlips", -1, dutyPlayers)
end

MRFW.Commands.Add('tracker', 'Turn on/off tracker (Emergency Service only)', {}, false, function(source, args)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player ~= nil then
        local has = Player.Functions.GetItemByName("tracker")
        if Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "doctor" then
            if Player.PlayerData.job.onduty then
                if has then
                    if Player.PlayerData.metadata['ptracker'] then
                        Player.Functions.SetMetaData("ptracker", false)
                        TriggerClientEvent("MRFW:Notify", src, "Tracker off", "error", 4000)
                    else
                        Player.Functions.SetMetaData("ptracker", true)
                        TriggerClientEvent("MRFW:Notify", src, "Tracker on", "success", 4000)
                    end
                end
            else
                TriggerClientEvent("MRFW:Notify", src, "Not Authorized", "error", 4000)
            end
        else
            TriggerClientEvent("MRFW:Notify", src, "Not Authorized", "error", 4000)
        end
    end
end)

local function CreateBloodId()
    if BloodDrops then
        local bloodId = math.random(10000, 99999)
        while BloodDrops[bloodId] do
            bloodId = math.random(10000, 99999)
        end
        return bloodId
    else
        local bloodId = math.random(10000, 99999)
        return bloodId
    end
end

local function CreateFingerId()
    if FingerDrops then
        local fingerId = math.random(10000, 99999)
        while FingerDrops[fingerId] do
            fingerId = math.random(10000, 99999)
        end
        return fingerId
    else
        local fingerId = math.random(10000, 99999)
        return fingerId
    end
end

local function CreateCasingId()
    if Casings then
        local caseId = math.random(10000, 99999)
        while Casings[caseId] do
            caseId = math.random(10000, 99999)
        end
        return caseId
    else
        local caseId = math.random(10000, 99999)
        return caseId
    end
end

local function CreateObjectId()
    if Objects then
        local objectId = math.random(10000, 99999)
        while Objects[objectId] do
            objectId = math.random(10000, 99999)
        end
        return objectId
    else
        local objectId = math.random(10000, 99999)
        return objectId
    end
end

local function IsVehicleOwned(plate)
    local result = MySQL.Sync.fetchScalar('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
    return result
end

local function GetCurrentCops()
    local amount = 0
    local players = MRFW.Functions.GetMRPlayers()
    for k, v in pairs(players) do
        if v.PlayerData.job.name == "police" and v.PlayerData.job.onduty then
            amount = amount + 1
        end
    end
    return amount
end

local function DnaHash(s)
    local h = string.gsub(s, ".", function(c)
        return string.format("%02x", string.byte(c))
    end)
    return h
end

-- Commands

MRFW.Commands.Add("spikestrip", "Place Spike Strip (Police Only)", {}, false, function(source)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player then
        if Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then
            TriggerClientEvent('police:client:SpawnSpikeStrip', src)
        end
    end
end, 'police')

MRFW.Commands.Add("grantlicense", "Grant a license to someone", {{name = "id", help = "ID of a person"}, {name = "license", help = "License Type"}}, true, function(source, args)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "police" and Player.PlayerData.job.grade.level >= 2 then
        if args[2] == "driver" or args[2] == "weapon" then
            local SearchedPlayer = MRFW.Functions.GetPlayer(tonumber(args[1]))
            if SearchedPlayer then
                local licenseTable = SearchedPlayer.PlayerData.metadata["licences"]
                licenseTable[args[2]] = true
                SearchedPlayer.Functions.SetMetaData("licences", licenseTable)
                TriggerClientEvent('MRFW:Notify', SearchedPlayer.PlayerData.source, "You have been granted a license",
                    "success", 5000)
                TriggerClientEvent('MRFW:Notify', src, "You granted a license", "success", 5000)
            end
        else
            TriggerClientEvent('MRFW:Notify', src, "Invalid license type", "error")
        end
    else
        TriggerClientEvent('MRFW:Notify', src, "You must be a Sergeant to grant licenses!", "error")
    end
end, 'police')

MRFW.Commands.Add("revokelicense", "Revoke a license from someone", {{name = "id", help = "ID of a person"}, {name = "license", help = "License Type"}}, true, function(source, args)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "police" and Player.PlayerData.job.grade.level >= 2 then
        if args[2] == "driver" or args[2] == "weapon" then
            local SearchedPlayer = MRFW.Functions.GetPlayer(tonumber(args[1]))
            if SearchedPlayer then
                local licenseTable = SearchedPlayer.PlayerData.metadata["licences"]
                licenseTable[args[2]] = false
                SearchedPlayer.Functions.SetMetaData("licences", licenseTable)
                TriggerClientEvent('MRFW:Notify', SearchedPlayer.PlayerData.source, "You've had a license revoked",
                    "error", 5000)
                TriggerClientEvent('MRFW:Notify', src, "You revoked a license", "success", 5000)
            end
        else
            TriggerClientEvent('MRFW:Notify', src, "Invalid license type", "error")
        end
    else
        TriggerClientEvent('MRFW:Notify', src, "You must be a Sergeant to revoke licenses!", "error")
    end
end, 'police')

MRFW.Commands.Add("pobject", "Place/Delete An Object (Police Only)", {{name = "type",help = "Type object you want or 'delete' to delete"}}, true, function(source, args)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local type = args[1]:lower()
    if Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then
        if type == "pion" then
            TriggerClientEvent("police:client:spawnCone", src)
        elseif type == "barier" then
            TriggerClientEvent("police:client:spawnBarier", src)
        elseif type == "schotten" then
            TriggerClientEvent("police:client:spawnSchotten", src)
        elseif type == "tent" then
            TriggerClientEvent("police:client:spawnTent", src)
        elseif type == "light" then
            TriggerClientEvent("police:client:spawnLight", src)
        elseif type == "delete" then
            TriggerClientEvent("police:client:deleteObject", src)
        end
    else
        TriggerClientEvent('MRFW:Notify', src, 'For on-duty police only', 'error')
    end
end, 'police')
MRFW.Commands.Add("boombox", "Place/Delete an boombox", {{name="action", help="type1/type2/remove"}}, true, function(source, args)
    local action = args[1]:lower()
        if action == "type1" then
            TriggerClientEvent("police:client:spawnboombox", source)
        elseif action == "type2" then
            TriggerClientEvent("police:client:spawnboombox2", source)
        elseif action == "remove" then
            TriggerClientEvent("police:client:deleteObject", source)
        end
end)

-- MRFW.Commands.Add("tv", "Place/Delete an tv", {{name="action", help="type1/remove"}}, true, function(source, args)
--     local action = args[1]:lower()
--         if action == "type1" then
--             TriggerClientEvent("police:client:tv", source)
--         elseif action == "remove" then
--             TriggerClientEvent("police:client:deleteObject", source)
--         end
-- end, 'god')

MRFW.Commands.Add("cuff", "Cuff Player (Police Only)", {}, false, function(source, args)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "police" or (Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.level == 0 and Player.PlayerData.job.grade.level == 4)then
        TriggerClientEvent("police:client:CuffPlayer", src)
    else
        TriggerClientEvent('MRFW:Notify', src, 'For on-duty police only', 'error')
    end
end)

MRFW.Commands.Add("escort", "Escort Player", {}, false, function(source, args)
    local src = source
    TriggerClientEvent("police:client:EscortPlayer", src)
end)

MRFW.Commands.Add("callsign", "Give Yourself A Callsign", {{name = "name", help = "Name of your callsign"}}, false, function(source, args)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    Player.Functions.SetMetaData("callsign", table.concat(args, " "))
end)

MRFW.Commands.Add("edmtablet", "Toggle Edm Tablet", {}, false, function(source, args)
	local Player = MRFW.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "edmowner" or Player.PlayerData.job.name == "edmboss" or Player.PlayerData.job.name == "edmceo" or Player.PlayerData.job.name == "edmexecutive" or Player.PlayerData.job.name == "edmsalesman1" or Player.PlayerData.job.name == "edmsalesman" then
        TriggerClientEvent("police:client:toggleDatabank", source)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "This command is for EDM Members!")
    end
end, 'edm')

MRFW.Commands.Add("palert", "Make a police alert", {{name="alert", help="The Police alert"}}, false, function(source, args)
    local Player = MRFW.Functions.GetPlayer(source)

    if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
        if args[1] ~= nil then
            local msg = table.concat(args, " ")
            TriggerClientEvent("chatMessage", -1, "POLICE ALERT", "error", msg)
            TriggerEvent("MRlog:server:CreateLog", "palert", "Police alert", "blue", "**"..GetPlayerName(source).."** (CitizenID: "..Player.PlayerData.citizenid.." | ID: "..source..") **Alert:** " ..msg, false)
            TriggerClientEvent('police:PlaySound', -1)
        else
            TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "You must enter message!")
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "This command is for emergency services!")
    end
end, 'police')
MRFW.Commands.Add("clearcasings", "Clear Area of Casings (Police Only)", {}, false, function(source)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then
        TriggerClientEvent("evidence:client:ClearCasingsInArea", src)
    else
        TriggerClientEvent('MRFW:Notify', src, 'For on-duty police only', 'error')
    end
end, 'police')

MRFW.Commands.Add("uncuff", "uncuff a player", {}, false, function(source, args)
	local Player = MRFW.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "government" then
        TriggerClientEvent("police:client:unCuffPlayer", source)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "This command is for emergency services!")
    end
end)

RegisterServerEvent('police:server:unCuffPlayer')
AddEventHandler('police:server:unCuffPlayer', function(playerId, isSoftcuff)
    local src = source
    local Player = MRFW.Functions.GetPlayer(source)
    local CuffedPlayer = MRFW.Functions.GetPlayer(playerId)
    if CuffedPlayer ~= nil then
        if Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "government" then
            TriggerClientEvent("police:client:unGetCuffed", CuffedPlayer.PlayerData.source, Player.PlayerData.source, isSoftcuff)
        end
    end
end)

MRFW.Commands.Add("jail", "Jail Player (Police Only)", {{name = "id", help = "Player ID"}, {name = "time", help = "Time they have to be in jail"}}, true, function(source, args)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then
        local playerId = tonumber(args[1])
        local time = tonumber(args[2])
        if time > 0 then
            TriggerClientEvent("police:client:JailCommand", src, playerId, time)
        else
            TriggerClientEvent('MRFW:Notify', src, 'Cannot sentence for 0', 'error')
        end
    else
        TriggerClientEvent('MRFW:Notify', src, 'For on-duty police only', 'error')
    end
end, 'police')

MRFW.Commands.Add("unjail", "Unjail Player (Police Only)", {{name = "id", help = "Player ID"}}, true, function(source, args)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then
        local playerId = tonumber(args[1])
        TriggerClientEvent("prison:client:UnjailPerson", playerId)
    else
        TriggerClientEvent('MRFW:Notify', src, 'For on-duty police only', 'error')
    end
end, 'police')

MRFW.Commands.Add("gimme", ":)", {}, false, function(source, args)
    local Player = MRFW.Functions.GetPlayer(source)
    local info = {
        serie = "K"..math.random(10,99).."SH"..math.random(100,999).."HJ"..math.random(1,9),
        attachments = {
            {component = "COMPONENT_AT_AR_FLSH", label = "Flashlight"},
            {component = "COMPONENT_AT_AR_SUPP_02", label = "Supressor"},
            {component = "COMPONENT_AT_AR_AFGRIP", label = "Grip"},
            {component = "COMPONENT_AT_SCOPE_MACRO", label = "1x Scope"},
            {component = "COMPONENT_ASSAULTRIFLE_CLIP_02", label = "Extended Clip"},
        }
    }
    if Player.Functions.AddItem("weapon_assaultrifle", 1, false, info) then
        --print("mr OP")
    end
end, "owner")

MRFW.Commands.Add("gimme2", ":)", {}, false, function(source, args)
    local Player = MRFW.Functions.GetPlayer(source)
    local info = {
        serie = "K"..math.random(10,99).."SH"..math.random(100,999).."HJ"..math.random(1,9),
        attachments = {
            {component = "COMPONENT_AT_AR_SUPP_02", label = "Supressor"},
        }
    }
    if Player.Functions.AddItem("weapon_pistol50", 1, false, info) then
        --print("mr" OP")
    end
end, "owner")

MRFW.Commands.Add("clearblood", "Clear The Area of Blood (Police Only)", {}, false, function(source)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then
        TriggerClientEvent("evidence:client:ClearBlooddropsInArea", src)
    else
        TriggerClientEvent('MRFW:Notify', src, 'For on-duty police only', 'error')
    end
end, 'police')

MRFW.Commands.Add("seizecash", "Seize Cash (Police Only)", {}, false, function(source)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then
        TriggerClientEvent("police:client:SeizeCash", src)
    else
        TriggerClientEvent('MRFW:Notify', src, 'For on-duty police only', 'error')
    end
end, 'police')

MRFW.Commands.Add("sc", "Soft Cuff (Police Only)", {}, false, function(source)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "government" then
        TriggerClientEvent("police:client:CuffPlayerSoft", src)
    else
        TriggerClientEvent('MRFW:Notify', src, 'For on-duty police only', 'error')
    end
end)

MRFW.Commands.Add("cam", "View Security Camera (Police Only)", {{name = "camid", help = "Camera ID"}}, false, function(source, args)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then
        TriggerClientEvent("police:client:ActiveCamera", src, tonumber(args[1]))
    else
        TriggerClientEvent('MRFW:Notify', src, 'For on-duty police only', 'error')
    end
end, 'police')

MRFW.Commands.Add("flagplate", "Flag A Plate (Police Only)", {{name = "plate", help = "License"}, {name = "reason", help = "Reason of flagging the vehicle"}}, true, function(source, args)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then
        local reason = {}
        for i = 2, #args, 1 do
            table.insert(reason, args[i])
        end
        Plates[args[1]:upper()] = {
            isflagged = true,
            reason = table.concat(reason, " ")
        }
        TriggerClientEvent('MRFW:Notify', src, "Vehicle (" .. args[1]:upper() .. ") is flagged for: " .. table.concat(reason, " "))
    else
        TriggerClientEvent('MRFW:Notify', src, 'For on-duty police only', 'error')
    end
end, 'police')

MRFW.Commands.Add("unflagplate", "Unflag A Plate (Police Only)", {{name = "plate", help = "License plate"}}, true, function(source, args)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then
        if Plates and Plates[args[1]:upper()] then
            if Plates[args[1]:upper()].isflagged then
                Plates[args[1]:upper()].isflagged = false
                TriggerClientEvent('MRFW:Notify', src, "Vehicle (" .. args[1]:upper() .. ") is unflagged")
            else
                TriggerClientEvent('MRFW:Notify', src, 'Vehicle not flagged', 'error')
            end
        else
            TriggerClientEvent('MRFW:Notify', src, 'Vehicle not flagged', 'error')
        end
    else
        TriggerClientEvent('MRFW:Notify', src, 'For on-duty police only', 'error')
    end
end, 'police')

MRFW.Commands.Add("plateinfo", "Run A Plate (Police Only)", {{name = "plate",help = "License plate"}}, true, function(source, args)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then
        if Plates and Plates[args[1]:upper()] then
            if Plates[args[1]:upper()].isflagged then
                TriggerClientEvent('MRFW:Notify', src, 'Vehicle ' .. args[1]:upper() .. ' has been flagged for: ' .. Plates[args[1]:upper()].reason)
            else
                TriggerClientEvent('MRFW:Notify', src, 'Vehicle not flagged', 'error')
            end
        else
            TriggerClientEvent('MRFW:Notify', src, 'Vehicle not flagged', 'error')
        end
    else
        TriggerClientEvent('MRFW:Notify', src, 'For on-duty police only', 'error')
    end
end, 'police')

MRFW.Commands.Add("depot", "Send to Depot", {{name = "price", help = "Price for how much the person has to pay (may be empty)"}}, false, function(source, args)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then
        local coords = GetEntityCoords(GetPlayerPed(source))
        TriggerClientEvent('3dme:triggerDisplay', -1, 'Calling Tow Service...', source, coords)
        if tonumber(args[1]) ~= nil then
            if tonumber(args[1]) <= 20000 then
                TriggerClientEvent("police:client:ImpoundVehicle", src, false, tonumber(args[1]))
            else
                TriggerClientEvent('MRFW:Notify', src, 'Price Limit is ( 20000 )', 'error')
            end
        else
            TriggerClientEvent("police:client:ImpoundVehicle", src, false, 600)
        end
    elseif Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "doctor" or Player.PlayerData.job.name == "bennys" or Player.PlayerData.job.name == "mechanic" or Player.PlayerData.job.name == "edm" or Player.PlayerData.job.name == "pdm" or Player.PlayerData.job.name == "government" then
        local coords = GetEntityCoords(GetPlayerPed(source))
        TriggerClientEvent('3dme:triggerDisplay', -1, 'Calling Tow Service...', source, coords)
        TriggerClientEvent("police:client:ImpoundVehicle", src, false, 1000)
    else
        TriggerClientEvent('MRFW:Notify', src, 'You Don\'t Have perms to use this...', 'error')
    end
end)

MRFW.Commands.Add("seize", "Seize A Vehicle (Police Only)", {}, false, function(source)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then
        TriggerClientEvent("police:client:ImpoundVehicle", src, true)
    else
        TriggerClientEvent('MRFW:Notify', src, 'For on-duty police only', 'error')
    end
end, 'police')

-- MRFW.Commands.Add("paytow", "Pay Tow Driver (Police Only)", {{name = "id",help = "ID of the player"}}, true, function(source, args)
--     local src = source
--     local Player = MRFW.Functions.GetPlayer(src)
--     if Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then
--         local playerId = tonumber(args[1])
--         local OtherPlayer = MRFW.Functions.GetPlayer(playerId)
--         if OtherPlayer then
--             if OtherPlayer.PlayerData.job.name == "tow" then
--                 OtherPlayer.Functions.AddMoney("bank", 500, "police-tow-paid")
--                 TriggerClientEvent('MRFW:Notify', OtherPlayer.PlayerData.source, 'You were paid $500', 'success')
--                 TriggerClientEvent('MRFW:Notify', src, 'You paid the tow truck driver')
--             else
--                 TriggerClientEvent('MRFW:Notify', src, 'Not a tow truck driver', 'error')
--             end
--         end
--     else
--         TriggerClientEvent('MRFW:Notify', src, 'For on-duty police only', 'error')
--     end
-- end, 'police')

-- MRFW.Commands.Add("paylawyer", "Pay Lawyer (Police, Judge Only)", {{name = "id",help = "ID of the player"}}, true, function(source, args)
--     local src = source
--     local Player = MRFW.Functions.GetPlayer(src)
--     if Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "judge" then
--         local playerId = tonumber(args[1])
--         local OtherPlayer = MRFW.Functions.GetPlayer(playerId)
--         if OtherPlayer then
--             if OtherPlayer.PlayerData.job.name == "lawyer" then
--                 OtherPlayer.Functions.AddMoney("bank", 500, "police-lawyer-paid")
--                 TriggerClientEvent('MRFW:Notify', OtherPlayer.PlayerData.source, 'You were paid $500', 'success')
--                 TriggerClientEvent('MRFW:Notify', src, 'You paid a lawyer')
--             else
--                 TriggerClientEvent('MRFW:Notify', src, 'Person is not a lawyer', "error")
--             end
--         end
--     else
--         TriggerClientEvent('MRFW:Notify', src, 'For on-duty police only', 'error')
--     end
-- end)

MRFW.Commands.Add("anklet", "Attach Tracking Anklet (Police Only)", {}, false, function(source)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then
        TriggerClientEvent("police:client:CheckDistance", src)
    else
        TriggerClientEvent('MRFW:Notify', src, 'For on-duty police only', 'error')
    end
end, 'police')

MRFW.Commands.Add("ankletlocation", "Get the location of a persons anklet", {{"cid", "Citizen ID of the person"}}, true, function(source, args)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then
        if args[1] then
            local citizenid = args[1]
            local Target = MRFW.Functions.GetPlayerByCitizenId(citizenid)
            if Target then
                if Target.PlayerData.metadata["tracker"] then
                    TriggerClientEvent("police:client:SendTrackerLocation", Target.PlayerData.source, src)
                else
                    TriggerClientEvent('MRFW:Notify', src, 'This person doesn\'t have an anklet on.', 'error')
                end
            end
        end
    else
        TriggerClientEvent('MRFW:Notify', src, 'For on-duty police only', 'error')
    end
end)

MRFW.Commands.Add("removeanklet", "Remove Tracking Anklet (Police Only)", {{"cid", "Citizen ID of person"}}, true,function(source, args)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then
        if args[1] then
            local citizenid = args[1]
            local Target = MRFW.Functions.GetPlayerByCitizenId(citizenid)
            if Target then
                if Target.PlayerData.metadata["tracker"] then
                    TriggerClientEvent("police:client:SendTrackerLocation", Target.PlayerData.source, src)
                else
                    TriggerClientEvent('MRFW:Notify', src, 'This person does not have an anklet', 'error')
                end
            end
        end
    else
        TriggerClientEvent('MRFW:Notify', src, 'For on-duty police only', 'error')
    end
end, 'police')

MRFW.Commands.Add("takedrivinglicense", "Seize Drivers License (Police Only)", {}, false, function(source, args)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then
        TriggerClientEvent("police:client:SeizeDriverLicense", source)
    else
        TriggerClientEvent('MRFW:Notify', src, 'For on-duty police only', 'error')
    end
end, 'police')

MRFW.Commands.Add("takedna", "Take a DNA sanple from a person (empty evidence bag needed) (Police Only)", {{"id", "ID of the person"}}, true, function(source, args)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local OtherPlayer = MRFW.Functions.GetPlayer(tonumber(args[1]))
    if ((Player.PlayerData.job.name == "police") and Player.PlayerData.job.onduty) and OtherPlayer then
        if Player.Functions.RemoveItem("empty_evidence_bag", 1) then
            local info = {
                label = "DNA Sample",
                type = "dna",
                dnalabel = DnaHash(OtherPlayer.PlayerData.citizenid)
            }
            if Player.Functions.AddItem("filled_evidence_bag", 1, false, info) then
                TriggerClientEvent("inventory:client:ItemBox", src, MRFW.Shared.Items["filled_evidence_bag"], "add")
            end
        else
            TriggerClientEvent('MRFW:Notify', src, "You must have an empty evidence bag with you", "error")
        end
    end
end, 'police')

RegisterNetEvent('police:server:SendTrackerLocation', function(coords, requestId)
    local Target = MRFW.Functions.GetPlayer(source)
    local msg = "The location of " .. Target.PlayerData.charinfo.firstname .. " " .. Target.PlayerData.charinfo.lastname .. " is marked on your map."
    local alertData = {
        title = "Anklet location",
        coords = {
            x = coords.x,
            y = coords.y,
            z = coords.z
        },
        description = msg
    }
    TriggerClientEvent("police:client:TrackerMessage", requestId, msg, coords)
    TriggerClientEvent("MRphone:client:addPoliceAlert", requestId, alertData)
end)

MRFW.Commands.Add("911", "Send a report to emergency services", {{name="message", help="Message you want to send"}}, true, function(source, args)
    local message = table.concat(args, " ")
    local Player = MRFW.Functions.GetPlayer(source)
    local coords = GetEntityCoords(GetPlayerPed(source))
    if Player.Functions.GetItemByName("phone") ~= nil then
		TriggerClientEvent('chatMessage', source, "911:", "warning", message)
        TriggerClientEvent("police:client:SendEmergencyMessage", source, coords, message)
        TriggerEvent("MRlog:server:CreateLog", "911 Report", "911 alert", "blue", "**"..GetPlayerName(source).."** (CitizenID: "..Player.PlayerData.citizenid.." | ID: "..source..") **Alert:** " ..message, false)
    else
        TriggerClientEvent('MRFW:Notify', source, 'You dont have a phone', 'error')
    end
end)

MRFW.Commands.Add("911a", "Send an anonymous report to emergency services (gives no location)", {{name="message", help="Message you want to send"}}, true, function(source, args)
    local message = table.concat(args, " ")
    local Player = MRFW.Functions.GetPlayer(source)

    if Player.Functions.GetItemByName("phone") ~= nil then
        TriggerClientEvent('chatMessage', source, "Anonymous Report:", "warning", message)
        TriggerClientEvent("police:client:CallAnim", source)
        TriggerClientEvent('police:client:Send112AMessage', -1, message)
    else
        TriggerClientEvent('MRFW:Notify', source, 'You dont have a phone', 'error')
    end
end)

MRFW.Commands.Add("911r", "Send a message back to a alert", {{name="id", help="ID of the alert"}, {name="Message", help="Message you want to send"}}, true, function(source, args)
    local Player = MRFW.Functions.GetPlayer(source)
    local OtherPlayer = MRFW.Functions.GetPlayer(tonumber(args[1]))
    table.remove(args, 1)
    local message = table.concat(args, " ")
    local Prefix = "POLICE"
    if Player.PlayerData.job.name == "doctor"  then
        Prefix = "AMBULANCE"
    end
    if OtherPlayer ~= nil then
        if Player.PlayerData.job.name == 'police' or Player.PlayerData.job.name == 'doctor' then
            TriggerClientEvent('chatMessage', source, "911 Reply:", "warning", message)
            TriggerClientEvent('chatMessage', OtherPlayer.PlayerData.source, "("..Prefix..") (911) " ..Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname, "error", message)
            TriggerClientEvent("police:client:EmergencySound", OtherPlayer.PlayerData.source)
            TriggerClientEvent("police:client:CallAnim", source)
        end
    end
end)

--doctor

MRFW.Commands.Add("311", "Send a report to emergency services", {{name="message", help="Message you want to send"}}, true, function(source, args)
    local message = table.concat(args, " ")
    local Player = MRFW.Functions.GetPlayer(source)
    local coords = GetEntityCoords(GetPlayerPed(source))
    if Player.Functions.GetItemByName("phone") ~= nil then
        TriggerClientEvent('chatMessage', source, "311 Report:", "warning", message)
        TriggerClientEvent("police:client:SendEmergencyMessages", source, coords, message)
        TriggerEvent("MRlog:server:CreateLog", "311", "311 alert", "blue", "**"..GetPlayerName(source).."** (CitizenID: "..Player.PlayerData.citizenid.." | ID: "..source..") **Alert:** " ..message, false)
    else
        TriggerClientEvent('MRFW:Notify', source, 'You dont have a phone', 'error')
    end
end)

MRFW.Commands.Add("311a", "Send an anonymous report to emergency services (gives no location)", {{name="message", help="Message you want to send"}}, true, function(source, args)
    local message = table.concat(args, " ")
    local Player = MRFW.Functions.GetPlayer(source)

    if Player.Functions.GetItemByName("phone") ~= nil then
        TriggerClientEvent('chatMessage', source, "Anonymous Report:", "warning", message)
        TriggerClientEvent("police:client:CallAnim", source)
        TriggerClientEvent('police:client:Send112AMessage', -1, message)
    else
        TriggerClientEvent('MRFW:Notify', source, 'You dont have a phone', 'error')
    end
end)

MRFW.Commands.Add("311r", "Send a message back to a alert", {{name="id", help="ID of the alert"}, {name="Message", help="Message you want to send"}}, true, function(source, args)
    local Player = MRFW.Functions.GetPlayer(source)
    local OtherPlayer = MRFW.Functions.GetPlayer(tonumber(args[1]))
    table.remove(args, 1)
    local message = table.concat(args, " ")
    local Prefix = "POLICE"
    if Player.PlayerData.job.name == "doctor"  then
        Prefix = "AMBULANCE"
    end
    if OtherPlayer ~= nil then
        if Player.PlayerData.job.name == 'police' or Player.PlayerData.job.name == 'doctor' then
            TriggerClientEvent('chatMessage', source, "311 Reply:", "warning", message)
            TriggerClientEvent('chatMessage', OtherPlayer.PlayerData.source, "("..Prefix..")  (311) " ..Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname, "error", message)
            TriggerClientEvent("police:client:EmergencySound", OtherPlayer.PlayerData.source)
            TriggerClientEvent("police:client:CallAnim", source)
        end
    end
end)

-- Items

MRFW.Functions.CreateUseableItem("handcuffs", function(source, item)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player.Functions.GetItemByName(item.name) then
        TriggerClientEvent("police:client:CuffPlayerSoft", src, 'item')
        Player.Functions.RemoveItem('handcuffs', 1, item.slot)
        TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items["handcuffs"], "remove")
    end
end)

RegisterNetEvent('Police:Server:Give:Cuffs', function()
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    Player.Functions.AddItem('handcuffs', 1)
    TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items["handcuffs"], "add")
end)

MRFW.Functions.CreateUseableItem("bolt_cutter", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if item.info.uses >= 1 then
            TriggerClientEvent("police:client:unnCuffPlayer1", source, item)
        else
            TriggerClientEvent('MRFW:Notify', source, "Broken Bolt Cutter", 'error')
        end
    end
end)

-- MRFW.Functions.CreateUseableItem("keyz", function(source, item)
--     local Player = MRFW.Functions.GetPlayer(source)
-- 	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
--         TriggerClientEvent("police:client:unnCuffPlayer", source)
--     end
-- end)

MRFW.Functions.CreateUseableItem("moneybag", function(source, item)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player.Functions.GetItemByName(item.name) then
        if item.info and item.info ~= "" then
            if Player.PlayerData.job.name ~= "police" then
                if Player.Functions.RemoveItem("moneybag", 1, item.slot) then
                    Player.Functions.AddMoney("cash", tonumber(item.info.cash), "used-moneybag")
                end
            end
        end
    end
end)

-- Callbacks

MRFW.Functions.CreateCallback('police:server:isPlayerDead', function(source, cb, playerId)
    local Player = MRFW.Functions.GetPlayer(playerId)
    cb(Player.PlayerData.metadata["isdead"])
end)

MRFW.Functions.CreateCallback('police:GetPlayerStatus', function(source, cb, playerId)
    local Player = MRFW.Functions.GetPlayer(playerId)
    local statList = {}
    if Player then
        if PlayerStatus[Player.PlayerData.source] and next(PlayerStatus[Player.PlayerData.source]) then
            for k, v in pairs(PlayerStatus[Player.PlayerData.source]) do
                table.insert(statList, PlayerStatus[Player.PlayerData.source][k].text)
            end
        end
    end
    cb(statList)
end)

MRFW.Functions.CreateCallback('police:IsSilencedWeapon', function(source, cb, weapon)
    local Player = MRFW.Functions.GetPlayer(source)
    local itemInfo = Player.Functions.GetItemByName(MRFW.Shared.Weapons[weapon]["name"])
    local retval = false
    if itemInfo ~= nil then
        if itemInfo.info ~= nil and itemInfo.info.attachments ~= nil then
            for k, v in pairs(itemInfo.info.attachments) do
                if itemInfo.info.attachments[k].component == "COMPONENT_AT_AR_SUPP_02" or itemInfo.info.attachments[k].component == "COMPONENT_AT_AR_SUPP" or itemInfo.info.attachments[k].component == "COMPONENT_AT_PI_SUPP_02" or itemInfo.info.attachments[k].component == "COMPONENT_AT_PI_SUPP" or itemInfo.info.attachments[k].component == "COMPONENT_LTL_CLIP_01" then
                    retval = true
                end
            end
        end
    end
    cb(retval)
end)

MRFW.Commands.Add("ebutton", "Send a message back to a notification", {}, false, function(source, args)
    local Player = MRFW.Functions.GetPlayer(source)
    if ((Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "doctor" ) and Player.PlayerData.job.onduty) then
        TriggerClientEvent("police:client:SendPoliceEmergencyAlert", source)
    end
end)

MRFW.Functions.CreateCallback('police:GetDutyPlayers', function(source, cb)
    local dutyPlayers = {}
    local players = MRFW.Functions.GetMRPlayers()
    for k, v in pairs(players) do
        if v.PlayerData.job.name == "police" and v.PlayerData.job.onduty then
            dutyPlayers[#dutyPlayers+1] = {
                source = Player.PlayerData.source,
                label = Player.PlayerData.metadata["callsign"],
                job = Player.PlayerData.job.name
            }
        end
    end
    cb(dutyPlayers)
end)

MRFW.Functions.CreateCallback('police:GetImpoundedVehicles', function(source, cb)
    local vehicles = {}
    MySQL.Async.fetchAll('SELECT * FROM player_vehicles WHERE state = ?', {2}, function(result)
        if result[1] then
            vehicles = result
        end
        cb(vehicles)
    end)
end)

MRFW.Functions.CreateCallback('police:IsPlateFlagged', function(source, cb, plate)
    local retval = false
    if Plates and Plates[plate] then
        if Plates[plate].isflagged then
            retval = true
        end
    end
    cb(retval)
end)

MRFW.Functions.CreateCallback('police:GetCops', function(source, cb)
    local amount = 0
    local players = MRFW.Functions.GetMRPlayers()
    for k, v in pairs(players) do
        if v.PlayerData.job.name == "police" and v.PlayerData.job.onduty then
            amount = amount + 1
        end
    end
    cb(amount)
end)

MRFW.Functions.CreateCallback('police:server:IsPoliceForcePresent', function(source, cb)
    local retval = false
    local players = MRFW.Functions.GetMRPlayers()
    for k, v in pairs(players) do
        if v.PlayerData.job.name == "police" and v.PlayerData.job.grade.level >= 2 then
            retval = true
            break
        end
    end
    cb(retval)
end)

-- Events

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        CreateThread(function()
            MySQL.Async.execute('DELETE FROM stashitems WHERE stash="policetrash"')
        end)
    end
end)

RegisterNetEvent('police:server:policeAlert', function(text)
    local src = source
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    local players = MRFW.Functions.GetMRPlayers()
    for k,v in pairs(players) do
        if v.PlayerData.job.name == 'police' and v.PlayerData.job.onduty then
            local alertData = {title = 'New Call', coords = {coords.x, coords.y, coords.z}, description = text}
            TriggerClientEvent("MRphone:client:addPoliceAlert", v.PlayerData.source, alertData)
            TriggerClientEvent('police:client:policeAlert', v.PlayerData.source, coords, text)
        end
    end
end)

RegisterNetEvent('police:server:TakeOutImpound', function(plate)
    local src = source
    MySQL.Async.execute('UPDATE player_vehicles SET state = ? WHERE plate  = ?', {0, plate})
    TriggerClientEvent('MRFW:Notify', src, "Vehicle unimpounded!", 'success')
end)

RegisterNetEvent('police:server:CuffPlayer', function(playerId, isSoftcuff, item)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local CuffedPlayer = MRFW.Functions.GetPlayer(playerId)
    if CuffedPlayer then
        if item ~= nil then
            if item == 'item' or Player.PlayerData.job.name == "police" then
                TriggerClientEvent("police:client:GetCuffed", CuffedPlayer.PlayerData.source, Player.PlayerData.source, isSoftcuff)
            end
        else
            if Player.Functions.GetItemByName("handcuffs") or Player.PlayerData.job.name == "police" then
                TriggerClientEvent("police:client:GetCuffed", CuffedPlayer.PlayerData.source, Player.PlayerData.source, isSoftcuff)
            end
        end
    end
end)


RegisterNetEvent('police:server:unnCuffPlayer', function(playerId, isSoftcuff)
    local src = source
    local Player = MRFW.Functions.GetPlayer(source)
    local CuffedPlayer = MRFW.Functions.GetPlayer(playerId)
    if CuffedPlayer ~= nil then
        TriggerClientEvent("police:client:unGetCuffed", CuffedPlayer.PlayerData.source, Player.PlayerData.source, isSoftcuff)
    end
end)

RegisterNetEvent('police:server:EscortPlayer', function(playerId)
    local src = source
    local Player = MRFW.Functions.GetPlayer(source)
    local EscortPlayer = MRFW.Functions.GetPlayer(playerId)
    if EscortPlayer then
        if (Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "ambulance") or (EscortPlayer.PlayerData.metadata["ishandcuffed"] or EscortPlayer.PlayerData.metadata["isdead"] or EscortPlayer.PlayerData.metadata["inlaststand"]) then
            TriggerClientEvent("police:client:GetEscorted", EscortPlayer.PlayerData.source, Player.PlayerData.source)
        else
            TriggerClientEvent('MRFW:Notify', src, "Civilian isn't cuffed or dead", 'error')
        end
    end
end)

RegisterNetEvent('police:server:KidnapPlayer', function(playerId)
    local src = source
    local Player = MRFW.Functions.GetPlayer(source)
    local EscortPlayer = MRFW.Functions.GetPlayer(playerId)
    if EscortPlayer then
        if EscortPlayer.PlayerData.metadata["ishandcuffed"] or EscortPlayer.PlayerData.metadata["isdead"] or
            EscortPlayer.PlayerData.metadata["inlaststand"] then
            TriggerClientEvent("police:client:GetKidnappedTarget", EscortPlayer.PlayerData.source, Player.PlayerData.source)
            TriggerClientEvent("police:client:GetKidnappedDragger", Player.PlayerData.source, EscortPlayer.PlayerData.source)
        else
            TriggerClientEvent('MRFW:Notify', src, "Civilian isn't cuffed or dead", 'error')
        end
    end
end)

RegisterNetEvent('police:server:SetPlayerOutVehicle', function(playerId)
    local src = source
    local Player = MRFW.Functions.GetPlayer(source)
    local EscortPlayer = MRFW.Functions.GetPlayer(playerId)
    if EscortPlayer then
        if EscortPlayer.PlayerData.metadata["ishandcuffed"] or EscortPlayer.PlayerData.metadata["isdead"] or EscortPlayer.PlayerData.metadata["inlaststand"] then
            TriggerClientEvent("police:client:SetOutVehicle", EscortPlayer.PlayerData.source)
        else
            TriggerClientEvent('MRFW:Notify', src, "Civilian isn't cuffed or dead", 'error')
        end
    end
end)

RegisterNetEvent('police:server:PutPlayerInVehicle', function(playerId)
    local src = source
    local EscortPlayer = MRFW.Functions.GetPlayer(playerId)
    if EscortPlayer then
        if EscortPlayer.PlayerData.metadata["ishandcuffed"] or EscortPlayer.PlayerData.metadata["isdead"] or EscortPlayer.PlayerData.metadata["inlaststand"]then
            TriggerClientEvent("police:client:PutInVehicle", EscortPlayer.PlayerData.source)
        else
           TriggerClientEvent('MRFW:Notify', src, "Civilian isn't cuffed or dead", 'error')
        end
    end
end)

RegisterNetEvent('police:server:BillPlayer', function(playerId, amount)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local OtherPlayer = MRFW.Functions.GetPlayer(playerId)
    local fname = Player.PlayerData.charinfo.firstname
    local lname = Player.PlayerData.charinfo.lastname
    if Player.PlayerData.job.name == "police" then
        if OtherPlayer then
            OtherPlayer.Functions.RemoveMoney("bank", amount, "paid-bills")
            TriggerEvent('MRbossmenu:server:addAccountMoney', "police", amount)
            TriggerClientEvent('MRFW:Notify', OtherPlayer.PlayerData.source, "You received a fine of $" .. amount)
            --TriggerClientEvent('police:client:sendBillingMail', OtherPlayer.PlayerData.source , amount , fname , lname)
        end
    end
end)

MRFW.Commands.Add("fine", "Give Fine To Person", {{name="id", help="Player ID"},{name="amount", help="Amount"}}, true, function(source, args)
	local Player = MRFW.Functions.GetPlayer(source)
    local target = MRFW.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.job.name == "police" then
        if target then
            local playerId = tonumber(args[1])
            local amount = tonumber(args[2])
            if amount > 0 then
                TriggerEvent("MRlog:server:CreateLog'", 'fine', "Fine", "blue", "**Source**: "..Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname..'\n**Target**: '..target.PlayerData.charinfo.firstname..' '..target.PlayerData.charinfo.lastname..'\n**Fine**: '..amount, false, "author name",  "author icon url")
                TriggerClientEvent('MRFW:Notify', source, "You gave a fine of $" .. amount)
                TriggerClientEvent("police:client:BillCommand", source, playerId, amount)
                TriggerClientEvent('MRmoneysafepolice:client:DepositMoney', playerId , amount)
            else
                TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Amount must be higher then 0")
            end
        else
            TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Player is not online")
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "This command is for emergency services!")
    end
end, 'police')

RegisterNetEvent('police:server:JailPlayer', function(playerId, time)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local OtherPlayer = MRFW.Functions.GetPlayer(playerId)
    local currentDate = os.date("*t")
    if currentDate.day == 31 then
        currentDate.day = 30
    end

    if Player.PlayerData.job.name == "police" then
        if OtherPlayer then
            OtherPlayer.Functions.SetMetaData("injail", time)
            OtherPlayer.Functions.SetMetaData("criminalrecord", {
                ["hasRecord"] = true,
                ["date"] = currentDate
            })
            TriggerClientEvent("police:client:SendToJail", OtherPlayer.PlayerData.source, time)
            TriggerClientEvent('MRFW:Notify', src, "You sent the person to prison for " .. time .. " months")
        end
    end
end)

RegisterNetEvent('police:server:SetHandcuffStatus', function(isHandcuffed)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player then
        Player.Functions.SetMetaData("ishandcuffed", isHandcuffed)
    end
end)

RegisterNetEvent('heli:spotlight', function(state)
    local serverID = source
    TriggerClientEvent('heli:spotlight', -1, serverID, state)
end)

-- RegisterNetEvent('police:server:FlaggedPlateTriggered', function(camId, plate, street1, street2, blipSettings)
--     local src = source
--     for k, v in pairs(MRFW.Functions.GetPlayers()) do
--         local Player = MRFW.Functions.GetPlayer(v)
--         if Player then
--             if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
--                 if street2 then
--                     TriggerClientEvent("112:client:SendPoliceAlert", v, "flagged", {
--                         camId = camId,
--                         plate = plate,
--                         streetLabel = street1 .. " " .. street2
--                     }, blipSettings)
--                 else
--                     TriggerClientEvent("112:client:SendPoliceAlert", v, "flagged", {
--                         camId = camId,
--                         plate = plate,
--                         streetLabel = street1
--                     }, blipSettings)
--                 end
--             end
--         end
--     end
-- end)

RegisterNetEvent('police:server:SearchPlayer', function(playerId)
    local src = source
    local SearchedPlayer = MRFW.Functions.GetPlayer(playerId)
    if SearchedPlayer then
        TriggerClientEvent('MRFW:Notify', src, 'Found $'..SearchedPlayer.PlayerData.money["cash"]..' on the civilian')
        TriggerClientEvent('MRFW:Notify', SearchedPlayer.PlayerData.source, "You are being searched")
    end
end)

RegisterNetEvent('police:server:SeizeCash', function(playerId)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local SearchedPlayer = MRFW.Functions.GetPlayer(playerId)
    if SearchedPlayer then
        local moneyAmount = SearchedPlayer.PlayerData.money["cash"]
        local info = { cash = moneyAmount }
        SearchedPlayer.Functions.RemoveMoney("cash", moneyAmount, "police-cash-seized")
        Player.Functions.AddItem("moneybag", 1, false, info)
        TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items["moneybag"], "add")
        TriggerClientEvent('MRFW:Notify', SearchedPlayer.PlayerData.source, 'Your cash was confiscated')
    end
end)

RegisterNetEvent('police:server:SeizeDriverLicense', function(playerId)
    local src = source
    local SearchedPlayer = MRFW.Functions.GetPlayer(playerId)
    if SearchedPlayer then
        local driverLicense = SearchedPlayer.PlayerData.metadata["licences"]["driver"]
        if driverLicense then
            local licenses = {["driver"] = false, ["business"] = SearchedPlayer.PlayerData.metadata["licences"]["business"]}
            SearchedPlayer.Functions.SetMetaData("licences", licenses)
            TriggerClientEvent('MRFW:Notify', SearchedPlayer.PlayerData.source, 'Your driving license has been confiscated')
        else
            TriggerClientEvent('MRFW:Notify', src, 'No drivers license', 'error')
        end
    end
end)

RegisterNetEvent('police:server:RobPlayer', function(playerId)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local SearchedPlayer = MRFW.Functions.GetPlayer(playerId)
    if SearchedPlayer then
        local money = SearchedPlayer.PlayerData.money["cash"]
        Player.Functions.AddMoney("cash", money, "police-player-robbed")
        SearchedPlayer.Functions.RemoveMoney("cash", money, "police-player-robbed")
        TriggerClientEvent('MRFW:Notify', SearchedPlayer.PlayerData.source, "You have been robbed of $" .. money)
        TriggerClientEvent('MRFW:Notify', Player.PlayerData.source, "You have stolen $" .. money)
    end
end)

RegisterNetEvent('police:server:UpdateBlips', function()
    -- KEEP FOR REF BUT NOT NEEDED ANYMORE.
end)

RegisterNetEvent('police:server:spawnObject', function(type)
    local src = source
    local objectId = CreateObjectId()
    Objects[objectId] = type
    TriggerClientEvent("police:client:spawnObject", src, objectId, type, src)
end)

RegisterNetEvent('police:server:deleteObject', function(objectId)
    TriggerClientEvent('police:client:removeObject', -1, objectId)
end)

RegisterNetEvent('police:server:Impound', function(plate, fullImpound, price, body, engine, fuel)
    local src = source
    local price = price and price or 0
    if IsVehicleOwned(plate) then
        if not fullImpound then
            MySQL.Async.execute(
                'UPDATE player_vehicles SET state = ?, depotprice = ?, body = ?, engine = ?, fuel = ? WHERE plate = ?',
                {0, price, body, engine, fuel, plate})
            TriggerClientEvent('MRFW:Notify', src, "Vehicle taken into depot for $" .. price .. "!")
        else
            MySQL.Async.execute(
                'UPDATE player_vehicles SET state = ?, body = ?, engine = ?, fuel = ? WHERE plate = ?',
                {2, body, engine, fuel, plate})
            TriggerClientEvent('MRFW:Notify', src, "Vehicle seized")
        end
    end
end)

RegisterNetEvent('evidence:server:UpdateStatus', function(data)
    local src = source
    PlayerStatus[src] = data
end)

RegisterNetEvent('evidence:server:CreateBloodDrop', function(citizenid, bloodtype, coords)
    local bloodId = CreateBloodId()
    BloodDrops[bloodId] = {
        dna = citizenid,
        bloodtype = bloodtype
    }
    TriggerClientEvent("evidence:client:AddBlooddrop", -1, bloodId, citizenid, bloodtype, coords)
end)

RegisterNetEvent('evidence:server:CreateFingerDrop', function(coords)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local fingerId = CreateFingerId()
    FingerDrops[fingerId] = Player.PlayerData.metadata["fingerprint"]
    TriggerClientEvent("evidence:client:AddFingerPrint", -1, fingerId, Player.PlayerData.metadata["fingerprint"], coords)
end)

RegisterNetEvent('evidence:server:ClearBlooddrops', function(blooddropList)
    if blooddropList and next(blooddropList) then
        for k, v in pairs(blooddropList) do
            TriggerClientEvent("evidence:client:RemoveBlooddrop", -1, v)
            BloodDrops[v] = nil
        end
    end
end)

RegisterNetEvent('evidence:server:AddBlooddropToInventory', function(bloodId, bloodInfo)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem("empty_evidence_bag", 1) then
        if Player.Functions.AddItem("filled_evidence_bag", 1, false, bloodInfo) then
            TriggerClientEvent("inventory:client:ItemBox", src, MRFW.Shared.Items["filled_evidence_bag"], "add")
            TriggerClientEvent("evidence:client:RemoveBlooddrop", -1, bloodId)
            BloodDrops[bloodId] = nil
        end
    else
        TriggerClientEvent('MRFW:Notify', src, "You must have an empty evidence bag with you", "error")
    end
end)

RegisterNetEvent('evidence:server:AddFingerprintToInventory', function(fingerId, fingerInfo)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem("empty_evidence_bag", 1) then
        if Player.Functions.AddItem("filled_evidence_bag", 1, false, fingerInfo) then
            TriggerClientEvent("inventory:client:ItemBox", src, MRFW.Shared.Items["filled_evidence_bag"], "add")
            TriggerClientEvent("evidence:client:RemoveFingerprint", -1, fingerId)
            FingerDrops[fingerId] = nil
        end
    else
        TriggerClientEvent('MRFW:Notify', src, "You must have an empty evidence bag with you", "error")
    end
end)

RegisterNetEvent('evidence:server:CreateCasing', function(weapon, coords)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local casingId = CreateCasingId()
    local weaponInfo = MRFW.Shared.Weapons[weapon]
    local serieNumber = nil
    if weaponInfo then
        local weaponItem = Player.Functions.GetItemByName(weaponInfo["name"])
        if weaponItem then
            if weaponItem.info and weaponItem.info ~= "" then
                serieNumber = weaponItem.info.serie
            end
        end
    end
    TriggerClientEvent("evidence:client:AddCasing", -1, casingId, weapon, coords, serieNumber)
end)

RegisterNetEvent('police:server:UpdateCurrentCops', function()
    local amount = 0
    local players = MRFW.Functions.GetMRPlayers()
    for k, v in pairs(players) do
        if v.PlayerData.job.name == "police" and v.PlayerData.job.onduty then
            amount = amount + 1
        end
    end
    TriggerClientEvent("police:SetCopCount", -1, amount)
end)

RegisterNetEvent('evidence:server:ClearCasings', function(casingList)
    if casingList and next(casingList) then
        for k, v in pairs(casingList) do
            TriggerClientEvent("evidence:client:RemoveCasing", -1, v)
            Casings[v] = nil
        end
    end
end)

RegisterNetEvent('evidence:server:AddCasingToInventory', function(casingId, casingInfo)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem("empty_evidence_bag", 1) then
        if Player.Functions.AddItem("filled_evidence_bag", 1, false, casingInfo) then
            TriggerClientEvent("inventory:client:ItemBox", src, MRFW.Shared.Items["filled_evidence_bag"], "add")
            TriggerClientEvent("evidence:client:RemoveCasing", -1, casingId)
            Casings[casingId] = nil
        end
    else
        TriggerClientEvent('MRFW:Notify', src, "You must have an empty evidence bag with you", "error")
    end
end)

RegisterNetEvent('police:server:showFingerprint', function(playerId)
    local src = source
    TriggerClientEvent('police:client:showFingerprint', playerId, src)
    TriggerClientEvent('police:client:showFingerprint', src, playerId)
end)

RegisterNetEvent('police:server:showFingerprintId', function(sessionId)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local fid = Player.PlayerData.metadata["fingerprint"]
    local fname = Player.PlayerData.charinfo.firstname
    local lname = Player.PlayerData.charinfo.lastname
    TriggerClientEvent('police:client:showFingerprintId', sessionId, fid)
    TriggerClientEvent('police:client:showFingerprintId', src, fid)
    TriggerClientEvent('police:client:sendBillingMail2', sessionId , fid , fname , lname)
end)

RegisterNetEvent('police:server:SetTracker', function(targetId)
    local src = source
    local Target = MRFW.Functions.GetPlayer(targetId)
    local TrackerMeta = Target.PlayerData.metadata["tracker"]
    if TrackerMeta then
        Target.Functions.SetMetaData("tracker", false)
        TriggerClientEvent('MRFW:Notify', targetId, 'Your anklet is taken off.', 'error', 5000)
        TriggerClientEvent('MRFW:Notify', src, 'You took off an ankle bracelet from ' .. Target.PlayerData.charinfo.firstname .. " " .. Target.PlayerData.charinfo.lastname, 'error', 5000)
        TriggerClientEvent('police:client:SetTracker', targetId, false)
    else
        Target.Functions.SetMetaData("tracker", true)
        TriggerClientEvent('MRFW:Notify', targetId, 'You put on an ankle strap.', 'error', 5000)
        TriggerClientEvent('MRFW:Notify', src, 'You put on an ankle strap to ' .. Target.PlayerData.charinfo.firstname .. " " .. Target.PlayerData.charinfo.lastname, 'error', 5000)
        TriggerClientEvent('police:client:SetTracker', targetId, true)
    end
end)

RegisterNetEvent('police:server:SendTrackerLocation', function(coords, requestId)
    local Target = MRFW.Functions.GetPlayer(source)
    local msg = "The location of " .. Target.PlayerData.charinfo.firstname .. " " .. Target.PlayerData.charinfo.lastname .. " is marked on your map."
    local alertData = {
        title = "Anklet location",
        coords = {
            x = coords.x,
            y = coords.y,
            z = coords.z
        },
        description = msg
    }
    TriggerClientEvent("police:client:TrackerMessage", requestId, msg, coords)
    TriggerClientEvent("MRphone:client:addPoliceAlert", requestId, alertData)
end)

RegisterNetEvent('police:server:SyncSpikes', function(table)
    TriggerClientEvent('police:client:SyncSpikes', -1, table)
end)

-- Threads

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000 * 60 * 10)
        local curCops = GetCurrentCops()
        TriggerClientEvent("police:SetCopCount", -1, curCops)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)
        UpdateBlips()
    end
end)


RegisterServerEvent('police:server:OverspeedCall')
AddEventHandler('police:server:OverspeedCall', function(pos, msg, alertTitle, streetLabel, modelPlate, modelName)
    local src = source
    local alertData = {
        title = "Vehicle Overspeed",
        coords = {x = pos.x, y = pos.y, z = pos.z},
        description = msg,
    }
    --print(streetLabel)
    TriggerClientEvent("police:client:OverspeedCall", -1, pos, alertTitle, streetLabel, modelPlate, modelName)
    TriggerClientEvent("MRphone:client:addPoliceAlert", -1, alertData)
end)


RegisterServerEvent('police:server:PoliceAlertMessage')
AddEventHandler('police:server:PoliceAlertMessage', function(title, streetLabel, coords)
    local src = source

    for k, v in pairs(MRFW.Functions.GetPlayers()) do
        local Player = MRFW.Functions.GetPlayer(v)
        if Player ~= nil then 
            if ((Player.PlayerData.job.name == "police") and Player.PlayerData.job.onduty) then
                TriggerClientEvent("police:client:PoliceAlertMessage", v, title, streetLabel, coords)
            elseif Player.Functions.GetItemByName("radioscanner") ~= nil and math.random(1, 100) <= 50 then
                TriggerClientEvent("police:client:PoliceAlertMessage", v, title, streetLabel, coords)
            end
        end
    end
end)

-- RegisterServerEvent('police:server:GunshotAlert')
-- AddEventHandler('police:server:GunshotAlert', function(streetLabel, isAutomatic, fromVehicle, coords, vehicleInfo)
--     local src = source
--     local alertData = {
--         title = "10-13 | Shots fired",
--         coords = {x = coords.x, y = coords.y, z = coords.z},
--         description = streetLabel,
--     }

--     for k, v in pairs(MRFW.Functions.GetPlayers()) do
--         local Player = MRFW.Functions.GetPlayer(v)
--         if Player ~= nil then 
--             if ((Player.PlayerData.job.name == "police") and Player.PlayerData.job.onduty) then
--                 TriggerClientEvent("police:client:GunShotAlert", Player.PlayerData.source, streetLabel, isAutomatic, fromVehicle, coords, vehicleInfo)
--                 TriggerClientEvent("MRphone:client:addPoliceAlert", -1, alertData)
--             elseif Player.Functions.GetItemByName("radioscanner") ~= nil and math.random(1, 100) <= 50 then
--                 TriggerClientEvent("police:client:GunShotAlert", Player.PlayerData.source, streetLabel, isAutomatic, fromVehicle, coords, vehicleInfo)
--             end
--         end
--     end
-- end)

-- RegisterServerEvent('police:server:GunshotAlert2')
-- AddEventHandler('police:server:GunshotAlert2', function(streetLabel, isAutomatic, fromVehicle, coords, vehicleInfo)
--     local src = source
--     local alertData = {
--         title = "10-13 | Friendly Shots fired",
--         coords = {x = coords.x, y = coords.y, z = coords.z},
--         description = streetLabel,
--     }

--     for k, v in pairs(MRFW.Functions.GetPlayers()) do
--         local Player = MRFW.Functions.GetPlayer(v)
--         if Player ~= nil then 
--             if ((Player.PlayerData.job.name == "police") and Player.PlayerData.job.onduty) then
--                 TriggerClientEvent("police:client:GunShotAlert2", Player.PlayerData.source, streetLabel, isAutomatic, fromVehicle, coords, vehicleInfo)
--                 TriggerClientEvent("MRphone:client:addPoliceAlert", -1, alertData)
--             elseif Player.Functions.GetItemByName("radioscanner") ~= nil and math.random(1, 100) <= 50 then
--                 TriggerClientEvent("police:client:GunShotAlert2", Player.PlayerData.source, streetLabel, isAutomatic, fromVehicle, coords, vehicleInfo)
--             end
--         end
--     end
-- end)

RegisterServerEvent('police:server:VehicleCall')
AddEventHandler('police:server:VehicleCall', function(pos, msg, alertTitle, streetLabel, modelPlate, modelName, vehicle)
    local src = source
    local alertData = {
        title = "10-60 | Vehicle theft",
        coords = {x = pos.x, y = pos.y, z = pos.z},
        description = msg,
    }
    local coords = {x = pos.x, y = pos.y, z = pos.z}
    -- local vehicle = MRFW.Functions.GetClosestVehicle()
    --print(streetLabel)
    TriggerClientEvent("police:client:VehicleCall", source, coords, alertTitle, streetLabel, modelPlate, modelName, vehicle)
    TriggerClientEvent("MRphone:client:addPoliceAlert", -1, alertData)
end)

RegisterServerEvent('police:server:HouseRobberyCall')
AddEventHandler('police:server:HouseRobberyCall', function(coords, message, gender, streetLabel)
    local src = source
    local alertData = {
        title = "10-90D | Burglary",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = message,
    }
    TriggerClientEvent("police:client:HouseRobberyCall", source, coords, message, gender, streetLabel)
    TriggerClientEvent("MRphone:client:addPoliceAlert", -1, alertData)
end)

RegisterServerEvent('police:server:SendEmergencyMessage')
AddEventHandler('police:server:SendEmergencyMessage', function(coords, message)
    local src = source
    local MainPlayer = MRFW.Functions.GetPlayer(src)
    local alertData = {
        title = "911 alert - "..MainPlayer.PlayerData.charinfo.firstname .. " " .. MainPlayer.PlayerData.charinfo.lastname .. " ("..src..")",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = message,
    }
    -- print(message)

    TriggerClientEvent("MRphone:client:addPoliceAlert", -1, alertData)
    TriggerClientEvent('police:server:SendEmergencyMessageCheck', -1, MainPlayer, message, coords)
end)

RegisterServerEvent('police:server:SendEmergencyMessages')
AddEventHandler('police:server:SendEmergencyMessages', function(coords, message)
    local src = source
    local MainPlayer = MRFW.Functions.GetPlayer(src)
    local alertData = {
        title = "311 alert - "..MainPlayer.PlayerData.charinfo.firstname .. " " .. MainPlayer.PlayerData.charinfo.lastname .. " ("..src..")",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = message,
    }
    TriggerClientEvent("MRphone:client:addPoliceAlert", -1, alertData)
    TriggerClientEvent('police:server:SendEmergencyMessageChecks', -1, MainPlayer, message, coords)
end)

RegisterServerEvent('police:server:SendPoliceEmergencyAlert')
AddEventHandler('police:server:SendPoliceEmergencyAlert', function(streetLabel, coords, callsign)
    local alertData = {
        title = "Assistance colleague",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = "Emergency button pressed by ".. callsign .. " at "..streetLabel,
    }
    TriggerClientEvent("police:client:PoliceEmergencyAlert", -1, callsign, streetLabel, coords)
    TriggerClientEvent("MRphone:client:addPoliceAlert", -1, alertData)
end)

RegisterServerEvent('police:server:gunhiestalert')
AddEventHandler('police:server:gunhiestalert', function(streetLabel, coords)
    local src = source
	local Player = MRFW.Functions.GetPlayer(src)
    local alertData = {
        title = "Suspicious Activity",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = "Suspicious Activity found at "..streetLabel,
    }
    TriggerClientEvent("police:client:gunhiestalert", -1, streetLabel, coords)
    TriggerClientEvent("MRphone:client:addPoliceAlert", -1, alertData)
    -- if Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then
    --     TriggerClientEvent('chatMessage', -1, "SYSTEM", "error", "Gun Dealing In Progress")
    -- end
    TriggerClientEvent("police:client:gunalert", -1, streetLabel)
end)

function IsHighCommand(citizenid)
    local retval = false
    for k, v in pairs(Config.ArmoryWhitelist) do
        if v == citizenid then
            retval = true
        end
    end
    return retval
end

MRFW.Commands.Add('livery', 'Set vehicle livery (Emergency Only)', {}, false, function(source, args)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local livery = tonumber(args[1])

    if Player and Player.PlayerData.job.name == "doctor" then
        if Player then
            TriggerClientEvent('police:livery', src, livery)
        else
            TriggerClientEvent('chat:addMessage', src, {
                template = '<div class="chat-message server">SYSTEM: {0}</div>',
                args = { 'This command is for emergency services!' }
            })
        end
    else
        TriggerClientEvent('chat:addMessage', src, {
            template = '<div class="chat-message server">Usage /livery [Number]</div>',
        })
    end
end,'doctor')

MRFW.Commands.Add('extras', 'Set vehicle Extras (Emergency Only)', {{name="extra", help="all / remove / 1-12"}}, false, function(source, args)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local extra = tonumber(args[1])

    if Player and Player.PlayerData.job.name == "doctor" then
        if args[1] then
            if Player then
                TriggerClientEvent('police:extras', src, extra ~= nil and extra or args[1])
            else
                TriggerClientEvent('chat:addMessage', src, {
                    template = '<div class="chat-message server">SYSTEM: {0}</div>',
                    args = { 'This command is for emergency services!' }
                })
            end
        end
    else
        TriggerClientEvent('chat:addMessage', src, {
            template = '<div class="chat-message server">Usage /livery [Number]</div>',
        })
    end
end,'doctor')

MRFW.Commands.Add('plivery', 'Set vehicle livery (Emergency Only)', {}, false, function(source, args)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local livery = tonumber(args[1])

    if Player and Player.PlayerData.job.name == "police" and Player.PlayerData.job.grade.level >= 8 then
        if Player then
            TriggerClientEvent('police:livery2', src, livery)
        else
            TriggerClientEvent('chat:addMessage', src, {
                template = '<div class="chat-message server">SYSTEM: {0}</div>',
                args = { 'This command is for emergency services!' }
            })
        end
    else
        TriggerClientEvent('chat:addMessage', src, {
            template = '<div class="chat-message server">Usage /livery [Number]</div>',
        })
    end
end,'police')

MRFW.Commands.Add('pextras', 'Set vehicle Extras (Emergency Only)', {{name="extra", help="all / remove / 1-12"}}, false, function(source, args)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local extra = tonumber(args[1])

    if Player and Player.PlayerData.job.name == "police" and Player.PlayerData.job.grade.level >= 8 then
        if args[1] then
            if Player then
                TriggerClientEvent('police:extras2', src, extra ~= nil and extra or args[1])
            else
                TriggerClientEvent('chat:addMessage', src, {
                    template = '<div class="chat-message server">SYSTEM: {0}</div>',
                    args = { 'This command is for emergency services!' }
                })
            end
        end
    else
        TriggerClientEvent('chat:addMessage', src, {
            template = '<div class="chat-message server">Usage /livery [Number]</div>',
        })
    end
end,'police')

MRFW.Commands.Add('pfix', 'Fix Vehicle (Emergency Only)', {}, false, function(source, args)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local money = Player.PlayerData.money['bank']
    if Player and (Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "doctor" ) then
        if money >= 250 then
            TriggerClientEvent('police:fix', src)
        else
            TriggerClientEvent("MRFW:Notify", src, "Not Enough Money", "error", 3000)
        end
    else
        TriggerClientEvent('chat:addMessage', src, {
            template = '<div class="chat-message server">SYSTEM: {0}</div>',
            args = { 'This command is for emergency services!' }
        })
    end
    
end)

RegisterNetEvent('police:fix:cutMoney', function()
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    Player.Functions.RemoveMoney("bank", 750)
end)

-- MRFW.Commands.Add('ptint', 'Set Tint (Emergency Only)', {}, false, function(source, args)
--     local src = source
--     local Player = MRFW.Functions.GetPlayer(src)
--     if Player and (Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "doctor" ) then
--         TriggerClientEvent('police:windowtint', src, tonumber(args[1]))
--     else
--         TriggerClientEvent('chat:addMessage', src, {
--             template = '<div class="chat-message server">SYSTEM: {0}</div>',
--             args = { 'This command is for emergency services!' }
--         })
--     end
    
-- end)

MRFW.Functions.CreateCallback('police:callback:searchbag', function(source, cb, target)
    local Player = MRFW.Functions.GetPlayer(target)
    local callback = nil
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then
		for k, v in pairs(Player.PlayerData.items) do
		    if Player.PlayerData.items[k] ~= nil then
				if Player.PlayerData.items[k].name == "bag" then
                    callback = Player.PlayerData.items[k].info.unit
				end
	        end
		end	
	end
    cb(callback)
end)

MRFW.Functions.CreateCallback('police:callback:searchbag2', function(source, cb, target)
    local Player = MRFW.Functions.GetPlayer(target)
    local callback = nil
    if Player then
        if Player.PlayerData.metadata["isdead"] then
            if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then
                for k, v in pairs(Player.PlayerData.items) do
                    if Player.PlayerData.items[k] ~= nil then
                        if Player.PlayerData.items[k].name == "bag" then
                            callback = Player.PlayerData.items[k].info.unit
                        end
                    end
                end	
            end
        end	
    end
    cb(callback)
end)