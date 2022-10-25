function DrawText3Ds(x, y, z, text)
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

-- Citizen.CreateThread(function()
--     while true do
--         local InRange = false
--         local PlayerPed = PlayerPedId()
--         local PlayerPos = GetEntityCoords(PlayerPed)

--         for shop, _ in pairs(Config.Locations) do
--             local position = Config.Locations[shop]["coords"]
--             local products = Config.Locations[shop].products
--             for _, loc in pairs(position) do
--                 local dist = #(PlayerPos - vector3(loc["x"], loc["y"], loc["z"]))
--                 if dist < 10 then
--                     InRange = true
--                     DrawMarker(2, loc["x"], loc["y"], loc["z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.25, 0.2, 0.1, 255, 255, 255, 155, 0, 0, 0, 1, 0, 0, 0)
--                     if dist < 1 then
--                         DrawText3Ds(loc["x"], loc["y"], loc["z"] + 0.15, '~g~E~w~ - Shop')
--                         if IsControlJustPressed(0, 38) then -- E
--                             local ShopItems = {}
--                             ShopItems.items = {}
--                             MRFW.Functions.TriggerCallback('mr-shops:server:getLicenseStatus', function(hasLicense, hasLicenseItem)
--                                 ShopItems.label = Config.Locations[shop]["label"]
--                                 if Config.Locations[shop].type == "weapon" then
--                                     if hasLicense and hasLicenseItem then
--                                         ShopItems.items = SetupItems(shop)
--                                         MRFW.Functions.Notify("The dealer verifies your license", "success")
--                                         Citizen.Wait(500)
--                                         for k, v in pairs(ShopItems.items) do
--                                             ShopItems.items[k].slot = k
--                                         end
--                                         ShopItems.slots = 30
--                                         TriggerServerEvent("inventory:server:OpenInventory", "shop", "Itemshop_"..shop, ShopItems)
--                                     else
--                                         for i = 1, #products do
--                                             if not products[i].requiredJob then
--                                                 if not products[i].requiresLicense then
--                                                     table.insert(ShopItems.items, products[i])
--                                                 end
--                                             else
--                                                 for i2 = 1, #products[i].requiredJob do
--                                                     if MRFW.Functions.GetPlayerData().job.name == products[i].requiredJob[i2] and not products[i].requiresLicense then
--                                                         table.insert(ShopItems.items, products[i])
--                                                     end
--                                                 end
--                                             end
--                                         end
--                                         MRFW.Functions.Notify("The dealer declines to show you firearms", "error")
--                                         Citizen.Wait(500)
--                                         MRFW.Functions.Notify("Speak with law enforcement to get a firearms license", "error")
--                                         Citizen.Wait(1000)
--                                     end
--                                 else
--                                     ShopItems.items = SetupItems(shop)
--                                     for k, v in pairs(ShopItems.items) do
--                                         ShopItems.items[k].slot = k
--                                     end
--                                     ShopItems.slots = 30
--                                     TriggerServerEvent("inventory:server:OpenInventory", "shop", "Itemshop_"..shop, ShopItems)
--                                 end
--                             end)
--                         end
--                     end
--                 end
--             end
--         end

--         if not InRange then
--             Citizen.Wait(5000)
--         end
--         Citizen.Wait(5)
--     end
-- end)

RegisterNetEvent('mr-shops:marketshop')
AddEventHandler('mr-shops:marketshop', function(shop, itemData, amount)
local PlayerPed = PlayerPedId()
local PlayerPos = GetEntityCoords(PlayerPed)

for shop, _ in pairs(Config.Locations) do
   local position = Config.Locations[shop]["coords"]
   for _, loc in pairs(position) do
      local dist = #(PlayerPos - vector3(loc["x"], loc["y"], loc["z"]))
      if dist < 2 then
         local ShopItems = {}
         ShopItems.items = {}
         MRFW.Functions.TriggerCallback('mr-shops:server:getLicenseStatus', function(hasLicense, hasLicenseItem, isMW)
         ShopItems.label = Config.Locations[shop]["label"]
         if Config.Locations[shop].type == "weapon" then
            if hasLicense and (hasLicenseItem or isMW) then
                ShopItems.items = SetupItems(shop)
                MRFW.Functions.Notify("The dealer verifies your license", "success")
                Citizen.Wait(500)
                for k, v in pairs(ShopItems.items) do
                    ShopItems.items[k].slot = k
                end
                ShopItems.slots = 30
                TriggerServerEvent("inventory:server:OpenInventory", "shop", "Itemshop_"..shop, ShopItems)
            else
                for i = 1, #Config.Locations[shop]["products"] do
                    if not Config.Locations[shop]["products"][i].requiredJob then
                        if not Config.Locations[shop]["products"][i].requiresLicense then
                            table.insert(ShopItems.items, Config.Locations[shop]["products"][i])
                        end
                    else
                        if not Config.Locations[shop]["products"][i].requiredGrade then
                            for i2 = 1,#Config.Locations[shop]["products"][i].requiredJob do
                                if MRFW.Functions.GetPlayerData().job.name == Config.Locations[shop]["products"][i].requiredJob[i2] and not Config.Locations[shop]["products"][i].requiresLicense then
                                    table.insert(ShopItems.items, Config.Locations[shop]["products"][i])
                                end
                            end
                        else
                            for i2 = 1,#Config.Locations[shop]["products"][i].requiredJob do
                                if MRFW.Functions.GetPlayerData().job.name == Config.Locations[shop]["products"][i].requiredJob[i2] and not Config.Locations[shop]["products"][i].requiresLicense then
                                    for i3 = 1, #Config.Locations[shop]["products"][i].requiredGrade do
                                        if MRFW.Functions.GetPlayerData().job.grade.level == Config.Locations[shop]["products"][i].requiredGrade[i3] then
                                            table.insert(ShopItems.items, Config.Locations[shop]["products"][i])
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                MRFW.Functions.Notify("The dealer declines to show you firearms", "error")
                Citizen.Wait(500)
                MRFW.Functions.Notify("Speak with law enforcement to get a firearms license", "error")
                Citizen.Wait(1000)
            end
         else
            ShopItems.items = SetupItems(shop)
            for k, v in pairs(ShopItems.items) do
                ShopItems.items[k].slot = k
            end
            ShopItems.slots = 30
            TriggerServerEvent("inventory:server:OpenInventory", "shop", "Itemshop_"..shop, ShopItems)
         end
         end)
      end
   end
end
end)

function SetupItems(shop)
    local products = Config.Locations[shop].products
    local playerJob = MRFW.Functions.GetPlayerData().job
    local items = {}

    for i = 1, #products do
        if not products[i].requiredJob then
            table.insert(items, products[i])
        else
            if not products[i].requiredGrade then
                for i2 = 1, #products[i].requiredJob do
                    if playerJob.name == products[i].requiredJob[i2] then
                        table.insert(items, products[i])
                    end
                end
            else
                for i2 = 1, #products[i].requiredJob do
                    if playerJob.name == products[i].requiredJob[i2] then
                        for i3 = 1, #products[i].requiredGrade do
                            if playerJob.grade.level == products[i].requiredGrade[i3] then
                                table.insert(items, products[i])
                            end
                        end
                    end
                end
            end
        end
    end

    return items
end

RegisterNetEvent('mr-shops:client:UpdateShop')
AddEventHandler('mr-shops:client:UpdateShop', function(shop, itemData, amount)
    TriggerServerEvent('mr-shops:server:UpdateShopItems', shop, itemData, amount)
end)

RegisterNetEvent('mr-shops:client:SetShopItems')
AddEventHandler('mr-shops:client:SetShopItems', function(shop, shopProducts)
    Config.Locations[shop]["products"] = shopProducts
end)

RegisterNetEvent('mr-shops:client:RestockShopItems')
AddEventHandler('mr-shops:client:RestockShopItems', function(shop, amount)
    if Config.Locations[shop]["products"] ~= nil then 
        for k, v in pairs(Config.Locations[shop]["products"]) do 
            Config.Locations[shop]["products"][k].amount = Config.Locations[shop]["products"][k].amount + amount
        end
    end
end)

Citizen.CreateThread(function()
    for store,_ in pairs(Config.Locations) do
	if Config.Locations[store]["showblip"] then
	    StoreBlip = AddBlipForCoord(Config.Locations[store]["coords"][1]["x"], Config.Locations[store]["coords"][1]["y"], Config.Locations[store]["coords"][1]["z"])
	    SetBlipColour(StoreBlip, 0)

	    if Config.Locations[store]["products"] == Config.Products["normal"] then --done
            SetBlipSprite(StoreBlip, 52)
            SetBlipScale(StoreBlip, 0.6)
        elseif Config.Locations[store]["products"] == Config.Products["normal2"] then --done
            SetBlipSprite(StoreBlip, 52)
            SetBlipScale(StoreBlip, 0.6)
        elseif Config.Locations[store]["products"] == Config.Products["ophone"] then --done
            SetBlipSprite(StoreBlip, 606)
            SetBlipScale(StoreBlip, 0.7)
        elseif Config.Locations[store]["products"] == Config.Products["petshop"] then --done
            SetBlipSprite(StoreBlip, 267)
            SetBlipScale(StoreBlip, 0.7)
        elseif Config.Locations[store]["products"] == Config.Products["gearshop"] then --done
            SetBlipSprite(StoreBlip, 52)
            SetBlipScale(StoreBlip, 0.6)
        elseif Config.Locations[store]["products"] == Config.Products["hardware"] then --done
            SetBlipSprite(StoreBlip, 402)
            SetBlipScale(StoreBlip, 0.8)
        elseif Config.Locations[store]["products"] == Config.Products["weapons"] then --done
            SetBlipSprite(StoreBlip, 110)
            SetBlipScale(StoreBlip, 0.85)
        elseif Config.Locations[store]["products"] == Config.Products["leisureshop"] then --done
            SetBlipSprite(StoreBlip, 52)
            SetBlipScale(StoreBlip, 0.6)
            SetBlipColour(StoreBlip, 3)
        -- elseif Config.Locations[store]["products"] == Config.Products["coffeeshop"] then --done
        --     SetBlipSprite(StoreBlip, 140)
        --     SetBlipScale(StoreBlip, 0.55)
        elseif Config.Locations[store]["products"] == Config.Products["weedsuper"] then --done
            SetBlipSprite(StoreBlip, 140)
            SetBlipScale(StoreBlip, 0.55)
        elseif Config.Locations[store]["products"] == Config.Products["casinobb"] then --done
            SetBlipSprite(StoreBlip, 605)
            SetBlipScale(StoreBlip, 0.75)
        -- elseif Config.Locations[store]["products"] == Config.Products["Diego"] then
        --     SetBlipSprite(StoreBlip, 524)
        --     SetBlipScale(StoreBlip, 0.55)
        -- elseif Config.Locations[store]["products"] == Config.Products["bahama"] then
        --     SetBlipSprite(StoreBlip, 279)
        --     SetBlipScale(StoreBlip, 0.55)
        --     SetBlipColour(StoreBlip, 1)
        -- elseif Config.Locations[store]["products"] == Config.Products["waterclub"] then
        --     SetBlipSprite(StoreBlip, 93)
        --     SetBlipScale(StoreBlip, 0.65)
        --     SetBlipColour(StoreBlip, 0)
        -- elseif Config.Locations[store]["products"] == Config.Products["comedyclub"] then
        --     SetBlipSprite(StoreBlip, 102)
        --     SetBlipScale(StoreBlip, 0.75)
        --     SetBlipColour(StoreBlip, 1)
        -- elseif Config.Locations[store]["products"] == Config.Products["unicorn"] then
        --     SetBlipSprite(StoreBlip, 121)
        --     SetBlipScale(StoreBlip, 0.65)
        --     SetBlipColour(StoreBlip, 1)
        -- elseif Config.Locations[store]["products"] == Config.Products["hotdog"] then
        --     SetBlipSprite(StoreBlip, 0)          
        -- elseif Config.Locations[store]["products"] == Config.Products["grocerystoreold"] then
        --     SetBlipSprite(StoreBlip, 103)
        --     SetBlipScale(StoreBlip, 0.70)
        --     SetBlipColour(StoreBlip, 5)
        elseif Config.Locations[store]["products"] == Config.Products["gov"] then
            SetBlipSprite(StoreBlip, 0)
        end

	    SetBlipDisplay(StoreBlip, 4)
	    SetBlipAsShortRange(StoreBlip, true)


	    BeginTextCommandSetBlipName("STRING")
	    AddTextComponentSubstringPlayerName(Config.Locations[store]["label"])
	    EndTextCommandSetBlipName(StoreBlip)
	end
    end
end)
