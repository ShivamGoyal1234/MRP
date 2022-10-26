-- Variables

local MRFW = exports['mrfw']:GetCoreObject()
local Drops = {}
local Trunks = {}
local Gloveboxes = {}
local Stashes = {}
local ShopItems = {}

-- Functions

local function recipeContains(recipe, fromItem)
	for k, v in pairs(recipe.accept) do
		if v == fromItem.name then
			return true
		end
	end

	return false
end

local function hasCraftItems(source, CostItems, amount)
	local Player = MRFW.Functions.GetPlayer(source)
	for k, v in pairs(CostItems) do
		if Player.Functions.GetItemByName(k) ~= nil then
			if Player.Functions.GetItemByName(k).amount < (v * amount) then
				return false
			end
		else
			return false
		end
	end
	return true
end

local function IsVehicleOwned(plate)
    local result = MySQL.Sync.fetchScalar('SELECT 1 from player_vehicles WHERE plate = ?', {plate})
    if result then return true else return false end
end

-- Shop Items
local function SetupShopItems(shop, shopItems)
	local items = {}
	if shopItems and next(shopItems) then
		for k, item in pairs(shopItems) do
			local itemInfo = MRFW.Shared.Items[item.name:lower()]
			if itemInfo then
				items[item.slot] = {
					name = itemInfo["name"],
					amount = tonumber(item.amount),
					info = item.info or "",
					label = itemInfo["label"],
					description = itemInfo["description"] or "",
					weight = itemInfo["weight"],
					type = itemInfo["type"],
					unique = itemInfo["unique"],
					useable = itemInfo["useable"],
					price = item.price,
					image = itemInfo["image"],
					slot = item.slot,
				}
			end
		end
	end
	return items
end

-- Stash Items
local function GetStashItems(stashId)
	local items = {}
	local result = MySQL.Sync.fetchScalar('SELECT items FROM stashitems WHERE stash = ?', {stashId})
	if result then
		local stashItems = json.decode(result)
		if stashItems then
			for k, item in pairs(stashItems) do
				local itemInfo = MRFW.Shared.Items[item.name:lower()]
				if itemInfo then
					items[item.slot] = {
						name = itemInfo["name"],
						amount = tonumber(item.amount),
						info = item.info or "",
						label = itemInfo["label"],
						description = itemInfo["description"] or "",
						weight = itemInfo["weight"],
						type = itemInfo["type"],
						unique = itemInfo["unique"],
						useable = itemInfo["useable"],
						image = itemInfo["image"],
						slot = item.slot,
					}
				end
			end
		end
	end
	return items
end

local function SaveStashItems(stashId, items)
	if Stashes[stashId].label ~= "Stash-None" then
		if items then
			for slot, item in pairs(items) do
				item.description = nil
			end
			MySQL.Async.insert('INSERT INTO stashitems (stash, items) VALUES (:stash, :items) ON DUPLICATE KEY UPDATE items = :items', {
				['stash'] = stashId,
				['items'] = json.encode(items)
			})
			Stashes[stashId].isOpen = false
		end
	end
end

local function AddToStash(stashId, slot, otherslot, itemName, amount, info)
	local amount = tonumber(amount)
	local ItemData = MRFW.Shared.Items[itemName]
	if not ItemData.unique then
		if Stashes[stashId].items[slot] and Stashes[stashId].items[slot].name == itemName then
			Stashes[stashId].items[slot].amount = Stashes[stashId].items[slot].amount + amount
		else
			local itemInfo = MRFW.Shared.Items[itemName:lower()]
			Stashes[stashId].items[slot] = {
				name = itemInfo["name"],
				amount = amount,
				info = info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] or "",
				weight = itemInfo["weight"],
				type = itemInfo["type"],
				unique = itemInfo["unique"],
				useable = itemInfo["useable"],
				image = itemInfo["image"],
				slot = slot,
			}
		end
	else
		if Stashes[stashId].items[slot] and Stashes[stashId].items[slot].name == itemName then
			local itemInfo = MRFW.Shared.Items[itemName:lower()]
			Stashes[stashId].items[otherslot] = {
				name = itemInfo["name"],
				amount = amount,
				info = info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] or "",
				weight = itemInfo["weight"],
				type = itemInfo["type"],
				unique = itemInfo["unique"],
				useable = itemInfo["useable"],
				image = itemInfo["image"],
				slot = otherslot,
			}
		else
			local itemInfo = MRFW.Shared.Items[itemName:lower()]
			Stashes[stashId].items[slot] = {
				name = itemInfo["name"],
				amount = amount,
				info = info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] or "",
				weight = itemInfo["weight"],
				type = itemInfo["type"],
				unique = itemInfo["unique"],
				useable = itemInfo["useable"],
				image = itemInfo["image"],
				slot = slot,
			}
		end
	end
end

local function RemoveFromStash(stashId, slot, itemName, amount)
	local amount = tonumber(amount)
	if Stashes[stashId].items[slot] ~= nil and Stashes[stashId].items[slot].name == itemName then
		if Stashes[stashId].items[slot].amount > amount then
			Stashes[stashId].items[slot].amount = Stashes[stashId].items[slot].amount - amount
		else
			Stashes[stashId].items[slot] = nil
			if next(Stashes[stashId].items) == nil then
				Stashes[stashId].items = {}
			end
		end
	else
		Stashes[stashId].items[slot] = nil
		if Stashes[stashId].items == nil then
			Stashes[stashId].items[slot] = nil
		end
	end
end

-- Trunk items
local function GetOwnedVehicleItems(plate)
	local items = {}
	local result = MySQL.Sync.fetchScalar('SELECT items FROM trunkitems WHERE plate = ?', {plate})
	if result then
		local trunkItems = json.decode(result)
		if trunkItems then
			for k, item in pairs(trunkItems) do
				local itemInfo = MRFW.Shared.Items[item.name:lower()]
				if itemInfo then
					items[item.slot] = {
						name = itemInfo["name"],
						amount = tonumber(item.amount),
						info = item.info or "",
						label = itemInfo["label"],
						description = itemInfo["description"] or "",
						weight = itemInfo["weight"],
						type = itemInfo["type"],
						unique = itemInfo["unique"],
						useable = itemInfo["useable"],
						image = itemInfo["image"],
						slot = item.slot,
					}
				end
			end
		end
	end
	return items
end

local function SaveOwnedVehicleItems(plate, items)
	if Trunks[plate].label ~= "Trunk-None" then
		if items ~= nil then
			for slot, item in pairs(items) do
				item.description = nil
			end
			MySQL.Async.insert('INSERT INTO trunkitems (plate, items) VALUES (:plate, :items) ON DUPLICATE KEY UPDATE items = :items', {
				['plate'] = plate,
				['items'] = json.encode(items)
			})
			Trunks[plate].isOpen = false
		end
	end
end

local function AddToTrunk(plate, slot, otherslot, itemName, amount, info)
	local amount = tonumber(amount)
	local ItemData = MRFW.Shared.Items[itemName]

	if not ItemData.unique then
		if Trunks[plate].items[slot] ~= nil and Trunks[plate].items[slot].name == itemName then
			Trunks[plate].items[slot].amount = Trunks[plate].items[slot].amount + amount
		else
			local itemInfo = MRFW.Shared.Items[itemName:lower()]
			Trunks[plate].items[slot] = {
				name = itemInfo["name"],
				amount = amount,
				info = info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] or "",
				weight = itemInfo["weight"],
				type = itemInfo["type"],
				unique = itemInfo["unique"],
				useable = itemInfo["useable"],
				image = itemInfo["image"],
				slot = slot,
			}
		end
	else
		if Trunks[plate].items[slot] ~= nil and Trunks[plate].items[slot].name == itemName then
			local itemInfo = MRFW.Shared.Items[itemName:lower()]
			Trunks[plate].items[otherslot] = {
				name = itemInfo["name"],
				amount = amount,
				info = info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] or "",
				weight = itemInfo["weight"],
				type = itemInfo["type"],
				unique = itemInfo["unique"],
				useable = itemInfo["useable"],
				image = itemInfo["image"],
				slot = otherslot,
			}
		else
			local itemInfo = MRFW.Shared.Items[itemName:lower()]
			Trunks[plate].items[slot] = {
				name = itemInfo["name"],
				amount = amount,
				info = info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] or "",
				weight = itemInfo["weight"],
				type = itemInfo["type"],
				unique = itemInfo["unique"],
				useable = itemInfo["useable"],
				image = itemInfo["image"],
				slot = slot,
			}
		end
	end
end

local function RemoveFromTrunk(plate, slot, itemName, amount)
	if Trunks[plate].items[slot] ~= nil and Trunks[plate].items[slot].name == itemName then
		if Trunks[plate].items[slot].amount > amount then
			Trunks[plate].items[slot].amount = Trunks[plate].items[slot].amount - amount
		else
			Trunks[plate].items[slot] = nil
			if next(Trunks[plate].items) == nil then
				Trunks[plate].items = {}
			end
		end
	else
		Trunks[plate].items[slot]= nil
		if Trunks[plate].items == nil then
			Trunks[plate].items[slot] = nil
		end
	end
end

-- Glovebox items
local function GetOwnedVehicleGloveboxItems(plate)
	local items = {}
	local result = MySQL.Sync.fetchScalar('SELECT items FROM gloveboxitems WHERE plate = ?', {plate})
	if result then
		local gloveboxItems = json.decode(result)
		if gloveboxItems then
			for k, item in pairs(gloveboxItems) do
				local itemInfo = MRFW.Shared.Items[item.name:lower()]
				if itemInfo then
					items[item.slot] = {
						name = itemInfo["name"],
						amount = tonumber(item.amount),
						info = item.info or "",
						label = itemInfo["label"],
						description = itemInfo["description"] or "",
						weight = itemInfo["weight"],
						type = itemInfo["type"],
						unique = itemInfo["unique"],
						useable = itemInfo["useable"],
						image = itemInfo["image"],
						slot = item.slot,
					}
				end
			end
		end
	end
	return items
end

local function SaveOwnedGloveboxItems(plate, items)
	if Gloveboxes[plate].label ~= "Glovebox-None" then
		if items ~= nil then
			for slot, item in pairs(items) do
				item.description = nil
			end
			MySQL.Async.insert('INSERT INTO gloveboxitems (plate, items) VALUES (:plate, :items) ON DUPLICATE KEY UPDATE items = :items', {
				['plate'] = plate,
				['items'] = json.encode(items)
			})
			Gloveboxes[plate].isOpen = false
		end
	end
end

local function AddToGlovebox(plate, slot, otherslot, itemName, amount, info)
	local amount = tonumber(amount)
	local ItemData = MRFW.Shared.Items[itemName]

	if not ItemData.unique then
		if Gloveboxes[plate].items[slot] ~= nil and Gloveboxes[plate].items[slot].name == itemName then
			Gloveboxes[plate].items[slot].amount = Gloveboxes[plate].items[slot].amount + amount
		else
			local itemInfo = MRFW.Shared.Items[itemName:lower()]
			Gloveboxes[plate].items[slot] = {
				name = itemInfo["name"],
				amount = amount,
				info = info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] or "",
				weight = itemInfo["weight"],
				type = itemInfo["type"],
				unique = itemInfo["unique"],
				useable = itemInfo["useable"],
				image = itemInfo["image"],
				slot = slot,
			}
		end
	else
		if Gloveboxes[plate].items[slot] ~= nil and Gloveboxes[plate].items[slot].name == itemName then
			local itemInfo = MRFW.Shared.Items[itemName:lower()]
			Gloveboxes[plate].items[otherslot] = {
				name = itemInfo["name"],
				amount = amount,
				info = info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] or "",
				weight = itemInfo["weight"],
				type = itemInfo["type"],
				unique = itemInfo["unique"],
				useable = itemInfo["useable"],
				image = itemInfo["image"],
				slot = otherslot,
			}
		else
			local itemInfo = MRFW.Shared.Items[itemName:lower()]
			Gloveboxes[plate].items[slot] = {
				name = itemInfo["name"],
				amount = amount,
				info = info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] or "",
				weight = itemInfo["weight"],
				type = itemInfo["type"],
				unique = itemInfo["unique"],
				useable = itemInfo["useable"],
				image = itemInfo["image"],
				slot = slot,
			}
		end
	end
end

local function RemoveFromGlovebox(plate, slot, itemName, amount)
	if Gloveboxes[plate].items[slot] ~= nil and Gloveboxes[plate].items[slot].name == itemName then
		if Gloveboxes[plate].items[slot].amount > amount then
			Gloveboxes[plate].items[slot].amount = Gloveboxes[plate].items[slot].amount - amount
		else
			Gloveboxes[plate].items[slot] = nil
			if next(Gloveboxes[plate].items) == nil then
				Gloveboxes[plate].items = {}
			end
		end
	else
		Gloveboxes[plate].items[slot]= nil
		if Gloveboxes[plate].items == nil then
			Gloveboxes[plate].items[slot] = nil
		end
	end
end

-- Drop items
local function AddToDrop(dropId, slot, itemName, amount, info)
	local amount = tonumber(amount)
	if Drops[dropId].items[slot] ~= nil and Drops[dropId].items[slot].name == itemName then
		Drops[dropId].items[slot].amount = Drops[dropId].items[slot].amount + amount
	else
		local itemInfo = MRFW.Shared.Items[itemName:lower()]
		Drops[dropId].items[slot] = {
			name = itemInfo["name"],
			amount = amount,
			info = info or "",
			label = itemInfo["label"],
			description = itemInfo["description"] or "",
			weight = itemInfo["weight"],
			type = itemInfo["type"],
			unique = itemInfo["unique"],
			useable = itemInfo["useable"],
			image = itemInfo["image"],
			slot = slot,
			id = dropId,
		}
	end
end

local function RemoveFromDrop(dropId, slot, itemName, amount)
	if Drops[dropId].items[slot] ~= nil and Drops[dropId].items[slot].name == itemName then
		if Drops[dropId].items[slot].amount > amount then
			Drops[dropId].items[slot].amount = Drops[dropId].items[slot].amount - amount
		else
			Drops[dropId].items[slot] = nil
			if next(Drops[dropId].items) == nil then
				Drops[dropId].items = {}
			end
		end
	else
		Drops[dropId].items[slot] = nil
		if Drops[dropId].items == nil then
			Drops[dropId].items[slot] = nil
		end
	end
