TryToFish = function(item)
    MRFW.Functions.TriggerCallback('mr-fishing:GetItemData', function(count)
        if IsPedSwimming(cachedData["ped"]) then return MRFW.Functions.Notify("You can't be swimming and fishing at the same time.", "error") end 
        if IsPedInAnyVehicle(cachedData["ped"]) then return MRFW.Functions.Notify("You need to exit your vehicle to start fishing.", "error") end 
        if count ~= nil then
            if count == 0 then
                MRFW.Functions.Notify("You need both a fishing rod and bait to fish.", "primary")
            else
                local waterValidated, castLocation = IsInWater()

                if waterValidated then
                    local fishingRod = GenerateFishingRod(cachedData["ped"])

                    CastBait(fishingRod, castLocation, item)
                else
                    MRFW.Functions.Notify("You need to aim towards the water to fish", "primary")
                end
            end
        end
    end, Config.FishingItems["rod"]["name"], Config.FishingItems["bait"]["name"])
end

local isFishing = false
CastBait = function(rodHandle, castLocation, item)
    if isFishing then return end
    isFishing = true

    local startedCasting = GetGameTimer()

    if not HasFishingBait() then
        MRFW.Functions.Notify('You don\'t have any bait!', 'error')

        isFishing = false
        return DeleteEntity(rodHandle)
    end

    if not HasFishingRod() then
        isFishing = false
        return DeleteEntity(rodHandle)
    end

    while not IsControlJustPressed(0, 47) do
        Citizen.Wait(5)

        ShowHelpNotification("Cast your line by pressing ~INPUT_DETONATE~")

        if GetGameTimer() - startedCasting > 5000 then
            MRFW.Functions.Notify("You need to cast the bait.", "primary")

            isFishing = false
            return DeleteEntity(rodHandle)
        end
    end

    PlayAnimation(cachedData["ped"], "mini@tennis", "forehand_ts_md_far", {
        ["flag"] = 48
    })

    while IsEntityPlayingAnim(cachedData["ped"], "mini@tennis", "forehand_ts_md_far", 3) do
        Citizen.Wait(0)
    end

    PlayAnimation(cachedData["ped"], "amb@world_human_stand_fishing@idle_a", "idle_c", {
        ["flag"] = 11
    })

    local startedBaiting = GetGameTimer()
    local randomBait = math.random(10000, 15000)

    -- DrawBusySpinner("Waiting for a fish that is biting..")
    MRFW.Functions.Notify("Waiting for a fish to bite...", "success", "10000")
    TriggerServerEvent('MRFW:Server:RemoveItem', "fishingbait", 1)
	TriggerEvent("inventory:client:ItemBox", MRFW.Shared.Items["fishingbait"], "remove")

    local interupted = false

    Citizen.Wait(1000)

    while GetGameTimer() - startedBaiting < randomBait do
        Citizen.Wait(5)

        if not IsEntityPlayingAnim(cachedData["ped"], "amb@world_human_stand_fishing@idle_a", "idle_c", 3) then
            interupted = true

            break
        end
    end

    RemoveLoadingPrompt()

    if interupted then
        ClearPedTasks(cachedData["ped"])

        isFishing = false
        CastBait(rodHandle, castLocation, item)
        return DeleteEntity(rodHandle)
    end
    
    local caughtFish = TryToCatchFish()

    ClearPedTasks(cachedData["ped"])

    if caughtFish then
        giveFish(item)
        TriggerServerEvent('hud:server:RelieveStress', 5)
    else
        MRFW.Functions.Notify("The fish got loose.", "error")
    end
    
    isFishing = false
    CastBait(rodHandle, castLocation, item)
    return DeleteEntity(rodHandle)
end

TryToCatchFish = function()
    local minigameSprites = {
        ["powerDict"] = "custom",
        ["powerName"] = "bar",
    
        ["tennisDict"] = "tennis",
        ["tennisName"] = "swingmetergrad"
    }

    while not HasStreamedTextureDictLoaded(minigameSprites["powerDict"]) and not HasStreamedTextureDictLoaded(minigameSprites["tennisDict"]) do
        RequestStreamedTextureDict(minigameSprites["powerDict"], false)
        RequestStreamedTextureDict(minigameSprites["tennisDict"], false)

        Citizen.Wait(5)
    end

    local swingOffset = 0.09
    local swingReversed = false

    local DrawObject = function(x, y, width, height, red, green, blue)
        DrawRect(x + (width / 2.0), y + (height / 2.0), width, height, red, green, blue, 150)
    end

    while true do
        Citizen.Wait(5)

        ShowHelpNotification("Press ~INPUT_CONTEXT~ in the green area.")

        DrawSprite(minigameSprites["powerDict"], minigameSprites["powerName"], 0.5, 0.4, 0.01, 0.2, 0.0, 255, 99, 99, 255)

        DrawObject(0.49453227, 0.3, 0.010449, 0.03, 130, 255, 95)

        DrawSprite(minigameSprites["tennisDict"], minigameSprites["tennisName"], 0.5, 0.4 + swingOffset, 0.018, 0.002, 0.0, 0, 0, 0, 255)

        if swingReversed then
            swingOffset = swingOffset - 0.005
        else
            swingOffset = swingOffset + 0.005
        end

        if swingOffset > 0.09 then
            swingReversed = true
        elseif swingOffset < -0.09 then
            swingReversed = false
        end

        if IsControlJustPressed(0, 38) then
            swingOffset = 0 - swingOffset

            extraPower = (swingOffset + 0.09) * 250 + 1.0

            -- print(extraPower)
            if extraPower >= 30 then
                return true
            else
                return false
            end
        end
    end

    SetStreamedTextureDictAsNoLongerNeeded(minigameSprites["powerDict"])
    SetStreamedTextureDictAsNoLongerNeeded(minigameSprites["tennisDict"])
