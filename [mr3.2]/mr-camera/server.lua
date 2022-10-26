local MRFW = exports['mrfw']:GetCoreObject()

local WebHook = "https://discord.com/api/webhooks/994049424844136468/1A_LZXVXIt0-sXcrV5ZOFnV07YT0P3TskCSlqBebxlN104-bWLNXo-8O-PyEWx-4UtUl"

MRFW.Functions.CreateUseableItem("camera", function(source, item)
    local src = source
    TriggerClientEvent("mr-camera:client:use-camera", src)
end)

MRFW.Functions.CreateUseableItem("photo", function(source, item)
    local src = source
    if item.info and item.info.photourl then
        TriggerClientEvent("mr-camera:client:use-photo", src, item.info.photourl)
    end
end)

RegisterNetEvent("mr-camera:server:add-photo-item", function(url)
    local src = source
    local ply = MRFW.Functions.GetPlayer(source)
    if ply then
        local info = {
            photourl = url
        }
        ply.Functions.AddItem("photo", 1, nil, info)
        TriggerEvent('inventory:client:ItemBox', MRFW.Shared.Items["photo"], "add")
    end
end)

MRFW.Functions.CreateCallback("mr-camera:server:webhook",function(source,cb)
	if WebHook ~= "" then
		cb(WebHook)
	else
		cb(nil)
	end
end)
