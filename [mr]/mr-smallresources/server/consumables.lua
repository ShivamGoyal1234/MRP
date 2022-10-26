MRFW.Functions.CreateUseableItem("joint", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:UseJoint", source)
    end
end)
MRFW.Functions.CreateUseableItem("cigarette", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Usecigarette", source)
    end
end)
MRFW.Functions.CreateUseableItem("armor", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:UseArmor", source)
end)
MRFW.Functions.CreateUseableItem("armorplate", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:UseArmorplate", source)
end)
MRFW.Functions.CreateUseableItem("heavyarmor", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:UseHeavyArmor", source)
end)
MRFW.Functions.CreateUseableItem("parachute", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:UseParachute", source)
    end
end)
MRFW.Functions.CreateUseableItem("water_bottle", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Drink", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("vodka", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:DrinkAlcohol", source, item.name)
end)
MRFW.Functions.CreateUseableItem("beer", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:DrinkAlcoholbeer", source, item.name)
end)
MRFW.Functions.CreateUseableItem("whiskey", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:DrinkAlcoholwhiskey", source, item.name)
end)
MRFW.Functions.CreateUseableItem("coffee", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:DrinkCoffee", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("kurkakola", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Drinksoda", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("sandwich", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eatsandwich", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("twerks_candy", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eategobar", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("snikkel_candy", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eategobar", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("tosti", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eatsandwich", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("binoculars", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
    TriggerClientEvent("binoculars:Toggle", source)
end)
MRFW.Functions.CreateUseableItem("cokebaggy", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:Cokebaggy", source)
end)
MRFW.Functions.CreateUseableItem("crack_baggy", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:Crackbaggy", source)
end)
MRFW.Functions.CreateUseableItem("xtcbaggy", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:EcstasyBaggy", source)
end)
MRFW.Functions.CreateUseableItem("pillbox-coffee", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:DrinkCoffee", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("pillbox-sandwich", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eatsandwich", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("mcd-wrap", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eatsandwich", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("mcd-fries", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eatsandwich", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("mcd-desert", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eatcup", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("mcd-meal", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eat", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("chicken-meal", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eat", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("chicken-fries", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eatsandwich", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("hotdog", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eatsandwich", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("bahamsspecial", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:DrinkAlcoholchampagne", source, item.name)
end)
MRFW.Functions.CreateUseableItem("champagne", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:DrinkAlcoholchampagne", source, item.name)
end)
MRFW.Functions.CreateUseableItem("tequila", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:DrinkAlcoholflute", source, item.name)
end)
MRFW.Functions.CreateUseableItem("vine", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Drinkwine", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("wine", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Drinkwine", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("mcd-wrap-c", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eatsandwich", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("mcd-nuggets", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eatsandwich", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("mcd-chickenpop", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eatsandwich", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("mcd-icetea", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:DrinkCoffee", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("mcd-strawberry", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Drinkcup", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("mcd-mango", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Drinkcup", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("mcd-caramel", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Drinkcup", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("mcd-cappuccino", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:DrinkCoffee", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("mcd-iced", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Drinkcup", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("mcd-hchocolate", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Drinkcup", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("mcd-burger", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:EatBurger", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("chicken-burger", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:EatBurger", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("mcd-burger-c", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:EatBurger", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("monster", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:SDrink", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("redbull", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:SDrink", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("hi-tea", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:TeaDrink", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("oxy", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:UseOxy", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("weed_2og", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:MakeJoint", source)
end)
MRFW.Functions.CreateUseableItem("meth_pooch", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:MethPooch", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("acid", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Acideffect", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("paracetamol", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:paracetamol", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("aspirine", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:aspirine", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("disprin", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:disprin", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("heparin", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:heparin", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("ibuprofen", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:ibuprofen", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("tsoup", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:tsoup", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("msoup", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:msoup", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("rggol", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:rggol", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("belachi", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:belachi", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("gulabjamun", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:gulabjamun", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("paan", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:paan", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("rosogulla", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:rosogulla", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("cookedchicken", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:cookedchicken", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("pannermasala", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:pannermasala", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("chickenmasala", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:chickenmasala", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("chickenroll", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:chickenroll", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("brownbread", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:brownbread", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("naan", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:naan", source, item.name)
    end
end)

MRFW.Functions.CreateUseableItem("mushroom", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:mushroomkhao", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("pmushroom", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:pmushroomkhao", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("weed_skunk", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:MakesJoint", source)
end)
MRFW.Functions.CreateUseableItem("sjoint", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:UsesJoint", source)
    end
end)
MRFW.Functions.CreateUseableItem("mcd-maharaja", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:EatBurger", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("mcd-spicypaneer", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:EatBurger", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("mcd-egg", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:EatBurger", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("mcd-cola", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Drinksoda", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("combomeal", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:OpenMeal", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("chai", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:chai", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("tompasta", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eatbowl", source, item.name)
    end
end)

MRFW.Functions.CreateUseableItem("tea", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Drinkcup", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("cheesepasta", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eatbowl", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("cookies", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eatdonut", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("brownies", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eatdonut", source, item.name)
    end
end)

MRFW.Functions.CreateUseableItem("garlicbread", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:garlicbread", source, item.name)
    end
end)

MRFW.Functions.CreateUseableItem("hotchocolate", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Drinkcup", source, item.name)
    end
end)

MRFW.Functions.CreateUseableItem("coldcoffee", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Drinkcup", source, item.name)
    end
end)

MRFW.Functions.CreateUseableItem("donuts", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eatdonut", source, item.name)
    end
end)

MRFW.Functions.CreateUseableItem("icecream2", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eatbowl", source, item.name)
    end
end)

MRFW.Functions.CreateUseableItem("lassi", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Drinkcup", source, item.name)
    end
end)

MRFW.Functions.CreateUseableItem("nimbupani", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Drinkcup", source, item.name)
    end
end)

MRFW.Functions.CreateUseableItem("firework1", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
    TriggerClientEvent("fireworks:client:UseFirework", source, item.name, "proj_indep_firework")
end)
MRFW.Functions.CreateUseableItem("firework2", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
    TriggerClientEvent("fireworks:client:UseFirework", source, item.name, "proj_indep_firework_v2")
end)
MRFW.Functions.CreateUseableItem("firework3", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
    TriggerClientEvent("fireworks:client:UseFirework", source, item.name, "proj_xmas_firework")
end)
MRFW.Functions.CreateUseableItem("firework4", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
    TriggerClientEvent("fireworks:client:UseFirework", source, item.name, "scr_indep_fireworks")
end)

RegisterNetEvent("mr-smallresources:server:AddParachute", function(item)
    local src = source
    local Ply = MRFW.Functions.GetPlayer(src)
    -- Ply.Functions.AddItem("parachute", 1)
    local infos = {}
    infos.uses = item.info.uses - 1
    if infos.uses < 10 then
      infos.uses = 0
    end
    Ply.Functions.AddItem("parachute", 1, nil,infos)
end)

MRFW.Commands.Add("removevest", "Resets Vest (Police Only)", {}, false, function(source, args)
    local Player = MRFW.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("consumables:client:ResetArmor", source)
    else
        TriggerClientEvent('MRFW:Notify', source,  "For Emergency Service Only", "error")
    end
end, 'police')

MRFW.Commands.Add("resetparachute", "Resets Parachute", {}, false, function(source, args)
    local Player = MRFW.Functions.GetPlayer(source)
        TriggerClientEvent("consumables:client:ResetParachute", source)
end)


MRFW.Functions.CreateUseableItem("nightvision", function(source, item)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player ~= nil then
        TriggerClientEvent("consumables:client:useNightVision", src)
    end
end)

MRFW.Functions.CreateUseableItem("uwububbleteablueberry", function(source, item)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:uwububbleteablueberry", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("uwububbletearose", function(source, item)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:uwububbleteablueberry", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("uwububbleteamint", function(source, item)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:uwububbleteablueberry", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("uwupancake", function(source, item)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:EatPancakes", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("uwucupcake", function(source, item)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:EatCupcakes", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("uwuvanillasandy", function(source, item)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:uwuvanillasandy", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("uwuchocsandy", function(source, item)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:uwuchocsandy", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("uwubudhabowl", function(source, item)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:uwubudhabowl", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("uwusushi", function(source, item)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:EatPancakes", source, item.name)
    end
end)
MRFW.Functions.CreateUseableItem("uwumisosoup", function(source, item)
    local src = source
    local Player = MRFW.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:uwumisosoup", source, item.name)
    end
end)