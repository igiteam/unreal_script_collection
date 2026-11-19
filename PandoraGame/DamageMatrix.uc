class DamageMatrix extends Actor
    native
    notplaceable;

const Epsilon = 0.0001;

enum WeaponDamageTypes
{
    WDT_Ump_Primary,                // 0
    WDT_Ump_Secondary,              // 1
    WDT_SPAssaultRifle_Primary,     // 2
    WDT_SPAssaultRifle_Secondary,   // 3
    WDT_Shotgun_Primary,            // 4
    WDT_Shotgun_Secondary,          // 5
    WDT_FireAxe_Primary,            // 6
    WDT_FireAxe_Secondary,          // 7
    WDT_Saw_Primary,                // 8
    WDT_Saw_Secondary,              // 9
    WDT_Flamethrower_Primary,       // 10
    WDT_Flamethrower_Secondary,     // 11
    WDT_Rocketlauncher_Sole,        // 12
    WDT_Minigun_Sole,               // 13
    WDT_NineMM_Primary,             // 14
    WDT_NineMM_Secondary,           // 15
    WDT_DesertEagle_Primary,        // 16
    WDT_DesertEagle_Secondary,      // 17
    WDT_UNKNOWN_DAMAGE_TYPE,        // 18
    WDT_NUM_ELEMENTS,               // 19
    WDT_MAX                         // 20
};

enum DamageMatrixCreature
{
    DMC_Player,                     // 0
    DMC_BlackOrder_Assault1,        // 1
    DMC_Council_Assault1,           // 2
    DMC_Werewolf,                   // 3
    DMC_Griffon,                    // 4
    DMC_FireDrake,                  // 5
    DMC_Medusa,                     // 6
    DMC_Golem,                      // 7
    DMC_Minotaur,                   // 8
    DMC_Nari,                       // 9
    DMC_WeakWerewolf,               // 10
    DMC_BloodTick,                  // 11
    DMC_Tentacle,                   // 12
    DMC_UNKNOWN_CREATURE_TYPE,      // 13
    DMC_BadGuyPawn,                 // 14
    DMC_NUM_ELEMENTS,               // 15
    DMC_MAX                         // 16
};

var float creatureResistances[285];

// Export UDamageMatrix::execGetWorldInfo(FFrame&, void* const)
native static final function WorldInfo GetWorldInfo();

// Export UDamageMatrix::execSPSpawn(FFrame&, void* const)
native static final function Actor SPSpawn(class<Actor> SpawnClass, optional Actor SpawnOwner, optional name SpawnTag, optional Vector SpawnLocation, optional Rotator SpawnRotation, optional Actor Template);

// Export UDamageMatrix::execGetCreatureType(FFrame&, void* const)
native function DamageMatrix.DamageMatrixCreature GetCreatureType(Actor Actor);

// Export UDamageMatrix::execGetWeaponDamageType(FFrame&, void* const)
native function DamageMatrix.WeaponDamageTypes GetWeaponDamageType(SPBulletPersistent bullet);

// Export UDamageMatrix::execCalculateModifiedDamage(FFrame&, void* const)
native function float CalculateModifiedDamage(DamageMatrix.DamageMatrixCreature creatureIndex, DamageMatrix.WeaponDamageTypes weaponDamageIndex);

static simulated event DamageMatrix Get()
{
    local DamageMatrix damageManager;
    local PandoraGRI PGRI;

    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x28
    if(PGRI == none)
    {
        return none;
    }
    // End:0x4D
    if(PGRI.ActiveDamageManager != none)
    {
        return PGRI.ActiveDamageManager;
    }
    damageManager = DamageMatrix(SPSpawn(Class'DamageMatrix'));
    // End:0x85
    if(damageManager != none)
    {
        damageManager.bKillDuringLevelTransition = true;
    }
    PGRI.ActiveDamageManager = damageManager;
    return damageManager;
    //return ReturnValue;    
}

