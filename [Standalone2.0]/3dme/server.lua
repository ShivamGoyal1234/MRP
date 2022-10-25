local MRFW = exports['mrfw']:GetCoreObject()

MRFW.Commands.Add("me", "Character interactions", {{name='message', help='Enter Somethin'}}, false, function(source, args)
	local text = table.concat(args, ' ')
	local Player = MRFW.Functions.GetPlayer(source)
	local coords = GetEntityCoords(GetPlayerPed(source))
    TriggerClientEvent('3dme:triggerDisplay', -1, text, source, coords)
    TriggerEvent("mr-log:server:CreateLog", "me", "Me", "white", "**"..GetPlayerName(source).."** (CitizenID: "..Player.PlayerData.citizenid.." | ID: "..source..")** " ..Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname.. " **" ..text, false)
end)