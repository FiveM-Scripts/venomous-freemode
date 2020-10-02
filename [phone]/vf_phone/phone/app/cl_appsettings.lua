--[[
            vf_phone
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

local function SetTheme(theme)
    Phone.Theme = theme
    SetResourceKvpInt("vf_phone_theme", theme)
end

local function SetWallpaper(wallpaper)
    Phone.Wallpaper = wallpaper
    SetResourceKvpInt("vf_phone_wallpaper", wallpaper)
end

local Settings = {
    {
        Name = GetLabelText("CELL_720"),
        Icon = 23,
        Items = {
            {
                Name = GetLabelText("CELL_820"),
                OnSelect = function()
                    SetTheme(1)
                end
            },
            {
                Name = GetLabelText("CELL_821"),
                OnSelect = function()
                    SetTheme(2)
                end
            },
            {
                Name = GetLabelText("CELL_822"),
                OnSelect = function()
                    SetTheme(3)
                end
            },
            {
                Name = GetLabelText("CELL_823"),
                OnSelect = function()
                    SetTheme(4)
                end
            },
            {
                Name = GetLabelText("CELL_824"),
                OnSelect = function()
                    SetTheme(5)
                end
            },
            {
                Name = GetLabelText("CELL_825"),
                OnSelect = function()
                    SetTheme(6)
                end
            },
            {
                Name = GetLabelText("CELL_826"),
                OnSelect = function()
                    SetTheme(7)
                end
            }
        }
    },
    {
        Name = GetLabelText("CELL_740"),
        Icon = 25,
        Items = {
            {
                Name = GetLabelText("CELL_844"),
                OnSelect = function()
                    SetWallpaper(4)
                end
            },        
            {
                Name = GetLabelText("CELL_845"),
                OnSelect = function()
                    SetWallpaper(5)
                end
            },
            {
                Name = GetLabelText("CELL_846"),
                OnSelect = function()
                    SetWallpaper(6)
                end
            },
            {
                Name = GetLabelText("CELL_847"),
                OnSelect = function()
                    SetWallpaper(7)
                end
            },
            {
                Name = GetLabelText("CELL_848"),
                OnSelect = function()
                    SetWallpaper(8)
                end
            },
            {
                Name = GetLabelText("CELL_849"),
                OnSelect = function()
                    SetWallpaper(9)
                end
            },
            {
                Name = GetLabelText("CELL_850"),
                OnSelect = function()
                    SetWallpaper(10)
                end
            },
            {
                Name = GetLabelText("CELL_851"),
                OnSelect = function()
                    SetWallpaper(11)
                end
            }
        }
    },
    {
        Name = GetLabelText("CELL_801"),
        Icon = 26,
        Items = {
            {
                Name = GetLabelText("CELL_830"),
                OnSelect = function()
                    if not Phone.SleepMode then
                        exports.vf_utils:QueueHelpText(
                            "This will signal other apps to not send any notifications to you. You might miss out on crucial messages.", 10)
                    end
                    Phone.SleepMode = true
                end
            },
            {
                Name = GetLabelText("CELL_831"),
                Icon = 1,
                OnSelect = function()
                    Phone.SleepMode = false
                end
            }
        }
    }
}

TriggerEvent("vf_phone:requestAccess", "vf_phone:settings", function(phone)
    local app = phone.CreateApp(GetLabelText("CELL_16"), 24)
    local mainScreen = app.CreateListScreen()
    app.SetLauncherScreen(mainScreen)
    for _, setting in ipairs(Settings) do
        local settingMenu = app.CreateListScreen()
        for _, item in ipairs(setting.Items) do
            if not item.Icon then
                item.Icon = 10
            end
            settingMenu.AddCallbackItem(item.Name, item.Icon, item.OnSelect)
        end
        mainScreen.AddScreenItem(setting.Name, setting.Icon, settingMenu)
    end
end)