# vf_phone

A phone resource which uses built-in natives and scaleforms instead of being built on top of NUI.

Uses functionality from `vf_utils`

## Developing

Docs coming soon, have an example for now:

```lua
AddEventHandler("vf_phone:setup", function()
	local app = CreateApp("Hello World", 24)
	local mainScreen = app.CreateListScreen()
	app.SetLauncherScreen(mainScreen)
	mainScreen.AddCallbackItem("Hello", 0, function() print("World") end)
	mainScreen.AddScreenItem("Don't Click", 0, app.CreateListScreen())
end)
```