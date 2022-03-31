global function Slay
global function SlayCommand
global function SlayCMD

void function SlayCommand()
{
	#if SERVER
	AddClientCommandCallback("slay", SlayCMD);
	#endif
}

bool function SlayCMD(entity player, array<string> args)
{
	#if SERVER
	array<entity> players = GetPlayerArray();
	hadGift_Admin = false;
	CheckAdmin(player);
	if (hadGift_Admin != true)
	{
		Kprint( player, "Admin permission not detected.");
		return true;
	}

	// if player only typed "gift"
	if (args.len() == 0)
	{
		Kprint( player, "Give a valid argument.");
		Kprint( player, "Example: slay <playerID> <playerID2> <playerID3> ... / imc / militia / all");
		// print every single player's name and their id
		int i = 0;
		foreach (entity p in GetPlayerArray())
		{
			string playername = p.GetPlayerName();
			Kprint( player, "[" + i.tostring() + "] " + playername);
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
					Slay(p)
			}
		break;

		case ("imc"):
			foreach (entity p in GetPlayerArrayOfTeam( TEAM_IMC ))
			{
				if (p != null)
					Slay(p)
			}
		break;

		case ("militia"):
			foreach (entity p in GetPlayerArrayOfTeam( TEAM_MILITIA ))
			{
				if (p != null)
					Slay(p)
			}
		break;

		default:
            CheckPlayerName(args[0])
				foreach (entity p in successfulnames)
                    Slay(p)
		break;
	}
	if (args.len() > 1) {
		array<string> playersname = args.slice(1);
		foreach (string playerId in playersname)
		{
            CheckPlayerName(playerId)
				foreach (entity p in successfulnames)
                    Slay(p)

		}
	}

	#endif
	return true;
}

void function Slay(entity player)
{
#if SERVER
	try {
		if ( IsAlive( player ) )
		{
			player.Die()
			Kprint( player, "Slayed " + player.GetPlayerName() + "!")
		}
	} catch(e)
	{
		Kprint( player, "Unable to slay " + player.GetPlayerName() + ". Could be unalive lol.")
	}
#endif
}