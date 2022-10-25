MRFW = exports['mrfw']:GetCoreObject()
inside = false
closesthouse = nil
hasKey = false
contractOpen = false
local isOwned = false
local cam = nil
local viewCam = false
local FrontCam = false
local stashLocation = nil
local cupboardLocation = nil -- new
local outfitLocation = nil
local logoutLocation = nil
local OwnedHouseBlips = {}
local CurrentDoorBell = 0
local rangDoorbell = nil
local houseObj = {}
local POIOffsets = nil
local entering = false
local data = nil
local CurrentHouse = nil
local inHoldersMenu = false
local RamsDone = 0
local showText = false
local showText2 = false
local showText3 = false
local showText4 = false
local showText5 = false
local showText6 = false
local showText7 = false

-- Functions

local function DrawText3Ds(x, y, z, text)
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

local function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

local function openHouseAnim()
    loadAnimDict("anim@heists@keycard@") 
    TaskPlayAnim( PlayerPedId(), "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0 )
    Citizen.Wait(400)
    ClearPedTasks(PlayerPedId())
end

local function openContract(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "toggle",
        status = bool,
    })
    contractOpen = bool
end

local function GetClosestPlayer()
    local closestPlayers = MRFW.Functions.GetPlayersFromCoords()
    local closestDistance = -1
    local closestPlayer = -1
    local coords = GetEntityCoords(PlayerPedId())
    for i=1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = #(pos - coords)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = closestPlayers[i]
                closestDistance = distance
            end
        end
	end
	return closestPlayer, closestDistance
end

local function DoRamAnimation(bool)
    local ped = PlayerPedId()
    local dict = "missheistfbi3b_ig7"
    local anim = "lift_fibagent_loop"
    if bool then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(1)
        end
        TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 1, -1, false, false, false)
    else
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(1)
        end
        TaskPlayAnim(ped, dict, "exit", 8.0, 8.0, -1, 1, -1, false, false, false)
    end
end

local function setViewCam(coords, h, yaw)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords.x, coords.y, coords.z, yaw, 0.00, h, 80.00, false, 0)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, true)
    viewCam = true
end

local function InstructionButton(ControlButton)
    N_0xe83a3e3557a56640(ControlButton)
end

local function InstructionButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

local function CreateInstuctionScaleform(scaleform)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    InstructionButton(GetControlInstructionalButton(1, 194, true))
    InstructionButtonMessage("Exit Camera")
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()
    return scaleform
end

local function FrontDoorCam(coords)
    DoScreenFadeOut(150)
    Citizen.Wait(500)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords.x, coords.y, coords.z + 0.5, 0.0, 0.00, coords.h - 180, 80.00, false, 0)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, true)
    FrontCam = true
    FreezeEntityPosition(PlayerPedId(), true)
    Citizen.Wait(500)
    DoScreenFadeIn(150)
    SendNUIMessage({
        type = "frontcam",
        toggle = true,
        label = Config.Houses[closesthouse].adress
    })
    Citizen.CreateThread(function()
        while FrontCam do
            local instructions = CreateInstuctionScaleform("instructional_buttons")
            DrawScaleformMovieFullscreen(instructions, 255, 255, 255, 255, 0)
            SetTimecycleModifier("scanline_cam_cheap")
            SetTimecycleModifierStrength(1.0)
            if IsControlJustPressed(1, 194) then -- Backspace
                DoScreenFadeOut(150)
                SendNUIMessage({
                    type = "frontcam",
                    toggle = false,
                })
                Citizen.Wait(500)
                RenderScriptCams(false, true, 500, true, true)
                FreezeEntityPosition(PlayerPedId(), false)
                SetCamActive(cam, false)
                DestroyCam(cam, true)
                ClearTimecycleModifier("scanline_cam_cheap")
                cam = nil
                FrontCam = false
                Citizen.Wait(500)
                DoScreenFadeIn(150)
            end

            local getCameraRot = GetCamRot(cam, 2)

            -- ROTATE UP
            if IsControlPressed(0, 32) then -- W
                if getCameraRot.x <= 0.0 then
                    SetCamRot(cam, getCameraRot.x + 0.7, 0.0, getCameraRot.z, 2)
                end
            end

            -- ROTATE DOWN
            if IsControlPressed(0, 33) then -- S
                if getCameraRot.x >= -50.0 then
                    SetCamRot(cam, getCameraRot.x - 0.7, 0.0, getCameraRot.z, 2)
                end
            end

            -- ROTATE LEFT
            if IsControlPressed(0, 34) then -- A
                SetCamRot(cam, getCameraRot.x, 0.0, getCameraRot.z + 0.7, 2)
            end

            -- ROTATE RIGHT
            if IsControlPressed(0, 35) then -- D
                SetCamRot(cam, getCameraRot.x, 0.0, getCameraRot.z - 0.7, 2)
            end

            Citizen.Wait(1)
        end
    end)
end

local function disableViewCam()
    if viewCam then
        RenderScriptCams(false, true, 500, true, true)
        SetCamActive(cam, false)
        DestroyCam(cam, true)
        viewCam = false
    end
end

local function SetClosestHouse()
    local pos = GetEntityCoords(PlayerPedId(), true)
    local current = nil
    local dist = nil
    if not inside then
        for id, house in pairs(Config.Houses) do
            local distcheck = #(pos - vector3(Config.Houses[id].coords.enter.x, Config.Houses[id].coords.enter.y, Config.Houses[id].coords.enter.z))
            if current ~= nil then
                if distcheck < dist then
                    current = id
                    dist = distcheck
                end
            else
                dist = distcheck
                current = id
            end
        end
        closesthouse = current
        if closesthouse ~= nil and tonumber(dist) < 30 then 
            MRFW.Functions.TriggerCallback('mr-houses:server:ProximityKO', function(key, owned)
                hasKey = key
                isOwned = owned
            end, closesthouse)
        end
    end
    if dist ~= nil then
        if tonumber(dist) < 4 then
            TriggerEvent('mr-garages:client:setHouseGarage', closesthouse, hasKey)
        end
    end
end

local function setHouseLocations()
    if closesthouse ~= nil then
        MRFW.Functions.TriggerCallback('mr-houses:server:getHouseLocations', function(result)
            if result ~= nil then
                if result.stash ~= nil then
                    stashLocation = json.decode(result.stash)
                end

                if result.cupboard ~= nil then
                    cupboardLocation = json.decode(result.cupboard)
                end

                if result.outfit ~= nil then
                    outfitLocation = json.decode(result.outfit)
                end

                if result.logout ~= nil then
                    logoutLocation = json.decode(result.logout)
                end
            end
        end, closesthouse)
    end
end

function UnloadDecorations()
	if ObjectList ~= nil then 
		for k, v in pairs(ObjectList) do
			if DoesEntityExist(v.object) then
				DeleteObject(v.object)
			end
		end
	end
end