end

local function CreateDropId()
	if Drops ~= nil then
		local id = math.random(10000, 99999)
		local dropid = id
		while Drops[dropid] ~= nil do
			id = math.random(10000, 99999)
			dropid = id
		end
		return dropid
	else
		local id = math.random(10000, 99999)
		local dropid = id
		return dropid
	end
end

local function CreateNewDrop(source, fromSlot, toSlot, itemAmount)
	local Player = MRFW.Functions.GetPlayer(source)
	local itemData = Player.Functions.GetItemBySlot(fromSlot)
	local coords = GetEntityCoords(GetPlayerPed(source))
	if Player.Functions.RemoveItem(itemData.name, itemAmount, itemData.slot) then
		TriggerClientEvent("inventory:client:CheckWeapon", source, itemData.name)
		local itemInfo = MRFW.Shared.Items[itemData.name:lower()]
		local dropId = CreateDropId()
		Drops[dropId] = {}
		Drops[dropId].items = {}

		Drops[dropId].items[toSlot] = {
			name = itemInfo["name"],
			amount = itemAmount,
			info = itemData.info or "",
			label = itemInfo["label"],
			description = itemInfo["description"] or "",
			weight = itemInfo["weight"],
			type = itemInfo["type"],
			unique = itemInfo["unique"],
			useable = itemInfo["useable"],
			image = itemInfo["image"],
			slot = toSlot,
			id = dropId,
		}
		TriggerEvent("mr-log:server:CreateLog", "drop", "New Item Drop", "red", "**".. GetPlayerName(source) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..source.."*) dropped new item; name: **"..itemData.name.."**, amount: **" .. itemAmount .. "**")
		TriggerClientEvent("inventory:client:DropItemAnim", source)
		TriggerClientEvent("inventory:client:AddDropItem", -1, dropId, source, coords)
		if itemData.name:lower() == "radio" then
			TriggerClientEvent('Radio.Set', source, false)
		end
	else
		TriggerClientEvent("MRFW:Notify", source, "You don't have this item!", "error")
		return
	end
end

-- Events

RegisterNetEvent('inventory:server:addTrunkItems', function(plate, items)
	Trunks[plate] = {}
	Trunks[plate].items = items
end)

RegisterNetEvent('inventory:server:combineItem', function(item, fromItem, toItem)
	local src = source
	local ply = MRFW.Functions.GetPlayer(src)

	-- Check that inputs are not nil
	-- Most commonly when abusing this exploit, this values are left as
	if fromItem == nil  then return end
	if toItem == nil then return end

	-- Check that they have the items
	local fromItem = ply.Functions.GetItemByName(fromItem)
	local toItem = ply.Functions.GetItemByName(toItem)

	if fromItem == nil  then return end
	if toItem == nil then return end

	-- Check the recipe is valid
	local recipe = MRFW.Shared.Items[toItem.name].combinable

	if recipe and recipe.reward ~= item then return end
	if not recipeContains(recipe, fromItem) then return end

	TriggerClientEvent('inventory:client:ItemBox', src, MRFW.Shared.Items[item], 'add')
	ply.Functions.AddItem(item, 1)
	ply.Functions.RemoveItem(fromItem.name, 1)
	ply.Functions.RemoveItem(toItem.name, 1)
end)

RegisterNetEvent('inventory:server:CraftItems', function(itemName, itemCosts, amount, toSlot, points)
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	local amount = tonumber(amount)
	if itemName ~= nil and itemCosts ~= nil then
		for k, v in pairs(itemCosts) do
			Player.Functions.RemoveItem(k, (v*amount))
		end
		Player.Functions.AddItem(itemName, amount, toSlot)
		Player.Functions.SetMetaData("craftingrep", Player.PlayerData.metadata["craftingrep"]+(points*amount))
		TriggerClientEvent("inventory:client:UpdatePlayerInventory", src, false)
	end
end)

RegisterNetEvent('inventory:server:CraftAttachment', function(itemName, itemCosts, amount, toSlot, points)
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	local amount = tonumber(amount)
	if itemName ~= nil and itemCosts ~= nil then
		for k, v in pairs(itemCosts) do
			Player.Functions.RemoveItem(k, (v*amount))
		end
		Player.Functions.AddItem(itemName, amount, toSlot)
		Player.Functions.SetMetaData("attachmentcraftingrep", Player.PlayerData.metadata["attachmentcraftingrep"]+(points*amount))
		TriggerClientEvent("inventory:client:UpdatePlayerInventory", src, false)
	end
end)

RegisterNetEvent('inventory:server:pastaItems', function(itemName, itemCosts, amount, toSlot, points)
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	local amount = tonumber(amount)
	if itemName ~= nil and itemCosts ~= nil then
		for k, v in pairs(itemCosts) do
			Player.Functions.RemoveItem(k, (v*amount))
		end
		Player.Functions.AddItem(itemName, amount, toSlot)
		Player.Functions.SetMetaData("pastarep", Player.PlayerData.metadata["pastarep"]+(points*amount))
		TriggerClientEvent("inventory:client:UpdatePlayerInventory", src, false)
	end
end)

RegisterNetEvent('inventory:server:teaItems', function(itemName, itemCosts, amount, toSlot, points)
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	local amount = tonumber(amount)
	if itemName ~= nil and itemCosts ~= nil then
		for k, v in pairs(itemCosts) do
			Player.Functions.RemoveItem(k, (v*amount))
		end
		Player.Functions.AddItem(itemName, amount, toSlot)
		Player.Functions.SetMetaData("tearep", Player.PlayerData.metadata["tearep"]+(points*amount))
		TriggerClientEvent("inventory:client:UpdatePlayerInventory", src, false)
	end
end)

RegisterNetEvent('inventory:server:mcdItems', function(itemName, itemCosts, amount, toSlot, points)
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	local amount = tonumber(amount)
	if itemName ~= nil and itemCosts ~= nil then
		for k, v in pairs(itemCosts) do
			Player.Functions.RemoveItem(k, (v*amount))
		end
		Player.Functions.AddItem(itemName, amount, toSlot)
		Player.Functions.SetMetaData("mcdrep", Player.PlayerData.metadata["mcdrep"]+(points*amount))
		TriggerClientEvent("inventory:client:UpdatePlayerInventory", src, false)
	end
end)

RegisterNetEvent('inventory:server:dhabaItems', function(itemName, itemCosts, amount, toSlot, points)
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	local amount = tonumber(amount)
	if itemName ~= nil and itemCosts ~= nil then
		for k, v in pairs(itemCosts) do
			Player.Functions.RemoveItem(k, (v*amount))
		end
		Player.Functions.AddItem(itemName, amount, toSlot)
		Player.Functions.SetMetaData("dhabarep", Player.PlayerData.metadata["dhabarep"]+(points*amount))
		TriggerClientEvent("inventory:client:UpdatePlayerInventory", src, false)
	end
end)

RegisterNetEvent('inventory:server:mechItems', function(itemName, itemCosts, amount, toSlot, points)
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	local amount = tonumber(amount)
	if itemName ~= nil and itemCosts ~= nil then
		for k, v in pairs(itemCosts) do
			Player.Functions.RemoveItem(k, (v*amount))
		end
		Player.Functions.AddItem(itemName, amount, toSlot)
		Player.Functions.SetMetaData("mechrep", Player.PlayerData.metadata["mechrep"]+(points*amount))
		TriggerClientEvent("inventory:client:UpdatePlayerInventory", src, false)
	end
end)

RegisterNetEvent('inventory:server:SetIsOpenState', function(IsOpen, type, id)
	if not IsOpen then
		if type == "stash" then
			Stashes[id].isOpen = false
		elseif type == "trunk" then
			Trunks[id].isOpen = false
		elseif type == "glovebox" then
			Gloveboxes[id].isOpen = false
		elseif type == "drop" then
			Drops[id].isOpen = false
		end
	end
end)

RegisterNetEvent('inventory:server:OpenInventory', function(name, id, other)
	local src = source
	local ply = Player(src)
	local Player = MRFW.Functions.GetPlayer(src)
	if not ply.state.inv_busy then
		if name and id then
			local secondInv = {}
			if name == "stash" then
				if Stashes[id] then
					if Stashes[id].isOpen then
						local Target = MRFW.Functions.GetPlayer(Stashes[id].isOpen)
						if Target then
							TriggerClientEvent('inventory:client:CheckOpenState', Stashes[id].isOpen, name, id, Stashes[id].label)
						else
							Stashes[id].isOpen = false
						end
					end
				end
				local maxweight = 1000000
				local slots = 50
				if other then
					maxweight = other.maxweight or 1000000
					slots = other.slots or 50
				end
				secondInv.name = "stash-"..id
				secondInv.label = "Stash-"..id
				secondInv.maxweight = maxweight
				secondInv.inventory = {}
				secondInv.slots = slots
				if Stashes[id] and Stashes[id].isOpen then
					secondInv.name = "none-inv"
					secondInv.label = "Stash-None"
					secondInv.maxweight = 1000000
					secondInv.inventory = {}
					secondInv.slots = 0
				else
					local stashItems = GetStashItems(id)
					if next(stashItems) then
						secondInv.inventory = stashItems
						Stashes[id] = {}
						Stashes[id].items = stashItems
						Stashes[id].isOpen = src
						Stashes[id].label = secondInv.label
					else
						Stashes[id] = {}
						Stashes[id].items = {}
						Stashes[id].isOpen = src
						Stashes[id].label = secondInv.label
					end
				end
			elseif name == "trunk" then
				if Trunks[id] then
					if Trunks[id].isOpen then
						local Target = MRFW.Functions.GetPlayer(Trunks[id].isOpen)
						if Target then
							TriggerClientEvent('inventory:client:CheckOpenState', Trunks[id].isOpen, name, id, Trunks[id].label)
						else
							Trunks[id].isOpen = false
						end
					end
				end
				secondInv.name = "trunk-"..id
				secondInv.label = "Trunk-"..id
				secondInv.maxweight = other.maxweight or 60000
				secondInv.inventory = {}
				secondInv.slots = other.slots or 50
				if (Trunks[id] and Trunks[id].isOpen) or (MRFW.Shared.SplitStr(id, "PLZI")[2] and Player.PlayerData.job.name ~= "police") then
					secondInv.name = "none-inv"
					secondInv.label = "Trunk-None"
					secondInv.maxweight = other.maxweight or 60000
					secondInv.inventory = {}
					secondInv.slots = 0
				else
					if id then
						local ownedItems = GetOwnedVehicleItems(id)
						if IsVehicleOwned(id) and next(ownedItems) then
							secondInv.inventory = ownedItems
							Trunks[id] = {}
							Trunks[id].items = ownedItems
							Trunks[id].isOpen = src
							Trunks[id].label = secondInv.label
						elseif Trunks[id] and not Trunks[id].isOpen then
							secondInv.inventory = Trunks[id].items
							Trunks[id].isOpen = src
							Trunks[id].label = secondInv.label
						else
							Trunks[id] = {}
							Trunks[id].items = {}
							Trunks[id].isOpen = src
							Trunks[id].label = secondInv.label
						end
					end
				end
			elseif name == "glovebox" then
				if Gloveboxes[id] then
					if Gloveboxes[id].isOpen then
						local Target = MRFW.Functions.GetPlayer(Gloveboxes[id].isOpen)
						if Target then
							TriggerClientEvent('inventory:client:CheckOpenState', Gloveboxes[id].isOpen, name, id, Gloveboxes[id].label)
						else
							Gloveboxes[id].isOpen = false
						end
					end
				end
				secondInv.name = "glovebox-"..id
				secondInv.label = "Glovebox-"..id
				secondInv.maxweight = 10000
				secondInv.inventory = {}
				secondInv.slots = 5
				if Gloveboxes[id] and Gloveboxes[id].isOpen then
					secondInv.name = "none-inv"
					secondInv.label = "Glovebox-None"
					secondInv.maxweight = 10000
					secondInv.inventory = {}
					secondInv.slots = 0
				else
					local ownedItems = GetOwnedVehicleGloveboxItems(id)
					if Gloveboxes[id] and not Gloveboxes[id].isOpen then
						secondInv.inventory = Gloveboxes[id].items
						Gloveboxes[id].isOpen = src
						Gloveboxes[id].label = secondInv.label
					elseif IsVehicleOwned(id) and next(ownedItems) then
						secondInv.inventory = ownedItems
						Gloveboxes[id] = {}
						Gloveboxes[id].items = ownedItems
						Gloveboxes[id].isOpen = src
						Gloveboxes[id].label = secondInv.label
					else
						Gloveboxes[id] = {}
						Gloveboxes[id].items = {}
						Gloveboxes[id].isOpen = src
						Gloveboxes[id].label = secondInv.label
					end
				end
			elseif name == "shop" then
				secondInv.name = "itemshop-"..id
				secondInv.label = other.label
				secondInv.maxweight = 900000
				secondInv.inventory = SetupShopItems(id, other.items)
				ShopItems[id] = {}
				ShopItems[id].items = other.items
				secondInv.slots = #other.items
			elseif name == "traphouse" then
				secondInv.name = "traphouse-"..id
				secondInv.label = other.label
				secondInv.maxweight = 900000
				secondInv.inventory = other.items
				secondInv.slots = other.slots
			elseif name == "crafting" then
				secondInv.name = "crafting"
				secondInv.label = other.label
				secondInv.maxweight = 900000
				secondInv.inventory = other.items
				secondInv.slots = #other.items
			elseif name == "attachment_crafting" then
				secondInv.name = "attachment_crafting"
				secondInv.label = other.label
				secondInv.maxweight = 900000
				secondInv.inventory = other.items
				secondInv.slots = #other.items
			elseif name == "pasta_crafting" then
				secondInv.name = "pasta_crafting"
				secondInv.label = other.label
				secondInv.maxweight = 900000
				secondInv.inventory = other.items
				secondInv.slots = #other.items
			elseif name == "tea_crafting" then
				secondInv.name = "tea_crafting"
				secondInv.label = other.label
				secondInv.maxweight = 900000
				secondInv.inventory = other.items
				secondInv.slots = #other.items
			elseif name == "mcd_crafting" then
				secondInv.name = "mcd_crafting"
				secondInv.label = other.label
				secondInv.maxweight = 900000
				secondInv.inventory = other.items
				secondInv.slots = #other.items
			elseif name == "dhaba_crafting" then
				secondInv.name = "dhaba_crafting"
				secondInv.label = other.label
				secondInv.maxweight = 900000
				secondInv.inventory = other.items
				secondInv.slots = #other.items
			elseif name == "mech_crafting" then
				secondInv.name = "mech_crafting"
				secondInv.label = other.label
				secondInv.maxweight = 2000000
				secondInv.inventory = other.items
				secondInv.slots = #other.items
			elseif name == "otherplayer" then
				local OtherPlayer = MRFW.Functions.GetPlayer(tonumber(id))
				if OtherPlayer then
					secondInv.name = "otherplayer-"..id
					secondInv.label = "Player-"..id
					secondInv.maxweight = MRFW.Config.Player.MaxWeight
					secondInv.inventory = OtherPlayer.PlayerData.items
					if Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then
						secondInv.slots = MRFW.Config.Player.MaxInvSlots - 1
					else
						secondInv.slots = MRFW.Config.Player.MaxInvSlots - 1
					end
					Wait(250)
				end
			else
				if Drops[id] then
					if Drops[id].isOpen then
						local Target = MRFW.Functions.GetPlayer(Drops[id].isOpen)
						if Target then
							TriggerClientEvent('inventory:client:CheckOpenState', Drops[id].isOpen, name, id, Drops[id].label)
						else
							Drops[id].isOpen = false
						end
					end
				end
				if Drops[id] and not Drops[id].isOpen then
					secondInv.name = id
					secondInv.label = "Dropped-"..tostring(id)
					secondInv.maxweight = 100000
					secondInv.inventory = Drops[id].items
					secondInv.slots = 30
					Drops[id].isOpen = src
					Drops[id].label = secondInv.label
				else
					secondInv.name = "none-inv"
					secondInv.label = "Dropped-None"
					secondInv.maxweight = 100000
					secondInv.inventory = {}
					secondInv.slots = 0
				end
			end
			TriggerClientEvent("inventory:client:OpenInventory", src, {}, Player.PlayerData.items, secondInv)
		else
			TriggerClientEvent("inventory:client:OpenInventory", src, {}, Player.PlayerData.items)
		end
	else
		TriggerClientEvent('MRFW:Notify', src, 'Not Accessible', 'error')
	end
end)

