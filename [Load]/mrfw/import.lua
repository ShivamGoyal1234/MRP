-- This might eventually be deprecated for the export system

if GetCurrentResourceName() == 'mrfw' then
    function GetSharedObject()
        return MRFW
    end

    exports('GetSharedObject', GetSharedObject)
end

MRFW = exports['mrfw']:GetSharedObject()