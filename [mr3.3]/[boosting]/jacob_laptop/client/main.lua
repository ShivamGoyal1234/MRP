local MRFW = exports['mrfw']:GetCoreObject()
local PlayerData = MRFW.Functions.GetPlayerData()
local PlayerJob = {}
local isJoinQueue, isContractStarted, Tier = false, false, nil
local carSpawned, carID, carmodel = nil, nil, nil
local display = false
local zone, inZone, blipDisplay, dropBlip, cooldown, inscratchPoint = nil, false, nil, nil, false, false
local scratchpoint 
local contract_started = false

OnlineCops = 0


local tabletDict = "amb@code_human_in_bus_passenger_idles@female@tablet@base"
local tabletAnim = "base"
local tabletProp = 'prop_cs_tablet'
local tabletBone = 60309
local tabletOffset = vector3(0.03, 0.002, -0.0)
local tabletRot = vector3(10.0, 160.0, 0.0)

RegisterNetEvent('MRFW:Client:OnPlayerLoaded', function()
    PlayerData = MRFW.Functions.GetPlayerData()
    PlayerJob = MRFW.Functions.GetPlayerData().job
    onDuty = true
    TriggerServerEvent('jacob-carboost:server:getItem')
    TriggerEvent('jacob-carboost:client:setupBoostingApp')
end)

RegisterNetEvent('police:SetCopCount', function (amount)
    OnlineCops = amount
end)

RegisterNetEvent('MRFW:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

RegisterNetEvent('MRFW:Player:SetPlayerData', function(val)
    PlayerData = val
end)

RegisterNetEvent('MRFW:Client:OnPlayerUnload', function ()
    PlayerJob = {}
    TriggerServerEvent('jacob-carboost:server:removeData', PlayerData.citizenid)  
    PlayerData = {}
    Config.BennysItems = {}
end)

RegisterNetEvent('MRFW:Client:SetDuty', function(duty)
    onDuty = duty
end)

-- function

function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type="openlaptop",
        status = bool
    })
    doAnimation()
end

local function createRadiusBlips(v)
    local blip = Citizen.InvokeNative(0x46818D79B1F7499A,v.x + math.random(0.0,150.0), v.y + math.random(0.0,80.0), v.z + math.random(0.0,5.0) , 200.0)
    SetBlipHighDetail(blip, true)
    SetBlipColour(blip, 68)
    SetBlipAsShortRange(blip, true)
    SetBlipAlpha(blip, 128)
    blipDisplay = blip
end

local function CreateBlip(coords, name, sprite, colour)
    colour = colour or 4
	local blip = AddBlipForCoord(coords)
	SetBlipSprite(blip, sprite)
	SetBlipScale(blip, 0.6)
	SetBlipColour(blip, colour)
	SetBlipDisplay(blip, 4)
    SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(name)
	EndTextCommandSetBlipName(blip)
	return blip
end

