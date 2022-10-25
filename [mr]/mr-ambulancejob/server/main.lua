local PlayerInjuries = {}
local PlayerWeaponWounds = {}
local MRFW = exports['mrfw']:GetCoreObject()
-- Events

-- Compatibility with txAdmin Menu's heal options.
-- This is a admin only server side event that will pass the target player id.
-- (This can also contain -1)

MRFW.Functions.CreateCallback('jacob:server:checkDoctor', function(source, cb)
    local AmbulanceCount = 0
    
    for k, v in pairs(MRFW.Functions.GetPlayers()) do
        local Player = MRFW.Functions.GetPlayer(v)
        if Player ~= nil then
            if ((Player.PlayerData.job.name == "doctor") and Player.PlayerData.job.onduty) then
                AmbulanceCount = AmbulanceCount + 1
            end
        end
    end

    cb(AmbulanceCount)
end)
AddEventHandler('txAdmin:events:healedPlayer', function(eventData)
	if
		GetInvokingResource() ~= "monitor" or 
		type(eventData) ~= "table" or
		type(eventData.id) ~= "number" 
	then
		return
	end

	TriggerClientEvent('hospital:client:Revive', eventData.id)
	TriggerClientEvent("hospital:client:HealInjuries", eventData.id, "full")
end)

RegisterNetEvent('hospital:server:SendToBed2', function(bedId)
	local src = source
	TriggerClientEvent('hospital:client:SendToBed2', src, bedId, Config.Locations["beds"][bedId])
	TriggerClientEvent('hospital:client:SetBed', -1, bedId, true)
end)

RegisterNetEvent('hospital:server:SendToBed', function(bedId, isRevive)
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	TriggerClientEvent('hospital:client:SendToBed', src, bedId, Config.Locations["beds"][bedId], isRevive)
	TriggerClientEvent('hospital:client:SetBed', -1, bedId, true)
	-- Player.Functions.RemoveMoney("bank", Config.BillCost , "respawned-at-hospital")
	-- TriggerEvent('mr-bossmenu:server:addAccountMoney', "doctor", Config.BillCost)
	-- TriggerClientEvent('hospital:client:SendBillEmail', src, Config.BillCost)
end)

RegisterNetEvent('hospital:server:SendToBedcheckin', function(bedId, isRevive)
	local src = source
	TriggerClientEvent('hospital:client:SendToBedcheckin', src, bedId, Config.Locations["beds"][bedId], isRevive)
	TriggerClientEvent('hospital:client:SetBed', -1, bedId, true)
end)

RegisterNetEvent('hospital:pay', function()
    local src = source
    local ply = MRFW.Functions.GetPlayer(src)
	local cashamount = ply.PlayerData.money["bank"]
	if cashamount >= 700  then
		ply.Functions.RemoveMoney("bank", 700, "respawned-at-hospital")
		TriggerClientEvent('hospital:client:Sendcheckemail',src)
	end
end)

RegisterNetEvent('hospital:server:RespawnAtHospital', function()
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	if Player.PlayerData.metadata["injail"] > 0 then
		for k, v in pairs(Config.Locations["jailbeds"]) do
			TriggerClientEvent('hospital:client:SendToBed', src, k, v, true)
			TriggerClientEvent('hospital:client:SetBed2', -1, k, true)
			if Config.WipeInventoryOnRespawn then
				Player.Functions.ClearInventory()
				MySQL.Async.execute('UPDATE players SET inventory = ? WHERE citizenid = ?', { json.encode({}), Player.PlayerData.citizenid })
				TriggerClientEvent('MRFW:Notify', src, 'All your possessions have been taken..', 'error')
			end
			Player.Functions.RemoveMoney("bank", Config.BillCost, "respawned-at-hospital")
			TriggerEvent('mr-bossmenu:server:addAccountMoney', "doctor", Config.BillCost)
			TriggerClientEvent('hospital:client:SendBillEmail', src, Config.BillCost)
			return
		end
	else
		for k, v in pairs(Config.Locations["beds"]) do
			TriggerClientEvent('hospital:client:SendToBed', src, k, v, true)
			TriggerClientEvent('hospital:client:SetBed', -1, k, true)
			if Config.WipeInventoryOnRespawn then
				Player.Functions.ClearInventory()
				MySQL.Async.execute('UPDATE players SET inventory = ? WHERE citizenid = ?', { json.encode({}), Player.PlayerData.citizenid })
				TriggerClientEvent('MRFW:Notify', src, 'All your possessions have been taken..', 'error')
			end
			Player.Functions.RemoveMoney("bank", Config.BillCost, "respawned-at-hospital")
			TriggerEvent('mr-bossmenu:server:addAccountMoney', "doctor", Config.BillCost)
			TriggerClientEvent('hospital:client:SendBillEmail', src, Config.BillCost)
			return
		end
	end
end)

