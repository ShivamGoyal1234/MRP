local MRFW = exports['mrfw']:GetCoreObject() -- We've ALWAYS got to grab our core object

local currentjob = {}

RegisterNetEvent("MRFW:Client:OnPlayerLoaded")
AddEventHandler("MRFW:Client:OnPlayerLoaded", function()
	local Player=MRFW.Functions.GetPlayerData()
    local job = Player.job
    -- print(json.encode(Player.job))
    currentjob = job
    if job == "police" or job == "doctor" or job == "mechanic" or job == "government" or job == "pdm" then -- job's name here
        TriggerServerEvent("mr-shiftlog:userjoined", job)
    end
end)

RegisterNetEvent('MRFW:Client:OnJobUpdate')
AddEventHandler('MRFW:Client:OnJobUpdate', function(job)
    Wait(100)
    
    if job.name == "police" or job.name == "doctor" or job.name == "mechanic" or job.name == "government" or job.name == "pdm" then -- job's name here
        if job.onduty then
            TriggerEvent("mr-shiftlog:jobchanged", job, job, 1, src)
        else
            TriggerEvent("mr-shiftlog:jobchanged2", job, job, 1, src)
        end
           
    end
    currentjob = job
end)

RegisterNetEvent('MRFW:Client:OnPlayerUnload', function()
    TriggerServerEvent("mr-shiftlog:jobchanged2", currentjob, currentjob, 1, src)
end)

RegisterNetEvent('MRFW:Client:SetDuty', function(val)
    if currentjob.name == "police" or currentjob.name == "doctor" or currentjob.name == "mechanic" or currentjob.name == "government" or currentjob.name == "pdm" then -- job's name here
        if not val then
            TriggerServerEvent("mr-shiftlog:jobchanged2", currentjob, currentjob, 1, src)
        else
            TriggerServerEvent("mr-shiftlog:jobchanged", currentjob, currentjob, 0, src)  
        end
    end
    onDuty = val
end)