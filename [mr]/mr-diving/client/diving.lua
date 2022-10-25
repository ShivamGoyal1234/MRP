local CurrentDivingLocation = {
    Area = 0,
    Blip = {
        Radius = nil,
        Label = nil
    }
}

RegisterNetEvent('mr-diving:client:NewLocations', function()
    MRFW.Functions.TriggerCallback('mr-diving:server:GetDivingConfig', function(Config, Area)
        MRDiving.Locations = Config
        TriggerEvent('mr-diving:client:SetDivingLocation', Area)
    end)
end)

RegisterNetEvent('mr-diving:client:SetDivingLocation', function(DivingLocation)
    CurrentDivingLocation.Area = DivingLocation

    for _,Blip in pairs(CurrentDivingLocation.Blip) do
        if Blip ~= nil then
            RemoveBlip(Blip)
        end
    end
    
    CreateThread(function()
        RadiusBlip = AddBlipForRadius(MRDiving.Locations[CurrentDivingLocation.Area].coords.Area.x, MRDiving.Locations[CurrentDivingLocation.Area].coords.Area.y, MRDiving.Locations[CurrentDivingLocation.Area].coords.Area.z, 100.0)
        
        SetBlipRotation(RadiusBlip, 0)
        SetBlipColour(RadiusBlip, 47)

        CurrentDivingLocation.Blip.Radius = RadiusBlip

        LabelBlip = AddBlipForCoord(MRDiving.Locations[CurrentDivingLocation.Area].coords.Area.x, MRDiving.Locations[CurrentDivingLocation.Area].coords.Area.y, MRDiving.Locations[CurrentDivingLocation.Area].coords.Area.z)

        SetBlipSprite (LabelBlip, 597)
        SetBlipDisplay(LabelBlip, 4)
        SetBlipScale  (LabelBlip, 0.7)
        SetBlipColour(LabelBlip, 0)
        SetBlipAsShortRange(LabelBlip, true)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName('Diving Area')
        EndTextCommandSetBlipName(LabelBlip)

        CurrentDivingLocation.Blip.Label = LabelBlip
    end)
end)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Wait( 0 )
    end
end

local showText = false

CreateThread(function()
    while true do
        local inRange = false
        

        if CurrentDivingLocation.Area ~= 0 then
            local Ped = PlayerPedId()
            local Pos = GetEntityCoords(Ped)
            local AreaDistance = #(Pos - vector3(MRDiving.Locations[CurrentDivingLocation.Area].coords.Area.x, MRDiving.Locations[CurrentDivingLocation.Area].coords.Area.y, MRDiving.Locations[CurrentDivingLocation.Area].coords.Area.z))
            local CoralDistance = nil

            if AreaDistance < 100 then
                inRange = true
            end

            if inRange then
                for cur, CoralLocation in pairs(MRDiving.Locations[CurrentDivingLocation.Area].coords.Coral) do
                    CoralDistance = #(Pos - vector3(CoralLocation.coords.x, CoralLocation.coords.y, CoralLocation.coords.z))

                    if CoralDistance ~= nil then
                        if CoralDistance <= 30 then
                            if not CoralLocation.PickedUp then
                                DrawMarker(32, CoralLocation.coords.x, CoralLocation.coords.y, CoralLocation.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 1.0, 0.4, 255, 223, 0, 255, true, false, false, false, false, false, false)
                                if CoralDistance <= 1.5 then
                                    if not showText then
                                        exports['mr-text']:DrawText(
                                            '[E] Collecting coral',
                                            0, 94, 255,0.7,
                                            1,
                                            50
                                        )
                                        showText = true
                                    end
                                    if IsControlJustPressed(0, 38) then
                                        -- loadAnimDict("pickup_object")
                                        local times = math.random(2, 5)
                                        CallCops()
                                        FreezeEntityPosition(Ped, true)
                                        MRFW.Functions.Progressbar("take_coral", "Collecting coral", times * 1000, false, true, {
                                            disableMovement = true,
                                            disableCarMovement = true,
                                            disableMouse = false,
                                            disableCombat = true,
                                        }, {
                                            animDict = "weapons@first_person@aim_rng@generic@projectile@thermal_charge@",
                                            anim = "plant_floor",
                                            flags = 16,
                                        }, {}, {}, function() -- Done
                                            TakeCoral(cur)
                                            ClearPedTasks(Ped)
                                            FreezeEntityPosition(Ped, false)
                                        end, function() -- Cancel
                                            ClearPedTasks(Ped)
                                            FreezeEntityPosition(Ped, false)
                                        end)
                                    end
                                else
                                    if showText then
                                        exports['mr-text']:HideText(1)
                                        showText = false
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        if not inRange then
            Wait(2500)
        end

        Wait(5)
    end
end)

function TakeCoral(coral)
    MRDiving.Locations[CurrentDivingLocation.Area].coords.Coral[coral].PickedUp = true
    TriggerServerEvent('mr-diving:server:TakeCoral', CurrentDivingLocation.Area, coral, true)
end

RegisterNetEvent('mr-diving:client:UpdateCoral', function(Area, Coral, Bool)
    MRDiving.Locations[Area].coords.Coral[Coral].PickedUp = Bool
end)

function CallCops()
    local Call = math.random(1, 3)
    local Chance = math.random(1, 3)
    local Ped = PlayerPedId()
    local Coords = GetEntityCoords(Ped)

    if Call == Chance then
        TriggerServerEvent('mr-diving:server:CallCops', Coords)
    end
end

