# vf_phone

A phone resource which uses built-in natives and scaleforms instead of being built on top of NUI.

Uses functionality from `vf_utils`

## Developing

To externally add a new app to the phone, hook onto the `vf_phone:setup` call and pass a table with all the information to the `vf_phone:addApp` event.

Here's an example app:
```lua
AppTest = {
    AppName = "Hello World", -- App Name to be shown on the app drawer and header
    AppIcon = 13, -- App Icon to be shown on the app drawer
    OverrideBack = true -- Override backspace killing the app (useful for apps with sub-menus)
}

function AppTest.Init(phoneScaleform --[[ The phone's scaleform to draw the app on ]], kill --[[ Function to call for app kill ]])
    -- Called on app start
end

function AppTest.Tick()
    -- Called every tick
end

function AppTest.Kill()
    -- Called on app kill
end

AddEventHandler("vf_phone:setup", function()
    -- Add the app by passing the AppTest table
    TriggerEvent("vf_phone:addApp", AppTest)
end)
```