local AJFW = exports['ajfw']:GetCoreObject() -- We've ALWAYS got to grab our core object

local currentjob = {}

RegisterNetEvent("AJFW:Client:OnPlayerLoaded")
AddEventHandler("AJFW:Client:OnPlayerLoaded", function()
	local Player=AJFW.Functions.GetPlayerData()
    local job = Player.job
    -- print(json.encode(Player.job))
    currentjob = job
    if job == "police" or job == "doctor" or job == "mechanic" or job == "government" or job == "pdm" then -- job's name here
        TriggerServerEvent("aj-shiftlog:userjoined", job)
    end
end)

RegisterNetEvent('AJFW:Client:OnJobUpdate')
AddEventHandler('AJFW:Client:OnJobUpdate', function(job)
    Wait(100)
    
    if job.name == "police" or job.name == "doctor" or job.name == "mechanic" or job.name == "government" or job.name == "pdm" then -- job's name here
        if job.onduty then
            TriggerEvent("aj-shiftlog:jobchanged", job, job, 1, src)
        else
            TriggerEvent("aj-shiftlog:jobchanged2", job, job, 1, src)
        end
           
    end
    currentjob = job
end)

RegisterNetEvent('AJFW:Client:OnPlayerUnload', function()
    TriggerServerEvent("aj-shiftlog:jobchanged2", currentjob, currentjob, 1, src)
end)

RegisterNetEvent('AJFW:Client:SetDuty', function(val)
    if currentjob.name == "police" or currentjob.name == "doctor" or currentjob.name == "mechanic" or currentjob.name == "government" or currentjob.name == "pdm" then -- job's name here
        if not val then
            TriggerServerEvent("aj-shiftlog:jobchanged2", currentjob, currentjob, 1, src)
        else
            TriggerServerEvent("aj-shiftlog:jobchanged", currentjob, currentjob, 0, src)  
        end
    end
    onDuty = val
end)