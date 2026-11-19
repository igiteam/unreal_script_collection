class AdvPhysicsTriggerBoxDestroyable extends AdvPhysicsTriggerBox;

var private int Health;

event TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    Health -= Damage;
    // End:0x2F
    if(Health <= 0)
    {
        DestroyObject();
    }
    //return;    
}

function DestroyObject()
{
    self.Reset();
    Health = 100;
    //return;    
}

defaultproperties
{
    Health=100
    // Reference: StaticMeshComponent'Default__AdvPhysicsTriggerBoxDestroyable.StaticMeshComponent'
    begin object name=StaticMeshComponent
        ReplacementPrimitive=none
        AlwaysCheckCollision=true
        bNotifyRigidBodyCollision=true
        ScriptRigidBodyCollisionThreshold=0.0010000
    end object
    StaticMeshComponent=StaticMeshComponent
    // Reference: DynamicLightEnvironmentComponent'Default__AdvPhysicsTriggerBoxDestroyable.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=MyLightEnvironment
    // Reference: StaticMeshComponent'Default__AdvPhysicsTriggerBoxDestroyable.StaticMeshComponent0'
    begin object name=StaticMeshComponent0
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvPhysicsTriggerBoxDestroyable.MyLightEnvironment'
    end object
    Components[1]=StaticMeshComponent0
    Components[2]=StaticMeshComponent
    BlockRigidBody=true
    bCollideWorld=true
    bNoEncroachCheck=true
    bCollideAsEncroacher=true
    CollisionComponent=StaticMeshComponent
}