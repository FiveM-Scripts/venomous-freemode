storeGroups = {
   {["name"] = GetLabelText("VAULT_WMENUT_8"), ["id"] = "explosives"},
   {["name"] = GetLabelText("VAULT_WMENUT_2"), ["id"] = "pistols"},
   {["name"] = GetLabelText("VAULT_WMENUT_7"), ["id"] = "heavyweapons"},
   {["name"] = GetLabelText("VAULT_WMENUT_9"), ["id"] = "melee"},
   {["name"] = GetLabelText("VAULT_WMENUT_5"), ["id"] = "assaultrifle"},
   {["name"] = GetLabelText("VAULT_WMENUT_3"), ["id"] = "shotguns"},
   {["name"] = GetLabelText("VAULT_WMENUT_6"), ["id"] = "sniperrifle"},
 }

StoreWeapons = {
	{ ["id"] = "pistols",
	  ["items"] = {
	    {model="WEAPON_APPISTOL", name="AP Pistol", price = 5000},
	    {model="WEAPON_COMBATPISTOL", name="Combat Pistol", price = 3200},
	    {model="WEAPON_DOUBLEACTION", name="Double-Action Revolver", price = 5400},
	    {model="WEAPON_HEAVYPISTOL", name="Heavy Pistol", price = 3375},
	    {model="WEAPON_REVOLVER", name="Heavy Revolver", price = 5400},
	    {model="WEAPON_REVOLVER_MK2", name="Revolver Mk ||", price = 5420},
	    {model="WEAPON_MARKSMANPISTOL", name="Marksman Pistol", price = 4350},
	    {model="WEAPON_PISTOL", name="Pistol", price = 2500},
	    {model="WEAPON_PISTOL50", name="Pistol .50", price = 3375},
	    {model="WEAPON_PISTOL_MK2", name="Pistol MK2", price = 3900},
	    {model="WEAPON_SNSPISTOL", name="SNS Pistol", price = 2750},
	    {model="WEAPON_SNSPISTOL_MK2", name="SNS Pistol Mk ||", price = 3900}
	   }
    },
	{ ["id"] = "melee",
	  ["items"] = {
	    {model="WEAPON_CROWBAR", name="Crowbar", price = 90},
	    {model="WEAPON_KNIFE", name="Knife", price = 90},
	    {model="WEAPON_HAMMER", name="Hammer", price = 3200},
	    {model="WEAPON_HATCHET", name="Hatchet", price = 3900},
	    {model="WEAPON_PETROLCAN", name="Jerry Can", price = 22},
	   }
    },

	{ ["id"] = "assaultrifle",
	  ["items"] = {
	    {model="WEAPON_ASSAULTRIFLE", name="Assault Rifle", price = 1250},
	    {model="WEAPON_ASSAULTRIFLE_MK2", name="Assault Rifle Mk2", price = 1450},
	    {model="WEAPON_BULLPUPRIFLE", name="Bullpup Rifle", price = 1500},
	    {model="WEAPON_CARBINERIFLE", name="Carbine Rifle", price = 13000},
	    {model="WEAPON_COMPACTRIFLE", name="Compact Rifle", price = 14650},
	    {model="WEAPON_SPECIALCARBINE", name="Special Carbine", price = 14650}
	   }
    },
	{ ["id"] = "explosives",
	  ["items"] = {
	    {model="WEAPON_GRENADE", name="Grenade", price = 250	},
	    {model="WEAPON_MOLOTOV", name="Molotov Cocktail", price = 300},
	    {model="WEAPON_PIPEBOMB", name="Pipe Bomb", price = 500},
	    {model="WEAPON_PROXMINE", name="Proximity Mine", price = 675},
	    {model="WEAPON_STICKYBOMB", name="Sticky Bomb", price = 600},
	   }
    },    
	{ ["id"] = "heavyweapons",
	  ["items"] = {
	    {model="WEAPON_COMPACTLAUNCHER", name="Compact Grenade Launcher", price = 1250},
	    {model="WEAPON_FIREWORK", name="Firework Launcher", price = 1450},
	    {model="WEAPON_GRENADELAUNCHER", name="Grenade Launcher", price = 1650},
	    {model="WEAPON_HOMINGLAUNCHER", name="Homing Launcher", price=75000},
	    {model="WEAPON_MINIGUN", name="Minigun", price=50000},
	    {model="WEAPON_RAILGUN", name="Railgun", price=187500},
	    {model="WEAPON_RPG", name="Rocket Launcher", price=26250}
	   }
    },
	{ ["id"] = "shotguns",
	  ["items"] = {
	    {model="WEAPON_AUTOSHOTGUN", name="Assault Shotgun", price = 149000},
	    {model="WEAPON_ASSAULTSHOTGUN", name="Bullpup Shotgun", price = 100000},
	    {model="WEAPON_BULLPUPSHOTGUN", name="Double Barrel Shotgun ", price = 80000},
	    {model="WEAPON_HEAVYSHOTGUN", name="Heavy Shotgun", price = 135500},
	    {model="WEAPON_MUSKET", name="Musket", price = 192600},
	    {model="WEAPON_PUMPSHOTGUN", name="Pump Shotgun", price = 35000},
	    {model="WEAPON_PUMPSHOTGUN_MK2",name="Pump Shotgun Mk2", price = 38000},
	    {model="WEAPON_SAWNOFFSHOTGUN", name="Sawed-Off Shotgun", price = 3000},
	    {model="WEAPON_DBSHOTGUN", name="Sweeper Shotgun", price = 3000}
	   }
    },    
	{ ["id"] = "sniperrifle",
	  ["items"] = {
	    {model="WEAPON_HEAVYSNIPER", name="Heavy Sniper", price = 381500},
	    {model="WEAPON_MARKSMANRIFLE", name="Marksman Rifle", price = 157500},
	    {model="WEAPON_MARKSMANRIFLE_MK2", name="Marksman Rifle Mk2", price = 197500},
	    {model="WEAPON_SNIPERRIFLE", name="Sniper Rifle", price = 200000}
	   }
    },
}