RegisterNetEvent('hospital:server:ambulanceAlert', function(text)
    local src = source
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    local players = MRFW.Functions.GetMR-Players()
    for k,v in pairs(players) do
        if v.PlayerData.job.name == 'doctor' and v.PlayerData.job.onduty then
            TriggerClientEvent('hospital:client:ambulanceAlert', v.PlayerData.source, coords, text)
        end
    end
end)

RegisterNetEvent('hospital:server:LeaveBed', function(id)
    TriggerClientEvent('hospital:client:SetBed', -1, id, false)
end)

RegisterNetEvent('hospital:server:SyncInjuries', function(data)
    local src = source
    PlayerInjuries[src] = data
end)


RegisterNetEvent('hospital:server:SetWeaponDamage', function(data)
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	if Player then
		PlayerWeaponWounds[Player.PlayerData.source] = data
	end
end)

RegisterNetEvent('hospital:server:RestoreWeaponDamage', function()
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	PlayerWeaponWounds[Player.PlayerData.source] = nil
end)

RegisterNetEvent('hospital:server:SetDeathStatus', function(isDead)
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	if Player then
		Player.Functions.SetMetaData("isdead", isDead)
	end
end)

RegisterNetEvent('hospital:server:SetLaststandStatus', function(bool)
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	if Player then
		Player.Functions.SetMetaData("inlaststand", bool)
	end
end)

RegisterNetEvent('hospital:server:SetArmor', function(amount)
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	if Player then
		Player.Functions.SetMetaData("armor", amount)
	end
end)

RegisterNetEvent('hospital:server:TreatWounds', function(playerId)
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	local Patient = MRFW.Functions.GetPlayer(playerId)
	if Patient then
		if Player.PlayerData.job.name =="doctor" then
			Player.Functions.RemoveItem('bandage', 1)
			TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items['bandage'], "remove")
			TriggerClientEvent("hospital:client:HealInjuries", Patient.PlayerData.source, "full")
		end
	end
end)

RegisterNetEvent('hospital:server:SetDoctor', function()
	local amount = 0
    local players = MRFW.Functions.GetMR-Players()
    for k,v in pairs(players) do
        if v.PlayerData.job.name == 'doctor' and v.PlayerData.job.onduty then
            amount = amount + 1
        end
	end
	TriggerClientEvent("hospital:client:SetDoctorCount", -1, amount)
end)

RegisterNetEvent('hospital:server:SetDoctorSign', function(value)
	signindoo = value

	TriggerClientEvent("hospital:client:SetSignDoc", -1, signindoo)
end)

RegisterNetEvent('hospital:server:RevivePlayer', function(playerId, isOldMan)
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	local Patient = MRFW.Functions.GetPlayer(playerId)
	local oldMan = isOldMan or false
	if Patient then
		if oldMan then
			if Player.Functions.RemoveMoney("cash", 2000, "revived-player") then
				TriggerClientEvent('hospital:client:Revive', Patient.PlayerData.source)
				Player.Functions.RemoveItem('cprkit', 1)
				TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items['cprkit'], "remove")
			else
				TriggerClientEvent('MRFW:Notify', src, "You don\'t have enough money on you..", "error")
			end
		else
			TriggerClientEvent('hospital:client:Revive', Patient.PlayerData.source)
			Player.Functions.RemoveItem('cprkit', 1)
			TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items['cprkit'], "remove")
		end
	end
