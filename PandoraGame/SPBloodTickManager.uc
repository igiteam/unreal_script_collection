class SPBloodTickManager extends Actor
    native
    notplaceable;

struct native BTSpawnInfo
{
    var Vector Location;
    var Rotator Rotation;
    var float delay;
    var Pawn Owner;
    var Pawn PreferredEnemy;

    structdefaultproperties
    {
        Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Rotation=(Pitch=0,Yaw=0,Roll=0)
        delay=0.0000000
        Owner=none
        PreferredEnemy=none
    }
};

struct native BTSpawned
{
    var BTSpawnInfo Info;
    var Pawn Pawn;
    var private native const Pointer pInList;
    var private native const Pointer pNext;
    var private native const Pointer pPrev;

    structdefaultproperties
    {
        Info=(Location=(X=0.0000000,Y=0.0000000,Z=0.0000000),Rotation=(Pitch=0,Yaw=0,Roll=0),delay=0.0000000,Owner=none,PreferredEnemy=none)
        Pawn=none
    }
};

struct native BTList
{
    var private native const Pointer pFirst;
    var int NumItems;
    var private native const Pointer pCurrent;

    structdefaultproperties
    {
        NumItems=0
    }
};

/** VARIABLE DECLARATIONS */
var() int MaxBloodTicks;
var array<BTSpawned> SpawnData;
var BTList FreeList;
var BTList PendingList;
var BTList SpawnedList;
var BTList KillList;

// Export USPBloodTickManager::execInit(FFrame&, void* const)
native final function Init();

// Export USPBloodTickManager::execCanSpawn(FFrame&, void* const)
native final function bool CanSpawn(optional int Count);

// Export USPBloodTickManager::execAvailableForSpawn(FFrame&, void* const)
native final function int AvailableForSpawn();

// Export USPBloodTickManager::execRequestSpawn(FFrame&, void* const)
native function bool RequestSpawn(BTSpawnInfo SpawnInfo);

// Export USPBloodTickManager::execProcessPending(FFrame&, void* const)
native function ProcessPending(float DeltaTime);

// Export USPBloodTickManager::execDeathNotification(FFrame&, void* const)
native function DeathNotification(Actor Actor);

// Export USPBloodTickManager::execLivingTicks(FFrame&, void* const)
native function int LivingTicks(Actor Actor);

// Export USPBloodTickManager::execGetWorldInfo(FFrame&, void* const)
private native static final function WorldInfo GetWorldInfo();

function Deactivate()
{
    local PandoraGameInfo spGameInfo;

    spGameInfo = PandoraGameInfo(GetWorldInfo().Game);
    // End:0x28
    if(spGameInfo == none)
    {
        return;
    }
    spGameInfo.ActiveSPBloodTickManager = none;
    //return;    
}

function int NumAlive()
{
    return SpawnedList.NumItems + PendingList.NumItems;
    //return ReturnValue;    
}

static function bool IsActive()
{
    local PandoraGameInfo spGameInfo;

    spGameInfo = PandoraGameInfo(GetWorldInfo().Game);
    // End:0x28
    if(spGameInfo == none)
    {
        return false;
    }
    // End:0x3F
    if(spGameInfo.ActiveSPBloodTickManager != none)
    {
        return true;
    }
    //return ReturnValue;    
}

static function SPBloodTickManager Get(Actor Actor)
{
    local PandoraGameInfo spGameInfo;
    local SPBloodTickManager Manager;

    spGameInfo = PandoraGameInfo(GetWorldInfo().Game);
    // End:0x28
    if(spGameInfo == none)
    {
        return none;
    }
    // End:0x4D
    if(spGameInfo.ActiveSPBloodTickManager != none)
    {
        return spGameInfo.ActiveSPBloodTickManager;
    }
    // End:0x5A
    if(Actor == none)
    {
        return none;
    }
    Manager = Actor.Spawn(Class'SPBloodTickManager');
    spGameInfo.ActiveSPBloodTickManager = Manager;
    // End:0xBF
    if(Manager != none)
    {
        Manager.bKillDuringLevelTransition = true;
        Manager.Init();
    }
    return Manager;
    //return ReturnValue;    
}

event bool SpawnHelper(out BTSpawned NewRequest)
{
    local SPBloodTickPawnPersistent BloodTick;
    local SPBloodTickAIController BloodTickController;
    local class<Actor> classToSpawn;

    classToSpawn = Class'SPBloodTickPawnPersistent'.static.GetBloodTickPawnClass();
    // End:0x28
    if(classToSpawn == none)
    {        
    }
    else
    {
        BloodTick = SPBloodTickPawnPersistent(Spawn(classToSpawn,,, NewRequest.Info.Location, NewRequest.Info.Rotation));
        // End:0x197
        if(BloodTick != none)
        {
            BloodTick.bKillDuringLevelTransition = true;
            BloodTickController = Spawn(Class'SPBloodTickAIController',,, NewRequest.Info.Location, NewRequest.Info.Rotation);
            // End:0x197
            if(BloodTickController != none)
            {
                BloodTickController.Possess(BloodTick, false);
                BloodTickController.SetPreferedEnemy(NewRequest.Info.PreferredEnemy.Controller);
                NewRequest.Pawn = BloodTick;
                BloodTick.Gorgon = NewRequest.Info.Owner;
                BloodTickController.bKillDuringLevelTransition = true;
                return true;
            }
        }
    }
    return false;
    //return ReturnValue;    
}

function Tick(float DeltaTime)
{
    ProcessPending(DeltaTime);
    //return;    
}

auto state Active
{Begin:

    Sleep(1.0000000);
    J0x08:

    // End:0x3B [Loop If]
    if((SpawnedList.NumItems + PendingList.NumItems) > 0)
    {
        Sleep(1.0000000);
        // [Loop Continue]
        goto J0x08;
    }
    GotoState('Inactive', 'Begin', true, false);
    stop;            
}

state Inactive
{Begin:

    Sleep(1.0000000);
    // End:0x46
    if((SpawnedList.NumItems + PendingList.NumItems) > 0)
    {
        GotoState('Active', 'Begin', true, false);
    }
    Deactivate();
    Destroy();
    stop;                    
}
