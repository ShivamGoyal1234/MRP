local slots = 5 -- Range for the inventory check, begins in 1 an finish on slots value, hotbar's slots are 1-5
local s = {}
local sa = {}
local k = 0
local m = 0
local back_bone = 24818
local x = -0.07
local y = -0.15
local z = 0.0
local x_rotation = 0.0
local y_rotation = 45.0
local z_rotation = 0.0
local selectwep = nil
local valid = false
local weaps = {}
local current = nil

local rifles = {
    ["weapon_microsmg"] = "w_sb_microsmg",
    ["weapon_smg"] = "w_sb_smg",
    ["weapon_assaultsmg"] = "w_sb_assaultsmg",
    ["weapon_combatpdw"] = "w_sb_pdw",
    ["weapon_gusenberg"] = "w_sb_gusenberg",
    ["weapon_smg_mk2"] = "w_sb_smgmk2",
    ["weapon_minismg"] ="w_sb_minismg",
    
    ["weapon_assaultshotgun"] = "w_sg_assaultshotgun",
    ["weapon_bullpupshotgun"] = "w_sg_bullpupshotgun",
    ["weapon_heavyshotgun"] = "w_sg_heavyshotgun",
    ["weapon_pumpshotgun"] = "w_sg_pumpshotgun",
    ["weapon_sawnoffshotgun"] = "w_sg_sawnoff",
    ["weapon_musket"] = "w_ar_musket",
    ["weapon_autoshotgun"] = "w_sg_sweeper",
    ["weapon_combatshotgun"] = "w_sg_pumpshotgunh4",
    ["weapon_pumpshotgun_mk2"] = "w_sg_pumpshotgunmk2",
    
    ["weapon_advancedrifle"] = "w_ar_advancedrifle",
    ["weapon_assaultrifle"] = "w_ar_assaultrifle",
    ["weapon_bullpuprifle"] = "w_ar_bullpuprifle",
    ["weapon_carbinerifle"] = "w_ar_carbinerifle",
    ["weapon_specialcarbine"] = "w_ar_specialcarbine",
    ["weapon_carbinerifle_mk2"] = "w_ar_carbineriflemk2",
    ["weapon_assaultrifle_mk2"] = "w_ar_assaultriflemk2",
    ["weapon_bullpuprifle_mk2"] = "w_ar_bullpupriflemk2",
    ["weapon_specialcarbine_mk2"] = "w_ar_specialcarbinemk2",
    ["weapon_compactrifle"] = "w_ar_assaultrifle_smg",
    ["weapon_militaryrifle"] = "w_ar_bullpuprifleh4",
    ["weapon_heavyrifle"] = "w_ar_heavyrifleh",

    ["weapon_sniperrifle"] = "w_sr_sniperrifle",
    ["weapon_heavysniper"] = "w_sr_heavysniper",
    ["weapon_heavysniper_mk2"] = "w_sr_heavysnipermk2",
    ["weapon_marksmanrifle"] = "w_sr_marksmanrifle",
    ["weapon_marksmanrifle_mk2"] = "w_sr_marksmanriflemk2",

    ["weapon_m4a4"] = "w_ar_m4a4",
    ["weapon_nsr"] = "w_ar_nsr",
    ["weapon_p90"] = "w_sb_p90",
    ["weapon_awp"] = "w_sr_awp",
    ["weapon_ltl"] = "w_sg_ltl",
    ["weapon_hke1"] = "w_ar_hke1",
}

local pistols = {
    ["weapon_pistol"] = "w_pi_pistol",
    ["weapon_combatpistol"] = "w_pi_combatpistol",
    ["weapon_appistol"] = "w_pi_appistol",
    ["weapon_pistol50"] = "w_pi_pistol50",
    ["weapon_snspistol"] = "w_pi_sns_pistol",
    ["weapon_heavypistol"] = "w_pi_heavypistol",
    ["weapon_vintagepistol"] = "w_pi_vintage_pistol",
    ["weapon_revolver"] = "w_pi_revolver",
    ["weapon_doubleaction"] = "w_pi_doubleaction",
    ["weapon_pistol_mk2"] = "w_pi_pistolmk2",
    ["weapon_marksmanpistol"] = "W_PI_SingleShot",
    ["weapon_machinepistol"] = "w_sb_compactsmg",
    ["weapon_glock17"] = "w_pi_glock17",
}

local melee = {
    ["weapon_knife"] = "prop_w_me_knife_01",
    ["weapon_dagger"] = "w_me_dagger",
    ["weapon_karambit"] = "w_me_karambit",
    ["weapon_dagger2"] = "w_me_dagger2",
}

