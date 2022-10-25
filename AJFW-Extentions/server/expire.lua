Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3600000)
        local database = MySQL.Sync.fetchAll('SELECT * FROM queue',{})
        local time = os.date("*t")
        if time.hour == 00 then
            for k,v in pairs(database) do
                if v.expiredd == 1 then
                    if v.days > 1 then
                        local remain = v.days - 1
                        MySQL.Async.execute('UPDATE queue SET days = ? WHERE license = ?',{remain, v.license})
                    elseif v.days == 1 then
                        MySQL.Async.execute('DELETE FROM queue WHERE license = ? ',{v.license})
                    end
                end
            end
        end
    end
end)