function FixSaveDecorations()
	local currupt = 0
	if Config.Houses[closesthouse].decorations == nil or next(Config.Houses[closesthouse].decorations) == nil then
		MRFW.Functions.TriggerCallback('mr-houses:server:getHouseDecorations', function(result)
			Config.Houses[closesthouse].decorations = result
			if Config.Houses[closesthouse].decorations ~= nil then
				ObjectList = {}
				for k, v in pairs(Config.Houses[closesthouse].decorations) do
					if Config.Houses[closesthouse].decorations[k] ~= nil then 
						if Config.Houses[closesthouse].decorations[k].object ~= nil then
							if DoesEntityExist(Config.Houses[closesthouse].decorations[k].object) then
								DeleteObject(Config.Houses[closesthouse].decorations[k].object)
							end
						end
						local modelHash = GetHashKey(Config.Houses[closesthouse].decorations[k].hashname)
						RequestModel(modelHash)
						while not HasModelLoaded(modelHash) do
							Citizen.Wait(10)
						end
						local decorateObject = CreateObject(modelHash, Config.Houses[closesthouse].decorations[k].x, Config.Houses[closesthouse].decorations[k].y, Config.Houses[closesthouse].decorations[k].z, false, false, false)
						SetEntityRotation(decorateObject, Config.Houses[closesthouse].decorations[k].rotx, Config.Houses[closesthouse].decorations[k].roty, Config.Houses[closesthouse].decorations[k].rotz)
						if Config.Houses[closesthouse].decorations[k].objectName ~= nil then
                            ObjectList[Config.Houses[closesthouse].decorations[k].objectId] = {objectName = Config.Houses[closesthouse].decorations[k].objectName, hashname = Config.Houses[closesthouse].decorations[k].hashname, x = Config.Houses[closesthouse].decorations[k].x, y = Config.Houses[closesthouse].decorations[k].y, z = Config.Houses[closesthouse].decorations[k].z, rotx = Config.Houses[closesthouse].decorations[k].rotx, roty = Config.Houses[closesthouse].decorations[k].roty, rotz = Config.Houses[closesthouse].decorations[k].rotz, object = decorateObject, objectId = Config.Houses[closesthouse].decorations[k].objectId}
                        else
                            currupt = currupt + 1
                            for a,__ in pairs(Config.Furniture) do
                                for b,_ in pairs(Config.Furniture[a].items) do
                                    if Config.Houses[closesthouse].decorations[k].hashname == Config.Furniture[a].items[b]["object"] then
                                        ObjectList[Config.Houses[closesthouse].decorations[k].objectId] = {objectName = Config.Furniture[a].items[b]["label"], hashname = Config.Houses[closesthouse].decorations[k].hashname, x = Config.Houses[closesthouse].decorations[k].x, y = Config.Houses[closesthouse].decorations[k].y, z = Config.Houses[closesthouse].decorations[k].z, rotx = Config.Houses[closesthouse].decorations[k].rotx, roty = Config.Houses[closesthouse].decorations[k].roty, rotz = Config.Houses[closesthouse].decorations[k].rotz, object = decorateObject, objectId = Config.Houses[closesthouse].decorations[k].objectId}
                                    end
                                end
                            end
                        end
                        FreezeEntityPosition(decorateObject, true)
					end
				end
			end
		end, closesthouse)
	elseif Config.Houses[closesthouse].decorations ~= nil then
		ObjectList = {}
		for k, v in pairs(Config.Houses[closesthouse].decorations) do
			if Config.Houses[closesthouse].decorations[k] ~= nil then 
				if Config.Houses[closesthouse].decorations[k].object ~= nil then
					if DoesEntityExist(Config.Houses[closesthouse].decorations[k].object) then
						DeleteObject(Config.Houses[closesthouse].decorations[k].object)
					end
				end
				local modelHash = GetHashKey(Config.Houses[closesthouse].decorations[k].hashname)
				RequestModel(modelHash)
				while not HasModelLoaded(modelHash) do
					Citizen.Wait(10)
				end
				local decorateObject = CreateObject(modelHash, Config.Houses[closesthouse].decorations[k].x, Config.Houses[closesthouse].decorations[k].y, Config.Houses[closesthouse].decorations[k].z, false, false, false)
				Config.Houses[closesthouse].decorations[k].object = decorateObject
				SetEntityRotation(decorateObject, Config.Houses[closesthouse].decorations[k].rotx, Config.Houses[closesthouse].decorations[k].roty, Config.Houses[closesthouse].decorations[k].rotz)
				if Config.Houses[closesthouse].decorations[k].objectName ~= nil then
                    ObjectList[Config.Houses[closesthouse].decorations[k].objectId] = {objectName = Config.Houses[closesthouse].decorations[k].objectName, hashname = Config.Houses[closesthouse].decorations[k].hashname, x = Config.Houses[closesthouse].decorations[k].x, y = Config.Houses[closesthouse].decorations[k].y, z = Config.Houses[closesthouse].decorations[k].z, rotx = Config.Houses[closesthouse].decorations[k].rotx, roty = Config.Houses[closesthouse].decorations[k].roty, rotz = Config.Houses[closesthouse].decorations[k].rotz, object = decorateObject, objectId = Config.Houses[closesthouse].decorations[k].objectId}
                else
                    currupt = currupt + 1
                    for a,__ in pairs(Config.Furniture) do
                        for b,_ in pairs(Config.Furniture[a].items) do
                            if Config.Houses[closesthouse].decorations[k].hashname == Config.Furniture[a].items[b]["object"] then
                                ObjectList[Config.Houses[closesthouse].decorations[k].objectId] = {objectName = Config.Furniture[a].items[b]["label"], hashname = Config.Houses[closesthouse].decorations[k].hashname, x = Config.Houses[closesthouse].decorations[k].x, y = Config.Houses[closesthouse].decorations[k].y, z = Config.Houses[closesthouse].decorations[k].z, rotx = Config.Houses[closesthouse].decorations[k].rotx, roty = Config.Houses[closesthouse].decorations[k].roty, rotz = Config.Houses[closesthouse].decorations[k].rotz, object = decorateObject, objectId = Config.Houses[closesthouse].decorations[k].objectId}
                            end
                        end
                    end
                end
				FreezeEntityPosition(decorateObject, true)
			end
		end
	end
    if currupt ~= 0 then
        TriggerServerEvent("mr-houses:server:savedecorations", closesthouse, ObjectList)
        MRFW.Functions.Notify('Fixed '..currupt..' Furnitures Successfully', 'primary', 3000)
    else
        MRFW.Functions.Notify('Why are you using this command everything seems fine', 'error', 3000)
    end
end

function LoadDecorations(house)
	if Config.Houses[house].decorations == nil or next(Config.Houses[house].decorations) == nil then
		MRFW.Functions.TriggerCallback('mr-houses:server:getHouseDecorations', function(result)
			Config.Houses[house].decorations = result
			if Config.Houses[house].decorations ~= nil then
				ObjectList = {}
				for k, v in pairs(Config.Houses[house].decorations) do
					if Config.Houses[house].decorations[k] ~= nil then 
						if Config.Houses[house].decorations[k].object ~= nil then
							if DoesEntityExist(Config.Houses[house].decorations[k].object) then
								DeleteObject(Config.Houses[house].decorations[k].object)
							end
						end
						local modelHash = GetHashKey(Config.Houses[house].decorations[k].hashname)
						RequestModel(modelHash)
						while not HasModelLoaded(modelHash) do
							Citizen.Wait(10)
						end
						local decorateObject = CreateObject(modelHash, Config.Houses[house].decorations[k].x, Config.Houses[house].decorations[k].y, Config.Houses[house].decorations[k].z, false, false, false)
						SetEntityRotation(decorateObject, Config.Houses[house].decorations[k].rotx, Config.Houses[house].decorations[k].roty, Config.Houses[house].decorations[k].rotz)
						ObjectList[Config.Houses[house].decorations[k].objectId] = {objectName = Config.Houses[house].decorations[k].objectName, hashname = Config.Houses[house].decorations[k].hashname, x = Config.Houses[house].decorations[k].x, y = Config.Houses[house].decorations[k].y, z = Config.Houses[house].decorations[k].z, rotx = Config.Houses[house].decorations[k].rotx, roty = Config.Houses[house].decorations[k].roty, rotz = Config.Houses[house].decorations[k].rotz, object = decorateObject, objectId = Config.Houses[house].decorations[k].objectId}
						FreezeEntityPosition(decorateObject, true)
					end
				end
			end
		end, house)
	elseif Config.Houses[house].decorations ~= nil then
		ObjectList = {}
		for k, v in pairs(Config.Houses[house].decorations) do
			if Config.Houses[house].decorations[k] ~= nil then 
				if Config.Houses[house].decorations[k].object ~= nil then
					if DoesEntityExist(Config.Houses[house].decorations[k].object) then
						DeleteObject(Config.Houses[house].decorations[k].object)
					end
				end
				local modelHash = GetHashKey(Config.Houses[house].decorations[k].hashname)
				RequestModel(modelHash)
				while not HasModelLoaded(modelHash) do
					Citizen.Wait(10)
				end
				local decorateObject = CreateObject(modelHash, Config.Houses[house].decorations[k].x, Config.Houses[house].decorations[k].y, Config.Houses[house].decorations[k].z, false, false, false)
				Config.Houses[house].decorations[k].object = decorateObject
				SetEntityRotation(decorateObject, Config.Houses[house].decorations[k].rotx, Config.Houses[house].decorations[k].roty, Config.Houses[house].decorations[k].rotz)
				ObjectList[Config.Houses[house].decorations[k].objectId] = {objectName = Config.Houses[house].decorations[k].objectName, hashname = Config.Houses[house].decorations[k].hashname, x = Config.Houses[house].decorations[k].x, y = Config.Houses[house].decorations[k].y, z = Config.Houses[house].decorations[k].z, rotx = Config.Houses[house].decorations[k].rotx, roty = Config.Houses[house].decorations[k].roty, rotz = Config.Houses[house].decorations[k].rotz, object = decorateObject, objectId = Config.Houses[house].decorations[k].objectId}
				FreezeEntityPosition(decorateObject, true)
			end
		end
	end
end

-- GUI Functions

function closeMenuFull()
    Menu.hidden = true
    currentGarage = nil
    inHoldersMenu = false
    ClearMenu()
end

function ClearMenu()
	Menu.GUI = {}
	Menu.buttonCount = 0
	Menu.selection = 0
end

function removeHouseKey(citizenData)
    TriggerServerEvent('mr-houses:server:removeHouseKey', closesthouse, citizenData)
    closeMenuFull()
end

function HouseKeysMenu()
    ped = PlayerPedId();
    MenuTitle = "Sleutels"
    ClearMenu()
    MRFW.Functions.TriggerCallback('mr-houses:server:getHouseKeyHolders', function(holders)
        ped = PlayerPedId();
        MenuTitle = "Sleutelhouders:"
        ClearMenu()
        if holders == nil or next(holders) == nil then
            MRFW.Functions.Notify("No key holders found..", "error", 3500)
            closeMenuFull()
        else
            for k, v in pairs(holders) do
                Menu.addButton(holders[k].firstname .. " " .. holders[k].lastname, "optionMenu", holders[k]) 
            end
        end
        Menu.addButton("Exit Menu", "closeMenuFull", nil) 
    end, closesthouse)
end

function optionMenu(citizenData)
    ped = PlayerPedId();
    MenuTitle = "What now?"
    ClearMenu()
    Menu.addButton("Remove key", "removeHouseKey", citizenData)
    Menu.addButton("Back", "HouseKeysMenu",nil)
end

-- Shell Configuration

local function getDataForHouseTier(house, coords)
    if Config.Houses[house].tier == 1 then
        data = exports['mr-interior']:CreateCaravanShell(coords)
    elseif Config.Houses[house].tier == 2 then
        data = exports['mr-interior']:CreateFuryShell01(coords)
    elseif Config.Houses[house].tier == 3 then
        data = exports['mr-interior']:CreateTier1House(coords)
    elseif Config.Houses[house].tier == 4 then
        data = exports['mr-interior']:CreateFuryShell05(coords)
    elseif Config.Houses[house].tier == 5 then
        data = exports['mr-interior']:CreateTrevorsShell(coords)
    elseif Config.Houses[house].tier == 6 then
        data = exports['mr-interior']:CreateApartmentShell(coords)
    elseif Config.Houses[house].tier == 7 then
        data = exports['mr-interior']:CreateFranklinAuntShell(coords)
    elseif Config.Houses[house].tier == 8 then
        data = exports['mr-interior']:CreateFranklinShell(coords)
    elseif Config.Houses[house].tier == 9 then
        data = exports['mr-interior']:CreateMichaelShell(coords)
    elseif Config.Houses[house].tier == 10 then
        data = exports['mr-interior']:CreateFuryShell02(coords)
    elseif Config.Houses[house].tier == 11 then
        data = exports['mr-interior']:CreateFuryShell03(coords)
    elseif Config.Houses[house].tier == 12 then
        data = exports['mr-interior']:CreateFuryShell04(coords)
    elseif Config.Houses[house].tier == 13 then
        data = exports['mr-interior']:CreateFuryShell06(coords)
    elseif Config.Houses[house].tier == 14 then
        data = exports['mr-interior']:CreateWarehouse(coords)
    elseif Config.Houses[house].tier == 15 then
        data = exports['mr-interior']:Createluxaryapt(coords)
    elseif Config.Houses[house].tier == 16 then
        data = exports['mr-interior']:Createluxarymanson(coords)
    elseif Config.Houses[house].tier == 17 then
        data = exports['mr-interior']:Createsmallapt(coords)
    else
        MRFW.Functions.Notify('Invalid House Tier', 'error')
    end
