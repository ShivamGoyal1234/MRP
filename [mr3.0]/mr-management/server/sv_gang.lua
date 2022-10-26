local MRFW = exports['mrfw']:GetCoreObject()
local GangaccountGangs = {}

CreateThread(function()
	Wait(500)
	local gangmenu = MySQL.Sync.fetchAll('SELECT * FROM gangmenu', {})
	if not gangmenu then
		return
	end
	for k,v in pairs(gangmenu) do
		local k = tostring(v.job_name)
		local v = tonumber(v.amount)
		if k and v then
			GangaccountGangs[k] = v
		end
	end
end)

RegisterNetEvent("mr-gangmenu:server:withdrawMoney", function(amount)
	local src = source
	local xPlayer = MRFW.Functions.GetPlayer(src)
	local gang = xPlayer.PlayerData.gang.name

	if not GangaccountGangs[gang] then
		GangaccountGangs[gang] = 0
	end

	if GangaccountGangs[gang] >= amount and amount > 0 then
		GangaccountGangs[gang] = GangaccountGangs[gang] - amount
		xPlayer.Functions.AddMoney("cash", amount, 'Boss menu withdraw')
	else
		TriggerClientEvent('MRFW:Notify', src, "Invalid amount!", "error")
		TriggerClientEvent('mr-gangmenu:client:OpenMenu', src)
		return
	end

	MySQL.Async.execute('UPDATE gangmenu SET amount = ? WHERE job_name = ?', { GangaccountGangs[gang], gang })
	TriggerEvent('mr-log:server:CreateLog', 'gangmenu', 'Withdraw Money', 'yellow', xPlayer.PlayerData.charinfo.firstname .. ' ' .. xPlayer.PlayerData.charinfo.lastname .. ' successfully withdrew $' .. amount .. ' (' .. gang .. ')', false)
	TriggerClientEvent('MRFW:Notify', src, "You have withdrawn: $" ..amount, "success")
	TriggerClientEvent('mr-gangmenu:client:OpenMenu', src)
end)

RegisterNetEvent("mr-gangmenu:server:depositMoney", function(amount)
	local src = source
	local xPlayer = MRFW.Functions.GetPlayer(src)
	local gang = xPlayer.PlayerData.gang.name

	if not GangaccountGangs[gang] then
		GangaccountGangs[gang] = 0
	end

	if xPlayer.Functions.RemoveMoney("cash", amount) then
		GangaccountGangs[gang] = GangaccountGangs[gang] + amount
	else
		TriggerClientEvent('MRFW:Notify', src, "Invalid amount!", "error")
		TriggerClientEvent('mr-gangmenu:client:OpenMenu', src)
		return
	end

	MySQL.Async.execute('UPDATE gangmenu SET amount = ? WHERE job_name = ?', { GangaccountGangs[gang], gang })
	TriggerEvent('mr-log:server:CreateLog', 'gangmenu', 'Deposit Money', 'yellow', xPlayer.PlayerData.charinfo.firstname .. ' ' .. xPlayer.PlayerData.charinfo.lastname .. ' successfully deposited $' .. amount .. ' (' .. gang .. ')', false)
	TriggerClientEvent('MRFW:Notify', src, "You have deposited: $" ..amount, "success")
	TriggerClientEvent('mr-gangmenu:client:OpenMenu', src)
end)

RegisterNetEvent("mr-gangmenu:server:addaccountGangMoney", function(accountGang, amount)
	if not GangaccountGangs[accountGang] then
		GangaccountGangs[accountGang] = 0
	end

	GangaccountGangs[accountGang] = GangaccountGangs[accountGang] + amount
	MySQL.Async.execute('UPDATE gangmenu SET amount = ? WHERE job_name = ?', { GangaccountGangs[accountGang], accountGang })
end)

RegisterNetEvent("mr-gangmenu:server:removeaccountGangMoney", function(accountGang, amount)
	if not GangaccountGangs[accountGang] then
		GangaccountGangs[accountGang] = 0
	end

	if GangaccountGangs[accountGang] >= amount then
		GangaccountGangs[accountGang] = GangaccountGangs[accountGang] - amount
	end

	MySQL.Async.execute('UPDATE gangmenu SET amount = ? WHERE job_name = ?', { GangaccountGangs[accountGang], accountGang })
end)

MRFW.Functions.CreateCallback('mr-gangmenu:server:GetAccount', function(source, cb, GangName)
	local gangmoney = GetaccountGang(GangName)
	cb(gangmoney)
end)

-- Export
function GetaccountGang(accountGang)
	return GangaccountGangs[accountGang] or 0
end

-- Get Employees
MRFW.Functions.CreateCallback('mr-gangmenu:server:GetEmployees', function(source, cb, gangname)
	local src = source
	local employees = {}
	if not GangaccountGangs[gangname] then
		GangaccountGangs[gangname] = 0
	end
	local players = MySQL.Sync.fetchAll("SELECT * FROM `players` WHERE `gang` LIKE '%".. gangname .."%'", {})
	if players[1] ~= nil then
		for key, value in pairs(players) do
			local isOnline = MRFW.Functions.GetPlayerByCitizenId(value.citizenid)

			if isOnline then
				employees[#employees+1] = {
				empSource = isOnline.PlayerData.citizenid,
				grade = isOnline.PlayerData.gang.grade,
				isboss = isOnline.PlayerData.gang.isboss,
				name = '🟢' .. isOnline.PlayerData.charinfo.firstname .. ' ' .. isOnline.PlayerData.charinfo.lastname
				}
			else
				employees[#employees+1] = {
				empSource = value.citizenid,
				grade =  json.decode(value.gang).grade,
				isboss = json.decode(value.gang).isboss,
				name = '❌' ..  json.decode(value.charinfo).firstname .. ' ' .. json.decode(value.charinfo).lastname
				}
			end
		end
	end
	cb(employees)
end)

