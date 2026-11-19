class SPDSkeletalMesh extends SkeletalMeshActor
    native;

var repnotify SPDestructibleProperties DCRepProperties;
var(DestructComponent) const editconst export editinline SPActorDestructComponent DestructComponent;
var export editinline DrawSphereComponent RenderComponent;
var export editinline DrawSphereComponent PreviewSphere;
var export editinline SPKynapseComponent KynapseComponent;
/** Set from the owner during initialization. */
var(Kynapse) bool bUseExpensivePathBlocking;

replication
{
    // Pos:0x000
    if(bNetInitial || bNetDirty
        DCRepProperties;
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x8C
    if(VarName == 'DCRepProperties')
    {
        DestructComponent.SetProperties(DCRepProperties);
        DestructComponent.MinCollisionVelocity = DCRepProperties.MinCollisionVelocity;
        DestructComponent.MaxCollisionVelocity = DCRepProperties.MaxCollisionVelocity;
        DestructComponent.HitPoints = DCRepProperties.HitPoints;        
    }
    else
    {
        super.ReplicatedEvent(VarName);
    }
    //return;    
}

simulated function PostBeginPlay()
{
    local SPDestructibleProperties spProperties;

    super.PostBeginPlay();
    // End:0x127
    if(DestructComponent != none)
    {
        spProperties = DestructComponent.GetProperties();
        // End:0x11C
        if(((int(WorldInfo.NetMode) != int(NM_Standalone)) && int(Role) == int(ROLE_Authority)) && spProperties != none)
        {
            // DebugMode: 0
            assert(DestructComponent.MinCollisionVelocity == spProperties.MinCollisionVelocity);
            // DebugMode: 0
            assert(DestructComponent.MaxCollisionVelocity == spProperties.MaxCollisionVelocity);
            // DebugMode: 0
            assert(DestructComponent.HitPoints == spProperties.HitPoints);
            // DebugMode: 0
            assert(DestructComponent.OnlyDestroyedByKismet == DestructComponent.default.OnlyDestroyedByKismet);
            // DebugMode: 0
            assert(DestructComponent.AutoTrigger == DestructComponent.default.AutoTrigger);
        }
        DCRepProperties = spProperties;
    }
    SkeletalMeshComponent.SetPhysicsWeight(1.0000000);
    // End:0x158
    if(bHidden == true)
    {
        SetHiddenFlag(bHidden);
    }
    //return;    
}

simulated function Destroyed()
{
    DestructComponent.ClientOnlyCauseDestruction();
    super.Destroyed();
    //return;    
}