RegisterNetEvent('mr-diving:server:CallCops', function(Coords, msg)
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerEvent("chatMessage", "911 MESSAGE", "error", msg)
    local transG = 100
    local blip = AddBlipForRadius(Coords.x, Coords.y, Coords.z, 100.0)
    SetBlipSprite(blip, 9)
    SetBlipColour(blip, 1)
    SetBlipAlpha(blip, transG)
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("911 - Dive site")
    EndTextCommandSetBlipName(blip)
    while transG ~= 0 do
        Wait(180 * 4)
        transG = transG - 1
        SetBlipAlpha(blip, transG)
        if transG == 0 then
            SetBlipSprite(blip, 2)
            RemoveBlip(blip)
            return
        end
    end
end)

local currentGear = {
    mask = 0,
    tank = 0,
    enabled = false
}

function DeleteGear()
	if currentGear.mask ~= 0 then
        DetachEntity(currentGear.mask, 0, 1)
        DeleteEntity(currentGear.mask)
		currentGear.mask = 0
    end
    
	if currentGear.tank ~= 0 then
        DetachEntity(currentGear.tank, 0, 1)
        DeleteEntity(currentGear.tank)
		currentGear.tank = 0
	end
end
local function round(input, decimalPlaces)
    return tonumber(string.format("%." .. (decimalPlaces or 0) .. "f", input))
end
local oxygen = 0
local function Timing(bool)
    local enable = bool
    -- print(enable)
    if enable then
        oxygen = math.random(MRBoatshop.TimingMin, MRBoatshop.TimingMax)
        while enable do
            Wait(0)
            while oxygen > 0 do
                Wait(5)
                Text("~r~"..round(oxygen, 1).." ~w~lt ~b~Oxygen ~y~Left In Your ~g~Tank", 4, 0.45, 0.18, 0.915)
                if IsPedSwimmingUnderWater(PlayerPedId()) then
                    local ped = PlayerPedId()
                    -- print(oxygen)
                    oxygen = oxygen - 0.015
                    oxy = oxygen*100
                    -- print(oxy)
                    SetPedMaxTimeUnderwater(PlayerPedId(), oxy)
                    SetPlayerUnderwaterTimeRemaining(PlayerPedId(),oxy )
                end
            end
        end
    else
        oxygen = 0
    end
end

function Text(content, font, scale, x, y)
    SetTextFont(font)
    SetTextScale(scale, scale)
    SetTextProportional(0)
    SetTextColour(255,255,255,255)
    SetTextEntry("STRING")
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    AddTextComponentString(content)
    DrawText(x, y)
end

local gearInfo = nil

RegisterNetEvent('mr-diving:client:UseGear', function(bool, iteminfo)
    if bool then
        GearAnim()
        MRFW.Functions.Progressbar("equip_gear", "Put on a diving suit", 5000, false, true, {}, {}, {}, {}, function() -- Done
            gearInfo = iteminfo
            DeleteGear()
            local maskModel = GetHashKey("p_d_scuba_mask_s")
            local tankModel = GetHashKey("p_s_scuba_tank_s")
    
            RequestModel(tankModel)
            while not HasModelLoaded(tankModel) do
                Wait(1)
            end
            TankObject = CreateObject(tankModel, 1.0, 1.0, 1.0, 1, 1, 0)
            local bone1 = GetPedBoneIndex(PlayerPedId(), 24818)
            AttachEntityToEntity(TankObject, PlayerPedId(), bone1, -0.25, -0.25, 0.0, 180.0, 90.0, 0.0, 1, 1, 0, 0, 2, 1)
            currentGear.tank = TankObject
    
            RequestModel(maskModel)
            while not HasModelLoaded(maskModel) do
                Wait(1)
            end
            
            MaskObject = CreateObject(maskModel, 1.0, 1.0, 1.0, 1, 1, 0)
            local bone2 = GetPedBoneIndex(PlayerPedId(), 12844)
            AttachEntityToEntity(MaskObject, PlayerPedId(), bone2, 0.0, 0.0, 0.0, 180.0, 90.0, 0.0, 1, 1, 0, 0, 2, 1)
            currentGear.mask = MaskObject
    
            SetEnableScuba(PlayerPedId(), true)
            SetPedMaxTimeUnderwater(PlayerPedId(), 2000.00)
            currentGear.enabled = true
            TriggerServerEvent('mr-diving:server:RemoveGear')
            ClearPedTasks(PlayerPedId())
            TriggerEvent('chatMessage', "SYSTEM", "error", "/divingsuit to take off your diving suit")
            Timing(true)
        end)
    else
        if currentGear.enabled then
            GearAnim()
            MRFW.Functions.Progressbar("remove_gear", "Pull out a diving suit ..", 5000, false, true, {}, {}, {}, {}, function() -- Done
                Timing(false)
                DeleteGear()

                SetEnableScuba(PlayerPedId(), false)
                SetPedMaxTimeUnderwater(PlayerPedId(), 1.00)
                currentGear.enabled = false
                TriggerServerEvent('mr-diving:server:GiveBackGear', gearInfo)
                ClearPedTasks(PlayerPedId())
                MRFW.Functions.Notify('You took your wetsuit off')
            end)
        else
            MRFW.Functions.Notify('You are not wearing a diving gear ..', 'error')
        end
    end
end)

function GearAnim()
    loadAnimDict("clothingshirt")    	
	TaskPlayAnim(PlayerPedId(), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
end

RegisterNetEvent('mr-diving:client:RemoveGear', function()
    TriggerEvent('mr-diving:client:UseGear', false)
end)