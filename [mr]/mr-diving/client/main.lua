
PlayerJob = {}

RegisterNetEvent("MRFW:Client:OnPlayerLoaded", function()
    MRFW.Functions.TriggerCallback('mr-diving:server:GetBusyDocks', function(Docks)
        MRBoatshop.Locations["berths"] = Docks
    end)

    MRFW.Functions.TriggerCallback('mr-diving:server:GetDivingConfig', function(Config, Area)
        MRDiving.Locations = Config
        TriggerEvent('mr-diving:client:SetDivingLocation', Area)
    end)

    PlayerJob = MRFW.Functions.GetPlayerData().job

    if PlayerJob.name == "police" then
        if PoliceBlip ~= nil then
            RemoveBlip(PoliceBlip)
        end
        PoliceBlip = AddBlipForCoord(MR-Boatshop.PoliceBoat.x, MRBoatshop.PoliceBoat.y, MRBoatshop.PoliceBoat.z)
        SetBlipSprite(PoliceBlip, 410)
        SetBlipDisplay(PoliceBlip, 4)
        SetBlipScale(PoliceBlip, 0.8)
        SetBlipAsShortRange(PoliceBlip, true)
        SetBlipColour(PoliceBlip, 29)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Police boat")
        EndTextCommandSetBlipName(PoliceBlip)
        PoliceBlip = AddBlipForCoord(MR-Boatshop.PoliceBoat2.x, MRBoatshop.PoliceBoat2.y, MRBoatshop.PoliceBoat2.z)
        SetBlipSprite(PoliceBlip, 410)
        SetBlipDisplay(PoliceBlip, 4)
        SetBlipScale(PoliceBlip, 0.8)
        SetBlipAsShortRange(PoliceBlip, true)
        SetBlipColour(PoliceBlip, 29)
    
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Police boat")
        EndTextCommandSetBlipName(PoliceBlip)
    end
end)

DrawText3D = function(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

RegisterNetEvent('mr-diving:client:UseJerrycan', function()
    local ped = PlayerPedId()
    local boat = IsPedInAnyBoat(ped)
    if boat then
        local curVeh = GetVehiclePedIsIn(ped, false)
        MRFW.Functions.Progressbar("reful_boat", "Refueling boat ..", 20000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            exports['mr-fuel']:SetFuel(curVeh, 100)
            MRFW.Functions.Notify('The boat has been refueled', 'success')
            TriggerServerEvent('mr-diving:server:RemoveItem', 'jerry_can', 1)
            TriggerEvent('inventory:client:ItemBox', MRFW.Shared.Items['jerry_can'], "remove")
        end, function() -- Cancel
            MRFW.Functions.Notify('Refueling has been canceled!', 'error')
        end)
    else
        MRFW.Functions.Notify('You are not in a boat', 'error')
    end
end)