RegisterNetEvent('inventory:server:SaveInventory', function(type, id)
	if type == "trunk" then
		if IsVehicleOwned(id) then
			SaveOwnedVehicleItems(id, Trunks[id].items)
		else
			Trunks[id].isOpen = false
		end
	elseif type == "glovebox" then
		if (IsVehicleOwned(id)) then
			SaveOwnedGloveboxItems(id, Gloveboxes[id].items)
		else
			Gloveboxes[id].isOpen = false
		end
	elseif type == "stash" then
		SaveStashItems(id, Stashes[id].items)
	elseif type == "drop" then
		if Drops[id] then
			Drops[id].isOpen = false
			if Drops[id].items == nil or next(Drops[id].items) == nil then
				Drops[id] = nil
				TriggerClientEvent("inventory:client:RemoveDropItem", -1, id)
			end
		end
	end
end)

RegisterNetEvent('inventory:server:UseItemSlot', function(slot)
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	local itemData = Player.Functions.GetItemBySlot(slot)
	if itemData then
		local itemInfo = MRFW.Shared.Items[itemData.name]
		if itemData.type == "weapon" then
			if itemData.info.quality then
				if itemData.info.quality > 0 then
					TriggerClientEvent("inventory:client:UseWeapon", src, itemData, true)
				else
					TriggerClientEvent("inventory:client:UseWeapon", src, itemData, false)
				end
			else
				TriggerClientEvent("inventory:client:UseWeapon", src, itemData, true)
			end
			TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "use")
		elseif itemData.useable then
			TriggerClientEvent("MRFW:Client:UseItem", src, itemData)
			TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "use")
		end
	end
end)

RegisterNetEvent('inventory:server:UseItem', function(inventory, item)
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	if inventory == "player" or inventory == "hotbar" then
		local itemData = Player.Functions.GetItemBySlot(item.slot)
		if itemData then
			TriggerClientEvent("MRFW:Client:UseItem", src, itemData)
		end
	end
end)

