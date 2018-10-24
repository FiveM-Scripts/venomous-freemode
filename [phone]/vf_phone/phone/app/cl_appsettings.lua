local function _SetTheme(theme)
    Phone.Theme = theme
    SetResourceKvpInt("vf_phone_theme", theme)
end

local function _SetWallpaper(wallpaper)
    Phone.Wallpaper = wallpaper
    SetResourceKvpInt("vf_phone_wallpaper", wallpaper)
end

local _Settings = {
    {
        Name = GetLabelText("CELL_720"),
        Icon = 23,
        Items = {
            {
                Name = GetLabelText("CELL_820"),
                OnSelect = function()
                    _SetTheme(1)
                end
            },
            {
                Name = GetLabelText("CELL_821"),
                OnSelect = function()
                    _SetTheme(2)
                end
            },
            {
                Name = GetLabelText("CELL_822"),
                OnSelect = function()
                    _SetTheme(3)
                end
            },
            {
                Name = GetLabelText("CELL_823"),
                OnSelect = function()
                    _SetTheme(4)
                end
            },
            {
                Name = GetLabelText("CELL_824"),
                OnSelect = function()
                    _SetTheme(5)
                end
            },
            {
                Name = GetLabelText("CELL_825"),
                OnSelect = function()
                    _SetTheme(6)
                end
            },
            {
                Name = GetLabelText("CELL_826"),
                OnSelect = function()
                    _SetTheme(7)
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
                    _SetWallpaper(4)
                end
            },        
            {
                Name = GetLabelText("CELL_845"),
                OnSelect = function()
                    _SetWallpaper(5)
                end
            },
            {
                Name = GetLabelText("CELL_846"),
                OnSelect = function()
                    _SetWallpaper(6)
                end
            },
            {
                Name = GetLabelText("CELL_847"),
                OnSelect = function()
                    _SetWallpaper(7)
                end
            },
            {
                Name = GetLabelText("CELL_848"),
                OnSelect = function()
                    _SetWallpaper(8)
                end
            },
            {
                Name = GetLabelText("CELL_849"),
                OnSelect = function()
                    _SetWallpaper(9)
                end
            },
            {
                Name = GetLabelText("CELL_850"),
                OnSelect = function()
                    _SetWallpaper(10)
                end
            },
            {
                Name = GetLabelText("CELL_851"),
                OnSelect = function()
                    _SetWallpaper(11)
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
AddEventHandler("vf_phone:setup", function()
    local app = CreateApp(GetLabelText("CELL_16"), 24)
    local mainScreen = app.CreateListScreen()
    app.SetLauncherScreen(mainScreen)
    for _, setting in ipairs(_Settings) do
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