local AJFW = exports['ajfw']:GetCoreObject()
local Accounts = {}

CreateThread(function()
	Wait(500)
	local bossmenu = MySQL.Sync.fetchAll('SELECT * FROM bossmenu', {})
	if not bossmenu then
		return
	end
	for k,v in pairs(bossmenu) do
		local k = tostring(v.job_name)
		local v = tonumber(v.amount)
		if k and v then
			Accounts[k] = v
		end
	end
end)

RegisterNetEvent("aj-bossmenu:server:withdrawMoney", function(amount)
	local src = source
	local xPlayer = AJFW.Functions.GetPlayer(src)
	local job = xPlayer.PlayerData.job.name

	if not Accounts[job] then
		Accounts[job] = 0
	end

	if Accounts[job] >= amount and amount > 0 then
		Accounts[job] = Accounts[job] - amount
		xPlayer.Functions.AddMoney("cash", amount)
	else
		TriggerClientEvent('AJFW:Notify', src, "Invalid Amount!", "error")
		TriggerClientEvent('aj-bossmenu:client:OpenMenu', src)
		return
	end
	
	MySQL.Async.execute('UPDATE bossmenu SET amount = ? WHERE job_name = ?', { Accounts[job], job})
	TriggerEvent('aj-log:server:CreateLog', 'bossmenu', 'Withdraw Money', "blue", xPlayer.PlayerData.name.. "Withdrawal $" .. amount .. ' (' .. job .. ')', true)
	TriggerClientEvent('AJFW:Notify', src, "You have withdrawn: $" ..amount, "success")
	TriggerClientEvent('aj-bossmenu:client:OpenMenu', src)
end)

RegisterNetEvent("aj-bossmenu:server:depositMoney", function(amount)
	local src = source
	local xPlayer = AJFW.Functions.GetPlayer(src)
	local job = xPlayer.PlayerData.job.name

	if not Accounts[job] then
		Accounts[job] = 0
	end

	if xPlayer.Functions.RemoveMoney("cash", amount) then
		Accounts[job] = Accounts[job] + amount
	else
		TriggerClientEvent('AJFW:Notify', src, "Invalid Amount!", "error")
		TriggerClientEvent('aj-bossmenu:client:OpenMenu', src)
		return
	end

	MySQL.Async.execute('UPDATE bossmenu SET amount = ? WHERE job_name = ?', { Accounts[job], job })
	TriggerEvent('aj-log:server:CreateLog', 'bossmenu', 'Deposit Money', "blue", xPlayer.PlayerData.name.. "Deposit $" .. amount .. ' (' .. job .. ')', true)
	TriggerClientEvent('AJFW:Notify', src, "You have deposited: $" ..amount, "success")
	TriggerClientEvent('aj-bossmenu:client:OpenMenu', src)
end)
 
RegisterNetEvent("aj-bossmenu:server:addAccountMoney", function(account, amount)
	if not Accounts[account] then
		Accounts[account] = 0
	end

	Accounts[account] = Accounts[account] + amount
	MySQL.Async.execute('UPDATE bossmenu SET amount = ? WHERE job_name = ?', { Accounts[account], account })
end)

RegisterNetEvent("aj-bossmenu:server:removeAccountMoney", function(account, amount)
	if not Accounts[account] then
		Accounts[account] = 0
	end

	if Accounts[account] >= amount then
		Accounts[account] = Accounts[account] - amount
	end

	MySQL.Async.execute('UPDATE bossmenu SET amount = ? WHERE job_name = ?', { Accounts[account], account })
end)

AJFW.Functions.CreateCallback('aj-bossmenu:server:GetAccount', function(source, cb, jobname)
	local result = GetAccount(jobname)
	cb(result)
end)

-- Export
function GetAccount(account)
	return Accounts[account] or 0
end

-- Get Employees
AJFW.Functions.CreateCallback('aj-bossmenu:server:GetEmployees', function(source, cb, jobname)
	local src = source
	local employees = {}
	if not Accounts[jobname] then
		Accounts[jobname] = 0
	end
	local players = MySQL.Sync.fetchAll("SELECT * FROM `players` WHERE `job` LIKE '%".. jobname .."%'", {})
	if players[1] ~= nil then
		for key, value in pairs(players) do
			local isOnline = AJFW.Functions.GetPlayerByCitizenId(value.citizenid)

			if isOnline then
				employees[#employees+1] = {
				empSource = isOnline.PlayerData.citizenid, 
				grade = isOnline.PlayerData.job.grade,
				isboss = isOnline.PlayerData.job.isboss,
				name = '🟢 ' .. isOnline.PlayerData.charinfo.firstname .. ' ' .. isOnline.PlayerData.charinfo.lastname
				}
			else
				employees[#employees+1] = {
				empSource = value.citizenid, 
				grade =  json.decode(value.job).grade,
				isboss = json.decode(value.job).isboss,
				name = '❌ ' ..  json.decode(value.charinfo).firstname .. ' ' .. json.decode(value.charinfo).lastname
				}
			end
		end
		table.sort(employees, function(a, b)
            return a.grade.level > b.grade.level
        end)
	end
	cb(employees)
end)

