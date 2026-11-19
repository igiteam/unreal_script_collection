class SPDPhysSkel extends SPKAsset
    native;

var repnotify SPDestructibleProperties DCRepProperties;
var(DestructComponent) const editconst export editinline SPActorDestructComponent DestructComponent;
var export editinline DrawSphereComponent RenderComponent;
var export editinline DrawSphereComponent PreviewSphere;

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
    // End:0x130
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        // End:0x130
        if(DestructComponent != none)
        {
            spProperties = DestructComponent.GetProperties();
            // End:0x130
            if(spProperties != none)
            {
                // End:0x125
                if((int(Role) == int(ROLE_Authority)) && spProperties != none)
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
        }
    }
    SetTimer(0.0666670, false, 'SpawningComplete');
    //return;    
}

simulated function SpawningComplete()
{
    SkeletalMeshComponent.bForceMeshObjectUpdates = false;
    SkeletalMeshComponent.SpAnimLodScaleForVisible = 0.5000000;
    SkeletalMeshComponent.SpAnimLodScaleForInvisible = 0.3000000;
    SkeletalMeshComponent.bSpUpdateAnimTreeWhenNotRendered = 0;
    SkeletalMeshComponent.bUpdateSkelWhenNotRendered = false;
    SkeletalMeshComponent.bForceUpdateAttachmentsInTick = false;
    bAllowedToSuspendTickAndUpdateWhenHidden = true;
    //return;    
}

simulated function Destroyed()
{
    DestructComponent.ClientOnlyCauseDestruction();
    super(KAsset).Destroyed();
    //return;    
}

event Landed(Vector HitNormal, Actor FloorActor)
{
    TakeFallingDamage();
    //return;    
}

function TakeFallingDamage()
{
    local int Damage;

    Damage = DestructComponent.SpeedToDamage(Velocity.Z);
    // End:0x60
    if(Damage > 0)
    {
        TakeDamageAndProcEffects(float(Damage), none, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'Engine.DmgType_Fell');
    }
    //return;    
}
