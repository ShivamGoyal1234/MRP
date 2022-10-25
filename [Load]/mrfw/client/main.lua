MRFW = {}
MRFW.PlayerData = {}
MRFW.Config = MRConfig
MRFW.Shared = MRShared
MRFW.ServerCallbacks = {}

exports('GetCoreObject', function()
    return MRFW
end)

-- To use this export in a script instead of manifest method
-- Just put this line of code below at the very top of the script
-- local MRFW = exports['mrfw']:GetCoreObject()