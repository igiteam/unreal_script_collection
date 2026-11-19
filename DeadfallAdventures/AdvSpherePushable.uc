class AdvSpherePushable extends KActor
    classgroup(Adventurer);

var() AdvDamageVolume DamageVolume;
var bool bDamageEnabled;

function Tick(float DeltaTime)
{
    // End:0xBF
    if(DamageVolume != none)
    {
        // End:0x87
        if(bIsMoving)
        {
            // End:0x56
            if(!bDamageEnabled)
            {
                bDamageEnabled = true;
                DamageVolume.EnableDamage();
            }
            DamageVolume.SetLocation(Location + Normal(Velocity));            
        }
        else
        {
            // End:0xBF
            if(bDamageEnabled)
            {
                bDamageEnabled = false;
                DamageVolume.DisableDamage();
            }
        }
    }
    //return;    
}

event Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
{
    local Vector HitLocation;

    // End:0xAF
    if(Pawn(Other).Controller.IsLocalPlayerController())
    {
        HitLocation = Other.Location;
        ApplyImpulse(HitNormal * float(-1), VSize(Other.Velocity), HitLocation);
    }
    super(Actor).Bump(Other, OtherComp, HitNormal);
    //return;    
}

defaultproperties
{
    bWakeOnLevelStart=true
    // Reference: StaticMeshComponent'Default__AdvSpherePushable.StaticMeshComponent0'
    begin object name=StaticMeshComponent0
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvSpherePushable.MyLightEnvironment'
        AlwaysCheckCollision=true
        bNotifyRigidBodyCollision=true
        ScriptRigidBodyCollisionThreshold=0.0010000
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__AdvSpherePushable.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=MyLightEnvironment
    Components[1]=StaticMeshComponent0
    BlockRigidBody=true
    bCollideWorld=true
    bCollideAsEncroacher=true
    CollisionComponent=StaticMeshComponent0
}