end



IsInWater = function()
    local startedCheck = GetGameTimer()

    local ped = cachedData["ped"]
    local pedPos = GetEntityCoords(ped)

    local forwardVector = GetEntityForwardVector(ped)
    local forwardPos = vector3(pedPos["x"] + forwardVector["x"] * 10, pedPos["y"] + forwardVector["y"] * 10, pedPos["z"])

    local fishHash = `a_c_fish`

    WaitForModel(fishHash)

    local waterHeight = GetWaterHeight(forwardPos["x"], forwardPos["y"], forwardPos["z"])

    local fishHandle = CreatePed(1, fishHash, forwardPos, 0.0, false)
    
    SetEntityAlpha(fishHandle, 0, true) -- makes the fish invisible.

    -- DrawBusySpinner("Checking fishing location....")
    MRFW.Functions.Notify("Checking fishing location...", "success", "3000")

    while GetGameTimer() - startedCheck < 3000 do
        Citizen.Wait(0)
    end

    RemoveLoadingPrompt()

    local fishInWater = IsEntityInWater(fishHandle)

    DeleteEntity(fishHandle)

    SetModelAsNoLongerNeeded(fishHash)

    return fishInWater, fishInWater and vector3(forwardPos["x"], forwardPos["y"], waterHeight) or false
end

GenerateFishingRod = function(ped)
    local pedPos = GetEntityCoords(ped)
    
    local fishingRodHash = `prop_fishing_rod_01`

    WaitForModel(fishingRodHash)

    local rodHandle = CreateObject(fishingRodHash, pedPos, true)

    AttachEntityToEntity(rodHandle, ped, GetPedBoneIndex(ped, 18905), 0.1, 0.05, 0, 80.0, 120.0, 160.0, true, true, false, true, 1, true)

    SetModelAsNoLongerNeeded(fishingRodHash)

    return rodHandle
end

HandleStore = function()
    local storeData = Config.FishingRestaurant

    WaitForModel(storeData["ped"]["model"])

    local pedHandle = CreatePed(5, storeData["ped"]["model"], storeData["ped"]["position"], storeData["ped"]["heading"], false)

    SetEntityInvincible(pedHandle, true)
    SetEntityAsMissionEntity(pedHandle, true, true)
    SetBlockingOfNonTemporaryEvents(pedHandle, true)

    cachedData["storeOwner"] = pedHandle

    SetModelAsNoLongerNeeded(storeData["ped"]["model"])

    -- local storeBlip = AddBlipForCoord(storeData["ped"]["position"])
	
    -- SetBlipSprite(storeBlip, storeData["blip"]["sprite"])
    -- SetBlipScale(storeBlip, 0.65)
    -- SetBlipColour(storeBlip, storeData["blip"]["color"])
    -- SetBlipAsShortRange(storeBlip, true)
    -- BeginTextCommandSetBlipName("STRING")
    -- AddTextComponentString(storeData["name"])
    -- EndTextCommandSetBlipName(storeBlip)
end


SellFish = function()
    MRFW.Functions.TriggerCallback('mr-fishing:GetItemData', function(count)
        TaskTurnPedToFaceEntity(cachedData["storeOwner"], cachedData["ped"], 1000)
        TaskTurnPedToFaceEntity(cachedData["ped"], cachedData["storeOwner"], 1000)

        TriggerServerEvent("mr-fishing:sellFish", function(sold, fishesSold) end)
    end)
end



PlayAnimation = function(ped, dict, anim, settings)
	if dict then
        Citizen.CreateThread(function()
            RequestAnimDict(dict)

            while not HasAnimDictLoaded(dict) do
                Citizen.Wait(100)
            end

            if settings == nil then
                TaskPlayAnim(ped, dict, anim, 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)
            else 
                local speed = 1.0
                local speedMultiplier = -1.0
                local duration = 1.0
                local flag = 0
                local playbackRate = 0

                if settings["speed"] then
                    speed = settings["speed"]
                end

                if settings["speedMultiplier"] then
                    speedMultiplier = settings["speedMultiplier"]
                end

                if settings["duration"] then
                    duration = settings["duration"]
                end

                if settings["flag"] then
                    flag = settings["flag"]
                end

                if settings["playbackRate"] then
                    playbackRate = settings["playbackRate"]
                end

                TaskPlayAnim(ped, dict, anim, speed, speedMultiplier, duration, flag, playbackRate, 0, 0, 0)
            end
      
            RemoveAnimDict(dict)
		end)
	else
		TaskStartScenarioInPlace(ped, anim, 0, true)
	end
