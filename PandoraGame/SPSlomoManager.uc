class SPSlomoManager extends Actor
    native
    notplaceable;

struct native AnimNotifyInfo
{
    var SPAnimNodeSequence Anim;
    var float initRate;
    var float destRate;
    var float currTime;
    var float RampTime;

    structdefaultproperties
    {
        Anim=none
        initRate=0.0000000
        destRate=0.0000000
        currTime=0.0000000
        RampTime=0.0000000
    }
};

var private transient array<AnimNotifyInfo> AnimNotifyArray;

// Export USPSlomoManager::execGetWorldInfo(FFrame&, void* const)
native static final function WorldInfo GetWorldInfo();

// Export USPSlomoManager::execGetSloMoManager(FFrame&, void* const)
native static function SPSlomoManager GetSloMoManager();

// Export USPSlomoManager::execSPSpawn(FFrame&, void* const)
native static final function Actor SPSpawn(class<Actor> SpawnClass, optional Actor SpawnOwner, optional name SpawnTag, optional Vector SpawnLocation, optional Rotator SpawnRotation, optional Actor Template);

// Export USPSlomoManager::execUpdateSlomo(FFrame&, void* const)
private native final function UpdateSlomo(float ElapsedTime);

// Export USPSlomoManager::execClearNotifyArray(FFrame&, void* const)
native final function ClearNotifyArray();

function Tick(float ElapsedTime)
{
    UpdateSlomo(ElapsedTime);
    //return;    
}