RegisterNetEvent('inventory:server:SetInventoryData', function(fromInventory, toInventory, fromSlot, toSlot, fromAmount, toAmount)
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	fromSlot = tonumber(fromSlot)
	toSlot = tonumber(toSlot)

	if (fromInventory == "player" or fromInventory == "hotbar") and (MRFW.Shared.SplitStr(toInventory, "-")[1] == "itemshop" or toInventory == "crafting") then
		return
	end

	if fromInventory == "player" or fromInventory == "hotbar" then
		local fromItemData = Player.Functions.GetItemBySlot(fromSlot)
		local fromAmount = tonumber(fromAmount) ~= nil and tonumber(fromAmount) or fromItemData.amount
		if fromItemData ~= nil and fromItemData.amount >= fromAmount then
			if toInventory == "player" or toInventory == "hotbar" then
				local toItemData = Player.Functions.GetItemBySlot(toSlot)
				Player.Functions.RemoveItem(fromItemData.name, fromAmount, fromSlot)
				TriggerClientEvent("inventory:client:CheckWeapon", src, fromItemData.name)
				--Player.PlayerData.items[toSlot] = fromItemData
				if toItemData ~= nil then
					--Player.PlayerData.items[fromSlot] = toItemData
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						Player.Functions.RemoveItem(toItemData.name, toAmount, toSlot)
						Player.Functions.AddItem(toItemData.name, toAmount, fromSlot, toItemData.info)
					end
				else
					--Player.PlayerData.items[fromSlot] = nil
				end
				Player.Functions.AddItem(fromItemData.name, fromAmount, toSlot, fromItemData.info)
			elseif MRFW.Shared.SplitStr(toInventory, "-")[1] == "otherplayer" then
				local playerId = tonumber(MRFW.Shared.SplitStr(toInventory, "-")[2])
				local OtherPlayer = MRFW.Functions.GetPlayer(playerId)
				local toItemData = OtherPlayer.PlayerData.items[toSlot]
				Player.Functions.RemoveItem(fromItemData.name, fromAmount, fromSlot)
				TriggerClientEvent("inventory:client:CheckWeapon", src, fromItemData.name)
				--Player.PlayerData.items[toSlot] = fromItemData
				if toItemData ~= nil then
					--Player.PlayerData.items[fromSlot] = toItemData
					local itemInfo = MRFW.Shared.Items[toItemData.name:lower()]
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						OtherPlayer.Functions.RemoveItem(itemInfo["name"], toAmount, fromSlot)
						Player.Functions.AddItem(toItemData.name, toAmount, fromSlot, toItemData.info)
						TriggerEvent("mr-log:server:CreateLog", "robbing", "Swapped Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | *"..src.."*) swapped item; name: **"..itemInfo["name"].."**, amount: **" .. toAmount .. "** with name: **" .. fromItemData.name .. "**, amount: **" .. fromAmount.. "** with player: **".. GetPlayerName(OtherPlayer.PlayerData.source) .. "** (citizenid: *"..OtherPlayer.PlayerData.citizenid.."* | id: *"..OtherPlayer.PlayerData.source.."*)")
					end
				else
					local itemInfo = MRFW.Shared.Items[fromItemData.name:lower()]
					TriggerEvent("mr-log:server:CreateLog", "robbing", "Dropped Item", "red", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | *"..src.."*) dropped new item; name: **"..itemInfo["name"].."**, amount: **" .. fromAmount .. "** to player: **".. GetPlayerName(OtherPlayer.PlayerData.source) .. "** (citizenid: *"..OtherPlayer.PlayerData.citizenid.."* | id: *"..OtherPlayer.PlayerData.source.."*)")
				end
				local itemInfo = MRFW.Shared.Items[fromItemData.name:lower()]
				OtherPlayer.Functions.AddItem(itemInfo["name"], fromAmount, toSlot, fromItemData.info)
			elseif MRFW.Shared.SplitStr(toInventory, "-")[1] == "trunk" then
				local plate = MRFW.Shared.SplitStr(toInventory, "-")[2]
				local toItemData = Trunks[plate].items[toSlot]
				Player.Functions.RemoveItem(fromItemData.name, fromAmount, fromSlot)
				TriggerClientEvent("inventory:client:CheckWeapon", src, fromItemData.name)
				--Player.PlayerData.items[toSlot] = fromItemData
				if toItemData ~= nil then
					--Player.PlayerData.items[fromSlot] = toItemData
					local itemInfo = MRFW.Shared.Items[toItemData.name:lower()]
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						RemoveFromTrunk(plate, fromSlot, itemInfo["name"], toAmount)
						Player.Functions.AddItem(toItemData.name, toAmount, fromSlot, toItemData.info)
						TriggerEvent("mr-log:server:CreateLog", "trunk", "Swapped Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) swapped item; name: **"..itemInfo["name"].."**, amount: **" .. toAmount .. "** with name: **" .. fromItemData.name .. "**, amount: **" .. fromAmount .. "** - plate: *" .. plate .. "*")
					end
				else
					local itemInfo = MRFW.Shared.Items[fromItemData.name:lower()]
					TriggerEvent("mr-log:server:CreateLog", "trunk", "Dropped Item", "red", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) dropped new item; name: **"..itemInfo["name"].."**, amount: **" .. fromAmount .. "** - plate: *" .. plate .. "*")
				end
				local itemInfo = MRFW.Shared.Items[fromItemData.name:lower()]
				AddToTrunk(plate, toSlot, fromSlot, itemInfo["name"], fromAmount, fromItemData.info)
			elseif MRFW.Shared.SplitStr(toInventory, "-")[1] == "glovebox" then
				local plate = MRFW.Shared.SplitStr(toInventory, "-")[2]
				local toItemData = Gloveboxes[plate].items[toSlot]
				Player.Functions.RemoveItem(fromItemData.name, fromAmount, fromSlot)
				TriggerClientEvent("inventory:client:CheckWeapon", src, fromItemData.name)
				--Player.PlayerData.items[toSlot] = fromItemData
				if toItemData ~= nil then
					--Player.PlayerData.items[fromSlot] = toItemData
					local itemInfo = MRFW.Shared.Items[toItemData.name:lower()]
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						RemoveFromGlovebox(plate, fromSlot, itemInfo["name"], toAmount)
						Player.Functions.AddItem(toItemData.name, toAmount, fromSlot, toItemData.info)
						TriggerEvent("mr-log:server:CreateLog", "glovebox", "Swapped Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) swapped item; name: **"..itemInfo["name"].."**, amount: **" .. toAmount .. "** with name: **" .. fromItemData.name .. "**, amount: **" .. fromAmount .. "** - plate: *" .. plate .. "*")
					end
				else
					local itemInfo = MRFW.Shared.Items[fromItemData.name:lower()]
					TriggerEvent("mr-log:server:CreateLog", "glovebox", "Dropped Item", "red", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) dropped new item; name: **"..itemInfo["name"].."**, amount: **" .. fromAmount .. "** - plate: *" .. plate .. "*")
				end
				local itemInfo = MRFW.Shared.Items[fromItemData.name:lower()]
				AddToGlovebox(plate, toSlot, fromSlot, itemInfo["name"], fromAmount, fromItemData.info)
			elseif MRFW.Shared.SplitStr(toInventory, "-")[1] == "stash" then
				local stashId = MRFW.Shared.SplitStr(toInventory, "-")[2]
				local toItemData = Stashes[stashId].items[toSlot]
				if string.sub(stashId, 1, string.len("storage_bags")) == "storage_bags" then
					if fromItemData.name == 'bag' then
						TriggerClientEvent("MRFW:Notify", src, "You can't store bag in bag", "error", 5000)
					else
						Player.Functions.RemoveItem(fromItemData.name, fromAmount, fromSlot)
						TriggerClientEvent("inventory:client:CheckWeapon", src, fromItemData.name)
						--Player.PlayerData.items[toSlot] = fromItemData
						if toItemData ~= nil then
							--Player.PlayerData.items[fromSlot] = toItemData
							local itemInfo = MRFW.Shared.Items[toItemData.name:lower()]
							local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
							if toItemData.name ~= fromItemData.name then
								--RemoveFromStash(stashId, fromSlot, itemInfo["name"], toAmount)
								RemoveFromStash(stashId, toSlot, itemInfo["name"], toAmount)
								Player.Functions.AddItem(toItemData.name, toAmount, fromSlot, toItemData.info)
								TriggerEvent("mr-log:server:CreateLog", "stash", "Swapped Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) swapped item; name: **"..itemInfo["name"].."**, amount: **" .. toAmount .. "** with name: **" .. fromItemData.name .. "**, amount: **" .. fromAmount .. "** - stash: *" .. stashId .. "*",true)
							end
						else
							local itemInfo = MRFW.Shared.Items[fromItemData.name:lower()]
							TriggerEvent("mr-log:server:CreateLog", "stash", "Dropped Item", "red", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) dropped new item; name: **"..itemInfo["name"].."**, amount: **" .. fromAmount .. "** - stash: *" .. stashId .. "*")
						end
						local itemInfo = MRFW.Shared.Items[fromItemData.name:lower()]
						AddToStash(stashId, toSlot, fromSlot, itemInfo["name"], fromAmount, fromItemData.info)
					end
				else
					Player.Functions.RemoveItem(fromItemData.name, fromAmount, fromSlot)
					TriggerClientEvent("inventory:client:CheckWeapon", src, fromItemData.name)
					--Player.PlayerData.items[toSlot] = fromItemData
					if toItemData ~= nil then
						--Player.PlayerData.items[fromSlot] = toItemData
						local itemInfo = MRFW.Shared.Items[toItemData.name:lower()]
						local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
						if toItemData.name ~= fromItemData.name then
							--RemoveFromStash(stashId, fromSlot, itemInfo["name"], toAmount)
							RemoveFromStash(stashId, toSlot, itemInfo["name"], toAmount)
							Player.Functions.AddItem(toItemData.name, toAmount, fromSlot, toItemData.info)
							TriggerEvent("mr-log:server:CreateLog", "stash", "Swapped Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) swapped item; name: **"..itemInfo["name"].."**, amount: **" .. toAmount .. "** with name: **" .. fromItemData.name .. "**, amount: **" .. fromAmount .. "** - stash: *" .. stashId .. "*")
						end
					else
						local itemInfo = MRFW.Shared.Items[fromItemData.name:lower()]
						TriggerEvent("mr-log:server:CreateLog", "stash", "Dropped Item", "red", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) dropped new item; name: **"..itemInfo["name"].."**, amount: **" .. fromAmount .. "** - stash: *" .. stashId .. "*")
					end
					local itemInfo = MRFW.Shared.Items[fromItemData.name:lower()]
					AddToStash(stashId, toSlot, fromSlot, itemInfo["name"], fromAmount, fromItemData.info)
				end
				
			elseif MRFW.Shared.SplitStr(toInventory, "-")[1] == "traphouse" then
				-- Traphouse
				local traphouseId = MRFW.Shared.SplitStr(toInventory, "-")[2]
				local toItemData = exports['mr-traphouse']:GetInventoryData(traphouseId, toSlot)
				local IsItemValid = exports['mr-traphouse']:CanItemBeSaled(fromItemData.name:lower())
				if IsItemValid then
					Player.Functions.RemoveItem(fromItemData.name, fromAmount, fromSlot)
					TriggerClientEvent("inventory:client:CheckWeapon", src, fromItemData.name)
					if toItemData ~= nil then
						local itemInfo = MRFW.Shared.Items[toItemData.name:lower()]
						local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
						if toItemData.name ~= fromItemData.name then
							exports['mr-traphouse']:RemoveHouseItem(traphouseId, fromSlot, itemInfo["name"], toAmount)
							Player.Functions.AddItem(toItemData.name, toAmount, fromSlot, toItemData.info)
							TriggerEvent("mr-log:server:CreateLog", "traphouse", "Swapped Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) swapped item; name: **"..itemInfo["name"].."**, amount: **" .. toAmount .. "** with name: **" .. fromItemData.name .. "**, amount: **" .. fromAmount .. "** - traphouse: *" .. traphouseId .. "*")
						end
					else
						local itemInfo = MRFW.Shared.Items[fromItemData.name:lower()]
						TriggerEvent("mr-log:server:CreateLog", "traphouse", "Dropped Item", "red", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) dropped new item; name: **"..itemInfo["name"].."**, amount: **" .. fromAmount .. "** - traphouse: *" .. traphouseId .. "*")
					end
					local itemInfo = MRFW.Shared.Items[fromItemData.name:lower()]
					exports['mr-traphouse']:AddHouseItem(traphouseId, toSlot, itemInfo["name"], fromAmount, fromItemData.info, src)
				else
					TriggerClientEvent('MRFW:Notify', src, "You can\'t sell this item..", 'error')
				end
			else
				-- drop
				toInventory = tonumber(toInventory)
				if toInventory == nil or toInventory == 0 then
					CreateNewDrop(src, fromSlot, toSlot, fromAmount)
				else
					local toItemData = Drops[toInventory].items[toSlot]
					Player.Functions.RemoveItem(fromItemData.name, fromAmount, fromSlot)
					TriggerClientEvent("inventory:client:CheckWeapon", src, fromItemData.name)
					if toItemData ~= nil then
						local itemInfo = MRFW.Shared.Items[toItemData.name:lower()]
						local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
						if toItemData.name ~= fromItemData.name then
							Player.Functions.AddItem(toItemData.name, toAmount, fromSlot, toItemData.info)
							RemoveFromDrop(toInventory, fromSlot, itemInfo["name"], toAmount)
							TriggerEvent("mr-log:server:CreateLog", "drop", "Swapped Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) swapped item; name: **"..itemInfo["name"].."**, amount: **" .. toAmount .. "** with name: **" .. fromItemData.name .. "**, amount: **" .. fromAmount .. "** - dropid: *" .. toInventory .. "*")
						end
					else
						local itemInfo = MRFW.Shared.Items[fromItemData.name:lower()]
						TriggerEvent("mr-log:server:CreateLog", "drop", "Dropped Item", "red", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) dropped new item; name: **"..itemInfo["name"].."**, amount: **" .. fromAmount .. "** - dropid: *" .. toInventory .. "*")
					end
					local itemInfo = MRFW.Shared.Items[fromItemData.name:lower()]
					AddToDrop(toInventory, toSlot, itemInfo["name"], fromAmount, fromItemData.info)
					if itemInfo["name"] == "radio" then
						TriggerClientEvent('Radio.Set', src, false)
					end
				end
			end
		else
			TriggerClientEvent("MRFW:Notify", src, "You don\'t have this item!", "error")
		end
	elseif MRFW.Shared.SplitStr(fromInventory, "-")[1] == "otherplayer" then
		local playerId = tonumber(MRFW.Shared.SplitStr(fromInventory, "-")[2])
		local OtherPlayer = MRFW.Functions.GetPlayer(playerId)
		local fromItemData = OtherPlayer.PlayerData.items[fromSlot]
		local fromAmount = tonumber(fromAmount) ~= nil and tonumber(fromAmount) or fromItemData.amount
		if fromItemData ~= nil and fromItemData.amount >= fromAmount then
			local itemInfo = MRFW.Shared.Items[fromItemData.name:lower()]
			if toInventory == "player" or toInventory == "hotbar" then
				local toItemData = Player.Functions.GetItemBySlot(toSlot)
				OtherPlayer.Functions.RemoveItem(itemInfo["name"], fromAmount, fromSlot)
				TriggerClientEvent("inventory:client:CheckWeapon", OtherPlayer.PlayerData.source, fromItemData.name)
				if toItemData ~= nil then
					local itemInfo = MRFW.Shared.Items[toItemData.name:lower()]
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						Player.Functions.RemoveItem(toItemData.name, toAmount, toSlot)
						OtherPlayer.Functions.AddItem(itemInfo["name"], toAmount, fromSlot, toItemData.info)
						TriggerEvent("mr-log:server:CreateLog", "robbing", "Swapped Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) swapped item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** with item; **"..itemInfo["name"].."**, amount: **" .. toAmount .. "** from player: **".. GetPlayerName(OtherPlayer.PlayerData.source) .. "** (citizenid: *"..OtherPlayer.PlayerData.citizenid.."* | *"..OtherPlayer.PlayerData.source.."*)")
					end
				else
					TriggerEvent("mr-log:server:CreateLog", "robbing", "Retrieved Item", "green", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) took item; name: **"..fromItemData.name.."**, amount: **" .. fromAmount .. "** from player: **".. GetPlayerName(OtherPlayer.PlayerData.source) .. "** (citizenid: *"..OtherPlayer.PlayerData.citizenid.."* | *"..OtherPlayer.PlayerData.source.."*)")
				end
				Player.Functions.AddItem(fromItemData.name, fromAmount, toSlot, fromItemData.info)
			else
				local toItemData = OtherPlayer.PlayerData.items[toSlot]
				OtherPlayer.Functions.RemoveItem(itemInfo["name"], fromAmount, fromSlot)
				--Player.PlayerData.items[toSlot] = fromItemData
				if toItemData ~= nil then
					local itemInfo = MRFW.Shared.Items[toItemData.name:lower()]
					--Player.PlayerData.items[fromSlot] = toItemData
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						local itemInfo = MRFW.Shared.Items[toItemData.name:lower()]
						OtherPlayer.Functions.RemoveItem(itemInfo["name"], toAmount, toSlot)
						OtherPlayer.Functions.AddItem(itemInfo["name"], toAmount, fromSlot, toItemData.info)
					end
				else
					--Player.PlayerData.items[fromSlot] = nil
				end
				local itemInfo = MRFW.Shared.Items[fromItemData.name:lower()]
				OtherPlayer.Functions.AddItem(itemInfo["name"], fromAmount, toSlot, fromItemData.info)
			end
		else
			TriggerClientEvent("MRFW:Notify", src, "Item doesn\'t exist??", "error")
		end
	elseif MRFW.Shared.SplitStr(fromInventory, "-")[1] == "trunk" then
		local plate = MRFW.Shared.SplitStr(fromInventory, "-")[2]
		local fromItemData = Trunks[plate].items[fromSlot]
		local fromAmount = tonumber(fromAmount) ~= nil and tonumber(fromAmount) or fromItemData.amount
		if fromItemData ~= nil and fromItemData.amount >= fromAmount then
			local itemInfo = MRFW.Shared.Items[fromItemData.name:lower()]
			if toInventory == "player" or toInventory == "hotbar" then
				local toItemData = Player.Functions.GetItemBySlot(toSlot)
				RemoveFromTrunk(plate, fromSlot, itemInfo["name"], fromAmount)
				if toItemData ~= nil then
					local itemInfo = MRFW.Shared.Items[toItemData.name:lower()]
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						Player.Functions.RemoveItem(toItemData.name, toAmount, toSlot)
						AddToTrunk(plate, fromSlot, toSlot, itemInfo["name"], toAmount, toItemData.info)
						TriggerEvent("mr-log:server:CreateLog", "trunk", "Swapped Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) swapped item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** with item; name: **"..itemInfo["name"].."**, amount: **" .. toAmount .. "** plate: *" .. plate .. "*")
					else
						TriggerEvent("mr-log:server:CreateLog", "trunk", "Stacked Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) stacked item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** from plate: *" .. plate .. "*")
					end
				else
					TriggerEvent("mr-log:server:CreateLog", "trunk", "Received Item", "green", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) received item; name: **"..fromItemData.name.."**, amount: **" .. fromAmount.. "** plate: *" .. plate .. "*")
				end
				Player.Functions.AddItem(fromItemData.name, fromAmount, toSlot, fromItemData.info)
			else
				local toItemData = Trunks[plate].items[toSlot]
				RemoveFromTrunk(plate, fromSlot, itemInfo["name"], fromAmount)
				--Player.PlayerData.items[toSlot] = fromItemData
				if toItemData ~= nil then
					local itemInfo = MRFW.Shared.Items[toItemData.name:lower()]
					--Player.PlayerData.items[fromSlot] = toItemData
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						local itemInfo = MRFW.Shared.Items[toItemData.name:lower()]
						RemoveFromTrunk(plate, toSlot, itemInfo["name"], toAmount)
						AddToTrunk(plate, fromSlot, toSlot, itemInfo["name"], toAmount, toItemData.info)
					end
				else
					--Player.PlayerData.items[fromSlot] = nil
				end
				local itemInfo = MRFW.Shared.Items[fromItemData.name:lower()]
				AddToTrunk(plate, toSlot, fromSlot, itemInfo["name"], fromAmount, fromItemData.info)
			end
		else
			TriggerClientEvent("MRFW:Notify", src, "Item doesn\'t exist??", "error")
		end
	elseif MRFW.Shared.SplitStr(fromInventory, "-")[1] == "glovebox" then
		local plate = MRFW.Shared.SplitStr(fromInventory, "-")[2]
		local fromItemData = Gloveboxes[plate].items[fromSlot]
		local fromAmount = tonumber(fromAmount) ~= nil and tonumber(fromAmount) or fromItemData.amount
		if fromItemData ~= nil and fromItemData.amount >= fromAmount then
			local itemInfo = MRFW.Shared.Items[fromItemData.name:lower()]
			if toInventory == "player" or toInventory == "hotbar" then
				local toItemData = Player.Functions.GetItemBySlot(toSlot)
				RemoveFromGlovebox(plate, fromSlot, itemInfo["name"], fromAmount)
				if toItemData ~= nil then
					local itemInfo = MRFW.Shared.Items[toItemData.name:lower()]
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						Player.Functions.RemoveItem(toItemData.name, toAmount, toSlot)
						AddToGlovebox(plate, fromSlot, toSlot, itemInfo["name"], toAmount, toItemData.info)
						TriggerEvent("mr-log:server:CreateLog", "glovebox", "Swapped", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src..")* swapped item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** with item; name: **"..itemInfo["name"].."**, amount: **" .. toAmount .. "** plate: *" .. plate .. "*")
					else
						TriggerEvent("mr-log:server:CreateLog", "glovebox", "Stacked Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) stacked item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** from plate: *" .. plate .. "*")
					end
				else
					TriggerEvent("mr-log:server:CreateLog", "glovebox", "Received Item", "green", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) received item; name: **"..fromItemData.name.."**, amount: **" .. fromAmount.. "** plate: *" .. plate .. "*")
				end
				Player.Functions.AddItem(fromItemData.name, fromAmount, toSlot, fromItemData.info)
			else
				local toItemData = Gloveboxes[plate].items[toSlot]
				RemoveFromGlovebox(plate, fromSlot, itemInfo["name"], fromAmount)
				--Player.PlayerData.items[toSlot] = fromItemData
				if toItemData ~= nil then
					local itemInfo = MRFW.Shared.Items[toItemData.name:lower()]
					--Player.PlayerData.items[fromSlot] = toItemData
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						local itemInfo = MRFW.Shared.Items[toItemData.name:lower()]
						RemoveFromGlovebox(plate, toSlot, itemInfo["name"], toAmount)
						AddToGlovebox(plate, fromSlot, toSlot, itemInfo["name"], toAmount, toItemData.info)
					end
				else
					--Player.PlayerData.items[fromSlot] = nil
				end
				local itemInfo = MRFW.Shared.Items[fromItemData.name:lower()]
				AddToGlovebox(plate, toSlot, fromSlot, itemInfo["name"], fromAmount, fromItemData.info)
			end
		else
			TriggerClientEvent("MRFW:Notify", src, "Item doesn\'t exist??", "error")
		end
	elseif MRFW.Shared.SplitStr(fromInventory, "-")[1] == "stash" then
		local stashId = MRFW.Shared.SplitStr(fromInventory, "-")[2]
		local fromItemData = Stashes[stashId].items[fromSlot]
		local fromAmount = tonumber(fromAmount) ~= nil and tonumber(fromAmount) or fromItemData.amount
		if fromItemData ~= nil and fromItemData.amount >= fromAmount then
			local itemInfo = MRFW.Shared.Items[fromItemData.name:lower()]
			if toInventory == "player" or toInventory == "hotbar" then
				local toItemData = Player.Functions.GetItemBySlot(toSlot)
				RemoveFromStash(stashId, fromSlot, itemInfo["name"], fromAmount)
				if toItemData ~= nil then
					local itemInfo = MRFW.Shared.Items[toItemData.name:lower()]
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						Player.Functions.RemoveItem(toItemData.name, toAmount, toSlot)
						AddToStash(stashId, fromSlot, toSlot, itemInfo["name"], toAmount, toItemData.info)
						TriggerEvent("mr-log:server:CreateLog", "stash", "Swapped Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) swapped item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** with item; name: **"..fromItemData.name.."**, amount: **" .. fromAmount .. "** stash: *" .. stashId .. "*")
					else
						TriggerEvent("mr-log:server:CreateLog", "stash", "Stacked Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) stacked item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** from stash: *" .. stashId .. "*")
					end
				else
					TriggerEvent("mr-log:server:CreateLog", "stash", "Received Item", "green", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) received item; name: **"..fromItemData.name.."**, amount: **" .. fromAmount.. "** stash: *" .. stashId .. "*")
				end
				SaveStashItems(stashId, Stashes[stashId].items)
				Player.Functions.AddItem(fromItemData.name, fromAmount, toSlot, fromItemData.info)
			else
				local toItemData = Stashes[stashId].items[toSlot]
				RemoveFromStash(stashId, fromSlot, itemInfo["name"], fromAmount)
				--Player.PlayerData.items[toSlot] = fromItemData
				if toItemData ~= nil then
					local itemInfo = MRFW.Shared.Items[toItemData.name:lower()]
					--Player.PlayerData.items[fromSlot] = toItemData
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						local itemInfo = MRFW.Shared.Items[toItemData.name:lower()]
						RemoveFromStash(stashId, toSlot, itemInfo["name"], toAmount)
						AddToStash(stashId, fromSlot, toSlot, itemInfo["name"], toAmount, toItemData.info)
					end
				else
					--Player.PlayerData.items[fromSlot] = nil
				end
				local itemInfo = MRFW.Shared.Items[fromItemData.name:lower()]
				AddToStash(stashId, toSlot, fromSlot, itemInfo["name"], fromAmount, fromItemData.info)
			end
		else
			TriggerClientEvent("MRFW:Notify", src, "Item doesn\'t exist??", "error")
		end
	elseif MRFW.Shared.SplitStr(fromInventory, "-")[1] == "traphouse" then
		local traphouseId = MRFW.Shared.SplitStr(fromInventory, "-")[2]
		local fromItemData = exports['mr-traphouse']:GetInventoryData(traphouseId, fromSlot)
		local fromAmount = tonumber(fromAmount) ~= nil and tonumber(fromAmount) or fromItemData.amount
		if fromItemData ~= nil and fromItemData.amount >= fromAmount then
			local itemInfo = MRFW.Shared.Items[fromItemData.name:lower()]
			if toInventory == "player" or toInventory == "hotbar" then
				local toItemData = Player.Functions.GetItemBySlot(toSlot)
				exports['mr-traphouse']:RemoveHouseItem(traphouseId, fromSlot, itemInfo["name"], fromAmount)
				if toItemData ~= nil then
					local itemInfo = MRFW.Shared.Items[toItemData.name:lower()]
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						Player.Functions.RemoveItem(toItemData.name, toAmount, toSlot)
						exports['mr-traphouse']:AddHouseItem(traphouseId, fromSlot, itemInfo["name"], toAmount, toItemData.info, src)
						TriggerEvent("mr-log:server:CreateLog", "stash", "Swapped Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) swapped item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** with item; name: **"..fromItemData.name.."**, amount: **" .. fromAmount .. "** stash: *" .. traphouseId .. "*")
					else
						TriggerEvent("mr-log:server:CreateLog", "stash", "Stacked Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) stacked item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** from stash: *" .. traphouseId .. "*")
					end
				else
					TriggerEvent("mr-log:server:CreateLog", "stash", "Received Item", "green", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) received item; name: **"..fromItemData.name.."**, amount: **" .. fromAmount.. "** stash: *" .. traphouseId .. "*")
				end
				Player.Functions.AddItem(fromItemData.name, fromAmount, toSlot, fromItemData.info)
			else
				local toItemData = exports['mr-traphouse']:GetInventoryData(traphouseId, toSlot)
				exports['mr-traphouse']:RemoveHouseItem(traphouseId, fromSlot, itemInfo["name"], fromAmount)
				if toItemData ~= nil then
					local itemInfo = MRFW.Shared.Items[toItemData.name:lower()]
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						local itemInfo = MRFW.Shared.Items[toItemData.name:lower()]
						exports['mr-traphouse']:RemoveHouseItem(traphouseId, toSlot, itemInfo["name"], toAmount)
						exports['mr-traphouse']:AddHouseItem(traphouseId, fromSlot, itemInfo["name"], toAmount, toItemData.info, src)
					end
				end
				local itemInfo = MRFW.Shared.Items[fromItemData.name:lower()]
				exports['mr-traphouse']:AddHouseItem(traphouseId, toSlot, itemInfo["name"], fromAmount, fromItemData.info, src)
			end
		else
			TriggerClientEvent("MRFW:Notify", src, "Item doesn't exist??", "error")
		end
	elseif MRFW.Shared.SplitStr(fromInventory, "-")[1] == "itemshop" then
		local shopType = MRFW.Shared.SplitStr(fromInventory, "-")[2]
		local itemData = ShopItems[shopType].items[fromSlot]
		local itemInfo = MRFW.Shared.Items[itemData.name:lower()]
		local bankBalance = Player.PlayerData.money["bank"]
		local price = tonumber((itemData.price*fromAmount))

		if MRFW.Shared.SplitStr(shopType, "_")[1] == "Dealer" then
			if MRFW.Shared.SplitStr(itemData.name, "_")[1] == "weapon" then
				price = tonumber(itemData.price)
				if Player.Functions.RemoveMoney("cash", price, "dealer-item-bought") then
					itemData.info.serie = tostring(MRFW.Shared.RandomInt(2) .. MRFW.Shared.RandomStr(3) .. MRFW.Shared.RandomInt(1) .. MRFW.Shared.RandomStr(2) .. MRFW.Shared.RandomInt(3) .. MRFW.Shared.RandomStr(4))
					Player.Functions.AddItem(itemData.name, 1, toSlot, itemData.info)
					TriggerClientEvent('mr-drugs:client:updateDealerItems', src, itemData, 1)
					TriggerClientEvent('MRFW:Notify', src, itemInfo["label"] .. " bought!", "success")
					TriggerEvent("mr-log:server:CreateLog", "dealers", "Dealer item bought", "green", "**"..GetPlayerName(src) .. "** bought a " .. itemInfo["label"] .. " for $"..price)
				else
					TriggerClientEvent('MRFW:Notify', src, "You don\'t have enough cash..", "error")
				end
			else
				if Player.Functions.RemoveMoney("cash", price, "dealer-item-bought") then
					Player.Functions.AddItem(itemData.name, fromAmount, toSlot, itemData.info)
					TriggerClientEvent('mr-drugs:client:updateDealerItems', src, itemData, fromAmount)
					TriggerClientEvent('MRFW:Notify', src, itemInfo["label"] .. " bought!", "success")
					TriggerEvent("mr-log:server:CreateLog", "dealers", "Dealer item bought", "green", "**"..GetPlayerName(src) .. "** bought a " .. itemInfo["label"] .. "  for $"..price)
				else
					TriggerClientEvent('MRFW:Notify', src, "You don't have enough cash..", "error")
				end
			end
		elseif MRFW.Shared.SplitStr(shopType, "_")[1] == "Itemshop" then
			if Player.Functions.RemoveMoney("cash", price, "itemshop-bought-item") then
                if MRFW.Shared.SplitStr(itemData.name, "_")[1] == "weapon" then
                    itemData.info.serie = tostring(MRFW.Shared.RandomInt(2) .. MRFW.Shared.RandomStr(3) .. MRFW.Shared.RandomInt(1) .. MRFW.Shared.RandomStr(2) .. MRFW.Shared.RandomInt(3) .. MRFW.Shared.RandomStr(4))
                end
				Player.Functions.AddItem(itemData.name, fromAmount, toSlot, itemData.info)
				TriggerClientEvent('mr-shops:client:UpdateShop', src, MRFW.Shared.SplitStr(shopType, "_")[2], itemData, fromAmount)
				TriggerClientEvent('MRFW:Notify', src, itemInfo["label"] .. " bought!", "success")
				TriggerEvent("mr-log:server:CreateLog", "shops", "Shop item bought", "green", "**"..GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | *"..src.."*) bought " .. itemInfo["label"] .. "**, amount: **" .. fromAmount .. " for $"..price)
				if Player.PlayerData.job.name == "police" then
					TriggerEvent("mr-log:server:CreateLog", "shopspolice", "Police Armory", "green", "**"..GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | *"..src.."*) bought " .. itemInfo["label"] .. "**, amount: **" .. fromAmount .. " for $"..price)
				end
				if Player.PlayerData.job.name == "doctor" then
					TriggerEvent("mr-log:server:CreateLog", "shopsdoc", "EMS Shop", "green", "**"..GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | *"..src.."*) bought " .. itemInfo["label"] .. "**, amount: **" .. fromAmount .. " for $"..price)
				end
				if Player.PlayerData.job.name == "government" then
					TriggerEvent("mr-log:server:CreateLog", "shopsgov", "Government Armory", "green", "**"..GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | *"..src.."*) bought " .. itemInfo["label"] .. "**, amount: **" .. fromAmount .. " for $"..price)
				end
			elseif bankBalance >= price then
				Player.Functions.RemoveMoney("bank", price, "itemshop-bought-item")
                if MRFW.Shared.SplitStr(itemData.name, "_")[1] == "weapon" then
                    itemData.info.serie = tostring(MRFW.Shared.RandomInt(2) .. MRFW.Shared.RandomStr(3) .. MRFW.Shared.RandomInt(1) .. MRFW.Shared.RandomStr(2) .. MRFW.Shared.RandomInt(3) .. MRFW.Shared.RandomStr(4))
                end
				Player.Functions.AddItem(itemData.name, fromAmount, toSlot, itemData.info)
				TriggerClientEvent('mr-shops:client:UpdateShop', src, MRFW.Shared.SplitStr(shopType, "_")[2], itemData, fromAmount)
				TriggerClientEvent('MRFW:Notify', src, itemInfo["label"] .. " bought!", "success")
				TriggerEvent("mr-log:server:CreateLog", "shops", "Shop item bought", "green", "**"..GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | *"..src.."*) bought " .. itemInfo["label"] .. "**, amount: **" .. fromAmount .. " for $"..price)
				if Player.PlayerData.job.name == "police" then
					TriggerEvent("mr-log:server:CreateLog", "shopspolice", "Police Armory", "green", "**"..GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | *"..src.."*) bought " .. itemInfo["label"] .. "**, amount: **" .. fromAmount .. " for $"..price)
				end
				if Player.PlayerData.job.name == "doctor" then
					TriggerEvent("mr-log:server:CreateLog", "shopsdoc", "EMS Shop", "green", "**"..GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | *"..src.."*) bought " .. itemInfo["label"] .. "**, amount: **" .. fromAmount .. " for $"..price)
				end
				if Player.PlayerData.job.name == "government" then
					TriggerEvent("mr-log:server:CreateLog", "shopsgov", "Government Armory", "green", "**"..GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | *"..src.."*) bought " .. itemInfo["label"] .. "**, amount: **" .. fromAmount .. " for $"..price)
				end
			else
				TriggerClientEvent('MRFW:Notify', src, "You don't have enough cash..", "error")
			end
		else
			if Player.Functions.RemoveMoney("cash", price, "unkown-itemshop-bought-item") then
				Player.Functions.AddItem(itemData.name, fromAmount, toSlot, itemData.info)
				TriggerClientEvent('MRFW:Notify', src, itemInfo["label"] .. " bought!", "success")
				if Player.PlayerData.job.name == "police" then
					TriggerEvent("mr-log:server:CreateLog", "shopspolice", "Police Armory", "green", "**"..GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | *"..src.."*) bought " .. itemInfo["label"] .. "**, amount: **" .. fromAmount .. " for $"..price)
				end
				if Player.PlayerData.job.name == "doctor" then
					TriggerEvent("mr-log:server:CreateLog", "shopsdoc", "EMS Shop", "green", "**"..GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | *"..src.."*) bought " .. itemInfo["label"] .. "**, amount: **" .. fromAmount .. " for $"..price)
				end
				if Player.PlayerData.job.name == "government" then
					TriggerEvent("mr-log:server:CreateLog", "shopsgov", "Government Armory", "green", "**"..GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | *"..src.."*) bought " .. itemInfo["label"] .. "**, amount: **" .. fromAmount .. " for $"..price)
				end
				TriggerEvent("mr-log:server:CreateLog", "shops", "Shop item bought", "green", "**"..GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | *"..src.."*) bought " .. itemInfo["label"] .. "**, amount: **" .. fromAmount .. " for $"..price)
			elseif bankBalance >= price then
				Player.Functions.RemoveMoney("bank", price, "unkown-itemshop-bought-item")
				Player.Functions.AddItem(itemData.name, fromAmount, toSlot, itemData.info)
				TriggerClientEvent('MRFW:Notify', src, itemInfo["label"] .. " bought!", "success")
				if Player.PlayerData.job.name == "police" then
					TriggerEvent("mr-log:server:CreateLog", "shopspolice", "Police Armory", "green", "**"..GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | *"..src.."*) bought " .. itemInfo["label"] .. "**, amount: **" .. fromAmount .. " for $"..price)
				end
				if Player.PlayerData.job.name == "doctor" then
					TriggerEvent("mr-log:server:CreateLog", "shopsdoc", "EMS Shop", "green", "**"..GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | *"..src.."*) bought " .. itemInfo["label"] .. "**, amount: **" .. fromAmount .. " for $"..price)
				end
				if Player.PlayerData.job.name == "government" then
					TriggerEvent("mr-log:server:CreateLog", "shopsgov", "Government Armory", "green", "**"..GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | *"..src.."*) bought " .. itemInfo["label"] .. "**, amount: **" .. fromAmount .. " for $"..price)
				end
				TriggerEvent("mr-log:server:CreateLog", "shops", "Shop item bought", "green", "**"..GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | *"..src.."*) bought " .. itemInfo["label"] .. "**, amount: **" .. fromAmount .. " for $"..price)
			else
				TriggerClientEvent('MRFW:Notify', src, "You don\'t have enough cash..", "error")
			end
		end
	elseif fromInventory == "crafting" then
		local itemData = Config.CraftingItems[fromSlot]
		if hasCraftItems(src, itemData.costs, fromAmount) then
			TriggerClientEvent("inventory:client:CraftItems", src, itemData.name, itemData.costs, fromAmount, toSlot, itemData.points)
		else
			TriggerClientEvent("inventory:client:UpdatePlayerInventory", src, true)
			TriggerClientEvent('MRFW:Notify', src, "You don't have the right items..", "error")
		end
	elseif fromInventory == "attachment_crafting" then
		local itemData = Config.AttachmentCrafting["items"][fromSlot]
		if hasCraftItems(src, itemData.costs, fromAmount) then
			TriggerClientEvent("inventory:client:CraftAttachment", src, itemData.name, itemData.costs, fromAmount, toSlot, itemData.points)
		else
			TriggerClientEvent("inventory:client:UpdatePlayerInventory", src, true)
			TriggerClientEvent('MRFW:Notify', src, "You don't have the right items..", "error")
		end
	elseif fromInventory == "pasta_crafting" then
		local itemData = Config.pastaItems[fromSlot]
		if hasCraftItems(src, itemData.costs, fromAmount) then
			TriggerClientEvent("inventory:client:pastaItems", src, itemData.name, itemData.costs, fromAmount, toSlot, itemData.points)
		else
			TriggerClientEvent("inventory:client:UpdatePlayerInventory", src, true)
			TriggerClientEvent('MRFW:Notify', src, "You don't have the right items..", "error")
		end
	elseif fromInventory == "tea_crafting" then
		local itemData = Config.teaItems[fromSlot]
		if hasCraftItems(src, itemData.costs, fromAmount) then
			TriggerClientEvent("inventory:client:teaItems", src, itemData.name, itemData.costs, fromAmount, toSlot, itemData.points)
		else
			TriggerClientEvent("inventory:client:UpdatePlayerInventory", src, true)
			TriggerClientEvent('MRFW:Notify', src, "You don't have the right items..", "error")
		end
	elseif fromInventory == "mcd_crafting" then
		local itemData = Config.mcdItems[fromSlot]
		if hasCraftItems(src, itemData.costs, fromAmount) then
			TriggerClientEvent("inventory:client:mcdItems", src, itemData.name, itemData.costs, fromAmount, toSlot, itemData.points)
		else
			TriggerClientEvent("inventory:client:UpdatePlayerInventory", src, true)
			TriggerClientEvent('MRFW:Notify', src, "You don't have the right items..", "error")
		end
	elseif fromInventory == "dhaba_crafting" then
		local itemData = Config.dhabaItems[fromSlot]
		if hasCraftItems(src, itemData.costs, fromAmount) then
			TriggerClientEvent("inventory:client:dhabaItems", src, itemData.name, itemData.costs, fromAmount, toSlot, itemData.points)
		else
			TriggerClientEvent("inventory:client:UpdatePlayerInventory", src, true)
			TriggerClientEvent('MRFW:Notify', src, "You don't have the right items..", "error")
		end
	elseif fromInventory == "mech_crafting" then
		local itemData = Config.mechItems[fromSlot]
		if hasCraftItems(src, itemData.costs, fromAmount) then
			TriggerClientEvent("inventory:client:mechItems", src, itemData.name, itemData.costs, fromAmount, toSlot, itemData.points)
		else
			TriggerClientEvent("inventory:client:UpdatePlayerInventory", src, true)
			TriggerClientEvent('MRFW:Notify', src, "You don't have the right items..", "error")
		end
	else
		-- drop
		fromInventory = tonumber(fromInventory)
		local fromItemData = Drops[fromInventory].items[fromSlot]
		local fromAmount = tonumber(fromAmount) ~= nil and tonumber(fromAmount) or fromItemData.amount
		if fromItemData ~= nil and fromItemData.amount >= fromAmount then
			local itemInfo = MRFW.Shared.Items[fromItemData.name:lower()]
			if toInventory == "player" or toInventory == "hotbar" then
				local toItemData = Player.Functions.GetItemBySlot(toSlot)
				RemoveFromDrop(fromInventory, fromSlot, itemInfo["name"], fromAmount)
				if toItemData ~= nil then
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						Player.Functions.RemoveItem(toItemData.name, toAmount, toSlot)
						AddToDrop(fromInventory, toSlot, itemInfo["name"], toAmount, toItemData.info)
						if itemInfo["name"] == "radio" then
							TriggerClientEvent('Radio.Set', src, false)
						end
						TriggerEvent("mr-log:server:CreateLog", "drop", "Swapped Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) swapped item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** with item; name: **"..fromItemData.name.."**, amount: **" .. fromAmount .. "** - dropid: *" .. fromInventory .. "*")
					else
						TriggerEvent("mr-log:server:CreateLog", "drop", "Stacked Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) stacked item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** - from dropid: *" .. fromInventory .. "*")
					end
				else
					TriggerEvent("mr-log:server:CreateLog", "drop", "Received Item", "green", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) received item; name: **"..fromItemData.name.."**, amount: **" .. fromAmount.. "** -  dropid: *" .. fromInventory .. "*")
				end
				Player.Functions.AddItem(fromItemData.name, fromAmount, toSlot, fromItemData.info)
			else
				toInventory = tonumber(toInventory)
				local toItemData = Drops[toInventory].items[toSlot]
				RemoveFromDrop(fromInventory, fromSlot, itemInfo["name"], fromAmount)
				--Player.PlayerData.items[toSlot] = fromItemData
				if toItemData ~= nil then
					local itemInfo = MRFW.Shared.Items[toItemData.name:lower()]
					--Player.PlayerData.items[fromSlot] = toItemData
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						local itemInfo = MRFW.Shared.Items[toItemData.name:lower()]
						RemoveFromDrop(toInventory, toSlot, itemInfo["name"], toAmount)
						AddToDrop(fromInventory, fromSlot, itemInfo["name"], toAmount, toItemData.info)
						if itemInfo["name"] == "radio" then
							TriggerClientEvent('Radio.Set', src, false)
						end
					end
				else
					--Player.PlayerData.items[fromSlot] = nil
				end
				local itemInfo = MRFW.Shared.Items[fromItemData.name:lower()]
				AddToDrop(toInventory, toSlot, itemInfo["name"], fromAmount, fromItemData.info)
				if itemInfo["name"] == "radio" then
					TriggerClientEvent('Radio.Set', src, false)
				end
			end
		else
			TriggerClientEvent("MRFW:Notify", src, "Item doesn't exist??", "error")
		end
	end
end)

