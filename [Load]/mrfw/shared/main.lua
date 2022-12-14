MRShared = {}

local StringCharset = {}
local NumberCharset = {}

for i = 48,  57 do NumberCharset[#NumberCharset+1] = string.char(i) end
for i = 65,  90 do StringCharset[#StringCharset+1] = string.char(i) end
for i = 97, 122 do StringCharset[#StringCharset+1] = string.char(i) end

MRShared.RandomStr = function(length)
    if length <= 0 then return '' end
    return MRShared.RandomStr(length - 1) .. StringCharset[math.random(1, #StringCharset)]
end

MRShared.RandomInt = function(length)
    if length <= 0 then return '' end
    return MRShared.RandomInt(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
end

MRShared.SplitStr = function(str, delimiter)
    local result = { }
    local from = 1
    local delim_from, delim_to = string.find(str, delimiter, from)
    while delim_from do
		result[#result+1] = string.sub(str, from, delim_from - 1)
        from = delim_to + 1
        delim_from, delim_to = string.find(str, delimiter, from)
    end
	result[#result+1] = string.sub(str, from)
    return result
end

-- MRShared.Sign = function(v)
-- 	return (v >= 0 and 1) or -1
-- end

MRShared.Trim = function(value)
	if not value then return nil end
    return (string.gsub(value, '^%s*(.-)%s*$', '%1'))
end

-- MRShared.Round = function(v, bracket)
-- 	bracket = bracket or 1
-- 	return MRShared.Sign(v/bracket + MRFW.Sign(v) * 0.5) * bracket
-- end

MRShared.Round = function(value, numDecimalPlaces)
    -- print(value, numDecimalPlaces)
    if not numDecimalPlaces then return math.floor(value + 0.5) end
    local power = 10 ^ numDecimalPlaces
    -- print(power)
    return math.floor((value * power) + 0.5) / (power)
end

MRShared.StarterItems = {
	["phone"] = {amount = 1, item = "phone"},
    ["water_bottle"] = {amount = 5, item = "water_bottle"},
    ["sandwich"] = {amount = 5, item = "sandwich"},
}

MRShared.MaleNoGloves = {
    [0] = true,
    [1] = true,
    [2] = true,
    [3] = true,
    [4] = true,
    [5] = true,
    [6] = true,
    [7] = true,
    [8] = true,
    [9] = true,
    [10] = true,
    [11] = true,
    [12] = true,
    [13] = true,
    [14] = true,
    [15] = true,
    [18] = true,
    [52] = true,
    [53] = true,
    [54] = true,
    [55] = true,
    [56] = true,
    [57] = true,
    [58] = true,
    [59] = true,
    [60] = true,
    [61] = true,
    [62] = true,
    [97] = true,
    [98] = true,
    [112] = true,
    [113] = true,
    [114] = true,
    [118] = true,
    [125] = true,
    [132] = true,
    [164] = true,
    [169] = true,
    [188] = true,
    [196] = true,
    [197] = true,
}

MRShared.FemaleNoGloves = {
    [0] = true,
    [1] = true,
    [2] = true,
    [3] = true,
    [4] = true,
    [5] = true,
    [6] = true,
    [7] = true,
    [8] = true,
    [9] = true,
    [10] = true,
    [11] = true,
    [12] = true,
    [13] = true,
    [14] = true,
    [15] = true,
    [19] = true,
    [59] = true,
    [60] = true,
    [61] = true,
    [62] = true,
    [63] = true,
    [64] = true,
    [65] = true,
    [66] = true,
    [67] = true,
    [68] = true,
    [69] = true,
    [70] = true,
    [71] = true,
    [112] = true,
    [113] = true,
    [129] = true,
    [130] = true,
    [131] = true,
    [135] = true,
    [142] = true,
    [149] = true,
    [153] = true,
    [157] = true,
    [161] = true,
    [165] = true,
    [205] = true,
    [210] = true,
    [229] = true,
    [233] = true,
    [241] = true,
    [242] = true,
}