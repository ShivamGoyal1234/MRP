-- MRFW = nil
-- TriggerEvent('MRFW:GetObject', function(obj) MRFW = obj end)

--Nothing Here--
--mr--
function escapeSqli(str)
    local replacements = {
        ['"'] = '\\"',
        ["'"] = "\\'"
    }
    return str:gsub("['\"]", replacements) -- or string.gsub( source, "['\"]", replacements )
end

RegisterNetEvent('mr-stations:server:LogoutLocation', function()
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	local MyItems = Player.PlayerData.items
	MySQL.Async.execute('UPDATE players SET inventory = ? WHERE citizenid = ? ', { escapeSqli(json.encode(MyItems)), Player.PlayerData.citizenid})
	MRFW.Player.Logout(src)
    TriggerClientEvent('mr-multicharacter:client:chooseChar', src)
end)