end)

-- MRFW.Commands.Add('doctortest', 'help text here', {}, false, function(source, args)
-- 	-- TriggerEvent('core_dispatch:addCall','00-00','Person Injured', {{icon = "fa-user-friends", info = 'hello'}},GetEntityCoords(GetPlayerPed(source)),'doctor',3000, 409, 59)
-- end)

-- RegisterNetEvent('hospital:server:MakeDeadCall', function(blipSettings, gender, street1, street2)
-- 	-- local src = source
-- 	-- local genderstr = "Man"

-- 	-- if gender == 1 then genderstr = "Woman" end

-- 	-- if street2 ~= nil then
-- 	-- 	TriggerClientEvent("112:client:SendAlert", -1, "A ".. genderstr .." injured at " ..street1 .. " "..street2, blipSettings)
-- 	-- 	TriggerClientEvent('mr-policealerts:client:AddPoliceAlert', -1, {
--     --         timeOut = 5000,
--     --         alertTitle = "Person injured",
--     --         details = {
--     --             [1] = {
--     --                 icon = '<i class="fas fa-venus-mars"></i>',
--     --                 detail = genderstr,
--     --             },
--     --             [2] = {
--     --                 icon = '<i class="fas fa-globe-europe"></i>',
--     --                 detail = street1.. ' '..street2,
--     --             },
--     --         },
--     --         callSign = nil,
--     --     }, true)
-- 	-- else
-- 	-- 	TriggerClientEvent("112:client:SendAlert", -1, "A ".. genderstr .." injured at "..street1, blipSettings)
-- 	-- 	TriggerClientEvent('mr-policealerts:client:AddPoliceAlert', -1, {
--     --         timeOut = 5000,
--     --         alertTitle = "Person injured",
--     --         details = {
--     --             [1] = {
--     --                 icon = '<i class="fas fa-venus-mars"></i>',
--     --                 detail = genderstr,
--     --             },
--     --             [2] = {
--     --                 icon = '<i class="fas fa-globe-europe"></i>',
--     --                 detail = street1,
--     --             },
--     --         },
--     --         callSign = nil,
--     --     }, true)
-- 	-- end
-- 	exports['mr-dispatch']:InjuriedPerson()
-- end)

function GetCharsInjuries(source)
    return PlayerInjuries[source]
end

function GetActiveInjuries(source)
	local injuries = {}
	if (PlayerInjuries[source].isBleeding > 0) then
		injuries["BLEED"] = PlayerInjuries[source].isBleeding
	end
	for k, v in pairs(PlayerInjuries[source].limbs) do
		if PlayerInjuries[source].limbs[k].isDamaged then
			injuries[k] = PlayerInjuries[source].limbs[k]
		end
	end
    return injuries
end


RegisterNetEvent('hospital:server:SendDoctorAlert', function()
    local players = MRFW.Functions.GetMR-Players()
    for k,v in pairs(players) do
        if v.PlayerData.job.name == 'doctor' and v.PlayerData.job.onduty then
			TriggerClientEvent('MRFW:Notify', v.PlayerData.source, 'A doctor is needed at Pillbox Hospital', 'ambulance')
		end
	end
end)

RegisterNetEvent('hospital:server:UseFirstAid', function(targetId)
	local src = source
	local Target = MRFW.Functions.GetPlayer(targetId)
	if Target then
		TriggerClientEvent('hospital:client:CanHelp', targetId, src)
	end
end)

RegisterNetEvent('hospital:server:CanHelp', function(helperId, canHelp)
	local src = source
	if canHelp then
		TriggerClientEvent('hospital:client:HelpPerson', helperId, src)
	else
		TriggerClientEvent('MRFW:Notify', helperId, "You can\'t help this person..", "error")
	end
end)

-- Callbacks