end

-- If you are using paid shells the comment function above and uncomment this or grab the ones you need

-- local function getDataForHouseTier(house, coords)
--     if Config.Houses[house].tier == 1 then
--         return exports['mr-interior']:CreateApartmentShell(coords)
--     elseif Config.Houses[house].tier == 2 then
--         return exports['mr-interior']:CreateTier1House(coords)
--     elseif Config.Houses[house].tier == 3 then
--         return exports['mr-interior']:CreateTrevorsShell(coords)
--     elseif Config.Houses[house].tier == 4 then
--         return exports['mr-interior']:CreateCaravanShell(coords)
--     elseif Config.Houses[house].tier == 5 then
--         return exports['mr-interior']:CreateLesterShell(coords)
--     elseif Config.Houses[house].tier == 6 then
--         return exports['mr-interior']:CreateRanchShell(coords)
--     elseif Config.Houses[house].tier == 7 then
--         return exports['mr-interior']:CreateFranklinAunt(coords)
--     elseif Config.Houses[house].tier == 8 then
--         return exports['mr-interior']:CreateMedium2(coords)
--     elseif Config.Houses[house].tier == 9 then
--         return exports['mr-interior']:CreateMedium3(coords)
--     elseif Config.Houses[house].tier == 10 then
--         return exports['mr-interior']:CreateBanham(coords)
--     elseif Config.Houses[house].tier == 11 then
--         return exports['mr-interior']:CreateWestons(coords)
--     elseif Config.Houses[house].tier == 12 then
--         return exports['mr-interior']:CreateWestons2(coords)
--     elseif Config.Houses[house].tier == 13 then
--         return exports['mr-interior']:CreateClassicHouse(coords)
--     elseif Config.Houses[house].tier == 14 then
--         return exports['mr-interior']:CreateClassicHouse2(coords)
--     elseif Config.Houses[house].tier == 15 then
--         return exports['mr-interior']:CreateClassicHouse3(coords)
--     elseif Config.Houses[house].tier == 16 then
--         return exports['mr-interior']:CreateHighend1(coords)
--     elseif Config.Houses[house].tier == 17 then
--         return exports['mr-interior']:CreateHighend2(coords)
--     elseif Config.Houses[house].tier == 18 then
--         return exports['mr-interior']:CreateHighend3(coords)
--     elseif Config.Houses[house].tier == 19 then
--         return exports['mr-interior']:CreateHighend(coords)
--     elseif Config.Houses[house].tier == 20 then
--         return exports['mr-interior']:CreateHighendV2(coords)
--     elseif Config.Houses[house].tier == 21 then
--         return exports['mr-interior']:CreateMichael(coords)
--     elseif Config.Houses[house].tier == 22 then
--         return exports['mr-interior']:CreateStashHouse(coords)
--     elseif Config.Houses[house].tier == 23 then
--         return exports['mr-interior']:CreateStashHouse2(coords)
--     elseif Config.Houses[house].tier == 24 then
--         return exports['mr-interior']:CreateContainer(coords)
--     elseif Config.Houses[house].tier == 25 then
--         return exports['mr-interior']:CreateGarageLow(coords)
--     elseif Config.Houses[house].tier == 26 then
--         return exports['mr-interior']:CreateGarageMed(coords)
--     elseif Config.Houses[house].tier == 27 then
--         return exports['mr-interior']:CreateGarageHigh(coords)
--     elseif Config.Houses[house].tier == 28 then
--         return exports['mr-interior']:CreateOffice1(coords)
--     elseif Config.Houses[house].tier == 29 then
--         return exports['mr-interior']:CreateOffice2(coords)
--     elseif Config.Houses[house].tier == 30 then
--         return exports['mr-interior']:CreateOfficeBig(coords)
--     elseif Config.Houses[house].tier == 31 then
--         return exports['mr-interior']:CreateBarber(coords)
--     elseif Config.Houses[house].tier == 32 then
--         return exports['mr-interior']:CreateGunstore(coords)
--     elseif Config.Houses[house].tier == 33 then
--         return exports['mr-interior']:CreateStore1(coords)
--     elseif Config.Houses[house].tier == 34 then
--         return exports['mr-interior']:CreateStore2(coords)
--     elseif Config.Houses[house].tier == 35 then
--         return exports['mr-interior']:CreateStore3(coords)
--     elseif Config.Houses[house].tier == 36 then
--         return exports['mr-interior']:CreateWarehouse1(coords)
--     elseif Config.Houses[house].tier == 37 then
--         return exports['mr-interior']:CreateWarehouse2(coords)
--     elseif Config.Houses[house].tier == 38 then
--         return exports['mr-interior']:CreateWarehouse3(coords)
--     elseif Config.Houses[house].tier == 39 then
--         return exports['mr-interior']:CreateK4Coke(coords)
--     elseif Config.Houses[house].tier == 40 then
--         return exports['mr-interior']:CreateK4Meth(coords)
--     elseif Config.Houses[house].tier == 41 then
--         return exports['mr-interior']:CreateK4Weed(coords)
--     elseif Config.Houses[house].tier == 42 then
--         return exports['mr-interior']:CreateContainer2(coords)
--     elseif Config.Houses[house].tier == 43 then
--         return exports['mr-interior']:CreateFurniStash1(coords)
--     elseif Config.Houses[house].tier == 44 then
--         return exports['mr-interior']:CreateFurniStash3(coords)
--     elseif Config.Houses[house].tier == 45 then
--         return exports['mr-interior']:CreateFurniLow(coords)
--     elseif Config.Houses[house].tier == 46 then
--         return exports['mr-interior']:CreateFurniMid(coords)
--     elseif Config.Houses[house].tier == 47 then
--         return exports['mr-interior']:CreateFurniMotel(coords)
--     elseif Config.Houses[house].tier == 48 then
--         return exports['mr-interior']:CreateFurniMotelClassic(coords)
--     elseif Config.Houses[house].tier == 49 then
--         return exports['mr-interior']:CreateFurniMotelStandard(coords)
--     elseif Config.Houses[house].tier == 50 then
--         return exports['mr-interior']:CreateFurniMotelHigh(coords)
--     elseif Config.Houses[house].tier == 51 then
--         return exports['mr-interior']:CreateFurniMotelModern(coords)
--     elseif Config.Houses[house].tier == 52 then
--         return exports['mr-interior']:CreateFurniMotelModern2(coords)
--     elseif Config.Houses[house].tier == 53 then
--         return exports['mr-interior']:CreateFurniMotelModern3(coords)
--     elseif Config.Houses[house].tier == 54 then
--         return exports['mr-interior']:CreateCoke(coords)
--     elseif Config.Houses[house].tier == 55 then
--         return exports['mr-interior']:CreateCoke2(coords)
--     elseif Config.Houses[house].tier == 56 then
--         return exports['mr-interior']:CreateMeth(coords)
--     elseif Config.Houses[house].tier == 57 then
--         return exports['mr-interior']:CreateWeed(coords)
--     elseif Config.Houses[house].tier == 58 then
--         return exports['mr-interior']:CreateWeed2(coords)
--     else
--         MRFW.Functions.Notify('Invalid House Tier', 'error')
--     end
-- end

local function enterOwnedHouse(house)
    CurrentHouse = house
    closesthouse = house
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.25)
    openHouseAnim()
    inside = true
    Citizen.Wait(250)
    local coords = { x = Config.Houses[house].coords.shell.x, y = Config.Houses[house].coords.shell.y, z= Config.Houses[house].coords.shell.z}
    LoadDecorations(house)
    if Config.Houses[house].tier == 1 then
        data = exports['mr-interior']:CreateCaravanShell(coords)
    elseif Config.Houses[house].tier == 2 then
        data = exports['mr-interior']:CreateFuryShell01(coords)
    elseif Config.Houses[house].tier == 3 then
        data = exports['mr-interior']:CreateTier1House(coords)
    elseif Config.Houses[house].tier == 4 then
        data = exports['mr-interior']:CreateFuryShell05(coords)
    elseif Config.Houses[house].tier == 5 then
        data = exports['mr-interior']:CreateTrevorsShell(coords)
    elseif Config.Houses[house].tier == 6 then
        data = exports['mr-interior']:CreateApartmentShell(coords)
    elseif Config.Houses[house].tier == 7 then
        data = exports['mr-interior']:CreateFranklinAuntShell(coords)
    elseif Config.Houses[house].tier == 8 then
        data = exports['mr-interior']:CreateFranklinShell(coords)
    elseif Config.Houses[house].tier == 9 then
        data = exports['mr-interior']:CreateMichaelShell(coords)
    elseif Config.Houses[house].tier == 10 then
        data = exports['mr-interior']:CreateFuryShell02(coords)
    elseif Config.Houses[house].tier == 11 then
        data = exports['mr-interior']:CreateFuryShell03(coords)
    elseif Config.Houses[house].tier == 12 then
        data = exports['mr-interior']:CreateFuryShell04(coords)
    elseif Config.Houses[house].tier == 13 then
        data = exports['mr-interior']:CreateFuryShell06(coords)
    elseif Config.Houses[house].tier == 14 then
        data = exports['mr-interior']:CreateWarehouse(coords)
    elseif Config.Houses[house].tier == 15 then
        data = exports['mr-interior']:Createluxaryapt(coords)
    elseif Config.Houses[house].tier == 16 then
        data = exports['mr-interior']:Createluxarymanson(coords)
    elseif Config.Houses[house].tier == 17 then
        data = exports['mr-interior']:Createsmallapt(coords)
    end
    Citizen.Wait(100)
    houseObj = data[1]
    POIOffsets = data[2]
    entering = true
    Citizen.Wait(500)
    SetRainFxIntensity(0.0)
    TriggerServerEvent('mr-houses:server:SetInsideMeta', house, true)
    TriggerEvent('mr-weathersync:client:DisableSync' , 23, 0, 0)
    TriggerEvent('mr-weed:client:getHousePlants', house)
    Citizen.Wait(100)
    SetWeatherTypePersist('EXTRASUNNY')
    SetWeatherTypeNow('EXTRASUNNY')
    SetWeatherTypeNowPersist('EXTRASUNNY')
    NetworkOverrideClockTime(23, 0, 0)
    entering = false
    setHouseLocations()
    if showText then
        exports['mr-text']:HideText(1)
        showText = false
    end
