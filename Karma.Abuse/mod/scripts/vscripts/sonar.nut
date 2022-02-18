global function Sonar
global function SonarCommand
global function SonarCMD

void function SonarCommand()
{
	#if SERVER
	AddClientCommandCallback("sonar", SonarCMD);
	AddClientCommandCallback("testsonar", TestSonarCMD);
	#endif
}

bool function SonarCMD(entity player, array<string> args)
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

	// if player only typed "sonar"
	if (args.len() == 0)
	{
		print("Give a valid argument.");
		print("Example: sonar <playerID> <playerID2> <playerID3> ... / imc / militia / all");
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
    array<entity> sheep1
	switch (args[0])
	{
		case ("all"):
			foreach (entity p in GetPlayerArray())
			{
				if (p != null)
					sheep1.append(p)
			}
		break;

		case ("imc"):
			foreach (entity p in GetPlayerArrayOfTeam( TEAM_IMC ))
			{
				if (p != null)
					sheep1.append(p)
			}
		break;

		case ("militia"):
			foreach (entity p in GetPlayerArrayOfTeam( TEAM_MILITIA ))
			{
				if (p != null)
					sheep1.append(p)
			}
		break;

		default:
            CheckPlayerName(args[0])
				foreach (entity p in successfulnames)
                    sheep1.append(p)
		break;
	}

    if (args.len() == 1 )
    {
        print("Please insert a duration.")
        return true;
    }
    int duration
    if (args.len() > 1)
    {
        duration = args[1].tointeger()
    }

	if (args.len() > 2) {
		print("Only two arguments required.")
        return true;
	}

    foreach (entity play in sheep1)
    {
        thread Sonar(play, duration)
    }
	#endif
	return true;
}

void function Sonar(entity player, int duration)
{
#if SERVER
    float dur = duration.tofloat()
	StatusEffect_AddTimed( player, eStatusEffect.sonar_detected, 1.0, dur, 0.0 )
    Highlight_SetEnemyHighlight( player, "enemy_sonar" )
    wait duration
    if (Hightlight_HasEnemyHighlight(player, "enemy_sonar"))
        Highlight_ClearEnemyHighlight( player )
#endif
}

bool function TestSonarCMD(entity player, array<string> args)
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

	// if player only typed "sonar"
	if (args.len() == 0)
	{
		print("Give a valid argument.");
		print("Example: sonar <playerID> <playerID2> <playerID3> ... / imc / militia / all");
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
    array<entity> sheep1
	switch (args[0])
	{
		case ("all"):
			foreach (entity p in GetPlayerArray())
			{
				if (p != null)
					sheep1.append(p)
			}
		break;

		case ("imc"):
			foreach (entity p in GetPlayerArrayOfTeam( TEAM_IMC ))
			{
				if (p != null)
					sheep1.append(p)
			}
		break;

		case ("militia"):
			foreach (entity p in GetPlayerArrayOfTeam( TEAM_MILITIA ))
			{
				if (p != null)
					sheep1.append(p)
			}
		break;

		default:
            CheckPlayerName(args[0])
				foreach (entity p in successfulnames)
                    sheep1.append(p)
		break;
	}

	if (args.len() > 1) {
		print("Only one arguments required.")
        return true;
	}

    foreach (entity play in sheep1)
    {
        thread TestSonar(play)
    }
	#endif
	return true;
}

const int MAPHACK_PULSE_COUNT = 4
const float MAPHACK_PULSE_DELAY = 2.0

void function TestSonar( entity player )
{
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDeath" )

	// todo: potentially look into ScanMinimap in _passives for doing this better? boost is pretty likely based off it pretty heavily
	for ( int i = 0; i < MAPHACK_PULSE_COUNT; i++ )
	{
		EmitSoundOnEntityOnlyToPlayer( player, player, "Burn_Card_Map_Hack_Radar_Pulse_V1_1P" )
		array<entity> aliveplayers = GetPlayerArray()
		foreach ( entity otherPlayer in GetPlayerArray() )
		{
			Remote_CallFunction_Replay( otherPlayer, "ServerCallback_SonarPulseFromPosition", player.GetOrigin().x, player.GetOrigin().y, player.GetOrigin().z, 2000)

			if ( otherPlayer.GetTeam() != player.GetTeam() && aliveplayers.find(otherPlayer) != -1 )
			{
				MapHackSonar(player, otherPlayer)
			}
		}
		wait MAPHACK_PULSE_DELAY
		foreach ( entity otherPlayer in GetPlayerArray() )
		{
			if ( otherPlayer.GetTeam() != player.GetTeam() && aliveplayers.find(otherPlayer) != -1 ) {
				MapHackSonarStop(player, otherPlayer)
			}
		}
	}
}

void function MapHackSonar(entity player, entity otherPlayer)
{
	StatusEffect_AddTimed( otherPlayer, eStatusEffect.maphack_detected, 1.0, MAPHACK_PULSE_DELAY / 2, 0.0 )
	Highlight_SetEnemyHighlight( otherPlayer, "enemy_sonar" )
	Highlight_SetSonarHighlightWithParam1( otherPlayer, "enemy_sonar", player.GetOrigin() )
	Highlight_SetSonarHighlightOrigin( otherPlayer, player.GetOrigin() )
	otherPlayer.HighlightEnableForTeam( player.GetTeam() )
}
void function MapHackSonarStop(entity player, entity otherPlayer)
{
	otherPlayer.HighlightDisableForTeam( player.GetTeam() )
	otherPlayer.HighlightSetTeamBitField( 0 )
	if (Hightlight_HasEnemyHighlight( otherPlayer, "enemy_sonar"))
        Highlight_ClearEnemyHighlight( otherPlayer )
}