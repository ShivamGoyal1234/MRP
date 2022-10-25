local AJFW = exports['ajfw']:GetCoreObject()

local PlayerData = {}
local Menu
local Categories
local Categories2

RegisterNetEvent('AJFW:Client:OnPlayerLoaded', function()
    PlayerData = AJFW.Functions.GetPlayerData()
end)

RegisterNetEvent('AJFW:Client:OnPlayerUnload', function()
    PlayerData = {}
end)

RegisterNetEvent('AJFW:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

RegisterNetEvent('aj-sdt:client:openStash', function()
    if PlayerData.job.name == 'shopone' and PlayerData.job.grade.level == 2 then
        TriggerEvent("inventory:client:SetCurrentStash", "SDrive_Through")
        TriggerServerEvent("inventory:server:OpenInventory", "stash", "SDrive_Through", {
            maxweight = 4000000,
            slots = 100,
        })
    else
        AJFW.Functions.Notify('You Don\'t have access', 'error', 3000)
    end
end)

RegisterNetEvent('aj-sdt:client:openMCDMENU3', function(data)
    local dialog = exports['aj-input']:ShowInput({
        header = 'ShopOne Menu',
        submitText = "Submit",
        inputs = {
            {
                type = 'number',
                isRequired = true,
                name = 'amount',
                text = 'Amount (<=5)'
            }
        }
    })
    if dialog then
        if not dialog.amount then return end
        if tonumber(dialog.amount) > 5 then AJFW.Functions.Notify('You can\'t purchase more than 5 '..data.data.label..' at 1 time', 'error', 3000) return end
        local hasitem = false
        local indx = 0
        local countitem = 0
        AJFW.Functions.TriggerCallback('aj-inventory:server:GetStashItems', function(StashItems)
            for k,v in pairs(StashItems) do
                if v.name == data.item then
                    hasitem = true
                    if v.amount >= tonumber(dialog.amount) then
                        countitem = v.amount
                        indx = k
                    end
                end
            end
            if hasitem and countitem >= tonumber(dialog.amount) then
                if (countitem - tonumber(dialog.amount)) <= 0 then
                    StashItems[indx] = nil
                else
                    countitem = (countitem - tonumber(dialog.amount))
                    StashItems[indx].amount = countitem
                end
                if AJFW.Functions.GetPlayerData().money.cash >= (tonumber(dialog.amount)*data.data.price) then
                    TriggerServerEvent('aj-sdt:server:purchaseItem', data, tonumber(dialog.amount), StashItems)
                else
                    AJFW.Functions.Notify('Please Bring Some Cash', 'error', 3000)
                end
            else
                AJFW.Functions.Notify('Sorry We Don\'t have enough stock please contact shopone staff', 'error')
            end
        end, "SDrive_Through")
    end
end)

RegisterNetEvent('aj-sdt:client:openMCDMENU', function(data)
    Categories2 = {
        {
            header = '< Go Back',
            params = {
                event = 'aj-sdt:client:openMenu'
            }
        }
    }
    for k,v in pairs(Config.Items) do
        Categories2[#Categories2 + 1] = {
            header = k,
            params = {
                event = 'aj-sdt:client:openMCDMENU2',
                args = k
            }
        }
    end
    exports['aj-menu']:openMenu(Categories2)
end)

RegisterNetEvent('aj-sdt:client:openMCDMENU2', function(menuu)
    Categories = {
        {
            header = '< Go Back',
            params = {
                event = 'aj-sdt:client:openMCDMENU'
            }
        }
    }
    for k,v in pairs(Config.Items[menuu]) do
        Categories[#Categories + 1] = {
            header = v.label,
            txt = '$'..v.price,
            params = {
                event = 'aj-sdt:client:openMCDMENU3',
                args = {
                    item = k,
                    data = v
                }
            }
        }
    end
    exports['aj-menu']:openMenu(Categories)
end)

RegisterNetEvent('aj-sdt:client:openMenu', function()
    Menu = {
        {
            isMenuHeader = true,
            header = 'ShopOne Menu',
        },
        {
            header = 'Storage',
            txt = 'Storage',
            params = {
                event = 'aj-sdt:client:openStash',
                args = {
                    typo = 'Storage',
                    type = 'test'
                }
            }
        },
        {
            header = "Menu",
            txt = 'See Some Delicious Food',
            params = {
                event = 'aj-sdt:client:openMCDMENU',
                args = {
                    typo = 'Menu',
                    type = 'test'
                }
            }
        },
    }
    exports['aj-menu']:openMenu(Menu)
end)