function RegisterDamageResistance(int PawnID, optional SPGameDifficultyTune TuneData, optional float UMP_Primary, optional float UMP_Secondary, optional float SPAssaultRifle_Primary, optional float SPAssaultRifle_Secondary, optional float Shotgun_Primary, optional float Shotgun_Secondary, optional float FireAxe_Primary, optional float FireAxe_Secondary, optional float Saw_Primary, optional float Saw_Secondary, optional float Flame_Primary, optional float Flame_Secondary, optional float RocketLauncher_Sole, optional float Minigun_Sole, optional float NineMM_Primary, optional float NineMM_Secondary, optional float DesertEagle_Primary, optional float DesertEagle_Secondary)
{
    // End:0x3CA
    if(TuneData != none)
    {
        creatureResistances[PawnID + 0] = TuneData.GetValue(TuneData.DBS_Ump_Primary);
        creatureResistances[PawnID + 1] = TuneData.GetValue(TuneData.DBS_Ump_Secondary);
        creatureResistances[PawnID + 2] = TuneData.GetValue(TuneData.DBS_SPAssaultRifle_Primary);
        creatureResistances[PawnID + 3] = TuneData.GetValue(TuneData.DBS_SPAssaultRifle_Secondary);
        creatureResistances[PawnID + 4] = TuneData.GetValue(TuneData.DBS_Shotgun_Primary);
        creatureResistances[PawnID + 5] = TuneData.GetValue(TuneData.DBS_Shotgun_Secondary);
        creatureResistances[PawnID + 6] = TuneData.GetValue(TuneData.DBS_FireAxe_Primary);
        creatureResistances[PawnID + 7] = TuneData.GetValue(TuneData.DBS_FireAxe_Secondary);
        creatureResistances[PawnID + 8] = TuneData.GetValue(TuneData.DBS_Saw_Primary);
        creatureResistances[PawnID + 9] = TuneData.GetValue(TuneData.DBS_Saw_Secondary);
        creatureResistances[PawnID + 10] = TuneData.GetValue(TuneData.DBS_Flamethrower_Primary);
        creatureResistances[PawnID + 11] = TuneData.GetValue(TuneData.DBS_Flamethrower_Secondary);
        creatureResistances[PawnID + 12] = TuneData.GetValue(TuneData.DBS_Rocketlauncher_Sole);
        creatureResistances[PawnID + 13] = TuneData.GetValue(TuneData.DBS_Minigun_Sole);
        creatureResistances[PawnID + 14] = TuneData.GetValue(TuneData.DBS_NineMM_Primary);
        creatureResistances[PawnID + 15] = TuneData.GetValue(TuneData.DBS_NineMM_Secondary);
        creatureResistances[PawnID + 16] = TuneData.GetValue(TuneData.DBS_DesertEagle_Primary);
        creatureResistances[PawnID + 17] = TuneData.GetValue(TuneData.DBS_DesertEagle_Secondary);
        creatureResistances[PawnID + 18] = 1.0000000;        
    }
    else
    {
        creatureResistances[PawnID + 0] = UMP_Primary;
        creatureResistances[PawnID + 1] = UMP_Secondary;
        creatureResistances[PawnID + 2] = SPAssaultRifle_Primary;
        creatureResistances[PawnID + 3] = SPAssaultRifle_Secondary;
        creatureResistances[PawnID + 4] = Shotgun_Primary;
        creatureResistances[PawnID + 5] = Shotgun_Secondary;
        creatureResistances[PawnID + 6] = FireAxe_Primary;
        creatureResistances[PawnID + 7] = FireAxe_Secondary;
        creatureResistances[PawnID + 8] = Saw_Primary;
        creatureResistances[PawnID + 9] = Saw_Secondary;
        creatureResistances[PawnID + 10] = Flame_Primary;
        creatureResistances[PawnID + 11] = Flame_Secondary;
        creatureResistances[PawnID + 12] = RocketLauncher_Sole;
        creatureResistances[PawnID + 13] = Minigun_Sole;
        creatureResistances[PawnID + 14] = NineMM_Primary;
        creatureResistances[PawnID + 15] = NineMM_Secondary;
        creatureResistances[PawnID + 16] = DesertEagle_Primary;
        creatureResistances[PawnID + 17] = DesertEagle_Secondary;
        creatureResistances[PawnID + 18] = 1.0000000;
    }
    //return;    
}

function PostBeginPlay()
{
    local int nPlayer, nBlackOrder_Assault1, nBadGuy, nBloodTick, nCouncil_Assault1, nWerewolf,
	    nGriffon, nFireDrake, nMedusa, nGolem, nMinotaur,
	    nNari, nWeakWerewolf, nUnknownCreature, nTentacle;

    nPlayer = 0 * int(15);
    nBlackOrder_Assault1 = 1 * int(15);
    nCouncil_Assault1 = 2 * int(15);
    nWerewolf = 3 * int(15);
    nWeakWerewolf = 10 * int(15);
    nNari = 9 * int(15);
    nBloodTick = 11 * int(15);
    nGriffon = 4 * int(15);
    nFireDrake = 5 * int(15);
    nMedusa = 6 * int(15);
    nGolem = 7 * int(15);
    nMinotaur = 8 * int(15);
    nBadGuy = 14 * int(15);
    nTentacle = 12 * int(15);
    nUnknownCreature = 13 * int(15);
    RegisterDamageResistance(nPlayer, Class'SPTuneManager'.static.GetGameDifficultyTunePlayer());
    RegisterDamageResistance(nGriffon, Class'SPTuneManager'.default.Difficulty.GriffonGD);
    RegisterDamageResistance(nBadGuy,, 1.2500000, 1.2500000, 0.9000000,,,,,, 0.9000000,,,,, 2.0000000);
    RegisterDamageResistance(nBlackOrder_Assault1, Class'SPTuneManager'.default.Difficulty.BlackOrderGD);
    RegisterDamageResistance(nCouncil_Assault1, Class'SPTuneManager'.default.Difficulty.CouncilGD);
    RegisterDamageResistance(nWerewolf, Class'SPTuneManager'.static.GetGameDifficultyTuneWerewolf());
    RegisterDamageResistance(nFireDrake, Class'SPTuneManager'.default.Difficulty.FireDrakeGD);
    RegisterDamageResistance(nMedusa);
    RegisterDamageResistance(nGolem);
    RegisterDamageResistance(nMinotaur, Class'SPTuneManager'.default.Difficulty.MinotaurGD);
    RegisterDamageResistance(nNari, Class'SPTuneManager'.default.Difficulty.NariGD);
    RegisterDamageResistance(nWeakWerewolf, Class'SPTuneManager'.static.GetGameDifficultyTuneWeakWerewolf());
    RegisterDamageResistance(nBloodTick, Class'SPTuneManager'.default.Difficulty.BloodTickGD);
    RegisterDamageResistance(nTentacle, Class'SPTuneManager'.default.Difficulty.TentacleGD);
    RegisterDamageResistance(nUnknownCreature);
    //return;    
}