MRFW.Functions.CreateCallback('hospital:GetDoctors', function(source, cb)
	local amount = 0
    local players = MRFW.Functions.GetMR-Players()
    for k,v in pairs(players) do
        if v.PlayerData.job.name == 'doctor' and v.PlayerData.job.onduty then
			amount = amount + 1
		end
	end
	cb(amount)
end)

MRFW.Functions.CreateCallback('hospital:GetPlayerStatus', function(source, cb, playerId)
	local Player = MRFW.Functions.GetPlayer(playerId)
	local injuries = {}
	injuries["WEAPONWOUNDS"] = {}
	if Player then
		if PlayerInjuries[Player.PlayerData.source] then
			if (PlayerInjuries[Player.PlayerData.source].isBleeding > 0) then
				injuries["BLEED"] = PlayerInjuries[Player.PlayerData.source].isBleeding
			end
			for k, v in pairs(PlayerInjuries[Player.PlayerData.source].limbs) do
				if PlayerInjuries[Player.PlayerData.source].limbs[k].isDamaged then
					injuries[k] = PlayerInjuries[Player.PlayerData.source].limbs[k]
				end
			end
		end
		if PlayerWeaponWounds[Player.PlayerData.source] then
			for k, v in pairs(PlayerWeaponWounds[Player.PlayerData.source]) do
				injuries["WEAPONWOUNDS"][k] = v
			end
		end
	end
    cb(injuries)
end)

MRFW.Functions.CreateCallback('hospital:GetPlayerBleeding', function(source, cb)
	local src = source
	if PlayerInjuries[src] and PlayerInjuries[src].isBleeding then
		cb(PlayerInjuries[src].isBleeding)
	else
		cb(nil)
	end
end)

MRFW.Functions.CreateCallback('hospital:server:HasBandage', function(source, cb)
	local src = source
    local player = MRFW.Functions.GetPlayer(src)
    local bandage = player.Functions.GetItemByName("bandage")
    if bandage ~= nil then cb(true) else cb(false) end
end)

MRFW.Functions.CreateCallback('hospital:server:HasFirstAid', function(source, cb)
	local src = source
    local player = MRFW.Functions.GetPlayer(src)
    local firstaid = player.Functions.GetItemByName("firstaid")
    if firstaid ~= nil then cb(true) else cb(false) end
end)

MRFW.Functions.CreateCallback('hospital:server:Hascprkit', function(source, cb)
	local src = source
    local player = MRFW.Functions.GetPlayer(src)
    local cprkit = player.Functions.GetItemByName("cprkit")
    if cprkit ~= nil then cb(true) else cb(false) end
end)

-- Commands

-- MRFW.Commands.Add('911e', 'EMS Report', {{name='message', help='Message to be sent'}}, false, function(source, args)
-- 	local src = source
-- 	if args[1] then message = table.concat(args, " ") else message = 'Civilian Call' end
--     local ped = GetPlayerPed(src)
--     local coords = GetEntityCoords(ped)
--     local players = MRFW.Functions.GetMR-Players()
--     for k,v in pairs(players) do
--         if v.PlayerData.job.name == 'doctor' and v.PlayerData.job.onduty then
--             TriggerClientEvent('hospital:client:ambulanceAlert', v.PlayerData.source, coords, message)
--         end
--     end
-- end)

MRFW.Commands.Add("status", "Check A Players Health", {}, false, function(source, args)
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	if Player.PlayerData.job.name == "doctor" then
		TriggerClientEvent("hospital:client:CheckStatus", src)
	else
		TriggerClientEvent('MRFW:Notify', src, "You Are Not EMS", "error")
	end
end, 'doctor')

MRFW.Commands.Add("heal", "Heal A Player", {}, false, function(source, args)
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	if Player.PlayerData.job.name == "doctor" then
		TriggerClientEvent("hospital:client:TreatWounds", src)
	else
		TriggerClientEvent('MRFW:Notify', src, "You Are Not EMS", "error")
	end
end, 'doctor')

