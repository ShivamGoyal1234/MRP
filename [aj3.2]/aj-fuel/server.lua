AJFW = exports['ajfw']:GetCoreObject()

RegisterNetEvent("cc-fuel:server:pay", function(price,source) 
    local xPlayer = AJFW.Functions.GetPlayer(source)
	local amount = math.floor(price)

	if price > 0 then
		-- print("Removing cash for " .. source .. " amount " .. amount)
		xPlayer.Functions.RemoveMoney('cash', amount)
	end
end)
