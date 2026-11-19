class SeqAct_AIFactory extends SequenceAction
    native;

enum ETeamTypes
{
    TEAM_Friendly,                  // 0
    TEAM_Enemy,                     // 1
    TEAM_MAX                        // 2
};

enum EAIAssignment
{
    EA_UniquePerSpawn,              // 0
    EA_Shared,                      // 1
    EA_MAX                          // 2
};

enum ESpawnPointSelectionMethod
{
    SPSM_Shuffle,                   // 0
    SPSM_Linear,                    // 1
    SPSM_MAX                        // 2
};

struct native AISpawnInfo
{
    var() protectedwrite AIController ControllerArchetype;
    var() protectedwrite SkyPawn PawnArchetype;
    var() protectedwrite SkyBehaviorTree BehaviorTreeTemplate;
    var() int SpawnTotal;
    var() int MaxAlive;
    var int SpawnedCount;
    var array<SkyPawn> WatchList;
    var() float MaxSpawnDelay;
    var() float MinSpawnDelay;
    var float CurrentDelay;
    var() protectedwrite array<protectedwrite Inventory> InventoryArchList;
    var array<string> VarLinkDescs;
    var string SpawnPointLinkDesc;
    var array<string> OutLinkDescs;
    var array<SkyPawn> CurrentSpawns;
    var deprecated bool bAssignMoveTarget;
    var class<SkyPawn> PawnClass;
    var class<AIController> ControllerClass;
    var() int TeamIndex;
    var() SkyItem_RocketPack RocketPackArchetype;
    var() bool bGiveDefaultInventory;
    var array<Actor> SpawnPoints;
    var(Squad) name SquadName;
    var(Squad) bool bBecomeLeader;

    structdefaultproperties
    {
        ControllerArchetype=none
        PawnArchetype=none
        BehaviorTreeTemplate=none
        SpawnTotal=1
        MaxAlive=1
        SpawnedCount=0
        WatchList=none
        MaxSpawnDelay=0.0000000
        MinSpawnDelay=0.0000000
        CurrentDelay=0.0000000
        InventoryArchList=none
        VarLinkDescs=none
        SpawnPointLinkDesc=""
        OutLinkDescs=none
        CurrentSpawns=none
        PawnClass=none
        ControllerClass=none
        TeamIndex=1
        RocketPackArchetype=none
        bGiveDefaultInventory=false
        SpawnPoints=none
        SquadName="None"
        bBecomeLeader=false
    }
};

var const array<name> InventoryTypeNames;
var(Spawn) array<AISpawnInfo> SpawnSets;
var const array<AISpawnInfo> PresetSpawnSets;
var bool bAllSpawned;
var bool bAllDead;
var bool bAbortSpawns;
var bool bSuppressAllDead;
var bool bActivatedDeadLink;
var deprecated bool bMoveInterruptable;
var() bool bUseDamageForKillAll;
var int DeadCount;
var() int ActivateDeadLinkCount;
var deprecated SeqAct_AIFactory.EAIAssignment MoveAssignment;
var() SeqAct_AIFactory.ESpawnPointSelectionMethod SpawnPointSelectionMethod;
var deprecated array<Actor> MoveTargets;
var(Cover) array<name> NavigationSets;
var int CoverGroupIdx;
var() float TeleportDistance;
var() float TeleportZDistance;
var() int SpawnTotal;
var() int MaxAlive;

// Export USeqAct_AIFactory::execNotifySpawnerDisabled(FFrame&, void* const)
native function NotifySpawnerDisabled(SkySpawner Spawner);

// Export USeqAct_AIFactory::execCanSpawnAtLocation(FFrame&, void* const)
native static function bool CanSpawnAtLocation(out Vector chkLocation, Vector ChkExtent, Actor SpawnPointActor);

static event int GetObjClassVersion()
{
    return 34;
    //return ReturnValue;    
}