end

local function leaveOwnedHouse(house)
    if not FrontCam then
        inside = false
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.25)
        openHouseAnim()
        Citizen.Wait(250)
        DoScreenFadeOut(250)
        Citizen.Wait(500)
        exports['mr-interior']:DespawnInterior(houseObj, function()
            UnloadDecorations()
            TriggerEvent('mr-weathersync:client:EnableSync')
            Citizen.Wait(250)
            DoScreenFadeIn(250)
            SetEntityCoords(PlayerPedId(), Config.Houses[CurrentHouse].coords.enter.x, Config.Houses[CurrentHouse].coords.enter.y, Config.Houses[CurrentHouse].coords.enter.z + 0.2)
            SetEntityHeading(PlayerPedId(), Config.Houses[CurrentHouse].coords.enter.h)
            TriggerEvent('mr-weed:client:leaveHouse')
            TriggerServerEvent('mr-houses:server:SetInsideMeta', house, false)
            CurrentHouse = nil
        end)
        if showText3 then
            exports['mr-text']:HideText(3)
            exports['mr-text']:HideText(10)
            showText3 = false
        end
    end
end

local function enterNonOwnedHouse(house)
    CurrentHouse = house
    closesthouse = house
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.25)
    openHouseAnim()
    inside = true
    Citizen.Wait(250)
    local coords = { x = Config.Houses[closesthouse].coords.shell.x, y = Config.Houses[closesthouse].coords.shell.y, z= Config.Houses[closesthouse].coords.shell.z}
    LoadDecorations(house)
    if Config.Houses[house].tier == 1 then
        data = exports['mr-interior']:CreateCaravanShell(coords)
    elseif Config.Houses[house].tier == 2 then
        data = exports['mr-interior']:CreateFuryShell01(coords)
    elseif Config.Houses[house].tier == 3 then
        data = exports['mr-interior']:CreateTier1House(coords)
    elseif Config.Houses[house].tier == 4 then
        data = exports['mr-interior']:CreateFuryShell05(coords)
    elseif Config.Houses[house].tier == 5 then
        data = exports['mr-interior']:CreateTrevorsShell(coords)
    elseif Config.Houses[house].tier == 6 then
        data = exports['mr-interior']:CreateApartmentShell(coords)
    elseif Config.Houses[house].tier == 7 then
        data = exports['mr-interior']:CreateFranklinAuntShell(coords)
    elseif Config.Houses[house].tier == 8 then
        data = exports['mr-interior']:CreateFranklinShell(coords)
    elseif Config.Houses[house].tier == 9 then
        data = exports['mr-interior']:CreateMichaelShell(coords)
    elseif Config.Houses[house].tier == 10 then
        data = exports['mr-interior']:CreateFuryShell02(coords)
    elseif Config.Houses[house].tier == 11 then
        data = exports['mr-interior']:CreateFuryShell03(coords)
    elseif Config.Houses[house].tier == 12 then
        data = exports['mr-interior']:CreateFuryShell04(coords)
    elseif Config.Houses[house].tier == 13 then
        data = exports['mr-interior']:CreateFuryShell06(coords)
    elseif Config.Houses[house].tier == 14 then
        data = exports['mr-interior']:CreateWarehouse(coords)
    elseif Config.Houses[house].tier == 15 then
        data = exports['mr-interior']:Createluxaryapt(coords)
    elseif Config.Houses[house].tier == 16 then
        data = exports['mr-interior']:Createluxarymanson(coords)
    elseif Config.Houses[house].tier == 17 then
        data = exports['mr-interior']:Createsmallapt(coords)
    end
    houseObj = data[1]
    POIOffsets = data[2]
    entering = true
    Citizen.Wait(500)
    SetRainFxIntensity(0.0)
    TriggerServerEvent('mr-houses:server:SetInsideMeta', house, true)
    TriggerEvent('mr-weathersync:client:DisableSync', 23, 0, 0)
    TriggerEvent('mr-weed:client:getHousePlants', house)
    Citizen.Wait(100)
    SetWeatherTypePersist('EXTRASUNNY')
    SetWeatherTypeNow('EXTRASUNNY')
    SetWeatherTypeNowPersist('EXTRASUNNY')
    NetworkOverrideClockTime(23, 0, 0)
    entering = false
    inOwned = true
    setHouseLocations()
    if showText then
        exports['mr-text']:HideText(1)
        showText = false
    end
end

local function leaveNonOwnedHouse(house)
    if not FrontCam then
        inside = false
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.25)
        openHouseAnim()
        Citizen.Wait(250)
        DoScreenFadeOut(250)
        Citizen.Wait(500)
        exports['mr-interior']:DespawnInterior(houseObj, function()
            UnloadDecorations()
            TriggerEvent('mr-weathersync:client:EnableSync')
            Citizen.Wait(250)
            DoScreenFadeIn(250)
            SetEntityCoords(PlayerPedId(), Config.Houses[CurrentHouse].coords.enter.x, Config.Houses[CurrentHouse].coords.enter.y, Config.Houses[CurrentHouse].coords.enter.z + 0.2)
            SetEntityHeading(PlayerPedId(), Config.Houses[CurrentHouse].coords.enter.h)
            inOwned = false
            TriggerEvent('mr-weed:client:leaveHouse')
            TriggerServerEvent('mr-houses:server:SetInsideMeta', house, false)
            CurrentHouse = nil
        end)
        if showText3 then
            exports['mr-text']:HideText(3)
            showText3 = false
        end
    end
end

local function isNearHouses()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)

    if closesthouse ~= nil then
        local dist = #(pos - vector3(Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z))
        if dist <= 1.5 then
            if hasKey then
                return true
            end
        end
    end
end

exports('isNearHouses', isNearHouses)

-- Events

RegisterNetEvent('mr-houses:server:sethousedecorations', function(house, decorations)
	Config.Houses[house].decorations = decorations
	if inside and closesthouse == house then 
		LoadDecorations(house)
	end
end)

RegisterNetEvent('mr-houses:client:sellHouse', function()
    if closesthouse and hasKey then
        TriggerServerEvent('mr-houses:server:viewHouse', closesthouse)
    end
end)

RegisterNetEvent('mr-houses:client:EnterHouse', function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)

    if closesthouse ~= nil then
        local dist = #(pos - vector3(Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z))
        if dist < 1.5 then
            if hasKey then
                enterOwnedHouse(closesthouse)
            else
                if not Config.Houses[closesthouse].locked then
                    enterNonOwnedHouse(closesthouse)
                end
            end
        end
    end
end)

RegisterNetEvent('mr-houses:client:RequestRing', function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)

    if closesthouse ~= nil then
        TriggerServerEvent('mr-houses:server:RingDoor', closesthouse)
    end
end)

AddEventHandler('MRFW:Client:OnPlayerLoaded', function()
    MRFW.Functions.TriggerCallback('mr-houses:server:getfurnituretable', function(data)
        Config.Furniture = data
    end)
    TriggerServerEvent('mr-houses:client:setHouses')
    SetClosestHouse()
    TriggerEvent('mr-houses:client:setupHouseBlips')
    Citizen.Wait(100)
    TriggerEvent('mr-garages:client:setHouseGarage', closesthouse, hasKey)
    TriggerServerEvent("mr-houses:server:setHouses")
    TriggerServerEvent("mr-houses:AutoStatuscheck")
end)

RegisterNetEvent('mr-houses:server:postfurnituretable', function(data)
    Config.Furniture = data
end)

RegisterNetEvent('MRFW:Client:OnPlayerUnload', function()
    inside = false
    closesthouse = nil
    hasKey = false
    isOwned = false
    for k, v in pairs(OwnedHouseBlips) do
        RemoveBlip(v)
    end
end)

RegisterNetEvent('mr-houses:client:setHouseConfig', function(houseConfig)
    Config.Houses = houseConfig
end)

RegisterNetEvent('mr-houses:client:lockHouse', function(bool, house)
    Config.Houses[house].locked = bool
end)

RegisterNetEvent('mr-houses:client:createHouses', function(price, tier)
    local pos = GetEntityCoords(PlayerPedId())
    local heading = GetEntityHeading(PlayerPedId())
    local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, pos.x, pos.y, pos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
    local street = GetStreetNameFromHashKey(s1)
    street = street:gsub("%-", " ")
    TriggerServerEvent('mr-houses:server:addNewHouse', street, heading, price, tier, pos)
end)

RegisterNetEvent('mr-houses:client:addGarage', function()
    if closesthouse ~= nil then 
        local pos = GetEntityCoords(PlayerPedId())
        local heading = GetEntityHeading(PlayerPedId())
        local coords = {
            x = pos.x,
            y = pos.y,
            z = pos.z,
            h = heading,
        }
        TriggerServerEvent('mr-houses:server:addGarage', closesthouse, coords)
    else
        MRFW.Functions.Notify("No house around..", "error")
    end
end)

