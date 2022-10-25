local INPUT_AIM = 0
local UseFPS = false
local justPressed = 0
local disable = 0
CreateThread(function()
    while true do
        Wait(1)
        if IsControlPressed(0, INPUT_AIM) then
            justPressed = justPressed + 1
        end
        if IsControlJustReleased(0, INPUT_AIM) then
            if justPressed < 15 then
                UseFPS = true
            end
            justPressed = 0
        end
        if GetFollowPedCamViewMode() == 1 or GetFollowVehicleCamViewMode() == 1 then
        	Wait(1)
        	SetFollowPedCamViewMode(0)
        	SetFollowVehicleCamViewMode(0)
        end
        if UseFPS then
        	if GetFollowPedCamViewMode() == 0 or GetFollowVehicleCamViewMode() == 0 then
        		Wait(1)
        		SetFollowPedCamViewMode(4)
        		SetFollowVehicleCamViewMode(4)
        	else
        		Wait(1)
        		SetFollowPedCamViewMode(0)
        		SetFollowVehicleCamViewMode(0)
        	end
    		UseFPS = false
        end
        if IsPedArmed(PlayerPedId(),1) or not IsPedArmed(PlayerPedId(),7) then
            if IsControlJustPressed(0,24) or IsControlJustPressed(0,141) or IsControlJustPressed(0,142) or IsControlJustPressed(0,140)  then
               disable = 50
            end
        end
        if disable > 0 then
            disable = disable - 1
            DisableControlAction(0,24)
            DisableControlAction(0,140)
            DisableControlAction(0,141)
            DisableControlAction(0,142)
        end
    end
end)
CreateThread(function()
    while true do
        Wait(1)
        if IsPedArmed(PlayerPedId(), 6) then
            DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
        else
            Wait(1500)
        end
    end
end)