end

FadeOut = function(duration)
    DoScreenFadeOut(duration)
    
    while not IsScreenFadedOut() do
        Citizen.Wait(0)
    end
end

FadeIn = function(duration)
    DoScreenFadeIn(500)

    while not IsScreenFadedIn() do
        Citizen.Wait(0)
    end
end

WaitForModel = function(model)
    if not IsModelValid(model) then
        return
    end

	if not HasModelLoaded(model) then
		RequestModel(model)
	end
	
	while not HasModelLoaded(model) do
		Citizen.Wait(0)
	end
end

DrawBusySpinner = function(text)
    SetLoadingPromptTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    ShowLoadingPrompt(3)
end

ShowHelpNotification = function(msg, thisFrame, beep, duration)
	AddTextEntry('ajHelpNotification', msg)

	if thisFrame then
		DisplayHelpTextThisFrame('ajHelpNotification', false)
	else
		if beep == nil then beep = true end
		BeginTextCommandDisplayHelp('ajHelpNotification')
		EndTextCommandDisplayHelp(0, false, beep, duration or -1)
	end
end

function HasFishingBait()
    local rtval = false
    MRFW.Functions.TriggerCallback('MRFW:HasItem', function(amount)
        if amount then
            rtval = true
        end
    end, "fishingbait")
    Wait(1000)
    return rtval
end

function HasFishingRod()
    local rtval2 = false
    MRFW.Functions.TriggerCallback('MRFW:HasItemV2', function(has, info)
        if has then
            if info.info.uses >= 1 then
                rtval2 = true
            end
        end
    end, 'fishingrod')
    Wait(1000)
    return rtval2
end

function giveFish(item)

    local kismat = math.random(1, 100)
    local kismatFound = true
    local kismatCount = 1

    if kismatFound then
        for i = 1, kismatCount, 1 do
            if kismat == 100 then
                MRFW.Functions.Progressbar("makingphoto", "Catching fish..", 500, false, true, {
                }, {}, {}, {}, function()
                end)
                TriggerServerEvent("mr-fishing:receiveFish", castLocation, function(received) end)
            elseif kismat >= 90 and kismat <= 99 then
                MRFW.Functions.Progressbar("makingphoto", "Catching fish..", 500, false, true, {
                }, {}, {}, {}, function()
                end)
				TriggerServerEvent("mr-fishing:receiveFish", castLocation, function(received) end)

            elseif kismat >= 80 and kismat <= 90 then
                MRFW.Functions.Progressbar("makingphoto", "Catching fish..", 500, false, true, {
                }, {}, {}, {}, function()
                end)
                local infos = {}
                infos.uses = item.info.uses - 1
                TriggerServerEvent('MRFW:Server:RemoveItem', item.name, item.amount, item.slot)
                TriggerServerEvent("MRFW:Server:AddItem", item.name, item.amount, item.slot, infos)
                MRFW.Functions.Notify("Opps! Your rod got broken!", "error")
                interupted = true
                DeleteEntity(rodHandle)

            elseif kismat >= 60 and kismat <= 80 then
                MRFW.Functions.Progressbar("makingphoto", "Catching fish..", 500, false, true, {
                }, {}, {}, {}, function()
                end)
				TriggerServerEvent("mr-fishing:receiveFish", castLocation, function(received) end)

            elseif kismat >= 40 and kismat <= 60 then
                MRFW.Functions.Progressbar("makingphoto", "Catching fish..", 500, false, true, {
                }, {}, {}, {}, function()
                end)
                local infos = {}
                infos.uses = item.info.uses - 1
                TriggerServerEvent('MRFW:Server:RemoveItem', item.name, item.amount, item.slot)
                TriggerServerEvent("MRFW:Server:AddItem", item.name, item.amount, item.slot, infos)
                MRFW.Functions.Notify("Opps! Your rod got broken!", "error")
                interupted = true
                DeleteEntity(rodHandle)

            elseif kismat >= 20 and kismat <= 50 then
                MRFW.Functions.Progressbar("makingphoto", "Catching fish..", 500, false, true, {
                }, {}, {}, {}, function()
                end)
				TriggerServerEvent("mr-fishing:receiveFish", castLocation, function(received) end)

			elseif kismat >= 0 and kismat <= 20 then
                MRFW.Functions.Progressbar("makingphoto", "Catching fish..", 500, false, true, {
                }, {}, {}, {}, function()
                end)
				TriggerServerEvent("mr-fishing:receiveFish", castLocation, function(received) end)
            end
            Citizen.Wait(500)
        end
    end
end