RegisterNetEvent('mr-houses:client:toggleDoorlock', function()
    local pos = GetEntityCoords(PlayerPedId())
    local dist = #(pos - vector3(Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z))
    if dist < 1.5 then
        if hasKey then
            if Config.Houses[closesthouse].locked then
                TriggerServerEvent('mr-houses:server:lockHouse', false, closesthouse)
                MRFW.Functions.Notify("House is unlocked!", "success", 2500)
            else
                TriggerServerEvent('mr-houses:server:lockHouse', true, closesthouse)
                MRFW.Functions.Notify("House is locked!", "error", 2500)
            end
        else
            MRFW.Functions.Notify("You don't have the keys of the house...", "error", 3500)
        end
    else
        MRFW.Functions.Notify("There is no door nearby", "error", 3500)
    end
end)

RegisterNetEvent('mr-houses:client:RingDoor', function(player, house)
    if closesthouse == house and inside then
        CurrentDoorBell = player
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "doorbell", 0.1)
        MRFW.Functions.Notify("Someone is ringing the door!")
    end
end)

RegisterNetEvent('mr-houses:client:giveHouseKey', function(data)
    local player, distance = GetClosestPlayer()
    if player ~= -1 and distance < 2.5 and closesthouse ~= nil then
        local playerId = GetPlayerServerId(player)
        local pedpos = GetEntityCoords(PlayerPedId())
        local housedist = #(pedpos - vector3(Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z))
        if housedist < 10 then
            TriggerServerEvent('mr-houses:server:giveHouseKey', playerId, closesthouse)
        else
            MRFW.Functions.Notify("You're not close enough to the door..", "error")
        end
    elseif closesthouse == nil then
        MRFW.Functions.Notify("There is no house near you", "error")
    else
        MRFW.Functions.Notify("No one around!", "error")
    end
end)

RegisterNetEvent('mr-houses:client:givetheHouseKeyonrent', function(playerid)
    local player, distance = GetClosestPlayer()
    if player ~= -1 and distance < 2.5 and closesthouse ~= nil then
        local housedist = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z)
        local playerId = GetPlayerServerId(player)
        if housedist < 10 then
            TriggerServerEvent('mr-houses:server:giveHouseKeyonrent', playerId, closesthouse)
        else
            MRFW.Functions.Notify("You'r not close enough to the door..", "error")
        end
    elseif closesthouse == nil then
        MRFW.Functions.Notify("There is no house near you", "error")
    else
        MRFW.Functions.Notify("No one around!", "error")
    end
end)

RegisterNetEvent('mr-houses:client:removeHouseKeyonrent', function(data,playerid)
    if closesthouse ~= nil then 
        local housedist = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z)
        if housedist < 5 then
            MRFW.Functions.TriggerCallback('mr-houses:server:getHouseOwner', function(result)
                if MRFW.Functions.GetPlayerData().citizenid == result then
                    inHoldersMenu = true
                    HouseKeysMenu()
                    Menu.hidden = not Menu.hidden
                else
                    MRFW.Functions.Notify("You're not a house owner..", "error")
                end
            end, closesthouse)
        else
            MRFW.Functions.Notify("You'r not close enough to the door..", "error")
        end
    else
        MRFW.Functions.Notify("You'r not close enough to the door..", "error")
    end
end)

RegisterNetEvent('mr-houses:client:removeHouseKey', function(data)
    if closesthouse ~= nil then
        local pedpos = GetEntityCoords(PlayerPedId())
        local housedist = #(pedpos - vector3(Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z))
        if housedist < 5 then
            MRFW.Functions.TriggerCallback('mr-houses:server:getHouseOwner', function(result)
                if MRFW.Functions.GetPlayerData().citizenid == result then
                    inHoldersMenu = true
                    HouseKeysMenu()
                    Menu.hidden = not Menu.hidden
                else
                    MRFW.Functions.Notify("You're not a house owner..", "error")
                end
            end, closesthouse)
        else
            MRFW.Functions.Notify("You're not close enough to the door..", "error")
        end
    else
        MRFW.Functions.Notify("You're not close enough to the door..", "error")
    end
end)

RegisterNetEvent('mr-houses:client:refreshHouse', function(data)
    Citizen.Wait(100)
    SetClosestHouse()
end)

RegisterNetEvent('mr-houses:client:SpawnInApartment', function(house)
    local pos = GetEntityCoords(PlayerPedId())
    if rangDoorbell ~= nil then
        if #(pos - vector3(Config.Houses[house].coords.enter.x, Config.Houses[house].coords.enter.y, Config.Houses[house].coords.enter.z)) > 5 then
            return
        end
    end
    closesthouse = house
    enterNonOwnedHouse(house)
end)

RegisterNetEvent('mr-houses:client:enterOwnedHouse', function(house)
    MRFW.Functions.GetPlayerData(function(PlayerData)
		if PlayerData.metadata["injail"] == 0 then
			enterOwnedHouse(house)
		end
	end)
end)

RegisterNetEvent('mr-houses:client:LastLocationHouse', function(houseId)
    MRFW.Functions.GetPlayerData(function(PlayerData)
		if PlayerData.metadata["injail"] == 0 then
			enterOwnedHouse(houseId)
		end
	end)
end)

RegisterNetEvent('mr-houses:client:setupHouseBlips', function()
    Citizen.CreateThread(function()
        Citizen.Wait(2000)
        if LocalPlayer.state['isLoggedIn'] then
            MRFW.Functions.TriggerCallback('mr-houses:server:getOwnedHouses', function(ownedHouses)
                if ownedHouses then
                    for k, v in pairs(ownedHouses) do
                        local house = Config.Houses[ownedHouses[k]]
                        HouseBlip = AddBlipForCoord(house.coords.enter.x, house.coords.enter.y, house.coords.enter.z)
                        SetBlipSprite (HouseBlip, 40)
                        SetBlipDisplay(HouseBlip, 4)
                        SetBlipScale  (HouseBlip, 0.65)
                        SetBlipAsShortRange(HouseBlip, true)
                        SetBlipColour(HouseBlip, 3)
                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentSubstringPlayerName(house.adress)
                        EndTextCommandSetBlipName(HouseBlip)
                        OwnedHouseBlips[#OwnedHouseBlips+1] = HouseBlip
                    end
                end
            end)
        end
    end)
end)

RegisterNetEvent('mr-houses:client:SetClosestHouse', function()
    SetClosestHouse()
end)

RegisterNetEvent('mr-houses:client:viewHouse', function(realestate, contact,estimateamount, firstname, lastname)
    setViewCam(Config.Houses[closesthouse].coords.cam, Config.Houses[closesthouse].coords.cam.h, Config.Houses[closesthouse].coords.yaw)
    Citizen.Wait(500)
    openContract(true)
    SendNUIMessage({
        type = "setupContract",
        firstname = firstname,
        lastname = lastname,
        street = Config.Houses[closesthouse].adress,
        -- houseprice = houseprice,
        -- brokerfee = brokerfee,
        -- bankfee = bankfee,
        -- taxes = taxes,
        -- totalprice = (houseprice + brokerfee + bankfee + taxes)
        realestate = realestate,
        contact = contact,
        estimateamount = estimateamount
    })
end)

RegisterNetEvent('mr-houses:client:setLocation', function(data)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local coords = {x = pos.x, y = pos.y, z = pos.z}
    if inside then
        if hasKey then
            if data.id == 'setstash' then
                TriggerServerEvent('mr-houses:server:setLocation', coords, closesthouse, 1)
            elseif data.id == 'setoutift' then
                TriggerServerEvent('mr-houses:server:setLocation', coords, closesthouse, 2)
            elseif data.id == 'setlogout' then
                TriggerServerEvent('mr-houses:server:setLocation', coords, closesthouse, 3)
            elseif data.id == 'setcupboard' then
                TriggerServerEvent('mr-houses:server:setLocation', coords, closesthouse, 4)
            end
        else
            MRFW.Functions.Notify('You do not own this house', 'error')
        end
    else    
        MRFW.Functions.Notify('You are not in a house', 'error')
    end
end)

RegisterNetEvent('mr-houses:client:refreshLocations', function(house, location, type)
    if closesthouse == house then
        if inside then
            if type == 1 then
                stashLocation = json.decode(location)
            elseif type == 2 then
                outfitLocation = json.decode(location)
            elseif type == 3 then
                logoutLocation = json.decode(location)
            elseif type == 4 then
                cupboardLocation = json.decode(location)
            end
        end
    end
end)

RegisterNetEvent('mr-houses:client:HomeInvasion', function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local Skillbar = exports['mr-skillbar']:GetSkillbarObject()
    if closesthouse ~= nil then
        MRFW.Functions.TriggerCallback('police:server:IsPoliceForcePresent', function(IsPresent)
            if IsPresent then
                local dist = #(pos - vector3(Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z))
                if Config.Houses[closesthouse].IsRaming == nil then
                    Config.Houses[closesthouse].IsRaming = false
                end
                if dist < 1 then
                    if Config.Houses[closesthouse].locked then
                        if not Config.Houses[closesthouse].IsRaming then
                            DoRamAnimation(true)
                            Skillbar.Start({
                                duration = math.random(5000, 10000),
                                pos = math.random(10, 30),
                                width = math.random(10, 20),
                            }, function()
                                if RamsDone + 1 >= Config.RamsNeeded then
                                    TriggerServerEvent('mr-houses:server:lockHouse', false, closesthouse)
                                    MRFW.Functions.Notify('It worked the door is now out.', 'success')
                                    TriggerServerEvent('mr-houses:server:SetHouseRammed', true, closesthouse)
                                    DoRamAnimation(false)
                                else
                                    DoRamAnimation(true)
                                    Skillbar.Repeat({
                                        duration = math.random(500, 1000),
                                        pos = math.random(10, 30),
                                        width = math.random(5, 12),
                                    })
                                    RamsDone = RamsDone + 1
                                end
                            end, function()
                                RamsDone = 0
                                TriggerServerEvent('mr-houses:server:SetRamState', false, closesthouse)
                                MRFW.Functions.Notify('It failed try again.', 'error')
                                DoRamAnimation(false)
                            end)
                            TriggerServerEvent('mr-houses:server:SetRamState', true, closesthouse)
                        else
                            MRFW.Functions.Notify('Someone is already working on the door..', 'error')
                        end
                    else
                        MRFW.Functions.Notify('19/5000 This house is already open..', 'error')
                    end
                else
                    MRFW.Functions.Notify('You\'re not near a house..', 'error')
                end
            else
                MRFW.Functions.Notify('There is no police force present..', 'error')
            end
        end)
    else
        MRFW.Functions.Notify('You\'re not near a house..', 'error')
    end
end)

RegisterNetEvent('mr-houses:client:SetRamState', function(bool, house)
    Config.Houses[house].IsRaming = bool
end)

RegisterNetEvent('mr-houses:client:SetHouseRammed', function(bool, house)
    Config.Houses[house].IsRammed = bool
end)

RegisterNetEvent('mr-houses:client:ResetHouse', function()
    if closesthouse ~= nil then
        if Config.Houses[closesthouse].IsRammed == nil then
            Config.Houses[closesthouse].IsRammed = false
            TriggerServerEvent('mr-houses:server:SetHouseRammed', false, closesthouse)
            TriggerServerEvent('mr-houses:server:SetRamState', false, closesthouse)
        end
        if Config.Houses[closesthouse].IsRammed then
            openHouseAnim()
            TriggerServerEvent('mr-houses:server:SetHouseRammed', false, closesthouse)
            TriggerServerEvent('mr-houses:server:SetRamState', false, closesthouse)
            TriggerServerEvent('mr-houses:server:lockHouse', true, closesthouse)
            RamsDone = 0
            MRFW.Functions.Notify('You locked the house again..', 'success')
        else
            MRFW.Functions.Notify('This door is not broken open ..', 'error')
        end
    end
end)

-- NUI Callbacks

RegisterNUICallback('HasEnoughMoney', function(data, cb)
    MRFW.Functions.TriggerCallback('mr-houses:server:HasEnoughMoney', function(hasEnough)
    end, data.objectData)
end)

RegisterNUICallback('buy', function()
    openContract(false)
    disableViewCam()
    TriggerServerEvent('mr-houses:server:buyHouse', closesthouse)
end)

RegisterNUICallback('rent', function()
    openContract(false)
    disableViewCam()
    TriggerServerEvent('mr-houses:server:rentHouse', closesthouse)
end)

RegisterNUICallback('exit', function()
    openContract(false)
    disableViewCam()
end)

RegisterNetEvent('mr-houses:client:ownthishouse')
AddEventHandler('mr-houses:client:ownthishouse', function(street, id)

    TriggerServerEvent('mr-houses:server:buyHouse', closesthouse, id)
    MRFW.Functions.Notify('You are owner of the house : '..street.. ' ', 'success', 5000)

end)

RegisterNetEvent('mr-houses:client:transferthishouse')
AddEventHandler('mr-houses:client:transferthishouse', function(street, housenumber , playerid , id)

    TriggerServerEvent('mr-houses:server:transferthishouse', closesthouse, housenumber , playerid, id)
    MRFW.Functions.Notify('You have transfered the house : '..street.. ' ', 'success', 5000)

end)



-- Threads

Citizen.CreateThread(function()
    Wait(1000)
    TriggerServerEvent('mr-houses:client:setHouses')
    SetClosestHouse()
    TriggerEvent('mr-houses:client:setupHouseBlips')
    Citizen.Wait(100)
    -- TriggerEvent('mr-garages:client:setHouseGarage', closesthouse, hasKey)
    TriggerServerEvent("mr-houses:server:setHouses")
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)
        if LocalPlayer.state['isLoggedIn'] then
            if not inside then
                SetClosestHouse()
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        sleep = 1000
        if inHoldersMenu then
            sleep = 1
            Menu.renderGUI()
        end
        Citizen.Wait(sleep)
    end
end)


