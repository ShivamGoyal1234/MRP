
AJFW.Commands.Add("setlawyer", "Set someone as a lawyer", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or Player.PlayerData.job.name == "Mayor" or  Player.PlayerData.job.name == "doj" and Player.PlayerData.job.grade.name == "Chief Justice" then
        if OtherPlayer ~= nil then
            local lawyerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
            OtherPlayer.Functions.SetJob("lawyer")
            OtherPlayer.Functions.AddItem("lawyerpass", 1, false, lawyerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have Hired as a lawyer")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "You are now a lawyer")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["lawyerpass"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,'government')

AJFW.Commands.Add("removelawyer", "Delete someone from lawyer", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or Player.PlayerData.job.grade.name == "Mayor" or  Player.PlayerData.job.name == "doj" and Player.PlayerData.job.grade.name == "Chief Justice" then
        if OtherPlayer ~= nil then
            --OtherPlayer.Functions.SetJob("unemployed")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "You are now unemployed")
            TriggerClientEvent("AJFW:Notify", source, "-".. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " , You are Fired as a lawyer")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,'government')

AJFW.Functions.CreateUseableItem("lawyerpass", function(source, item)
    local Player = AJFW.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("aj-justice:client:showLawyerLicense", -1, source, item.info)
    end
end)

AJFW.Commands.Add("mayorpass", "Give Mayor Pass", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or  Player.PlayerData.job.name == "doj" and Player.PlayerData.job.grade.name == "Chief Justice" then
        if OtherPlayer ~= nil then
            local playerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
           
            OtherPlayer.Functions.AddItem("mayorpass", 1, false, playerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received mayor pass.")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "Now you can meet mayor! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["mayorpass"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

AJFW.Commands.Add("mechanicid", "Give Mechanic ID", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or Player.PlayerData.job.grade.name == "Mayor" or Player.PlayerData.job.grade.name == "Secretery" or Player.PlayerData.job.grade.name == "Employee" then
        if OtherPlayer ~= nil then
            local playerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
           
            OtherPlayer.Functions.AddItem("mecard", 1, false, playerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["mecard"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

AJFW.Commands.Add("newsid", "Give Reporter ID", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or Player.PlayerData.job.grade.name == "Mayor" or Player.PlayerData.job.grade.name == "Secretery" or Player.PlayerData.job.grade.name == "Employee" then
        if OtherPlayer ~= nil then
            local playerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
           
            OtherPlayer.Functions.AddItem("wcard", 1, false, playerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["wcard"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

AJFW.Commands.Add("taxiid", "Give Taxi ID", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or Player.PlayerData.job.grade.name == "Mayor" or Player.PlayerData.job.grade.name == "Secretery" or Player.PlayerData.job.grade.name == "Employee" then
        if OtherPlayer ~= nil then
            local playerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
           
            OtherPlayer.Functions.AddItem("taxicard", 1, false, playerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["taxicard"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

AJFW.Commands.Add("towid", "Give Tow ID", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or Player.PlayerData.job.grade.name == "Mayor" or Player.PlayerData.job.grade.name == "Secretery" or Player.PlayerData.job.grade.name == "Employee" then
        if OtherPlayer ~= nil then
            local playerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
           
            OtherPlayer.Functions.AddItem("towcard", 1, false, playerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["towcard"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

AJFW.Commands.Add("poid", "Give Postal ID", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or Player.PlayerData.job.grade.name == "Mayor" or Player.PlayerData.job.grade.name == "Secretery" or Player.PlayerData.job.grade.name == "Employee" then
        if OtherPlayer ~= nil then
            local playerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
           
            OtherPlayer.Functions.AddItem("pocard", 1, false, playerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["pocard"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

AJFW.Commands.Add("idcard", "Give ID Card", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or Player.PlayerData.job.grade.name == "Mayor" or Player.PlayerData.job.grade.name == "Secretery" or Player.PlayerData.job.grade.name == "Employee" then
        if OtherPlayer ~= nil then
            local playerInfo = {
                citizenid = OtherPlayer.PlayerData.citizenid,
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                birthdate = OtherPlayer.PlayerData.charinfo.birthdate,
                gender = OtherPlayer.PlayerData.charinfo.gender,
                nationality = OtherPlayer.PlayerData.charinfo.nationality,
            }
           
            OtherPlayer.Functions.AddItem("id_card", 1, false, playerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received ID CARD.")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["id_card"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

AJFW.Commands.Add("policeid", "Give Police ID", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or Player.PlayerData.job.grade.name == "Mayor" or Player.PlayerData.job.grade.name == "Secretery" or Player.PlayerData.job.grade.name == "Employee" then
        if OtherPlayer ~= nil then
            local playerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                birthdate = OtherPlayer.PlayerData.charinfo.birthdate,
                gender = OtherPlayer.PlayerData.charinfo.gender,
                nationality = OtherPlayer.PlayerData.charinfo.nationality,
            }
           
            OtherPlayer.Functions.AddItem("pcard", 1, false, playerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["pcard"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

AJFW.Commands.Add("mwid", "Give Police ID", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or Player.PlayerData.job.grade.name == "Mayor" or Player.PlayerData.job.grade.name == "Secretery" or Player.PlayerData.job.grade.name == "Employee" then
        if OtherPlayer ~= nil then
            local playerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                birthdate = OtherPlayer.PlayerData.charinfo.birthdate,
                gender = OtherPlayer.PlayerData.charinfo.gender,
                nationality = OtherPlayer.PlayerData.charinfo.nationality,
            }
           
            OtherPlayer.Functions.AddItem("mwcard", 1, false, playerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["mwcard"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

-- AJFW.Commands.Add("idcard", "Give ID card", {{name="id", help="Player ID"}}, true, function(source, args)
--     local Player = AJFW.Functions.GetPlayer(source)
--     local playerId = tonumber(args[1])
--     local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
--     if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or Player.PlayerData.job.grade.name == "Mayor" or Player.PlayerData.job.grade.name == "Secretery" or Player.PlayerData.job.grade.name == "Employee" then
--         if OtherPlayer ~= nil then
--             local playerInfo = {
--                 id = math.random(100000, 999999),
--                 firstname = OtherPlayer.PlayerData.charinfo.firstname,
--                 lastname = OtherPlayer.PlayerData.charinfo.lastname,
--                 citizenid = OtherPlayer.PlayerData.citizenid,
--             }
           
--             OtherPlayer.Functions.AddItem("id_card", 1, false, playerInfo)
--             TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
--             TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["id_card"], "add")
--         else
--             TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
--         end
--     else
--         TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
--     end
-- end)

AJFW.Commands.Add("emsid", "Give EMS ID", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or Player.PlayerData.job.grade.name == "Mayor" or Player.PlayerData.job.grade.name == "Secretery" or Player.PlayerData.job.grade.name == "Employee" then
        if OtherPlayer ~= nil then
            local playerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
           
            OtherPlayer.Functions.AddItem("mcard", 1, false, playerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["mcard"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

AJFW.Commands.Add("garbageid", "Give Garbage ID", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or Player.PlayerData.job.grade.name == "Mayor" or Player.PlayerData.job.grade.name == "Secretery" or Player.PlayerData.job.grade.name == "Employee" then
        if OtherPlayer ~= nil then
            local playerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
           
            OtherPlayer.Functions.AddItem("garbagecard", 1, false, playerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["garbagecard"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,"government")


AJFW.Functions.CreateUseableItem("mayorpass", function(source, item)
    local Player = AJFW.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("aj-justice:client:showMayorPass", -1, source, item.info)
    end
end)


--Business

AJFW.Commands.Add("setbe", "Set Someone Bahamas Employee", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "bahamas" and Player.PlayerData.job.grade.name == "Owner" then
        if OtherPlayer ~= nil then
            local bahamasInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
            OtherPlayer.Functions.SetJob("bahamasemployee")

            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have Hired as a bahamas employee")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "You are now a bahamas employee")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end)

AJFW.Commands.Add("setce", "Set Someone Cinema Employee", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "cinema" and Player.PlayerData.job.grade.name == "Owner" then
        if OtherPlayer ~= nil then
            local cinemaInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
            OtherPlayer.Functions.SetJob("cinemaemployee")

            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have Hired as a cinema employee")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "You are now a cinema employee")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end)

AJFW.Commands.Add("setcce", "Set Someone Comedy Club Employee", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "comclub" and Player.PlayerData.job.grade.name == "Owner" then
        if OtherPlayer ~= nil then
            local cinemaInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
            OtherPlayer.Functions.SetJob("ccemployee")

            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have Hired as a Comedy Club employee")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "You are now a Comedy Club Employee")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end)

AJFW.Commands.Add("setmcde", "Set Someone MCD Employee", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "mcd" and Player.PlayerData.job.grade.name == "Owner" then
        if OtherPlayer ~= nil then
            local cinemaInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
            OtherPlayer.Functions.SetJob("mcdemployee")

            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have Hired as a MCD Employee")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "You are now a MCD Employee")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end)

AJFW.Commands.Add("setcse", "Set Someone Coffee Employee", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "coffee" and Player.PlayerData.job.grade.name == "Owner" then
        if OtherPlayer ~= nil then
            local cinemaInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
            OtherPlayer.Functions.SetJob("csemployee")

            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have Hired as a Coffee Employee")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "You are now a Coffee Employee")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end)


--cards

AJFW.Commands.Add("agentid", "Give Real Estate Agent ID", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or Player.PlayerData.job.grade.name == "Mayor" or Player.PlayerData.job.grade.name == "Secretery" then
        if OtherPlayer ~= nil then
            local playerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
           
            OtherPlayer.Functions.AddItem("realestatecard", 1, false, playerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["realestatecard"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

AJFW.Commands.Add("govid", "Give Government Employee ID", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or Player.PlayerData.job.grade.name == "Mayor" or Player.PlayerData.job.grade.name == "Secretery" then
        if OtherPlayer ~= nil then
            local playerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
           
            OtherPlayer.Functions.AddItem("governmentcard", 1, false, playerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["governmentcard"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

AJFW.Commands.Add("judgeid", "Give Judge ID", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or Player.PlayerData.job.grade.name == "Mayor" or Player.PlayerData.job.grade.name == "Secretery" then
        if OtherPlayer ~= nil then
            local playerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
           
            OtherPlayer.Functions.AddItem("judgecard", 1, false, playerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["judgecard"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

AJFW.Commands.Add("mayorid", "Give Mayor ID", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" then
        if OtherPlayer ~= nil then
            local playerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
           
            OtherPlayer.Functions.AddItem("mayorcard", 1, false, playerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["mayorcard"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

AJFW.Commands.Add("businesslic", "Give Business License", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or Player.PlayerData.job.grade.name == "Mayor" or Player.PlayerData.job.grade.name == "Secretery" then
        if OtherPlayer ~= nil then
            local playerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
           
            OtherPlayer.Functions.AddItem("businesscard", 1, false, playerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["businesscard"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

AJFW.Commands.Add("empid", "Give Employee ID", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or Player.PlayerData.job.grade.name == "Mayor" or Player.PlayerData.job.grade.name == "Secretery" then
        if OtherPlayer ~= nil then
            local playerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
           
            OtherPlayer.Functions.AddItem("employeecard", 1, false, playerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["employeecard"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

AJFW.Commands.Add("surgerypass", "Give Surgery Pass", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "doctor" and Player.PlayerData.job.grade.name == "EMS Chief" or Player.PlayerData.job.grade.name == "Deputy EMS Chief" or Player.PlayerData.job.grade.name == "Captain" or Player.PlayerData.job.grade.name == "Lieutenant" then
        if OtherPlayer ~= nil then
            local playerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
           
            OtherPlayer.Functions.AddItem("surgerypass", 1, false, playerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received Surgery Pass")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "Now You can go for Plastic Surgery ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["surgerypass"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end, "doctor")

AJFW.Commands.Add("weaponpass", "Give Weapon Pass", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "police" and Player.PlayerData.job.grade.name == "Commissioner" or Player.PlayerData.job.grade.name == "Chief" or Player.PlayerData.job.grade.name == "Deputy Commissioner" or Player.PlayerData.job.grade.name == "Assistant Commissioner" or Player.PlayerData.job.grade.name == "Captain" or Player.PlayerData.job.grade.name == "Lieutenant" or Player.PlayerData.job.grade.name == "Sergeant" or Player.PlayerData.job.grade.name == "Corporal" then
        if OtherPlayer ~= nil then
            local playerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                gender = OtherPlayer.PlayerData.charinfo.gender,
                citizenid = OtherPlayer.PlayerData.citizenid,
            }
           
            OtherPlayer.Functions.AddItem("weaponlicense", 1, false, playerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received Weapon Pass")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "Now You can go for Weapon Pass")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["weaponlicense"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,"police")

AJFW.Commands.Add("dojcard", "Give DOJ CARD", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or Player.PlayerData.job.name == "Mayor" or  Player.PlayerData.job.name == "doj" and Player.PlayerData.job.grade.name == "Chief Justice" then
        if OtherPlayer ~= nil then
            local playerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
           
            OtherPlayer.Functions.AddItem("dojcard", 1, false, playerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received DOJ CARD")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["dojcard"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,"government")


-- AJFW.Commands.Add("givepaper", "Give finance paper", {{name="id", help="Player ID"}}, true, function(source, args)
--     local Player = AJFW.Functions.GetPlayer(source)
--     local playerId = tonumber(args[1])
--     local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
--     if Player.PlayerData.job.name == "pdm" and Player.PlayerData.job.grade.name == "Owner" or Player.PlayerData.job.grade.name == "CEO" or Player.PlayerData.job.grade.name == "Salesman" or Player.PlayerData.job.grade.name == "Senior Salesman" or Player.PlayerData.job.grade.name == "Executive" or Player.PlayerData.job.grade.name == "Manager" then
--         if OtherPlayer ~= nil then
--             local playerInfo = {
--                 id = math.random(100000, 999999),
--                 firstname = OtherPlayer.PlayerData.charinfo.firstname,
--                 lastname = OtherPlayer.PlayerData.charinfo.lastname,
--                 citizenid = OtherPlayer.PlayerData.citizenid,
--             }
--             Player.Functions.RemoveMoney('bank', 1000, 'spawned Finance')
--             OtherPlayer.Functions.AddItem("financepaper", 1, false, playerInfo)
--             TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received Finance Paper")
--             TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "Now You can go for Finance Paper")
--             TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["financepaper"], "add")
--         else
--             TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
--         end
--     else
--         TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
--     end
-- end)

-- AJFW.Commands.Add("vehiclecard", "Give Vehicle Card", {{name="id", help="Player ID"}}, true, function(source, args)
--     local Player = AJFW.Functions.GetPlayer(source)
--     local playerId = tonumber(args[1])
--     local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
--     if Player.PlayerData.job.name == "pdm" and Player.PlayerData.job.grade.name == "Owner" or Player.PlayerData.job.grade.name == "CEO" or Player.PlayerData.job.grade.name == "Salesman" or Player.PlayerData.job.grade.name == "Senior Salesman" or Player.PlayerData.job.grade.name == "Executive" or Player.PlayerData.job.grade.name == "Manager" then
--         if OtherPlayer ~= nil then
--             local playerInfo = {
--                 id = math.random(100000, 999999),
--                 firstname = OtherPlayer.PlayerData.charinfo.firstname,
--                 lastname = OtherPlayer.PlayerData.charinfo.lastname,
--                 citizenid = OtherPlayer.PlayerData.citizenid,
--             }
           
--             OtherPlayer.Functions.AddItem("buycard", 1, false, playerInfo)
--             TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received Vehicle card")
--             TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "Now You can go for Purchasing Vehicle")
--             TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["buycard"], "add")
--         else
--             TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
--         end
--     else
--         TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
--     end
-- end)


-- AJFW.Commands.Add("givedocument", "Give housing paper", {{name="id", help="Player ID"}}, true, function(source, args)
--     local Player = AJFW.Functions.GetPlayer(source)
--     local playerId = tonumber(args[1])
--     local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
--     if Player.PlayerData.job.name == "realestate" and Player.PlayerData.job.grade.name == "Company Owner" then
--         if OtherPlayer ~= nil then
--             local playerInfo = {
--                 id = math.random(100000, 999999),
--                 firstname = OtherPlayer.PlayerData.charinfo.firstname,
--                 lastname = OtherPlayer.PlayerData.charinfo.lastname,
--                 citizenid = OtherPlayer.PlayerData.citizenid,
--             }
           
--             OtherPlayer.Functions.AddItem("housingpaper", 1, false, playerInfo)
--             TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received Housing Paper")
--             TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "Now You can go and buy your house")
--             TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["housingpaper"], "add")
--         else
--             TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
--         end
--     else
--         TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
--     end
-- end)

AJFW.Commands.Add("petlicense", "Give Pet Lic", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "police" then
        if OtherPlayer ~= nil then
            local playerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
           
            OtherPlayer.Functions.AddItem("petlicense", 1, false, playerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received Pet License")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "Now You can go for Pet License")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["petlicense"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,"police")

-----------------Vaccination
-- AJFW.Commands.Add("covidvac", "Give covid vaccine", {{name="id", help="Player ID"}}, true, function(source, args)
--     local Player = AJFW.Functions.GetPlayer(source)
--     local playerId = tonumber(args[1])
--     local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
--     if Player.Functions.GetItemByName("covidvac") ~= nil and Player.PlayerData.job.name == "doctor" then
--         if OtherPlayer ~= nil then
--             local playerInfo = {
--                 id = math.random(100000, 999999),
--                 firstname = OtherPlayer.PlayerData.charinfo.firstname,
--                 lastname = OtherPlayer.PlayerData.charinfo.lastname,
--                 citizenid = OtherPlayer.PlayerData.citizenid,
--                 gender = OtherPlayer.PlayerData.charinfo.gender,
--             }
--             TriggerClientEvent('covidvac:client:vaccination', source)
--             OtherPlayer.Functions.AddItem("covidcert", 1, false, playerInfo)
--             TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,Have received Covid Vaccine.")
--             TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "Now You are vaccinated.But wear mask for safety.")
--             TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["covidcert"], "add")
--         else
--             TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
--         end
--     else
--         TriggerClientEvent("AJFW:Notify", source, "You dont have item required or you dont have permission..", "error")
--     end
-- end)