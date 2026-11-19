class SkySeqAct_AIFactoryNew extends SequenceAction
    native;

enum ESelectionMethod
{
    ESMTH_Shuffle,                  // 0
    ESMTH_Linear,                   // 1
    ESMTH_MAX                       // 2
};

enum EAIFactoryInputLinks
{
    EAIFIL_Spawn,                   // 0
    EAIFIL_AbortSpawn,              // 1
    EAIFIL_DestroyAll,              // 2
    EAIFIL_MAX                      // 3
};

enum EAIFactoryOutputLinks
{
    EAIFOL_AllSpawned,              // 0
    EAIFOL_AllDead,                 // 1
    EAIFOL_Spawned,                 // 2
    EAIFOL_Death,                   // 3
    EAIFOL_MAX                      // 4
};

enum EAIFactoryVariableLinks
{
    EAIFVL_LastSpawned,             // 0
    EAIFVL_LastVehicle,             // 1
    EAIFVL_SpawnPoints,             // 2
    EAIFVL_MAX                      // 3
};

struct native SpawnInfo
{
    var() protectedwrite SkyPawn PawnArchetype;
    var() protectedwrite AIController ControllerArchetype;
    var() protectedwrite SkyBehaviorTree BehaviorTreeTemplate;
    var() SkyItem_RocketPack RocketPackArchetype;
    var() bool bGiveDefaultInventory;
    var() protectedwrite array<protectedwrite Inventory> InventoryArchetypes;
    var() bool bBecomeLeader;
    var() protectedwrite SkyVehicle VehicleArchetype;

    structdefaultproperties
    {
        PawnArchetype=none
        ControllerArchetype=none
        BehaviorTreeTemplate=none
        RocketPackArchetype=none
        bGiveDefaultInventory=true
        InventoryArchetypes=none
        bBecomeLeader=false
        VehicleArchetype=none
    }
};

struct native PendingSpawnInfo
{
    var int SpawnCount;
    var SkyPawn Pawn;
    var SkyVehicle Vehicle;

    structdefaultproperties
    {
        SpawnCount=0
        Pawn=none
        Vehicle=none
    }
};

struct native SPawnAndVehicle
{
    var SkyPawn Pawn;
    var SkyVehicle Vehicle;
    var bool bVehicleWithoutPawn;

    structdefaultproperties
    {
        Pawn=none
        Vehicle=none
        bVehicleWithoutPawn=false
    }
};

var() array<SpawnInfo> SpawnSets;
var() SkySeqAct_AIFactoryNew.ESelectionMethod SpawnPointSelectionMethod;
var() float SpawnDelayMax;
var() float SpawnDelayMin;
var() int SpawnTotal;
var() int MaxAlive;
var() name SquadName;
var() int TeamIndex;
var() bool bRandom;
var() bool bSpawnOffscreenOnly;
var bool bAllSpawned;
var bool bAllDead;
var bool bAbortSpawns;
var bool bSuspending;
var int SpawnedCount;
var array<SPawnAndVehicle> WatchList;
var float CurrentDelay;
var array<string> VarLinkDescs;
var array<string> OutLinkDescs;
var array<Actor> SpawnPoints;
var int PendingDeathActivates;
var array<PendingSpawnInfo> PendingSpawns;
var array<int> SpawnSetOrder;
var int NextToSpawnIdx;
var array<SkyPawn> DeathSpawns;

// Export USkySeqAct_AIFactoryNew::execTriggerDeath(FFrame&, void* const)
native function TriggerDeath(Pawn Victim);

// Export USkySeqAct_AIFactoryNew::execAssociatePawnToVehicle(FFrame&, void* const)
native function AssociatePawnToVehicle(Pawn Pawn, Pawn Vehicle);

// Export USkySeqAct_AIFactoryNew::execDisassociatePawnFromVehicle(FFrame&, void* const)
native function DisassociatePawnFromVehicle(Pawn Pawn, Pawn Vehicle);

// Export USkySeqAct_AIFactoryNew::execRegisterDeathSpawn(FFrame&, void* const)
native function RegisterDeathSpawn(SkyPawn SP);

static event int GetObjClassVersion()
{
    return 5;
    //return ReturnValue;    
}
