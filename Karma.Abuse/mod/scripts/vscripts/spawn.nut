global function SpawnCommand


void function SpawnCommand()
{
	#if SERVER
	AddClientCommandCallback("spawn", SpawnCMD);

    //Precache models to spawn units :)

    // drones
    PrecacheModel($"models/robots/drone_air_attack/drone_air_attack_plasma.mdl")
    PrecacheModel($"models/robots/drone_air_attack/drone_air_attack_rockets.mdl")
    PrecacheModel($"models/robots/drone_air_attack/drone_air_attack_static.mdl")
    PrecacheModel($"models/robots/drone_air_attack/drone_attack_pc_1.mdl")
    PrecacheModel($"models/robots/drone_air_attack/drone_attack_pc_2.mdl")
    PrecacheModel($"models/robots/drone_air_attack/drone_attack_pc_3.mdl")
    PrecacheModel($"models/robots/drone_air_attack/drone_attack_pc_4.mdl")
    PrecacheModel($"models/robots/drone_air_attack/drone_attack_pc_5.mdl")
    //gunship
    PrecacheModel($"models/vehicle/straton/straton_imc_gunship_01.mdl")
    PrecacheModel($"models/vehicle/straton/straton_imc_gunship_01_1000x.mdl")
    PrecacheModel($"models/vehicle/straton/straton_imc_gunship_afterburner.mdl")
    PrecacheModel($"models/robots/aerial_unmanned_worker/aerial_unmanned_worker.mdl")
    //worker drone
    PrecacheModel($"models/robots/aerial_unmanned_worker/worker_drone_pc1.mdl")
    PrecacheModel($"models/robots/aerial_unmanned_worker/worker_drone_pc2.mdl")
    PrecacheModel($"models/robots/aerial_unmanned_worker/worker_drone_pc3.mdl")
    PrecacheModel($"models/robots/aerial_unmanned_worker/worker_drone_pc4.mdl")
    //plsma turret
    PrecacheModel($"models/robotics_r2/heavy_turret/mega_turret.mdl")
    PrecacheModel($"models/robotics_r2/turret_plasma/plasma_turret_pc_1.mdl")
    PrecacheModel($"models/robotics_r2/turret_plasma/plasma_turret_pc_2.mdl")
    PrecacheModel($"models/robotics_r2/turret_plasma/plasma_turret_pc_3.mdl")
    PrecacheModel($"models/robotics_r2/turret_rocket/rocket_turret_posed.mdl")
    //prowler
    PrecacheModel($"models/creatures/prowler/prowler_corpse_static_01.mdl")
    PrecacheModel($"models/creatures/prowler/prowler_corpse_static_02.mdl")
    PrecacheModel($"models/creatures/prowler/prowler_corpse_static_05.mdl")
    PrecacheModel($"models/creatures/prowler/prowler_corpse_static_06.mdl")
    PrecacheModel($"models/creatures/prowler/prowler_corpse_static_07.mdl")
    PrecacheModel($"models/creatures/prowler/prowler_corpse_static_08.mdl")
    PrecacheModel($"models/creatures/prowler/prowler_corpse_static_09.mdl")
    PrecacheModel($"models/creatures/prowler/prowler_corpse_static_10.mdl")
    PrecacheModel($"models/creatures/prowler/prowler_corpse_static_12.mdl")
    PrecacheModel($"models/creatures/prowler/prowler_dead_static_07.mdl")
    PrecacheModel($"models/creatures/prowler/prowler_dead_static_08.mdl")
    PrecacheModel($"models/creatures/prowler/prowler_dead_static_09.mdl")
    PrecacheModel($"models/creatures/prowler/prowler_dead_static_10.mdl")
    PrecacheModel($"models/creatures/prowler/prowler_dead_static_11.mdl")
    PrecacheModel($"models/creatures/prowler/prowler_death1_static.mdl")
    PrecacheModel($"models/creatures/prowler/r2_prowler.mdl")
	#endif
}