RegisterNetEvent('mr-inventory:server:SaveStashItems', function(stashId, items)
    MySQL.Async.insert('INSERT INTO stashitems (stash, items) VALUES (:stash, :items) ON DUPLICATE KEY UPDATE items = :items', {
        ['stash'] = stashId,
        ['items'] = json.encode(items)
    })
end)

RegisterServerEvent("inventory:server:GiveItem", function(target, name, amount, slot)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    local OtherPlayer = MRFW.Functions.GetPlayer(tonumber(target))
    local dist = #(GetEntityCoords(GetPlayerPed(src))-GetEntityCoords(GetPlayerPed(target)))
	if Player == OtherPlayer then return TriggerClientEvent('MRFW:Notify', src, "You can't give yourself an item?") end
	if dist > 2 then return TriggerClientEvent('MRFW:Notify', src, "You are too far away to give items!") end
	local item = Player.Functions.GetItemBySlot(slot)
	if not item then TriggerClientEvent('MRFW:Notify', src, "Item you tried giving not found!"); return end
	if item.name ~= name then TriggerClientEvent('MRFW:Notify', src, "Incorrect item found try again!"); return end

	if amount <= item.amount then
		if amount == 0 then
			amount = item.amount
		end
		if Player.Functions.RemoveItem(item.name, amount, item.slot) then
			if OtherPlayer.Functions.AddItem(item.name, amount, false, item.info) then
				TriggerClientEvent('inventory:client:ItemBox',target, MRFW.Shared.Items[item.name], "add")
				TriggerClientEvent('MRFW:Notify', target, "You Received "..amount..' '..item.label.." From "..Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname)
				TriggerClientEvent("inventory:client:UpdatePlayerInventory", target, true)
				TriggerClientEvent('inventory:client:ItemBox',src, MRFW.Shared.Items[item.name], "remove")
				TriggerClientEvent('MRFW:Notify', src, "You gave " .. OtherPlayer.PlayerData.charinfo.firstname.." "..OtherPlayer.PlayerData.charinfo.lastname.. " " .. amount .. " " .. item.label .."!")
				TriggerClientEvent("inventory:client:UpdatePlayerInventory", src, true)
				TriggerClientEvent('mr-inventory:client:giveAnim', src)
				TriggerClientEvent('mr-inventory:client:giveAnim', target)
			else
				Player.Functions.AddItem(item.name, amount, item.slot, item.info)
				TriggerClientEvent('MRFW:Notify', src,  "The other players inventory is full!", "error")
				TriggerClientEvent('MRFW:Notify', target,  "Your inventory is full!", "error")
				TriggerClientEvent("inventory:client:UpdatePlayerInventory", src, false)
				TriggerClientEvent("inventory:client:UpdatePlayerInventory", target, false)
			end
		else
			TriggerClientEvent('MRFW:Notify', src,  "You do not have enough of the item", "error")
		end
	else
		TriggerClientEvent('MRFW:Notify', src, "You do not have enough items to transfer")
	end
end)

