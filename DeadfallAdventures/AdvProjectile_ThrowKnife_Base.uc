class AdvProjectile_ThrowKnife_Base extends EvilProjectile_Base
    abstract
    hidecategories(Navigation);

var transient bool bDirectHit;

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    local TraceHitInfo THitInfo;

    // End:0xBF
    if(EvilPawn(Other) != none)
    {
        EvilPawn(Other).Knockdown((MomentumTransfer / EvilPawn(Other).Mass) * Normal(Velocity), VRand() * float(4));
        EvilPawn(Other).DirectHitByProjectile();
        bDirectHit = true;
    }
    // End:0xF1
    if(DamageRadius > 0.0000000)
    {
        Explode(HitLocation, HitNormal);        
    }
    else
    {
        // End:0x1B1
        if(Damage > float(0))
        {
            Trace(HitLocation, HitNormal, HitLocation + Velocity, HitLocation, true, vect(0.0000000, 0.0000000, 0.0000000), THitInfo);
            Other.TakeDamage(int(Damage), InstigatorController, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType, THitInfo, self);
        }
        ShutDown();
    }
    //return;    
}

defaultproperties
{
    TossZ=50.0000000
    CustomGravityScaling=0.5000000
    Speed=2500.0000000
    MaxSpeed=3500.0000000
    MyDamageType=Class'AdvDmgType_ThrowKnife'
    // Reference: CylinderComponent'Default__AdvProjectile_ThrowKnife_Base.CollisionCylinder'
    begin object name=CollisionCylinder
        CollisionHeight=5.0000000
        CollisionRadius=5.0000000
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Physics=EPhysics.PHYS_Falling
    bNetTemporary=false
    LifeSpan=10.0000000
    CollisionComponent=CollisionCylinder
}