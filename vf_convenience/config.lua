--[[
            vf_convenience - Venomous Freemode - convenience stores resource
              Copyright (C) 2018-2020  FiveM-Scripts

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program in the file "LICENSE".  If not, see <http://www.gnu.org/licenses/>.
]]

-- Configure the coordinates for each shop
locations = {
    ["1"]  = {
        ["blip"] = vector3(-69.3353042602539, -1776.7222900390625, 28.543842315673828),
        ["menu"] = "shopui_title_gasstation",
        ["ped"]  = vector4(-46.313, -1757.504, 29.421, 46.395),
        ["door"] = vector3(-53.470420837402344, -1756.8638916015625, 29.43963623046875),
    },
    ["2"]  = {
        ["blip"] = vector3(26.017168045043945, -1353.472900390625, 29.33883285522461),
        ["menu"] = "shopui_title_conveniencestore",
        ["ped"]  = vector4(24.376, -1345.558, 29.421, 267.940),
        ["door"] = vector3(29.204355239868164, 1350.133056640625, 29.33132553100586),
    },
    ["3"]  = {
        ["blip"] = vector3(376.7219848632813, 320.2231750488281, 103.417724609375),
        ["menu"] = "shopui_title_conveniencestore",
        ["ped"]  = vector4(373.015, 328.332, 103.566, 257.309),
        ["door"] = vector3(376.5338745117187, 323.00653076171875, 103.57288360595705),
    },
    ["4"]  = {
        ["blip"] = vector3(1145.4398193359375, -980.5490112304688, 46.2032585144043),
        ["menu"] = "shopui_title_liquorstore2",
        ["ped"]  = vector4(1134.182, -982.477, 46.416, 275.432),
        ["door"] = vector3(1141.9202880859375, -980.8821411132812, 46.19901657104492),
    },
    ["5"] = {
        ["blip"] = vector3(2685.930419921875, 3284.34033203125, 55.24053192138672),
        ["menu"] = "shopui_title_conveniencestore",
        ["ped"]  = vector4(2676.389, 3280.362, 55.241, 332.305),
        ["door"] = vector3(2685.930419921875, 3284.34033203125, 55.24053192138672),
    },
    ["6"] = {
        ["blip"] = vector3(1966.7060546875, 3737.554931640625, 32.192169189453125),
        ["menu"] = "shopui_title_conveniencestore",
        ["ped"]  = vector4(1958.960, 3741.979, 32.344, 303.196),
        ["door"] = vector3(1965.3636474609375, 3740.43701171875, 32.33184814453125),
    },
    ["7"] = {
        ["blip"] = vector3(-2977.73388671875, 391.07135009765625, 15.02270793914795),
        ["menu"] = "shopui_title_liquorstore2",
        ["ped"]  = vector4(-2966.391, 391.324, 15.043, 88.867),
        ["door"] = vector3(-2974.0458984375, 390.7870178222656, 15.034119606018066),
    },
    ["8"] = {
        ["blip"] = vector3(1160.7017822265625, -331.40130615234375, 68.89907836914062),
        ["menu"] = "shopui_title_gasstation",
        ["ped"]  = vector4(1164.565, -322.121, 69.205, 100.492),
        ["door"] = vector3(1159.8760986328125, -326.99432373046875, 69.21745300292969),
    },
    ["9"] = {
        ["blip"] = vector3(-1493.5517578125, -385.7423400878906, 39.890830993652344),
        ["menu"] = "shopui_title_liquorstore2",
        ["ped"]  = vector4(-1486.530, -377.768, 40.163, 147.669),
        ["door"] = vector3(-1491.3759765625, -383.4170227050781, 40.165184020996094),
    },
    ["10"] = {
        ["blip"] = vector3(-1228.534423828125, -899.4459838867188, 12.280976295471191),
        ["menu"] = "shopui_title_liquorstore2",
        ["ped"]  = vector4(-1221.568, -908.121, 12.326, 31.739),
        ["door"] = vector3(-1226.547607421875, -902.0326538085938, 12.28719425201416),
    },
    ["11"] = {
        ["blip"] = vector3(-708.9332885742188, -920.1010131835938, 19.013906478881836),
        ["menu"] = "shopui_title_liquorstore2",
        ["ped"]  = vector4(-706.153, -913.464, 19.216, 82.056),
        ["door"] = vector3(-712.0322265625, -916.9070434570312, 19.214242935180664),
    },
    ["12"] = {
        ["blip"] = vector3(-1812.6617431640625, 776.0027465820312, 136.80467224121094),
        ["menu"] = "shopui_title_gasstation",
        ["ped"]  = vector4(-1820.230, 794.369, 138.089, 130.327),
        ["door"] = vector3(-1822.2608642578125, 787.783203125, 138.18797302246094),
    },
    ["13"] = {
        ["blip"] = vector3(2566.368408203125, 385.0050354003906, 108.6210479736328),
        ["menu"] = "shopui_title_conveniencestore",
        ["ped"]  = vector4(2555.474, 380.909, 108.623, 355.737),
        ["door"] = vector3(2559.598388671875, 385.2843933105469, 108.6210479736328),
    },
    ["14"] = {
        ["blip"] = vector3(1725.73388671875, 6399.884765625, 34.44724655151367),
        ["menu"] = "shopui_title_conveniencestore",
        ["ped"]  = vector4(1728.614, 6416.729, 35.037, 247.369),
        ["door"] = vector3(1731.052734375, 6411.2568359375, 35.00066375732422),
    },
}