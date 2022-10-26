
MRFW.Commands.Add("setlawyer", "Set someone as a lawyer", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = MRFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = MRFW.Functions.GetPlayer(playerId)
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
            TriggerClientEvent("MRFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have Hired as a lawyer")
            TriggerClientEvent("MRFW:Notify", OtherPlayer.PlayerData.source, "You are now a lawyer")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, MRFW.Shared.Items["lawyerpass"], "add")
        else
            TriggerClientEvent("MRFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("MRFW:Notify", source, "You have no rights..", "error")
    end
end,'government')

MRFW.Commands.Add("removelawyer", "Delete someone from lawyer", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = MRFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = MRFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or Player.PlayerData.job.grade.name == "Mayor" or  Player.PlayerData.job.name == "doj" and Player.PlayerData.job.grade.name == "Chief Justice" then
        if OtherPlayer ~= nil then
            --OtherPlayer.Functions.SetJob("unemployed")
            TriggerClientEvent("MRFW:Notify", OtherPlayer.PlayerData.source, "You are now unemployed")
            TriggerClientEvent("MRFW:Notify", source, "-".. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " , You are Fired as a lawyer")
        else
            TriggerClientEvent("MRFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("MRFW:Notify", source, "You have no rights..", "error")
    end
end,'government')

MRFW.Functions.CreateUseableItem("lawyerpass", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("mr-justice:client:showLawyerLicense", -1, source, item.info)
    end
end)

MRFW.Commands.Add("mayorpass", "Give Mayor Pass", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = MRFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = MRFW.Functions.GetPlayer(playerId)
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
            TriggerClientEvent("MRFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received mayor pass.")
            TriggerClientEvent("MRFW:Notify", OtherPlayer.PlayerData.source, "Now you can meet mayor! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, MRFW.Shared.Items["mayorpass"], "add")
        else
            TriggerClientEvent("MRFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("MRFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

MRFW.Commands.Add("mechanicid", "Give Mechanic ID", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = MRFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = MRFW.Functions.GetPlayer(playerId)
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
            TriggerClientEvent("MRFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("MRFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, MRFW.Shared.Items["mecard"], "add")
        else
            TriggerClientEvent("MRFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("MRFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

MRFW.Commands.Add("newsid", "Give Reporter ID", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = MRFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = MRFW.Functions.GetPlayer(playerId)
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
            TriggerClientEvent("MRFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("MRFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, MRFW.Shared.Items["wcard"], "add")
        else
            TriggerClientEvent("MRFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("MRFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

MRFW.Commands.Add("taxiid", "Give Taxi ID", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = MRFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = MRFW.Functions.GetPlayer(playerId)
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
            TriggerClientEvent("MRFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("MRFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, MRFW.Shared.Items["taxicard"], "add")
        else
            TriggerClientEvent("MRFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("MRFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

MRFW.Commands.Add("towid", "Give Tow ID", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = MRFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = MRFW.Functions.GetPlayer(playerId)
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
            TriggerClientEvent("MRFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("MRFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, MRFW.Shared.Items["towcard"], "add")
        else
            TriggerClientEvent("MRFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("MRFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

MRFW.Commands.Add("poid", "Give Postal ID", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = MRFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = MRFW.Functions.GetPlayer(playerId)
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
            TriggerClientEvent("MRFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("MRFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, MRFW.Shared.Items["pocard"], "add")
        else
            TriggerClientEvent("MRFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("MRFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

MRFW.Commands.Add("idcard", "Give ID Card", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = MRFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = MRFW.Functions.GetPlayer(playerId)
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
            TriggerClientEvent("MRFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received ID CARD.")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, MRFW.Shared.Items["id_card"], "add")
        else
            TriggerClientEvent("MRFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("MRFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

MRFW.Commands.Add("policeid", "Give Police ID", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = MRFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = MRFW.Functions.GetPlayer(playerId)
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
            TriggerClientEvent("MRFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("MRFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, MRFW.Shared.Items["pcard"], "add")
        else
            TriggerClientEvent("MRFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("MRFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

MRFW.Commands.Add("mwid", "Give Police ID", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = MRFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = MRFW.Functions.GetPlayer(playerId)
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
            TriggerClientEvent("MRFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("MRFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, MRFW.Shared.Items["mwcard"], "add")
        else
            TriggerClientEvent("MRFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("MRFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

-- MRFW.Commands.Add("idcard", "Give ID card", {{name="id", help="Player ID"}}, true, function(source, args)
--     local Player = MRFW.Functions.GetPlayer(source)
--     local playerId = tonumber(args[1])
--     local OtherPlayer = MRFW.Functions.GetPlayer(playerId)
--     if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or Player.PlayerData.job.grade.name == "Mayor" or Player.PlayerData.job.grade.name == "Secretery" or Player.PlayerData.job.grade.name == "Employee" then
--         if OtherPlayer ~= nil then
--             local playerInfo = {
--                 id = math.random(100000, 999999),
--                 firstname = OtherPlayer.PlayerData.charinfo.firstname,
--                 lastname = OtherPlayer.PlayerData.charinfo.lastname,
--                 citizenid = OtherPlayer.PlayerData.citizenid,
--             }
           
--             OtherPlayer.Functions.AddItem("id_card", 1, false, playerInfo)
--             TriggerClientEvent("MRFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
--             TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, MRFW.Shared.Items["id_card"], "add")
--         else
--             TriggerClientEvent("MRFW:Notify", source, "This person is not present..", "error")
--         end
--     else
--         TriggerClientEvent("MRFW:Notify", source, "You have no rights..", "error")
--     end
-- end)

MRFW.Commands.Add("emsid", "Give EMS ID", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = MRFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = MRFW.Functions.GetPlayer(playerId)
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
            TriggerClientEvent("MRFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("MRFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, MRFW.Shared.Items["mcard"], "add")
        else
            TriggerClientEvent("MRFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("MRFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

MRFW.Commands.Add("garbageid", "Give Garbage ID", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = MRFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = MRFW.Functions.GetPlayer(playerId)
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
            TriggerClientEvent("MRFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("MRFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, MRFW.Shared.Items["garbagecard"], "add")
        else
            TriggerClientEvent("MRFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("MRFW:Notify", source, "You have no rights..", "error")
    end
end,"government")


MRFW.Functions.CreateUseableItem("mayorpass", function(source, item)
    local Player = MRFW.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("mr-justice:client:showMayorPass", -1, source, item.info)
    end
end)


--Business

MRFW.Commands.Add("setbe", "Set Someone Bahamas Employee", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = MRFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = MRFW.Functions.GetPlayer(playerId)
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

            TriggerClientEvent("MRFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have Hired as a bahamas employee")
            TriggerClientEvent("MRFW:Notify", OtherPlayer.PlayerData.source, "You are now a bahamas employee")
        else
            TriggerClientEvent("MRFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("MRFW:Notify", source, "You have no rights..", "error")
    end
end)

MRFW.Commands.Add("setce", "Set Someone Cinema Employee", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = MRFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = MRFW.Functions.GetPlayer(playerId)
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

            TriggerClientEvent("MRFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have Hired as a cinema employee")
            TriggerClientEvent("MRFW:Notify", OtherPlayer.PlayerData.source, "You are now a cinema employee")
        else
            TriggerClientEvent("MRFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("MRFW:Notify", source, "You have no rights..", "error")
    end
end)

MRFW.Commands.Add("setcce", "Set Someone Comedy Club Employee", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = MRFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = MRFW.Functions.GetPlayer(playerId)
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

            TriggerClientEvent("MRFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have Hired as a Comedy Club employee")
            TriggerClientEvent("MRFW:Notify", OtherPlayer.PlayerData.source, "You are now a Comedy Club Employee")
        else
            TriggerClientEvent("MRFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("MRFW:Notify", source, "You have no rights..", "error")
    end
end)

MRFW.Commands.Add("setmcde", "Set Someone MCD Employee", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = MRFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = MRFW.Functions.GetPlayer(playerId)
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

            TriggerClientEvent("MRFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have Hired as a MCD Employee")
            TriggerClientEvent("MRFW:Notify", OtherPlayer.PlayerData.source, "You are now a MCD Employee")
        else
            TriggerClientEvent("MRFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("MRFW:Notify", source, "You have no rights..", "error")
    end
end)

MRFW.Commands.Add("setcse", "Set Someone Coffee Employee", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = MRFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = MRFW.Functions.GetPlayer(playerId)
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

            TriggerClientEvent("MRFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have Hired as a Coffee Employee")
            TriggerClientEvent("MRFW:Notify", OtherPlayer.PlayerData.source, "You are now a Coffee Employee")
        else
            TriggerClientEvent("MRFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("MRFW:Notify", source, "You have no rights..", "error")
    end
end)


--cards

MRFW.Commands.Add("agentid", "Give Real Estate Agent ID", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = MRFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = MRFW.Functions.GetPlayer(playerId)
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
            TriggerClientEvent("MRFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("MRFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, MRFW.Shared.Items["realestatecard"], "add")
        else
            TriggerClientEvent("MRFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("MRFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

MRFW.Commands.Add("govid", "Give Government Employee ID", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = MRFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = MRFW.Functions.GetPlayer(playerId)
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
            TriggerClientEvent("MRFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("MRFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, MRFW.Shared.Items["governmentcard"], "add")
        else
            TriggerClientEvent("MRFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("MRFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

MRFW.Commands.Add("judgeid", "Give Judge ID", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = MRFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = MRFW.Functions.GetPlayer(playerId)
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
            TriggerClientEvent("MRFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("MRFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, MRFW.Shared.Items["judgecard"], "add")
        else
            TriggerClientEvent("MRFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("MRFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

MRFW.Commands.Add("mayorid", "Give Mayor ID", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = MRFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = MRFW.Functions.GetPlayer(playerId)
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
            TriggerClientEvent("MRFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("MRFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, MRFW.Shared.Items["mayorcard"], "add")
        else
            TriggerClientEvent("MRFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("MRFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

MRFW.Commands.Add("businesslic", "Give Business License", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = MRFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = MRFW.Functions.GetPlayer(playerId)
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
            TriggerClientEvent("MRFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("MRFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, MRFW.Shared.Items["businesscard"], "add")
        else
            TriggerClientEvent("MRFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("MRFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

MRFW.Commands.Add("empid", "Give Employee ID", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = MRFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = MRFW.Functions.GetPlayer(playerId)
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
            TriggerClientEvent("MRFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("MRFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, MRFW.Shared.Items["employeecard"], "add")
        else
            TriggerClientEvent("MRFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("MRFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

MRFW.Commands.Add("surgerypass", "Give Surgery Pass", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = MRFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = MRFW.Functions.GetPlayer(playerId)
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
            TriggerClientEvent("MRFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received Surgery Pass")
            TriggerClientEvent("MRFW:Notify", OtherPlayer.PlayerData.source, "Now You can go for Plastic Surgery ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, MRFW.Shared.Items["surgerypass"], "add")
        else
            TriggerClientEvent("MRFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("MRFW:Notify", source, "You have no rights..", "error")
    end
end, "doctor")

MRFW.Commands.Add("weaponpass", "Give Weapon Pass", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = MRFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = MRFW.Functions.GetPlayer(playerId)
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
            TriggerClientEvent("MRFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received Weapon Pass")
            TriggerClientEvent("MRFW:Notify", OtherPlayer.PlayerData.source, "Now You can go for Weapon Pass")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, MRFW.Shared.Items["weaponlicense"], "add")
        else
            TriggerClientEvent("MRFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("MRFW:Notify", source, "You have no rights..", "error")
    end
end,"police")

MRFW.Commands.Add("dojcard", "Give DOJ CARD", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = MRFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = MRFW.Functions.GetPlayer(playerId)
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
            TriggerClientEvent("MRFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received DOJ CARD")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, MRFW.Shared.Items["dojcard"], "add")
        else
            TriggerClientEvent("MRFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("MRFW:Notify", source, "You have no rights..", "error")
    end
end,"government")


-- MRFW.Commands.Add("givepaper", "Give finance paper", {{name="id", help="Player ID"}}, true, function(source, args)
--     local Player = MRFW.Functions.GetPlayer(source)
--     local playerId = tonumber(args[1])
--     local OtherPlayer = MRFW.Functions.GetPlayer(playerId)
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
--             TriggerClientEvent("MRFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received Finance Paper")
--             TriggerClientEvent("MRFW:Notify", OtherPlayer.PlayerData.source, "Now You can go for Finance Paper")
--             TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, MRFW.Shared.Items["financepaper"], "add")
--         else
--             TriggerClientEvent("MRFW:Notify", source, "This person is not present..", "error")
--         end
--     else
--         TriggerClientEvent("MRFW:Notify", source, "You have no rights..", "error")
--     end
-- end)

-- MRFW.Commands.Add("vehiclecard", "Give Vehicle Card", {{name="id", help="Player ID"}}, true, function(source, args)
--     local Player = MRFW.Functions.GetPlayer(source)
--     local playerId = tonumber(args[1])
--     local OtherPlayer = MRFW.Functions.GetPlayer(playerId)
--     if Player.PlayerData.job.name == "pdm" and Player.PlayerData.job.grade.name == "Owner" or Player.PlayerData.job.grade.name == "CEO" or Player.PlayerData.job.grade.name == "Salesman" or Player.PlayerData.job.grade.name == "Senior Salesman" or Player.PlayerData.job.grade.name == "Executive" or Player.PlayerData.job.grade.name == "Manager" then
--         if OtherPlayer ~= nil then
--             local playerInfo = {
--                 id = math.random(100000, 999999),
--                 firstname = OtherPlayer.PlayerData.charinfo.firstname,
--                 lastname = OtherPlayer.PlayerData.charinfo.lastname,
--                 citizenid = OtherPlayer.PlayerData.citizenid,
--             }
           
--             OtherPlayer.Functions.AddItem("buycard", 1, false, playerInfo)
--             TriggerClientEvent("MRFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received Vehicle card")
--             TriggerClientEvent("MRFW:Notify", OtherPlayer.PlayerData.source, "Now You can go for Purchasing Vehicle")
--             TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, MRFW.Shared.Items["buycard"], "add")
--         else
--             TriggerClientEvent("MRFW:Notify", source, "This person is not present..", "error")
--         end
--     else
--         TriggerClientEvent("MRFW:Notify", source, "You have no rights..", "error")
--     end
-- end)


-- MRFW.Commands.Add("givedocument", "Give housing paper", {{name="id", help="Player ID"}}, true, function(source, args)
--     local Player = MRFW.Functions.GetPlayer(source)
--     local playerId = tonumber(args[1])
--     local OtherPlayer = MRFW.Functions.GetPlayer(playerId)
--     if Player.PlayerData.job.name == "realestate" and Player.PlayerData.job.grade.name == "Company Owner" then
--         if OtherPlayer ~= nil then
--             local playerInfo = {
--                 id = math.random(100000, 999999),
--                 firstname = OtherPlayer.PlayerData.charinfo.firstname,
--                 lastname = OtherPlayer.PlayerData.charinfo.lastname,
--                 citizenid = OtherPlayer.PlayerData.citizenid,
--             }
           
--             OtherPlayer.Functions.AddItem("housingpaper", 1, false, playerInfo)
--             TriggerClientEvent("MRFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received Housing Paper")
--             TriggerClientEvent("MRFW:Notify", OtherPlayer.PlayerData.source, "Now You can go and buy your house")
--             TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, MRFW.Shared.Items["housingpaper"], "add")
--         else
--             TriggerClientEvent("MRFW:Notify", source, "This person is not present..", "error")
--         end
--     else
--         TriggerClientEvent("MRFW:Notify", source, "You have no rights..", "error")
--     end
-- end)

MRFW.Commands.Add("petlicense", "Give Pet Lic", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = MRFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = MRFW.Functions.GetPlayer(playerId)
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
            TriggerClientEvent("MRFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received Pet License")
            TriggerClientEvent("MRFW:Notify", OtherPlayer.PlayerData.source, "Now You can go for Pet License")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, MRFW.Shared.Items["petlicense"], "add")
        else
            TriggerClientEvent("MRFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("MRFW:Notify", source, "You have no rights..", "error")
    end
end,"police")

-----------------Vaccination
-- MRFW.Commands.Add("covidvac", "Give covid vaccine", {{name="id", help="Player ID"}}, true, function(source, args)
--     local Player = MRFW.Functions.GetPlayer(source)
--     local playerId = tonumber(args[1])
--     local OtherPlayer = MRFW.Functions.GetPlayer(playerId)
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
--             TriggerClientEvent("MRFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,Have received Covid Vaccine.")
--             TriggerClientEvent("MRFW:Notify", OtherPlayer.PlayerData.source, "Now You are vaccinated.But wear mask for safety.")
--             TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, MRFW.Shared.Items["covidcert"], "add")
--         else
--             TriggerClientEvent("MRFW:Notify", source, "This person is not present..", "error")
--         end
--     else
--         TriggerClientEvent("MRFW:Notify", source, "You dont have item required or you dont have permission..", "error")
--     end
-- end)