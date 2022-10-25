RegisterServerEvent('mr-log:server:CreateLog')
AddEventHandler('mr-log:server:CreateLog', function(name, title, color, message, tagEveryone, name2, icon)
    local tag = tagEveryone ~= nil and tagEveryone or false
    local webHook = Config.Webhooks[name] ~= nil and Config.Webhooks[name] or Config.Webhooks["default"]
    local embedData = {}
    if icon ~= nil and name2 ~= nil then
        embedData = {
            {
                ["title"] = title,
                ["color"] = Config.Colors[color] ~= nil and Config.Colors[color] or Config.Colors["default"],
                ["footer"] = {
                    ["text"] = os.date("%c"),
                },
                ["description"] = message,
                ["author"] = {
                    ["name"] = name2,
                    ["icon_url"] = icon,
                },
            }
        }
    elseif name2 ~= nil then
        embedData = {
            {
                ["title"] = title,
                ["color"] = Config.Colors[color] ~= nil and Config.Colors[color] or Config.Colors["default"],
                ["footer"] = {
                    ["text"] = os.date("%c"),
                },
                ["description"] = message,
                ["author"] = {
                ["name"] = name2,
                -- ["icon_url"] = "https://cdn.discordapp.com/attachments/755443626619699271/905476038430195773/aj_LOGO.png",
                    },
            }
        }
    elseif icon ~= nil then
        embedData = {
            {
                ["title"] = title,
                ["color"] = Config.Colors[color] ~= nil and Config.Colors[color] or Config.Colors["default"],
                ["footer"] = {
                    ["text"] = os.date("%c"),
                },
                ["description"] = message,
                ["author"] = {
                ["name"] = 'MRFW Logs',
                ["icon_url"] = icon,
                    },
            }
        }
    else
        embedData = {
            {
                ["title"] = title,
                ["color"] = Config.Colors[color] ~= nil and Config.Colors[color] or Config.Colors["default"],
                ["footer"] = {
                    ["text"] = os.date("%c"),
                },
                ["description"] = message,
                ["author"] = {
                ["name"] = 'MRFW Logs',
                -- ["icon_url"] = "https://cdn.discordapp.com/attachments/755443626619699271/905476038430195773/aj_LOGO.png",
                    },
            }
        }
    end
    PerformHttpRequest(webHook, function(err, text, headers) end, 'POST', json.encode({ username = "aj Logs",embeds = embedData}), { ['Content-Type'] = 'application/json' })
    Citizen.Wait(100)
    if tag then
        PerformHttpRequest(webHook, function(err, text, headers) end, 'POST', json.encode({ username = "aj Logs", content = "@everyone"}), { ['Content-Type'] = 'application/json' })
    end
end)

MRFW.Commands.Add("testwebhook", "Test Your Discord Webhook For Logs (God Only)", {}, false, function(source, args)
    TriggerEvent("mr-log:server:CreateLog", "default", "TestWebhook", "default", "Triggered **a** test webhook :)")
end, "dev")
