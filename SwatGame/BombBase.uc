class BombBase extends RWOSupport.ReactiveStaticMesh
    implements  IAmUsedByToolkit,
                ICanBeSpawned,
                ICanBeDisabled,
                IUseArchetype
    config(SwatGame)
    abstract;

var config float TimeToQualify;
var bool bActive;

var private Name SpawnedFromName;

var Spawner Spawner;

replication
{
   reliable if ( Role == ROLE_Authority )
       bActive, SpawnedFromName;
}

simulated function PostNetBeginPlay()
{
    Super.PostNetBeginPlay();
    
    if( !bActive )
        ReactToTriggered( None );
}

// IAmUsedByToolkit implementation

// Return true iff this can be operated by a toolkit now
simulated function bool CanBeUsedByToolkitNow()
{
    return bActive;
}

// Called when qualifying begins.
simulated function OnUsingByToolkitBegan( Pawn User );

// Called when qualifying completes successfully.
simulated function OnUsedByToolkit(Pawn User)
{
    // If two players are qualifying on the bomb at the same time, only
    // deactivate it once.
    if ( bActive )
    {
        if ( Level.NetMode != NM_Client )
        {
            SwatGameInfo(Level.Game).GameEvents.BombDisabled.Triggered( self, User );
            SwatGameInfo(Level.Game).GameEvents.InanimateDisabled.Triggered(self, User);

            BroadcastReactToTriggered( User );

            bActive = false;
        }
    }
}

// Called when qualifying is interrupted.
simulated function OnUsingByToolkitInterrupted( Pawn User );


//return the time to qualify to use this with a Toolkit
simulated function float GetQualifyTimeForToolkit()
{
    return TimeToQualify;
}

// IUseArchetype implementation
function InitializeFromSpawner(Spawner inSpawner)
{
    Spawner = inSpawner;
    SpawnedFromName = Spawner.Name;
}

function Internal_InitializeFromArchetypeInstance(ArchetypeInstance Instance);  //TMC Implementers: FINAL, please
function InitializeFromArchetypeInstance();

//ICanBeSpawned implementation
function Spawner GetSpawner()
{
    return Spawner;
}

//ICanBeDisabled
simulated function bool IsActive()
{
    return bActive;
}

simulated function String UniqueID()
{
    return String(SpawnedFromName);
}

















// Decompiled with UE Explorer.
defaultproperties
{
    TimeToQualify=5.0000000
    bActive=true
    bNoDelete=false
    RemoteRole=1
    bUseCollisionBoneBoundingBox=true
}