---------------Task 1---------------------------


local Area = {}
local insidePoint = false


local MRFW = exports['mrfw']:GetCoreObject()

isLoggedIn = false


RegisterNetEvent('MRFW:Client:OnPlayerLoaded')
AddEventHandler('MRFW:Client:OnPlayerLoaded', function()
    isLoggedIn = true
end)

RegisterNetEvent('MRFW:Client:OnPlayerUnload')
AddEventHandler('MRFW:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

CreateThread(function()
    Wait(500)
    for k, v in pairs(Zones["Area"]) do
        local zone = PolyZone:Create(v.shape, {
            name = "Zone"..k,
            debugPoly = false,
        })

        Area[k] = {
            zone = zone,
            id = k,
        }
    end
end)

CreateThread(function()
    while true do 
        Wait(500)
        if isLoggedIn then
            
            local PlayerPed = PlayerPedId()
            local pedCoords = GetEntityCoords(PlayerPed)
                    
            for k, zone in pairs(Area) do  

                if Area[k].zone:isPointInside(pedCoords) then
                    insidePoint = true
                    TriggerEvent("MRFW:Notify","You are in High Security Area", "error")
                    ---IF YOU WANT TO PLAY SOUND THEN 
                    PlaySoundFrontend(-1, "HACKING_FAILURE", "", true)
          
                    while insidePoint == true do   
                        if not Area[k].zone:isPointInside(GetEntityCoords(PlayerPed)) then
                            insidePoint = false
                            ---IF YOU WANT TO PLAY SOUND THEN 
                            PlaySoundFrontend(-1, "HACKING_SUCCESS", "", true)
                            TriggerEvent("MRFW:Notify","You left High Security Area", "error")
                        end
                        Wait(1000)
                    end
                end
            end  
            Wait(2000)
        end
    end
end)


-------------------Task 2 clint side---------------------

RegisterNetEvent("client:getpos", function ()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 ~= nil then 
    streetLabel = streetLabel .. " " .. street2
    end
    print(streetLabel)
    TriggerEvent("MRFW:Notify",streetLabel, "error")
end)

