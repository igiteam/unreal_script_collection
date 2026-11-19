class SPDRigidBody extends SPKActor
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
        super(KActor).ReplicatedEvent(VarName);
    }
    //return;    
}

simulated function PostBeginPlay()
{
    local SPDestructibleProperties spProperties;

    super(KActor).PostBeginPlay();
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
    //return;    
}

simulated function Destroyed()
{
    DestructComponent.ClientOnlyCauseDestruction();
    super(KActor).Destroyed();
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

event bool CanBeUsed(Pawn User)
{
    // End:0x5A
    if(User.IsA('PlayerPawn') && PandoraPlayerController(User.Controller) != none)
    {
        return PandoraPlayerController(User.Controller).AttemptPickup(self, true);
    }
    return false;
    //return ReturnValue;    
}

event bool UsedBy(Pawn User)
{
    // End:0x5A
    if(User.IsA('PlayerPawn') && PandoraPlayerController(User.Controller) != none)
    {
        return PandoraPlayerController(User.Controller).AttemptPickup(self, false);
    }
    return false;
    //return ReturnValue;    
}