bool function SpawnCMD(entity player, array<string> args)
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

	// if player only typed "gift"
	if (args.len() == 0) {
        print("Give a valid argument.");
        print("Example: spawn <playerId> <teamNum> <amount> <npc> , playerId = imc / militia / all, npc = grunt");
        // print every single player's name and their id
        int i = 0;
        foreach(entity p in GetPlayerArray()) {
            string playername = p.GetPlayerName();
            print("[" + i.tostring() + "] " + playername);
            i++
        }
        return true;
    }
	string playername = player.GetPlayerName()
    array < entity > sheep1 = [];
    // if player typed "health somethinghere"
    switch (args[0]) {
        case ("all"):
            foreach(entity p in GetPlayerArray()) {
                if (p != null)
                    sheep1.append(p)
            }
            break;

        case ("imc"):
            foreach(entity p in GetPlayerArrayOfTeam(TEAM_IMC)) {
                if (p != null)
                    sheep1.append(p)
            }
            break;

        case ("militia"):
            foreach(entity p in GetPlayerArrayOfTeam(TEAM_MILITIA)) {
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

    // if player typed "gift correctId" with no further arguments
    // if (args.len() == 2 || args.len() == 3) {
    //     return true;
    // }

    // if (args.len() > 4 )
	// {
	// 	print("Only 4 arguments required.")
	// 	return true;
	// }

    // table<string,int> parm
    // int a = 1

    // while(a<10){ // make this a for loop :(
    //     if (args.len() == a+3){
    //     parm["null"] <- 0
    //     }
    //     if (args.len() == a+4) {
    //         parm[args[a+3]] <- 0
    //     }
    //     if (args.len() == a+5) {
    //         parm[args[a+3]] <- args[a+4].tointeger()
    //     }
    //     a += 1
    // }

    table<string,int> parm

    print(args.len() % 2 == 0)
    if (args.len() % 2 == 0){
        for (int a = 4;a < args.len(); a += 2){
            if (a > args.len()) break;
            parm[args[a]] <- args[a+1].tointeger()
        }
    }
    
    foreach (entity p in sheep1) {
        thread Spawn(p, args[1].tointeger(), args[2].tointeger(),args[3],parm)
    }
	#endif
	return true;
}

void function Spawn(entity player, int team, int amount, string model, table<string,int> parm)
{
#if SERVER
    // vector origin = GetPlayerCrosshairOrigin( player );
    vector angles = player.EyeAngles();
    angles.x = 0;
    angles.z = 0;

    //parms before spawning the entity 
    // also can have cords overide
    vector origin = setParmsBefore(player,parm)

    vector spawnPos = origin;
    vector spawnAng = angles;

    //info about the spawn
    print("=====Info=====")
    print("Pos :" + spawnPos)
    print("Angle : " + spawnAng)
    print("Team : " + team)
    print("Amount : " + amount)
    print("type")

    int a = amount

    //initilize spawnNpc
    entity spawnNpc

    //this is made to abstarct the names of the npc or make it easier to spawn them 
    switch (model) {

//////////////////////////////////////// ground boys ///////////////////////////////////////////////////

        case ("reaper"):
            print("reaper")

            SpawnNPC("npc_super_spectre", amount, team, spawnPos, spawnAng,parm, player)
            break;
            
        case ("grunt"):
            print("grunt")

            SpawnNPC("npc_soldier", amount, team, spawnPos, spawnAng,parm, player)
            break;
        
        case ("stalker"):
            print("stalker")

            SpawnNPC("npc_stalker", amount, team, spawnPos, spawnAng,parm, player)
            break;
        
        case ("spectre"):
            print("spectre")

            SpawnNPC("npc_spectre", amount, team, spawnPos, spawnAng,parm, player)
            break;
        
        case ("tick"):
            print("tick")

            SpawnNPC("npc_frag_drone", amount, team, spawnPos, spawnAng,parm, player)
            break;

//////////////////////////////////////// Drones ///////////////////////////////////////////////////
        
        case ("rocket_drone"):
            print("rocket_drone")

            SpawnNPC2("npc_drone","npc_drone_rocket", amount, team, spawnPos, spawnAng,parm, player)
            break;
        
        case ("plasma_drone"):
            print("rocket_drone")

            SpawnNPC2("npc_drone","npc_drone_plasma", amount, team, spawnPos, spawnAng,parm, player)
            break;
        
        case ("beam_drone"):
            print("beam_drone")

            SpawnNPC2("npc_drone","npc_drone_beam", amount, team, spawnPos, spawnAng,parm, player)
            break;
        
        case ("shield_drone"):
            print("shield_drone")

            // SpawnNPC2("npc_drone","npc_drone_shield", amount, team, spawnPos, spawnAng,parm, player)
            // they lact have an ai
            break;
        
        case ("worker_drone"):
            print("worker_drone")

            SpawnNPC2("npc_drone","npc_drone_worker", amount, team, spawnPos, spawnAng,parm, player)
            // error lol
            break;
        case ("drone"):
            print("drone")

            SpawnNPC("npc_drone", amount, team, spawnPos, spawnAng,parm, player)
            break;

//////////////////////////////////////// Other Air Npcs ///////////////////////////////////////////////////
        
        case ("gunship"):
            print("gunship")

            SpawnNPC2("npc_gunship","npc_gunship", amount, team, spawnPos, spawnAng,parm, player)
            break;
        
        case ("dropship"):
            print("dropship")

            SpawnNPC("npc_dropship", amount, team, spawnPos, spawnAng,parm, player)
            break;

//////////////////////////////////////// Turrets ///////////////////////////////////////////////////
        
        case ("turret_big"):
            print("turret_big")

            SpawnNPC2("npc_turret_mega","npc_turret_mega", amount, team, spawnPos, spawnAng,parm, player)
            break;
        
        case ("turret"):
            print("turret")

            SpawnNPC2("npc_turret_sentry","npc_turret_sentry", amount, team, spawnPos, spawnAng,parm, player)
            break;
        
        case ("turret_plasma"):
            print("turret_titan")

            SpawnNPC2("npc_turret_sentry","npc_turret_sentry_plasma", amount, team, spawnPos, spawnAng,parm, player)
            break;

//////////////////////////////////////// Other ///////////////////////////////////////////////////
        
        case ("marvin"):
            print("marvin")

            SpawnNPC("npc_marvin", amount, team, spawnPos, spawnAng,parm, player)
            break;
        
        case ("prowler"):
            print("prowler")
    
            SpawnNPC("npc_prowler", amount, team, spawnPos, spawnAng,parm, player)
            break;

//////////////////////////////////////// Train ///////////////////////////////////////////////////
        
        case ("train1"):
            print("train")
    
            SpawnNPC3("npc_drone", 5, team, spawnPos, spawnAng,parm, player)
            break;
        
        case ("train2"):
            print("train2")
    
            SpawnNPC3("npc_super_spectre", 5, team, spawnPos, spawnAng,parm, player)
            break;

//////////////////////////////////////// Titans ///////////////////////////////////////////////////

        case ("ronin"):
            print("ronin")
    
            SpawnTitanM("titan_stryder", "npc_titan_stryder_leadwall", amount, team, spawnPos, spawnAng,parm, player)
            break;
        
        case ("amped_ronin"):
            print("amped_ronin")
    
            SpawnTitanM("titan_stryder", "npc_titan_stryder_leadwall_shift_core", amount, team, spawnPos, spawnAng,parm, player)
            break;
        
        case ("ronin_boss"):
            print("ronin_boss")
    
            SpawnTitanM("titan_stryder", "npc_titan_stryder_leadwall_bounty", amount, team, spawnPos, spawnAng,parm, player)
            break;
        
        case ("arc_titan"):
            print("arc_titan")
    
            SpawnTitanM("titan_stryder", "npc_titan_arc", amount, team, spawnPos, spawnAng,parm, player)
            break;
        
        case ("northstar"):
            print("northstar")
    
            SpawnTitanM("titan_stryder", "npc_titan_stryder_sniper", amount, team, spawnPos, spawnAng,parm, player)
            break;
        
        case ("northstar_fd"):
            print("northstar_fd")
    
            SpawnTitanM("titan_stryder", "npc_titan_stryder_sniper_boss_fd", amount, team, spawnPos, spawnAng,parm, player)
            break;

        case ("northstar_boss"):
            print("northstar_boss")
    
            SpawnTitanM("titan_stryder", "npc_titan_stryder_sniper_bounty", amount, team, spawnPos, spawnAng,parm, player)
            break;
        
        case ("brute"):
            print("brute")
    
            SpawnTitanM("titan_stryder", "npc_titan_stryder_rocketeer", amount, team, spawnPos, spawnAng,parm, player)
            break;
        
        case ("amped_brute"):
            print("amped_brute")
    
            SpawnTitanM("titan_stryder", "npc_titan_stryder_rocketeer_dash_core", amount, team, spawnPos, spawnAng,parm, player)
            break;
        
        case ("tone"):
            print("tone")
    
            SpawnTitanM("npc_titan_atlas", "npc_titan_atlas_tracker", amount, team, spawnPos, spawnAng,parm, player)
            break;
        
        case ("tone_boss"):
            print("tone_boss")
    
            SpawnTitanM("npc_titan_atlas", "npc_titan_atlas_tracker_bounty", amount, team, spawnPos, spawnAng,parm, player)
            break;
        
        case ("ion"):
            print("ion")
    
            SpawnTitanM("npc_titan_atlas", "npc_titan_atlas_stickybomb", amount, team, spawnPos, spawnAng,parm, player)
            break;
        
        case ("ion_boss"):
            print("ion")
    
            SpawnTitanM("npc_titan_atlas", "npc_titan_atlas_stickybomb_bounty", amount, team, spawnPos, spawnAng,parm, player)
            break;
        
        case ("monarch"):
            print("monarch")
    
            SpawnTitanM("npc_titan_atlas", "npc_titan_atlas_vanguard", amount, team, spawnPos, spawnAng,parm, player)
            break;
        
        case ("monarch_boss"):
            print("monarch_boss")
    
            SpawnTitanM("npc_titan_atlas", "npc_titan_atlas_vanguard_bounty", amount, team, spawnPos, spawnAng,parm, player)
            break;
        
        case ("scorch"):
            print("scorch")
    
            SpawnTitanM("npc_titan_ogre", "npc_titan_ogre_meteor", amount, team, spawnPos, spawnAng,parm, player)
            break;
        
        case ("scorch_boss"):
            print("scorch_boss")
    
            SpawnTitanM("npc_titan_ogre", "npc_titan_ogre_meteor_bounty", amount, team, spawnPos, spawnAng,parm, player)
            break;
        
        case ("legion"):
            print("legion")
    
            SpawnTitanM("npc_titan_ogre", "npc_titan_ogre_minigun", amount, team, spawnPos, spawnAng,parm, player)
            break;
        
        case ("legion_boss"):
            print("legion_boss")
    
            SpawnTitanM("npc_titan_ogre", "npc_titan_ogre_minigun_bounty", amount, team, spawnPos, spawnAng,parm, player)
            break;
        
        // case ("meele_titan"): doesn't work
        //     print("legion_boss")
    
        //     SpawnTitanC("npc_titan_ogre", "npc_titan_ogre_fighter_berserker_core", amount, team, spawnPos, spawnAng,parm, player)
        //     break;

        // case ("nuke_titan1"): don't work :(
        //     print("nuke_titan1")
    
        //     SpawnTitanC("titan_ogre", "npc_titan_nuke", amount, team, spawnPos, spawnAng,parm, player)
        //     break;
        
        // case ("nuke_titan2"):
        //     print("nuke_titan2")
    
        //     SpawnTitanC("titan_ogre", "npc_titan_nuke", amount, team, spawnPos, spawnAng,parm, player)
        //     break;

        // case ("titan_sarah"): //doesn't work
        //     print("titan_sarah")
    
        //     SpawnTitanC("npc_titan", "npc_titan_sarah", amount, team, spawnPos, spawnAng,parm, player)
        //     break;

//////////////////////////////////////// Pilots ///////////////////////////////////////////////////
        
        case ("pilot"):
            print("pilot")

            SpawnNPC("npc_pilot_elite", amount, team, spawnPos, spawnAng,parm, player)
            break;
        
        case ("sarah"): // she is not a pilot because npc_soldier but I will let it pass 
            print("sarah")

            SpawnNPC2("npc_soldier", "npc_soldier_hero_sarah", amount, team, spawnPos, spawnAng,parm, player)
            break;

///////////////////////////////////////// Other ///////////////////////////////////////////////////////

        case ("battery"):
            print("battery")

            while(a>0)
            {
            a-=1;
            entity battery = Rodeo_CreateBatteryPack()
            battery.SetOrigin( spawnPos )
            }
            break;

        default:
            print("none")
            break;
    }
#endif
}

void function SpawnNPC(string name, int amount, int team, vector spawnPos, vector spawnAng, table<string,int> parm,entity player)
{
    int a = amount
    entity spawnNpc

    // try {
    while(a>0)
    {
    a-=1;

    spawnNpc = CreateNPC( name, team, spawnPos, spawnAng);
    SetSpawnOption_AISettings( spawnNpc, name);
    DispatchSpawn( spawnNpc );

    setParmsAfter(player,parm, spawnNpc)
    }
        
    // }
    // catch() {
    //     continue;
    // }
}

void function SpawnNPC2(string name,string aiName, int amount, int team, vector spawnPos, vector spawnAng, table<string,int> parm,entity player)
{
    int a = amount
    entity spawnNpc

    // try {
    while(a>0)
    {
    a-=1;

    spawnNpc = CreateNPC( name, team, spawnPos, spawnAng);
    SetSpawnOption_AISettings( spawnNpc, aiName);
    DispatchSpawn( spawnNpc );

    setParmsAfter(player,parm, spawnNpc)
    }
        
    // }
    // catch() {
    //     continue;
    // }
}

void function SpawnNPC3(string name, int amount, int team, vector spawnPos, vector spawnAng, table<string,int> parm,entity player)
{
    int a = amount
    entity spawnNpc
    entity lastEntity = player
    table<string,int> parm
    parm["pet"] <- 1

    // try {
    while(a>0)
    {
    a-=1;

    spawnNpc = CreateNPC( name, team, spawnPos, spawnAng);
    SetSpawnOption_AISettings( spawnNpc, name);
    DispatchSpawn( spawnNpc );

    setParmsAfter(lastEntity,parm, spawnNpc)
    lastEntity = spawnNpc
    }
        
    // }
    // catch() {
    //     continue;
    // }
}

void function SpawnTitanM(string name, string aiName, int amount, int team, vector spawnPos, vector spawnAng, table<string,int> parm,entity player)
{
    int a = amount
    entity spawnNpc

    // try {
    while(a>0)
    {
    a-=1;

    entity spawnNpc = CreateNPCTitan( name, team, spawnPos, spawnAng, [] );
	SetSpawnOption_NPCTitan( spawnNpc, TITAN_HENCH );
    // string settings = expect string( Dev_GetPlayerSettingByKeyField_Global( name, "sp_aiSettingsFile" ) )
	SetSpawnOption_AISettings( spawnNpc, aiName );
    SetSpawnOption_Titanfall( spawnNpc )
    SetSpawnOption_NPCTitan( spawnNpc, TITAN_HENCH );
    // spawnNpc.ai.titanSpawnLoadout.setFile = name
	// OverwriteLoadoutWithDefaultsForSetFile( spawnNpc.ai.titanSpawnLoadout )
	DispatchSpawn( spawnNpc );

    setParmsAfter(player,parm, spawnNpc)
    }
        
    // }
    // catch() {
    //     continue;
    // }
}

void function SpawnTitanC(string name, string aiName, int amount, int team, vector spawnPos, vector spawnAng, table<string,int> parm,entity player)
{
    int a = amount
    DisablePrecacheErrors()
	wait 0.2

    // try {
    while(a>0)
    {
    a-=1;

	// TitanLoadoutDef loadout = GetTitanLoadoutForCurrentMap()
	// entity npc = CreateAutoTitanForPlayer_FromTitanLoadout( player, loadout, spawnPos, spawnAng )

	// SetSpawnOption_AISettings( npc, "npc_titan_buddy" )
    // SetSpawnOption_Titanfall( npc )

	// DispatchSpawn( npc )

    // setParmsAfter(player,parm, npc)

    string mercName = "Slone"

    printt( "script thread DEV_SpawnMercTitanAtCrosshair( \"" + mercName + "\")" )
	// Assert( IsNewThread(), "Must be threaded off due to precache issues" )
	TitanLoadoutDef ornull loadout = GetTitanLoadoutForBossCharacter( mercName )
	if ( loadout == null )
		return
	expect TitanLoadoutDef( loadout )
	string baseClass = "npc_titan"
	string aiSettings = GetNPCSettingsFileForTitanPlayerSetFile( loadout.setFile )

	bool restoreHostThreadMode = GetConVarInt( "host_thread_mode" ) != 0
	entity npc = DEV_SpawnNPCWithWeaponAtCrosshairStart( restoreHostThreadMode, baseClass, aiSettings, TEAM_IMC )
	SetSpawnOption_NPCTitan( npc, TITAN_MERC )
	SetSpawnOption_TitanLoadout( npc, loadout )
	npc.ai.bossTitanPlayIntro = false

	DispatchSpawn( npc )
	DEV_SpawnNPCWithWeaponAtCrosshairEnd( restoreHostThreadMode )
    }
}

void function setParmsAfter(entity player,table<string,int> parm, entity Entity)
{
    if ("pet" in parm) {
        if (parm["pet"] == 1)
        {
            print("npc is now a pet")
            int followBehavior = GetDefaultNPCFollowBehavior( Entity )
            Entity.InitFollowBehavior( player, followBehavior )
            Entity.EnableBehavior( "Follow" )
            Entity.SetTitle( player.GetPlayerName() + "'s pet" )
        }
    }
    if ("health" in parm) {
        if (parm["health"] > 0)
        {
            if (parm["health"] > 524287)
                parm["health"] = 524286

            Entity.SetMaxHealth(parm["health"])
            Entity.SetHealth(parm["health"])
            print("health is now at " + parm["health"])
        }
    }
    if ("size" in parm) {
        if (parm["size"] > 0)
        {
            if (parm["size"] > 1000)
                parm["size"] = 1000

            Entity.kv.modelscale = parm["size"]
        }
    }
    if ("rodeo" in parm) {
        if (parm["rodeo"] == 1)
        {
            Entity.SetNumRodeoSlots( 3 )
            // Entity.SetRodeoRider( 1, player )

            print("number of rodeo spot is now 3")
        }
    }
}

vector function setParmsBefore(entity player,table<string,int> parm)
{
    float x = 0.1
    float y = 0.1
    float z = 0.1
    vector new_origin

    if ("wait" in parm) {
        if (parm["wait"] > 0)
        {
            print("Waiting " + parm["wait"] + " before spawning")
            Wait(parm["wait"].tofloat())
            // SendHudMessage( player, "Wating is now over, time to spawn your entity!", -1, 0.4, 255, 100, 100, 0, 0.15, 4, 0.15 )
            
        }
    } // I hate this why x can't be used why
    if ("X" in parm) {
        x = parm["X"].tofloat();
        print("X set to " + parm["X"].tofloat())
    }
    if ("Y" in parm) {
        y = parm["Y"].tofloat();
        print("Y set to " + parm["Y"].tofloat())
    }
    if ("Z" in parm) {
        z = parm["Z"].tofloat();
        print("Z set to " + parm["Z"].tofloat())
    }

    if ((x != 0.1) || (y != 0.1) || (z != 0.1)){
        new_origin = Vector( x, y, z )
        print("all positions are diffrent")
    }
    else{
        new_origin = GetPlayerCrosshairOrigin( player );
        print("not all positions are diffrent")
    }

    return new_origin;
}

string function getWeapon(int Id)
{
    string value
    array<string> titanWeapons = [
		"mp_titanweapon_leadwall",
		"mp_titanweapon_meteor",
		"mp_titanweapon_particle_accelerator",
		"mp_titanweapon_predator_cannon",
		"mp_titanweapon_rocketeer_rocketstream",
		"mp_titanweapon_sniper",
		"mp_titanweapon_sticky_40mm",
		"mp_titanweapon_xo16_shorty",
		"mp_titanweapon_xo16_vanguard"
	]

    if (Id < 9){
        value = titanWeapons[Id];
    }
    return value;
}

//might be usuful lol
// ClientCommand( player,  command )
//ModelIsPrecached( asset )
// PrecacheModel( asset )
// bool ArrayEntityWithinDistance( array< entity >, vector, float )
// entity.SetRodeoRider( int, entity ). Sets the rodeo rider at the given slot.
// entity.SetNumRodeoSlots( int ). Sets the maximum number of rodeo slots available on this entity.
//SetTargetName( Entity,  string)
// var SetAILethality( var )
// AssistingPlayerStruct GetLatestAssistingPlayerInfo( entity )
// file.sarahTitan.SetTitle( "#NPC_SARAH_NAME" )
// ShowName( file.sarahTitan )
// SetPlayerPetTitan( player, npc )
// void SetLocationTrackerHealth( entity, float )
// void SetLocationTrackerID( entity, int )
// void SetLocationTrackerRadius( entity, float )

    // if ("weapon" in parm) {
    //     // int GetPersistentSpawnLoadoutIndex( Entity, string )
    //     TitanLoadoutDef loadout = GetActiveTitanLoadout( Entity )

    //     loadout.primary = parm["weapon"]
    //     loadout.primaryMod = ""
    //     loadout.primaryMods = []

    //     print("changed there loadout to " + parm["weapon"])
    // }
    // }
