local App
local ContactsScreen

local function Lester_RemoveWanted()

end

local Contacts = {
    { Name = "Lester", Actions = { { Name = "Remove Wanted Level", Handler = Lester_RemoveWanted } } }
}

AddEventHandler("vf_baseapps:setup", function(phone)
    --[[App = phone.CreateApp(GetLabelText("CELL_0"), 11)
    ContactsScreen = App.CreateListScreen()
    App.SetLauncherScreen(ContactsScreen)

    for _, contact in pairs(Contacts) do
        local contactActionsMenu = App.CreateListScreen()

        ContactsScreen.AddScreenItem(contact.Name, 1, contactActionsMenu)
        
        for _, action in pairs(contact.Actions) do
            contactActionsMenu.AddCallbackItem(action.Name, 0, action.Handler)
        end
    end]]--
end)