MRFW.Commands.Add("revivep", "Revive A Player", {}, false, function(source, args)
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	if Player.PlayerData.job.name == "doctor" then
		TriggerClientEvent("hospital:client:RevivePlayer", src)
	else
		TriggerClientEvent('MRFW:Notify', src, "You Are Not EMS", "error")
	end
end, 'doctor')

MRFW.Commands.Add("revive", "Revive A Player or Yourself (Admin Only)", {{name="id", help="Player ID (may be empty)"}}, false, function(source, args)
	local src = source
	local Players = MRFW.Functions.GetPlayer(src)
	if args[1] then
		local Player = MRFW.Functions.GetPlayer(tonumber(args[1]))
		if Player then
			Player.Functions.SetMetaData('stress', 0)
        	TriggerClientEvent('hud:client:UpdateStress', src, 0)
			TriggerClientEvent('hospital:client:Revive', Player.PlayerData.source)
		else
			TriggerClientEvent('MRFW:Notify', src, "Player Not Online", "error")
		end
	else
		Players.Functions.SetMetaData('stress', 0)
        TriggerClientEvent('hud:client:UpdateStress', src, 0)
		TriggerClientEvent('hospital:client:Revive', src)
	end
end, "admin")

MRFW.Commands.Add("setpain", "Set Yours or A Players Pain Level (Admin Only)", {{name="id", help="Player ID (may be empty)"}}, false, function(source, args)
	local src = source
	if args[1] then
		local Player = MRFW.Functions.GetPlayer(tonumber(args[1]))
		if Player then
			TriggerClientEvent('hospital:client:SetPain', Player.PlayerData.source)
		else
			TriggerClientEvent('MRFW:Notify', src, "Player Not Online", "error")
		end
	else
		TriggerClientEvent('hospital:client:SetPain', src)
	end
end, "owner")

MRFW.Commands.Add("kill", "Kill A Player or Yourself (Admin Only)", {{name="id", help="Player ID (may be empty)"}}, false, function(source, args)
	local src = source
	if args[1] then
		local Player = MRFW.Functions.GetPlayer(tonumber(args[1]))
		if Player then
			TriggerClientEvent('hospital:client:KillPlayer', Player.PlayerData.source)
		else
			TriggerClientEvent('MRFW:Notify', src, "Player Not Online", "error")
		end
	else
		TriggerClientEvent('hospital:client:KillPlayer', src)
	end
end, "owner")

MRFW.Commands.Add('aheal', 'Heal A Player or Yourself (Admin Only)', {{name='id', help='Player ID (may be empty)'}}, false, function(source, args)
	local src = source
	if args[1] then
		local Player = MRFW.Functions.GetPlayer(tonumber(args[1]))
		if Player then
			TriggerClientEvent('hospital:client:adminHeal', Player.PlayerData.source)
		else
			TriggerClientEvent('MRFW:Notify', src, "Player Not Online", "error")
		end
	else
		TriggerClientEvent('hospital:client:adminHeal', src)
	end
end, 'admin')

-- Items

MRFW.Functions.CreateUseableItem("bandage", function(source, item)
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	if Player.Functions.GetItemByName(item.name) ~= nil then
		TriggerClientEvent("hospital:client:UseBandage", src)
	end
end)

MRFW.Functions.CreateUseableItem("painkillers", function(source, item)
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	if Player.Functions.GetItemByName(item.name) ~= nil then
		TriggerClientEvent("hospital:client:UsePainkillers", src)
	end
end)

MRFW.Functions.CreateUseableItem("firstaid", function(source, item)
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	if Player.Functions.GetItemByName(item.name) ~= nil then
		TriggerClientEvent("hospital:client:UseFirstAiditem", source)
	end
end)

MRFW.Functions.CreateUseableItem("ifak", function(source, item)
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	if Player.Functions.GetItemByName(item.name) ~= nil then
		TriggerClientEvent("hospital:client:UseIfak", source)
	end
end)

function IsHighCommand(citizenid)
    local retval = false
    for k, v in pairs(Config.Whitelist) do
        if v == citizenid then
            retval = true
        end
    end
    return retval
end