-- Grade Change
RegisterNetEvent('aj-bossmenu:server:GradeUpdate', function(data)
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)
	local Employee = AJFW.Functions.GetPlayerByCitizenId(data.cid)
	if Employee then
		if Employee.Functions.SetJob(Player.PlayerData.job.name, data.grado) then
			TriggerClientEvent('AJFW:Notify', src, "Sucessfulluy promoted!", "success")
			TriggerClientEvent('AJFW:Notify', Employee.PlayerData.source, "You have been promoted to" ..data.nomegrado..".", "success")
		else
			TriggerClientEvent('AJFW:Notify', src, "Promotion grade does not exist.", "error")
		end
	else
		TriggerClientEvent('AJFW:Notify', src, "Civilian not in city.", "error")
	end
	TriggerClientEvent('aj-bossmenu:client:OpenMenu', src)
end)

-- Fire Employee
RegisterNetEvent('aj-bossmenu:server:FireEmployee', function(target)
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)
	local Employee = AJFW.Functions.GetPlayerByCitizenId(target)
	if Employee then
		if target ~= Player.PlayerData.citizenid then
			if Employee.Functions.SetJob("unemployed", '0') then
				TriggerEvent("aj-log:server:CreateLog", "bossmenu", "Job Fire", "red", Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname .. ' successfully fired ' .. Employee.PlayerData.charinfo.firstname .. " " .. Employee.PlayerData.charinfo.lastname .. " (" .. Player.PlayerData.job.name .. ")", false)
				TriggerClientEvent('AJFW:Notify', src, "Employee fired!", "success")
				TriggerClientEvent('AJFW:Notify', Employee.PlayerData.source , "You have been fired! Good luck.", "error")
			else
				TriggerClientEvent('AJFW:Notify', src, "Error..", "error")
			end
		else
			TriggerClientEvent('AJFW:Notify', src, "You can\'t fire yourself", "error")
		end
	else
		local player = MySQL.Sync.fetchAll('SELECT * FROM players WHERE citizenid = ? LIMIT 1', { target })
		if player[1] ~= nil then
			Employee = player[1]
			local job = {}
			job.name = "unemployed"
			job.label = "Unemployed"
			job.payment = AJFW.Shared.Jobs[job.name].grades['0'].payment or 50
			job.onduty = true
			job.isboss = false
			job.grade = {}
			job.grade.name = nil
			job.grade.level = 0
			MySQL.Sync.execute('UPDATE players SET job = ? WHERE citizenid = ?', { json.encode(job), target })
			TriggerClientEvent('AJFW:Notify', src, "Employee fired!", "success")
			-- TriggerEvent("aj-log:server:CreateLog", "bossmenu", "Job Fire", "red", Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname .. ' successfully fired ' .. Employee.PlayerData.charinfo.firstname .. " " .. Employee.PlayerData.charinfo.lastname .. " (" .. Player.PlayerData.job.name .. ")", false)
		else
			TriggerClientEvent('AJFW:Notify', src, "Civilian not in city.", "error")
		end
	end
	TriggerClientEvent('aj-bossmenu:client:OpenMenu', src)
end)

-- Recruit Player
RegisterNetEvent('aj-bossmenu:server:HireEmployee', function(recruit)
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)
	local Target = AJFW.Functions.GetPlayer(recruit)
	if Player.PlayerData.job.isboss == true then
		if Target and Target.Functions.SetJob(Player.PlayerData.job.name, 0) then
			TriggerClientEvent('AJFW:Notify', src, "You hired " .. (Target.PlayerData.charinfo.firstname .. ' ' .. Target.PlayerData.charinfo.lastname) .. " come " .. Player.PlayerData.job.label .. "", "success")
			TriggerClientEvent('AJFW:Notify', Target.PlayerData.source , "You were hired as " .. Player.PlayerData.job.label .. "", "success")
			TriggerEvent('aj-log:server:CreateLog', 'bossmenu', 'Recruit', "lightgreen", (Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname).. " successfully recruited " .. (Target.PlayerData.charinfo.firstname .. ' ' .. Target.PlayerData.charinfo.lastname) .. ' (' .. Player.PlayerData.job.name .. ')', true)
		end
	end
	TriggerClientEvent('aj-bossmenu:client:OpenMenu', src)
end)

-- Get closest player sv
AJFW.Functions.CreateCallback('aj-bossmenu:getplayers', function(source, cb)
	local src = source
	local players = {}
	local PlayerPed = GetPlayerPed(src)
	local pCoords = GetEntityCoords(PlayerPed)
	for k, v in pairs(AJFW.Functions.GetPlayers()) do
		local targetped = GetPlayerPed(v)
		local tCoords = GetEntityCoords(targetped)
		local dist = #(pCoords - tCoords)
		if PlayerPed ~= targetped and dist < 10 then
			local ped = AJFW.Functions.GetPlayer(v)
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