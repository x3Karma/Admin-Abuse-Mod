untyped

global function SpawnViper
global function AddCommands
global function SpawnTitan

global function registerFunctions
global function registerFunctionsAfter
// global function Respawn



global int TitanGroup = 0
global const currentTitanId = ["npc_titan_atlas_tracker",
							"npc_titan_atlas_tracker_fd_sniper",
							"npc_titan_atlas_tracker_mortar",
							"npc_titan_atlas_tracker_boss_fd",
							"npc_titan_atlas_vanguard",
							"npc_titan_atlas_vanguard_boss_fd",
							"npc_titan_ogre_meteor",
							"npc_titan_ogre_meteor_boss_fd",
							"npc_titan_ogre_minigun",
							"npc_titan_ogre_minigun_boss_fd",
							"npc_titan_ogre_minigun_nuke",
							"npc_titan_stryder_leadwall",
							"npc_titan_stryder_leadwall_arc",
							"npc_titan_stryder_leadwall_boss_fd",
							"npc_titan_stryder_leadwall_shift_core",
							"npc_titan_stryder_rocketeer",
							"npc_titan_stryder_rocketeer_dash_core",
							"npc_titan_stryder_sniper",
							"npc_titan_stryder_sniper_boss_fd",
							"npc_titan_stryder_sniper_fd",
							"npc_titan_atlas_stickybomb",
							"npc_titan_atlas_stickybomb_boss_fd"];


void function registerFunctions()
{
	Remote_RegisterFunction("SpawnViper");
	Remote_RegisterFunction("SpawnTitan");
}
void function registerFunctionsAfter()
{
	// Remote_RegisterFunction("Respawn");
}
void function AddCommands()
{
	#if SERVER
	AddClientCommandCallback("cycletitanid", cycleTitanId);
	AddClientCommandCallback("spawntitan", SpawnTitan);
	AddClientCommandCallback("spawnviper", SpawnViper);
	AddClientCommandCallback("rpwn", rpwn);
	AddClientCommandCallback("respawn", rpwn);
	#endif
}

bool function SpawnTitan(entity a, array<string> args)
{
#if SERVER
	entity player = GetPlayerArray()[0];
	vector origin = GetPlayerCrosshairOrigin( player );
	vector angles = player.EyeAngles();
	angles.x = 0;
	angles.z = 0;
	string titanId = currentTitanId[TitanGroup];

	vector spawnPos = origin;
	vector spawnAng = angles;
	int team = TEAM_BOTH;
	var teamTagPos = titanId.find( "#" )
	entity spawnNpc = CreateNPCTitan( "npc_titan", team, spawnPos, spawnAng, [] );
	SetSpawnOption_NPCTitan( spawnNpc, TITAN_HENCH );
	SetSpawnOption_AISettings( spawnNpc, titanId );
	DispatchSpawn( spawnNpc );
	#endif
	return true;
}

bool function cycleTitanId(entity player, array<string> args)
{
	TitanGroup++;
	if (TitanGroup == 22) {
	TitanGroup = 0; }

	#if SERVER
	print(currentTitanId[TitanGroup]);
	#endif
	return true;
}

bool function rpwn(entity player, array<string> args)
{
#if SERVER
	hadGift_Admin = false;
	CheckAdmin(player);
	if (hadGift_Admin != true)
	{
		print("Admin permission not detected.");
		return true;
	}
	// if player only typed rpwn/respawn with no further arguments
	if (args.len() == 0)
	{
		print("Give a valid argument.");
		print("Example: rpwn/respawn <playername> <playername2> ... / imc / militia / all");
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

	array<entity> players = GetPlayerArray();
	switch (args[0])
	{
		case ("all"):
			foreach (entity p in GetPlayerArray())
			{
				if (p != null)
					Respawn(p)
			}
		break;

		case ("imc"):
			foreach (entity p in GetPlayerArrayOfTeam( TEAM_IMC ))
			{
				if (p != null)
					Respawn(p)
			}
		break;

		case ("militia"):
			foreach (entity p in GetPlayerArrayOfTeam( TEAM_MILITIA ))
			{
				if (p != null)
					Respawn(p)
			}
		break;

		default:
            CheckPlayerName(args[0])
				foreach (entity p in successfulnames)
                    Respawn(p)
		break;
	}
	if (args.len() > 1) {
		array<string> playersname = args.slice(1);
		foreach (string playerId in playersname)
		{
            CheckPlayerName(playerId)
				foreach (entity p in successfulnames)
                    Respawn(p)
		}
	}

#endif
	return true;
}

void function Respawn(entity player)
{
#if SERVER
	try {
	player.RespawnPlayer(null);
	} catch(e) {}
#endif
}

bool function SpawnViper(entity player, array<string> args)
{
#if SERVER
	const CROSSHAIR_VERT_OFFSET = 32;
	string bossId = "Viper";

	TitanLoadoutDef ornull loadout = GetTitanLoadoutForBossCharacter( bossId );
	printt("loadout is null: ", loadout == null );
	if ( loadout == null )
	{
		return true;
	}
	expect TitanLoadoutDef( loadout );
	string baseClass = "npc_titan";
	string aiSettings = GetNPCSettingsFileForTitanPlayerSetFile( loadout.setFile );

	entity player = GetPlayerByIndex( 0 );
	vector origin = GetPlayerCrosshairOrigin( player );
	vector angles = Vector( 0, 0, 0 );
	entity npc = CreateNPC( baseClass, TEAM_IMC, origin, angles );
	if ( IsTurret( npc ) )
	{
		npc.kv.origin -= Vector( 0, 0, CROSSHAIR_VERT_OFFSET );
	}
	SetSpawnOption_AISettings( npc, aiSettings );

	if ( npc.GetClassName() == "npc_titan" )
	{
		string builtInLoadout = expect string( Dev_GetAISettingByKeyField_Global( aiSettings, "npc_titan_player_settings" ) )
		SetTitanSettings( npc.ai.titanSettings, builtInLoadout );
		npc.ai.titanSpawnLoadout.setFile = builtInLoadout;
		OverwriteLoadoutWithDefaultsForSetFile( npc.ai.titanSpawnLoadout ); // get the entire loadout, including defensive and tactical
	}

	SetSpawnOption_NPCTitan( npc, TITAN_MERC );
	SetSpawnOption_TitanLoadout( npc, loadout );
	npc.ai.bossTitanPlayIntro = false;
	DispatchSpawn( npc );
	return true;
	#endif
}