-- callback

MRFW.Functions.CreateCallback('mr-inventory:server:GetStashItems', function(source, cb, stashId)
	cb(GetStashItems(stashId))
end)

-- command

MRFW.Commands.Add("resetinv", "Reset Inventory (Admin Only)", {{name="type", help="stash/trunk/glovebox"},{name="id/plate", help="ID of stash or license plate"}}, true, function(source, args)
	local invType = args[1]:lower()
	table.remove(args, 1)
	local invId = table.concat(args, " ")
	if invType ~= nil and invId ~= nil then
		if invType == "trunk" then
			if Trunks[invId] ~= nil then
				Trunks[invId].isOpen = false
			end
		elseif invType == "glovebox" then
			if Gloveboxes[invId] ~= nil then
				Gloveboxes[invId].isOpen = false
			end
		elseif invType == "stash" then
			if Stashes[invId] ~= nil then
				Stashes[invId].isOpen = false
			end
		else
			TriggerClientEvent('MRFW:Notify', source,  "Not a valid type..", "error")
		end
	else
		TriggerClientEvent('MRFW:Notify', source,  "Arguments not filled out correctly..", "error")
	end
end, "h-admin")

MRFW.Commands.Add("rob", "Rob Player", {}, false, function(source, args)
	TriggerClientEvent("police:client:RobPlayer", source)
end)

MRFW.Commands.Add("giveitem", "Give An Item (Admin Only)", {{name="id", help="Player ID"},{name="item", help="Name of the item (not a label)"}, {name="amount", help="Amount of items"}}, true, function(source, args)
	local Player = MRFW.Functions.GetPlayer(tonumber(args[1]))
	local amount = tonumber(args[3])
	local itemData = MRFW.Shared.Items[tostring(args[2]):lower()]
	if Player then
		if amount > 0 then
			if itemData then
				-- check iteminfo
				local info = {}
				if itemData["name"] == "id_card" then
					info.citizenid = Player.PlayerData.citizenid
					info.firstname = Player.PlayerData.charinfo.firstname
					info.lastname = Player.PlayerData.charinfo.lastname
					info.birthdate = Player.PlayerData.charinfo.birthdate
					info.gender = Player.PlayerData.charinfo.gender
					info.nationality = Player.PlayerData.charinfo.nationality
				elseif itemData["name"] == "driver_license" then
					info.firstname = Player.PlayerData.charinfo.firstname
					info.lastname = Player.PlayerData.charinfo.lastname
					info.birthdate = Player.PlayerData.charinfo.birthdate
					info.type = "Class C Driver License"
				elseif itemData["type"] == "weapon" then
					amount = 1
					info.serie = tostring(MRFW.Shared.RandomInt(2) .. MRFW.Shared.RandomStr(3) .. MRFW.Shared.RandomInt(1) .. MRFW.Shared.RandomStr(2) .. MRFW.Shared.RandomInt(3) .. MRFW.Shared.RandomStr(4))
				elseif itemData["name"] == "harness" then
					info.uses = 20
				elseif itemData["name"] == "markedbills" then
					info.worth = math.random(5000, 10000)
				elseif itemData["name"] == "labkey" then
					info.lab = exports["mr-methlab"]:GenerateRandomLab()
				elseif itemData["name"] == "printerdocument" then
					info.url = "https://cdn.discordapp.com/attachments/870094209783308299/870104331142189126/Logo_-_Display_Picture_-_Stylized_-_Red.png"
				elseif itemData["name"] == "weapon_patrolcan" then
					info.ammo = 4000
					info.uses = 100
				end

				if Player.Functions.AddItem(itemData["name"], amount, false, info) then
					TriggerClientEvent('MRFW:Notify', source, "You Have Given " ..GetPlayerName(tonumber(args[1])).." "..amount.." "..itemData["name"].. "", "success")
				else
					TriggerClientEvent('MRFW:Notify', source,  "Can't give item!", "error")
				end
			else
				TriggerClientEvent('MRFW:Notify', source,  "Item Does Not Exist", "error")
			end
		else
			TriggerClientEvent('MRFW:Notify', source,  "Invalid Amount", "error")
		end
	else
		TriggerClientEvent('MRFW:Notify', source,  "Player Is Not Online", "error")
	end
end, "dev")

