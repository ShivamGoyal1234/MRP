-- --[[
-- 	HUD = 0;
-- 	HUD_WANTED_STARS = 1;
-- 	HUD_WEAPON_ICON = 2;
-- 	HUD_CASH = 3;
-- 	HUD_MP_CASH = 4;
-- 	HUD_MP_MESSAGE = 5;
-- 	HUD_VEHICLE_NAME = 6;
-- 	HUD_AREA_NAME = 7;
-- 	HUD_VEHICLE_CLASS = 8;
-- 	HUD_STREET_NAME = 9;
-- 	HUD_HELP_TEXT = 10;
-- 	HUD_FLOATING_HELP_TEXT_1 = 11;
-- 	HUD_FLOATING_HELP_TEXT_2 = 12;
-- 	HUD_CASH_CHANGE = 13;
-- 	HUD_RETICLE = 14;
-- 	HUD_SUBTITLE_TEXT = 15;
-- 	HUD_RADIO_STATIONS = 16;
-- 	HUD_SAVING_GAME = 17;
-- 	HUD_GAME_STREAM = 18;
-- 	HUD_WEAPON_WHEEL = 19;
-- 	HUD_WEAPON_WHEEL_STATS = 20;
-- 	MAX_HUD_COMPONENTS = 21;
-- 	MAX_HUD_WEAPONS = 22;
-- 	MAX_SCRIPTED_HUD_COMPONENTS = 141;
-- ]]--

Citizen.CreateThread(function()
	while true do
		HideHudComponentThisFrame(1)
		HideHudComponentThisFrame(2)
		HideHudComponentThisFrame(3)
		HideHudComponentThisFrame(4)
		HideHudComponentThisFrame(5)			-- 5 : MP_MESSAGE
		-- HideHudComponentThisFrame(6)			-- 6 : VEHICLE_NAME
		HideHudComponentThisFrame(7)
		-- HideHudComponentThisFrame(8)			-- 8 : VEHICLE_CLASS
		HideHudComponentThisFrame(9)
		-- HideHudComponentThisFrame(10)		-- 10 : HELP_TEXT
		-- HideHudComponentThisFrame(11)		-- 11 : FLOATING_HELP_TEXT_1
		-- HideHudComponentThisFrame(12)		-- 12 : FLOATING_HELP_TEXT_2
		HideHudComponentThisFrame(13)
		HideHudComponentThisFrame(14)
		-- HideHudComponentThisFrame(15)		-- 15 : SUBTITLE_TEXT
		-- HideHudComponentThisFrame(16)		-- 16 : RADIO_STATIONS
		HideHudComponentThisFrame(17)
		-- HideHudComponentThisFrame(18)		-- 18 : GAME_STREAM
        HideHudComponentThisFrame(19)
        HideHudComponentThisFrame(20)
        HideHudComponentThisFrame(21)
		HideHudComponentThisFrame(22)
		DisableControlAction(1, 37)
		DisplayAmmoThisFrame(true)

		Citizen.Wait(5)
	end
end) 