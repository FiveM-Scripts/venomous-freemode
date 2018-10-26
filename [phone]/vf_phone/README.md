# vf_phone

A phone resource which uses built-in natives and scaleforms instead of being built on top of NUI.

Uses functionality from `vf_utils`

## Developing

Docs coming soon, have an example for now:

```lua
AddEventHandler("vf_phone:setup", function(Phone)
	local app = Phone.CreateApp("Hello World", 24) -- Name and Icon
	local mainScreen = app.CreateListScreen() -- Creates a new List Screen
	app.SetLauncherScreen(mainScreen) -- Sets it as "main" screen (this screen will be shown when app is launched)
	mainScreen.AddCallbackItem("I do nothing") -- Create Item named "I do nothing" without icon or callback
	mainScreen.AddCallbackItem("Hello", 0, function() print("World") end) -- Name, Icon and Callback
	mainScreen.AddScreenItem("Don't Click", 0, app.CreateListScreen()) -- Name, Icon and Screen to show on select (In this case an empty one)
end)
```