MRFW.Commands.Add("randomitems", "Give Random Items (God Only)", {}, false, function(source, args)
	local Player = MRFW.Functions.GetPlayer(source)
	local filteredItems = {}
	for k, v in pairs(MRFW.Shared.Items) do
		if MRFW.Shared.Items[k]["type"] ~= "weapon" then
			filteredItems[#filteredItems+1] = v
		end
	end
	for i = 1, 10, 1 do
		local randitem = filteredItems[math.random(1, #filteredItems)]
		local amount = math.random(1, 10)
		if randitem["unique"] then
			amount = 1
		end
		if Player.Functions.AddItem(randitem["name"], amount) then
			TriggerClientEvent('inventory:client:ItemBox', source, MRFW.Shared.Items[randitem["name"]], 'add')
            Wait(500)
		end
	end
end, "owner")

-- item

MRFW.Functions.CreateUseableItem("snowball", function(source, item)
	local Player = MRFW.Functions.GetPlayer(source)
	local itemData = Player.Functions.GetItemBySlot(item.slot)
	if Player.Functions.GetItemBySlot(item.slot) then
        TriggerClientEvent("inventory:client:UseSnowball", source, itemData.amount)
    end
end)

MRFW.Functions.CreateUseableItem("wcard", function(source, item)
    -- local Player = MRFW.Functions.GetPlayer(source)
	-- if Player.Functions.GetItemBySlot(item.slot) ~= nil then
    --     TriggerClientEvent("inventory:client:showWCard", -1, source, Player.PlayerData.citizenid, item.info)
    -- end
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	local Players = MRFW.Functions.GetPlayers()
	local photo
	exports.oxmysql:execute('SELECT * FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
		for k,v in pairs(result) do
			photo = v.photo
		end
	end)
	Citizen.Wait(500)
	local gender = "Man"
	if item.info.gender == 1 then
		gender = "Woman"
	end
	local csn = item.info.citizenid
	local name = item.info.firstname
	local name2 = item.info.lastname
	local birth = 'Weazel News'
	local gender = gender
	local national = item.info.nationality
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
		for k,v in pairs(Players) do
			local ply = GetPlayerPed(src)
			local target = GetPlayerPed(v)
			local dist = #( GetEntityCoords(ply) - GetEntityCoords(target) )
			if dist < 3 then
				TriggerClientEvent('mr-idcard:client:Jobopen', v, csn, name, name2, birth, gender, national, photo)
			end
		end
		TriggerClientEvent('mr-idcard:client:Jobopen', src, csn, name, name2, birth, gender, national, photo)
	end	
end)

MRFW.Functions.CreateUseableItem("taxicard", function(source, item)
    -- local Player = MRFW.Functions.GetPlayer(source)
	-- if Player.Functions.GetItemBySlot(item.slot) ~= nil then
    --     TriggerClientEvent("inventory:client:showTaxiCard", -1, source, Player.PlayerData.citizenid, item.info)
    -- end
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	local Players = MRFW.Functions.GetPlayers()
	local photo
	exports.oxmysql:execute('SELECT * FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
		for k,v in pairs(result) do
			photo = v.photo
		end
	end)
	Citizen.Wait(500)
	local gender = "Man"
	if item.info.gender == 1 then
		gender = "Woman"
	end
	local csn = item.info.citizenid
	local name = item.info.firstname
	local name2 = item.info.lastname
	local birth = 'Taxi'
	local gender = gender
	local national = item.info.nationality
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
		for k,v in pairs(Players) do
			local ply = GetPlayerPed(src)
			local target = GetPlayerPed(v)
			local dist = #( GetEntityCoords(ply) - GetEntityCoords(target) )
			if dist < 3 then
				TriggerClientEvent('mr-idcard:client:Jobopen', v, csn, name, name2, birth, gender, national, photo)
			end
		end
		TriggerClientEvent('mr-idcard:client:Jobopen', src, csn, name, name2, birth, gender, national, photo)
	end	
end)

MRFW.Functions.CreateUseableItem("towcard", function(source, item)
    -- local Player = MRFW.Functions.GetPlayer(source)
	-- if Player.Functions.GetItemBySlot(item.slot) ~= nil then
    --     TriggerClientEvent("inventory:client:showTowCard", -1, source, Player.PlayerData.citizenid, item.info)
    -- end
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	local Players = MRFW.Functions.GetPlayers()
	local photo
	exports.oxmysql:execute('SELECT * FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
		for k,v in pairs(result) do
			photo = v.photo
		end
	end)
	Citizen.Wait(500)
	local gender = "Man"
	if item.info.gender == 1 then
		gender = "Woman"
	end
	local csn = item.info.citizenid
	local name = item.info.firstname
	local name2 = item.info.lastname
	local birth = 'Tow'
	local gender = gender
	local national = item.info.nationality
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
		for k,v in pairs(Players) do
			local ply = GetPlayerPed(src)
			local target = GetPlayerPed(v)
			local dist = #( GetEntityCoords(ply) - GetEntityCoords(target) )
			if dist < 3 then
				TriggerClientEvent('mr-idcard:client:Jobopen', v, csn, name, name2, birth, gender, national, photo)
			end
		end
		TriggerClientEvent('mr-idcard:client:Jobopen', src, csn, name, name2, birth, gender, national, photo)
	end	
end)

MRFW.Functions.CreateUseableItem("pocard", function(source, item)
    -- local Player = MRFW.Functions.GetPlayer(source)
	-- if Player.Functions.GetItemBySlot(item.slot) ~= nil then
    --     TriggerClientEvent("inventory:client:showPoCard", -1, source, Player.PlayerData.citizenid, item.info)
    -- end
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	local Players = MRFW.Functions.GetPlayers()
	local photo
	exports.oxmysql:execute('SELECT * FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
		for k,v in pairs(result) do
			photo = v.photo
		end
	end)
	Citizen.Wait(500)
	local gender = "Man"
	if item.info.gender == 1 then
		gender = "Woman"
	end
	local csn = item.info.citizenid
	local name = item.info.firstname
	local name2 = item.info.lastname
	local birth = 'Go Postal'
	local gender = gender
	local national = item.info.nationality
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
		for k,v in pairs(Players) do
			local ply = GetPlayerPed(src)
			local target = GetPlayerPed(v)
			local dist = #( GetEntityCoords(ply) - GetEntityCoords(target) )
			if dist < 3 then
				TriggerClientEvent('mr-idcard:client:Jobopen', v, csn, name, name2, birth, gender, national, photo)
			end
		end
		TriggerClientEvent('mr-idcard:client:Jobopen', src, csn, name, name2, birth, gender, national, photo)
	end	
end)

MRFW.Functions.CreateUseableItem("mcard", function(source, item)
    -- local Player = MRFW.Functions.GetPlayer(source)
	-- if Player.Functions.GetItemBySlot(item.slot) ~= nil then
    --     TriggerClientEvent("inventory:client:showMcard", -1, source, Player.PlayerData.citizenid, item.info)
    -- end
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	local Players = MRFW.Functions.GetPlayers()
	local photo
	exports.oxmysql:execute('SELECT * FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
		for k,v in pairs(result) do
			photo = v.photo
		end
	end)
	Citizen.Wait(500)
	local gender = "Man"
	if item.info.gender == 1 then
		gender = "Woman"
	end
	local csn = item.info.citizenid
	local name = item.info.firstname
	local name2 = item.info.lastname
	local birth = 'EMS'
	local gender = gender
	local national = item.info.nationality
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
		for k,v in pairs(Players) do
			local ply = GetPlayerPed(src)
			local target = GetPlayerPed(v)
			local dist = #( GetEntityCoords(ply) - GetEntityCoords(target) )
			if dist < 3 then
				TriggerClientEvent('mr-idcard:client:Jobopen', v, csn, name, name2, birth, gender, national, photo)
			end
		end
		TriggerClientEvent('mr-idcard:client:Jobopen', src, csn, name, name2, birth, gender, national, photo)
	end	
end)

MRFW.Functions.CreateUseableItem("mecard", function(source, item)
    -- local Player = MRFW.Functions.GetPlayer(source)
	-- if Player.Functions.GetItemBySlot(item.slot) ~= nil then
    --     TriggerClientEvent("inventory:client:showMecard", -1, source, Player.PlayerData.citizenid, item.info)
    -- end
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	local Players = MRFW.Functions.GetPlayers()
	local photo
	exports.oxmysql:execute('SELECT * FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
		for k,v in pairs(result) do
			photo = v.photo
		end
	end)
	Citizen.Wait(500)
	local gender = "Man"
	if item.info.gender == 1 then
		gender = "Woman"
	end
	local csn = item.info.citizenid
	local name = item.info.firstname
	local name2 = item.info.lastname
	local birth = 'Mechanic'
	local gender = gender
	local national = item.info.nationality
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
		for k,v in pairs(Players) do
			local ply = GetPlayerPed(src)
			local target = GetPlayerPed(v)
			local dist = #( GetEntityCoords(ply) - GetEntityCoords(target) )
			if dist < 3 then
				TriggerClientEvent('mr-idcard:client:Jobopen', v, csn, name, name2, birth, gender, national, photo)
			end
		end
		TriggerClientEvent('mr-idcard:client:Jobopen', src, csn, name, name2, birth, gender, national, photo)
	end	
end)

MRFW.Functions.CreateUseableItem("garbagecard", function(source, item)
    -- local Player = MRFW.Functions.GetPlayer(source)
	-- if Player.Functions.GetItemBySlot(item.slot) ~= nil then
    --     TriggerClientEvent("inventory:client:showGarbageCard", -1, source, Player.PlayerData.citizenid, item.info)
    -- end
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	local Players = MRFW.Functions.GetPlayers()
	local photo
	exports.oxmysql:execute('SELECT * FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
		for k,v in pairs(result) do
			photo = v.photo
		end
	end)
	Citizen.Wait(500)
	local gender = "Man"
	if item.info.gender == 1 then
		gender = "Woman"
	end
	local csn = item.info.citizenid
	local name = item.info.firstname
	local name2 = item.info.lastname
	local birth = 'Grabage'
	local gender = gender
	local national = item.info.nationality
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
		for k,v in pairs(Players) do
			local ply = GetPlayerPed(src)
			local target = GetPlayerPed(v)
			local dist = #( GetEntityCoords(ply) - GetEntityCoords(target) )
			if dist < 3 then
				TriggerClientEvent('mr-idcard:client:Jobopen', v, csn, name, name2, birth, gender, national, photo)
			end
		end
		TriggerClientEvent('mr-idcard:client:Jobopen', src, csn, name, name2, birth, gender, national, photo)
	end	
end)

MRFW.Functions.CreateUseableItem("realestatecard", function(source, item)
    -- local Player = MRFW.Functions.GetPlayer(source)
	-- if Player.Functions.GetItemBySlot(item.slot) ~= nil then
    --     TriggerClientEvent("inventory:client:showrealestateCard", -1, source, Player.PlayerData.citizenid, item.info)
    -- end
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	local Players = MRFW.Functions.GetPlayers()
	local photo
	exports.oxmysql:execute('SELECT * FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
		for k,v in pairs(result) do
			photo = v.photo
		end
	end)
	Citizen.Wait(500)
	local gender = "Man"
	if item.info.gender == 1 then
		gender = "Woman"
	end
	local csn = item.info.citizenid
	local name = item.info.firstname
	local name2 = item.info.lastname
	local birth = 'Real Estate'
	local gender = gender
	local national = item.info.nationality
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
		for k,v in pairs(Players) do
			local ply = GetPlayerPed(src)
			local target = GetPlayerPed(v)
			local dist = #( GetEntityCoords(ply) - GetEntityCoords(target) )
			if dist < 3 then
				TriggerClientEvent('mr-idcard:client:Jobopen', v, csn, name, name2, birth, gender, national, photo)
			end
		end
		TriggerClientEvent('mr-idcard:client:Jobopen', src, csn, name, name2, birth, gender, national, photo)
	end	
end)

MRFW.Functions.CreateUseableItem("governmentcard", function(source, item)
    -- local Player = MRFW.Functions.GetPlayer(source)
	-- if Player.Functions.GetItemBySlot(item.slot) ~= nil then
    --     TriggerClientEvent("inventory:client:showgovernmentCard", -1, source, Player.PlayerData.citizenid, item.info)
    -- end
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	local Players = MRFW.Functions.GetPlayers()
	local photo
	exports.oxmysql:execute('SELECT * FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
		for k,v in pairs(result) do
			photo = v.photo
		end
	end)
	Citizen.Wait(500)
	local gender = "Man"
	if item.info.gender == 1 then
		gender = "Woman"
	end
	local csn = item.info.citizenid
	local name = item.info.firstname
	local name2 = item.info.lastname
	local birth = 'Government'
	local gender = gender
	local national = item.info.nationality
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
		for k,v in pairs(Players) do
			local ply = GetPlayerPed(src)
			local target = GetPlayerPed(v)
			local dist = #( GetEntityCoords(ply) - GetEntityCoords(target) )
			if dist < 3 then
				TriggerClientEvent('mr-idcard:client:Jobopen', v, csn, name, name2, birth, gender, national, photo)
			end
		end
		TriggerClientEvent('mr-idcard:client:Jobopen', src, csn, name, name2, birth, gender, national, photo)
	end	
end)

MRFW.Functions.CreateUseableItem("judgecard", function(source, item)
    -- local Player = MRFW.Functions.GetPlayer(source)
	-- if Player.Functions.GetItemBySlot(item.slot) ~= nil then
    --     TriggerClientEvent("inventory:client:showjudgeCard", -1, source, Player.PlayerData.citizenid, item.info)
    -- end
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	local Players = MRFW.Functions.GetPlayers()
	local photo
	exports.oxmysql:execute('SELECT * FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
		for k,v in pairs(result) do
			photo = v.photo
		end
	end)
	Citizen.Wait(500)
	local gender = "Man"
	if item.info.gender == 1 then
		gender = "Woman"
	end
	local csn = item.info.citizenid
	local name = item.info.firstname
	local name2 = item.info.lastname
	local birth = 'Judge'
	local gender = gender
	local national = item.info.nationality
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
		for k,v in pairs(Players) do
			local ply = GetPlayerPed(src)
			local target = GetPlayerPed(v)
			local dist = #( GetEntityCoords(ply) - GetEntityCoords(target) )
			if dist < 3 then
				TriggerClientEvent('mr-idcard:client:Jobopen', v, csn, name, name2, birth, gender, national, photo)
			end
		end
		TriggerClientEvent('mr-idcard:client:Jobopen', src, csn, name, name2, birth, gender, national, photo)
	end	
end)

MRFW.Functions.CreateUseableItem("mayorcard", function(source, item)
    -- local Player = MRFW.Functions.GetPlayer(source)
	-- if Player.Functions.GetItemBySlot(item.slot) ~= nil then
    --     TriggerClientEvent("inventory:client:showmayorCard", -1, source, Player.PlayerData.citizenid, item.info)
    -- end
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	local Players = MRFW.Functions.GetPlayers()
	local photo
	exports.oxmysql:execute('SELECT * FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
		for k,v in pairs(result) do
			photo = v.photo
		end
	end)
	Citizen.Wait(500)
	local gender = "Man"
	if item.info.gender == 1 then
		gender = "Woman"
	end
	local csn = item.info.citizenid
	local name = item.info.firstname
	local name2 = item.info.lastname
	local birth = 'Mayor'
	local gender = gender
	local national = item.info.nationality
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
		for k,v in pairs(Players) do
			local ply = GetPlayerPed(src)
			local target = GetPlayerPed(v)
			local dist = #( GetEntityCoords(ply) - GetEntityCoords(target) )
			if dist < 3 then
				TriggerClientEvent('mr-idcard:client:Jobopen', v, csn, name, name2, birth, gender, national, photo)
			end
		end
		TriggerClientEvent('mr-idcard:client:Jobopen', src, csn, name, name2, birth, gender, national, photo)
	end	
end)

MRFW.Functions.CreateUseableItem("businesscard", function(source, item)
    -- local Player = MRFW.Functions.GetPlayer(source)
	-- if Player.Functions.GetItemBySlot(item.slot) ~= nil then
    --     TriggerClientEvent("inventory:client:ShowbusinessLicense", -1, source, Player.PlayerData.citizenid, item.info)
    -- end
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	local Players = MRFW.Functions.GetPlayers()
	local photo
	exports.oxmysql:execute('SELECT * FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
		for k,v in pairs(result) do
			photo = v.photo
		end
	end)
	Citizen.Wait(500)
	local gender = "Man"
	if item.info.gender == 1 then
		gender = "Woman"
	end
	local csn = item.info.citizenid
	local name = item.info.firstname
	local name2 = item.info.lastname
	local birth = 'Business Owner'
	local gender = gender
	local national = item.info.nationality
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
		for k,v in pairs(Players) do
			local ply = GetPlayerPed(src)
			local target = GetPlayerPed(v)
			local dist = #( GetEntityCoords(ply) - GetEntityCoords(target) )
			if dist < 3 then
				TriggerClientEvent('mr-idcard:client:Jobopen', v, csn, name, name2, birth, gender, national, photo)
			end
		end
		TriggerClientEvent('mr-idcard:client:Jobopen', src, csn, name, name2, birth, gender, national, photo)
	end	
end)

MRFW.Functions.CreateUseableItem("employeecard", function(source, item)
    -- local Player = MRFW.Functions.GetPlayer(source)
	-- if Player.Functions.GetItemBySlot(item.slot) ~= nil then
    --     TriggerClientEvent("inventory:client:Showemployeecard", -1, source, Player.PlayerData.citizenid, item.info)
    -- end
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	local Players = MRFW.Functions.GetPlayers()
	local photo
	exports.oxmysql:execute('SELECT * FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
		for k,v in pairs(result) do
			photo = v.photo
		end
	end)
	Citizen.Wait(500)
	local gender = "Man"
	if item.info.gender == 1 then
		gender = "Woman"
	end
	local csn = item.info.citizenid
	local name = item.info.firstname
	local name2 = item.info.lastname
	local birth = 'Employee'
	local gender = gender
	local national = item.info.nationality
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
		for k,v in pairs(Players) do
			local ply = GetPlayerPed(src)
			local target = GetPlayerPed(v)
			local dist = #( GetEntityCoords(ply) - GetEntityCoords(target) )
			if dist < 3 then
				TriggerClientEvent('mr-idcard:client:Jobopen', v, csn, name, name2, birth, gender, national, photo)
			end
		end
		TriggerClientEvent('mr-idcard:client:Jobopen', src, csn, name, name2, birth, gender, national, photo)
	end	
end)

MRFW.Functions.CreateUseableItem("pcard", function(source, item)
    local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	local Players = MRFW.Functions.GetPlayers()
	local photo
	exports.oxmysql:execute('SELECT * FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
		for k,v in pairs(result) do
			photo = v.photo
		end
	end)
	Citizen.Wait(500)
	local gender = "Man"
	if item.info.gender == 1 then
		gender = "Woman"
	end
	local csn = item.info.citizenid
	local name = item.info.firstname
	local name2 = item.info.lastname
	local birth = 'Police Officer'
	local gender = gender
	local national = item.info.nationality
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
		for k,v in pairs(Players) do
			local ply = GetPlayerPed(src)
			local target = GetPlayerPed(v)
			local dist = #( GetEntityCoords(ply) - GetEntityCoords(target) )
			if dist < 3 then
				TriggerClientEvent('mr-idcard:client:Jobopen', v, csn, name, name2, birth, gender, national, photo)
			end
		end
		TriggerClientEvent('mr-idcard:client:Jobopen', src, csn, name, name2, birth, gender, national, photo)
	end	
end)

MRFW.Functions.CreateUseableItem("mwcard", function(source, item)
    local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	local Players = MRFW.Functions.GetPlayers()
	local photo
	exports.oxmysql:execute('SELECT * FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
		for k,v in pairs(result) do
			photo = v.photo
		end
	end)
	Citizen.Wait(500)
	local gender = "Man"
	if item.info.gender == 1 then
		gender = "Woman"
	end
	local csn = item.info.citizenid
	local name = item.info.firstname
	local name2 = item.info.lastname
	local birth = 'Merry Weather'
	local gender = gender
	local national = item.info.nationality
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
		for k,v in pairs(Players) do
			local ply = GetPlayerPed(src)
			local target = GetPlayerPed(v)
			local dist = #( GetEntityCoords(ply) - GetEntityCoords(target) )
			if dist < 3 then
				TriggerClientEvent('mr-idcard:client:Jobopen', v, csn, name, name2, birth, gender, national, photo)
			end
		end
		TriggerClientEvent('mr-idcard:client:Jobopen', src, csn, name, name2, birth, gender, national, photo)
	end	
end)

MRFW.Functions.CreateUseableItem("weaponlicense", function(source, item)
    -- local Player = MRFW.Functions.GetPlayer(source)
	-- if Player.Functions.GetItemBySlot(item.slot) ~= nil then
    --     TriggerClientEvent("inventory:client:showweaponlicense", -1, source, Player.PlayerData.citizenid, item.info)
    -- end
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	local Players = MRFW.Functions.GetPlayers()
	local photo
	exports.oxmysql:execute('SELECT * FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
		for k,v in pairs(result) do
			photo = v.photo
		end
	end)
	Citizen.Wait(500)
	local gender = "Man"
	if item.info.gender == 1 then
		gender = "Woman"
	end
	local csn = item.info.citizenid
	local name = item.info.firstname
	local name2 = item.info.lastname
	local birth = 'Weapon License'
	local gender = gender
	local national = item.info.nationality
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
		for k,v in pairs(Players) do
			local ply = GetPlayerPed(src)
			local target = GetPlayerPed(v)
			local dist = #( GetEntityCoords(ply) - GetEntityCoords(target) )
			if dist < 3 then
				TriggerClientEvent('mr-idcard:client:Weaponopen', v, csn, name, name2, birth, gender, national, photo)
			end
		end
		TriggerClientEvent('mr-idcard:client:Weaponopen', src, csn, name, name2, birth, gender, national, photo)
	end	
end)

MRFW.Functions.CreateUseableItem("dojcard", function(source, item)
    -- local Player = MRFW.Functions.GetPlayer(source)
	-- if Player.Functions.GetItemBySlot(item.slot) ~= nil then
    --     TriggerClientEvent("inventory:client:Showdojcard", -1, source, Player.PlayerData.citizenid, item.info)
    -- end
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	local Players = MRFW.Functions.GetPlayers()
	local photo
	exports.oxmysql:execute('SELECT * FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
		for k,v in pairs(result) do
			photo = v.photo
		end
	end)
	Citizen.Wait(500)
	local gender = "Man"
	if item.info.gender == 1 then
		gender = "Woman"
	end
	local csn = item.info.citizenid
	local name = item.info.firstname
	local name2 = item.info.lastname
	local birth = 'Doj'
	local gender = gender
	local national = item.info.nationality
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
		for k,v in pairs(Players) do
			local ply = GetPlayerPed(src)
			local target = GetPlayerPed(v)
			local dist = #( GetEntityCoords(ply) - GetEntityCoords(target) )
			if dist < 3 then
				TriggerClientEvent('mr-idcard:client:Jobopen', v, csn, name, name2, birth, gender, national, photo)
			end
		end
		TriggerClientEvent('mr-idcard:client:Jobopen', src, csn, name, name2, birth, gender, national, photo)
	end	
end)

MRFW.Functions.CreateUseableItem("petlicense", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("inventory:client:Showpetlicense", -1, source, Player.PlayerData.citizenid, item.info)
    end
end)


MRFW.Functions.CreateUseableItem("covidcert", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("inventory:client:showcovidcer", -1, source, Player.PlayerData.citizenid, item.info)
    end
end)

MRFW.Functions.CreateUseableItem("id_card", function(source, item)
	local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	local Players = MRFW.Functions.GetPlayers()
	local photo
	exports.oxmysql:execute('SELECT * FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
		for k,v in pairs(result) do
			photo = v.photo
		end
	end)
	Citizen.Wait(500)
	local gender = "Man"
	if item.info.gender == 1 then
		gender = "Woman"
	end
	local csn = item.info.citizenid
	local name = item.info.firstname
	local name2 = item.info.lastname
	local birth = item.info.birthdate
	local gender = gender
	local national = item.info.nationality
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
		for k,v in pairs(Players) do
			local ply = GetPlayerPed(src)
			local target = GetPlayerPed(v)
			local dist = #( GetEntityCoords(ply) - GetEntityCoords(target) )
			if dist < 3 then
				TriggerClientEvent('mr-idcard:client:open', v, csn, name, name2, birth, gender, national, photo)
			end
		end
		TriggerClientEvent('mr-idcard:client:open', src, csn, name, name2, birth, gender, national, photo)
	end
end)

MRFW.Functions.CreateUseableItem("driver_license", function(source, item)
    local src = source
	local Player = MRFW.Functions.GetPlayer(src)
	local Players = MRFW.Functions.GetPlayers()
	local photo
	exports.oxmysql:execute('SELECT * FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
		for k,v in pairs(result) do
			photo = v.photo
			-- print(photo)
		end
	end)
	Citizen.Wait(500)
	-- print(photo)
	local gender = "Man"
	if item.info.gender == 1 then
		gender = "Woman"
	end
	local csn = item.info.citizenid
	local name = item.info.firstname
	local name2 = item.info.lastname
	local birth = item.info.birthdate
	local gender = gender
	local national = item.info.nationality
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
		for k,v in pairs(Players) do
			local ply = GetPlayerPed(src)
			local target = GetPlayerPed(v)
			local dist = #( GetEntityCoords(ply) - GetEntityCoords(target) )
			if dist < 3 then
				TriggerClientEvent('mr-idcard:client:driveropen', v, csn, name, name2, birth, gender, national, photo)
			end
		end
		TriggerClientEvent('mr-idcard:client:driveropen', src, csn, name, name2, birth, gender, national, photo)
	end	
end)

MRFW.Functions.CreateUseableItem('bag', function(source,item)
	TriggerClientEvent('open:inventory:bag', source, item.info.unit)
end)

------------------------------------k9--------------------------------------------------

local function HasItem(list, item)

	for i = 1, #list do

		if item == list[i] then
			return true
		end
	end

	return false
end

AddEventHandler("inventory:server:SearchLocalVehicleInventory", function(plate, list, cb)
local trunk = Trunks[plate]
local glovebox = Gloveboxes[plate]
local result = false

if trunk ~= nil then
	for k, v in pairs(trunk.items) do
		local ITEM = trunk.items[k].name
		if HasItem(list, ITEM) then
			RESULT = true
		end
	end
else
	trunk = GetOwnedVehicleItems(plate)

	for k, v in pairs(trunk) do

		local ITEM = trunk[k].name
		if HasItem(list, ITEM) then
			RESULT = true
		end
	end

end

if glovebox ~= nil then
	for k, v in pairs(glovebox.items) do

		local ITEM = glovebox.items[k].name
		if HasItem(list, ITEM) then
			RESULT = true
		end
	end
else
	glovebox = GetOwnedVehicleGloveboxItems(plate)

	for k, v in pairs(glovebox) do
		local ITEM = glovebox[k].name
		if HasItem(list, ITEM) then
			RESULT = true
		end
	end
end
cb(RESULT)
end)


RegisterNetEvent("inventory:server:spawnOnGround", function(source, itemData, itemAmount) 
	local coords = GetEntityCoords(GetPlayerPed(source))
	local itemInfo = MRFW.Shared.Items[itemData.name:lower()]
	local dropId = CreateDropId()
	Drops[dropId] = {}
	Drops[dropId].items = {}

	Drops[dropId].items[1] = {
		name = itemInfo["name"],
		amount = itemAmount,
		info = itemData.info ~= nil and itemData.info or "",
		label = itemInfo["label"],
		description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
		weight = itemInfo["weight"],
		type = itemInfo["type"],
		unique = itemInfo["unique"],
		useable = itemInfo["useable"],
		image = itemInfo["image"],
		slot = 1,
		id = dropId,
	}
	local Ply = MRFW.Functions.GetPlayer(source)
	TriggerEvent("mr-log:server:CreateLog", "drop", "New Item Spawn as Drop", "red", "**".. GetPlayerName(source) .. "** (citizenid: *"..Ply.PlayerData.citizenid.."* | id: *"..source.."*) overflowed inventory into drop; name: **"..itemData.name.."**, amount: **" .. itemAmount .. "**")
	TriggerClientEvent("inventory:client:AddDropItem", -1, dropId, source, coords)
end)