Citizen.CreateThread(function()
    while true do
        local inRange = false
        sleep = 1500
        if closesthouse ~= nil then
            local pos = GetEntityCoords(PlayerPedId())
            sleep = 5
            local dist2 = vector3(Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z)
            if #(pos.xy - dist2.xy) < 30 then
                inRange = true
                if hasKey then
                    -- ENTER HOUSE
                    if not inside then
                        if closesthouse ~= nil then
                            if #(pos - dist2) < 1.5 then
                                if not showText then
                                    exports['mr-text']:DrawText(
                                        '[E] To get in ('..closesthouse..")",
                                        0, 94, 255,0.7,
                                        1,
                                        50
                                    )
                                    showText = true
                                end
                                -- DrawText3Ds(Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z, '~b~E~w~ - To get in (~r~'..closesthouse.."~w~)")
                                if IsControlJustPressed(0, 38) then
                                    TriggerEvent('mr-houses:client:EnterHouse', closesthouse)
                                end
                            else
                                if showText then
                                    exports['mr-text']:HideText(1)
                                    showText = false
                                end
                            end
                        end
                    end
                    if CurrentDoorBell ~= 0 then
                        if #(pos - vector3(Config.Houses[closesthouse].coords.shell.x + POIOffsets.exit.x, Config.Houses[closesthouse].coords.shell.y + POIOffsets.exit.y, Config.Houses[closesthouse].coords.shell.z + POIOffsets.exit.z)) < 1.5 then
                            if not showText2 then
                                exports['mr-text']:DrawText(
                                    '[G] Invite In',
                                    0, 94, 255,0.7,
                                    2,
                                    60
                                )
                                showText2 = true
                            end
                            -- DrawText3Ds(Config.Houses[closesthouse].coords.enter.x + POIOffsets.exit.x, Config.Houses[closesthouse].coords.enter.y + POIOffsets.exit.y, Config.Houses[closesthouse].coords.enter.z - Config.MinZOffset + POIOffsets.exit.z + 0.35, '~g~G~w~ - Invite In')
                            if IsControlJustPressed(0, 47) then -- G
                                TriggerServerEvent("mr-houses:server:OpenDoor", CurrentDoorBell, closesthouse)
                                CurrentDoorBell = 0
                            end
                        else
                            if showText2 then
                                exports['mr-text']:HideText(2)
                                showText2 = false
                            end
                        end
                    end
                    -- EXIT HOUSE
                    if inside then
                        if not entering then
                            if POIOffsets ~= nil then
                                if POIOffsets.exit ~= nil then
                                    if #(pos - vector3(Config.Houses[CurrentHouse].coords.shell.x + POIOffsets.exit.x, Config.Houses[CurrentHouse].coords.shell.y + POIOffsets.exit.y, Config.Houses[CurrentHouse].coords.shell.z + POIOffsets.exit.z)) < 1.5 then
                                        if not showText3 then
                                            exports['mr-text']:DrawText(
                                                '[E] Leave',
                                                0, 94, 255,0.7,
                                                3,
                                                50
                                            )
                                            exports['mr-text']:DrawText(
                                                '[H] Camera',
                                                0, 94, 255,0.7,
                                                10,
                                                40
                                            )
                                            showText3 = true
                                        end
                                        -- DrawText3Ds(Config.Houses[CurrentHouse].coords.enter.x + POIOffsets.exit.x, Config.Houses[CurrentHouse].coords.enter.y + POIOffsets.exit.y, Config.Houses[CurrentHouse].coords.enter.z - Config.MinZOffset + POIOffsets.exit.z, '~g~E~w~ - Leave')
                                        -- DrawText3Ds(Config.Houses[CurrentHouse].coords.enter.x + POIOffsets.exit.x, Config.Houses[CurrentHouse].coords.enter.y + POIOffsets.exit.y, Config.Houses[CurrentHouse].coords.enter.z - Config.MinZOffset + POIOffsets.exit.z - 0.1, '~g~H~w~ - Camera')
                                        if IsControlJustPressed(0, 38) then -- E
                                            leaveOwnedHouse(CurrentHouse)
                                        end
                                        if IsControlJustPressed(0, 74) then -- H
                                            FrontDoorCam(Config.Houses[CurrentHouse].coords.enter)
                                        end
                                    else
                                        if showText3 then
                                            exports['mr-text']:HideText(3)
                                            exports['mr-text']:HideText(10)
                                            showText3 = false
                                        end
                                        if showText2 then
                                            exports['mr-text']:HideText(2)
                                            showText2 = false
                                        end
                                    end
                                end
                            end
                        end
                    end
                else
                    if not isOwned then
                        if closesthouse ~= nil then
                            if(GetDistanceBetweenCoords(pos, Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z, true) < 1.5)then
                                if not viewCam and Config.Houses[closesthouse].locked then
                                    if not showText then
                                        exports['mr-text']:DrawText(
                                            '[E] To view the house',
                                            0, 94, 255,0.7,
                                            1,
                                            50
                                        )
                                        showText = true
                                    end
                                    -- DrawText3Ds(Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z, '~g~E~w~ - To view the house')
                                    if IsControlJustPressed(0, 38) then
                                        TriggerServerEvent("mr-houses:ExistRent")
                                    end
                                -- elseif not viewCam and not Config.Houses[closesthouse].locked then
                                --     DrawText3Ds(Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z, '[~g~E~w~] Om naar ~b~binnen~w~ te gaan')
                                --     if IsControlJustPressed(0, 38)  then
                                --         enterNonOwnedHouse(closesthouse)
                                --     end
                                end
                            else
                                if showText then
                                    exports['mr-text']:HideText(1)
                                    showText = false
                                end
                            end
                        end
                    elseif isOwned then
                        if closesthouse ~= nil then
                            if not inOwned then
                                -- if(GetDistanceBetweenCoords(pos, Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z, true) < 1.5)then
                                    -- if not Config.Houses[closesthouse].locked then
                                    --     DrawText3Ds(Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z, '[~g~E~w~] Om naar ~b~binnen~w~ te gaan')
                                    --     if IsControlJustPressed(0, 38)  then
                                    --         enterNonOwnedHouse(closesthouse)
                                    --     end
                                    -- else
                                    --     DrawText3Ds(Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z, 'De deur is ~r~vergrendeld / ~g~G~w~ - Aanbellen')
                                    --     if IsControlJustPressed(0, 47) then
                                    --         TriggerServerEvent('mr-houses:server:RingDoor', closesthouse)
                                    --     end
                                    -- end
                                -- end
                            elseif inOwned then
                                if POIOffsets ~= nil then
                                    if POIOffsets.exit ~= nil then
                                        if(GetDistanceBetweenCoords(pos, Config.Houses[CurrentHouse].coords.shell.x + POIOffsets.exit.x, Config.Houses[CurrentHouse].coords.shell.y + POIOffsets.exit.y, Config.Houses[CurrentHouse].coords.shell.z + POIOffsets.exit.z, true) < 1.5)then
                                            if not showText3 then
                                                exports['mr-text']:DrawText(
                                                    '[E] To leave home',
                                                    0, 94, 255,0.7,
                                                    3,
                                                    50
                                                )
                                                showText3 = true
                                            end
                                            -- DrawText3Ds(Config.Houses[CurrentHouse].coords.enter.x + POIOffsets.exit.x, Config.Houses[CurrentHouse].coords.enter.y + POIOffsets.exit.y, Config.Houses[CurrentHouse].coords.enter.z - Config.MinZOffset + POIOffsets.exit.z, '~g~E~w~ - To leave home')
                                            if IsControlJustPressed(0, 38) then
                                                leaveNonOwnedHouse(CurrentHouse)
                                            end
                                        else
                                            if showText3 then
                                                exports['mr-text']:HideText(3)
                                                showText3 = false
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    if inside and not isOwned then
                        if not entering then
                            if POIOffsets ~= nil then
                                if POIOffsets.exit ~= nil then
                                    if #(pos - vector3(Config.Houses[CurrentHouse].coords.shell.x + POIOffsets.exit.x, Config.Houses[CurrentHouse].coords.shell.y + POIOffsets.exit.y, Config.Houses[CurrentHouse].coords.shell.z + POIOffsets.exit.z)) < 1.5 then
                                        if not showText3 then
                                            exports['mr-text']:DrawText(
                                                '[E] Leave',
                                                0, 94, 255,0.7,
                                                3,
                                                50
                                            )
                                            showText3 = true
                                        end
                                        -- DrawText3Ds(Config.Houses[CurrentHouse].coords.enter.x + POIOffsets.exit.x, Config.Houses[CurrentHouse].coords.enter.y + POIOffsets.exit.y, Config.Houses[CurrentHouse].coords.enter.z - Config.MinZOffset + POIOffsets.exit.z, '~g~E~w~ - Leave')
                                        if IsControlJustPressed(0, 38) then -- E
                                            leaveNonOwnedHouse(CurrentHouse)
                                        end
                                    else
                                        if showText3 then
                                            exports['mr-text']:HideText(3)
                                            showText3 = false
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                -- STASH
                if inside then
                    if CurrentHouse ~= nil then
                        if stashLocation ~= nil then
                            if #(pos - vector3(stashLocation.x, stashLocation.y, stashLocation.z)) < 1.5 then
                                if not showText4 then
                                    exports['mr-text']:DrawText(
                                        '[E] Stash',
                                        0, 94, 255,0.7,
                                        4,
                                        50
                                    )
                                    showText4 = true
                                end
                                -- DrawText3Ds(stashLocation.x, stashLocation.y, stashLocation.z, '~g~E~w~ - Stash')
                                if IsControlJustPressed(0, 38) then -- E
                                    if hasKey then
                                        local other = {}
                                        other.maxweight = 1000000
                                        other.slots = 50
                                        if Config.Houses[CurrentHouse].tier == 1 then
                                            other.maxweight = 3000000
                                            other.slots = 90
                                        end
                                        if Config.Houses[CurrentHouse].tier == 2 then
                                            other.maxweight = 3500000
                                            other.slots = 100
                                        end
                                        if Config.Houses[CurrentHouse].tier == 3 then
                                            other.maxweight = 4000000
                                            other.slots = 120
                                        end
                                        if Config.Houses[CurrentHouse].tier == 4 then
                                            other.maxweight = 4000000
                                            other.slots = 100
                                        end		
                                        if Config.Houses[CurrentHouse].tier == 5 then
                                            other.maxweight = 4500000
                                            other.slots = 100
                                        end
                                        if Config.Houses[CurrentHouse].tier == 6 then
                                            other.maxweight = 5000000
                                            other.slots = 130
                                        end
                                        if Config.Houses[CurrentHouse].tier == 7 then
                                            other.maxweight = 5500000
                                            other.slots = 150
                                        end	
                                        if Config.Houses[CurrentHouse].tier == 8 then
                                            other.maxweight = 5500000
                                            other.slots = 150
                                        end	
                                        if Config.Houses[CurrentHouse].tier == 9 then
                                            other.maxweight = 6000000
                                            other.slots = 150
                                        end	
                                        if Config.Houses[CurrentHouse].tier == 10 then
                                            other.maxweight = 6500000
                                            other.slots = 160
                                        end	
                                        if Config.Houses[CurrentHouse].tier == 11 then
                                            other.maxweight = 7000000
                                            other.slots = 170
                                        end
                                        if Config.Houses[CurrentHouse].tier == 12 then
                                            other.maxweight = 7000000
                                            other.slots = 170
                                        end
                                        if Config.Houses[CurrentHouse].tier == 13 then
                                            other.maxweight = 7000000
                                            other.slots = 170
                                        end	
                                        if Config.Houses[CurrentHouse].tier == 14 then
                                            other.maxweight = 10000000
                                            other.slots = 250
                                        end	
                                        if Config.Houses[CurrentHouse].tier == 15 then
                                            other.maxweight = 8500000
                                            other.slots = 200
                                        end	
                                        if Config.Houses[CurrentHouse].tier == 16 then
                                            other.maxweight = 8000000
                                            other.slots = 200
                                        end		
                                        if Config.Houses[CurrentHouse].tier == 17 then
                                            other.maxweight = 8000000
                                            other.slots = 200
                                        end			
                                        TriggerServerEvent("inventory:server:OpenInventory", "stash", CurrentHouse, other)
                                        TriggerEvent("inventory:client:SetCurrentStash", CurrentHouse)
                                    else
                                        MRFW.Functions.Notify('Stash is Locked', 'error', 3000)
                                    end
                                end
                            else
                                if showText4 then
                                    exports['mr-text']:HideText(4)
                                    showText4 = false
                                end
                            end
                        end
                    end
                end

                local CupboardObject = nil
                -- Cupboard
                if inside then
                    if CurrentHouse ~= nil then
                        if cupboardLocation ~= nil then
                            if(GetDistanceBetweenCoords(pos, cupboardLocation.x, cupboardLocation.y, cupboardLocation.z, true) < 1.5)then
                                if not showText5 then
                                    exports['mr-text']:DrawText(
                                        '[E] Cupboard',
                                        0, 94, 255,0.7,
                                        5,
                                        50
                                    )
                                    showText5 = true
                                end
                                -- DrawText3Ds(cupboardLocation.x, cupboardLocation.y, cupboardLocation.z, '~g~E~w~ - Cupboard')
                                if IsControlJustPressed(0, 38) then
                                    if hasKey then
                                        local other = {}
                                        other.maxweight = 500000
                                        other.slots = 50		
                                        TriggerServerEvent("inventory:server:OpenInventory", "stash", "Cupboard_"..CurrentHouse, other)
                                        TriggerEvent("inventory:client:SetCurrentStash","Cupboard_"..CurrentHouse)
                                    else
                                        MRFW.Functions.Notify('Cup Board is Locked', 'error', 3000)
                                    end
                                end
                            else
                                if showText5 then
                                    exports['mr-text']:HideText(5)
                                    showText5 = false
                                end
                            end
                        end
                    end
                end

                if inside then
                    if CurrentHouse ~= nil then
                        if outfitLocation ~= nil then
                            if #(pos - vector3(outfitLocation.x, outfitLocation.y, outfitLocation.z)) < 1.5 then
                                if not showText6 then
                                    exports['mr-text']:DrawText(
                                        '[E] Outfits',
                                        0, 94, 255,0.7,
                                        6,
                                        50
                                    )
                                    showText6 = true
                                end
                                -- DrawText3Ds(outfitLocation.x, outfitLocation.y, outfitLocation.z, '~g~E~w~ - Outfits')
                                if IsControlJustPressed(0, 38) then -- E
                                    TriggerEvent('mr-clothing:client:openOutfitMenu')
                                end
                            else
                                if showText6 then
                                    exports['mr-text']:HideText(6)
                                    showText6 = false
                                end
                            end
                        end
                    end
                end
                if inside then
                    if CurrentHouse ~= nil then
                        if logoutLocation ~= nil then
                            if #(pos - vector3(logoutLocation.x, logoutLocation.y, logoutLocation.z)) < 1.5 then
                                if not showText7 then
                                    exports['mr-text']:DrawText(
                                        '[E] Change Characters',
                                        0, 94, 255,0.7,
                                        7,
                                        50
                                    )
                                    showText7 = true
                                end
                                -- DrawText3Ds(logoutLocation.x, logoutLocation.y, logoutLocation.z, '~g~E~w~ - Change Characters')
                                if IsControlJustPressed(0, 38) then -- E
                                    DoScreenFadeOut(250)
                                    while not IsScreenFadedOut() do
                                        Citizen.Wait(10)
                                    end
                                    exports['mr-interior']:DespawnInterior(houseObj, function()
                                        TriggerEvent('mr-weathersync:client:EnableSync')
                                        SetEntityCoords(PlayerPedId(), Config.Houses[CurrentHouse].coords.enter.x, Config.Houses[CurrentHouse].coords.enter.y, Config.Houses[CurrentHouse].coords.enter.z + 0.5)
                                        SetEntityHeading(PlayerPedId(), Config.Houses[CurrentHouse].coords.enter.h)
                                        inOwned = false
                                        inside = false
                                        if showText7 then
                                            exports['mr-text']:HideText(7)
                                            showText7 = false
                                        end
                                        TriggerServerEvent('mr-houses:server:LogoutLocation')
                                    end)
                                end
                            else
                                if showText7 then
                                    exports['mr-text']:HideText(7)
                                    showText7 = false
                                end
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    while true do
        sleep = 2500
        local inRange = false
        if LocalPlayer.state['isLoggedIn'] and MRFW ~= nil then
            sleep = 1000
            local pos = GetEntityCoords(PlayerPedId())
            if #(pos - vector3(Config.Locations["main1"].coords.x, Config.Locations["main1"].coords.y, Config.Locations["main1"].coords.z)) < 1.5 or #(pos - vector3(Config.Locations["inside"].coords.x, Config.Locations["inside"].coords.y, Config.Locations["inside"].coords.z)) < 1.5 then
                inRange = true
                sleep = 5
                if #(pos - vector3(Config.Locations["main1"].coords.x, Config.Locations["main1"].coords.y, Config.Locations["main1"].coords.z)) < 1.5 then
                    DrawText3D(Config.Locations["main1"].coords.x, Config.Locations["main1"].coords.y, Config.Locations["main1"].coords.z, "~g~E~w~ - To Enter Real Estate Office")
                    if IsControlJustReleased(0, 38) then
                        DoScreenFadeOut(500)
                        while not IsScreenFadedOut() do
                            Citizen.Wait(10)
                        end
    
                        SetEntityCoords(PlayerPedId(), Config.Locations["inside"].coords.x, Config.Locations["inside"].coords.y, Config.Locations["inside"].coords.z, 0, 0, 0, false)
                        SetEntityHeading(PlayerPedId(), Config.Locations["inside"].coords.h)
    
                        Citizen.Wait(100)
    
                        DoScreenFadeIn(1000)
                    end
                elseif #(pos - vector3(Config.Locations["inside"].coords.x, Config.Locations["inside"].coords.y, Config.Locations["inside"].coords.z)) < 1.5 then
                    sleep = 5
                    DrawText3D(Config.Locations["inside"].coords.x, Config.Locations["inside"].coords.y, Config.Locations["inside"].coords.z, "~g~E~w~ - To go outside")
                    if IsControlJustReleased(0, 38) then
                        DoScreenFadeOut(500)
                        while not IsScreenFadedOut() do
                            Citizen.Wait(10)
                        end
    
                        SetEntityCoords(PlayerPedId(), Config.Locations["outside"].coords.x, Config.Locations["outside"].coords.y, Config.Locations["outside"].coords.z, 0, 0, 0, false)
                        SetEntityHeading(PlayerPedId(), Config.Locations["outside"].coords.h)
    
                        Citizen.Wait(100)
    
                        DoScreenFadeIn(1000)
                    end
                end 
            end
        end
        Citizen.Wait(sleep)
    end
end)

