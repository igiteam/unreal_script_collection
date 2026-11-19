class StaticDOA extends Engine.StaticMeshActor
    implements  IAmReportableCharacter,
                IUseArchetype
    config(SwatGame);

var private bool HasBeenReported;
var private Name SpawnedFromName;

///////////////////////////////////////////////////////////////////////////////

replication
{
    reliable if ( Role == ROLE_Authority )
        SpawnedFromName, HasBeenReported;
}


///////////////////////////////////////////////////////////////////////////////

//ICanBeUsed implementation (IAmReportableCharacter extends ICanBeUsed)

simulated function bool CanBeUsedNow()
{
    return (!HasBeenReported);
}

simulated function OnUsed(Pawn Other)
{
    AssertWithDescription(!HasBeenReported,
        "[tcohen] StaticDOA::OnUsed() but this DOA has already been reported.");

    SwatGameInfo(Level.Game).GameEvents.ReportableReportedToTOC.Triggered(self, Other);
}

simulated function PostUsed()
{
    HasBeenReported = true;
}

simulated function String UniqueID()
{
    return String(SpawnedFromName);
}

//IAmReportableCharacter implementation

simulated function name GetEffectEventForReportingToTOC()
{
    return 'ReportedDOA';
}

simulated function name GetEffectEventForReportResponseFromTOC()
{
    return 'RepliedDOAReported';
}

//IUseArchetype implementation

function InitializeFromSpawner(Spawner Spawner)
{
    SpawnedFromName = Spawner.Name;
}

function Internal_InitializeFromArchetypeInstance(ArchetypeInstance Instance);
function InitializeFromArchetypeInstance();

/////////////////////////////////////////////////////////////












// Decompiled with UE Explorer.
defaultproperties
{
    bStatic=false
    bStasis=true
    CollisionRadius=30.0000000
    CollisionHeight=20.0000000
    bUseCylinderCollision=true
}