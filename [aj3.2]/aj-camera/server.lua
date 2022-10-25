local AJFW = exports['ajfw']:GetCoreObject()

local WebHook = "https://discord.com/api/webhooks/994049424844136468/1A_LZXVXIt0-sXcrV5ZOFnV07YT0P3TskCSlqBebxlN104-bWLNXo-8O-PyEWx-4UtUl"

AJFW.Functions.CreateUseableItem("camera", function(source, item)
    local src = source
    TriggerClientEvent("aj-camera:client:use-camera", src)
end)

AJFW.Functions.CreateUseableItem("photo", function(source, item)
    local src = source
    if item.info and item.info.photourl then
        TriggerClientEvent("aj-camera:client:use-photo", src, item.info.photourl)
    end
end)

RegisterNetEvent("aj-camera:server:add-photo-item", function(url)
    local src = source
    local ply = AJFW.Functions.GetPlayer(source)
    if ply then
        local info = {
            photourl = url
        }
        ply.Functions.AddItem("photo", 1, nil, info)
        TriggerEvent('inventory:client:ItemBox', AJFW.Shared.Items["photo"], "add")
    end
end)

AJFW.Functions.CreateCallback("aj-camera:server:webhook",function(source,cb)
	if WebHook ~= "" then
		cb(WebHook)
	else
		cb(nil)
	end
end)
