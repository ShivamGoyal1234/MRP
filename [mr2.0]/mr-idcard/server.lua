MRFW = exports['mrfw']:GetCoreObject()

local photo = nil


MRFW.Commands.Add("addphoto", "Add Photo To ID", {{name="playerid", help="Player ID"},{name="url", help="URL"}}, true, function(source, args)
	local Player = MRFW.Functions.GetPlayer(source)
	local playerid = tonumber(args[1])
	local url = tostring(args[2])

	local target = MRFW.Functions.GetPlayer(playerid)
	local fetchcitizen = target.PlayerData.citizenid

    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or Player.PlayerData.job.grade.name == "Mayor" or Player.PlayerData.job.grade.name == "Secretery" or Player.PlayerData.job.grade.name == "Employee" then

		MySQL.Async.execute('UPDATE players SET photo = ? WHERE citizenid = ?', {url, fetchcitizen})
		MySQL.Async.execute('UPDATE players SET mdw_image = ? WHERE citizenid = ?', {url, fetchcitizen})
		-- MySQL.Async.execute('UPDATE players SET pp = ? WHERE citizenid = ?', {url, fetchcitizen})
		local db = MySQL.Sync.fetchAll('SELECT * FROM mdt_data WHERE cid = ?',{fetchcitizen})
		if db[1] ~= nil then
			MySQL.Async.execute('UPDATE mdt_data SET pfp = ? WHERE cid = ?', {url, fetchcitizen})
		else
			MySQL.Async.insert('INSERT INTO mdt_data (cid, tags, gallery, pfp) VALUES (?, ?, ?, ?)',{fetchcitizen, '[]', '[]', url})
		end
	else
		TriggerClientEvent('MRFW:Notify', source, "You don't have Permission!", "error")
	end
end, 'government')


RegisterServerEvent('mr-idcard:server:fetchPhoto')
AddEventHandler('mr-idcard:server:fetchPhoto', function()
	local src     		= source
	local aj 		= MRFW.Functions.GetPlayer(src)
	local db = MySQL.Sync.fetchAll('SELECT * FROM players WHERE citizenid = ?', {aj.PlayerData.citizenid})
	if db ~= nil then
		for k,v in pairs(db) do
			photo = v.photo
		end
	end
end)




