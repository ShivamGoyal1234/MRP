-- local blipsLoaded = false
-- RegisterNetEvent('MRFW:Client:OnPlayerLoaded', function()
--     if not blipsLoaded then
--         blipsLoaded = true
--         CreateThread(function()
--             for i=1, #Config.Blips, 1 do
--                 local Blip = Config.Blips[i]
--                 blip = AddBlipForCoord(Blip["x"], Blip["y"], Blip["z"])
--                 SetBlipSprite(blip, Blip["id"])
--                 SetBlipDisplay(blip, 4)
--                 SetBlipScale(blip, Blip["scale"])
--                 SetBlipColour(blip, Blip["color"])
--                 SetBlipAsShortRange(blip, true)
--                 BeginTextCommandSetBlipName("STRING")
--                 AddTextComponentString(Blip["text"])
--                 EndTextCommandSetBlipName(blip)
--             end
--         end)
--     end
-- end)

-- AddEventHandler('onResourceStart', function(resource)
--     if not blipsLoaded then
--         blipsLoaded = true
--         CreateThread(function()
--             for i=1, #Config.Blips, 1 do
--                 local Blip = Config.Blips[i]
--                 blip = AddBlipForCoord(Blip["x"], Blip["y"], Blip["z"])
--                 SetBlipSprite(blip, Blip["id"])
--                 SetBlipDisplay(blip, 4)
--                 SetBlipScale(blip, Blip["scale"])
--                 SetBlipColour(blip, Blip["color"])
--                 SetBlipAsShortRange(blip, true)
--                 BeginTextCommandSetBlipName("STRING")
--                 AddTextComponentString(Blip["text"])
--                 EndTextCommandSetBlipName(blip)
--             end
--         end)
--     end
-- end)