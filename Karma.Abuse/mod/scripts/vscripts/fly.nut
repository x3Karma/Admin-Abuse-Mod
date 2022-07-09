global function FlyCommand
global function Fly
global function FlyCMD

void function FlyCommand()
{
	#if SERVER
	AddClientCommandCallback("fly", FlyCMD);
	#endif
}

bool function FlyCMD(entity player, array<string> args)
{
	#if SERVER
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
		Kprint( player, "Example: fly <playerId> <playerId2> ... / imc / militia / all");
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
	// if player typed "fly somethinghere"
	switch (args[0])
	{
		case ("all"):
			foreach (entity p in GetPlayerArray())
			{
				if (p != null)
					Fly(p)
			}
		break;

		case ("imc"):
			foreach (entity p in GetPlayerArrayOfTeam( TEAM_IMC ))
			{
				if (p != null)
					Fly(p)
			}
		break;

		case ("militia"):
			foreach (entity p in GetPlayerArrayOfTeam( TEAM_MILITIA ))
			{
				if (p != null)
					Fly(p)
			}
		break;

		default:
			CMDsender = player
            CheckPlayerName(args[0])
				foreach (entity p in successfulnames)
                    Fly(p)
		break;
	}
	if (args.len() > 1) 
	{
		CMDsender = player
		array<string> playersname = args.slice(1);
		foreach (string playerId in playersname)
		{
            CheckPlayerName(playerId)
				foreach (entity p in successfulnames)
                    Fly(p)
		}
	}
	#endif
	return true;
}

void function Fly( entity player )
{
	#if SERVER
	if ( player.IsNoclipping() )
	{
		player.SetPhysics( MOVETYPE_WALK )
		Kprint( CMDsender, player.GetPlayerName() + " stopped noclipping.")
	}
	else
	{
		player.SetPhysics( MOVETYPE_NOCLIP )
		Kprint( CMDsender, player.GetPlayerName() + " started noclipping.")
	}
#endif
}
