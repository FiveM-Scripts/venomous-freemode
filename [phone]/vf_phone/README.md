# vf_phone

A phone resource which uses built-in natives and scaleforms instead of being built on top of NUI.

Uses functionality from `vf_utils`

## Developing

Docs coming soon, have an example for now:

```lua
AddEventHandler("vf_phone:setup", function()
	local app = exports.vf_phone:CreateApp("Hello World", 24) -- Name and Icon
	local mainScreen = app.CreateListScreen() -- Creates a new List Screen
	app.SetLauncherScreen(mainScreen) -- Sets it as "main" screen (this screen will be shown when app is launched)
	mainScreen.AddDummyItem("I'm a dummy", 0) -- Name and Icon
	mainScreen.AddCallbackItem("Hello", 0, function() print("World") end) -- Name, Icon and Callback
	mainScreen.AddScreenItem("Don't Click", 0, app.CreateListScreen()) -- Name, Icon and Screen
end)
```