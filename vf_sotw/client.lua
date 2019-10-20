-- Configure the weed products
weedItems = {
    {text="Amnesia Haze", price=12},
    {text="Black Domina", price=15},
    {text="Blue Cheese", price=15},
    {text="Bubblegum", price=9},
    {text="Cheeze Haze", price=9},
    {text="Dr.Grinspoon", price=18},
    {text="G13 Haze", price=15},
    {text="Liberty Haze", price=17},
    {text="Mexican Haze", price=12},
    {text="N.L.X", price=6},
    {text="Silver Haze", price=12},
    {text="Smoke mix", price=5},
    {text="Utopia Kush", price=17},
    {text="Vanilla Kush", price=15},
    {text="White Widow", price=9}
}

_weedPool = MenuPool.New()
weedMenu = UIMenu.New(GetLabelText("PN_WEED"), '~b~' .. GetLabelText("SHOP_L_ITEMS"))
_weedPool:Add(weedMenu)

local function DisplayHelpTextTimed(text, time)
	BeginTextCommandDisplayHelp("STRING")
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayHelp(0, 0, 1, tonumber(time))
end

function AddWeedMenu(menu)
	for k,v in pairs(weedItems) do
		local item = UIMenuItem.New(v.text, '')
		item:RightLabel(GetLabelText('BB_CASHAMT') .. ' ' .. v.price)
		menu:AddItem(item)

		item.Activated = function(ParentMenu, SelectedItem)
		    if SelectedItem == item then
		    	TriggerServerEvent('sotw:purchase', v.price)
		    	menu:Visible(not menu:Visible())
		    end
		end
    end
end

Citizen.CreateThread(function()
	AddWeedMenu(weedMenu)
	_weedPool:MouseControlsEnabled(false)
	_weedPool:RefreshIndex()

	storeBlip = AddBlipForCoord(-1172.406, -1572.292, 4.664)
	SetBlipSprite(storeBlip, 140)
	SetBlipColour(storeBlip, 15)
	SetBlipAsShortRange(storeBlip, true)
	SetBlipNameFromTextFile(storeBlip, "EMSTR_437")

	SetBlipScale(storeBlip, 0.8)

	while true do
		_weedPool:ProcessMenus()
		x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
		DrawMarker(1, -1172.406, -1572.292, 4.664-1.0001, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 107, 218, 16, 155, 0, 0, 2, 0, 0, 0, 0)
		
		if GetDistanceBetweenCoords(x, y, z, -1172.406, -1572.292, 4.664, true) < 0.6 then
			DisplayHelpTextTimed(GetLabelText("SHR_MENU"), 8000)
			if IsControlJustPressed(1, 51) then
				weedMenu:Visible(not weedMenu:Visible())
			end
		end

		Wait(1)
	end
end)


Citizen.CreateThread(function()
	while true do
		Wait(1)
		if toxicated then
			Wait(120000)
			if HasClipSetLoaded("MOVE_M@DRUNK@SLIGHTLYDRUNK") then
				ClearTimecycleModifier()
				SetPedMotionBlur(PlayerPedId(), false)

				ResetPedMovementClipset(PlayerPedId(), 0.0)
				ResetScenarioTypesEnabled()
				StopGameplayCamShaking(true)
				StopScreenEffect("DrugsMichaelAliensFightIn")
				RemoveClipSet("MOVE_M@DRUNK@SLIGHTLYDRUNK")
			end
			toxicated = false
		end
	end
end)

RegisterNetEvent("sotw:buyweed")
AddEventHandler("sotw:buyweed", function()
	RequestClipSet("MOVE_M@DRUNK@SLIGHTLYDRUNK")	
	while not HasClipSetLoaded("MOVE_M@DRUNK@SLIGHTLYDRUNK") do
		Wait(0)
	end

	TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_DRUG_DEALER", 0, -1)	
	buyweed = true

	while buyweed do
		Wait(10000)
		ClearPedTasks(PlayerPedId())
		FreezeEntityPosition(PlayerPedId(), false)
		buyweed = false
	end

	ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE", 0.5)
	SetPedMovementClipset(PlayerPedId(), "MOVE_M@DRUNK@SLIGHTLYDRUNK", 1048576000)
	SetPedMotionBlur(PlayerPedId(), true)
	StartScreenEffect("DrugsMichaelAliensFightIn", -1, false)

	SetTimecycleModifier("Drug_deadman_blend")
	toxicated = true
end)