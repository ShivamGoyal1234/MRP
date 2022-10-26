Config = {}


Config.Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}


Config.Locations = {
    ["exit"] = {x = 82.8, y = 279.12, z = 110.21, h = 132.82, r = 1.0},
    ["vehicle"] = {x = 95.98, y = 300.13, z = 110.02, h = 74.01, r = 1.0}, 
}

Config.Vehicles = {
    ["nrg"] = "MCD Bike",
    ["vwcaddy"] = "MCD Car",

}

Config.mcdShops = {
    label = "MCD STORAGE",
    slots = 30,
    items = {
        [1] = {
            name = "mcd-glass",
            price = 0,
            amount = 500,
            info = {},
            type = "item",
            slot = 1,
        },
        [2] = {
            name = "mcd-cup",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 2,
        },
        
        [3] = {
            name = "mcd-desert",
            price = 10,
            amount = 50,
            info = {},
            type = "item",
            slot = 3,
        },
        [4] = {
            name = "mcd-cola",
            price = 10,
            amount = 50,
            info = {},
            type = "item",
            slot = 4,
        },
        
    }
}

