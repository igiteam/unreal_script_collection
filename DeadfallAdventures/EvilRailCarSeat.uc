class EvilRailCarSeat extends Keypoint
    native
    hidecategories(Navigation)
    classgroup(RailCars)
    implements(SpawnPointInterface);

var() deprecated name AnimName;
var EvilPawn Occupant;
var() bool bEnabled;

replication
{
    // Pos:0x000
    if((int(Role) == int(ROLE_Authority)) && bNetInitial || bNetDirty
        AnimName, Occupant;
}

simulated function PostBeginPlay()
{
    super(Actor).PostBeginPlay();
    // End:0x73
    if(EvilRailCar_Base(Base) == none)
    {
        FindBase();
        // End:0x60
        if(int(Role) == int(ROLE_Authority))
        {
            // End:0x5D
            if(EvilRailCar_Base(Base) == none)
            {
                Destroy();
                return;
            }            
        }
        else
        {
            SetTimer(1.0000000, false, 'TryFindingBase');
        }
    }
    //return;    
}

simulated function TryFindingBase()
{
    // End:0x4D
    if(EvilRailCar_Base(Base) == none)
    {
        FindBase();
        // End:0x4D
        if(EvilRailCar_Base(Base) == none)
        {
            SetTimer(1.0000000, false, 'TryFindingBase');
        }
    }
    //return;    
}

function EnableSpawn()
{
    bEnabled = true;
    //return;    
}

function DisableSpawn()
{
    bEnabled = false;
    //return;    
}

function bool IsSpawnEnabled()
{
    return bEnabled;
    //return ReturnValue;    
}

function ActivateSpawn()
{
    //return;    
}

function DeactivateSpawn(optional float Time = 0.0000000)
{
    //return;    
}

function bool IsSpawnActive()
{
    return true;
    //return ReturnValue;    
}

function bool DeactivateAfterEachSpawn()
{
    return false;
    //return ReturnValue;    
}

function bool CanSpawn()
{
    return Occupant == none;
    //return ReturnValue;    
}

function bool CanOnlySpawnWhenInvisible()
{
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    bEnabled=true
    RemoteRole=ENetRole.ROLE_SimulatedProxy
    bStatic=false
    bAlwaysRelevant=true
    bUpdateSimulatedPosition=true
}