local function spawnAngryPed(coords)
    if coords and coords[1] then
        local peds = {}
        for k, v in pairs(coords) do
            local npc = {
                'a_m_m_beach_01',
                'a_m_m_og_boss_01',
                'a_m_m_soucent_01',
            }
            local x,y,z = v.x, v.y, v.z
            local model = npc[math.random(1, #npc)]
            local hash = GetHashKey(model)
            RequestModel(hash)
            while not HasModelLoaded(model) do
                Wait(50)
            end
            local ped = CreatePed(1, hash, x, y, z, 0.0, true, true)
            peds[#peds+1] = ped
            SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(ped), true)
            SetPedAccuracy(ped, 100)
            SetPedRelationshipGroupHash(ped, GetHashKey("AMBIENT_GANG_WEICHENG"))
            SetPedRelationshipGroupDefaultHash(ped, GetHashKey("AMBIENT_GANG_WEICHENG"))
            SetPedCombatAttributes(ped, 46, true)
            SetPedCombatAbility(ped, 100)
            GiveWeaponToPed(ped, "WEAPON_PISTOL", -1, false, true)
            SetPedDropsWeaponsWhenDead(ped, false)
            SetPedCombatMovement(ped, 3)
            SetPedCombatRange(ped, 2)
            SetPedFleeAttributes(ped, 0, 0)
            SetPedConfigFlag(ped, 58, true)
            SetPedConfigFlag(ped, 75, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            TaskGotoEntityAiming(ped, PlayerPedId(), 4.0, 50.0)
        end
        Wait(2000)
        for k, v in pairs(peds) do
            TaskShootAtEntity(v, PlayerPedId(), -1)
        end
    end
end

-- Zamn thanks mr-mdt 😎
function doAnimation()
    if not display then return end
    -- Animation
    RequestAnimDict(tabletDict)
    while not HasAnimDictLoaded(tabletDict) do Citizen.Wait(100) end
    -- Model
    RequestModel(tabletProp)
    while not HasModelLoaded(tabletProp) do Citizen.Wait(100) end

    local plyPed = PlayerPedId()

    local tabletObj = CreateObject(tabletProp, 0.0, 0.0, 0.0, true, true, false)

    local tabletBoneIndex = GetPedBoneIndex(plyPed, tabletBone)

    -- Set statebag inventory is in use
    TriggerEvent('actionbar:setEmptyHanded')

    AttachEntityToEntity(tabletObj, plyPed, tabletBoneIndex, tabletOffset.x, tabletOffset.y, tabletOffset.z, tabletRot.x, tabletRot.y, tabletRot.z, true, false, false, false, 2, true)
    SetModelAsNoLongerNeeded(tabletProp)

    CreateThread(function()
        while display do
            Wait(0)
            if not IsEntityPlayingAnim(plyPed, tabletDict, tabletAnim, 3) then
                TaskPlayAnim(plyPed, tabletDict, tabletAnim, 3.0, 3.0, -1, 49, 0, 0, 0, 0)
            end
        end
        ClearPedSecondaryTask(plyPed)
        Wait(250)
        DetachEntity(tabletObj, true, false)
        DeleteEntity(tabletObj)
    end)
end

local function StartHacking(vehicle)
    local veh = Entity(vehicle)
    local trackerLeft = veh.state.trackerLeft
    if veh.state.tracker then
        if not veh.state.hacked then
            local success =  exports['jacob_hacking']:StartHack()
            if success then
                local randomSeconds = math.random(30)
                trackerLeft = trackerLeft - 1
                veh.state.trackerLeft = trackerLeft
                veh.state.hacked = true
                if trackerLeft == 0 then
                    veh.state.tracker = false
                    veh.state.hacked = true
                    return MRFW.Functions.Notify(Lang:t("success.disable_tracker"))
                else
                    MRFW.Functions.Notify(Lang:t('success.tracker_off', {time = randomSeconds, tracker_left = trackerLeft}))
                end
                CreateThread(function ()
                    Wait(randomSeconds*1000)
                    veh.state.hacked = false
                end)
            else
                MRFW.Functions.Notify(Lang:t('error.disable_fail'), "error")
            end
        else
            MRFW.Functions.Notify(Lang:t('error.already_hacked'), "error")
        end
    else
        MRFW.Functions.Notify(Lang:t("error.no_tracker"), "error")
    end
end

local function RegisterCar(vehicle)
    local veh = Entity(vehicle)
    veh.state.tracker = true
    -- print(Tier)
    veh.state.trackerLeft = math.random(Config.Tier[Tier].attempt) or math.random(3)
    veh.state.hacked = false
end

local function finishBoosting(data)
    TriggerServerEvent('jacob-carboost:server:finishBoosting', 'normal', Tier)
    TriggerEvent('jacob-carboost:client:deleteContract')
    DeleteEntity(carSpawned)
    RemoveBlip(dropBlip)
    carSpawned = nil
    zone:destroy()
    zone = nil
    inZone = false
    isContractStarted = false
    carmodel = nil
    ContractID = nil
    Wait(1000)
    TriggerEvent('jacob-carboost:client:refreshQueue')
end

local function Scratching()
    TriggerServerEvent('jacob-carboost:server:finishBoosting', 'vin', Tier)
    TriggerEvent('jacob-carboost:client:deleteContract')
    scratchpoint:destroy()
    scratchpoint = nil
    RemoveBlip(dropBlip)
    carSpawned = nil
    inscratchPoint = false
    isContractStarted = false
    carmodel = nil
    ContractID = nil
    Wait(1000)
    TriggerEvent('jacob-carboost:client:refreshQueue')
end

local function BoostingAlert()
    if Config.Alert == 'mr-dispatch' then
        AlertBoosting(carID, 'mr-dispatch')
    elseif Config.Alert == 'linden_outlawalert' then
        AlertBoosting(carID, 'linden_outlawalert')
    else
        AlertBoosting(carID, 'notification')
    end
end

-- NUI
RegisterNUICallback('openlaptop', function (data)
    SetDisplay(false)
end)

RegisterNUICallback('exit', function (data)
    SetDisplay(false)
end)

RegisterNUICallback('loadstore', function (data, cb)
    local storeitem = {}
    if Config.BennysSell then
        for k, v in pairs(Config.BennysSell) do
            local name
            if not storeitem[k] then
                if MRFW.Shared.Items[v.item] ~= nil then
                    if Config.BennysSell[k].name then
                        name = Config.BennysSell[k].name
                    else
                       if MRFW.Shared.Items[v.item] ~= nil then
                           name = MRFW.Shared.Items[v.item].label
                       else
                        name = "Unknown"
                         return TriggerServerEvent('jacob-carboost:server:log', "")
                       end
                    end
                    storeitem[#storeitem+1] = {
                        name = name,
                        item = v.item,
                        image = Config.Inventory ..MRFW.Shared.Items[v.item].image,
                        price = v.price,
                        stock = v.stock
                    }
                else
                    TriggerServerEvent('jacob-carboost:server:log', "The item is not found :"..k)
                end
            else
                TriggerServerEvent("jacob-carboost:server:log", "Duplicate item found: " .. k)
            end
        end
        cb({
            storeitem = storeitem
        })
    else
        TriggerServerEvent('jacob-carboost:server:log', "The store is empty")
        cb({
            error = "The store is empty"
        })
    end
end)

RegisterCommand('testconfig', function()
    TriggerServerEvent('jacob-testing')
end)


RegisterNUICallback('canStartContract', function (data, cb)
    if OnlineCops < Config.MinimumPolice then
        return cb({
            error = "To start the contract you need at least "..Config.MinimumPolice.." cops online"
        })
    end
    if isContractStarted then
        return cb({
            error = "You already start the contract"
        })
    else
        if data.type == 'vin' then
            MRFW.Functions.TriggerCallback('jacob-carboost:server:vinmoney', function(result)
                if result and not result.error then
                    contract_started = true
                    return cb({
                        canStart = true
                    })
                else
                    return cb({
                        error = result.error or Lang:t('error.not_enough_money', {
                            money = Config.Payment
                        })
                    })
                end
            end, data)
        else
            contract_started = true
            return cb({
                canStart = true
            })
        end
    end
end)

RegisterNUICallback('startcontract', function (data)
    local data = data
    if not isContractStarted then
        isContractStarted = true
        Tier = data.data.tier
        MRFW.Functions.TriggerCallback('jacob-carboost:server:getContractData', function (result)
            if result then
                TriggerEvent('jacob-carboost:client:spawnCar', result)
            else
                -- print("NO RESULT")
            end
        end, data)
    else
    end
end)

RegisterNUICallback('stopcontract', function (data)
    if isContractStarted then
        isContractStarted = false
        contract_started = false
        TriggerEvent('jacob-carboost:client:stopContract')
    end
end)

RegisterNUICallback('checkout', function (data)
    MRFW.Functions.TriggerCallback('jacob-carboost:server:canBuy', function (result)
        if result then
            local firstTime = false
            if not Config.BennysItems[1] then
                firstTime = true
            end
            local itemData = {
                items = data.list,
                price = data.total
            }
            for k, v in pairs(itemData.items) do
                Config.BennysItems[#Config.BennysItems+1] = {
                    item = {
                        name = v.item,
                        quantity = v.quantity
                    }
                }
            end
            TriggerServerEvent('jacob-carboost:server:buyItem', itemData.price, Config.BennysItems, firstTime)
            SendNUIMessage({
                type="checkout",
                success = result
            })
        else
            SendNUIMessage({
                type="checkout",
                success = result
            })
        end
    end, data.total)
end)

RegisterNUICallback('setupboostapp', function (data, cb)
    MRFW.Functions.TriggerCallback('jacob-carboost:server:getboostdata', function (result)
        if result then
            local carboostdata = result
            for k, v in pairs(carboostdata.contract) do
                carboostdata.contract[k].carname = GetLabelText(GetDisplayNameFromVehicleModel(v.car))
                carboostdata.contract[k].vinprice = Config.Tier[v.tier].vinprice
            end
            cb({
                setting = {
                    payment = Config.Payment,
                    amount = Config.VINPayment,
                },
                boostdata = carboostdata
            })
        else
            cb({
                error = 'No boost data'
            })
        end
    end, PlayerData.citizenid)
end)

RegisterNUICallback('sellcontract', function(data, cb)
    MRFW.Functions.TriggerCallback('jacob-carboost:server:sellContract', function (result)
        if result then
            cb(result)
        else
            cb({
                error = 'Can\'t Sell because contract already started'
            })
        end
    end, data, contract_started)
end)

RegisterNUICallback('transfercontract', function (data, cb)
    MRFW.Functions.TriggerCallback('jacob-carboost:server:transfercontract', function (result)
        if result and not result.error then
            if not contract_started then
                cb({
                    success = result
                })
            else
                cb({
                    error = result.error or "Na ye Nahin ho sakta"
                })
            end
        else
            cb({
                error = result.error or "Invalid player"
            })
        end
    end, data, contract_started)
end)

RegisterNUICallback('joinqueue', function (data)
    TriggerEvent('jacob-carboost:client:joinQueue', data)
end)

RegisterNUICallback('buycontract', function(data, cb)
    MRFW.Functions.TriggerCallback('jacob-carboost:server:buycontract', function(result)
        if result then
            cb(result)
        end
    end, data)
end)

-- Event

RegisterNetEvent('jacob-carboost:client:setConfig', function (data)
    Config.BennysItems = data
end)

RegisterNetEvent('jacob-carboost:client:joinQueue', function (data)
    isJoinQueue = data.status
    local citizenid = PlayerData.citizenid
    TriggerServerEvent('jacob-carboost:server:joinQueue', isJoinQueue, citizenid)
end)

RegisterNetEvent('jacob-carboost:client:refreshQueue', function ()
    local citizenid = PlayerData.citizenid
    if isJoinQueue then
        TriggerServerEvent('jacob-carboost:server:joinQueue', false, citizenid)
        Wait(2000)
        TriggerServerEvent('jacob-carboost:server:joinQueue', true, citizenid)
    end
end)

RegisterNetEvent('jacob-carboost:client:giveContract', function ()
    SendNUIMessage({
        type="givecontract",
        data = {
            
        }
    })
end)

RegisterNetEvent('jacob-carboost:client:setupBoostingApp', function ()
    SendNUIMessage({
        type="setupboostingapp",
    })
end)

RegisterNetEvent('jacob-carboost:client:newContract', function ()
    TriggerServerEvent('jacob-carboost:server:newContract', PlayerData.citizenid)
end)

RegisterNetEvent('jacob-carboost:client:addContract', function (data)
    local vehName = GetLabelText(GetDisplayNameFromVehicleModel(data.car))
    data.carname = vehName
    data.vinprice = Config.Tier[data.tier].vinprice
    SendNUIMessage({
        type="addcontract",
        boost = data
    })
end)

RegisterNetEvent('jacob-carboost:client:takeAll', function ()
    TriggerServerEvent('jacob-carboost:server:takeAll', Config.BennysItems)
    Config.BennysItems = {}
end)

RegisterNetEvent('jacob-carboost:client:takeItem', function (data)
    TriggerServerEvent('jacob-carboost:server:takeItem', data.item, data.quantity)
    for k, v in pairs(Config.BennysItems) do
        if v.item.name == data.item then
           table.remove(Config.BennysItems, k)
        end
    end
    if Config.BennysItems[1] == nil then
        Config.BennysItems = {}
    end
    TriggerServerEvent('jacob-carboost:server:updateBennysConfig', Config.BennysItems)
end)

RegisterNetEvent('jacob-carboost:client:openMenu', function ()
    if Config.BennysItems[1] then
        local menu = {
            {
                header = "| Post OP |",
                isMenuHeader = true
            },
        }
        for _, v in pairs(Config.BennysItems) do
            local item = v.item
            local name = tostring(item.name)

            menu[#menu+1] = {
                header = MRFW.Shared.Items[item.name]["label"],
                id = item.name,
                txt = "You have: "..item.quantity,
                params = {
                    event = "jacob-carboost:client:takeItem",
                    args = {
                            item = item.name,
                            quantity = item.quantity
                    }
                }    
            }
        end
        menu[#menu+1] = {
            header = "Take all",
            id = "take all",
            txt = "Take all the items",
            params = {
                event = "jacob-carboost:client:takeAll"
            }

        }
        exports['mr-menu']:openMenu(menu)
    else
        MRFW.Functions.Notify(Lang:t("error.empty_post"), "error")
    end
end)

RegisterNetEvent('jacob-carboost:client:spawnCar', function(data)
    MRFW.Functions.TriggerCallback('jacob-carboost:server:spawnCar', function(result)
        if result then
            local zoneName = GetNameOfZone(result.spawnlocation)
            local streetlabel = GetLabelText(zoneName)
            Wait(5000)
            createRadiusBlips(result.spawnlocation)
            -- print(result.spawnlocation)
            carID = result.networkID
            carmodel = result.car
            TriggerServerEvent('mr-phone:server:sendNewMail', {
                sender = "Unknown",
                subject = "Car Location",
                message = "Hey this is the car location, its in near "..streetlabel,
             })
             TriggerEvent('jacob-carboost:client:startBoosting', result)
        end
    end, data)
end)

RegisterNetEvent('jacob-carboost:client:startBoosting', function (data)
    local data = data
    ContractID = data.id
    local modified = false
    CreateThread(function ()
        while true do
            Wait(5000)
            if carID ~= nil then
                if DoesEntityExist(NetworkGetEntityFromNetworkId(carID)) then
                    carSpawned = NetworkGetEntityFromNetworkId(carID)
                    if not modified then
                        MRFW.Functions.SetVehicleProperties(carSpawned, VehProp)
                        modified = true
                    end
                    local carcoords = GetEntityCoords(carSpawned)
                    local playerCoords = GetEntityCoords(PlayerPedId())
                    local dist = #(playerCoords - carcoords)
                    if dist <= 5.0 then
                        if blipDisplay ~= nil then
                            RemoveBlip(blipDisplay)
                            spawnAngryPed(data.npc)
                            TriggerEvent('jacob-carboost:client:playerInVehicle', data)
                            break
                        end
                    end
                end
            end
        end
    end)
end)

RegisterNetEvent('jacob-carboost:client:checkvin', function ()
    local vehicle = MRFW.Functions.GetClosestVehicle()
    if vehicle ~= 0 then
        local vehPos = GetEntityCoords(vehicle)
        local PlayerPos = GetEntityCoords(PlayerPedId())
        if #(PlayerPos - vehPos) <= 5.0 then
            local networkID = NetworkGetNetworkIdFromEntity(vehicle)
            if GetVehicleDoorLockStatus(vehicle) == 1 then
                    MRFW.Functions.Progressbar('check_vin', 'Checking VIN Number', 6000, false, true, { -- Name | Label | Time | useWhileDead | canCancel
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {
                        animDict = '"anim@amb@clubhouse@tutorial@bkr_tut_ig3@"@',
                        anim = 'machinic_loop_mechandplayer',
                        flags = 16,
                    }, {}, {}, function() 
                        MRFW.Functions.TriggerCallback('jacob-carboost:server:checkvin', function(result)
                            if result and result.success then
    
                                MRFW.Functions.Notify(result.message, "primary")
                               
                            else
                                MRFW.Functions.Notify("Hmm you can't found the VIN", "error")
                            end
                        end, networkID)
                        ClearPedTasks(PlayerPedId())
                    end, function() -- Play When Cancel
                        MRFW.Functions.Notify("Cancelled", "error")
                        ClearPedTasks(PlayerPedId())
                    end)
                else
                    MRFW.Functions.Notify("The vehicle is locked", "error")
                end
            else
                MRFW.Functions.Notify("No vehicle nearby", "error")
            end
        end
end)

RegisterNetEvent('jacob-carboost:client:vinscratch', function(veh)
    local ID = NetworkGetNetworkIdFromEntity(veh)
    MRFW.Functions.Progressbar('vin_scratching', 'Scratching VIN', 7000, false, true, { -- Name | Label | Time | useWhileDead | canCancel
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = '"anim@amb@clubhouse@tutorial@bkr_tut_ig3@"@',
        anim = 'machinic_loop_mechandplayer',
        flags = 1,
    }, {}, {}, function() -- Play When Done 
        MRFW.Functions.TriggerCallback('jacob-carboost:server:checkvin', function(result)
            if result and result.owner == PlayerData.citizenid then
                if result.vinscratch == 1 then
                    return MRFW.Functions.Notify('You already scratch this vehicle VIN', 'error')
                end
            else
                MRFW.Functions.TriggerCallback('MRFW:HasItemV2', function(has, info)
                    if has then
                        if info.amount >= 3 then
                            -- MRFW.Functions.Notify('VIN Scratched, you can change your plate number', 'primary')
                            local vehProp = MRFW.Functions.GetVehicleProperties(veh)
                            TriggerServerEvent('jacob-carboost:server:vinscratch', ID, vehProp, carmodel)
                            TriggerEvent('jacob-carboost:client:deleteContract')
                            Scratching()
                        else
                            MRFW.Functions.Notify('Not Enough Material', 'error', 3000)
                        end
                    else
                        MRFW.Functions.Notify('Something is missing', 'error', 3000)
                    end
                end, 'vehicleticket')
            end
        end, ID)
       
        ClearPedTasks(PlayerPedId())
    end, function() -- Play When Cancel
        --Stuff goes here
        ClearPedTasks(PlayerPedId())
    end)
end)
        
RegisterNetEvent('jacob-carboost:client:playerInVehicle', function (data)
    local data = data
    CreateThread(function ()
        while true do
            Wait(100)
            if IsPedInVehicle(PlayerPedId(), carSpawned, false) then
                if IsVehicleAlarmActivated(carSpawned) or IsVehicleEngineStarting(carSpawned) or GetIsVehicleEngineRunning(carSpawned) then       
                    TriggerEvent('jacob-carboost:client:trackersReady', data)
                    break
                end
            end
        end
    end)
end)

RegisterNetEvent('jacob-carboost:client:trackersReady', function (data)
    CreateThread(function ()
        while true do
            Wait(1000)
            if GetIsVehicleEngineRunning(carSpawned) then
                RegisterCar(carSpawned)
                BoostingAlert()
                TriggerEvent('jacob-carboost:client:startTracker', data)
                break
            end
        end
    end)
end)

RegisterNetEvent('jacob-carboost:client:startTracker', function(data)
    local veh = Entity(carSpawned)
    CreateThread(function ()
        while true do
            Wait(5000)
            if not veh.state.tracker then
                TriggerEvent("jacob-carboost:client:bringtoPlace", data)
                break
            end
        end
    end)
end)

RegisterNetEvent("jacob-carboost:client:bringtoPlace", function (data)
   
    if data.type == 'vin' then
        -- [todo] write vinscratch logic here
        local pz = Config.ScratchingPoint[math.random(1, #Config.ScratchingPoint)]
        TriggerServerEvent('mr-phone:server:sendNewMail', {
            sender = "Unknown",
            subject = "VIN Scratching",
            message = "You can scratch your VIN here",
        })
        dropBlip = CreateBlip(pz.coords, 'VIN Scratch', 255, 1)
        scratchpoint = BoxZone:Create(pz.coords, pz.length, pz.width, {
            name=pz.name,
            heading=pz.heading,
            -- debugPoly=true,
            minZ=pz.minZ,
            maxZ=pz.maxZ
        })
        scratchpoint:onPointInOut(function ()
            return GetEntityCoords(carSpawned)
        end, function (isPointInside, point)
            inscratchPoint = isPointInside
            if inscratchPoint then
                MRFW.Functions.Notify(Lang:t("info.in_scratch"))
            else
                MRFW.Functions.Notify(Lang:t("info.not_in_scratch"))
            end
        end)
    else
        local polyZone = Config.DropPoint[math.random(1, #Config.DropPoint)]
        TriggerServerEvent('mr-phone:server:sendNewMail', {
            sender = "Unknown",
            subject = "Drop point",
            message = "Hey this is the drop point, you can drop your car here, I'm sending you the coord on gps",
        })
        dropBlip = CreateBlip(polyZone.coords, "Drop Point", 225, 1)
        SetNewWaypoint(polyZone.coords)
        Wait(100)
        zone = BoxZone:Create(polyZone.coords, polyZone.length, polyZone.width, {
            name=polyZone.name,
            heading=polyZone.heading,
            -- debugPoly=true,
            minZ=polyZone.minZ,
            maxZ=polyZone.maxZ
        })
        zone:onPointInOut(function ()
            return GetEntityCoords(carSpawned)
        end, function (isPointInside, point)
            inZone = isPointInside
            if inZone then
                MRFW.Functions.Notify(Lang:t("info.car_inzone"))
            end
        end)
        CreateThread(function ()
            while true do
                Wait(100)
                if inZone then
                    if DoesEntityExist(carSpawned) then
                        if not IsPedInVehicle(PlayerPedId(), carSpawned, false) then
                            local playerCoords = GetEntityCoords(PlayerPedId())
                            local carcoords = GetEntityCoords(carSpawned)
                            local dist = #(playerCoords - carcoords)
                            if dist >= 30.0 then
                                finishBoosting(data)
                                break
                            end
                        end
                    end
                end
            end
        end)
    end
end)

RegisterNetEvent('jacob-carboost:client:finishBoosting', function (data)

end)

RegisterNetEvent('jacob-carboost:client:updateProggress', function (data)
    local data = {
        rep = PlayerData.metadata['carboostrep'],
        boostclass = PlayerData.metadata['carboostclass'],
        isNextLevel = data
    }
    SendNUIMessage({
        type = "updateProggress",
        boost = data
    })
end)

RegisterNetEvent('jacob-carboost:client:deleteContract', function ()
    SendNUIMessage({
        type = "removeContract",
        id = ContractID
    })
    TriggerServerEvent('jacob-carboost:server:deleteContract', ContractID)
end)

RegisterNetEvent('jacob-carboost:client:playerUnload', function()
    if carSpawned then
        DeleteVehicle(carSpawned)
    end
    if contract_started then
        contract_started = false
    end
    TriggerServerEvent('jacob-carboost:server:joinQueue', false, PlayerData.citizenid)
end)

RegisterNetEvent('jacob-carboost:client:failedBoosting', function ()
    if zone then
        zone:destroy()
        zone = nil
        inZone = false
    elseif scratchpoint then
        scratchpoint:destroy()
        scratchpoint = nil
        inscratchPoint = false
    end
    RemoveBlip(blipDisplay)
    RemoveBlip(dropBlip)
    DeleteEntity(carSpawned)
    carSpawned, carID, carmodel = nil, nil, nil
    blipDisplay, dropBlip = nil, nil
    isContractStarted = false
    MRFW.Functions.Notify(Lang:t("error.no_car"), "error")
    TriggerEvent('jacob-carboost:client:refreshQueue')
    TriggerEvent('jacob-carboost:client:deleteContract')
end)

RegisterNetEvent('jacob-carboost:client:openLaptop', function (item)
    local infos = {}
    infos.uses = item.info.uses - 1
    TriggerServerEvent('MRFW:Server:RemoveItem', item.name, item.amount, item.slot)
    TriggerServerEvent("MRFW:Server:AddItem", item.name, item.amount, item.slot, infos)
    SetDisplay(not display)
end)

RegisterNetEvent('jacob-carboost:client:loadBoostStore', function(data)
    local cdata = data
    local saleData = {}
    for k, v in pairs(cdata) do
        local data = json.decode(v.data)
        saleData[#saleData+1] = {
            id = v.id,
            owner = data.owner,
            carname = GetLabelText(GetDisplayNameFromVehicleModel(data.car)),
            expire = v.expire,
            plate = data.plate,
            tier = data.tier,
            price = v.price
        }
    end
    SendNUIMessage({
        type = "setupboostingstore",
        store = saleData
    })
end)

RegisterNetEvent('jacob-carboost:client:refreshContract', function ()
    MRFW.Functions.TriggerCallback('jacob-carboost:server:getContractData')
    SendNUIMessage({
        type = "refreshContract",
    })
end)

RegisterNetEvent('jacob-carboost:client:newContractSale', function(data)
    local data = data 
    data.carname = GetLabelText(GetDisplayNameFromVehicleModel(data.car))
    SendNUIMessage({
        type = "newContractSale",
        sale = data
    })
end)

RegisterNetEvent('jacob-carboost:client:contractBought', function(id)
    SendNUIMessage({
        type = "contractbought",
        id = id
    })
end)

RegisterNetEvent('jacob-carboost:client:useHackingDevice', function (item)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if IsPedInVehicle(playerPed, vehicle) then
        if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), 0) ~= 0 then
            if cooldown then
                return MRFW.Functions.Notify(Lang:t("error.cannot_use"), "error")
            end
            local infos = {}
            infos.uses = item.info.uses - 1
            TriggerServerEvent('MRFW:Server:RemoveItem', item.name, item.amount, item.slot)
            TriggerServerEvent("MRFW:Server:AddItem", item.name, item.amount, item.slot, infos)
            StartHacking(vehicle)
            cooldown = true
            Wait(5000)
            cooldown = false
        else
            return MRFW.Functions.Notify(Lang:t('error.not_seat'), "error")
        end
    else
        MRFW.Functions.Notify(Lang:t("error.not_on_vehicle"), "error")
    end
end)

RegisterNetEvent('jacob-carboost:client:fakeplate', function()
    local veh = MRFW.Functions.GetClosestVehicle()
    local vehID = NetworkGetNetworkIdFromEntity(veh)
    local playerpos = GetEntityCoords(PlayerPedId())
    local front = GetOffsetFromEntityInWorldCoords(veh, 0, -2.5, 0)
    local back = GetOffsetFromEntityInWorldCoords(veh, 0, 2.5, 0)
    local distFront = #(playerpos - front)
    local distBack = #(playerpos - back)
    if veh ~= 0 and not IsPedInAnyVehicle(PlayerPedId()) then
        if distFront < 2.0 or distBack < 2.0 then 
            MRFW.Functions.TriggerCallback('jacob-carboost:server:checkvin', function (result)
                if result then
                    if result.owner == PlayerData.citizenid then
                        MRFW.Functions.Progressbar('change_plate', 'Changing the plate', 8000, false, true, { -- Name | Label | Time | useWhileDead | canCancel
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        }, {
                            animDict = '"anim@amb@clubhouse@tutorial@bkr_tut_ig3@"@',
                            anim = 'machinic_loop_mechandplayer',
                            flags = 1,
                        }, {}, {}, function() -- Play When Done
                            TriggerEvent('jacob-carboost:client:setPlate', vehID)
                            ClearPedTasks(PlayerPedId())
                        end, function() -- Play When Cancel
                            ClearPedTasks(PlayerPedId())
                            --Stuff goes here
                        end)
                    else
                        MRFW.Functions.Notify(Lang:t("error.not_owner"), "error")
                    end
                end
            end, vehID)
        else
            MRFW.Functions.Notify(Lang:t("error.not_plate"), "error")
        end
    end
end)

function RandomPlate()
	local random = tostring(MRFW.Shared.RandomInt(1) .. MRFW.Shared.RandomStr(2) .. MRFW.Shared.RandomInt(3) .. MRFW.Shared.RandomStr(2)):upper()
   return random
end

RegisterNetEvent('jacob-carboost:client:setPlate', function (vehID)
    local veh = NetworkGetEntityFromNetworkId(vehID)
    if veh and veh ~= 0 then
        local plate = MRFW.Functions.GetPlate(veh)
        local newPlate = RandomPlate()
        SetVehicleNumberPlateText(veh, newPlate)
        TriggerServerEvent('jacob-carboost:server:setPlate', plate, newPlate)
        MRFW.Functions.Notify(Lang:t("success.plate_changed", {
            plate = newPlate
        }), "success")
        TriggerEvent('inventory:client:ItemBox', MRFW.Shared.Items["fake_plate"], "remove")
        TriggerServerEvent("MRFW:Server:RemoveItem", "fake_plate", 1)
        TriggerEvent('vehiclekeys:client:SetOwner', newPlate)
    end
end)

-- Threads
CreateThread(function ()
    while display do
        Wait(0)
        DisableControlAction(0, 1, display)
        DisableControlAction(0, 2, display)
        DisableControlAction(0, 142, display)
        DisableControlAction(0, 18, display)
        DisableControlAction(0, 322, display)
        DisableControlAction(0, 106, display)
    end
end)

CreateThread(function ()
    if LocalPlayer.state['isLoggedIn'] then
        Wait(5000)
        TriggerServerEvent('jacob-carboost:server:getItem')
        TriggerServerEvent('jacob-carboost:server:getBoostSale')
        TriggerEvent('jacob-carboost:client:setupBoostingApp')
    end
    -- CreateBlip(vector3(1185.2, -3303.92, 6.92), "Post OP", 473)
end)



-- Prevent the boosting still running when the car is destroyed / disappeared for no reason
CreateThread(function ()
    while true do
        Wait(1000)
        if carSpawned ~= nil and not DoesEntityExist(carSpawned) then
            if carSpawned ~= 0 then
                TriggerEvent('jacob-carboost:client:failedBoosting')
            end
        end
    end
end)

-- exports
exports['mr-eye']:AddBoxZone("carboost:takeItem", vector3(1185.14, -3304.01, 7.1), 2, 2, {
	name = "BennysTakePoint",
    heading=0,
    minZ=5.1,
    maxZ=9.1,
	-- debugPoly = true,
    scale= {1.0, 1.0, 1.0},
    }, {
	options = {
		{
            type = "client",
            event = "jacob-carboost:client:openMenu",
			icon = "fas fa-solid fa-box",
			label = "Take item",
		},
	},
	distance = 3.0
})


exports['mr-eye']:AddTargetBone('windscreen', {
    options = {
        {
            icon = "fas fa-tally",
            label = "Scratch VIN",
            canInteract = function ()
                return inscratchPoint
            end,
            action = function (entity)
                TriggerEvent('jacob-carboost:client:vinscratch', entity)
            end
        },
    },
    distance = 1.2
})

exports['mr-eye']:AddTargetBone('windscreen', {
    options = {
        {
            type = "client",
            icon = "fas fa-solid fa-car",
            label = "Check VIN",
            event = "jacob-carboost:client:checkvin",
            job = "police",
        },
    },
    distance = 2
})

AddEventHandler('onResourceStop', function(resource)
   if resource == GetCurrentResourceName() then
      if DoesEntityExist(carSpawned) then
          DeleteEntity(carSpawned)
      end
   end
end)

