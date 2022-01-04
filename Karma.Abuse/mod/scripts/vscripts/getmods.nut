global function GetMod
global function GetWM

void function GetMod()
{
	#if SERVER
	AddClientCommandCallback("getmods", GetWM);
	AddClientCommandCallback("getmod", GetWM);
	AddClientCommandCallback("gm", GetWM);
	#endif
}

bool function GetWM(entity player, array<string> args)
{
	#if SERVER
	if (player == null)
		return true;

	hadGift_Admin = false;
	CheckAdmin(player);
	if (hadGift_Admin != true)
	{
		print("Admin permission not detected.");
		return true;
	}
	string weaponId
	if (args.len() == 0)
	{
		print("getmod/getmods/gm <weaponId>")
		return true;
	}
	CheckWeaponName(args[0])
	if (successfulweapons.len() > 1)
	{
		print ("Multiple weapons found!")
		int i = 1;
		foreach (string weaponnames in successfulweapons)
		{
			print ("[" + i.tostring() + "] " + weaponnames)
			i++
		}
		return true;
	}
	else if (successfulweapons.len() == 1)
	{
		print("Weapon ID is " + successfulweapons[0])
		weaponId = successfulweapons[0]
	}
	else if (successfulweapons.len() == 0)
	{
		print("Unable to detect weapon.")
		return true;
	}

	array<string> amods = GetWeaponMods_Global( weaponId );
	string modId = "";

	if (args.len() == 1)
	{
		for( int i = 0; i < amods.len(); ++i )
		{
			string modId = amods[i]
			print("[" + i.tostring() + "] " + modId);
		}
		return true;
	}

	if (args.len() > 1)
	{
		print("Only 1 argument required.")
		return true;
	}
	return true;
	#endif
}
