class SkyLimitedUseInteractor extends SkyGameInteractor
    native;

var() int MaxUses;
var() TechPointsInventory TechPointsInventoryArchetype;
var() Vector TechPointsOffset;
var transient int RemainingUses;
var transient array<string> CheckpointMaterials;
var transient array<MaterialInterface> CachedCheckpointMaterials;

simulated function OnSetPhysics(SeqAct_SetPhysics Action)
{
    // End:0x38
    if((int(Action.newPhysics) == int(10)) && SkeletalMeshComponent != none)
    {
        SkeletalMeshComponent.WakeRigidBody();
    }
    super(Actor).OnSetPhysics(Action);
    //return;    
}

function PostBeginPlay()
{
    RemainingUses = MaxUses;
    super(Actor).PostBeginPlay();
    //return;    
}

event SpawnTechPoints()
{
    local TechPointsInventory TPI;
    local Vector FinalLocation;

    // End:0x6F
    if(TechPointsInventoryArchetype != none)
    {
        FinalLocation = Location + TechPointsOffset;
        TPI = Spawn(TechPointsInventoryArchetype.Class, self,, FinalLocation,, TechPointsInventoryArchetype);
        // End:0x6F
        if(TPI != none)
        {
            TPI.DropFrom(FinalLocation, Velocity);
        }
    }
    //return;    
}
