class EvilProjectile_Bullet extends EvilProjectile_Base
    hidecategories(Navigation);

simulated function bool ShouldSpawnExplosionLight(Vector HitLocation, Vector HitNormal)
{
    return false;
    //return ReturnValue;    
}

event Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
{
    super(Actor).Bump(Other, OtherComp, HitNormal);
    // End:0xC7
    if((Pawn(Other) != none) && Pawn(Other).IsPlayerPawn())
    {
        Other.TakeDamage(int(Damage), InstigatorController, Location, MomentumTransfer * Normal(Velocity), MyDamageType,, self);
    }
    Destroy();
    //return;    
}

defaultproperties
{
    bWaitForEffects=true
    bAttachExplosionToVehicles=false
    DecalWidth=32.0000000
    DecalHeight=32.0000000
    CheckRadius=42.0000000
    Speed=1350.0000000
    MaxSpeed=1350.0000000
    Damage=10.0000000
    DamageRadius=10.0000000
    MomentumTransfer=100.0000000
    MyDamageType=Class'EvilDmgType_Bullet'
    // Reference: CylinderComponent'Default__EvilProjectile_Bullet.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__EvilProjectile_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
        CollisionHeight=20.0000000
        CollisionRadius=20.0000000
        ReplacementPrimitive=none
        CollideActors=true
        AlwaysCheckCollision=true
        BlockRigidBody=true
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    bBlockActors=true
    LifeSpan=8.0000000
    CollisionComponent=CollisionCylinder
    RotationRate=(Pitch=0,Yaw=0,Roll=50000)
}