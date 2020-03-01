local _App
local _PlayerListScreen

local function Lester_RemoveWanted()

end

local _Contacts = {
    { Name = "Lester", Actions = { { Name = "Remove Wanted Level", Handler = Lester_RemoveWanted } } }
}

AddEventHandler("vf_baseapps:setup", function(phone)
    return

    _App = phone.CreateApp(GetLabelText("CELL_0"), 11)
    _ContactsScreen = _App.CreateListScreen()
    _App.SetLauncherScreen(_ContactsScreen)

    for _, contact in pairs(_Contacts) do
        local contactActionsMenu = _App.CreateListScreen()

        _ContactsScreen.AddScreenItem(contact.Name, 1, contactActionsMenu)
        
        for _, action in pairs(contact.Actions) do
            contactActionsMenu.AddCallbackItem(action.Name, 0, action.Handler)
        end
    end
end)