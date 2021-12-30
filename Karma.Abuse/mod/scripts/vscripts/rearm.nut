global function Rearm
global function RearmCommand

void function RearmCommand()
{
	#if SERVER
	AddClientCommandCallback("rearm", RearmCMD);
	#endif
}

bool function RearmCMD(entity player, array<string> args)
{
	#if SERVER
	array<entity> players = GetPlayerArray();
	hadGift_Admin = false;
	CheckAdmin(player);
	if (hadGift_Admin != true)
	{
		print("Admin permission not detected.");
		return true;
	}

	// if player only typed "rearm"
	if (args.len() == 0)
	{
		print("Give a valid argument.");
		print("Example: rearm <playerID> <playerID2> <playerID3> ... / imc / militia / all");
		// print every single player's name and their id
		int i = 0;
		foreach (entity p in GetPlayerArray())
		{
			string playername = p.GetPlayerName();
			print("[" + i.tostring() + "] " + playername);
			i++
		}
		return true;
	}

	switch (args[0])
	{
		case ("all"):
			foreach (entity p in GetPlayerArray())
			{
				if (p != null)
					Rearm(p)
			}
		break;

		case ("imc"):
			foreach (entity p in GetPlayerArrayOfTeam( TEAM_IMC ))
			{
				if (p != null)
					Rearm(p)
			}
		break;

		case ("militia"):
			foreach (entity p in GetPlayerArrayOfTeam( TEAM_MILITIA ))
			{
				if (p != null)
					Rearm(p)
			}
		break;

		default:
			if (CheckPlayerName(args[0]))
				foreach (entity p in successfulnames)
                    Rearm(p)
		break;
	}
	if (args.len() > 1) {
		array<string> playersname = args.slice(1);
		foreach (string playerId in playersname)
		{
            if (CheckPlayerName(playerId))
				foreach (entity p in successfulnames)
                    Rearm(p)
		}
	}

	#endif
	return true;
}

void function Rearm(entity player)
{
#if SERVER
	entity weapon = null;
	try {
		foreach (weapon in player.GetOffhandWeapons())
		{
			if (weapon == null)
				break;
			else
			{
				weapon.SetWeaponPrimaryClipCount( weapon.GetWeaponPrimaryClipCountMax() );
				if (player.IsTitan()) {
					player.Server_SetDodgePower(100.0);
					entity soul = player.GetTitanSoul();
					SoulTitanCore_SetNextAvailableTime( soul, 100.0 );
				}
				print("Rearmed " + player.GetPlayerName() + "!")
			}
		}
	} catch(e)
	{
	}
#endif
}