local meleelarge = {
    ["weapon_bat"] = "w_me_bat",
    ["weapon_golfclub"] = "w_me_gclub",
    ["weapon_crowbar"] = "w_me_crowbar",
    ["weapon_machete"] = "w_me_machette_lr",
    ["weapon_hatchet"] = "w_me_hatchet",
    ["weapon_battleaxe"] = "w_me_battleaxe",
    ["weapon_stone_hatchet"] = "w_me_stonehatchet",
    ["weapon_thermalkatana"] = "w_me_thermalkatana",
    ["weapon_kiba"] = "w_me_kiba",
    ["weapon_sogfasthawk"] = "w_me_sogfasthawk",
    ["weapon_berserker"] = "w_me_berserker",
}

local nightstick = {
    ["weapon_nightstick"] = "w_me_nightstick",
}

local polweap = {
    ["weapon_stungun"] = "w_pi_stungun",
}

local function check()
    for i = 1, slots do
        k = 0
        if sa[i] ~= nil then
            for j = 1, slots do
                if s[j] ~= nil then
                    if sa[i].name == s[j].name then
                        k = 1
                        break
                    end
                end
            end
        else
            k = 1
        end
        if k == 0 then
            if sa[i] ~= nil then
                if sa[i].type == "weapon" then
                    DeleteWeapon(sa[i].name)
                end
            end
        end
    end
    
    for i = 1, slots do
        m = 0
        if s[i] ~= nil then
            for j = 1, slots do
                if sa[j] ~= nil then
                    if s[i].name == sa[j].name then
                        m = 1
                        break
                    end
                end
            end
        else
            m = 1
        end
        if m == 0 then
            if s[i] ~= nil then
                if s[i].type == "weapon" then
                    if IsPedArmed(PlayerPedId()) then
                        local wp = GetHashKey(s[i].name)
                        local aw = GetSelectedPedWeapon(PlayerPedId())
                        if wp ~= aw then
                            GiveWeap(s[i].name)
                        end
                    else
                        GiveWeap(s[i].name)
                    end
                end
            end
        end
    end
end

function DeleteWeapon(wep)
    DeleteObject(weaps[wep])
end

function GiveWeap(wep)
    if rifles[wep] ~= nil then
        back_bone = 24818
        x = 0.01
        y = -0.15
        z = 0.06
        x_rotation = 180.0
        y_rotation = 180.0
        z_rotation = 180.0
        valid = true
        selectwep = rifles[wep]
    elseif pistols[wep] ~= nil then
        back_bone = 51826
        x = -0.05
        y = 0.0
        z = 0.1
        x_rotation = -90.0
        y_rotation = 0.0
        z_rotation = 0.0
        valid = true
        selectwep = pistols[wep]
    elseif nightstick[wep] ~= nil then
        back_bone = 51826
        x = -0.2
        y = 0.0
        z = 0.1
        x_rotation = 90.0
        y_rotation = 90.0
        z_rotation = 0.0
        valid = true
        selectwep = nightstick[wep]
    elseif melee[wep] ~= nil then
        back_bone = 11816
        x = -0.1
        y = -0.15
        z = 0.12
        x_rotation = 0.0
        y_rotation = 135.0
        z_rotation = 0.0
        valid = true
        selectwep = melee[wep]
    elseif meleelarge[wep] ~= nil then
        back_bone = 24818
        x = -0.20
        y = -0.15
        z = 0.0
        x_rotation = 0.0
        y_rotation = 90.0
        z_rotation = 0.0
        valid = true
        selectwep = meleelarge[wep]
    elseif polweap[wep] ~= nil then
        back_bone = 58271
        x = -0.05
        y = 0.05
        z = -0.1
        x_rotation = -65.0
        y_rotation = 0.0
        z_rotation = 0.0
        valid = true
        selectwep = polweap[wep]
    end
    
    if valid then
        valid = false
        local bone = GetPedBoneIndex(PlayerPedId(), back_bone)
        RequestModel(selectwep)
        while not HasModelLoaded(selectwep) do
            Wait(10)
        end
        SetModelAsNoLongerNeeded(selectwep)
        weaps[wep] = CreateObject(GetHashKey(selectwep), 1.0, 1.0, 1.0, true, true, false)
        AttachEntityToEntity(weaps[wep], PlayerPedId(), bone, x, y, z, x_rotation, y_rotation, z_rotation, 1, 1, 0, 0, 2, 1)
    end
end

RegisterNetEvent('weapons:client:SetCurrentWeapon', function(weap, shootbool)
    if weap == nil then
        GiveWeap(current)
        current = nil
    else
        if current ~= nil then
            GiveWeap(current)
            current = nil
        end
        current = tostring(weap.name)
        DeleteWeapon(current)
    end
end)


CreateThread(function()
    while true do
        if LocalPlayer.state.isLoggedIn then
            local xPlayer = MRFW.Functions.GetPlayerData()
            for i = 1, slots do
                sa[i] = s[i]
                s[i] = xPlayer.items[i]
            end
            check()
            Wait(500)
        else
            Wait(1000)
        end
    end
end)
