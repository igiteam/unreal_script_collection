class AdvProjectile_Leuchpistol_Base extends EvilProjectile_Base
    abstract
    hidecategories(Navigation);

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    // End:0xCA
    if(EvilPawn(Other) != none)
    {
        EvilPawn(Other).DirectHitByProjectile();
        // End:0xCA
        if(ExplosionArchetype != none)
        {
            Other.TakeDamage(int(Damage), InstigatorController, Location, MomentumTransfer * Normal(Velocity), MyDamageType,, self);
            Explode(HitLocation, HitNormal);
            return;
        }
    }
    //return;    
}

defaultproperties
{
    TimeToExplode=4.0000000
    TossZ=25.0000000
    CustomGravityScaling=0.3000000
    Speed=1500.0000000
    MaxSpeed=3000.0000000
    MyDamageType=Class'AdvDmgType_Leuchpistol'
    // Reference: CylinderComponent'Default__AdvProjectile_Leuchpistol_Base.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Physics=EPhysics.PHYS_Falling
    bNetTemporary=false
    CollisionComponent=CollisionCylinder
}