-- Grade Change
RegisterNetEvent('mr-gangmenu:server:GradeUpdate', function(data)
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	local Employee = MRFW.Functions.GetPlayerByCitizenId(data.cid)
	if Employee then
		if Employee.Functions.SetGang(Player.PlayerData.gang.name, data.grado) then
			TriggerClientEvent('MRFW:Notify', src, "Successfully promoted!", "success")
			TriggerClientEvent('MRFW:Notify', Employee.PlayerData.source, "You have been promoted to " ..data.nomegrado..".", "success")
		else
			TriggerClientEvent('MRFW:Notify', src, "Grade does not exist.", "error")
		end
	else
		TriggerClientEvent('MRFW:Notify', src, "Civilian is not in city.", "error")
	end
	TriggerClientEvent('mr-gangmenu:client:OpenMenu', src)
end)

-- Fire Member
RegisterNetEvent('mr-gangmenu:server:FireMember', function(target)
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	local Employee = MRFW.Functions.GetPlayerByCitizenId(target)
	if Employee then
		if target ~= Player.PlayerData.citizenid then
			if Employee.Functions.SetGang("none", '0') then
				TriggerEvent("mr-log:server:CreateLog", "gangmenu", "Gang Fire", "orange", Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname .. ' successfully fired ' .. Employee.PlayerData.charinfo.firstname .. " " .. Employee.PlayerData.charinfo.lastname .. " (" .. Player.PlayerData.gang.name .. ")", false)
				TriggerClientEvent('MRFW:Notify', src, "Gang Member fired!", "success")
				TriggerClientEvent('MRFW:Notify', Employee.PlayerData.source , "You have been expelled from the gang!", "error")
			else
				TriggerClientEvent('MRFW:Notify', src, "Error.", "error")
			end
		else
			TriggerClientEvent('MRFW:Notify', src, "You can\'t kick yourself out of the gang!", "error")
		end
	else
		local player = MySQL.Sync.fetchAll('SELECT * FROM players WHERE citizenid = ? LIMIT 1', {target})
		if player[1] ~= nil then
			Employee = player[1]
			local gang = {}
			gang.name = "none"
			gang.label = "No Affiliation"
			gang.payment = 0
			gang.onduty = true
			gang.isboss = false
			gang.grade = {}
			gang.grade.name = nil
			gang.grade.level = 0
			MySQL.Async.execute('UPDATE players SET gang = ? WHERE citizenid = ?', {json.encode(gang), target})
			TriggerClientEvent('MRFW:Notify', src, "Gang member fired!", "success")
			TriggerEvent("mr-log:server:CreateLog", "gangmenu", "Gang Fire", "orange", Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname .. ' successfully fired ' .. Employee.PlayerData.charinfo.firstname .. " " .. Employee.PlayerData.charinfo.lastname .. " (" .. Player.PlayerData.gang.name .. ")", false)
		else
			TriggerClientEvent('MRFW:Notify', src, "Civilian is not in city.", "error")
		end
	end
	TriggerClientEvent('mr-gangmenu:client:OpenMenu', src)
end)

-- Recruit Player
RegisterNetEvent('mr-gangmenu:server:HireMember', function(recruit)
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	local Target = MRFW.Functions.GetPlayer(recruit)
	if Player.PlayerData.gang.isboss == true then
		if Target and Target.Functions.SetGang(Player.PlayerData.gang.name, 0) then
			TriggerClientEvent('MRFW:Notify', src, "You hired " .. (Target.PlayerData.charinfo.firstname .. ' ' .. Target.PlayerData.charinfo.lastname) .. " come " .. Player.PlayerData.gang.label .. "", "success")
			TriggerClientEvent('MRFW:Notify', Target.PlayerData.source , "You have been hired as " .. Player.PlayerData.gang.label .. "", "success")
			TriggerEvent('mr-log:server:CreateLog', 'gangmenu', 'Recruit', 'yellow', (Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname).. ' successfully recruited ' .. Target.PlayerData.charinfo.firstname .. ' ' .. Target.PlayerData.charinfo.lastname .. ' (' .. Player.PlayerData.gang.name .. ')', false)
		end
	end
	TriggerClientEvent('mr-gangmenu:client:OpenMenu', src)
end)

-- Get closest player sv
MRFW.Functions.CreateCallback('mr-gangmenu:getplayers', function(source, cb)
	local src = source
	local players = {}
	local PlayerPed = GetPlayerPed(src)
	local pCoords = GetEntityCoords(PlayerPed)
	for k, v in pairs(MRFW.Functions.GetPlayers()) do
		local targetped = GetPlayerPed(v)
		local tCoords = GetEntityCoords(targetped)
		local dist = #(pCoords - tCoords)
		if PlayerPed ~= targetped and dist < 10 then
			local ped = MRFW.Functions.GetPlayer(v)
			players[#players+1] = {
			id = v,
			coords = GetEntityCoords(targetped),
			name = ped.PlayerData.charinfo.firstname .. " " .. ped.PlayerData.charinfo.lastname,
			citizenid = ped.PlayerData.citizenid,
			sources = GetPlayerPed(ped.PlayerData.source),
			sourceplayer = ped.PlayerData.source
			}
		end
	end
		table.sort(players, function(a, b)
			return a.name < b.name
		end)
	cb(players)
end)
