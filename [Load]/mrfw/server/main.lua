MRFW = {}
MRFW.Config = MRConfig
MRFW.Shared = MRShared
MRFW.ServerCallbacks = {}
MRFW.UseableItems = {}


exports('GetCoreObject', function()
    return MRFW
end)

-- To use this export in a script instead of manifest method
-- Just put this line of code below at the very top of the script
-- local MRFW = exports['mrfw']:GetCoreObject()

-- Get permissions on server start

CreateThread(function()
    local result = MySQL.Sync.fetchAll('SELECT * FROM permissions', {})
    if result[1] then
        for k, v in pairs(result) do
            MRFW.Config.Server.PermissionList[v.cid] = {
                license = v.license,
                cid = v.cid,
                permission = v.permission,
                optin = true,
            }
        end
    end
end)

RegisterNetEvent('Refresh:permissions',function()
    local result = MySQL.Sync.fetchAll('SELECT * FROM permissions', {})
    if result[1] then
        for k, v in pairs(result) do
            MRFW.Config.Server.PermissionList[v.cid] = {
                license = v.license,
                cid = v.cid,
                permission = v.permission,
                optin = true,
            }
        end
    end
end)

CreateThread(function()
    Wait(500)
    local result = json.decode(LoadResourceFile(GetCurrentResourceName(), "./lib/secret.json"))
    if not result then
        return
    end
end)