function DrawText3D(x, y, z, text)
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

-- RegisterCommand('getoffset', function()
--     local coords = GetEntityCoords(PlayerPedId())
--     local houseCoords = vector3(
--         Config.Houses[CurrentHouse].coords.enter.x,
--         Config.Houses[CurrentHouse].coords.enter.y,
--         Config.Houses[CurrentHouse].coords.enter.z - Config.MinZOffset
--     )
--     if inside then
--         local xdist = coords.x - houseCoords.x
--         local ydist = coords.y - houseCoords.y
--         local zdist = coords.z - houseCoords.z
--         -- print('X: '..xdist)
--         -- print('Y: '..ydist)
--         -- print('Z: '..zdist)
--     end
-- end)

function removeOutfit(oData)
    TriggerServerEvent('clothes:removeOutfit', oData.outfitname)
    MRFW.Functions.Notify(oData.outfitname.." Is removed", "success", 2500)
    closeMenuFull()
end
function changeOutfit()
	Wait(200)
    loadAnimDict("clothingshirt")    	
	TaskPlayAnim(PlayerPedId(), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
	Wait(3100)
	TaskPlayAnim(PlayerPedId(), "clothingshirt", "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
end

RegisterNetEvent('mr-pethouse:spawnpetz', function()
    MRFW.Functions.TriggerCallback('MRFW:HasItem', function(result)
        if result then
            if closesthouse ~= nil then 
                local housedist = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z)
                if housedist < 8 then
                    MRFW.Functions.TriggerCallback('mr-houses:server:getHouseOwner', function(result)
                        if MRFW.Functions.GetPlayerData().citizenid == result then
                            TriggerServerEvent('mr-pethouse:spawnpet')
                        else
                            MRFW.Functions.Notify("You're not a house owner..", "error")
                        end
                    end, closesthouse)
                else
                    MRFW.Functions.Notify("You'r not close enough to the house.", "error")
                end
            else
                MRFW.Functions.Notify("You'r not close enough to the house..", "error")
            end
	        
        else
            MRFW.Functions.Notify("You Don't have Pet License!", "error")
        end
    end, 'petlicense')
end)

RegisterNetEvent('mr-houses:mail', function(hnumber , house , rentPayment)
    TriggerServerEvent('mr-phone:server:sendNewMail', {
        sender = "House Rent",
        subject = "Report",
        message = "Hi sir/mam , <br><br> Your House Plate : <strong>"..hnumber.. " | Location : " ..house.. "</strong> rent not settled yet! <br>Your Rent amount <strong> $ "..rentPayment.. "</strong> is left to be paid . Kindly pay by <strong>/payrent</strong> else we will seize your house <br><br> Real Estate",
        button = {}
    })
end)

RegisterNetEvent('mr-houses:paidmail')
AddEventHandler('mr-houses:paidmail', function(hnumber , house , rentPayment)


    TriggerServerEvent('mr-phone:server:sendNewMail', {
        sender = "House Rent",
        subject = "Receipt",
        message = "Hi sir/mam , <br><br> Your House Plate : <strong>"..hnumber.. " | Location : " ..house.. "</strong> whose Rent amount was <strong> $ "..rentPayment.. "</strong> is paid! . To check next Payment details , check on House app. To Pay full do <strong>/payfullrent</strong>. <br><br> Real Estate",
        button = {}
    })
end)

RegisterNetEvent('mr-houses:client:checkhouse')
AddEventHandler('mr-houses:client:checkhouse', function()
    TriggerServerEvent('mr-houses:server:viewHouse', closesthouse)
end)


RegisterNetEvent('mr-houses:client:payrent')
AddEventHandler('mr-houses:client:payrent', function()
    TriggerServerEvent('mr-houses:PayRent')
end)

RegisterNetEvent('mr-houses:client:cRent')
AddEventHandler('mr-houses:client:cRent', function()
    TriggerServerEvent('mr-houses:CheckRent')
end)

local blips = {

    {title="Real Estate", colour=0, id=375, x = -117.04, y = -604.8, z = 36.28},
 }

Citizen.CreateThread(function()

   for _, info in pairs(blips) do
     info.blip = AddBlipForCoord(info.x, info.y, info.z)
     SetBlipSprite(info.blip, info.id)
     SetBlipDisplay(info.blip, 4)
     SetBlipScale(info.blip, 0.8)
     SetBlipColour(info.blip, 1)
     SetBlipAsShortRange(info.blip, true)
     BeginTextCommandSetBlipName("STRING")
     AddTextComponentString(info.title)
     EndTextCommandSetBlipName(info.blip)
   end
end)

local timeout = 0


RegisterNetEvent('Jacob:Client:MyHouses')
AddEventHandler('Jacob:Client:MyHouses', function(cid)
    if timeout == 0 then
        TriggerServerEvent('Jacob:Server:MyHouses', cid, 0)
        timeout = 60
        ttt()
    else
        TriggerServerEvent('Jacob:Server:MyHouses', timeout, timeout)
    end
end)
RegisterNetEvent('Jacob:Client:MyHouses:results')
AddEventHandler('Jacob:Client:MyHouses:results', function(r)
     local rr = r
    if rr ~= nil then
        for k,v in pairs(rr) do
            local houseID = v.id
            local houseName = v.label
            local houseTier = v.tier 
            local housePostal = v.postal 
            
            ---TriggerEvent('chatMessage', "SYSTEM:", "normal", "House ID: "..houseID.." | House Name: "..houseName.." | House Tier: "..houseTier.." | House Postal: "..housePostal)
            TriggerServerEvent('mr-phone:server:sendNewMail', {
                sender = "Government",
                subject = "House Data",
                message = "Hi sir/mam , <br><br> Your House ID : <strong>"..houseID.." | House Name: " ..houseName.." | House Tier: "..houseTier.." | House Postal: "..housePostal.." <br><br> Real Estate",
                button = {}
            })
        end
    else
        TriggerEvent('chatMessage', "SYSTEM:", "error", "You don\'t owned any houses.")
    end
end)

function ttt()
    -- print(timeout)
    while timeout > 0 do
        Wait(1000)
        timeout = timeout - 1
    end
end

RegisterNetEvent('jacob:get:this:house')
AddEventHandler('jacob:get:this:house', function(src)
    TriggerServerEvent("jacob:get:this:house:s", src, closesthouse)
end)

RegisterNetEvent('houses:client:fixhouse', function(data)
    if inside then
        if isOwned then
            FixSaveDecorations()
        else
            MRFW.Functions.Notify('You Are Not The Owner of This House', 'error', 3000)
        end
    else
        MRFW.Functions.Notify('You are not in a house', 'error', 3000)
    end
end)