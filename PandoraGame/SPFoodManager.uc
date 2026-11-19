class SPFoodManager extends Actor
    native
    notplaceable;

struct native FoodInfo
{
    var Actor Food;
    var Actor Owner;
    var float lifeLeft;

    structdefaultproperties
    {
        Food=none
        Owner=none
        lifeLeft=0.0000000
    }
};

var private transient array<FoodInfo> FoodArray;

// Export USPFoodManager::execGetWorldInfo(FFrame&, void* const)
native static final function WorldInfo GetWorldInfo();

// Export USPFoodManager::execSPSpawn(FFrame&, void* const)
native static final function Actor SPSpawn(class<Actor> SpawnClass, optional Actor SpawnOwner, optional name SpawnTag, optional Vector SpawnLocation, optional Rotator SpawnRotation, optional Actor Template);

// Export USPFoodManager::execUpdateFood(FFrame&, void* const)
private native final function UpdateFood(float ElapsedTime);

// Export USPFoodManager::execAddFood(FFrame&, void* const)
native final function AddFood(Actor newFood);

// Export USPFoodManager::execRemoveFood(FFrame&, void* const)
native final function RemoveFood(Actor oldActor);

// Export USPFoodManager::execFindFood(FFrame&, void* const)
native final function Actor FindFood(SPPawn hungryActor);

// Export USPFoodManager::execClaimFood(FFrame&, void* const)
native final function ClaimFood(Actor Food, SPPawn newClaimer);

// Export USPFoodManager::execUnclaimFood(FFrame&, void* const)
native final function UnclaimFood(Actor Food, SPPawn currClaimer);

// Export USPFoodManager::execAmIClaimedFood(FFrame&, void* const)
native final function bool AmIClaimedFood(Actor Food);

// Export USPFoodManager::execGetLifetimeRemaining(FFrame&, void* const)
native final function float GetLifetimeRemaining(Actor Food);

static event SPFoodManager Get()
{
    local PandoraGameInfo spGameInfo;
    local SPFoodManager FoodManager;

    spGameInfo = PandoraGameInfo(GetWorldInfo().Game);
    // End:0x28
    if(spGameInfo == none)
    {
        return none;
    }
    // End:0x4D
    if(spGameInfo.ActiveFoodManager != none)
    {
        return spGameInfo.ActiveFoodManager;
    }
    FoodManager = SPFoodManager(SPSpawn(Class'SPFoodManager'));
    // End:0x85
    if(FoodManager != none)
    {
        FoodManager.bKillDuringLevelTransition = true;
    }
    spGameInfo.ActiveFoodManager = FoodManager;
    return FoodManager;
    //return ReturnValue;    
}

function Tick(float ElapsedTime)
{
    UpdateFood(ElapsedTime);
    //return;    
}
